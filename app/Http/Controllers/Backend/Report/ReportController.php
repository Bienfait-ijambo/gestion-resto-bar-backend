<?php

namespace App\Http\Controllers\Backend\Report;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Product,Orders,SelectedProduct,CashHistory,Balance,Commande};
use App\Modals\Agent;
use App\Modals\Users;
use App\Traits\GlMethod;
use App\Http\Controllers\Backend\Report\Traits\ReportHelper;
use App\Http\Controllers\Backend\Settings\Traits\SettingHelper;
use App\Http\Controllers\Backend\Report\Pdf\{MakeCashDeskPdf,MakePurchaseOrder,SupplyReport,MakeDebtReport,MakeCustomerReport};
use App\Exports\CashDesk\CashDeskExport;
use Maatwebsite\Excel\Facades\Excel;
use DB;
use PDF;
use url;

class ReportController extends Controller
{
    
    use GlMethod,ReportHelper,SettingHelper;

    function printBill(Request $request)
    {
      if ($request->get('order_id')) 
      {
        $order_id = $request->get('order_id');
        $g = $this->globalInput($request);

        $settings=$this->getSettingInfo($g);

        $pic=$this->displayImg('logo.png');
        $select_items= $this->getOrderProducts($order_id,$g);

         $output='';

         $output.='<div style="margin-top:-20px;">';
         $output.=' <div><img src="'.$pic.'" width="65" style="float:right;" /></div>';
         $output.='<span style="font-size:20px;text-align:center;"> <b>'.$settings->name.' </b></span><br/>';
         $output.='<span>Email : <a href="#">'.$settings->email.' </a><br/>Tel: '.$settings->telephone.' </span><br/>';
  
          $output.='</div><br/>'; 

          $output.='<span><b>FACTURE N°..0 '.$order_id.'</b></span><br/>';

          $output.='Mr /Mme/: '.$this->customerName($order_id,$g).'-'.$order_id.' <br/>';
          $output.='<table  cellpadding="2" cellspacing="0" border="1" width="250">
                   <tr style="font-weight:bold;">
                     <td >Article</td>
                     <td>Qté</td>
                     <td>P.U</td>
                   <td>P.T</td>
              </tr>';

        $total_=0;

        foreach ($select_items as $row) 
        {
          $total_+=floatval($row->product_qty) * floatval($row->product_price);
          $output.='
           <tr>
                 <td>'.$this->getProductName($row->product_id,$g).'</td> 
                 <td>'.$row->product_qty.'</td>
                 <td>'.$row->product_price.'</td>
                 <td>'.$this->formatNumber((floatval($row->product_qty) * floatval($row->product_price))).'</td>
            </tr>';
        }
         $output.=' <tr style="font-weight:bold;">
                 <td colspan="3">TOTAL GENERAL EN USD</td>
                 <td>'.$this->formatNumber($total_).'</td>
             </tr>';

       $output.='</table>';

       $orderRow=$this->getOrderCommentAndClientId($order_id);

        if (!is_null($orderRow)) {

             $comment = $orderRow->comment;
         
             if ($comment != '') 
             {
                 $output.='
                  <table cellpadding="2" cellspacing="0" border="1" width="250">
                       <tr style="background-color:grey;">
                         <td >Commentaire</td>
                      </tr>
                       <tr>
                         <td>'.$comment.'</td>
                       </tr>
                  </table>';
             }
             
          }
          
          $totalPaidAmount =  $this->customerTotalAmount($orderRow->client_id,$g);
          $gainPercent = floatval($settings->customer_gain);
          
          
          $output.='
            <table cellpadding="2" cellspacing="0" border="1" width="250">
                 <tr>
                   <td>NB: Votre compte bonus vient d atteindre '.(($gainPercent * floatval($totalPaidAmount))).' USD  utilisables pour payer vos prochains achats chez nous.</td>
                 </tr>
            </table>';
          

        $output.='<span >Fait à Goma, le '.date('d/m/Y H:i:s').'</span>';
        $output.='<p align="right">Signature</p>';
        $output.='</div>';
        //end wrapper


         $pdf = \App::make('dompdf.wrapper')
        ->loadHTML($output)->setPaper('a6','portrait');
          return $pdf->stream();
        }
        
      }


       function printCashReport(Request $request)
      {
         $g = $this->globalInput($request);

         $currency = $request->get('currency');

         $currentDate = $request->get('current_date');

         $transactionType = $request->get('transaction_type');

         $startDate = $request->get('start_date');

         $endDate=$request->get('end_date');

         $generate=$request->get('generate');


         $reportTitleInfo=array(
            'startDate'  =>$startDate,
            'endDate'    =>$endDate,
            'currentDate'=>$currentDate,
            'currency'   =>$currency
        );


         if ($generate == 'excel') 
         {
             return $this->generateExcel($reportTitleInfo,$transactionType,$g);
         }
         else
         {

          return $this->toDayCashReport($reportTitleInfo,intval($transactionType),$g);
          
         }
      
      }


    function printPurchaseOrder(Request $request)
    {
         $g = $this->globalInput($request);

         $orderId = $request->get('order_id');

         $logo=$this->displayImg('logo.png');

         $reportHeader=$this->getSettingInfo($g);

         $pdf=new MakePurchaseOrder($orderId,$logo,$reportHeader,$g);

         return $pdf->generate();
    }



    function toDayCashReport($reportTitleInfo,$transactionType,$g)
    {
       
        $settings=$this->getSettingInfo($g);
  
        $data=$this->processReportQuery($reportTitleInfo,$transactionType,$g);

        $logo = $this->displayImg('logo.png');
        
        $pdf = new MakeCashDeskPdf($settings,$logo,$data, $reportTitleInfo,$transactionType,$g);

        return $pdf->generate();

      
    }






      function generateExcel($reportTitleInfo,$transactionType,$g)
      {
         $excelFile=new CashDeskExport($reportTitleInfo,$transactionType,$g);
         return Excel::download($excelFile, 'rapport.xlsx');

      }



    function generateSupplyReport(Request $request)
    {
        
         $productId = $request->get('product_id');
         $startDate = $request->get('startDate');
         $endDate = $request->get('endDate');
         $g = $this->globalInput($request);

         $setting=$this->getSettingInfo($g);
         $logo = $this->displayImg('logo.png');

         $pdf=new SupplyReport($productId,$logo,$setting,[$startDate,$endDate],$g);
         return $pdf->generate();
        
    }



    function generateDebtReport(Request $request)
    {
        
        $g = $this->globalInput($request);
        $logo = $this->displayImg('logo.png');

        $pdf = new MakeDebtReport($logo,$request->currency,$g);
        return $pdf->generate();
        
    }


    function generateCustomerlist(Request $request)
    {
        
        $g = $this->globalInput($request);
        $logo = $this->displayImg('logo.png');

        $pdf = new MakeCustomerReport($logo,$request->limit,$request->offset,$g);
        return $pdf->generate();
        
    }





}

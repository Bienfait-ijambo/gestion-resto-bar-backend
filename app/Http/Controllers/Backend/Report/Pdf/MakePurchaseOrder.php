<?php
namespace App\Http\Controllers\Backend\Report\Pdf;

use App\Http\Controllers\Backend\Report\Repo\ReportRepo;
use App\Traits\GlMethod;

class MakePurchaseOrder 
{

	use GlMethod,ReportRepo;

	
	private $logo;

	private $reportHeader;

	private $orderId;

	private $g; //global input


	public function __construct($orderId,$logo,$reportHeader,$g)
	{
    $this->orderId=$orderId;

		$this->logo=$logo;

		$this->reportHeader=$reportHeader;

    $this->g=$g;
	}


  private function getCustomerName()
  {
    $customer=$this->returnCustomerName($this->orderId,$this->g);
    return $customer->client_name;
  }


	public function generate()
	{
	

        $settings = $this->reportHeader;


        $select_items=  $this->getProductAddedToOder($this->orderId,$this->g);

         $output='';
         $output.='<div style="margin-top:-20px;">';

         $output.=' <div><img src="'.$this->logo.'" width="65" style="float:right;" /></div>';
         $output.='<span style="font-size:20px;text-align:center;"> <b>'.$settings->name.' </b></span><br/>';
    
         $output.='<span>Email : <a href="#">'.$settings->email.' </a><br/>Tel: '.$settings->telephone.' </span><br/>';

    
          $output.='</div>'; 

          $output.='<h4>BON N°..0 '.$this->orderId.'</h4>';

          $output.='Mr /Mme/: '.$this->getCustomerName().'-'.$this->orderId.' <br/>';
          $output.='<table  cellpadding="2" cellspacing="0" border="1" width="250">
                   <tr style="font-weight:bold;">
                     <td >Article</td>
                     <td>Qté</td>
                     <td>P.U</td>
                   <td>P.T</td>

              </tr>';
        foreach ($select_items as $row) 
        {
         
          $output.='
           <tr>
               <td>'.$this->getProductName($row->product_id,$this->g).'</td> 
               <td>'.$row->product_qty.'</td>
               <td></td>
               <td></td>
            </tr>';
        }
  
        $output.='</table>';
        $output.='<span >Fait à Goma, le '.date('d/m/Y H:i:s').'</span>';
        $output.='<p align="right">Signature</p>';
        $output.='</div>';
        //end wrapper

         $pdf = \App::make('dompdf.wrapper')->loadHTML($output)->setPaper('a6', 'portrait');

         return $pdf->stream();
        

	}






}
<?php
namespace App\Http\Controllers\Backend\Report\Pdf;

use App\Http\Controllers\Backend\Report\Repo\ReportRepo;
use App\Http\Controllers\Backend\Report\Pdf\concerns\ReportHeader;
use App\Traits\GlMethod;
use PDF;

class SupplyReport  extends ReportHeader
{

	use GlMethod,ReportRepo;

	
	private $logo;

	private $setting;

	private $productId;

  private $g;

  private $dates=[];

	public function __construct($productId,$logo,$setting,$dates,$g)
	{
    $this->productId=$productId;

		$this->logo=$logo;

    $this->setting=$setting;

    $this->dates=$dates;

    $this->g=$g;
	}





	public function generate()
	{
	
        $data = $this->getStockHistory($this->dates,$this->productId,$this->g);

        $output='';

        $output.=$this->makeReportHeader($this->logo,$this->setting);
      

        $output.='<span style="font-size:20px;font-weight:bold;">Rapport d\'achat : '.$this->getProductName($this->productId,$this->g).'</b></span><br/><br/>';

     
        $output.='  Date : '.$this->f_date($this->dates[0]).'  --- '.$this->f_date($this->dates[1]).'';
        $output.='<table align="center" cellpadding="5" cellspacing="0" border="1" width="520" >
            
            <tr style="font-weight:bold;">
                   <td>N°</td>
                   <td>FOURNISSEUR</td>
                   <td>QTE</td>
                   <td>P.U</td>
                   <td>P.T en USD</td>
                   <td>Date</td>
            </tr>
               ';

        $count=1;
        $total_qty=0;
        $total_p=0;
         foreach ($data as $row) 
         {
            $total_qty+=floatval($row->product_qty);
            $total_p+=(floatval($row->product_qty) * floatval($row->product_price));

             $output.='
             <tr>
                   <td>'.$count++.'</td>
                   <td>'.$row->provider_name.'</td>
                   <td>'.$this->formatNumber($row->product_qty).'</td>
                   <td>'.$row->product_price.'</td>
                 <td>'.(floatval($row->product_qty) * floatval($row->product_price)).'</td>
                 <td>'.$this->f_date($row->created_at).'</td>
               </tr>';
         }

         $output.=' <tr style="font-weight:bold;">
                   <td colspan="2">Total</td>
                   <td>'.$this->formatNumber($total_qty).'</td>
                   <td></td>
                   <td>'.$this->formatNumber($total_p).' </td>
                   <td></td>
               </tr>';
         $output.='</table>';
         
          $pdf = \App::make('dompdf.wrapper')
          ->loadHTML($output)->setPaper('a4', 'portrait');
         return $pdf->stream();
        
	  }






}
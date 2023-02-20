<?php
namespace App\Http\Controllers\Backend\Report\Pdf;

use App\Http\Controllers\Backend\Report\Repo\ReportRepo;
use App\Http\Controllers\Backend\Settings\Repo\SettingRepo;
use App\Http\Controllers\Backend\Debt\Repo\DebtRepo;
use App\Http\Controllers\Backend\Report\Pdf\concerns\ReportHeader;
use App\Traits\GlMethod;
use App\Modals\Backend\{Balance};

class MakeDebtReport extends ReportHeader
{

	use GlMethod,ReportRepo,SettingRepo,DebtRepo;

	
	private $logo;

	private $setting;

	private $g; //global input

  private $currency;


	public function __construct($logo,$currency,$g)
	{
		$this->logo=$logo;

		$this->setting=$this->returnSettingInfo($g);

    $this->currency=$this->getCurrency($currency);

    $this->g=$g;
	}



	public function generate()
	{
	
        $data = $this->getCustomerDebts($this->g);

        $output='';

        $output.=$this->makeReportHeader($this->logo,$this->setting);
     
        $output.='<span style="font-size:20px;font-weight:bold;">Rapport de dettes</b></span><br/>';


        $output.='<table align="center" cellpadding="5" cellspacing="0" border="1" width="520" >
            
            <tr style="font-weight:bold;">
                <td>N°</td>
                <td>CLIENT</td>
                <td>TELEPHONE</td>
                <td>TOTAL</td>
            </tr>
               ';

        $count=1;
        $total=0;
      
         foreach ($data->get() as $row) 
         {

          $total+=floatval($row->total_amount);

             $output.='
                <tr>
                   <td>'.$count++.'</td>
                   <td>'.$row->name.'</td>
                   <td>'.$row->telephone.'</td>
                   <td>'.$row->total_amount.'</td>
               </tr>';
         }

         $output.=' <tr style="font-weight:bold;">
                   <td colspan="3">Total</td>
                   <td>'.$total.' '.$this->currency.'</td>
               </tr>';
         $output.='</table>';
         
          $pdf = \App::make('dompdf.wrapper')
          ->loadHTML($output)->setPaper('a4', 'portrait');
         return $pdf->stream();
        
	  }




}
<?php
namespace App\Http\Controllers\Backend\Report\Pdf;

use App\Http\Controllers\Backend\Report\Repo\ReportRepo;
use App\Http\Controllers\Backend\Report\Pdf\concerns\ReportHeader;
use App\Http\Controllers\Backend\Settings\Repo\SettingRepo;
use App\Traits\GlMethod;
use PDF;

class MakeCustomerReport  extends ReportHeader
{

	use GlMethod,SettingRepo,ReportRepo;

	
	private $logo;

	private $limit;

	private $offset;

	private $setting;

	private $g;

	

	public function __construct($logo,$limit,$offset,$g)
	{
        
		$this->logo=$logo;

		$this->limit=$limit;

		$this->setting=$this->returnSettingInfo($g);

		$this->offset=$offset;

        $this->g=$g;
	}

	private function paginationTitle()
	{

		return ''.$this->offset.' - '.(intval($this->limit)+intval($this->offset)).'';
	}



	public function generate()
	{
	
        $data =  $this->getCustomers($this->limit,$this->offset,$this->g);

        $output='';
 
        $output.=$this->makeReportHeader($this->logo,$this->setting);

        $output.='<span style="font-size:20px;font-weight:bold;">LISTE DES CLIENTS DE '.$this->paginationTitle().' </span><br/><br/>';

        $output.='<table align="center" cellpadding="5" cellspacing="0" border="1" width="520" >
            
            <tr style="font-weight:bold;background-color:#ccc;">
                   <td>N°</td>
                   <td>NOM</td>
                   <td>EMAIL</td>
                   <td>TELEPHONE</td>
            </tr>
               ';

        $count=1;

         foreach ($data as $row) 
         {
          
             $output.='
             <tr>
                   <td>'.$count++.'</td>
                   <td>'.$row->name.'</td>
                   <td>'.$row->email.'</td>
                   <td>'.$row->telephone.'</td>
               </tr>';
         }

  
         $output.='</table>';
         
          $pdf = \App::make('dompdf.wrapper')
          ->loadHTML($output)->setPaper('a4', 'portrait');
         return $pdf->stream();
        
	  }






}
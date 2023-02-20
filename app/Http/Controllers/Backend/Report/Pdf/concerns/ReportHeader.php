<?php
namespace App\Http\Controllers\Backend\Report\Pdf\concerns;
use App\Modals\Backend\{Balance};
/**
* 
*/
class ReportHeader 
{
	

	protected  function makeReportHeader($logo,$data)
	{
		$output='';
     
        $output.='<div align="center"> 
        <img src="'.$logo.'"  width="75" style="margin-top:-45px;" /><br/>';

        $output.='<span style="font-size:20px;"> <b>'.$data->name.'</b></span><br/>';
        $output.='<span>Email : <a href="#">'.$data->email.'</a><br/> Tel : '.$data->telephone.'</span><br/><br/></div>';

        return $output;

	}


  protected function getCurrency($currency)
  {
    $balance = new Balance();
    return  $balance->getCurrencyName($currency);
  }

  

}
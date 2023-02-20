<?php 


namespace App\Http\Controllers\Backend\Settings\Repo;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Modals\Backend\{Setting};
use DateTime;
use DB;
use Validator;
use Image;

trait SettingRepo{



    function returnSettingInfo($g)
    {
      // where('current_shop',$g['shop'])
    	$data = Setting::where('host_customer_id',$g['host'])
              ->orderBy('id','desc')
              ->limit(1)
              ->first(); 
      return $data;

    }

    

}
<?php 


namespace App\Http\Controllers\Backend\Settings\Traits;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Http\Controllers\Backend\Settings\Repo\SettingRepo;
use App\Modals\Backend\{Setting};
use App\Traits\GlMethod;
use DateTime;
use DB;
use Validator;
use Image;

trait SettingHelper{

	use GlMethod,SettingRepo;



    function getSettingInfo($g)
    {
    	$data = $this->returnSettingInfo($g);
      return !is_null($data) ? $data : ['data'=>404];

    }

    

}
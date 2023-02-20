<?php

namespace App\Http\Controllers\Backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Category,Product,Shop};
use App\Traits\GlMethod;
use Validator;
use DB;
class HasShopController extends Controller
{
    use GlMethod;

    function index()
    {
    	$data = Shop::all();
    	return response(['data'=>$data],200);
    }
}

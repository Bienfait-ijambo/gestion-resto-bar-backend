<?php

namespace App\Http\Controllers\Backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Product,Stock,Price};
use App\Traits\GlMethod;
use Validator;
use Image;
use DB;
class SalesController extends Controller
{
    use GlMethod;

    function index(Request $request)
    {
    	$g = $this->globalInput($request);

        $query=$request->get('query');
        $trimQuery=str_replace(" ", "%", $query);


        $data = Product::with(['prices','stock'])
        ->where('products.current_shop',$g['shop'])
        ->where('products.host_customer_id',$g['host'])
        ->select('products.id','products.name');

        if ($query != '') 
        {
            $data->where('products.name','like','%'.$trimQuery.'%')
            ->orderBy('products.name','desc');

            return $this->apiData($data->paginate(10));
        }
            return $this->apiData($data->paginate(10));

    }


}

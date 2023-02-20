<?php

namespace App\Http\Controllers\Backend\Supply;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Product,Stock,Price,SupplyStock};
use App\Http\Controllers\Backend\Supply\Repo\SupplyRepo;
use App\Traits\GlMethod;
use Validator;
use Image;
use DB;
use PDF;


class SupplyController extends Controller
{
    use GlMethod,SupplyRepo;

    function store(Request $request)
    {
    	return DB::transaction(function() use ($request){

          $g = $this->globalInput($request);

          $totalPrice = (floatval($request->product_price) * floatval($request->product_qty));

		   $data=array(
		    	'product_id'	        => $request->product_id,
		    	'provider_name'	        => $request->provider_name,
		    	'provider_telephone'	=> $request->provider_telephone,
		    	'product_price'	        => $request->product_price,
		    	'product_qty'	        => $request->product_qty,
		    	'total_price'	        => $this->aroundNumber($totalPrice),
                'comment'  		        => $request->comment,
                'current_shop'          => $g['shop'],
                'host_customer_id'      => $g['host']
		    );

		    //check
		    $productQty = $this->getProductQty($request->product_id,$g['shop'],$g['host']);

		     if (!is_null($productQty)) 
		     {
		     	$this->addAndUpdateQty($data['product_id'],$productQty->stock,$data['product_qty'],$g['shop'],$g['host']);
		     	SupplyStock::create($data);

	            return response([
	                'message'   =>"L'approvisionnement s'est effectuée avec succès"
	       		],200);
		     }
		    
		  
    	});

    	
    }


    function stockHistory(Request $request)
    {
    	$g = $this->globalInput($request);

    	$data = $this->getStockHistory($request->product_id,$g);

        $stock=$this->getAvailableStock($request->product_id,$g);

     	return response(['availableStock'=>$stock,'data'=>$data],200);	
    }



    
}

<?php

namespace App\Http\Controllers\Backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Category,Product,OutProductQty};
use App\Traits\GlMethod;
use Validator;
use DB;
class OutProductQtyController extends Controller
{
    use GlMethod;


    function index(Request $request)
    {
    	$g = $this->globalInput($request);
     
        $data =DB::table('out_product_qties as op')
        ->join('products','op.product_id','=','products.id')
        ->select('products.name as product_name','op.product_qty','op.id','op.comment','op.created_at')
        ->where('op.status',0)
        ->where('op.current_shop',$g['shop'])
        ->where('op.host_customer_id',$g['host']);


        return $this->apiData($data->paginate(10));
    }

    


    function store(Request $request)
    {
    	return DB::transaction(function() use($request){

        	$g = $this->globalInput($request);
        	$productId = $request->product_id;
        	$outQty = $request->product_qty;
        
        	 $reduceQty = $this->reduceQty($productId,$outQty,$g['shop'],$g['host']);

           if ($reduceQty == false) 
              return response(['message'  => 'Désolez, vous ne disposez pas de cette quantité !'],422);
        
          	  $this->createOutProductQty([
    		    	'product_id'  => $productId,
    		        'product_qty' => $outQty,
    		    	'comment'     => $request->comment,
                    'status'      => 0,
    		    	'current_shop'=> $g['shop'],
    		    	'host_customer_id'=> $g['host']
    		   ]);
    		     
    		  return response(['message' => "Sortie enregisté avec succès !!"],200);
     
    	});
    	         
    }


    function createOutProductQty($data)
    {
    	OutProductQty::create($data);
    }


  
}

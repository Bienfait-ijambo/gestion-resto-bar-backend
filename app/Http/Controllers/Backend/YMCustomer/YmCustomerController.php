<?php

namespace App\Http\Controllers\Backend\YMCustomer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use App\Modals\Backend\{Product,Stock,Price,Category,YmCustomer,Balance,AttribShop,PriceSetting};
use App\Traits\GlMethod;
use DB;
class YmCustomerController extends Controller
{
    use GlMethod;

    function index(Request $request)
    {
    	$data=YmCustomer::all();
    	return response(['data'=>$data],200);
    }

    function getCustomerShops(Request $request)
    {
        $g = $this->globalInput($request);
        $userId=$request->get('user_id');
        //continue here
        $data = DB::table('attrib_shops')
        ->join('ym_customers','attrib_shops.user_id','=','ym_customers.id')
        ->join('shops','attrib_shops.shop_id','shops.id')
        ->select('attrib_shops.id','shops.name as shopName','shops.id as shopId','ym_customers.name as customerName');

        if ($userId > 0) {
        	$data->where('attrib_shops.user_id',$userId);
        	return $this->apiData($data->paginate(10));
        }
       
        return $this->apiData($data->paginate(10));
    }

    function getShopsAttribToUser(Request $request)
    {

        $g = $this->globalInput($request);

        $data = DB::table('attrib_shops')
        ->join('ym_customers','attrib_shops.user_id','=','ym_customers.id')
        ->join('shops','attrib_shops.shop_id','shops.id')
        ->select('attrib_shops.shop_id','shops.name')
        ->where('attrib_shops.user_id',$g['host'])
        ->get();

        return response(['data'=>$data],200);


    }

    function createUserShop(Request $request)
    {
	      $data=$request->all();

	     $shopAlreadyAttrib= AttribShop::where('user_id',$data['user_id'])
	      ->where('shop_id',$data['shop_id'])
	      ->first();

	      if (is_null($shopAlreadyAttrib)) {

	      	  AttribShop::create($data);

	    	  return response([
		        'message'   =>'Shop crée avec succès !'
		      ],200);
	      }else{
	      	 return response([
		        'message'   =>'Vous avez déjà attribué ce shop à ce client !'
		      ],422);
	      }

   
    }


    function selectOrChangeShop(Request $request)
    {
        $g = $this->globalInput($request);
        $currentShop=$request->current_shop;

        User::where('id',$request->user_id)
        ->update([
            'current_shop'=>$currentShop
        ]);
        return response([
            'message'    =>'Traitement en cours...',
            'currentShop'=>$currentShop
        ],200);

    }




    public function store(Request $request)
    {
      return DB::transaction(function() use ($request){

	       $g = $this->globalInput($request);
	       $data = $request->all();
           
	       unset($data['current_shop'],$data['host_customer_id']);
	       $customer = YmCustomer::insert($data);

	       return response([
	        'data'      =>$customer,
	        'message'   =>'Félicitation, Enregistrement réussi.'
	       ],200);

      });  
       
    }


  

    
}

<?php

namespace App\Http\Controllers\Backend\Settings;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Category,Product,PriceSetting,Setting,AttribShop,Balance};
use App\Http\Controllers\Backend\Settings\Traits\SettingHelper;
use App\Traits\GlMethod;
use Validator;
use DB;
class SettingController extends Controller
{
   use GlMethod,SettingHelper;


   function index(Request $request)
   {
   	
   	 $g = $this->globalInput($request);

     	$data =PriceSetting::where('current_shop',$g['shop'])
              ->where('host_customer_id',$g['host'])
              ->get();
              
     	return response(['data'=>$data],200);
   }

    function settingInfo(Request $request)
   {
       $g = $this->globalInput($request);

       $setting=$this->getSettingInfo($g);

       $userHasPrices=$this->doesUserHasPrices($g);

      return response([
        'data'         => [$setting],
        'userHasPrices'=> $userHasPrices
    ],200);
   }

    function doesUserHasPrices($g)
    {
        $price = PriceSetting::where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
        ->first();

        return (!is_null($price)) ? true : false;

    }

   function store(Request $request)
   {
     $g = $this->globalInput($request);
      Setting::create([
        'name'          => $request->name,
        'email'         => $request->email,
        'telephone'     => $request->telephone,
        'customer_gain' => $request->customer_gain,
        'vat'           => $request->vat,
        'rate'          => $request->rate,
        'current_shop'      => $g['shop'],
        'host_customer_id'  => $g['host'],
      ]);

      return response([
          'message'   =>'Félicition , enregistrement réussi !!'
         ],201);
   }


    public function edit($id)
    {
         if (Request()->ajax()) {
            $data=Setting::findOrFail($id);
            return response()->json(['data'=>$data]);
        }
    }


    function initCustomerWorkingSpace(Request $request)
    {
      return DB::transaction(function() use ($request){

         $g = $this->globalInput($request);
         $mainCurrency = Balance::DOLLAR;
         $secondaryCurrency = Balance::CDF;

         $checkIfUserHasPrice=PriceSetting::where('host_customer_id',$g['host'])->first();

         if (!is_null($checkIfUserHasPrice)) {
           return response(['data'=>true]);
         }


         $this->initBalanceTable($mainCurrency,$secondaryCurrency,$g);

         return response(['data'=>true]);

      });
     
    }


    function createCustomerPrices($shopId,$host)
    {


        $data = array(
             array( 
                'name'            =>'DETAIL',
                'status'          =>1,
                'current_shop'    =>$shopId,
                'host_customer_id'=>$host
           ),
          array( 
                'name'            =>'GROS',
                'status'          =>1,
                'current_shop'    =>$shopId,
                'host_customer_id'=>$host
           ),

          array( 
                'name'            =>'ABONNEE',
                'status'          =>1,
                'current_shop'    =>$shopId,
                'host_customer_id'=>$host
           ),
           array( 
                'name'            =>'PROMOTIONNELLE',
                'status'          =>1,
                'current_shop'    =>$shopId,
                'host_customer_id'=>$host
           ),
        );

        for ($i=0; $i < count($data) ; $i++) { 
           PriceSetting::create($data[$i]);
        }

    }


    function initBalanceTable($mainCurrency,$secondaryCurrency,$g)
    {

       $userShops = AttribShop::where('user_id',$g['host'])->get();
       $countUserShop=count($userShops);

       $shops = [];

       foreach ($userShops as $row) {
        
        array_push($shops, array(
            'loopTimes'       => 4,
            'shop'            => $row->shop_id, 
            'currency'        => [$mainCurrency,$secondaryCurrency,$mainCurrency,$secondaryCurrency],
            'transaction_type'=> [0,0,1,1]
          )
         );

         $this->createCustomerPrices($row->shop_id,$g['host']);
       }

       if ($countUserShop === count($shops))
       {

             for ($i=0; $i < count($shops) ; $i++) { 

              for ($x=0; $x < $shops[$i]['loopTimes'] ; $x++) { 
                  

                Balance::create([
                  'amount'          =>0,
                  'currency'        =>$shops[$i]['currency'][$x],
                  'transaction_type'=>$shops[$i]['transaction_type'][$x],
                  'current_shop'    =>$shops[$i]['shop'],
                  'host_customer_id'=>$g['host']
                 ]);

              } 

           }
           
       }
      
    }




}

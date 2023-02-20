<?php

namespace App\Http\Controllers\Backend\Price;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Product,Stock,Price,Category};
use App\Traits\GlMethod;
use DB;
class PriceController extends Controller
{
     use GlMethod;
     

    function deletePrice($id)
    {
      $data = Price::where('id',$id)->delete();
      return response(['message'=> 'Surpprimer avec succès '],200);
    }


    function productPrices(Request $request)
    {
     
     $g = $this->globalInput($request);

      $data = Price::where('product_id',$request->product_id)
      ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host'])
      ->select('price_name','price','id')
      ->orderBy('price_name','asc')
      ->get();

      return response(['data'=>$data],200);
 
    }

    function addPrice(Request $request)
    {

      $currentShop =$request->current_shop;
      $hostCustomerId=$request->host_customer_id;

      $priceExist = Price::where('product_id',$request->product_id)
      ->where('price_name',$request->price_name)
      ->where('current_shop',$currentShop)
      ->where('host_customer_id',$hostCustomerId)
      ->first();

      if (is_null($priceExist)) 
      {
          $price = Price::create([
          'product_id'  =>$request->product_id,
          'price'       =>$request->price,
          'price_name'  =>$request->price_name,
          'current_shop'=>$currentShop,
          'host_customer_id'=>$hostCustomerId,

        ]);

          return response([
            'data'   => $price,
            'message'=> 'Prix ajoute avec succès'
          ],201);
      }
      else
      {
          return response(['message'=> 'Désolez, vous avez déjà ajouté ce prix !'],422);
      }
      
    }
}

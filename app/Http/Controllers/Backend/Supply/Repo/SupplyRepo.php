<?php 
namespace App\Http\Controllers\Backend\Supply\Repo;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Modals\Backend\{Product,Stock,Price,SupplyStock};
use DateTime;
use DB;
use Validator;
use Image;

trait SupplyRepo{



   
     function getStockHistory($productId,$g)
     {
      $data =  DB::table('supply_stocks as ap')
      ->join('products','ap.product_id','=','products.id')
      ->select('ap.id','products.name as product_name','ap.product_price','ap.product_qty','ap.total_price','ap.created_at','ap.comment','ap.product_price','ap.provider_name','ap.provider_telephone')
      ->where('ap.product_id',$productId)
      ->where('ap.current_shop',$g['shop'])
        ->where('ap.host_customer_id',$g['host'])
      ->orderBy('ap.id','desc')
      ->paginate(10);
      return $data;

     }



     function getAvailableStock($productId,$g)
     {
      $stock = Stock::where('product_id',$productId)
      ->where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
      ->sum('stock');

      return $stock;
     }




}
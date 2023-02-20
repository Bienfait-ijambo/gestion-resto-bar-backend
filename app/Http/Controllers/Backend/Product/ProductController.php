<?php

namespace App\Http\Controllers\Backend\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Product,Stock,Price};
use App\Traits\GlMethod;
use Validator;
use Image;
use DB;
class ProductController extends Controller
{
     use GlMethod;


    function index(Request $request)
    {

        $g = $this->globalInput($request);

    	  $categoryId=$request->get('category_id');
        $query=$request->get('query');
        $query=str_replace(" ", "%", $query);

  
        $data = Product::with(['prices','stock','units'])
        ->select('products.id','products.name','products.category_id','products.expiration_date','products.security_stock')
        ->where('products.current_shop',$g['shop'])
        ->where('products.host_customer_id',$g['host']);

        if ($query != '') {
            $data->where('products.name','like','%'.$query.'%')
            ->orderBy('products.name','desc');
        }

        if(!is_null($categoryId)) {

             $data->where('products.category_id',intval($categoryId))
            ->where('products.name','like','%'.$query.'%')
            ->orderBy('products.name','asc');
           
        }

         return $this->apiData($data->paginate(10));


    }

    function store(Request $request)
    {
      return DB::transaction(function() use ($request){

        $g = $this->globalInput($request);
    
        // $imageName=$this->uploadImage($request,'product_image');
          
          $product=Product::create([
               'name'          => ucfirst(strtolower($request->name)),
               'product_unit_id'  => $request->product_unit_id,
               'category_id'   => $request->category_id,
               'barcode'       => $request->barcode,
               'security_stock'=> $request->security_stock,
               'expiration_date'=> $request->expiration_date,
               'current_shop'	 => $g['shop'],
               'host_customer_id'=> $g['host']
            ]);

          $lastId= $product->id;

          $this->initProductInStockTable($lastId,$g['shop'],$g['host']);

         return response([
          'data'      =>$product,
          'message'   =>'Produit enregistre avec succès.'
         ],201);

      });
    }


    function initProductInStockTable($lastId,$currentShop,$hostCustomerId)
    {
    	Stock::create([
          'product_id'   => $lastId,
          'stock'        => 0,
          'current_shop' => $currentShop,
          'host_customer_id'=>$hostCustomerId
        ]);
    }



    function update(Request $request)
    {
       
      Product::whereId($request->id)->update([
         'name'             => ucfirst(strtolower($request->name)),
         'product_unit_id'  => $request->product_unit_id,
         'category_id'      => $request->category_id,
         'barcode'          => $request->barcode,
         'security_stock'   => $request->security_stock,
         'expiration_date'  => $request->expiration_date,
      ]);
                
      return response(['message' => 'Modification effectue avec succès !' ]);  

    }

    
    public function edit(Request $request,$id)
    {

        $g = $this->globalInput($request);

      $data=DB::table('products as p')
      ->join('categories','p.category_id','=','categories.id')
      ->select('p.name','p.product_price','p.category_id','categories.category_name','p.barcode','p.id as hiddenProductId','p.product_image','p.security_stock')
      ->where('p.id',$id)
      ->where('p.current_shop',$g['shop'])
      ->where('p.host_customer_id',$g['host'])
      ->get();
 
      return response(['data'=>$data],200);        
    }


   function getExpiredProducts(Request $request)
   {
     $g = $this->globalInput($request);

     $data=DB::table('expiredProducts')
     ->select('*')
     ->where('daysLeft','<',20)
     ->where('current_shop',$g['shop'])
     ->where('host_customer_id',$g['host']);

     return $this->apiData($data->paginate(10));

      // CREATE VIEW expiredProducts as SELECT id,name,expiration_date,now() as now,datediff(expiration_date,now()) as daysLeft,current_shop,host_customer_id FROM products;
    
   }





    function makeAlertStock(Request $request)
    {
      $g = $this->globalInput($request);

      $data=DB::table('stock_alert')
      ->select('id','name','security_stock','stock as actual_qty')
      ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host']);

      return $this->apiData($data->paginate(10));

      //CREATE VIEW stock_alert as SELECT products.id,products.name,products.security_stock,stocks.stock,products.current_shop,products.host_customer_id  FROM products INNER JOIN
// stocks ON products.id=stocks.product_id WHERE stocks.stock <= products.security_stock;
    }

    function countStockAlertProducts(Request $request)
    {
      $g = $this->globalInput($request);

      $data=DB::table('stock_alert')
      ->select('id','name','security_stock','stock as actual_qty')
      ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host'])
      ->count();

      return response(['data'=>$data],200);
    }


    function countProduct(Request $request)
    {
      $g = $this->globalInput($request);
      $countProducts = Product::where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host'])
      ->count();
      return response(['data'=>$countProducts]);
    }

    function destroy($id)
    {
      $data = Product::where('id',$id)->delete();
      return response(['message'=> 'Surpprimer avec succès '],200);
    }
}
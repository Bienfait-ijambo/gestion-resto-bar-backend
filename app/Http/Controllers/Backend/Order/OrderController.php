<?php

namespace App\Http\Controllers\Backend\Order;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Product,Stock,Price,Orders,SelectedProduct};
use App\User;
use App\Traits\GlMethod;
use App\Http\Controllers\Backend\Order\Traits\OrderHelper;
use App\Http\Controllers\Backend\Order\Dto\OrderDto;
use Validator;
use Image;
use DB;
class OrderController extends Controller
{
    use GlMethod,OrderHelper,OrderDto;


    function displayOrder(Request $request)
    {
      $commandId=$request->get('commandId');
      $status=$request->get('status');

      $clientName=$request->get('clientName');
      $userId=$request->get('userId');

      $g = $this->globalInput($request);


      $data = DB::table('orders')
      ->join('spaces','orders.space_id','=','spaces.id')
      ->join('tables','orders.table_id','=','tables.id')
      ->select('orders.id','orders.client_name','orders.count_product','orders.status','spaces.name as space_name','orders.created_at','orders.user_id','tables.name as table_name','orders.payment_type','orders.start_date','orders.end_date','orders.hidden_row_status','orders.current_shop','orders.host_customer_id')
      ->where('orders.status','!=',0)
      ->where('orders.current_shop',$g['shop'])
      ->where('orders.host_customer_id',$g['host']);

      if (!is_null($status)) {
        $data->where('orders.status',intval($status));
      }
          

      $orders=$data->orderBy('orders.id','desc')->paginate(10);

    
       return $this->apiData($orders);
    }


    function orderModalUsers(Request $request)
    {
      $g = $this->globalInput($request);
      $users=User::select('id','name')
      ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host'])
      ->get();
      return response(['data'=>$users]);
    }

     function changeCommandStatus(Request $request)
    {
      return DB::transaction(function() use ($request){

         $g = $this->globalInput($request);

         $data=$request->all();

          $row=Orders::where('id',$data['id'])->first();

          if (!is_null($row)) 
          {
             if ($data['type'] === 'CHANGE_STATUS_TO_PENDING_OR_FINISHED') 
             {
       
              if (intval($row->status) === 1) {
                $this->updateClientNameAndPaymentType($data,$g);
                $this->reverseStatus($data['id'],2,0);
                return response(['message'=>'Vous venez de valider cette commande avec succès !'],200);
              }

             }

             if ($data['type'] === 'CHANGE_STATUS_TO_ZERO') 
             {
                 $orderExist = $this->getCurrentOrder($g);

                 if(!is_null($orderExist)){
                      return response(['data'=>true]);
                 }else{
                     $this->reverseStatus($data['id'],0,1);
                     return response(['data'=>false]);
                 }
                
             }
             
             
          }

      });

    }

    function completedAnOrder(Request $request)
    {
        $orderId = $request->order_id;
        $this->reverseStatus($orderId,3,0);
         return response([
        'message'   =>'Commande Termine avec succès !'
       ],200);  
    }



    function createOrder(Request $request)
    {
      $g = $this->globalInput($request);
      $orders= $this->getCurrentOrder($g);
 
      if (!is_null($orders)) 
      {
      	 return response([
                'message'=>'Désolez, il y a une commande qui est  en cours...'
            ],422);

      }
      else
      {

        $order=Orders::create([
          'client_name'     =>$this->filterName($request->client_name,$g),
          'client_id'       =>0,
          'count_product'   =>0,
          'status'          =>0,
          'space_id'         =>$request->space_id,
          'table_id'        =>$request->table_id,
          'is_deletable'    =>0,
          'payment_type'    =>1,
          'user_id'         =>$request->user_id,
          'hidden_row_status'=>0,
          'current_shop'    =>$g['shop'],
          'host_customer_id'=>$g['host'],
        ]);

         return response([
                'data'  => $order,
                'message'=>'Commande crée avec succès'
            ],200);
      }
      
    }


    function getLastOrders(Request $request)
    {

      $g = $this->globalInput($request);

      $last_order=DB::table('orders')
      ->join('spaces','orders.space_id','=','spaces.id')
      ->join('tables','spaces.id','=','tables.space_id')
      ->select('orders.id','orders.client_name','orders.created_at','orders.user_id','orders.is_deletable','orders.table_id','spaces.name as space','tables.name as table_name','orders.current_shop','orders.host_customer_id')
      ->where('orders.status',0)
      ->where('orders.current_shop',$g['shop'])
      ->where('orders.host_customer_id',$g['host'])
      ->orderBy('id','desc')
      ->first();

       return response([
            'data'  => $last_order,
        ],200);
  
    }



    function addProductToCurrentOrder(Request $request)
    {

      return DB::transaction(function() use ($request){

         $g = $this->globalInput($request);
         $currentOrder= $this->getCurrentOrder($g);

         $data=$request->all();

         $last_order_id=$currentOrder->id;
         $data['last_order_id']=$last_order_id;
         $data['is_validated']=0;
         $data['print_type']=0;


          if (!is_null($currentOrder)) 
          {

            $check_p=$this->ProductIsAlreadySelect($last_order_id,$data['product_id'],$g);

            if (!is_null($check_p)) {
              return response(['message'=>'Désolez, vous avez déjà selectionner ce produit !'],422);
            }
            else
            {

             $insert = SelectedProduct::create($data);
             if ($insert)  {
              
                $count = intval($currentOrder->count_product);

                $this->countSelectedProduct($last_order_id,"add",$count);

                 return response([
                    'message'=>'Produit ajouté au panier !'.$count,
                    'data'=>$insert
                ],200);

             }
             

            }
            
          }
 
      });

    }

    




    function getOrderItems(Request $request)
    {
      $g = $this->globalInput($request);
      $lastOrderId=$request->last_order_id;

      $items= DB::table('selected_products as sel')
             ->join('products','sel.product_id','=','products.id')
             ->select('products.name','products.name','sel.id','sel.last_order_id','sel.product_id','sel.product_qty','sel.product_price','sel.is_validated','sel.print_type','sel.current_shop','sel.host_customer_id')
             ->where('sel.last_order_id',$lastOrderId)
             ->where('sel.current_shop',$g['shop'])
             ->where('sel.host_customer_id',$g['host'])
             ->where('sel.is_validated',1)
             ->orWhere('sel.is_validated',0)
            ->get();
          
          
       return response([ 'data'=>$items],200);
      
    }



    function removeProductFromOrder(Request $request)
    {
      return DB::transaction(function() use ($request){

         $g = $this->globalInput($request);
         $productId = $request->product_id;
         $orderProductQty = $request->product_qty;
            
          $orders = Orders::where('id',$request->last_order_id)->first();

          $count = intval($orders->count_product);
          $this->countSelectedProduct($request->last_order_id,'reduce',$count);

          if (intval($request->is_validated) === 1) {
            $productQty = $this->getProductQty($productId,$g['shop'],$g['host']);
            $this->addAndUpdateQty($productId,$productQty->stock,$orderProductQty,$g['shop'],$g['host']);
          }

          SelectedProduct::where('id',$request->selected_product_id)->delete();
          return response(['message'=>'Suppression réussie !'],200);
    

        });
      
    }

    function cancelCommand(Request $request)
    {

      return DB::transaction(function() use ($request){

         $orderId=intval($request->last_order_id);
         $g = $this->globalInput($request);
         $products=$this->getOrderProducts($orderId,$g);

        if (count($products) > 0) 
        {
            foreach ($products as $row) {
              
               $productQty = $this->getProductQty($row->product_id,$g['shop'],$g['host']);
               $this->addAndUpdateQty($row->product_id,$productQty->stock,$row->product_qty,$g['shop'],$g['host']);
            }

            Orders::where('id',$orderId)->delete();
            SelectedProduct::where('last_order_id',$orderId)->delete();
            return response(['message'=>'Vous avez annulée la commande avec succès!'],200);
        }else{
          Orders::where('id',$orderId)->delete();
          return response(['message'=>'Vous avez annulée la commande avec succès!'],200);
        }

      });

    }



    function getOrderProducts($orderId,$g){
      $products = SelectedProduct::select('product_id','product_qty','product_price')
          ->where('last_order_id',$orderId)
          ->where('current_shop',$g['shop'])
          ->where('host_customer_id',$g['host'])
          ->get();
      return $products;
    }




    function validateOrders(Request $request)
    {
        return DB::transaction(function() use ($request){

            $g = $this->globalInput($request);
            $orderId=$request->id;

            $select_items = $this->productAddedToShoppingCart($orderId,0,$g);
            //command talbe

            if (count($select_items) > 0) {
              
              foreach ($select_items as $row) {

                  $total_price=(floatval($row->product_qty) * floatval($row->product_price));
                  $this->reduceAndUpdateQty($row->product_id,$row->product_qty,$g['shop'],$g['host']);
                  $this->validatedSelectedProduct($orderId,$row->product_id,$g);

              }

              $this->changeOrderStatus($orderId);
              return response(['message'   => 'Commande validée avec succès'],200);

          } 
          else {
              $this->changeOrderStatus($orderId);
               return response(['message'   => 'Commande validée avec succès'],200);
          }


        });
    }


    function updateOrderQty(Request $request)
    {
      SelectedProduct::where('id',$request->id)
      ->update([
        'product_qty'=>$request->product_qty
      ]);
      return response(['message'   => 'Vous avez modifié la quantité !'],200);
    }

   


    function updateClientNameAndPaymentType($data,$g)
    {

        $dtoData = $this->orderDto($data,$g);
     
        $paymentTypeStatus=$this->paymentTypeStatus($data['payment_type']);

        $b = $this->getBalanceRow($dtoData);
    
        $select_items = $this->productAddedToShoppingCart($data['id'],1,$g);

        $clientType=$this->getPartenaire($data['clientType'],$data['client_name']);
        
        $newBalanceAmount=0;

        
        if (count($select_items) > 0) 
        {

          foreach ($select_items as $row)  {
              $productTotalPrice=$this->aroundNumber(floatval($row->product_qty) * floatval($row->product_price));
              $newBalanceAmount+=$productTotalPrice;

              if ($paymentTypeStatus !== false) {
                  $this->processCashTransaction2($paymentTypeStatus,$row->product_id,$productTotalPrice,$row->product_qty,$dtoData['currency'],$dtoData['transaction_type'],$clientType,$dtoData['accountancy_code'],$dtoData['comment'],$g);
              }

             
          }

            if ($paymentTypeStatus === false) 
            { // debt
                $this->createDebt($data['client_id'],$newBalanceAmount,$g);
                $this->updateClientNameAndPayementType($data);
                
            }
            else
            {
              $dtoData['amount']=$newBalanceAmount;
              $this->countCustomerPaideMoney($data['client_id'],$newBalanceAmount,$g);
              $this->increaseOrDecreaseCashDeskAmount('inscrease',$b->amount,$dtoData);
              $this->updateClientNameAndPayementType($data);
            }

           
       }
 
  
    }
    //end

    






}

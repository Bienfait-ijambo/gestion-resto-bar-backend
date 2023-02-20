<?php 

namespace App\Http\Controllers\Backend\Order\Traits;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Modals\Backend\{Product,SelectedProduct,Orders,BalanceHistory,Balance,CashHistory};
use App\Traits\GlMethod;
use DateTime;
use DB;
use Validator;


trait OrderHelper{

	use GlMethod;

	function processCashTransaction2($paymentTypeStatus,$productId,$productTotalPrice,$productQty,$currency,$transactionType,$client,$accountancyCode,$description,$g)
    {

         if ($paymentTypeStatus) {
              $comment = ''.$description.''.$this->getProductName($productId,$g).'';
              $this->processCashHistoryTransaction2($productTotalPrice,$comment,$productQty,$currency,1,$transactionType,$client,$accountancyCode,$g);
          }
 
    }

  


   function processCashHistoryTransaction2($amount,$comment,$qty,$currency,$status,$transactionType,$client,$accountancyCode,$g)
   {
        $this->createHistory([
                'amount'          => $amount,
                'comment'         => $comment,
                'out_qty'         => $qty,
                'currency'        => $currency,
                'status'          => $status,
                'transaction_type'=> $transactionType,
                'client'		  => $client,
                'accountancy_code'=> $accountancyCode,
                'current_shop'    => $g['shop'],
                'host_customer_id'=> $g['host']
        ]);
   }

   function soldType($type)
    {
      if ($type == 'CASH' || $type == 'AIRTEL-MONEY' || $type == 'M-PESA' || $type =='BANQUE' || $type == 'CHEQUE') 
         return 0;
      
      if($type == 'CREDIT')
        return 1; 
    }

    
    function paymentTypeStatus($paymentType)
    {
      $status=intval($paymentType);

      if ($status === 1 || $status === 2 || $status === 3) {
        return true;
      }

      if ($status === 4) {
          return false;
      }
    }

     function getCurrentOrder($g)
    {
       $orders = Orders::where('status',0)
      ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host'])
      ->first();
      return $orders;
    }


     function ProductIsAlreadySelect($last_order_id,$product_id,$g)
    {
      $row = SelectedProduct::where('last_order_id',$last_order_id)
        ->where('product_id',$product_id)
        ->where('is_validated',0)
        ->where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
        ->first();
        return $row;
    }

    function countSelectedProduct($lastOrderId,$actionType,$count){

       $count_product=$count;
       
       ($actionType == 'add') ? ($count_product += 1) : ($count_product -= 1);

       Orders::where('id',$lastOrderId)
       ->update(['count_product' => $count_product]);
    }


   function validatedSelectedProduct($lastOrderId,$productId,$g)
    {
        SelectedProduct::where('last_order_id',$lastOrderId)
            ->where('product_id',$productId)
            ->where('current_shop',$g['shop'])
            ->where('host_customer_id',$g['host'])
            ->update([
              'is_validated'=> 1
            ]);
    }

    
    function productAddedToShoppingCart($lastOrderId,$status,$g)
    {
       $data= SelectedProduct::where('last_order_id',$lastOrderId)
            ->where('is_validated',$status)
            ->where('current_shop',$g['shop'])
            ->where('host_customer_id',$g['host'])
            ->get();
      return $data;
    }


    function getPartenaire($clientType,$clientName)
    {
      if ($clientType==1 || $clientName==0) {
          return 'P./'.$clientName;
      }else{
        return '';
      }
    }

    

    function changeOrderStatus($order_id)
    {
      Orders::where('id',$order_id)->update([
            'status' => 1,
      ]);
    }

    function reverseStatus($orderId,$status,$isDeletable)
    {
      Orders::where('id',$orderId)->update([
            'status'      => $status,
            'is_deletable'=> $isDeletable
      ]);
    }




}
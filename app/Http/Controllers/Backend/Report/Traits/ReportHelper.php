<?php 
namespace App\Http\Controllers\Backend\Report\Traits;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Http\Controllers\Backend\Report\Repo\ReportRepo;
use App\Modals\Backend\{Product,SelectedProduct,Orders,BalanceHistory,Balance,CashHistory};
use App\Traits\GlMethod;
use DateTime;
use DB;
use Validator;
use Image;

trait ReportHelper{

	use GlMethod,ReportRepo;

	  function customerTotalAmount($customerId,$g)
    {
      $data = $this->getSigleRowCustomerFidelity($customerId,$g);
      return !is_null($data) ? floatval($data->amount) : 0;
    }


    function getOrderProducts($orderId,$g)
    {
    	  $data = $this->getProductAddedToOder($orderId,$g);
        return $data;
    }

    function displayImg($img)
    {
        $logo=base_path($img);
        $f=file_get_contents($logo);
        $pic='data:image/png;base64,'.base64_encode($f);
        return $pic;
    }

    

   function customerName($orderId,$g)
   {
      $orders= $this->returnCustomerName($orderId,$g);
        if (!is_null($orders)) {
          return $orders->client_name;
        }
    }


    function getOrderCommentAndClientId($orderId)
    {
    	$data = Orders::where('id',$orderId)->select('comment','client_id')->first();
    	return $data;
    }

   

    function returnTotalBalance($currency,$transactionType,$g)
    {  
      // $transactionType
      //  0 == cashdesk
      //  1 == bank
        $params=[
          'currency'        =>$currency,
          'transaction_type'=>$transactionType,
          'current_shop'    =>$g['shop'],
          'host_customer_id'=>$g['host'],
        ];

         $balance = $this->getBalanceRow($params); //get bank balance
         if (!is_null($balance)) {
           return $balance->amount;
         }
        
    }

    
     




}
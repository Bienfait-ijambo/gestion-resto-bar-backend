<?php
namespace App\Traits;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Modals\Backend\{Product,Stock,Price,SupplyStock,Customer,SelectedProduct,Orders,BalanceHistory,Balance,CashHistory};
use DateTime;
use DB;
use Validator;
use Image;
trait GlMethod
{ 
	//global query
    function Gquery($request)
    {
      return str_replace(" ", "%", $request->get('query'));
    }

    function f_date($date)
    {
      $date = new DateTime($date);
      return substr($date->format('d/m/Y H:i:s'), 0,10);
    }

    function apiData($data){
      return response($data, 200);
    }

    function formatNumber($number)
    {
      return number_format(floor($number*100)/100, 2); //Returns 0.99
    }

    function uploadImage($request)
    {
         $error = Validator::make($request->all(), [
          'image' =>  'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048'
        ]);

        if($error->fails()){
            return response([
                'message'   => "La taille  doit être supérieure ou égale à  2Mo, JPG, PNG, GIF !!!",
                'upload' => false
            ],422);
        }
        
            
        $baseUrl= url('/');
        $imageName = time().'.'.$request->image->getClientOriginalExtension();
        $resize_image = Image::make($request->image->getRealPath());
             
         $resize_image->resize(800, 550, function($constraint){
               $constraint->aspectRatio();
         })->save(storage_path('app/public/images/' . $imageName));

        return $baseUrl.'/storage/images/'.$imageName;
    }

   
    function generateOpt($n)
    {

     $generator="1234567890AZERTYUIOPQSDFGHJKLMWXCVBN";
     $result="";
     for ($i=0; $i <$n ; $i++) { 
       $result.=substr($generator, (rand()%(strlen($generator))),1);
     }
     return $result;
    }

    function reduceQty($productId,$outQty,$currentShop,$hostCustomerId)
    {
      $row=Stock::where('product_id',$productId)
          ->where('current_shop',$currentShop)
          ->where('host_customer_id',$hostCustomerId)
          ->first();

      $stockQty = $row->stock;

      if (floatval($stockQty) >= floatval($outQty)) 
      {
         $remainQty=floatval($stockQty) - floatval($outQty);
         $this->updateStock($productId,$remainQty,$currentShop,$hostCustomerId);
         return true;
      }
      else
      {
        return false;
      }

    }

    function updateStock($productId,$remainQty,$currentShop,$hostCustomerId)
    {
      Stock::where('product_id',$productId)
      ->where('current_shop',$currentShop)
      ->where('host_customer_id',$hostCustomerId)
      ->update([
        'stock'  => $remainQty
      ]);
    }



     function getProductQty($productId,$currentShop,$hostCustomerId)
     {
        $productQty=Stock::where('product_id',$productId)
          ->where('current_shop',$currentShop)
          ->where('host_customer_id',$hostCustomerId)
          ->first();
        return $productQty;
     }

    function addAndUpdateQty($product_id,$existQty,$newQty,$currentShop,$hostCustomerId)
    {
      $updateQty=floatval($existQty) + floatval($newQty);
      $this->updateStock($product_id,$updateQty,$currentShop,$hostCustomerId);
    }

    function reduceAndUpdateQty($product_id,$exit_qty,$currentShop,$hostCustomerId)
    {

        $productQty = $this->getProductQty($product_id,$currentShop,$hostCustomerId);
        
          if (!is_null($productQty)) 
          {
              $stock_qty = $productQty->stock;
              $out_qty = $exit_qty;

              if (floatval($stock_qty) >= floatval($out_qty)) {
                   $remain_qty=floatval($stock_qty) - floatval($out_qty);
                   $this->updateStock($product_id,$remain_qty,$currentShop,$hostCustomerId);
              }
          }
    
    }


      function globalInput($request)
      {
          $currentShop =$request->current_shop;
          $hostCustomerId=$request->host_customer_id;

            return [
              'shop' => $currentShop,
              'host' => $hostCustomerId
            ];
      }

      //this function take two val after point
    function aroundNumber($number)
    {
      if (strpos($number, '.')) {
        $position=strpos($number, '.') + 1;
        return substr($number, 0,$position + 1);
      }else{
        return $number;
      }
    }

    function filterName($id,$g)
    {
      if (is_numeric($id)) 
      {
        $client = Customer::where('id',$id)
        ->select('name as client_name')
        ->where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
        ->first();
        return $client->client_name;
      }
      else
      {
        return ($id!="Commande") ? $id : 'Commande';

      }
    }


    function getBalanceRow($dtoData)
    {
       $balance = Balance::where('currency',$dtoData['currency'])
            ->where('transaction_type',$dtoData['transaction_type'])
            ->where('current_shop',$dtoData['current_shop'])
             ->where('host_customer_id',$dtoData['host_customer_id'])
            ->first();
      return $balance;
    }

     function changeBalanceAmount($dtoData,$amount)
    {
       Balance::where('currency',$dtoData['currency'])
            ->where('transaction_type',$dtoData['transaction_type'])
            ->where('current_shop',$dtoData['current_shop'])
             ->where('host_customer_id',$dtoData['host_customer_id'])
            ->update([
               'amount' =>$amount
            ]);
    }

    function updateBalanceHistoryAmount($amount,$date,$dtoData)
    {
      
        BalanceHistory::where('currency',$dtoData['currency'])
        ->where('transaction_type',$dtoData['transaction_type'])
        ->where('current_shop',$dtoData['current_shop'])
        ->where('host_customer_id',$dtoData['host_customer_id'])
        ->where('created_at',$date)
        ->update([
          'amount' => $amount
        ]);
    }


    function createBalanceHistory($action,$dtoData,$date)
    {
      $data =BalanceHistory::where('currency',$dtoData['currency'])
      ->where('transaction_type',$dtoData['transaction_type'])
      ->where('current_shop',$dtoData['current_shop'])
      ->where('host_customer_id',$dtoData['host_customer_id'])
      ->where('created_at',$date)
      ->first();

      $b = $this->getBalanceRow($dtoData);

      if (!is_null($data)) 
      {
        if ($action == 'deposit') {

             $updateCurrentAmount1=(floatval($data->amount) + floatval($dtoData['amount']));
             $this->updateBalanceHistoryAmount($updateCurrentAmount1,$date,$dtoData);
        }

        if ($action == 'withdraw_') {

             $updateCurrentAmount2=(floatval($data->amount) - floatval($dtoData['amount']));
             $this->updateBalanceHistoryAmount($updateCurrentAmount2,$date,$dtoData);
        }
        
      }
      else
      {
        if ($action == 'deposit') {
            $newAmount1=floatval($b->amount);
            $this->initBalanceHistory($newAmount1,$date,$dtoData);
        }

        if ($action == 'withdraw_') {
            $newAmount2=(floatval($b->amount) - floatval($dtoData['amount']));
            $this->initBalanceHistory($newAmount2,$date,$dtoData);
         
        }
        
      }
    }

    function initBalanceHistory($amount,$date,$dtoData)
    {
      BalanceHistory::insert([
              'amount'            =>$amount,
              'currency'          =>$dtoData['currency'],
              'transaction_type'  =>$dtoData['transaction_type'],
              'current_shop'      =>$dtoData['current_shop'],
              'host_customer_id'  =>$dtoData['host_customer_id'],
              'created_at'        =>$date
        ]);
    }

    function toDayDate()
    {
      $todayDate=DB::select('SELECT date_format(now(),"%Y-%c-%d") as toDayDate');
      return $todayDate;
    }

   


    function updateBalanceAmount($dtoData,$amount)
    {
       Balance::where('currency',$dtoData['currency'])
        ->where('transaction_type',$dtoData['transaction_type'])
        ->where('current_shop',$dtoData['current_shop'])
        ->where('host_customer_id',$dtoData['host_customer_id'])
        ->update([
            'amount' => $amount
     ]);

    }

 



    function getProductName($product_id,$g)
    {
      $data=Product::where('id',$product_id)
       ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host'])
      ->select('name')
      ->first();
      if (!is_null($data)) 
         return $data->name;
    }


    function getSigleDebt($client_id,$g)
    {
      $row=DB::table('debt_balances')
      ->where('customer_id',$client_id)
      ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host'])
      ->first();

      return $row;
    }

    function createDebt($client_id,$amount,$g)
    {
      $exist = $this->getSigleDebt($client_id,$g);

      if (!is_null($exist)) 
      {
        $total_amount=floatval($exist->total_amount) + floatval($amount);

        $this->updateDebtBalance($exist->customer_id,$total_amount,$g);
      }
      else
      {
        DB::table('debt_balances')->insert([
          'customer_id'       =>$client_id,
          'total_amount'    =>$amount,
          'current_shop'    =>$g['shop'],
          'host_customer_id'=>$g['host'],
        ]);
      }

    }

    function updateDebtBalance($client_id,$total_amount,$g)
    {
       DB::table('debt_balances')
         ->where('customer_id',$client_id)
         ->where('current_shop',$g['shop'])
         ->where('host_customer_id',$g['host'])
         ->update(['total_amount' => $total_amount]);
    }

    function getSigleRowCustomerFidelity($customerId,$g)
    {
     $data = DB::table('customer_fidelities')
      ->where('customer_id',$customerId)
      ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host'])
      ->first();
      return $data;
    }

    function countCustomerPaideMoney($customerId,$amount,$g)
    {
      $balance = $this->getSigleRowCustomerFidelity($customerId,$g);

      if (!is_null($balance)) {
       //update

        $updateAmount = floatval($balance->amount) + $amount;

        DB::table('customer_fidelities')
        ->where('customer_id',$customerId)
        ->where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
        ->update([
          // 'customer_id'=>$customerId,
          'amount'     =>$updateAmount
        ]);


      }else{
        //insert
        DB::table('customer_fidelities')->insert([
          'customer_id'=>$customerId,
          'amount'     =>$amount,
          'current_shop'=>$g['shop'],
          'host_customer_id'=>$g['host']
        ]);

      }
    }


    


    //-------------------------------------------------------TRANSACTION-----------------------------------------------------------------------------------------------------------------------------------------------------------------


    function createHistory($data)
    {
      CashHistory::create($data);
    }

  function changeCashDeskAmount($operationType,$dtoData)
   {
      $dtoData['transaction_type']=0;
      $b = $this->getBalanceRow($dtoData); //get cashDesk-Amount

     if ($operationType == 'WITHDRAW') 
     {

         if (floatval($b->amount) >= floatval($dtoData['amount'])) 
         {
            
              $this->increaseOrDecreaseCashDeskAmount('decrease',$b->amount,$dtoData);
              
              return true;
         }
         else
         {
           return false;
         }
         
             
     }
     else
     {


       $this->increaseOrDecreaseCashDeskAmount('inscrease',$b->amount,$dtoData);

       $dtoData['status']=1;
       $dtoData['qty']=0;
       $this->processCashHistoryTransaction($dtoData);

     }
      
   }

 

  function increaseOrDecreaseCashDeskAmount($type,$currentAmount,$dtoData){

    $todayDate = $this->toDayDate();

    if ($type == 'inscrease') {

        //no transfert
        // if (intval($transactionType)===0) { 
            $currentBalanceAmount1=floatval($currentAmount) + floatval($dtoData['amount']);
            $this->updateBalanceAmount($dtoData,$currentBalanceAmount1);
        // }
        
        
        //cashdesk
        $this->createBalanceHistory('deposit',$dtoData,$todayDate[0]->toDayDate);

    }else{

         $currentBalanceAmount2=floatval($currentAmount) - floatval($dtoData['amount']);

         //decrease from cashDesk
         $dtoData['transaction_type']=0;
        $this->updateBalanceAmount($dtoData,$currentBalanceAmount2);
        $this->createBalanceHistory('withdraw_',$dtoData,$todayDate[0]->toDayDate);


    }
   
  }



   function processCashTransaction($paymentTypeStatus,$productId,$productTotalPrice,$productQty,$currency,$transactionType,$accountancyCode,$g)
    {

         if ($paymentTypeStatus) {
              $comment = 'Vente '.$this->getProductName($productId,$g).'';
              $this->processCashHistoryTransaction($productTotalPrice,$comment,$productQty,$currency,1,$transactionType,$accountancyCode,$g);
          }
 
    }

  


   function processCashHistoryTransaction($data)
   {
        $this->createHistory(array(
                'amount'          => $data['amount'],
                'comment'         => $data['comment'],
                'out_qty'         => $data['qty'],
                'currency'        => $data['currency'],
                'status'          => $data['status'],
                'transaction_type'=> $data['transaction_type'],
                'client'          => $data['client'],
                'accountancy_code'=> $data['accountancy_code'],
                'current_shop'    => $data['current_shop'],
                'host_customer_id'=> $data['host_customer_id']
      ));
   }

   function updateClientNameAndPayementType($data){

        Orders::where('id',$data['id'])
        ->update([
            'client_name'  => $data['client_name'],
            'client_id'    => $data['client_id'],
            'payment_type' => $data['payment_type']
          ]);
    }



  

}
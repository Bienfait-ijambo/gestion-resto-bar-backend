<?php 
namespace App\Http\Controllers\Backend\Report\Repo;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Modals\Backend\{Product,Orders,BalanceHistory,Balance,CashHistory,SelectedProduct,Ticketing};
use DateTime;
use DB;
use Validator;
use Image;

trait ReportRepo{



      function getDateTicketing($currency,$transactionType,$currentDate,$g)
      {
        $transactionType=Ticketing::CASH_DESK_TRANSACTION_TYPE;

        $data = Ticketing::where('transaction_type',$transactionType)
         ->where('currency',$currency)
         ->where('current_shop',$g['shop'])
         ->where('host_customer_id',$g['host'])
         ->where('created_at',$currentDate)
         ->get();

         return $data;
      }

 
      function getFromDateToDateTicketing($currency,$transactionType,$startDate,$endDate,$g)
      {
         $transactionType=Ticketing::CASH_DESK_TRANSACTION_TYPE;

         $data = Ticketing::where('transaction_type',$transactionType)
         ->where('currency',$currency)
         ->where('current_shop',$g['shop'])
         ->where('host_customer_id',$g['host'])
         ->whereBetween('created_at',array($startDate,$endDate))
         ->get();

         return $data;

      }


      function getTodayReport($currency,$currentDate,$transactionType,$g)
      {
       $data =  CashHistory::where('currency',$currency)
        ->where('transaction_type',$transactionType)
        ->where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
        ->where('created_at',$currentDate)
        ->select('id','created_at','accountancy_code','comment','client','out_qty','amount','currency','status','transaction_type')
        ->cursor();
       
        
        return $data;
      }

      function getFromDateToDateReport($currency,$currentDate,$startDate,$endDate,$transactionType,$g)
      {
       $data =  CashHistory::where('currency',$currency)
        ->where('transaction_type',$transactionType)
        ->where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
        ->whereBetween('created_at',array($startDate,$endDate))
        ->select('id','created_at','accountancy_code','comment','client','out_qty','amount','currency','status','transaction_type')
        ->cursor();

       return $data;
      }

        function getExcelData($reportTitleInfo,$transactionType,$g)
        {

          $data = DB::table('excel_report')
          ->where('currency',$reportTitleInfo['currency'])
          ->where('transaction_type',$transactionType)
          ->where('current_shop',$g['shop'])
          ->where('host_customer_id',$g['host'])
          ->whereBetween('created_at',array($reportTitleInfo['startDate'],$reportTitleInfo['endDate']))
          ->select('id','created_at','accountancy_code','comment','client','out_qty','amount','devise','movement','transaction','current_shop','shop_name')
          ->get();
          return $data;
        }

        //         CREATE VIEW excel_report as SELECT cash_histories.id,cash_histories.created_at,cash_histories.accountancy_code,cash_histories.comment,cash_histories.client,
        // cash_histories.out_qty,cash_histories.amount, 
        // IF(cash_histories.currency =1,'USD','FC') as devise,
        // IF(cash_histories.status =1,'ENTREE','SORTIE') as movement,
        // IF(cash_histories.transaction_type =1,'BANQUE','CAISSE') as transaction,shops.name as shop_name,cash_histories.currency,cash_histories.status,cash_histories.transaction_type,cash_histories.current_shop,cash_histories.host_customer_id FROM cash_histories INNER JOIN shops ON cash_histories.current_shop=shops.id;

      
      function getProductAddedToOder($orderId,$g)
      {
       $data = SelectedProduct::where('last_order_id',$orderId)
          ->where('current_shop',$g['shop'])
          ->where('host_customer_id',$g['host'])
          ->get();
        return $data;
      }

      function returnCustomerName($orderId,$g)
      {
        $data = Orders::where('id',$orderId)
        ->select('client_name')
         ->where('current_shop',$g['shop'])
          ->where('host_customer_id',$g['host'])
          ->first();
        return $data;
      }


      function processReportQuery($reportTitleInfo,$transactionType,$g)
      {
        $startDate=$reportTitleInfo['startDate'];

        $currency=$reportTitleInfo['currency'];

        $endDate=$reportTitleInfo['endDate'];

        $currentDate = $reportTitleInfo['currentDate'];

        if (!is_null($startDate) && !is_null($endDate)) 
        {
         return $data=$this->getFromDateToDateReport($currency,$currentDate,$startDate,$endDate,$transactionType,$g);
        }
        else
        {
          return $data= $this->getTodayReport($currency,$currentDate,$transactionType,$g);
        }

      }



        function getStockHistory($dates,$productId,$g)
        {
            $data =DB::table('supply_stocks as ap')
              ->join('products','ap.product_id','=','products.id')
             ->select('ap.id','products.name as product_name','ap.product_price','ap.product_qty','ap.total_price','ap.created_at','ap.comment','ap.product_price','ap.provider_name','ap.provider_telephone')
              ->where('ap.current_shop',$g['shop'])
              ->where('ap.host_customer_id',$g['host'])
              ->where('ap.product_id',$productId)
              ->whereBetween('ap.created_at',$dates)
              ->get();
            return $data;
        }


        function getPastDateBalance($currency,$transactionType,$g)
        {
          $pastDate=$this->getPastDate();

          $pastBalance = BalanceHistory::where('currency',$currency)
          ->where('transaction_type',$transactionType)
          ->where('current_shop',$g['shop'])
          ->where('host_customer_id',$g['host'])
          ->where('created_at',$pastDate)
          ->first();

          return !is_null($pastBalance) ? $pastBalance->amount : 0;
        }


        function getPastDate()
        {
          $pastDate = DB::select('SELECT DATE_SUB(CURDATE(), INTERVAL 1 DAY) as past_date');
          return $pastDate[0]->past_date;
        }

      


        function getCustomers($limit,$offset,$g)
        {
          $customers = DB::table('customers')
          ->select('name','email','telephone')
          ->limit($limit)
          ->skip($offset)
          ->where('current_shop',$g['shop'])
          ->where('host_customer_id',$g['host'])
          ->get();

          return $customers;
        }





}
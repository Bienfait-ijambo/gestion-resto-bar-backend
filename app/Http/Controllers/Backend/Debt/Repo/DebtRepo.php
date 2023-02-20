<?php 
namespace App\Http\Controllers\Backend\Debt\Repo;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Traits\GlMethod;
use DateTime;
use DB;
use Validator;
use Image;

trait DebtRepo{

	use GlMethod;


  function getCountDebts($g)
  {
      $count = DB::table('debt_balances')
              ->where('total_amount','>', 0)
              ->where('current_shop',$g['shop'])
              ->where('host_customer_id',$g['host'])
              ->count();
      return $count;
  }


  function returnTotalDebtAmount($g)
  {
     $totalDebtAmount=DB::table('debt_balances')
       ->where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
       ->sum('total_amount');
      return $totalDebtAmount;
  }


  function getDebtPaymentHistory($customerId,$limit,$g)
  {
    $data =  DB::table('debt_payment_histories')
        ->select('id','paid_amount','created_at')
        ->where('customer_id',$customerId)
        ->where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
        ->limit($limit)
        ->orderBy('id','desc')
        ->get();
      return $data;
  }


  function getCustomerDebts($g)
  {
    $data = DB::table('debt_balances as b')
        ->join('customers','b.customer_id','=','customers.id')
        ->select('customers.name','customers.telephone','b.total_amount','customers.id as customer_id','customers.email')
        ->where('b.total_amount','>',0)
        ->where('b.current_shop',$g['shop'])
        ->where('b.host_customer_id',$g['host']);
    return $data;
  }

   function createDebtPaymentHistory($clientId,$paidAmount,$g)
    {
       DB::table('debt_payment_histories')
        ->insert([
            'customer_id'       =>$clientId,
            'paid_amount'     =>$paidAmount,
            'current_shop'    =>$g['shop'],
            'host_customer_id'=>$g['host']
        ]);
    }


       

      




}
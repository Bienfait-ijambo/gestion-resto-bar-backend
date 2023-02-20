<?php

namespace App\Http\Controllers\Backend\Debt;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Controllers\Backend\Debt\Repo\DebtRepo;
use App\Modals\Backend\{Category,Product,Balance,CashHistory,Orders,SelectedProduct};
use App\Traits\GlMethod;
use App\Http\Controllers\Backend\Debt\Dto\DebtDto;
use Validator;
use DB;
class DebtController extends Controller
{
    use GlMethod,DebtRepo,DebtDto;


   

    function store(Request $request)
    {
      return DB::transaction(function() use($request){

        $g = $this->globalInput($request);

        $data=$request->all();

        $DebtDto=$this->debtDto($data,$g);

        $b = $this->getBalanceRow($DebtDto); //cashdesk

        $exist = $this->getSigleDebt($data['client_id'],$g);

        $amountToPay=floatval($exist->total_amount);
     
        if (floatval($data['paid_amount']) <= $amountToPay) 
        {
           $total_amount=($amountToPay - floatval($data['paid_amount']));

           $this->updateDebtBalance($data['client_id'],$total_amount,$g);

           $this->createDebtPaymentHistory($data['client_id'],$data['paid_amount'],$g);


           $DebtDto['amount']=floatval($data['paid_amount']);
           $this->processCashHistoryTransaction($DebtDto);

           $this->increaseOrDecreaseCashDeskAmount('inscrease',$b->amount,$DebtDto);

           $this->countCustomerPaideMoney($data['client_id'],$data['paid_amount'],$g);
          
           return response(['message'=>'Paiement effectué avec succès !'],200);

        }
        else
        {
          return response(['message'=>'Désolez, le montant saisie est plus grand !!!'],422);
        }

      });
        
    }


    function createCommentInOrderTable($orderId,$comment)
    {
         Orders::where('id',$orderId)->update(['comment'=>$comment]);
    }


   


    function countDebts(Request $request)
    {
       $g = $this->globalInput($request);

       $total_debt = $this->getCountDebts($g);
       $totalDebtAmount=$this->returnTotalDebtAmount($g);

       return response([
          'totalDebts'    =>$total_debt,
          'totalDebtAmount'=>$totalDebtAmount
        ],200);
    }

    


    function AllDebt(Request $request)
    {
        $g = $this->globalInput($request);

        $query=$request->get('query');
        $query=str_replace(" ", "%", $query);

        $data = $this->getCustomerDebts($g);
  
        if (!is_null($query) && $query!='') {
          $data->where('customers.name','like','%'.$query.'%')
         ->orderBy('customers.name','asc');
        }

        $output=[];
        foreach ($data->paginate(10) as $row) 
        {

          array_push($output,  array(
             'id'            =>$row->customer_id,
             'name'          =>$row->name,
             'email'         =>$row->email,
             'telephone'     =>$row->telephone,
             'amount'        =>$row->total_amount,
             'debts'         =>$this->getCustomerDebt($row->customer_id,2,$g),
             'paymentHistory'=>$this->paymentHistory($row->customer_id,$g)
           ));
           
        }

        return response([
          'customersDebts'=>$output,
          'data'=>$data->paginate(10)
        ],200);

    }

    function paymentHistory($customerId,$g)
    {
        $data =$this->getDebtPaymentHistory($customerId,2,$g);

        $output=[];

        foreach ($data as $row) 
        {
           array_push($output, [
            'id'    =>$row->id,
            'amount'=>$this->formatNumber($row->paid_amount),
            'date'  =>$this->f_date($row->created_at)
           ]);
        }

        return $output;
    }


    function getCustomerDebt($customerId,$limit,$g)
    {

     $data = DB::table('orders')
        ->join('selected_products','orders.id','=','selected_products.last_order_id')
        ->join('products','selected_products.product_id','=','products.id')
        ->select('products.name as product_name','selected_products.id','selected_products.product_qty','selected_products.product_price','orders.id as orderId')
        ->where('orders.client_id',$customerId)
        ->where('orders.payment_type',Orders::PAYEMENT_TYPES['CREDIT'])
        ->where('orders.current_shop',$g['shop'])
        ->where('orders.host_customer_id',$g['host'])
        // ->where('selected_products.current_shop',$g['shop'])
        // ->where('selected_products.host_customer_id',$g['host'])
        ->limit($limit)
        ->get();

      $output=[];

      foreach ($data as $row) 
      {
        $total_price=$this->formatNumber(floatval($row->product_qty)*floatval($row->product_price));

        array_push($output, [
          'id'           =>$row->id,
          'product_name' =>$row->product_name,
          'product_qty'  =>$row->product_qty,
          'product_price'=>$row->product_price,
          'total_price'  =>$total_price
        ]);
      }
     return $output;
    }





}

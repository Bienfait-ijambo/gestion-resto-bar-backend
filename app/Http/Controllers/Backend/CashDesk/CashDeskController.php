<?php

namespace App\Http\Controllers\Backend\CashDesk;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Category,Product,Balance,CashHistory};
use App\Http\Controllers\Backend\CashDesk\Traits\CashDeskHelper;
use App\Http\Controllers\Backend\CashDesk\Dto\Dto;
use App\Traits\GlMethod;
use Validator;
use DB;
class CashDeskController extends Controller
{
   use CashDeskHelper,GlMethod,Dto;
 

     function index(Request $request)
     {
     	  $g = $this->globalInput($request);

        $data = $this->getCashHistories($g);

       	return $this->apiData($data->paginate(10));
     }

     function BankSoldHistory(Request $request)
     {
      $g = $this->globalInput($request);

      $mainCurrency=$this->getYesterDaySold(1,1,$g); //bank
      $primaryCurrency=$this->getYesterDaySold(1,2,$g); //bank

      $output1=[];
      $output2=[];

      $usdSoldOutput='';
      foreach ($mainCurrency as $row) 
      {
        array_push($output1, array(
          'amount'=>$this->formatNumber($row->amount),
          'date'  =>$this->f_date($row->created_at)
        ));
      }


      foreach ($primaryCurrency as $row) 
      {
         array_push($output2, array(
          'amount'=>$this->formatNumber($row->amount),
          'date'=>$this->f_date($row->created_at)
        ));
      }

      return response([
          'mainCurrency'     =>$output1,
          'secondaryCurrency'=>$output2
      ],200);

     }

    

    function CashDesksoldHistory(Request $request)
    {
     $g = $this->globalInput($request);

      $mainCurrency=$this->getYesterDaySold(0,1,$g); //cashdesk
      $primaryCurrency=$this->getYesterDaySold(0,2,$g); //cashdesk

      $output1=[];
      $output2=[];

      $usdSoldOutput='';
      foreach ($mainCurrency as $row) 
      {
        array_push($output1, array(
          'amount'=>$this->formatNumber($row->amount),
          'date'  =>$this->f_date($row->created_at)
        ));
      }


      foreach ($primaryCurrency as $row) 
      {
         array_push($output2, array(
          'amount'=>$this->formatNumber($row->amount),
          'date'=>$this->f_date($row->created_at)
        ));
      }

      return response([
          'mainCurrency'=>$output1,
          'primaryCurrency'=>$output2
      ],200);

    }

    function getYesterDaySold($transactionType,$currency,$g)
    {
      $data = $this->getCashDeskBalanceHistory($transactionType,$currency,$g);
      return $data;
    }


   

    function processCashDeskTransaction(Request $request)
    {
      return DB::transaction(function() use ($request){

            $g = $this->globalInput($request);

            $dtoData=$this->cashHistoryDto($request,$g);
            $dtoData['qty']=0;
            $todayDate = $this->toDayDate();

     
          //deposit
          if (intval($request->type) === 1) {
  
              $this->changeCashDeskAmount('deposit',$dtoData);
              return response(['message' => 'Félicitation, Transaction réussie !'],200);
           }

            //withraw
          if (intval($request->type) === 0) 
          {
           
            $success = $this->changeCashDeskAmount('WITHDRAW',$dtoData);

            if ($success) {

              //transfert cash-desk amount
              $this->transfertFromCashDeskToBank($dtoData,$todayDate[0]->toDayDate);

              return response(['message' => 'Félicitation, Transaction réussie !'],200);
            }
            else {
              return response(['message' => 'Désolez, Vous ne disposez pas de ce montant '],422);
            }
            
          }
        

      });
      
    }



 

    function getCashDeskAmount(Request $request)
    {
        $g = $this->globalInput($request);
        $data = $this->returnCashDeskAndBankSolds($g);
        return response($data,200);
    }

   
   


    function getTodayTotatAmountFromCashDesk(Request $request)
    {

      return DB::transaction(function() use($request){

        $g = $this->globalInput($request);
        $todayDate=$request->date;

        $data=$this->returnAmountFromCashDesk($todayDate,$g);
        return response($data,200);

      });
         
    }

    function getTodayTotatAmountFromBank(Request $request)
    {

       return DB::transaction(function() use($request){

        $g = $this->globalInput($request);
        $todayDate=$request->date;
    
        $data=$this->returnAmountFromBank($todayDate,$g);
        return response($data,200);

      });
   
    } 

    function processBankTransaction(Request $request)
    {
      return DB::transaction(function() use ($request){

        $type=intval($request->type);

        $g = $this->globalInput($request);

        $dtoData=$this->cashHistoryDto($request,$g);

        $dtoData['qty']=0;

        $todayDate = $this->toDayDate();

        $realTransactionType=$dtoData['transaction_type'];
        


      if ($type === 1)
       {
          //------------------------deposit operation---------------------------//

         $dtoData['transaction_type']=Balance::BANK_TRANSACTION;

         $balance = $this->getBalanceRow($dtoData);
          
          $currentBalance=floatval($balance->amount) + ($dtoData['amount']);

          $this->changeBalanceAmount($dtoData,$currentBalance);

          //bank
          $this->processTransactionForBankDeposit($dtoData);

          //bank status=1
          $this->createBalanceHistory('deposit',$dtoData,$todayDate[0]->toDayDate);
  

         return response(['message' => 'Félicitation, Transaction réussie !'],200);

      }
      else
      {
        //------------------------------------withdrawal operation-----------------------//

          $dtoData['transaction_type']=Balance::BANK_TRANSACTION;
         $balance = $this->getBalanceRow($dtoData);

         $success = $this->decreaseBankAmount($balance->amount,$dtoData['amount'],$dtoData);

          if ($success) 
          {
              $dtoData['transaction_type']=$realTransactionType;
              $this->transfertFromBankToCashDesk($dtoData,$todayDate[0]->toDayDate);

             return response(['message' => 'Félicitation, Transaction réussie !'],200);
          }
          else
          {
            return response(['message' => 'Désolez, Vous ne disposez pas de ce montant '],422);
          }
      }


      });
    }

   

   


     public function destroy(Request $request)
     { 

       CashHistory::where('id',$request->id)->delete(); 
        return response([
        'message'   =>'Suppression réussi !'
       ],200);
       
     }


  



}

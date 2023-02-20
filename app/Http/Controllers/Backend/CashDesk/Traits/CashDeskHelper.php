<?php 


namespace App\Http\Controllers\Backend\CashDesk\Traits;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Modals\Backend\{Category,Product,Balance,CashHistory};
use App\Traits\GlMethod;
use DateTime;
use DB;
use Validator;
use Image;

trait CashDeskHelper{


   use GlMethod;




    function transfertFromCashDeskToBank($dtoData,$date)
    {
      //get current balance to add or decrease

      $balance = $this->getBalanceRow($dtoData); //get bank balance


      $currentAmount=floatval($balance->amount) + floatval($dtoData['amount']);

       if (intval($dtoData['transaction_type']) === 1) {
         // transfert money to bank
  
         $this->updateBankAmount($currentAmount,$dtoData);


         $this->processTransactionForCashDeskWithdraw($dtoData);

         $this->processTransactionForBankDeposit($dtoData);

          //bank status=1
          $this->createBalanceHistoryForBankDeposit($dtoData,$date);


      }else{

         $this->processTransactionForCashDeskWithdraw($dtoData);
      }

    }

     function transfertFromBankToCashDesk($dtoData,$date)
    {
      //get current balance to add or decrease
      //get current cashdesk balance
     

       if (intval($dtoData['transaction_type']) === 1) {

          $dtoData['transaction_type']=Balance::CASHDESK_TRANSACTION;
          $balance= $this->getBalanceRow($dtoData);

          $currentBalance=floatval($balance->amount) + floatval($dtoData['amount']);

           $this->changeBalanceAmount($dtoData,$currentBalance);

           $this->processTransactionForCashDeskDeposit($dtoData);

           $this->processTransactionForBankWithdraw($dtoData);

           $this->createBalanceHistoryForBankDeposit($dtoData,$date);

           $this->createBalanceHistoryForCashDeskDeposit($dtoData,$date);
           

      }else{

            //bank history
            // status = 2 withdraw
            // transactionType=1 =>bank
            $this->processTransactionForBankWithdraw($dtoData);
      
            $this->createBalanceHistoryForBankWithdraw($dtoData,$date);

      }

    }


    //types of balance history

    function createBalanceHistoryForBankDeposit($dtoData,$date)
    {
      $dtoData['transaction_type']=Balance::BANK_TRANSACTION;
      $this->createBalanceHistory('deposit',$dtoData,$date);
    }

     function createBalanceHistoryForBankWithdraw($dtoData,$date)
    {
      $dtoData['transaction_type']=Balance::BANK_TRANSACTION;
      $this->createBalanceHistory('withdraw_',$dtoData,$date);
    }

    function createBalanceHistoryForCashDeskDeposit($dtoData,$date)
    {
      $dtoData['transaction_type']=Balance::CASHDESK_TRANSACTION;
      $this->createBalanceHistory('deposit',$dtoData,$date);
    }

     function createBalanceHistoryForCashDeskWithdraw($dtoData,$date)
    {
      $dtoData['transaction_type']=Balance::CASHDESK_TRANSACTION;
      $this->createBalanceHistory('withdraw_',$dtoData,$date);
    }

    //end balance history


    //types of transaction

     function processTransactionForCashDeskDeposit($dtoData)
    {
   
       //cashdesk history
      //status=1 deposit
      // transactionType=0 =>cashHistory
      $dtoData['status']=Balance::DEPOSIT;
      $dtoData['transaction_type']=Balance::CASHDESK_TRANSACTION;

       $this->processCashHistoryTransaction($dtoData);
    }


    function processTransactionForCashDeskWithdraw($dtoData)
    {
       // cashdesk history
      //   status = 2 withdraw
      //   transactionType=0 cashdesk
      $dtoData['status']=Balance::WITHDRAW;
      $dtoData['transaction_type']=Balance::CASHDESK_TRANSACTION;

       $this->processCashHistoryTransaction($dtoData);
    }


    function processTransactionForBankDeposit($dtoData)
    {
      //bank history
      // status = 1 deposit
      // transactionType=1 bank

      $dtoData['status']=Balance::DEPOSIT;
      $dtoData['transaction_type']=Balance::BANK_TRANSACTION;

       $this->processCashHistoryTransaction($dtoData);
    }


    function processTransactionForBankWithdraw($dtoData)
    {
      //bank history
      // status = 2 withdraw
      // transactionType=1 =>bank

      $dtoData['status']=Balance::WITHDRAW;
      $dtoData['transaction_type']=Balance::BANK_TRANSACTION;

       $this->processCashHistoryTransaction($dtoData);
    }

    //end types of transaction


    

     function decreaseBankAmount($balanceAmount,$amountToDecrease,$dtoData)
    {

      if (floatval($balanceAmount) >= $amountToDecrease) {
         
         //reduce
         $currentBalance=floatval($balanceAmount) - floatval($amountToDecrease);
         
         $dtoData['transaction_type']=Balance::BANK_TRANSACTION;
         $this->changeBalanceAmount($dtoData,$currentBalance);

         return true;
      }

    }



    function updateBankAmount($amount,$dtoData)
    {

      DB::table('balances')
          ->where('currency',$dtoData['currency'])
          ->where('transaction_type',$dtoData['transaction_type'])
          ->where('current_shop',$dtoData['current_shop'])
          ->where('host_customer_id',$dtoData['host_customer_id'])
          ->update(['amount'=>$amount]);
    }

     function getCashDeskBalanceHistory($transactionType,$currency,$g)
     {

     $data= DB::table('balance_histories')
      ->where('transaction_type',$transactionType)
      ->where('currency',$currency)
      ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host'])
      ->limit(15)
      ->orderBy('created_at','desc')
      ->get();

      return $data;
    }

     function getCashHistories($g)
     {
       $data = CashHistory::where('current_shop',$g['shop'])
              ->where('host_customer_id',$g['host'])
              ->orderBy('id','desc');

       return $data;
     }

    function getBalanceSolds($g)
    {
      $solds = Balance::where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
        ->get();

      return $solds;
    }


    function returnCashDeskAndBankSolds($g)
    {
       $solds=$this->getBalanceSolds($g);

       if (count($solds) > 0) {
           $data=[
            'usAmount'     => floatval($solds[0]->amount),
            'cdfAmount'    => floatval($solds[1]->amount),
            'bankUsAmount' => floatval($solds[2]->amount),
            'bankCdfAmount'=> floatval($solds[3]->amount)
          ];
        return $data;
       }else{

        return [
            'usAmount'     => 0,
            'cdfAmount'    => 0,
            'bankUsAmount' => 0,
            'bankCdfAmount'=> 0
          ];

        
       }
      

    }

     function getTotalAmountInAndOut($status,$currency,$transactionType,$todayDate,$g)
    {
      $amount=CashHistory::where('status',$status)
        ->where('currency',$currency)
        ->where('transaction_type',$transactionType)
        ->where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host'])
        ->where('created_at',$todayDate)
        ->sum('amount');

      return $amount;

    }


    function returnAmountFromCashDesk($todayDate,$g)
    {

        //cashDesk - dollar : In amount
        $cashDeskAmountInUSD = $this->getTotalAmountInAndOut(1,1,0,$todayDate,$g);
        $cashDeskAmountOutUSD = $this->getTotalAmountInAndOut(2,1,0,$todayDate,$g);

         //cashDesk - CDF : In amount
        $cashDeskAmountInCDF = $this->getTotalAmountInAndOut(1,2,0,$todayDate,$g);
        $cashDeskAmountOutCDF = $this->getTotalAmountInAndOut(2,2,0,$todayDate,$g);

        return [
            'inAmountInUS' => $cashDeskAmountInUSD ,
            'outAmountInUS'=> $cashDeskAmountOutUSD,
            'inAmountInCDF' => $cashDeskAmountInCDF,
            'outAmountInCDF'=> $cashDeskAmountOutCDF
        ];

    }


    function returnAmountFromBank($todayDate,$g)
    {
         //cashDesk - dollar : In amount
        $cashDeskAmountInUSD = $this->getTotalAmountInAndOut(1,1,1,$todayDate,$g);
        $cashDeskAmountOutUSD = $this->getTotalAmountInAndOut(2,1,1,$todayDate,$g);

         //cashDesk - CDF : In amount
        $cashDeskAmountInCDF = $this->getTotalAmountInAndOut(1,2,1,$todayDate,$g);
        $cashDeskAmountOutCDF = $this->getTotalAmountInAndOut(2,2,1,$todayDate,$g);

        return [
            'inAmountInUS' => $cashDeskAmountInUSD ,
            'outAmountInUS'=> $cashDeskAmountOutUSD,
            'inAmountInCDF' => $cashDeskAmountInCDF,
            'outAmountInCDF'=> $cashDeskAmountOutCDF
        ];
    }

  
    

}
<?php  
namespace App\Http\Controllers\Backend\Debt\Dto;

trait DebtDto
{
	

	public function debtDto($fields,$g)
	{
          $fields['transaction_type']=0;
          $fields['status']=1;
          $fields['qty']=0;

	     $data=array(
            'comment'         => $fields['comment'],
            'qty'             => $fields['qty'],
            'currency'        => $fields['currency'],
            'status'          => $fields['status'],
            'transaction_type'=> $fields['transaction_type'],
            'client'          => $fields['client'],
            'accountancy_code'=> $fields['accountancy_code'],
            'current_shop'    => $fields['current_shop'],
            'host_customer_id'=> $fields['host_customer_id']
         );

         return $data;

	}

	            

}
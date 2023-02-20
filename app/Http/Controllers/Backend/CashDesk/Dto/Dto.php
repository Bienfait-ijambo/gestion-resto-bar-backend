<?php  
namespace App\Http\Controllers\Backend\CashDesk\Dto;

trait Dto
{
	

	public function cashHistoryDto($request,$g)
	{
		 $fields=$request->all();
		 $fields['qty']=0;

	    $data=array(
	     	'amount'          => floatval($fields['amount']),
            'comment'         => $fields['comment'],
            'out_qty'         => $fields['qty'],
            'currency'        => $fields['currency'],
            'status'          => $fields['status'],
            'transaction_type'=> intval($fields['transaction_type']),
            'client'		  => $fields['client'],
            'accountancy_code'=> $fields['accountancy_code'],
            'current_shop'    => $g['shop'],
            'host_customer_id'=> $g['host']
		  );

		return $data;

	}

	            

}
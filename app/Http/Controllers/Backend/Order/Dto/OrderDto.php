<?php  
namespace App\Http\Controllers\Backend\Order\Dto;

trait OrderDto
{
	

	public function orderDto($fields,$g)
	{
          
          $comment='';
          if (isset($fields['comment'])) {
                $comment=$fields['comment'];
          }

	    $data=array(
            'comment'         => $comment,
            'currency'        => $fields['currency'],
            'transaction_type'=> intval($fields['transaction_type']),
            'clientType'	  => $fields['clientType'],
            'client_name'	  => $fields['client_name'],
            'accountancy_code'=> $fields['accountancy_code'],
            'payment_type'    => $fields['payment_type'],
            'current_shop'    => $g['shop'],
            'host_customer_id'=> $g['host']
		  );

		return $data;

	}

	            

}
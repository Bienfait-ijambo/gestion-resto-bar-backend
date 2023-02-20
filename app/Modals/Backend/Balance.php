<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class Balance extends Model
{
	const DOLLAR = 1;

	const CDF = 2;

    const BANK_TRANSACTION=1;

    const CASHDESK_TRANSACTION=0;

    const DEPOSIT = 1;

    const WITHDRAW = 2;


    protected $guarded=[];


    public function getCurrencyName($num)
    {
    	$currency=intval($num);

    	if ($currency === self::DOLLAR) 
    		return 'USD';

    	if ($currency === self::CDF) 
    		return 'FRANCS';
    }


}

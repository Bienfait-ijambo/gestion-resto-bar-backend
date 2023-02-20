<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class Orders extends Model
{
	CONST PAYEMENT_TYPES=[
		'CASH'           => 1,
		'MOBILE-MONEY'   => 2,
		'CHEQUE / BANQUE'=> 3,
		'CREDIT'		 => 4,
	];

    protected $guarded=[];
}



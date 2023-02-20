<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class Ticketing extends Model
{

	const CASH_DESK_TRANSACTION_TYPE = 0;

	const DOLLAR_TRANSACTION_TYPE = 1;


    protected $guarded=[];
}

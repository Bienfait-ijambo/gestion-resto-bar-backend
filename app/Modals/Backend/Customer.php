<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class Customer extends Model
{
    protected $guarded=[];

    public function customersFidelity()
    {
        return $this->hasOne(CustomerFidelity::class);
    }
}

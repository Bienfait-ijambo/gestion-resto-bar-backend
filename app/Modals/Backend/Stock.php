<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class Stock extends Model
{
    protected $guarded=[];

     public function product()
    {
        return $this->hasOne(Product::class);
    }
}

<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class Unit extends Model
{
    protected $guarded=[];

     public function unit()
    {
        return $this->hasMany(Product::class);
    }
}

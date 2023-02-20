<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class SelectedProduct extends Model
{
    protected $guarded=[];

    public function products()
    {
        return $this->hasOne(Product::class,'id');
    }
}

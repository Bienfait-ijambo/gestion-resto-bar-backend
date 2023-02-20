<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $guarded=[];

    // protected $table = 'prices';

    public function prices()
    {
        return $this->hasMany(Price::class);
    }

    public function units()
    {
        return $this->hasOne(Unit::class,'id');
    
    }

    public function stock()
    {
        return $this->hasOne(Stock::class);
    }

    public function selectedProducts()
    {
        return $this->hasMany(SelectedProduct::class,'product_id');
    }


}

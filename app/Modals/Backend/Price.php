<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class Price extends Model
{
   protected $guarded=[];

   // protected $table = 'prices';

    public function products()
    {
        return $this->belongsTo(Product::class);
    }
}

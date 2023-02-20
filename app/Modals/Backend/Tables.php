<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class Tables extends Model
{
	 protected $guarded=[];
	 
     public function space()
    {
        return $this->belongsTo(Space::class);
    }
}

<?php

namespace App\Modals\Backend;

use Illuminate\Database\Eloquent\Model;

class Space extends Model
{
	protected $guarded=[];
     public function tables()
    {
        return $this->hasMany(Tables::class);
    }
}

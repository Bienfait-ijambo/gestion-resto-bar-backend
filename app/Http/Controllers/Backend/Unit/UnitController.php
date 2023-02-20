<?php

namespace App\Http\Controllers\Backend\Unit;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Category,Product,Unit};
use App\Traits\GlMethod;
use Validator;
use DB;
class UnitController extends Controller
{
    use GlMethod;


     function index(Request $request)
     {
        $g = $this->globalInput($request);
     	$data =Unit::where('current_shop',$g['shop'])
              ->where('host_customer_id',$g['host'])
              ->orderBy('id','desc')
              ->get();
     	return response(['data'=>$data],200);
     }

   

      
     function store(Request $request)
     {
     	$data=$request->validate([
     		'unit_name'   =>'required',
     		'current_shop'    =>'required',
     		'host_customer_id'=>'required'
     	]);

         // $g = $this->globalInput($request);

        $unitExist = Unit::where('unit_name',$data['unit_name'])
         ->where('current_shop',$data['current_shop'])
        ->where('host_customer_id',$data['host_customer_id'])
        ->first();

        if (is_null($unitExist)) {
           
            $category=Unit::create($data);
            return response([
                'data'   => $category,
                'message'=>'Unité crée avec succès !'
            ],201);

        }
        else
        {
             return response([
                'message'=>'Désolez, ce unité existe '
            ],422);

        }
       

    }

    function edit($id)
    {
        $data=Unit::findOrFail($id);
        return response()->json(['data'=>$data]);
    }

     function update(Request $request)
     {
        Unit::whereId($request->id)
        ->update([
             'unit_name'  => $request->unit_name,
          ]);
                
       return response()->json([ 'success'=>'Edite avec succès.']);  
        
    }
}

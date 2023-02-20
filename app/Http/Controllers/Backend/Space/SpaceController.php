<?php

namespace App\Http\Controllers\Backend\Space;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Product,Stock,Price,Space,Tables};
use App\Traits\GlMethod;
use Validator;
use Image;
use DB;
class SpaceController extends Controller
{
    use GlMethod;

    function store(Request $request)
     {
        $data = $request->all();
        $error = Validator::make($data, ['name' =>  'required']);
        if($error->fails()) {
            return response()->json(['error' => ['Ce champ est requis']]);
        }

        Space::create($data);

        return response(['message' =>'Enregistrement réussi !' ],201);
      
    }

    function edit($id)
    {
        $data=Room::findOrFail($id);
        return response()->json(['data'=>$data]);
    }

    function index(Request $request)
    {
    	$g = $this->globalInput($request);

    	$spaces = Space::with(['tables'])
    	->where('spaces.current_shop',$g['shop'])
        ->where('spaces.host_customer_id',$g['host'])
    	->paginate(20);

    	return response(['data'=>$spaces],200);
    }

     function update(Request $request)
      {
        $data = $request->all();
        $error = Validator::make($data, ['name' =>  'required',]);
        if($error->fails()){
            return response()->json(['error' => $error->errors()->all()]);
        }

        Space::whereId($request->id)
        ->update([
        	'name'=>$data['name'],
        	'current_shop'=>$data['current_shop'],
        	'host_customer_id'=>$data['host_customer_id']
        ]);
                
        return response([ 'message'   =>'Modification effectué avec succès']);  
         
      }

    function attribTableToSpace(Request $request)
    {
 
      $g = $this->globalInput($request);
      $data=$request->all();
      unset($data['space_name']);

      $doesExist=Tables::where('space_id',$request->space_id)
      ->where('name',$request->name)
      ->where('current_shop',$g['shop'])
       ->where('host_customer_id',$g['host'])
      ->first();

      if (is_null($doesExist)) 
      {
        Tables::create($data);
         return response([ 'message'   =>'Enregistrement effectué avec succès']);
      }

    }

    function destroy(Request $request)
    {
     
      Table::where('id',intval($request->id))->delete();
    }
}

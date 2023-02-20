<?php

namespace App\Http\Controllers\Backend\Category;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Category,Product};
use App\Traits\GlMethod;
use Validator;
use DB;
class CategoryController extends Controller
{
    use GlMethod;


     function index(Request $request)
     {
     	$g = $this->globalInput($request);
        $data =Category::where('current_shop',$g['shop'])
              ->where('host_customer_id',$g['host'])
              ->orderBy('id','desc')
              ->get();

     	return response(['data'=>$data],200);
     }

     function paginatedCategory(Request $request)
     {
        $query=$request->get('query');
        $trimQuery=str_replace(" ", "%", $query);
        
        $g = $this->globalInput($request);

        $data=DB::table('categories')
        ->where('current_shop',$g['shop'])
        ->where('host_customer_id',$g['host']);

        if ($query != '') 
        {
        	$data->where('category_name','like','%'.$trimQuery.'%')
        	->orderBy('category_name','desc');

        	return $this->apiData($data->paginate(10));
        }
        	return $this->apiData($data->paginate(10));

     }

      
     function store(Request $request)
     {
     	$data=$request->validate([
     		'category_name'   =>'required',
     		'current_shop'    =>'required',
     		'host_customer_id'=>'required'
     	]);

        $categoryExist = Category::where('category_name',$data['category_name'])
        ->where('current_shop',$data['current_shop'])
        ->where('host_customer_id',$data['host_customer_id'])
        ->first();

        if (is_null($categoryExist)) {
           
            $category=Category::create($data);
            return response([
                'data'   => $category,
                'message'=>'Categorie crée avec succès !'
            ],201);

        }
        else
        {
             return response([
                'message'=>'Désolez, ce categorie existe '
            ],422);

        }
       

    }

    function edit($id)
    {
        $data=Category::findOrFail($id);
        return response()->json(['data'=>$data]);
    }

     function update(Request $request)
     {
        Category::whereId($request->id)
        ->update([
             'category_name'  => $request->category_name,
          ]);
                
        return response([
                'message'=>'Categorie modifie avec succès'
            ],200); 
        
    }
}

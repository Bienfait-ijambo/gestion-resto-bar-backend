<?php

namespace App\Http\Controllers\Backend\CodeOhada;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{CodeOhada};
use App\Traits\GlMethod;
use Validator;
use DB;
use PDF;

class CodeOhadaController extends Controller
{
    use GlMethod;


    function index(Request $request)
    {
       $g = $this->globalInput($request);
       $query=$request->get('query');
       $trimQuery=str_replace(" ", "%", $query);

       $data = DB::table('code_ohadas')->where('host_customer_id',$g['host']);

        if ($query != '')  {
          $data->where('code','like','%'.$trimQuery.'%')
          ->orWhere('name','like','%'.$trimQuery.'%')
          ->orderBy('name','asc');

          return $this->apiData($data->paginate(10));
        }
          return $this->apiData($data->paginate(10));
    }



    public function store(Request $request)
    {

       // $g = $this->globalInput($request);
       $data=$request->all();
       $customer = CodeOhada::create($data);

       return response([
        'data'      =>$customer,
        'message'   =>'Félicitation, Enregistrement réussi.'
       ],200);
       
    }

    public function destroy(Request $request)
     { 

       CodeOhada::where('id',$request->id)->delete(); 
        return response([
        'message'   =>'Suppression réussi '
       ],200);
       
     }



    public function update(Request $request)
    {

        CodeOhada::whereId($request->id)
         ->update([
          'code'        => $request->code,
          'name'       => $request->name,
       ]);
                
       return response([
        'message'   =>'Félicitation, Modification effectuée avec succès'
       ],200);  
        
    }


}

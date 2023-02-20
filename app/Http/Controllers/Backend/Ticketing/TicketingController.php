<?php

namespace App\Http\Controllers\Backend\Ticketing;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Ticketing,Balance};
use App\Traits\GlMethod;
use Validator;
use DB;
class TicketingController extends Controller
{
	use GlMethod;

     function store(Request $request)
     {
     	$data=$request->all();

     	$data['transaction_type']=Ticketing::CASH_DESK_TRANSACTION_TYPE;

     	Ticketing::create($data);
     	return response([ 'message'=>'Cette opération a été enregistrée avec succès'],200);

     }


      function getTicketings(Request $request)
      {
        $g = $this->globalInput($request);

        $transactionType=Ticketing::CASH_DESK_TRANSACTION_TYPE;

        $currencies = [Balance::DOLLAR,Balance::CDF];

        $data = Ticketing::where('transaction_type',$transactionType)
         ->whereIn('currency',$currencies)
         ->where('current_shop',$g['shop'])
         ->where('host_customer_id',$g['host']);

         return $this->apiData($data->paginate(10));
      }


     public function destroy(Request $request)
     { 

       Ticketing::where('id',$request->id)->delete(); 
        return response([
        'message'   =>'Suppression réussi !'
       ],200);
       
     }



}

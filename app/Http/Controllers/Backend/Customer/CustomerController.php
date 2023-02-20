<?php

namespace App\Http\Controllers\Backend\Customer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modals\Backend\{Category,Product,Customer,Orders,SelectedProduct};
use App\Http\Controllers\Backend\Report\Traits\ReportHelper;
use App\Http\Controllers\Backend\Settings\Traits\SettingHelper;
use App\Traits\GlMethod;
use Validator;
use DB;
use PDF;
class CustomerController extends Controller
{
     use GlMethod,SettingHelper,ReportHelper;
     //start here
    function index(Request $request)
    {
       $g = $this->globalInput($request);
       $query=$request->get('query');
       $trimQuery=str_replace(" ", "%", $query);

       $data = Customer::with(['customersFidelity'])
      ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host']);

        if ($query != '')  {
          $data->where('name','like','%'.$trimQuery.'%')
          ->orderBy('name','asc');

          return $this->apiData($data->paginate(10));

        }
          return $this->apiData($data->paginate(10));
    }




    function customerNameAndId(Request $request)
    {
      $query=$request->get('query');
      $trimQuery=str_replace(" ", "%", $query);

      $g = $this->globalInput($request);

      $data=DB::table('customers')
      ->select('id','name','type')
      ->where('current_shop',$g['shop'])
      ->where('host_customer_id',$g['host']);

        if ($query != '')  {
          $data->where('name','like','%'.$trimQuery.'%')
          ->orderBy('name','asc');

          return $this->apiData($data->paginate(7));
        }
          return $this->apiData($data->paginate(7));
    }

    function getCustomerOrders($clientId,$g)
    {
    	$data = Orders::where('client_id',$clientId)
    	  ->where('current_shop',$g['shop'])
	      ->where('host_customer_id',$g['host'])
	      ->select('client_name','id')
	      ->get();


	   $orderIds=[];
	   $clientName='';

	      foreach ($data as $row) {
	      		array_push($orderIds, $row->id);
	      		$clientName =$row->client_name;
	      }

	    return [$orderIds,$clientName];
    }

  


    function printBoughtProductsBuyCustomer(Request $request)
    {
    	$g = $this->globalInput($request);
         
       
        $settings=$this->getSettingInfo($g);
        $pic=$this->displayImg('logo.png');
        $clientId=$request->client_id;
        $orderIds=$this->getCustomerOrders($clientId,$g);
  
        $data=DB::table('selected_products as s')
        ->join('products','s.product_id','=','products.id')
        ->select('products.name','s.product_qty','s.product_price','s.created_at')
        ->whereIn('last_order_id',$orderIds[0])
        ->get();

        $output='';
     
        $output.='<div align="center"> 
        <img src="'.$pic.'"  width="75" style="margin-top:-45px;" /><br/>';

        $output.='<span style="font-size:20px;"> <b>'.$settings->name.'</b></span><br/>';
        $output.='<span>Email : <a href="#">'.$settings->email.'</a><br/> Tel : '.$settings->telephone.'</span><br/><br/>';

        $output.='</div><hr/>';

        $output.='<b>CLIENT : '.$orderIds[1].'</b>';

        $output.='<table  cellpadding="5" cellspacing="0" border="1" width="520" >
            
            <tr style="font-weight:bold;">
                 <td>N°</td>
                 <td>DATE</td>
                 <td>ARTICLE</td>
                 <td>QTE</td>
                 <td>PRIX</td>
                 <td>TOTAL</td>
            </tr> ';

      $count=1;
      $total=0;

       foreach ($data as $row) 
       {

       	$subTotal=floatval($row->product_qty) * floatval($row->product_price);
       	$total+=$subTotal;

           $output.='
             <tr >
                 <td>'.$count++.'</td>
                 <td>'.$this->f_date($row->created_at).'</td>
                 <td>'.$row->name.'</td>
                 <td>'.$row->product_qty.'</td>
                 <td>'.$row->product_price.'</td>
                 <td>'.$subTotal.'</td>
             </tr>';
       }
       $output.='<tr>
                 <td colspan="5"></td>
                 <td>'.$total.' USD</td>
             </tr>';


       $output.='</table><br/>';

       $gainPercent = floatval($settings->customer_gain);
          
          
      $output.='
        <table cellpadding="2" cellspacing="0" border="1" width="250">
             <tr>
               <td>BONUS CLIENT :  '.(($gainPercent * floatval($total))).' USD</td>
             </tr>
        </table>';

        $pdf = \App::make('dompdf.wrapper')
             ->loadHTML($output)
            ->setPaper('a4', 'portrait');
        return $pdf->stream();
      
    }

    

 

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {

       // $g = $this->globalInput($request);
       $data=$request->all();
       unset($data['id'],$data['customers_fidelity']);

       $customer = Customer::create($data);

       return response([
        'data'      =>$customer,
        'message'   =>'Félicitation, Enregistrement réussi.'
       ],200);
       
    }

    public function edit($id)
    {
        $data=Customer::findOrFail($id);
        return response()->json(['data'=>$data]);
        
    }


     public function destroy(Request $request)
     { 

       Customer::where('id',$request->id)->delete(); 
        return response([
        'message'   =>'Suppression réussi '
       ],200);
       
     }



    public function update(Request $request)
    {

        Customer::whereId($request->id)
         ->update([
          'name'        => $request->name,
          'email'       => $request->email,
          'telephone'   => $request->telephone,
       ]);
                
       return response([
        'message'   =>'Félicitation, Modification effectuée avec succès'
       ],200);  
        
    }
}

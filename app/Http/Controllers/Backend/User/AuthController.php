<?php

namespace App\Http\Controllers\Backend\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use Illuminate\Support\Facades\Hash;
use App\Traits\GlMethod;
use Auth;
use DB;
class AuthController extends Controller
{
     use GlMethod;

    private $secretKey='X.XSJDLKStQBDyw1nIePtYNn3988983t3yBeYCnvG8OxzZ9989I8u+Rq0r0=';

    function index(Request $request)
    { 
         $g = $this->globalInput($request);
         $userType=$request->user_type;
         $hostUser=$request->host_user;

         $data = DB::table('users')
         ->select('id','name','email','type','image');


         if ($userType=='SUPERUSER') {

            if (!is_null($hostUser) && $hostUser!='') {
               $data->where('host_customer_id',intval($hostUser));
            }else{
                $data->where('current_shop',$g['shop'])
                ->where('host_customer_id',$g['host']); 
            }

            
         }else{

            $data->where('host_customer_id',intval($g['host']));
         }

    
        if($request->query!='') 
        {
            $query=$this->Gquery($request);
            $data->where('name','like','%'.$query.'%')
            ->orderBy('id','desc');
            return $this->apiData($data->paginate(10));
        }
           return $this->apiData($data->paginate(10));

    }

     public function store(Request $request) 
     {
        $g = $this->globalInput($request);
       
        $fields = $request->validate([
            'name'               => 'required|string',
            'type'               => 'required|string',
            'email'              => 'required',
            'password'           => 'required|string',
            'secondary_currency' => 'required',
            'main_currency'      => 'required',
        ]);



        $getUser = $this->selectUser($fields['email']);

        if (!is_null($getUser)) 
            return response(['message' => "Cet adresse mail existe !" ], 422);

        $fields['password']=bcrypt($fields['password']);
        $fields['current_shop']=$g['shop'];
        $fields['host_customer_id']=$g['host'];
        $fields['app_level']=0;


        $user = User::create($fields);

         $token = $user->createToken($this->secretKey)->plainTextToken;
        return response([
            'message' => "Utilisateur crée avec succès !",
            'user' => $user,
            'token' => $token
        ], 201);
    }


    public function login(Request $request) 
    {
        $fields = $request->validate([
            'email' => 'required|string',
            'password' => 'required|string'
        ]);

        // Check email
        $user = $this->selectUser($fields['email']);

        // Check password
        if(!$user || !Hash::check($fields['password'], $user->password)) {
            return response([
                'message' => 'Password or Email invalid',
                'isLogged'   => false
            ], 401);
        }

        $token = $user->createToken($this->secretKey)->plainTextToken;

        return response([
            'user' => $user,
            'token' => $token,
            'isLogged'   => true
        ], 201);
    }


    function selectUser($email)
    {
       $user = User::where('email',$email)->first();
       return $user;
    }

    public function logout(Request $request) 
    {
         if ($request->user()) { 
             $request->user()->tokens()->delete();
            // $request->user()->tokens()->where('id', 1)->delete();
          }
        return response([
            'message' => 'Logged out'
        ],200);

    }

    function update(Request $request)
    {
        $g = $this->globalInput($request);
       
        $fields = $request->validate([
            'name' => 'required|string',
            'type' => 'required|string',
            'email' => 'required',
            'password' => 'required|string',

        ]);
        User::where('id',$request->id)
        ->update([
            'name'  => $request->name,
            'email' => $request->email,
            'type'  => $request->type,
            'password' => bcrypt($request->password)
        ]);
        return response(['message'=>'Utilisateur modifier avec succès ! '],200);

    }

    // function editPhoto(Request $request)
    // {
    //     $imageName=$this->uploadImage($request);

    //     if (is_string($imageName)) 
    //     {
    //         User::where('id',$request->userId)
    //         ->update(['photo' =>$imageName]);

    //       return response([
    //         'message' =>'Photo ajouté avec succès',
    //         'imageName'   =>$imageName
    //       ],200);
    //     }else{
    //         return response(['data'   =>$imageName->original]);
    //     }    
    // }

    function destroy($id)
    {
        User::where('id',$id)->delete();
        return response(['message'=>'User deleted successfully ! '],200);
    }
}

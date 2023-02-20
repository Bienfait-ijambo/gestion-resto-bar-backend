<?php

namespace App\Http\Controllers\Backend\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use App\Modals\Backend\{UserRole,Role};
use Illuminate\Support\Facades\Hash;
use App\Traits\GlMethod;
use Auth;
use DB;
class RoleController extends Controller
{

	function index()
	{
		$roles=Role::all();
		return response(['data'=>$roles]);
	}

    function store(Request $request)
    {
    	$roles=['SUPERADMIN','ADMIN','SOUS-ADMIN','USER'];
    }

    /*
    APP : rules
    ---------------------------------------------------------
    ---------------------------------------------------------

    [SUPER ADMIN] : all pages
    [ADMIN] : access-one or more level + all pages
    [USER] : ACCESS SOME PAGE

    [
      {
		id:1,
		user_id:
		role
      }
    ]
	
  	[SUPERADMIN] : all-levels+shops+actions+pages

    [ADMIN]: user_shop_to_acess, + somes pages + all-actions: table,

    [USER] : user_shop_to_acess + user_page_to_access +  some_actions : table,


    user-shop-level-to-aces

    user-page-to-pages-to-access

    user-action-to-make

    Tables : 
    -----------------------------------------------------
     app_client_pages : []
	   user-roles   [SUPERADMIN, ADMIN, USER]
     user-actions [READ,UPDATE,DELETE,CREATE],
     user-shop-to-access   []
     user-page-to-access   []
     user-actions-to-make   [INSERT,UPDATE,DELETE]
    */
}

<?php

namespace App\Http\Controllers\Backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class CheckInternetStatusController extends Controller
{
    function checkInternet(Request $request)
    {
    	return response(['status'=>true]);
    }
}

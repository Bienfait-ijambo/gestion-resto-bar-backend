<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/



Route::group(['namespace'=>'Backend'],function(){

  Route::group(['namespace'=>'Report'],function(){

  	Route::get('/print_bill','ReportController@printBill');
  	Route::get('/print_purchase_order','ReportController@printPurchaseOrder');
  	Route::get('/print_cash_report','ReportController@printCashReport');
  	Route::get('/generate_supply_report','ReportController@generateSupplyReport');
  	Route::get('/print_debts','ReportController@generateDebtReport');
    Route::get('/print_customers','ReportController@generateCustomerlist');

  });


   Route::group(['namespace'=>'Customer'],function(){

  	Route::get('/print_bought_products','CustomerController@printBoughtProductsBuyCustomer');

  });

    
});



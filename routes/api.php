<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::group(['namespace'=>'Backend'],function(){

  Route::group(['namespace'=>'User'],function(){

		Route::post('/login','AuthController@login')->name('login');
  });

});


Route::group(['middleware' => ['auth:sanctum']], function () {

  Route::group(['namespace'=>'Backend'],function(){

		
		
		Route::group(['namespace'=>'User'],function(){

			Route::post('/users','AuthController@store');
			Route::get('/users','AuthController@index');
			// Route::post('/users/image','AuthController@editPhoto');
			Route::post('/logout','AuthController@logout');
			Route::put('/users','AuthController@update');
			Route::delete('/users/{id}','AuthController@destroy');

		});


		Route::get('/shops','HasShopController@index');


		Route::group(['namespace'=>'Category'],function(){

			Route::get('/categories','CategoryController@index');
			Route::post('/categories','CategoryController@store');
			Route::put('/categories','CategoryController@update');	
		});


		Route::group(['namespace'=>'Unit'],function(){

			 Route::get('/units','UnitController@index');
		     Route::post('/units','UnitController@store');
		     Route::put('/units','UnitController@update');

		});

		
		Route::group(['namespace'=>'Ticketing'],function(){

			Route::post('/ticketings','TicketingController@store');
			Route::get('/ticketings','TicketingController@getTicketings');
			Route::delete('/ticketings/{id}','TicketingController@destroy');

		});


		Route::group(['namespace'=>'CodeOhada'],function(){

			Route::get('/code_ohadas','CodeOhadaController@index');
			Route::post('/code_ohadas','CodeOhadaController@store');
			Route::put('code_ohadas','CodeOhadaController@update');
			Route::delete('code_ohadas/{id}','CodeOhadaController@destroy');
		  
		});


		Route::group(['namespace'=>'Customer'],function(){

			Route::get('/customers','CustomerController@index');
			Route::post('/customers','CustomerController@store');
			Route::put('customers','CustomerController@update');
			Route::delete('customers/{id}','CustomerController@destroy');
			Route::get('/customers/get_name_id','CustomerController@customerNameAndId');
		  
		});

		

	   Route::group(['namespace'=>'CashDesk'],function(){

		    Route::get('/cashdesks','CashDeskController@index');
			Route::get('/get_today_from_cashdesk','CashDeskController@getTodayTotatAmountFromCashDesk');
			Route::get('/get_today_from_bank','CashDeskController@getTodayTotatAmountFromBank');
		    Route::post('process_cashdesk_transaction','CashDeskController@processCashDeskTransaction');
		    Route::post('process_bank_transaction','CashDeskController@processBankTransaction');
		    Route::get('/cash_desk_amount','CashDeskController@getCashDeskAmount');
		    Route::get('/sold_history','CashDeskController@CashDesksoldHistory');
		    Route::get('/bank_sold_history','CashDeskController@BankSoldHistory');
		    Route::delete('cashdesks/{id}','CashDeskController@destroy');

		  
		});

	   Route::group(['namespace'=>'Product'],function(){

		   Route::post('/products','ProductController@store');
		   Route::put('/products','ProductController@update');
		   Route::get('/products','ProductController@index');
		   Route::delete('products/{id}','ProductController@destroy');
		   Route::get('/count_products','ProductController@countProduct');
		   Route::get('/product_stock_alerts','ProductController@makeAlertStock');
		   Route::get('/count_stock_alerts','ProductController@countStockAlertProducts');
		   Route::get('/expired_products','ProductController@getExpiredProducts');
  
		});


	  
		Route::group(['namespace'=>'Settings'],function(){

		  Route::get('pricesettings','SettingController@index');
	   	  Route::get('customerinfos','SettingController@settingInfo');
	   	  Route::post('save_customerInfo','SettingController@store');
	   	  Route::post('/init_working_space','SettingController@initCustomerWorkingSpace'); 
		  
		});


		Route::group(['namespace'=>'Price'],function(){

		   Route::get('prices','PriceController@productPrices');
	       Route::delete('/prices/{id}','PriceController@deletePrice');
	       Route::post('prices','PriceController@addPrice');
		  
		});


		Route::group(['namespace'=>'Supply'],function(){
		   
		    Route::post('/supply_stock','SupplyController@store');
	   		Route::get('/stock_histories','SupplyController@stockHistory');
	   		
		  
		});


	  

	   Route::get('/sales','SalesController@index');


	   Route::get('/out_product_qties','OutProductQtyController@index');
	   Route::post('/out_product_qties','OutProductQtyController@store');

	   

	   Route::group(['namespace'=>'Order'],function(){
	   	
	 	   Route::post('/orders','OrderController@createOrder');
		   Route::get('/last_order','OrderController@getLastOrders');
		   Route::post('/add_product_to_cart','OrderController@addProductToCurrentOrder');
		   Route::get('/products_added_to_cart','OrderController@getOrderItems');
		   Route::get('/remove_product_to_order','OrderController@removeProductFromOrder');
		   Route::post('/validate_order','OrderController@validateOrders');
		   Route::get('/display_orders','OrderController@displayOrder');
		   Route::get('/order_users','OrderController@orderModalUsers');
		   Route::post('/change_command_status','OrderController@changeCommandStatus');
		   Route::get('/cancel_command','OrderController@cancelCommand');
		   Route::post('/update_order_qty','OrderController@updateOrderQty');
		   Route::get('/mark_as_finished','OrderController@completedAnOrder'); 
		  
		});


		Route::group(['namespace'=>'Space'],function(){
		   
		   Route::get('/spaces','SpaceController@index');
		   Route::post('/spaces','SpaceController@store');
		   Route::put('/spaces','SpaceController@update');
		   Route::post('/attrib_table_to_space','SpaceController@attribTableToSpace');
		  
		});



	   Route::get('/check_internet_connection','CheckInternetStatusController@checkInternet');



	   Route::group(['namespace'=>'YMCustomer'],function(){
		   
		   Route::get('/ymcustomers','YmCustomerController@index');
		   Route::post('/ymcustomers','YmCustomerController@store');
		   Route::get('/customers_shops','YmCustomerController@getCustomerShops');
		   Route::get('/user_shops','YmCustomerController@getShopsAttribToUser');
		   Route::post('/select_shops','YmCustomerController@selectOrChangeShop');
		   Route::post('/create_user_shop','YmCustomerController@createUserShop');
		  
		});


	   Route::group(['namespace'=>'Debt'],function(){
		   
		   Route::get('/debts','DebtController@AllDebt');
	       Route::post('/debts','DebtController@store');
	       Route::get('/debts/count','DebtController@countDebts');    
		  
		});



	});
		
});
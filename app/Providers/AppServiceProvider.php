<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\View;
class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        View::composer(['errors*','views*'],function($view){


             $proMail ='';
             $standardMail ='';
             $view->with('app_name','YOUNG-MASTER CORPORATION');//
  
             //mailDev
             $view->with('proMail',$proMail);
             $view->with('standardMail',$standardMail);
  
         });
    }
}

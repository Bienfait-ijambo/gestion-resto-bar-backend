<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSupplyStocksTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
       
        Schema::create('supply_stocks', function (Blueprint $table) {
            $table->id();
            $table->integer('product_id');
            $table->string('provider_name')->nullable();
            $table->string('provider_telephone')->nullable();
            $table->string('product_price')->nullable();
            $table->integer('product_qty');
            $table->string('total_price');
            $table->text('comment')->nullable();
            $table->integer('current_shop');
            $table->integer('host_customer_id');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('supply_stocks');
    }
}

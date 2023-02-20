<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCashHistoriesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('cash_histories', function (Blueprint $table) {
            $table->id();
            $table->string('amount');
            $table->text('comment');
            $table->integer('out_qty');
            $table->integer('currency');
            $table->integer('status');
            $table->integer('transaction_type');
            $table->string('accountancy_code')->nullable();
            $table->string('client')->nullable();
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
        Schema::dropIfExists('cash_histories');
    }
}

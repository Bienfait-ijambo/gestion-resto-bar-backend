<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrdersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('client_name');
            $table->integer('client_id');
            $table->integer('count_product');
            $table->integer('status');
            $table->integer('space_id');
            $table->integer('table_id');
            $table->integer('is_deletable');
            $table->integer('payment_type');
            $table->integer('user_id');
            $table->string('start_date')->nullable();
            $table->string('end_date')->nullable();
            $table->text('comment')->nullable();
            $table->integer('hidden_row_status');
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
        Schema::dropIfExists('orders');
    }
}

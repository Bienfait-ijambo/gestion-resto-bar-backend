<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSettingsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        // (name,email,telephone,customer_gain,vat,rate,logo)
        Schema::create('settings', function (Blueprint $table) {
            $table->id();
            $table->string('name',200);
            $table->string('email',200);
            $table->string('telephone',200);
            $table->string('customer_gain',200)->nullable();
            $table->string('vat',200)->nullable();
            $table->string('rate',200)->nullable();
            $table->string('logo',200)->nullable();
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
        Schema::dropIfExists('settings');
    }
}

<?php

namespace App\Exports\CashDesk;

use App\Modals\Backend\{Category,Product,Balance,CashHistory};
use  App\Http\Controllers\Backend\Report\Repo\ReportRepo;
use App\Traits\GlMethod;
use Validator;
use DB;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
class CashDeskExport implements FromCollection,WithHeadings,ShouldAutoSize
{

	use ReportRepo;

	private $reportTitleInfo;

	private $transactionType;

	private $g; //glogal input field

	public function __construct($reportTitleInfo,$transactionType,$g)
	{
		$this->reportTitleInfo=$reportTitleInfo;

		$this->transactionType=$transactionType;

		$this->g=$g;

	}

    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        return $this->getExcelData($this->reportTitleInfo,$this->transactionType,$this->g);
    }



     public function headings(): array
    {
      
        return [
        	'ID',
            'DATE',
            'CODE-OHADA',
            'LIBELLE',
            'TIERS',
            'QUANTITE',
            'MONTANT',
            'DEVISE',
            'MOUVEMENT [ENTRE et SORTIE]',
            'TYPE DE TRANSACTION',
            'CODE-PROJET',
            'NOM-PROJET',

        ];
    }

 

}

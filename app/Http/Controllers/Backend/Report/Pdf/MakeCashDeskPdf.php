<?php 


namespace App\Http\Controllers\Backend\Report\Pdf;

use App\Traits\GlMethod;
use App\Http\Controllers\Backend\Report\Traits\ReportHelper;
use App\Http\Controllers\Backend\Report\Repo\ReportRepo;
use App\Http\Controllers\Backend\Report\Pdf\concerns\ReportHeader;
use App\Modals\Backend\{Balance};
use PDF;
class MakeCashDeskPdf extends ReportHeader
 {

  use GlMethod,ReportHelper,ReportRepo;

  private $setting;

  private $logo;

  private $pdfData;

  private $reportTitleInfo=[];

  private $transactionType;

  private $g;//global input field

  private $currencyName='';


  public function __construct($setting,$logo,$pdfData,$reportTitleInfo,$transactionType,$g)
  {
    $this->setting=$setting;

    $this->logo=$logo;

    $this->pdfData=$pdfData;

    $this->reportTitleInfo=$reportTitleInfo;

    $this->transactionType=$transactionType;

    $this->g=$g;

    $this->currencyName=$this->getCurrency($reportTitleInfo['currency']);

  }


 

  
  public function generate()
  {
     
        $output='';
        
      $output.='<div align="center" >';
     
        $output.=$this->makeReportHeader($this->logo,$this->setting);

     

        $output.=$this->displayReportTitleInfo();

        $output.='<table align="center"   cellpadding="7" cellspacing="0" border="1" width="750" >
            
            <tr  style="font-weight:bold;background-color:#ccc;">
                 <td>N째</td>
                 <td>DATE</td>
                 <td>CODE</td>
                 <td>LIBELLE</td>
                 <td>TIERS</td>
                 <td>QTE</td>
                 <td>ENTREE</td>
                 <td>SORTIE</td>
            </tr> ';

      $count=1;
      $total_qty=0;
      $total_debit=0;
      $total_credit=0;

       foreach ($this->pdfData as $row) 
       {
        $debit=$this->displayDebit($row->status,$row->amount);
        $credit=$this->displayCredit($row->status,$row->amount);

         $total_qty +=floatval($row->out_qty);
         $total_debit+=floatval($debit);
         $total_credit+=floatval($credit);


           $output.='
           <tr '.$this->coloredRow($row->status).'>
                 <td>'.$count++.'</td>
                 <td>'.$this->f_date($row->created_at).'</td>
                 <td>'.$row->accountancy_code.'</td>
                 <td>'.$row->comment.'</td>
                 <td>'.$row->client.'</td>
                 <td>'.$row->out_qty.'</td>
                 <td>'.$this->formatNumber($debit).'</td>
                 <td>'.$this->formatNumber($credit).'</td>
           
             </tr>';
       }

       $output.=' <tr >
                 <td colspan="4">Total</td>
                 <td></td>

                 <td>'.$this->formatNumber($total_qty).'</td>
                 <td>'.$this->formatNumber($total_debit).'</td>
                 <td>'.$this->formatNumber($total_credit).'</td>
            
             </tr>';

       $output.='</table><br/>';


       $output.='<table  cellpadding="5" cellspacing="0" border="1" width="520" >
            
            <tr style="font-weight:bold;background-color:#ccc;">
                 <td></td>
                 <td>SOLDE</td>
            </tr>';

               


      $totalBalanceAmount= $this->returnTotalBalance($this->reportTitleInfo['currency'],$this->transactionType,$this->g);

        $output.=' 
        <tr style="font-weight:bold;font-size:20px;">
            <td>SOLDE INITIAL</td>
            <td> <span i>'.$this->getPastDateBalance($this->reportTitleInfo['currency'],$this->transactionType,$this->g).'</span> '.$this->currencyName.'</td>
        </tr>
        <tr style="font-weight:bold;font-size:20px;">
            <td>SOLDE ACTUEL</td>
            <td> <span id="sold_to_format">'.$this->formatNumber($totalBalanceAmount).'</span> '.$this->currencyName.'</td>
        </tr>
        ';
          $output.='</table><br/>';

          $output.=$this->makeTicketingReport($totalBalanceAmount);

           $output.='</div>';
           
           return $output;

        //      $pdf = \App::make('dompdf.wrapper')
        //      ->loadHTML($output)
        //      ->setPaper('a4', 'portrait');
        //   return $pdf->stream();

  }

    private function setReportName()
    {
      $reportName =( $this->transactionType==0 ? 'CAISSE':'BANQUE');
      return $reportName;
    }


    private function displayReportTitleInfo()
    {
       $data=$this->reportTitleInfo;


       if (!is_null($data['startDate']) && !is_null($data['endDate'])) 
      {
        
        return $output='<span style="font-size:18px;font-weight:bold;">RAPPORT  '.$this->setReportName().' EN '.$this->currencyName.' DU '.$this->f_date($data['startDate']).'-'.$this->f_date($data['endDate']).' </b></span><br/><br/>';
      }
      else
      {
          return $output='<span style="font-size:18px;font-weight:bold;">RAPPORT  '.$this->setReportName().' '.$this->currencyName.' DU '.$this->f_date($data['currentDate']).' </b></span><br/><br/>';
      }
    }


    private function displayDebit($status,$amount)
    {
        return (intval($status)=== 1) ? $amount : 0;
    }

    private function displayCredit($status,$amount)
    {
        return (intval($status) === 2) ? $amount : 0;
    }

 
    private function coloredRow($status)
    {
        if (intval($status)===2) 
         return 'style="background-color:#dba8a8d4;"';
    }



    private function executeTicketing()
    {

      $data=$this->reportTitleInfo;

      if (!is_null($data['startDate']) && !is_null($data['endDate'])) {

        return $this->getFromDateToDateTicketing($data['currency'],$this->transactionType,$data['startDate'],$data['endDate'],$this->g);

        }
        else
        {
           return $this->getDateTicketing($data['currency'],$this->transactionType,$data['currentDate'],$this->g);

        }
    }


    private function makeTicketingReport($totalBalanceAmount)
    {

       $data=$this->executeTicketing();


       $output='<table  cellpadding="5" cellspacing="0" border="1" width="300" >

            <tr style="font-weight:bold;background-color:#ccc;">
                 <td></td>
                 <td colspan="3">BILLETAGE</td>
            </tr>

            <tr style="font-weight:bold;">
                 <td>N째</td>
                 <td>MONTANT en '.$this->currencyName.' </td>
                 <td>NOMBRE</td>
                 <td>TOTAL</td>
            </tr> ';

       $count=1;

       $total=0;

       foreach ($data as $row) 
       {

        $totalAmountRow=floatval($row->amount)*floatval($row->bill_number);
        
        $total+=$totalAmountRow;
        
           $output.='
           <tr>
                 <td>'.$count++.'</td>
                 <td>'.$row->amount.'</td>
                 <td>'.$row->bill_number.'</td>
                 <td>'.$totalAmountRow.'</td>
             </tr>';
       }

        $output.='
              <tr>
                 <td colspan="3"></td>
                 <td>'.$this->formatNumber($total).' '.$this->currencyName.'</td>
             </tr>
              <tr>
                 <td colspan="3">MENTION</td>
                 <td>'.(floatval($totalBalanceAmount) == floatval($total) ? 'VRAI': 'FAUX').'</td>
             </tr>';


       $output.='</table>';

       return $output;
        
    }

 }
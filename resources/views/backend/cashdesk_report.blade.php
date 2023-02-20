<!DOCTYPE html>
<html>
<head>
	<title></title>
</head>
<body>

	<table>
    <thead>
    <tr>
        <th>Name</th>
        <th>Email</th>
    </tr>
    </thead>
    <tbody>
    @foreach($invoices as $invoice)
        <tr>
            <td>{{ $invoice->name }}</td>
            <td></td>
        </tr>
    @endforeach
    </tbody>
</table>


</body>
</html>
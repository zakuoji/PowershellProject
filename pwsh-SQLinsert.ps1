$constr = "DBの接続文字列"
# DBの接続文字列をコピペ↑

# SQL Serverを使用
$con = New-Object -TypeName System.Data.SqlClient.SqlConnection;

$con.ConnectionString = $constr;

#テーブル名のレコードを指定
$sql = @"
INSERT INTO table(
    Record1,
    Record2
) VALUES (
    @Record1,
    @Record2
);
"@

# レコード名を入力
$rec1 = Read-Host "Record1?"
$rec2 = Read-Host "Record2?"

try {
    $con.Open()
    $transaction = $con.BeginTransaction()

    $cmd = $con.CreateCommand()
    $cmd.Connection = $con
    $cmd.Transaction = $transaction
    $cmd.CommandText = $sql


    # NVARCHAR型で出力
    $sqlparam1 = New-Object Data.SqlClient.SqlParameter("@Username", [Data.SQLDBType]::NVARCHAR, -1)
    $cmd.Parameters.Add($sqlparam1).Value = $rec1

    $sqlparam2 = New-Object Data.SqlClient.SqlParameter("@Password", [Data.SQLDBType]::NVARCHAR, -1)
    $cmd.Parameters.Add($sqlparam2).Value = $rec2

    # パラメータクエリー
    $cmd.Prepare()

    # 実行
    $cmd.ExecuteNonQuery()

    # コミット
    $transaction.Commit()


} catch {
    Write-Error $_.Exception.ToString()
} finally {
    $con.Close()
    $con.Dispose()
}
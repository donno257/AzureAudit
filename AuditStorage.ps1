$StorageAccounts = Get-AzureRmStorageAccount

$blobs = foreach ($StorageAccount in $StorageAccounts)
    {
        $SourceContext = $StorageAccount.Context
        $containers = Get-AzureStorageContainer -Context $StorageAccount.Context

        foreach ($container in $containers)
    {
$conblobs = Get-AzureStorageBlob -Container $container.Name -Context $StorageAccount.Context
foreach ($conblob in $conblobs)
    {
        [int]$BlobSize = $conblob.Length / 1024 / 1024 / 1024
        [pscustomobject]@{
        SANAme = $StorageAccount.StorageAccountName
        SAType = $StorageAccount.AccountType
        SABlobEndpoint = $StorageAccount.Context.BlobEndPoint
        SATableEndPoint = $StorageAccount.Context.TableEndPoint
        SAQueueEndpoint = $StorageAccount.Context.QueueEndPoint
        SAContainerName = $container.Name
        BlobName=$conblob.Name
        BlobSize =$BlobSize
        BlobType = $conblob.BlobType
        Bloburi = $StorageAccount.Context.BlobEndPoint + $container.Name + $conblob.Name

    }
}
}


}

$blobs | Export-Csv .\storage-audit.csv -NoTypeInformation
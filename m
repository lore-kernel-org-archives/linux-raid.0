Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DEBC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 16:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347494AbiEJQj6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 12:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245110AbiEJQj5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 12:39:57 -0400
Received: from GCC02-BL0-obe.outbound.protection.outlook.com (mail-bl0gcc02on2129.outbound.protection.outlook.com [40.107.89.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0C221E29
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 09:35:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiuFcl3LEhyxK/fqxR1HTKZ1+3u5H0XuxKa74+hq3OUxHYMplYws9kxgI5ZwC3XM1maq6vtQIYtSIWuvJrtXv84WMkJrMghUgqzngzX6T0AP7qbb5lBoBPqsIxImMPHN8FIauML7h/uNHGBvWsO7SdcdOCMzX7B5WYdtvk09jgICix1ZXevCFpFoYzYCoei5AyDg9fHEl+/xBz6jxfH+LS/9HzUo/Cq+XkfW2+za+bw7ldoG6DtVFbCemvT9X9ZAwKmxFPT+ZhtAv4y2f+FLuejnWvuE/zhlaWFgGegfHBoTpOVv1pkgZUgDUDQv51BdfIrcAf7fEwQOhz6crO1m/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JCuQ5GVWnByIW0veE591xLIwjxBrAiqAEqENgUtE22g=;
 b=inC04Uon1qpq1M1Q1FWngu5rjH5gfSJO2y+iF5Jw2Ntr8fEAvC8JmWCTOF2rhY8zDEGymy8hXbmlJWVtAUU1MPuBxSmpXqrsFSNl38l9iGItgQpC+jsQmtZxE5E/wRpynwicnBKCYE/zVIALFfwP1f0GVPZkSBefwwwHjUO6uqPG40P0+3EE/OLAvNP0xeuQBf1OmyhvgSQbpiq8+kMCSj16sIawQflzgV0JYnCEtJfmvuOR3pMnaxl9dvVKypXPxyflu7jW1FF2dsNyOK7SXNFE6ZL66oH3bwuEp2iA4f27IqKgVwMdYygmxS6pXrfCm3olZCJSKDqF1TsFp7sYkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nwra.com; dmarc=pass action=none header.from=nwra.com;
 dkim=pass header.d=nwra.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nwra.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCuQ5GVWnByIW0veE591xLIwjxBrAiqAEqENgUtE22g=;
 b=Rsw/e1+0YoBI7QxG8YVuOTyBr6BsFIbTPtcIsfsDCiYcWc83uOrdAx4YQhxZlCv66CKAnRxksydQO9YW59qbosWLii5Wm/GkxsHEI4+/EHPEoHiEJFPADnXvDRpfFupvYcjWoJncHcfzOKR47F1u5F9paASro/3Ecv7ZDKw9RG62dfEX+t7SDkaQTQm/pE5Oo1lpnBaG14dsNJPEg4GGcvGaHzvq8+UwzX+khIY+wh9qwFtniYFiRgAq8MPXa2BRvn/wSDgv7Yxh+8UWvXx0L8Sni7WJYrd2X1j4GOpmZ2Zhk7QGQlqA1qZTm63FN/0PITWWLZUPNcw707qXmx6fSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nwra.com;
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com (2603:10b6:a03:26b::14)
 by CO6PR09MB8167.namprd09.prod.outlook.com (2603:10b6:303:cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Tue, 10 May
 2022 16:35:52 +0000
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::adad:368e:3553:5368]) by SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::adad:368e:3553:5368%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:35:52 +0000
Message-ID: <5e7ff461-8f1a-3a69-e7f3-45ba3713c1d6@nwra.com>
Date:   Tue, 10 May 2022 10:35:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: nvme raid locking up (4.18.0-348.23.1.el8_5.x86_64)
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-raid@vger.kernel.org
References: <d9a9516f-695e-3ead-6744-1510b13148c4@nwra.com>
 <f801038e-1459-af90-679f-fc91f404aa96@molgen.mpg.de>
From:   Orion Poplawski <orion@nwra.com>
Organization: NWRA
In-Reply-To: <f801038e-1459-af90-679f-fc91f404aa96@molgen.mpg.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090209000003000202080701"
X-ClientProxiedBy: CY5P221CA0047.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:930:4::16) To SJ0PR09MB6318.namprd09.prod.outlook.com
 (2603:10b6:a03:26b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b52564b-2792-49f2-a21a-08da32a325a7
X-MS-TrafficTypeDiagnostic: CO6PR09MB8167:EE_
X-Microsoft-Antispam-PRVS: <CO6PR09MB816763D3A69BB22C6078C794CAC99@CO6PR09MB8167.namprd09.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZVA1nmfAXHWbvXDQ3YGS38shNkQiDq4dMzpiLnxVimnWzm+R0ACHtNZnp31KY1ltjz+HPN69wwh68c7/vQ7H2GcAk3H0+0WobesxuLuQ0IL50XkUvvrYCrFGs6T0mYI6rzwaZl6bQMNs0pdCf8GaSbio1Ipj4oIyK3WgxYKkW6LNw+blgxMXIM51bvwYREEf9GEvgJtV6jFIftuy2I6BsKDV7R9JKxpBlttr7jJUekoEnwO5/z6AinQ0YBWJPs15r7q5ew6y6cz0Jxa00i/3AAGdqFF29kGhtsle1+pNq7Qk68OQY3ky6R/IKaa3hmjcI3YFEw3BnMO6rdK8Dh6/4x2ypfLQ03u6N/TUyXtDaFYf0Rg0/uAWOzD+mKOre4/nS5X70ggcpYac25Q+zu5nPoyPz7jdBiFQzDRFIpbk4WlBRubfwuQRIYR/v0DU3OV4nSCYc3S2XgEKtPqKcvhqryRk180WUe0e2PEVa3l4wCz6cJu3jKUxhUjRkJ1HCiN9nHPGfvQFrizYXUBypsNV8jLf+3Go0MQnHNNf8nI2/lRwDV6d4Lj3r4jg3ueFeHII1iyUNKD8ZtXM3/Ctpu8hpIdykqJosQcGi5R8kA4aKmzvhDiO/YKV6r3cComPNPmRaMqeJZZHLSS2YIErenwKVbsYrVSKTHRDBTCjtAx49mu4KIO/V4CZYlYd7Y5z6A3SsPeovl50fAENh/0xqjmFCsVTL6ZSMY1OuCJZGYSj5Of9DIPh4h8B8QEjJL6E9S5wHX9kBjEYPYGKcmJKYWANxDjX25s5kp/YLp2sYBjCZYRHlue8haIdDL/fuNIK5KHz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR09MB6318.namprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(136003)(396003)(39830400003)(366004)(31696002)(508600001)(40140700001)(2906002)(38100700002)(8676002)(5660300002)(36756003)(235185007)(186003)(31686004)(83380400001)(8936002)(66556008)(2616005)(4326008)(966005)(66946007)(6916009)(86362001)(316002)(6486002)(36916002)(26005)(6666004)(33964004)(6506007)(53546011)(6512007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzluVm1jeVdmMHhJeEtHSkFkWE4rUkFMTTdzQU11eUZsQ3RkczNmRVIyY0dZ?=
 =?utf-8?B?a01QM0dLVmlWMUVwdUUvY3MrOW5uRTV4QW5kQ1VIc0FKb3pxU1VDc01XNDBp?=
 =?utf-8?B?OXZ6UG1Jdzl2K2pjS1Q3RitlTEVRVzliaGtlVWtITDRkaDFUUmxRRklKSGpw?=
 =?utf-8?B?dW9XcXZpQkYzS0duUHNkV3pQbTF0Wk13d25kNWZnM092emxraGMrRWlUTU9l?=
 =?utf-8?B?QlRZVnYxSUpVR1MxRmppNjVhMGROZGhPNEx3U2pHYU0rR0I4Mzc1VVh6VEpC?=
 =?utf-8?B?MFRyR3EzSU0yMnByNllDOWFHcWtKdjF0Y3pSVkYvWmRPNGh5cnBkdUZZMlVS?=
 =?utf-8?B?Yy9BY0pVMXJZVXhsbWRPRk1CSytFWVdYMW5LbnVCUm1rRGJvNG8zQXN4Q3R3?=
 =?utf-8?B?dDF5MUdkV1VoQ3NwaWNUSDNSNG1uQndmNkVTbVlZaEJqa1g4dkFGREI0bWhC?=
 =?utf-8?B?R1BSc1RuVTFVbExZdVdKRytVSno5dVNEWE4wQ1lXOWxqdVdpZExZS1V4cHdP?=
 =?utf-8?B?MTBhdHJFVHhxaVBNT05LMlp6T0thTTFoTWU0N1ZVUDdBZHQ1NWJkZ2Z6UDI3?=
 =?utf-8?B?ZjRzYXFFT240TFMrdzAzMUV1Qy96S29OZU84Z0xZeitWY3llbldaYjZIT2lq?=
 =?utf-8?B?UnI3NXU4VXpQYkxWUENsWGd3T1liVUo1SHZQdzRjNjNtTDJzQmdxZW05ZGJu?=
 =?utf-8?B?RWdoN05CQlFoQnRWeHdVYUx0NlFDaWRGaWkrVnZvMFg3ZUdjSGwvSnhqb2R6?=
 =?utf-8?B?M0VQbVRFTHNHL1VsS0x2bllWYUxyUHpSY05FOCtOV0N6TXJnSDJRZEhuT243?=
 =?utf-8?B?NnRFMU9sdnpOL2pMcEFIbk1BbnV3ajZaaURIN3FpZ1VpZjR2RTluUW15cXhi?=
 =?utf-8?B?M1M3WUZ6eW5meUVrQzJ5RGtOaGZ2TS9jcWFqU0JmZDVtSTRxajVqOGtFNVpm?=
 =?utf-8?B?NDNMRG91WFhJbmI3Wm9YK2dhV3o5bWluTHhIV01VbkppNXFJVGswMzlDdWM0?=
 =?utf-8?B?bmR6NERZaCtka3J5TGplOWZOTDNrRVBIdXZpbytnK00yTUM4UnpMZ3dlanZv?=
 =?utf-8?B?cjk3OU5KZnY5eXA5ai95em1Cc0pyaEdWOFp4UFljMDlXRGlVR2QrcHo0R3Uv?=
 =?utf-8?B?LzR2Rko4Um1mZjFKdk9tWC9xN3FhTXpyK3lOUExyWVdDbUtHZUlVVjlzcHpa?=
 =?utf-8?B?T3pEbG5oVXdPZDIyU0tBajlhTFBNTExwckhqdzNKZWtxdHA3eGxESytpOEk3?=
 =?utf-8?B?NmYrbDQvSjFYK24rbzlTZWY3VDZuZmZoN0J4Ym5PTE00cHltSHZkRVBaS3VX?=
 =?utf-8?B?TGNPQ3JON1lENWN6dmd2QlhTN052dHhXZkxsdHU4S3lubnp1Z3VUSnlEbmV5?=
 =?utf-8?B?b0VVNkVYOGFpWEgrSWVJL3dLbXBWTzhPOUx1dEZLanlGZ1ZPYkhKWW9IZ0t6?=
 =?utf-8?B?QmVYVU0xMDQ3SDlQTit0elVjY0NFUWw2ekJxU1BGM2xJaHdtTk1xeW55U3c5?=
 =?utf-8?B?aHZkREN1S25WZkxmbEE0enYxMmZpOVNTK1hDeXhUNU9tTzBHVFNlTS9pMEZL?=
 =?utf-8?B?VTVDVzlHdHJMOU9FdDdHVGZPZ0lLQTJ5MTRTQ3ZDalBlWFVRVHBqMzBhSDZU?=
 =?utf-8?B?YStqY1BTK0dUYW5nOG9qN2V0RkNvSGVFQnA0ZmVJTDBnQ1J4azVVQVJ0ZTIx?=
 =?utf-8?B?VjFjejZKTzNsdU9ES2NZR2I4OWdWYXYraWc5RFJYeVFtdjE0U2NoUGtwbk9p?=
 =?utf-8?B?eVVtaW1XWnpLcXY2TENqQzY1N3JzSWpHRllVTWtqQXdEMVpPUERMcmpFNUFa?=
 =?utf-8?B?YXIxS3RzZXdVUVhtS2xZQy9DY213dFAvQWFFdTlsdmlOV3BqWjhucXZSL0pK?=
 =?utf-8?B?aHh5WlVRKzlzckVxZVYvc0RheGV0N2lYSEk5ZEdqbndna1RSSFVHU0lmcWpW?=
 =?utf-8?B?TDdSS045WUdqUmdKVFlQNHcrM2I4N0NtOFY3dUhha296ckdETGtZQWZXazJa?=
 =?utf-8?B?T2ZHWENvb2lUd1hBRE82Y1FpSnpSZ2hMMVIwVlJmbyszajhkaEJ4b0tUWVYv?=
 =?utf-8?B?VnRYazJiZjZYdjZsMWFaeHY5RlYxdE5WaUkyWjNzM3NBTUpIZEc5dEFPOWo4?=
 =?utf-8?B?MTA5QnBzWHpHd2tsN25PZlNGa0QrN2oyTml4UU1aTDlSSlhGMDZPUThRSHg4?=
 =?utf-8?B?MkIrWFRkV0Q4SElGZnJCejQrWklOc0Y4VEl6V2ZZSmN6dlZySkJBWjBNZXFT?=
 =?utf-8?B?M3haWHAxWEluNnJtNVBvQWM2QTRlRTFPa0VqVlkrdUh0VUZkcGhnZnl3MnJj?=
 =?utf-8?B?aFQwY0g1a2tqNmdoQmVCUWNLWmROU1MxNnJLdkRqOFY0dEJGdWV5Zz09?=
X-OriginatorOrg: nwra.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b52564b-2792-49f2-a21a-08da32a325a7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR09MB6318.namprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:35:52.1022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 761303a3-2ec2-424e-8122-be8b689b4996
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR09MB8167
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--------------ms090209000003000202080701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/9/22 09:43, Paul Menzel wrote:
> Dear Orion,
> 
> 
> Am 09.05.22 um 17:32 schrieb Orion Poplawski:
>> I have another nearly identical system that has run without trouble, though
>> not with as much IO load as this one.  Is there anything else I can check to
>> see if there is a hardware issue or if this might be an issue with the linux
>> RAID system?  Is there a better place to ask for help?
> 
> It’d be great, if you tested with a current Linux version. For such old Linux
> kernel version, please contact the support of your Linux distribution. Red Hat
> should offer support for the Linux kernel, you use, I guess.

Thanks.  I've filed a bugzilla report - but without a support contract I'm not
going to get far there.  If I continue to see issues I'll try running with a
mainline kernel to see if that makes a difference.


-- 
Orion Poplawski
IT Systems Manager                         720-772-5637
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion@nwra.com
Boulder, CO 80301                 https://www.nwra.com/

--------------ms090209000003000202080701
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CmMwggUVMIID/aADAgECAhEArxwEsqyM/5sAAAAAUc4Y4zANBgkqhkiG9w0BAQsFADCBtDEU
MBIGA1UEChMLRW50cnVzdC5uZXQxQDA+BgNVBAsUN3d3dy5lbnRydXN0Lm5ldC9DUFNfMjA0
OCBpbmNvcnAuIGJ5IHJlZi4gKGxpbWl0cyBsaWFiLikxJTAjBgNVBAsTHChjKSAxOTk5IEVu
dHJ1c3QubmV0IExpbWl0ZWQxMzAxBgNVBAMTKkVudHJ1c3QubmV0IENlcnRpZmljYXRpb24g
QXV0aG9yaXR5ICgyMDQ4KTAeFw0yMDA3MjkxNTQ4MzBaFw0yOTA2MjkxNjE4MzBaMIGlMQsw
CQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjE5MDcGA1UECxMwd3d3LmVudHJ1
c3QubmV0L0NQUyBpcyBpbmNvcnBvcmF0ZWQgYnkgcmVmZXJlbmNlMR8wHQYDVQQLExYoYykg
MjAxMCBFbnRydXN0LCBJbmMuMSIwIAYDVQQDExlFbnRydXN0IENsYXNzIDIgQ2xpZW50IENB
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxDKNQtCeGZ1bkFoQTLUQACG5B0je
rm6A1v8UUAboda9rRo7npU+tw4yw+nvgGZH98GOtcUnzqBwfqzQZIE5LVOkAk75wCDHeiVOs
V7wk7yqPQtT36pUlXRR20s2nEvobsrRcYUC9X91Xm0RV2MWJGTxlPbno1KUtwizT6oMxogg8
XlmuEi4qCoxe87MxrgqtfuywSQn8py4iHmhkNJ0W46Y9AzFAFveU9ksZNMmX5iKcSN5koIML
WAWYxCJGiQX9o772SUxhAxak+AqZHOLAxn5pAjJXkAOvAJShudzOr+/0fBjOMAvKh/jVXx9Z
UdiLC7k4xljCU3zaJtTb8r2QzQIDAQABo4IBLTCCASkwDgYDVR0PAQH/BAQDAgGGMB0GA1Ud
JQQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjASBgNVHRMBAf8ECDAGAQH/AgEAMDMGCCsGAQUF
BwEBBCcwJTAjBggrBgEFBQcwAYYXaHR0cDovL29jc3AuZW50cnVzdC5uZXQwMgYDVR0fBCsw
KTAnoCWgI4YhaHR0cDovL2NybC5lbnRydXN0Lm5ldC8yMDQ4Y2EuY3JsMDsGA1UdIAQ0MDIw
MAYEVR0gADAoMCYGCCsGAQUFBwIBFhpodHRwOi8vd3d3LmVudHJ1c3QubmV0L3JwYTAdBgNV
HQ4EFgQUCZGluunyLip1381+/nfK8t5rmyQwHwYDVR0jBBgwFoAUVeSB0RGAvtiJuQijMfmh
JAkWuXAwDQYJKoZIhvcNAQELBQADggEBAD+96RB180Kn0WyBJqFGIFcSJBVasgwIf91HuT9C
k6QKr0wR7sxrMPS0LITeCheQ+Xg0rq4mRXYFNSSDwJNzmU+lcnFjtAmIEctsbu+UldVJN8+h
APANSxRRRvRocbL+YKE3DyX87yBaM8aph8nqUvbXaUiWzlrPEJv2twHDOiGlyEPAhJ0D+MU0
CIfLiwqDXKojK+n/uN6nSQ5tMhWBMMgn9MD+zxp1zIe7uhGhgmVQBZ/zRZKHoEW4Gedf+EYK
W8zYXWsWkUwVlWrj5PzeBnT2bFTdxCXwaRbW6g4/Wb4BYvlgnx1AszH3EJwv+YpEZthgAk4x
ELH2l47+IIO9TUowggVGMIIELqADAgECAhEAyiICIp1F+xAAAAAATDn2WDANBgkqhkiG9w0B
AQsFADCBpTELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsT
MHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5jb3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0G
A1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5jLjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAy
IENsaWVudCBDQTAeFw0yMDEyMTQyMDQzMDlaFw0yMzEyMTUyMTEzMDhaMIGTMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEmMCQGA1UEChMd
Tm9ydGhXZXN0IFJlc2VhcmNoIEFzc29jaWF0ZXMxNTAWBgNVBAMTD09yaW9uIFBvcGxhd3Nr
aTAbBgkqhkiG9w0BCQEWDm9yaW9uQG53cmEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAxBJrIv9eGtrQLaU9pIGsIGBTiW0vZIYmz+5Eoa69sj6t6QANvg0IuVgWZajH
2fu8R+7m/AbZ8Wsuzz+ovtDHiVqUGvGzYyN9a5Ssx94SwNp9zLPfdCRMdh3zJB7gc4GYE/fA
kMkieO8u05f/hSyf9zU5gpjl7SW6p8IjkoyxNOr7KCbI4CQ3+1LG8pn6tz/QJwQ/BJZa4dE0
asXfNlZf5kZtyWtJhwub76zH5uXeODDxY3RooWj1l4V2fQCoFX2ov1ENUW4hRov1cMAD2QHJ
KL0Boir36wISvzq8Z65MSMCGNRiWwRaclVwVZ+QYnlhGZ0g6tMvxVrK+sHnxxr/LOwIDAQAB
o4IBfzCCAXswDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
BDBCBgNVHSAEOzA5MDcGC2CGSAGG+mwKAQQCMCgwJgYIKwYBBQUHAgEWGmh0dHA6Ly93d3cu
ZW50cnVzdC5uZXQvcnBhMGoGCCsGAQUFBwEBBF4wXDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3AuZW50cnVzdC5uZXQwNQYIKwYBBQUHMAKGKWh0dHA6Ly9haWEuZW50cnVzdC5uZXQvMjA0
OGNsYXNzMnNoYTIuY2VyMDQGA1UdHwQtMCswKaAnoCWGI2h0dHA6Ly9jcmwuZW50cnVzdC5u
ZXQvY2xhc3MyY2EuY3JsMBkGA1UdEQQSMBCBDm9yaW9uQG53cmEuY29tMB8GA1UdIwQYMBaA
FAmRpbrp8i4qdd/Nfv53yvLea5skMB0GA1UdDgQWBBSpChQTknhqMfb9Exia9G14q4j9ZzAJ
BgNVHRMEAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQA15stihwBRGI8nFvZZalsmOHR954D+vrOZ
7cC0kl9K+S9u8j/E5nZd+A6PTKoDpAEYmPUYpe45tZLblnvfJC0yovSIIMTo1z3mRzldHYAt
ttjShH+M6s3xrqDtHfNAwt3TCf6H83sEpBi6wtbALfkIjKuDitgkdZsyUURoeglaaqVRhi2L
5wOOChQAyfsumjT1Gzk9qRtiv8aXzWiLeVKhzRO7a6o0jSdg1skyYKx3SPbIU4po/aT2Ph7V
niN0oqJHI11Fg6BfAey12aj5Uy96ztotiZRQuhWZPOc4d3df2N8RsdWViBp4jXt2hQjNr0Kw
pUPWRO/PENBVS1Uo1oXfMYIEYjCCBF4CAQEwgbswgaUxCzAJBgNVBAYTAlVTMRYwFAYDVQQK
Ew1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BTIGlzIGluY29y
cG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1c3QsIEluYy4x
IjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7EAAAAABMOfZY
MA0GCWCGSAFlAwQCAQUAoIICdzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMjA1MTAxNjM1NDhaMC8GCSqGSIb3DQEJBDEiBCB99jU/fVYTZ8eJhJA7G5O3
9EXxJ/ngQnU77jUhjlWNPDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIHMA0GCCqGSIb3DQMCAgEoMIHMBgkrBgEEAYI3EAQxgb4wgbswgaUxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BT
IGlzIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1
c3QsIEluYy4xIjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7
EAAAAABMOfZYMIHOBgsqhkiG9w0BCRACCzGBvqCBuzCBpTELMAkGA1UEBhMCVVMxFjAUBgNV
BAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsTMHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5j
b3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0GA1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5j
LjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAyIENsaWVudCBDQQIRAMoiAiKdRfsQAAAAAEw5
9lgwDQYJKoZIhvcNAQEBBQAEggEAG5Sx/y/bZFiGRu/D/y78UU3JytC9Ql+PFpiwu2+6nkbA
JrX7DrRXDSvvDaudeSNxMRIy0NutHHLaobXd35LfZ3dTrGbHI/MF8TvOs31uXypGhIfd1E02
EO1rp36g70XDHpjbRX7pycECKtX+eJIE7iE7rE3arfhYvN2h8BZ6Yzp7ND3oFc/r/Hjp70fz
UODNWKod4pDH95QQWnoL94gs4dGDlUlJtF7AfcJuiwcRuYb2ionCBVJtkZieW4K9aTPJmyub
4Z3dVUZ6AVO9jcGd4g7HCe5wZFVaoSkTcHcgTE9Mnq0S1lK9cB8IifZzUFNhG/0zl0PhT+ME
ntK+ynjAyQAAAAAAAA==

--------------ms090209000003000202080701--

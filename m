Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0ABC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 15:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42235610F8
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 15:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbhJLQBm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Oct 2021 12:01:42 -0400
Received: from mail-dm3gcc02on2102.outbound.protection.outlook.com ([40.107.91.102]:6881
        "EHLO GCC02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237386AbhJLQBl (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 12 Oct 2021 12:01:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVqOJYBOJsFOZYU9J30+hWGJq3LhC/DvnuqqL8V5UdaQ3InlW75izYzSvcxiuY7cY1jtqqb7Jh1/KDXZEydAauPTazRK2yGk21i+U102lCVSPvhmBHsNYodudS6G0hl8cdRF3vR9d1YWnhSqbLNA/cu1ZRFJUfeNAxcclq9HMHFV+DA9rSqb5pOkBr9uJFrjYFqeSpoLDbPF0/IPHC2z/sqqCef1Tt/aCfE5Mpve50xiA/b0YzPwCERpcCwy+vha7dsBJpnAjUnHATnbSaBFx+9eIHIsdMmF2+k185tcn0ZNELca3sqVN/jioME8PNVR5TCvNGdLw7rzXOPKHQm4yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Ww5MhJ/ep5Whzna7LBqzId7pqMs69MeqsIrvQPueYA=;
 b=j0Nd/X2smaahTf7kMeF4mWjnc8toRxnnPiedmlJtr0aHLdp6pFgxay4vwxPe5hkJMpMRpPgTGaM0olA6yOP+jis/v0smQhk34ARSSa8DnW7cxbXSZNoyznDMdsuI5vTpWljT6/9QE2WsZmJbTd0DXYu3crPbTov+Ryr1eq9gCONaGoChdcX64zHMcBDt+Xim1YWmzitULUDj63k8iKiKerNoxC4/PF/I24rYReZXDQIVbJVcS/sdjv6CUZjC5XWZBBgjbHQcyQLvnUCXZ/Weub4wGQ8M3zkuxduLPp7l1+/w1q6aVzsYyP7rg4x22D4QR4/Fs5zEJ8S9YFTRsw4R4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nwra.com; dmarc=pass action=none header.from=nwra.com;
 dkim=pass header.d=nwra.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nwra.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Ww5MhJ/ep5Whzna7LBqzId7pqMs69MeqsIrvQPueYA=;
 b=y31KHkX3ergfW0iyc2lL9SZLtXjk918jsHeD3K/oWELm9VioP3jBl5lOOHW1MSUP6/kG7enK1lk72sK73yyp0yva4Iv8y24tk5DoCt+w3lAOKQMn/ayfWdxY1DTLHaMx0kvsfYLpDVlwKhSsItc1RXffAdsmejui6a08udw+pW0pHzyjJGoAdT85UspbYRvYYl3sruDIJJJBqCEhZun2T7MajrPgryE49m45//uHaplrq86bfLIHa/R8Z4dHIaY0C4h4Dcl/xwSgEhddGN5Bod7xTECGDTPKQ48LlzEhQRlmQA8NfRWw5t7gXnftWuhIoZJ5EOzkxsTdfk3CUo77wg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nwra.com;
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com (2603:10b6:a03:26b::14)
 by SJ0PR09MB7342.namprd09.prod.outlook.com (2603:10b6:a03:267::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 15:59:37 +0000
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::182d:58ef:26e8:fb8a]) by SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::182d:58ef:26e8:fb8a%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 15:59:37 +0000
To:     linux-raid@vger.kernel.org
From:   Orion Poplawski <orion@nwra.com>
Subject: raid6check map sector to stripe
Organization: NWRA
Message-ID: <3e49b7e1-1194-f3d5-a828-908c06fc28c5@nwra.com>
Date:   Tue, 12 Oct 2021 09:59:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020104060306010005010104"
X-ClientProxiedBy: CY5P221CA0080.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:930:9::28) To SJ0PR09MB6318.namprd09.prod.outlook.com
 (2603:10b6:a03:26b::14)
MIME-Version: 1.0
Received: from barry.cora.nwra.com (204.134.157.90) by CY5P221CA0080.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:9::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 15:59:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7aecc91-86c9-42df-0eb5-08d98d994a65
X-MS-TrafficTypeDiagnostic: SJ0PR09MB7342:
X-Microsoft-Antispam-PRVS: <SJ0PR09MB7342E52F1D0FDBC3034384B1CAB69@SJ0PR09MB7342.namprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bEIzx0Umpr4mESbbIM65qht1SsICeKDA5SMsSHGCVce6wNXXdQMec6EBFwcCC6DLfP7doz/KW1WGqvAqwdkCyYRX+xN/1hXHgXxIjOEeYc2iDy3yXFF6q0Z18yHcmZI6Zq7VflV0IyVss2rFxoKECBsazJ0QMmttIn/QLR3uv6P9rKasYXlYXvUduJwFMrq8xq2ib3vAkESCa50ytkBahlB7u3Ka8yprJwV83FYXp6UkgIwU5fwy5V9H6++BbLX0ipptZIcCbwUJ8YT3HP0Fq4rXdJQTXLBtvYm4Z3k5Gd6cvyuipRkn9HOEZzqnMiumdT6jyYTgVBys5vHDc3rP66rj/tJiavL1nUXwfqr9ayAiU2Ljw+A0psEtLpmKjGWwB5WVB/yHZbtMza3aJSWNw9A3zHEOPSXbEeceTvQTcX74ww4izo5iOaIfyI2VLStVv6CNdc9sXVYAFsomK0V1chXj2+miQxckl99aD2NdJSlhdaBJ6q91JOlT2Q2b6dHTnjKrQxRwr5DNOczx79bELAqw4Mpnf4lSaJP2iG0ifyu7uTg6spGIHS/Xg303TSm8/LVj6DUaRBUj5dyE8hrpxIipOr5MxGib4RJaQCGhR2hRGExmGHgfII4KWBsFqxOTroblmgnRQA8bWdUpDiJgH10C+uM1tF5dpFAMBxv7kiuAraqSluF4E585JTU3QYLL5X91As/4EPgL0b6Vs0DsvkEhzBhWULwdiIBrfUgQG/69nC1x/Q9yifcgOLwAaf6davIQonlrZQSL/bmmmGXWFDnoqJux7XYN4CExmypcjWfvzeqBXsfDU9IZnHd0syVrerETadT4PCvXTFYH+k0v5X80vy0Spn3aNugAoEe92S3lSRMLNrB3HLUD+Hktj7za
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR09MB6318.namprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39840400004)(366004)(396003)(136003)(376002)(26005)(956004)(38100700002)(31686004)(235185007)(66556008)(2616005)(38350700002)(66476007)(5660300002)(186003)(6486002)(7696005)(36916002)(36756003)(52116002)(86362001)(66946007)(33964004)(2906002)(31696002)(316002)(8676002)(8936002)(40140700001)(6916009)(6666004)(966005)(508600001)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0dZRzhYeUorSkhZMk5kRTg4VkwvSGt0UlZleForM01pY0xLUFRLeXJXWUEw?=
 =?utf-8?B?WXo1MVoxUFY5SXhRL2tvWXBGL2V4a2R6ZXVSNTc3UmM2QXA5Nkh4TjhUQ1Ny?=
 =?utf-8?B?SkoyRkV2TGh6MHVTcWZQK1NXc3l1UlF2VVlRYjhRTEtnNzl1STd4OWRwYUht?=
 =?utf-8?B?dDVnZFRrZGErRSsyUEJab1BucjBPdERUd2d3VVZzQ1NkQkxnQnNPZ0k1TUNC?=
 =?utf-8?B?NS9pVGN5UlMva1hKTXJObEMwYi9hMkxIcFVOdktjRUNwd1JsOVZYR2NwZzBt?=
 =?utf-8?B?YlJWc2lIL1dSeFh3VXpDZGd6MHMwQzhNMmlMSHBLbUxOdWw0TGJKaHBOZUdG?=
 =?utf-8?B?QS85cGNIV2VMSGVPTUFLVVNGeWNMVFpFTkJ3dTdLSE9tQmRERzQwM1BZenZS?=
 =?utf-8?B?aUtlZ3hPS3BOWUVQSEdiTWNnUzFNTzBwV09iY2MycldZeDdQbXJyNDNtNXJT?=
 =?utf-8?B?WUtKbkZEQ3dWcDY4czFOanpFQlZhVStpTUlXY2xHa3VGeCtvckhCRk1md1gv?=
 =?utf-8?B?Ujl0RjlKWG5KLzIxOGhjaW1RNHNRT2VzdTltZlZGTHJlSTNWcmg4YnlLTXNn?=
 =?utf-8?B?RzZQeWFGUFRnN1djWkZ4ekVkaFYrK2t4MDhXaEEyd2ZidURQRm95NGJjUHYx?=
 =?utf-8?B?MVlZOHl0ZXhCUFRxMTkyUExKaWZvbzRFK3hVT2Z0VGFuRTNqMStoTDNaa1hU?=
 =?utf-8?B?Qnppa3Q2V3ZmVnJMcDVGWDRrZUJHeGpVbTFMMEVzamEyVlpoSElqK3pOejcv?=
 =?utf-8?B?dWpYQnJzWXFJWGRMbXp2SE5TRU5RcEMzazJsZi9oSXZsakhtN1JBRWRGSlMr?=
 =?utf-8?B?ZXhFRzRtTXlDSmhtcEd2dFo2ZXJOeDBQQktUUlhqZUJjUUhNTExvTkRuL0tz?=
 =?utf-8?B?dS84TnFWM1NjS2hFOUNtVHAzTnlCR0NIdkVOTzBJUDl0d2FURFdDNzBwcFRH?=
 =?utf-8?B?azBrcFRMS1ZBQnljdnAwVnlnVmEwUkhaWitxNkxtNStvSmdNaUVKaGs5ak1m?=
 =?utf-8?B?eGxsa2pJQ2w5SkpTVVgwQlBVSHZ1a0VPV2NFRFdZYWNFVE8xNnFPSGtka3VG?=
 =?utf-8?B?UEEwMXEyM2xQYXJXVFFmbFhvUE1SdjZoK3gzSUpuVHE1dEo2WXJsaUxNTE5n?=
 =?utf-8?B?SEFFbkZQQjJkcGlVcnQ2MTB6M0NWdUV5V2FEU2h0SHEvY3R4clFjbVhXN05a?=
 =?utf-8?B?TVcxcnBPbzdFemdqS3YzVU9Gd3p6Z1kzUkdGeENwVHBDV2d4YlpHVlJEM29P?=
 =?utf-8?B?UFQ0aXNTMTBPdENDY2YzR2Zmc2U3WENJdUU3dnVhZS9yWnZkNFA5azIzUXcw?=
 =?utf-8?B?VUpHdnY2RDd6Q2lFam1udXNYL2o4QUt5Q1l1SkNWVENkUmUvLzlZelE1QXQx?=
 =?utf-8?B?R1JpMiszTTJxbHNySnZvUVZURGRsL1hTbFdLemJIcE9SSlcwL0N3RWhReFlt?=
 =?utf-8?B?NTZIZVYvOWxQK0l4Szlld1lDc0hyQ2NqQU81SEVlY21Bd3dtanpuZzZpbEJh?=
 =?utf-8?B?NDZWR1Fyd2xhdCtiRjBibC96U1BJQStQcEM4Sk9sWU5Yb2trbGhTMjJ0K1FS?=
 =?utf-8?B?U1ZnT05kejRhaEg4OTVHOENCUWpFdk1zVDhEYTNyd04vWTRkbUJrbVhQOFdx?=
 =?utf-8?B?QW91dGZqZ2dYOWo2YTFJcmo2OW1rV09aRC9aYURmdTdGdXhGU2pIRGhUQUNT?=
 =?utf-8?B?bEtZc2VPcXlXUG95UXpWdk9MU1ZYRFU3WWFodGtPb3BiR0d1ODFmeWJZT3JV?=
 =?utf-8?Q?gj6lEomcFuweJ9b0P0Gsvd1IjhB7IQXUnbhuMic?=
X-OriginatorOrg: nwra.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7aecc91-86c9-42df-0eb5-08d98d994a65
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR09MB6318.namprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 15:59:36.9256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 761303a3-2ec2-424e-8122-be8b689b4996
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR09MB7342
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--------------ms020104060306010005010104
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hello -

  I'm trying out raid6check.  I have the following status on a raid 6 arr=
ay:

[2225216.602597] md: data-check of RAID array md0
[2241097.726463] md0: mismatch sector in range 3518805640-3518805648
[2241097.726472] md0: mismatch sector in range 3518805672-3518805680
[2268448.589916] md: md0: data-check done.

So it would seem like I should run raid6check over those sector ranges, b=
ut
raid6check takes stripes.  How do I map the sectors to stripes?

Thanks.

Also, I don't know where to source for
https://man7.org/linux/man-pages/man8/raid6check.8.html is, but it has
"vger.kernl.org" instead of "vger.kernel.org".


--=20
Orion Poplawski
IT Systems Manager                         720-772-5637
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion@nwra.com
Boulder, CO 80301                 https://www.nwra.com/


--------------ms020104060306010005010104
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
DQEJBTEPFw0yMTEwMTIxNTU5MzNaMC8GCSqGSIb3DQEJBDEiBCAXz9pJxJKok6IRpRBmC2NT
wG2SPYNYFghDCGk2fwS0XTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIHMA0GCCqGSIb3DQMCAgEoMIHMBgkrBgEEAYI3EAQxgb4wgbswgaUxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BT
IGlzIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1
c3QsIEluYy4xIjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7
EAAAAABMOfZYMIHOBgsqhkiG9w0BCRACCzGBvqCBuzCBpTELMAkGA1UEBhMCVVMxFjAUBgNV
BAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsTMHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5j
b3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0GA1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5j
LjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAyIENsaWVudCBDQQIRAMoiAiKdRfsQAAAAAEw5
9lgwDQYJKoZIhvcNAQEBBQAEggEArBQZxBtJmUXbuBrEZBNCkFjzqZOi2UPvbW/f35ApjrQH
n82oDjkQqEl/xfqcRa03aRZhp844Nlg9xD/EL8qa6n4v2jNzsv8be6Ke4UdYCCGZPk0hqEZH
2MFX0q4HxAjx4pCQYGbiPc2WDoQSwUlZFFfrZjqZ3a3c6CNpbcJtqzW1vp+T8S32wjOwTILK
Z7GyXTxu5PcF6pHZeblpg2QUo/LjtnBrnBxLrA/ScY7/C+wLoNZItW6jHbXp6W/fbV3lbeIT
/ftN0qxQQELPykESta6/MchdIsHNa2VJq/a9ZgAjfxJNw0cAWiJYjrlDWnP7Sbs517SoAskw
DPNID9AFFgAAAAAAAA==

--------------ms020104060306010005010104--

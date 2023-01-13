Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1B7C54EBE
	for <linux-raid@archiver.kernel.org>; Fri, 13 Jan 2023 16:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjAMQ0P (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Jan 2023 11:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjAMQZd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Jan 2023 11:25:33 -0500
Received: from GCC02-DM3-obe.outbound.protection.outlook.com (mail-dm3gcc02on2125.outbound.protection.outlook.com [40.107.91.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279D9820C6
        for <linux-raid@vger.kernel.org>; Fri, 13 Jan 2023 08:19:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAgsyJ1noYZTzNnuQYt00W1HQPrM8vhUzKgaYT5K0lC+AzHWuDtrx+fuMBDMrgsqucP85Afl9IpkrCsaT4XH7GWMMiJnJlcstgmGACG8cVRkdotGJyUbjukkp8PfPNe2D2nVWMIeBjO/w7FrnLUhIr16tkJqo2EFocTqdtMMBSfphPUen1WlvBIuvsfSr38y5nqDQkbCmM3qZyvdiEL1Cnvs86otvj0h2ipbCDy9xQIHMZCbwvFwckybK9wnOfZAsycicvlvus0tk6XEebN8V0/7W4t1B2hY/As8BZv1cJlzFPE7BszY4kezh9f4eYQEshbSZvDuh8rrs3Xvgj9fng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hR6u4BPtnK9ywzbYx7ZXgxo/PeRLNINFN5i7iDm5eVM=;
 b=JrEYbA22c5W91HXZ/bFn67t5DFW7TUY7WmtkG2UeK2H/ASfqmhAelEZId5RkfQ/cRO1p9YUe4wIQl0KcJkqsRceicJGEpJEDyiEZI673nhMMfkJAr3u7OEc339pzwxtFjCoAZV2V+sidKMSpkQUuWziVMetcEvczJ3sSr0xlLiNEmVWuGOfZf5Zob2gHNHzuLHGDwzeUDI9eqZV3U5VO7WWWizyn6Roz2XUfpCDyoms1IwWwJMrQi72ilw8AZKGyutCoZj0Q5zMs3sX2ggKJ+7sLco4kiaUXwucmyJg/jCQoXXzj7B4N9oxPkRZestn3xrxOhL+yjHZxoKairAjGhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nwra.com; dmarc=pass action=none header.from=nwra.com;
 dkim=pass header.d=nwra.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nwra.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hR6u4BPtnK9ywzbYx7ZXgxo/PeRLNINFN5i7iDm5eVM=;
 b=RsDTYC5E7eaQqo3gcgalW+RxrNtfpOaHLdyrE2KWnRMn+TG97z6PrpHQuFO2EE5SwNHbZHcq8E0ov9ZF9Wnvzxpa+eNEwxlqCWwFEdRvzN2j/ycSjM7/ukcV07ct7KOPyqM+UuZBMfEQ2wo6kQIfq7RxmnKmJItPMFVn8AmfRO6epMdK8O+/n2eaQ5B5L6unu1f2lvX8aYx8toJUL0/RnwcEhk3vb2+qApaJwzr0nggxhE3xMh6j5LKFyixwbMaJ08kkTR4iLaccQ+SJyDFwwwl6M3VDLoTu1OuHe0+qVDPYMwTjZ99KBFUoCwWYxxZrCig58HL6tDI67SHlU9ecQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nwra.com;
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com (2603:10b6:a03:26b::14)
 by MW4PR09MB8993.namprd09.prod.outlook.com (2603:10b6:303:1fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 16:19:15 +0000
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::bbab:ea1f:f06b:ea59]) by SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::bbab:ea1f:f06b:ea59%4]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 16:19:15 +0000
Message-ID: <005b6ea8-15b1-20bc-3fd1-66b7de43f3be@nwra.com>
Date:   Fri, 13 Jan 2023 09:19:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: nvme raid locking up (4.18.0-348.23.1.el8_5.x86_64)
Content-Language: en-US
From:   Orion Poplawski <orion@nwra.com>
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <d9a9516f-695e-3ead-6744-1510b13148c4@nwra.com>
 <f801038e-1459-af90-679f-fc91f404aa96@molgen.mpg.de>
 <5e7ff461-8f1a-3a69-e7f3-45ba3713c1d6@nwra.com>
Organization: NWRA
In-Reply-To: <5e7ff461-8f1a-3a69-e7f3-45ba3713c1d6@nwra.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030107070204040901010605"
X-ClientProxiedBy: CY5P221CA0092.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:930:9::22) To SJ0PR09MB6318.namprd09.prod.outlook.com
 (2603:10b6:a03:26b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR09MB6318:EE_|MW4PR09MB8993:EE_
X-MS-Office365-Filtering-Correlation-Id: 82f3afbc-474d-4781-dfeb-08daf581e9cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6UFsDOpKVmm3dLpHCUyN0JqoLqcKqoc5cQWPcbzrz5GbKp62clUgUrdKP13GcfrPM70XZZWXm6LO9PbKU+opG4YzJBgA75yOLFHH/5oar2myoa6xRa5SNoUecxcf9mR31enUX5KZZtgWdzA7ZXAI5ZBcxA0nEHfy/jz4448+3Jh2o+9dKzcIgL8MfRudFTHpgkfLGg9XyFgIOfANapL41lDUGeP0/0m3zTDkzQeZNxTsmbE8cCCiBtggoh6OL+IhLHs3fu1Rx3CUaR9GqediUHUHccTvGu+eICHMUVkdTq9sGOERUGsMQcy/Yfkueo1a1TYABnkFjgd+yGx8Is9QU53NtAva8ROFK8g16XkUVMgK+cUDnNPot9VxUHDU5Bq1lkKm0pXq/69/TxxYSqpQofD3g9kuoSg82G+2Ba4Ipfp+N5p7LriP/nYLZkkZIGmi5KnfD2fj07TAI4THgDmdIzkaA0e1ymHJWnAXBW/ZFnEvzVNoAu6jT+xsyfBS9r8mb7GoUOP0j6l5Hxq5scronCT7L7aeOa2BVPcpVok/Uw79ltMn2qVR5tn1aPZ8AvvNAI+jgRMgWJC97yC9Iu0OwnYLycd+IkfJnKAlXLA6zk5FgfeEpp2EFcAxlwk8agRt4QlI0ReyL794RwkPzlFBgJ1a4ohGV4ZZhNmx0KZDGuMLpW0+jAICx+/uMOJg53cfy1498pj7iCOZK00QOW9SmHIWiCtalGu8o1zU4+FybG+/GNijLUBskqMNX2W0C0PJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR09MB6318.namprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(39830400003)(451199015)(40140700001)(966005)(6486002)(508600001)(41300700001)(6512007)(38100700002)(41320700001)(66556008)(31696002)(2616005)(86362001)(26005)(66946007)(36916002)(186003)(66476007)(235185007)(5660300002)(53546011)(36756003)(6506007)(33964004)(2906002)(6666004)(31686004)(83380400001)(8676002)(6916009)(66899015)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qm5ENVhCSU00R2duNUxyWXl6aS9Lb2xmdlE0N1pFS1VZcS9xdTBhalQvQVVk?=
 =?utf-8?B?aklRUHMwWmtadWQ1R0d3OUE4bVZpWk9kZzB1ZlZ2V3piYXRRdlgxaWlHenBi?=
 =?utf-8?B?cTBYa0pJMnNWZ3A0ZXNMTEd5aStObFIwZDZ3R3RER2crbEdFTHdsYm52YmhZ?=
 =?utf-8?B?NW9vT0lmZkx2TTRSa0Vmd3c2ejVlR0VXNWJUMkJHT0VxM3NQUUhXREVxaWEz?=
 =?utf-8?B?NE9Qc1lJZUp4RWoxMWpvQncvem1UTHZMa0RRUmU1NWNjaURpaloydTFrMXhJ?=
 =?utf-8?B?aGhoT1BGYmN3aHVsS1liTmp6b3RmUGkyOGNhSm5QbGUrUHltMUVIL0JtRXFX?=
 =?utf-8?B?RWl0RXRLN1lEZHpSWWhEMzRxZlREMW5sT0pnWDR0enYwRFdrS0FiRFJIcWlX?=
 =?utf-8?B?Q2w5OWhsZE1nSExlMDQyVkJsVGVEWDNIdCtoM0hnODR6cU92K0NaN0wwVmNJ?=
 =?utf-8?B?TXV4STdpYlRDRWJ1OXM1TEtDMEpCaW83UlMvOHVWUDdJVzgxcVpMQmJvY25L?=
 =?utf-8?B?TXlDa1lSV0lFUnJTQ05rZXRRazkvSGZpOVBDRDZidkxQNmYzRC9ib2dRUTQz?=
 =?utf-8?B?Q1d2TU5BTGZpREV3cGVlOEM2UVN3cUQwUHBoUGZYVVViTUZHUmY4NEcrVlpR?=
 =?utf-8?B?Z0RsdGtXSTNuVU1aMDdOQXZpVWpQRTV6QjdzQnp6MXBReGYvRmNFZVVzVUoy?=
 =?utf-8?B?UlJVLy90Y2w5SEhBMXI1Ymc5aVVVbG1CVzFvUUY5dmVxQisrdHlrVW5uUjBl?=
 =?utf-8?B?MmFYeURqSzRtVVdQOFk1aGpzZUVqeVZNSEtIYUFHVlhrdytCRUx6S0FjblQw?=
 =?utf-8?B?ZDR4V1dFWktnd2FxN3JPNmJHcG9GRGk4cXZCWjFNRFJ2TDdPaVA4UkhGc1di?=
 =?utf-8?B?aktPNlZUTHhKL1RaaXpyRjU2Mno0ZzJsSmlla0NnaTZ3VVBadm9xMWxtRTM0?=
 =?utf-8?B?OVBGZW8rTWltd1JCSXplbGw2UDR1SlM5QTk4L2xQaDRGOGhVTVlERWpJTy82?=
 =?utf-8?B?UUp3clZXb2RRVzFpSzhzQUUvMUc3aDd1SmR6QWpNYi9lRUVzU2VyK0l2MFJY?=
 =?utf-8?B?dGU3VlduYThtOFVjVmFiZHZ0WnY5akhDb09yOU9aQ09vSEQyY005aG1tSkV1?=
 =?utf-8?B?eWR3WEFqM214cWczYU5QMExvNk9WYlhOcE9iK1l4SGNuU2VsSm16ekRJTHpJ?=
 =?utf-8?B?ekJtSEtmV3k0NS9LWlh6SUc4UjlRcWhIY3c0TEpYWDBSRTVBU2JKckhTV3RS?=
 =?utf-8?B?V3dBVnc1Ny9sSVZmRVBxcUZFeGFxZWgySkI3VFpJb2x3QUZVNlpSVE81dVJD?=
 =?utf-8?B?MlJKZ1B0bjRDUzZ3MnBITldKcnJqVmdDVG1kYjVHQXEzM0tRWEhWUXJrY1V3?=
 =?utf-8?B?emZhdzNrRElUUVZYQm15ZmFMVWp4RzFEWjlxajBqb0Zpbk1lZFdYbmN5RUlu?=
 =?utf-8?B?WDQ3dnFjRDdqQmR0SG9UZnNvVkxxY2dkOUVpdU5GWHFqcHdZWU4xOCtNbHZo?=
 =?utf-8?B?eStsTllmWjlvWkZDbWVDb3Y0N2dZT1hxMFk1Y1VnSHJucjFxVStwTmZ6SVVu?=
 =?utf-8?B?U1phNVZuVXVaVXBXN2tFc0orNVZVazAvZnE0Y01JQ1Z6NzV5VUN6aWJVajZ4?=
 =?utf-8?B?NUl5Ry9JNGthNzdydnlhRlExUXpLbVgrd2dQYzVZUnhPbVZBUUp1UGZJM0hE?=
 =?utf-8?B?blNGejc1bkhlR1c3WjQvUUs1S0Z4Ni9HNm9ScGRkRDVOMi9GQmVBbGxSMWQr?=
 =?utf-8?B?Q29FSStsMk83aFh2bXRwWVh0WHRjaTBHMGpXVWZQdStNR0hUVmpjaUllMDRz?=
 =?utf-8?B?dEl3K3B5ZDVkNEFML2lvc2Y4MVMrVnBFY09ZcSsvK1JBcHVLNG1wM2VXMDNF?=
 =?utf-8?B?MlhlelVyOVJPMDgyRUw2M2tWWDRGWmxEeTRXMDZBaUZBdlpRdGxrQXRRYXFX?=
 =?utf-8?B?VWswc2JoTHB0KzVXWStMZ3hLOHJFTFFvd3Q2ckhYN1lzRys4OUJ3Z0lpaEtY?=
 =?utf-8?B?WEc4dVBoWEMwR1RGL1RlclFxMTVGMzdMNnNUQ0FHTG9wY0RHbEw2Nk5ZNnFp?=
 =?utf-8?B?eWZqcUU5Z3lsTXgwaHVmWXNWeTBrY3MvSHpqQUFydW53VmNXQWlKTExJUFlE?=
 =?utf-8?Q?Snv+LAKd+vTxrmz9lDBWymqeK?=
X-OriginatorOrg: nwra.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f3afbc-474d-4781-dfeb-08daf581e9cf
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR09MB6318.namprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:19:15.0690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 761303a3-2ec2-424e-8122-be8b689b4996
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR09MB8993
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--------------ms030107070204040901010605
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/10/22 10:35, Orion Poplawski wrote:
> On 5/9/22 09:43, Paul Menzel wrote:
>> Dear Orion,
>>
>>
>> Am 09.05.22 um 17:32 schrieb Orion Poplawski:
>>> I have another nearly identical system that has run without trouble, though
>>> not with as much IO load as this one.  Is there anything else I can check to
>>> see if there is a hardware issue or if this might be an issue with the linux
>>> RAID system?  Is there a better place to ask for help?
>>
>> It’d be great, if you tested with a current Linux version. For such old Linux
>> kernel version, please contact the support of your Linux distribution. Red Hat
>> should offer support for the Linux kernel, you use, I guess.
> 
> Thanks.  I've filed a bugzilla report - but without a support contract I'm not
> going to get far there.  If I continue to see issues I'll try running with a
> mainline kernel to see if that makes a difference.

Just to follow up, I've not seen the issue with the mainline kernel (5.17.7+).

-- 
Orion Poplawski
IT Systems Manager                         720-772-5637
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion@nwra.com
Boulder, CO 80301                 https://www.nwra.com/


--------------ms030107070204040901010605
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
DQEJBTEPFw0yMzAxMTMxNjE5MTJaMC8GCSqGSIb3DQEJBDEiBCD8ytvY7oTDeXKZuGni0B9x
lrCFAKx1P/YjN1H/6fNDiTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIHMA0GCCqGSIb3DQMCAgEoMIHMBgkrBgEEAYI3EAQxgb4wgbswgaUxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BT
IGlzIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1
c3QsIEluYy4xIjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7
EAAAAABMOfZYMIHOBgsqhkiG9w0BCRACCzGBvqCBuzCBpTELMAkGA1UEBhMCVVMxFjAUBgNV
BAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsTMHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5j
b3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0GA1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5j
LjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAyIENsaWVudCBDQQIRAMoiAiKdRfsQAAAAAEw5
9lgwDQYJKoZIhvcNAQEBBQAEggEAdAJ+SHzgWMw6+vkCz2PM34ia64v8BQel+a74Ip0CrL01
dV99t3B8oTYhYbA7qHND7NUVox8zdA/lfMFzWwb46T0WQQvnHh4OaxlWTCjvR6AltWUNtVj1
MJMwMLvE7GDf2SYKZvDw8Z1uemlstQ4DkYGADLCnRiB2XtqTrPmvxNIIHXbaySrQw0vO6S/b
SM5L2T55wm9Y6rU1olmIc++gqBDf1xmLnY+gjDPZpWSj+dm7mXlwcIZe6SuXObCpjTTHSvhs
oU/dxA8V80fHiZ+c0VJ8YdL/juCvI5/i0pQ3BnlaglwEXGZsCHtg91gN1y9wEx7RHEud3J9z
nwwK9PuC9gAAAAAAAA==

--------------ms030107070204040901010605--

Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2114.outbound.protection.outlook.com [40.107.8.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655FE1E53A
	for <linux-raid@vger.kernel.org>; Fri, 12 Apr 2024 17:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.8.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943325; cv=fail; b=noK+wtegvclQxclL4eQtE7+X9eAa6jxgNbLLfS+uvytvsKMoxUv/vYgGfiZNkfd0AFhoKmrcSH6TqbJP+v+GaXhHmnZiKVnNSrPcPYYwdm0d9IQmXYld3pCBnQuVTRVbYXCXZnZEHXe+KjHrDu6Nx7uy+SrYv9sUvWmw2NNfQKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943325; c=relaxed/simple;
	bh=COEvhqGVnCHomDk6Lm9ag32/83WN5p/jDkVZYefPBi8=;
	h=Message-ID:Date:From:Subject:To:Cc:Content-Type:MIME-Version; b=bwW19k2FSYqFBU9Jhbc5kM7Owj2qQi5Trvk2gQVUNo7shiUKQMFHZ9WXJu+3xHHa7E5+WFlFrpXkjhy1cjn9ofktwVy0S4+FEH6RLCi0Aq6wDqMRQi+Yh7FHDNLd1Igxwj6SaAzEFYlYdQpN4+XZ4yj4AT0bWUbpd7IRtkMRT1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rhul.ac.uk; spf=pass smtp.mailfrom=rhul.ac.uk; dkim=pass (1024-bit key) header.d=rhul.ac.uk header.i=@rhul.ac.uk header.b=UbVCGYGj; arc=fail smtp.client-ip=40.107.8.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rhul.ac.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rhul.ac.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rhul.ac.uk header.i=@rhul.ac.uk header.b="UbVCGYGj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbhMi2StfNiKIJP363pYn0JAXKtTTGnU7csyx2OAQ/u+pkGPROx9AUGCLNnb44I/M4erUPWhz9XGuFxzkAoNDRstOROCh7KgLSoJlP2+CxivOLgm5ykLSGSYjW41uG6ew9PRpowFA1QAGgOMOgqM9X9mHIF5BgSk985UzfcwReBvmAgv8WYQC5FP/wk2Jibd4NYtuAg+J7y8Xc44C9pZtfnY5ct4y+WlRF0nVF24b7e+KDpiB3DrIRJF6fZgCQEA+MxLCA9h7/rNUXuTHuhUkl38nQsrrDPm3qP0T+sgTg7SOC3G/PGpN8VMa1UoMi71/1yh0V0oBYyArpT4K2hC5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gx1wLnFr+k8CFYLwYsYtIIJPczzh1ItaW2E87fJguLg=;
 b=ibEKX+F8d4qOjW4usXMe8hgq57i2w6/I8Of7x/NvKbY9ZiW90fLCu8GkXYGAay77POpTXBrSA3g2Lf1xAj0phiQulxBSRQ3NGe5srpuM3hYu5ftKy/wxL/8IpgR236eRaPaXJYeNiuIpbwgA9Fzt+7rZqZn+nBMbjqzZ3Z40KXNL2rsuSKArdQYJWrjSoKarUz/SQeg+j06LDbnbyIVY2JgY+MDFftvt5FxzoLHgeDTNJCfbAwijP00NPiZC6JqZJDtM3q8qATalh/DNXi5TaX7VtDLEAvHa8vmIDXHDgBWzU5OREmHdR90mXI0MZRMTbKRvCeUUUQuG6LUdwL2C+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rhul.ac.uk; dmarc=pass action=none header.from=rhul.ac.uk;
 dkim=pass header.d=rhul.ac.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rhul.ac.uk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gx1wLnFr+k8CFYLwYsYtIIJPczzh1ItaW2E87fJguLg=;
 b=UbVCGYGjbufBhKH2qGsWyqrq2nEvpkyDKgVy3YevH0u4QDZFWJL8VzdC4kqgchynd77ZVcmXAx9e4xhJ/qCWUn60gEf55ymBJqNj3ra1EJL5oetWc0VLys/tAZqlwSqzJYkNrn82CjwX6Y6wbcs+CFAvWQB2jEsG8J/5PIlpZtg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rhul.ac.uk;
Received: from AS2PR03MB9073.eurprd03.prod.outlook.com (2603:10a6:20b:5f8::13)
 by PR3PR03MB6489.eurprd03.prod.outlook.com (2603:10a6:102:7c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Fri, 12 Apr
 2024 17:35:19 +0000
Received: from AS2PR03MB9073.eurprd03.prod.outlook.com
 ([fe80::6084:82c7:3d75:d873]) by AS2PR03MB9073.eurprd03.prod.outlook.com
 ([fe80::6084:82c7:3d75:d873%5]) with mapi id 15.20.7409.042; Fri, 12 Apr 2024
 17:35:19 +0000
Message-ID: <d26a7e97-b120-45ee-9063-e156d79b3e37@rhul.ac.uk>
Date: Fri, 12 Apr 2024 18:35:17 +0100
User-Agent: Mozilla Thunderbird
From: Tom Crane <T.Crane@rhul.ac.uk>
Subject: RAID performance limited by single kernel thread mdX_raid6 ?
To: linux-raid@vger.kernel.org
Cc: T.Crane@rhul.ac.uk
Content-Language: en-GB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO2P265CA0443.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::23) To AS2PR03MB9073.eurprd03.prod.outlook.com
 (2603:10a6:20b:5f8::13)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2PR03MB9073:EE_|PR3PR03MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fe2902f-b4e5-4c89-bf86-08dc5b16ec70
RHUL_Disclaimer: YES
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v6GTAisHRLWXimMTzPvZhddnXsGp/Z4KZWpGaXmejlFH/Z1Qw9jHuArEBa9EDub9pnz93A4Zu84EUPFyILPdJQTbGH917eAk16LUputGuphTBEmbPRT4NmAiuAyFnsXsE1M5jWbUU/sYhMw77TfuEs1RXijA1JQRk3gJMbcA7uTTbESdFzaJS8v+Bx+vElH8ihtZYChOdWC7MRD6pq3jTAU7f2O5YAd+o0XLBUGj8ij+yyBZJtP1MO0PlDfnIJi0YqCqSEJr93/kh39tKsbtuo3J5yBQY758qlqnCgx3smgQ2WZB1CsliLjSgdB5kN7bY+P0/zNOK0ti2KYjUA9g7e7/5IFDuGMEOp57T+ZtXpCcA/kbvNgDLHckSsAdZ0NKOUu85+oDNXfuv08/un5xQ7zMqnGGyf9uIb1ehrFxERIl4oqMn8BzqZRfPYrz+dgiuVovmELWUoDf1KOm6ZkHKhqhzovnzW+21qRho1eHDlENu5RAtLpT+GVG85wGEIkydCQR1TIFuir1VLZRdTJUTaxRTEwtFaA1TH6CAKn5nDOdLK6pl9w34hceXax4uQ4SZau5kjJcf47E4swLUoP5z76DTVeduMhTUAvMqMO3EJtwFxSZAPBCQt2A+ZcKn282jzjfxMrZ57X89v99gAONWG3jIkjacw73P6ItS17e3oE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR03MB9073.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXVpbFJaY0x2L3M1U3VGZE1wUm9wREs2cGFaeEdSQkxoSlA1dTdCR1VBNzh2?=
 =?utf-8?B?YzZXM2d3a3U5TkM4dlN0eDJPLzVWcTdZK0ZwZ1NmR0QvU1FZcUo0ZjBmOCtQ?=
 =?utf-8?B?NGFBOXByb2hLL1pUQ1ZUcFVWaU5McExGeWgvQ0QrVzhWN0c4QmlzSFp4ZTVV?=
 =?utf-8?B?QmZwRHQrN1EzZlpRL0gzT1JONUhJdnhUS1JoRFZPWXlsMytzdXNPY3RpK3h5?=
 =?utf-8?B?czJXNDd6Z1Joa3YzdjFLT3EvN0NrU0x1anM4UmVYc0RMRWxYOUkydEJrZExh?=
 =?utf-8?B?aHFJRG8yZlJjTVNpdERtajNOZG1VcFl0WTRpM3lINHJ5TnRjd1lkNm9iTnBr?=
 =?utf-8?B?UlVxeS8rK2JaSGp3ek9DYjFZNDVNS24wM0dLdUFiSEFxSy9vTDZmNUpvUG54?=
 =?utf-8?B?MUtxM2huc29UK05TQW5Ga1JUUTcxanM3Mkp4Nkt1OWhMRkhGNlQ3VEttL0R0?=
 =?utf-8?B?YndBeFcrWE1nc0wyVWVxenFwa25RbEliUVhVWDFiTzdCcWozTVVGVWE3K0hG?=
 =?utf-8?B?eENNUnpNMk93SHNUTENscnc4b0Q5Z1NKbWVqL0VIc0cyKzZUOXIvQUhPTGQv?=
 =?utf-8?B?SE9DNTVYZFhhWWZpVkNPcmErVlBzaFNaZW1QckFqRFFjREU1Z053WGtyZU9D?=
 =?utf-8?B?cXBvejllNnRsNGFpSGlxR2N1bjRHVzA5bzFtckZTR2FJTEZ5TVVwcHNNY0ov?=
 =?utf-8?B?bGhxcjdSYXNoSEFLNEFnMWYrMzhIUk80eFV3TjBkMEFsTW5sWjd1RmQ0dEpF?=
 =?utf-8?B?bXpKZ00rTXJPc3oxV3FqYWpsd0ZhbnFuYzZLTEw4UlBxc3lvaFgrY3BXbmJv?=
 =?utf-8?B?YzE3aG5peXkwMTBqZUVpRjUvYm9Hc2Q5R0hkNFhQUWJpTW8vMW9QMXZzbTFw?=
 =?utf-8?B?R3NVNVdhN0NqL3Y5Mm9iUnhHb0xFRG9nK05xMFEycy9yV2RnZEdObyt5U0NL?=
 =?utf-8?B?L09SaUd3WUYzSmJxYkRRNzJhWmc3dUhUSVZnQUNMeHpPYXVvTjhDbkRKRWNi?=
 =?utf-8?B?cVRkbTM5azRUeWh0RmluSEZrMDZKZ3Iza2tHMFhlbkNLNEV6eVhGSHVMT2ZE?=
 =?utf-8?B?U211UTFIaS9qNUlsMVdSYXQ5VktWZ21lbWpQNFA3RTRBYjBXaGRBQWZnNldi?=
 =?utf-8?B?L3RCQUZ0eGR5dW1VNmc0RVNmTkcySk53aFk0N1ozaXFpelFPdk5qQlZ6dEpE?=
 =?utf-8?B?SU5HSExYZ1Z6WnRpNHZ5d09XMlpwelRGdlBZb3RNUHhPVUFUVnZyR2kxak1N?=
 =?utf-8?B?T1d3TWFQT2daMU5WLzAxNDA2QlZNRTZEZE16dm9LOFNrbXcydC9jTkhVNzB0?=
 =?utf-8?B?anU4RFFxSy9GRWVjMFZRTS9uZmRiV0pMVnd5QW5ZckEyamlnZ3R0ZU5tZkNI?=
 =?utf-8?B?RExXa0pHeGlKQ3UyWG1VVEhrODFEYmVZdGhDTzVqYzVtSExJNk1RN1Bhdisz?=
 =?utf-8?B?VDdLYVpDbHZqaWhObVhoZitvK3FGWUk1V3RWSW9OR3ROeThJWkZsaThtRWZJ?=
 =?utf-8?B?TEN6TWduMytiZ0QzUVZZclFkbUZVVkpHREpyRXpPbjhmaHQzK29OdU45YjAy?=
 =?utf-8?B?QXZGTlArT0FQeEIxZ1F1amt6bk9rVDROcFJ6czN5VTlxMlA3Q1FKQ09SbCtu?=
 =?utf-8?B?SjhJMk5GMi81bHZwa3lpaEo5czV2T1FxZXM0MSsyMzYzRDlEc0lQVGVZbVJR?=
 =?utf-8?B?dlR4L3diT29FQnZ0VVlhaDhzRTlGelcrUTUwUFozendrMHVMODBpTFJ3eGpa?=
 =?utf-8?B?N3VhQUs2MlowUmFRVWovNGRIL2dmT1JLd1luYnlRODloQ1FrUE9Yem5BV1hm?=
 =?utf-8?B?WWhiVU5nUGxIdUxDVVk0U0lBR04rbVRUUVJOdW9sbHBoNUNZYU0zY1BQYWhv?=
 =?utf-8?B?ZzJVMEZvMVl3WFZ0alVqdllmK0tBVjJOVGFDR2huTXgwd2NtVXZMZTc3bnJB?=
 =?utf-8?B?NFFlUzdEeHFuV1RqWlEzbWNSSS9jOVBtc3k4Z2h4amxVc3VwQUhLNzlmWFEx?=
 =?utf-8?B?azhCSjRCK2QvTGhOc1ByNkdCdWI4dG9RM1puc0Nzd0gvdk9uaEdJNDY5Mlhi?=
 =?utf-8?B?d1duam4vbUErSUFxSVJWcng2WGVTTmF3OGZHNmdraW9kdUVMbk1ZM2I0SWdS?=
 =?utf-8?Q?yCJP0QAR8R0ie2c9rhUzNmrI/?=
X-OriginatorOrg: rhul.ac.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe2902f-b4e5-4c89-bf86-08dc5b16ec70
X-MS-Exchange-CrossTenant-AuthSource: AS2PR03MB9073.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 17:35:19.5006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2efd699a-1922-4e69-b601-108008d28a2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xaXNYx/VwJVpgFpERFBThXBnIvNLXmJBxHOKN/c7C+V/hdJq7pr1GqYP7VxGjOVoFvzKvU8JicdNxFDFt6cViQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6489

We have a newly built RAID6 array built using the LVM subsystem. It
comprises 12-off 1TB NVME drives and 12 stripes to match the number of
drives.

The performance seems to be limited by the single [mdX_raid6] kernel
thread which 'top' shows is maxed out at 100% CPU (on a single core)
when performance testing the array.

The kernel is a fairly old one (Redhat's 3.10.0-1160.114.2.el7.x86_64)
on a Centos7 system.  A cursory googling of the topic does not suggest
that later kernels (e.g. Redhat's 5.14.0-362.18.1.el9_3.x86_64 should we
upgrade the system to an EL9 distro) have multi-threaded this... Can
anyone comment ?


Many thanks

Tom Crane.

ps. I'm not subscribed to this ML so please CC me when replying.

This email, its contents and any attachments are intended solely for the ad=
dressee and may contain confidential information. In certain circumstances,=
 it may also be subject to legal privilege. Any unauthorised use, disclosur=
e, or copying is not permitted. If you have received this email in error, p=
lease notify us and immediately and permanently delete it. Any views or opi=
nions expressed in personal emails are solely those of the author and do no=
t necessarily represent those of Royal Holloway, University of London. It i=
s your responsibility to ensure that this email and any attachments are vir=
us free.

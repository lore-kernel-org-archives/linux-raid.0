Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05olkn2109.outbound.protection.outlook.com [40.92.89.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6338F1E52C
	for <linux-raid@vger.kernel.org>; Sat, 17 Aug 2024 04:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.89.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723867644; cv=fail; b=KGfXtYxd0xv3T+Glb36TdA3QU/sj5WkaHKKUvfzYFNR4lhuja1GRHs8JEvXUoaLcfMOsuAL/eVEdmcskock9jbz70m+xgdkKsqHixEqW5eZ1SNLKnprxLAPj/VfBlinT+Rw1qjw8/OjiZoniIb/RBFMy9IluAapPADX92VweYx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723867644; c=relaxed/simple;
	bh=YuuUGcXSbo1g7BSDAMlhG3HWg08pZZO8OKd1oH7Gd7o=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=giVmi6ky/r1HyJHs8Njs7LBgzGlivghcK/1/irbeyf38NheDPiPeI/XZ+bP5Fh449bgAFVB6iJkde+g7OjmCdU9cAF/5DzPyvfxhZlcozasucEuE+R+4Q0N391ZihqWQ+PYpJv0HfB4Iu2jina/DRN1i4DlaXOhDN091aqU6v0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.at; spf=pass smtp.mailfrom=outlook.at; dkim=pass (2048-bit key) header.d=OUTLOOK.AT header.i=@OUTLOOK.AT header.b=Dqb7lF5y; arc=fail smtp.client-ip=40.92.89.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=OUTLOOK.AT header.i=@OUTLOOK.AT header.b="Dqb7lF5y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlRWrDe3aXPFugn+936T1rOVt6TX+TocfXY85MiRO+LFTUUEoBxDv4WGU7Zfhf+BUdcOCx/g727ycidua37P2H44m52+x5fsKvHXatj7We37gqraZHYfUAECk/OrlumXXQPtiFccuApBYWVNvAhC4EC+uwdwT+Wzdbz8Xvyp0goibtyD9RzziTu4MpYtv8f9ImrgEQWZl5jnxwM4K5899IGxMCferUn48wT1u5jvBaZgqpBoRk/I8XWnzMQivp2PUxsx8cDAKBUrhtT0c3mJ4p1To9hKVFSy89xZB7YpAYw0kQ28jEXSQBXwaKLVZuL3oAmMY5FB8aQiGwL+i0bapQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzUjR/tP2B6L1kKUNhu33vCbSZQF5tuJVbzdKjaG2K4=;
 b=pOkhdvoDAOk9QNujzgovxesbmUAaZBQp8ULEzGC0tf+92aMyk8Nqr2w698h/AHc65KDCOtrkoM6qR3CENpXCYqL5bw42upj0PEPwQjXMmo+29lWVbWlFq3hAIVGtfc3kEtm1zJVDTzNvRvT7nmbGclhDSUyrvzC6NizjH08JySJrH1MTvplFvPf/Xvi/cM2DldC1R4tFKngHDvMCGmCV6aH3X2kbWv0CwVjrRU3qULht3+FnHNyyzfMMmYnG2HIQ4N48sPlUIYYst0lIa1B/jksWJq1naJyzI9ldzm+CwZLyIGLpZ7S5Qx6oZavGWfTla0jyX8yw7o4xJAPUwQQO0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.AT;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzUjR/tP2B6L1kKUNhu33vCbSZQF5tuJVbzdKjaG2K4=;
 b=Dqb7lF5yJ5bQ+6fs7bchum/y2v7u58zOH69cD+ei7T4MWjqkawJhN7IG1DMFt3uJJUeMGGyS38jbI64iMS6C2Igy0bk1QmgKo/8WI1WqhpAdgX5okNBr++/UKAbODgmuyfGvZbcImyi/0TzSUJ6vyedrGuSxGIaD1ZCaAWRC7ixgRA9sB9AZlsElu1zWS78VEjnA4y2rWkn8mnKyrtiuRlnHa1htVfNPtHdoNoCQmQCbJUXy6Xr7+oJQaPqmOkA4Y/PSqUFM92rfkg6/ij3eM3H1GCLpxfgbd15S362s9bYzKJCYd9Nfc63cDx6sMJM+h7JMLk9em5jmGsTv+AL3qw==
Received: from AS2PR03MB9932.eurprd03.prod.outlook.com (2603:10a6:20b:640::9)
 by AS2PR03MB10154.eurprd03.prod.outlook.com (2603:10a6:20b:64a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Sat, 17 Aug
 2024 04:07:16 +0000
Received: from AS2PR03MB9932.eurprd03.prod.outlook.com
 ([fe80::62a:d77a:b8ec:8ab]) by AS2PR03MB9932.eurprd03.prod.outlook.com
 ([fe80::62a:d77a:b8ec:8ab%4]) with mapi id 15.20.7875.018; Sat, 17 Aug 2024
 04:07:16 +0000
Message-ID:
 <AS2PR03MB9932660C3968A6683471E98583822@AS2PR03MB9932.eurprd03.prod.outlook.com>
Date: Sat, 17 Aug 2024 06:07:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: RAID5 Recovery - superblock lost after reboot
To: Pascal Hambourg <pascal@plouf.fr.eu.org>,
 Reindl Harald <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
References: <AS2PR03MB99323D8FD38A563E4D7DE14F83872@AS2PR03MB9932.eurprd03.prod.outlook.com>
 <5419d297-ed97-455c-bee8-969b0d70de27@plouf.fr.eu.org>
 <AS2PR03MB993231A87C17935B96DEF3B283802@AS2PR03MB9932.eurprd03.prod.outlook.com>
 <1be185e9-f8a1-4e92-bb8d-8b6170ddcf07@thelounge.net>
 <1ce73b33-9b9a-4525-91da-5dc57d070d03@plouf.fr.eu.org>
From: David Alexander Geister <david.geister@outlook.at>
In-Reply-To: <1ce73b33-9b9a-4525-91da-5dc57d070d03@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN: [xPZB8mMLYvPXdASJAyALeb1zyieJZpTX]
X-ClientProxiedBy: VI1PR06CA0146.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::39) To AS2PR03MB9932.eurprd03.prod.outlook.com
 (2603:10a6:20b:640::9)
X-Microsoft-Original-Message-ID:
 <edd68aaa-4782-48f5-84b0-575633989599@outlook.at>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2PR03MB9932:EE_|AS2PR03MB10154:EE_
X-MS-Office365-Filtering-Correlation-Id: 72dfd22d-8f15-4c94-5b2e-08dcbe7214ba
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|5072599009|15080799003|20110799003|8060799006|19110799003|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	PvF3k1C2FuHOqBjbRZKzeDDLgw9xUTybOrlT++ANhpRLn2Yi/D24hv+NUcGd0hHSXbOmmvzGQ8uFLPRDz12f1/RBFr9C4SvtToDOO/7dE+JBQ+1c+QdNwBNTQGyNfPICTSZT47JnsUt1OVaLTbajZZbjWl94ABQcKWp3VhAfmr2VPYHcu6LUtPkX9Imw0xaSIKhGdG1Yus++C/7phYpMMoE/dggWy7p36CID/Iw9IEmXudeiG7qg4sL165uAc/rvTr4BQOUZUAOLGUmXqLcQ9jL1L3CwxybjSqwMzMhaQnCG1PJg0lRlTxJphP/ufkfnus0MAK3sIofMMIi/qYgaQB+jmLl7qyephOtxRFemMT0gvz58jlNr6seODa81UQSDaBGtjiClxN5TF+MgU64YmY+aI+1OvUmFygOiXQHhp3vD3Etg7E9721OnhhEhj7Eq7vuhsW1iWMAYdvtodmH/C3R72il9oVze1G6qH9GMk+5NpQw8og12YA8/os1Fw2cUBsk14L6G7ZA1P7QNYGMMHKmmYlCaKZPwxBOA7Q35WRTr+6JqVU8m4Jg7JDBATzofnwRFGSM1Xnbt3p7f/nSfIesAJQvVh/1lI/Q5IIIySCNa/d18HpBDVvl6UetePN4GQlNpGUZKwHvI1XbmrcJDG4Zx1P7sgz9GnaP0VF8ghtQDWUJMUuXojDnsWgV8BFd05QLihutjusLY63JH1m2w7M8ql1D0zsNzZ2Q2+my9rRjdRvSQ7wDXThXYmaGrXf6q
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmtZM1VsTDBUTnozYURTMzg3SXFJcm5lR1FaL2k2a0kycWRMT1E3bE1kcWR0?=
 =?utf-8?B?cmJZL3Q5S3VMUFloTkU0UjBaVTJFOTBhem9XQ3RLY1hrdzFwU2xrUXZZeDRE?=
 =?utf-8?B?WVNvZC8yZ3lHNXA1TS9zSENHbzdHV0ZvVGJQVi94TzJQV0w1TFo1Y1ZUa3B2?=
 =?utf-8?B?SS9QSW5Hd1k3RjByR0IwUVZaSzVtZEpUb1hVbklaNllBcGVzdSs2NEN1SHRB?=
 =?utf-8?B?VW9weDBJUXloU1cydWNKSEQ1S05qcEttTXFFNStOMFlkWFBuWnM2Y1hKT25j?=
 =?utf-8?B?Q0IwaEFZdlY5UW1WbksyS2dRdll5Mll6aHNYanRIaGRIbEZKTkVFaFE4Z25j?=
 =?utf-8?B?WG9hQjZTVFp2aTVyd1RVL1NLMXRNK01zci8vY0ZLOExOdURsOWZkVnMrWkV0?=
 =?utf-8?B?K1lGQjhIQ2RNYmRRWWxYSlhQYjBJdnZkTWJ5NVRlUW45aVEzSUhlaEZYZVFx?=
 =?utf-8?B?Vmk5YWFUcFBzd1laVkdhanB6dC82dHJJei95ZTRETEt2K3JxSVZ0SkhvcVF2?=
 =?utf-8?B?S3EvSzFFUWdCaVdqMmpkM1JNTTBOWHRyeGkxcnVXY29FcVBNYlJ5ZCtTL1dj?=
 =?utf-8?B?OGNod3V6TTc0aHplSkdNVmRsTFoyL2p2MTlYTTFtNVBkQTFSQVpKUy9UbldO?=
 =?utf-8?B?WjdKV3BoeFY3ZU9OdFd3aFpqU0pHNkF5Y052LzYraU4rR0lpYVV0Znh2Mkls?=
 =?utf-8?B?OXlndDZleFRTMkFLYy9JVlREQ2p4ajhJR1oxRDE1V0dpVm5VdjBDanhwd2k4?=
 =?utf-8?B?RHloQXdMd0Q1QzNjUFM3ZEh6Sm9zOVRmSG5uVGJzTTVJdm9rWkRlZEdNUjNS?=
 =?utf-8?B?dW8yZXd1eFB0dElXNmxMSE0xUVhBRDdDa2NROW9WNFdDWTZQeGpMUVZ5MzRT?=
 =?utf-8?B?dVQ1WmZzREhBSVR0Y29MdXE5SFlMSUx3bHpTNGkxOHEyNEpKU1crTGl3T3Bw?=
 =?utf-8?B?VHhEZDJqNzZUMU5PZTZuTU9PVFZGdlkvc0hmanBaTEMrR0F3WDZINEdoSFZm?=
 =?utf-8?B?L1F4SitMVFl1cmtPSUc3VWtQaGFKbzh4WldmNWU1RkxHUDQ1WkNBK1hHNGRt?=
 =?utf-8?B?WXdrNlltTnQwSUZQOTJHL21UVmNKenExS1pPRFdXaFZIaU5tUWlUUGJ1aFFs?=
 =?utf-8?B?b0NuYWlWNmNlS1hTVUFlTzNySlN1b3FJbEU2QmhTMENLeDQvUHMzV0lNdXRl?=
 =?utf-8?B?alhWa3hVNFE0QWRLL1o5cGcxZWxzWHl5blpkUlZGSy9aOXI1K29GVE9kZ0l1?=
 =?utf-8?B?RVA5V1Ezc016ck5qcVdkSEplVm9IelcwUVVHMEEvRVgyRTZRa1N2dFN3WE5s?=
 =?utf-8?B?OFNVMnBnUVlpOVkvamROV3k0amJRWFVQOFIzcHlUUVhHUzBaMVBDNXd1YVZ5?=
 =?utf-8?B?VTJ2U3VITUN6OE1zR2kwb0lBQ1J2bVVZL2FqTGtrT0tXLzgwaGl1UFdacTV5?=
 =?utf-8?B?SWplRU5vRXdoc1IwSWRLUFRLYmdKcHl6NHhaTCs3cXkvRmlqeXhuU3diTmNu?=
 =?utf-8?B?QzBoTGRFdm5KRkd6YXVTYmRUZE9yK2dBb1FzZm9iUGdQRGw2OTRpaUp6RlpP?=
 =?utf-8?B?K1BNM2dZbjVRVDZNY0NaRm9xTTAzTnJTeHUyWlZ2VW9Ub1liTDJ3TG9jNHY5?=
 =?utf-8?B?ZkJBQVNvRXNVRTYzRHFEc3ROV3R4UGkwVGxWU0xHSlJTL213WU9MenlDZndC?=
 =?utf-8?B?WHNoWHFscmFPWVZlVW9UaTBscDZuTWRwWWQyc1dOYkpJNkovRys3UUNRPT0=?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-76d7b.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 72dfd22d-8f15-4c94-5b2e-08dcbe7214ba
X-MS-Exchange-CrossTenant-AuthSource: AS2PR03MB9932.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2024 04:07:16.5624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB10154

So I got it working again by re-creating with --assume-clean just as you 
said.
I did not note down the S/Ns of the drives the first time around so I 
had to try my luck.

I'm spending the weekend on creating additional backups and reading more 
into this topic (on the kernel wiki) so I can safely create a good RAID 
array with partitions afterwards.


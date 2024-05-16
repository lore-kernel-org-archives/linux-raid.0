Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2048.outbound.protection.outlook.com [40.107.6.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70849142E97
	for <linux-raid@vger.kernel.org>; Thu, 16 May 2024 09:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.6.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715852201; cv=fail; b=TSEPowyqorMfAI8+1YSvyiaRQmmIKVmk5a5b6MUnuFEvgcSOK4rM3Cd5BGtEni4I9ZwKZo6sm8d9CsH6oXQujCCaejBhE1odKu/8RxMVQb9j8QAUzUwVu5gyYCoe+7AqynU2TQ+iCTNpFjArsBeGUUwfKqHRfy4WciBD7HD71D4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715852201; c=relaxed/simple;
	bh=dJ9S/3wg4UYLm9ORj91tPcS5wptUM+3mhHV8GgZEZes=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RTBsDzoYFGhWxu+Lc7GQKzKO+asTE4LRyHg6ag3pmrw6JRYnDkAdpaDtLHfWekMSeGNdlXtQiSYxaI77v1PNxGp0sYzlw9Qs6cFw3y6qgY/8S6G2iGYwivHOYjyu3Eng35fRExgxYnfVkyB3Mmqwv821x61KYtAQ81p2MeES4mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com; spf=pass smtp.mailfrom=axis.com; dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b=HhKecwHw; arc=fail smtp.client-ip=40.107.6.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=axis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b="HhKecwHw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+t1CSOw5WJsivWVi2PZA7L4a1LKocTXi984VCykRMcvE3oWP/Wvmoi0nM5ajNHw52BAHMOu9AzZbBo1LZH+n5iVYRuY8uWhMs+xgU6UjhVAsCLHQqiLFZQKqM04wV0dkp2w4QkebV7SsZYx2IG92Q0bMWOxVWy2ZvRe9SXhTRlObbKrpqVX8rDM2kpPcgxG7P13CHQsuyVhu1gAwY+jEZAw43ofNsAkVbDi3tRmnkEAap9V1tXNwM8hHMUqY5FeXvN/wc4Vfxb74f4rnRuMAQdZG9r1uaCjSULoiH8qRIrRXCANGCt8v2NJM72ly97gwuM94tN8tdLGtf1HC1ARAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4On+8KstDKvdgutM2iuNT+dhIyXbo0DVCIkXabimYw=;
 b=kO2xVcDY42u6KDt8+CraPUrfvMLg0R9I5ADlRjDf8iy8AbvjgRexE1bzUxFcQChEISq7GPfTIFiH4Nw+MzXxG+Y6thIHjMs80OpDkHebxVfhRefScrzE+8OiFFXKiSijShwe1aXAuVOXsLRpxcplv0Mr6T6eAdoLz+igdJnqhim5+vk3dUAmrA0wG7NedjpqmSKxELmJz2BOQTdeTasUBWqJHIYDNntVHKVHT9eNsxxc/4VYsf8C2qNLpVFwPjyVbjjRVb98A8Nm3MQXIey8k76uJHyXlpyPg2r0grUOlazHgTgNyo0Oi0RmQw7TfZY1grkxaTJNZWwA9Eh1NVSUTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axis.com; dmarc=pass action=none header.from=axis.com;
 dkim=pass header.d=axis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axis.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4On+8KstDKvdgutM2iuNT+dhIyXbo0DVCIkXabimYw=;
 b=HhKecwHwi9xWGMeXvd3PFb5sRPHmXyfNkUMoyFN8nA/chGyNwkWCAimJwlhv/edbGM4nBsTjiUa0vUXav/BY266fI9iKL12hZkxYEHi2379HUjchQcPHSjol7zI82p65MiiZuk9hfQ1FZ45V2sLCeB+KX+8JP8JzVG5MVEwaxac=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axis.com;
Received: from GV1PR02MB10909.eurprd02.prod.outlook.com (2603:10a6:150:16c::9)
 by DB4PR02MB9381.eurprd02.prod.outlook.com (2603:10a6:10:3fb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 09:36:34 +0000
Received: from GV1PR02MB10909.eurprd02.prod.outlook.com
 ([fe80::42d7:280:d9dc:e5be]) by GV1PR02MB10909.eurprd02.prod.outlook.com
 ([fe80::42d7:280:d9dc:e5be%4]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 09:36:34 +0000
Message-ID: <39b79a1d-17cb-479f-b5c2-629e66436f07@axis.com>
Date: Thu, 16 May 2024 11:36:32 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: raid5 hang on kernel v6.1 in combination with ext4lazyinit
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, dan@danm.net,
 junxiao.bi@oracle.com
Cc: linux-raid@vger.kernel.org, kernel@axis.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <3bb2549f-846a-4179-9e23-407235a06753@axis.com>
 <8c4b871d-83cc-8f1a-c409-2ed8ec79dba5@huaweicloud.com>
From: Gustav Ekelund <gustav.ekelund@axis.com>
In-Reply-To: <8c4b871d-83cc-8f1a-c409-2ed8ec79dba5@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MM0P280CA0006.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::12) To GV1PR02MB10909.eurprd02.prod.outlook.com
 (2603:10a6:150:16c::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR02MB10909:EE_|DB4PR02MB9381:EE_
X-MS-Office365-Filtering-Correlation-Id: 49277110-2010-4f30-a0d8-08dc758bacec
X-LD-Processed: 78703d3c-b907-432f-b066-88f7af9ca3af,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3JFZ0hmQjRRRnd4TmJ3UUNyTzJaK1RSS2lxQVF6N3Zwa3Nxa0lXYnN4enFS?=
 =?utf-8?B?NldNaGtLblJnY3pqS25oTGwvK2dUSHdDS2M4YkF3UkxlR1QzM21LTDdZRnFQ?=
 =?utf-8?B?R09hNFFNZ2I2a1M5aTB2MzIzZlZRWDBMcFlxbVFOemRGa3l2eFN4azZXS2Vy?=
 =?utf-8?B?a1h3U1Vrc1FDUnM0b3NQc2V6T2g5UEcyRU9EU1JLWTRDUnBPaW9mMVFCZzQx?=
 =?utf-8?B?NEpzSDlDU3dFcHc1MjNORVVoQ3lCZmxyTi9oMFZoOW5VZFFkTTFLRTI1ZXh5?=
 =?utf-8?B?VWFwd2xaSUVnS2sybkFCY0UwazFNc09zVFJJTUcwZUtRZ01lcXpjakpzaXIz?=
 =?utf-8?B?Snc1dVZyMjRxbnBobkJnaXpUdnV1MlRVQkVDeHNlcmZLSnBCYUVlMjhSZzJp?=
 =?utf-8?B?Y0hsUDY5NWdVSFNUTmZmQmRLNlRnYUtwVk9rTzdqRFg4NlR6b2l2TGlBS0ZB?=
 =?utf-8?B?US8vMlBXa0RLeUhNdk5pM1liOFFqMWMxSXc1UFN4dDQxSHdTZlJaZC9iVUZP?=
 =?utf-8?B?YmRWR0loczd2TCtzaXE5WG9PaWdaRlcxZXF5RmVRWkJhd25BUUl4SHlvMEUz?=
 =?utf-8?B?N2l4Wmg4K3FrU0JEQ3VjVFR5MFRIOHU1eitydFpFd290UWhEeVFHWHdrbzR5?=
 =?utf-8?B?U25JallDb2x1TVRpWWw1aG9mSkdyZ2RKVTducCtrWU1PMyswU0Zka2Z0TXAr?=
 =?utf-8?B?TkhKL3h2OFVHb3lZdGc4cXByemNQTXRmZGlaMjJpSkpOdUFNY01ib09Zck0x?=
 =?utf-8?B?NkdEbkZqUTRBNENJV0g1aFBlaXJQNDJlSnRSY1FhaUZEL3N4ZWljbVBHWEpi?=
 =?utf-8?B?MmwwWmpoalRBbFFUQXMrQWdxTEZ0N1Z2NmxnVXp2ek8rTkF5UUQrOUIrZzF6?=
 =?utf-8?B?YXpHZ3BHTzljMHMxWHkwbzNmRGM0OGNhemVxWngrc2wrR0c3LzlrNW9FcUZP?=
 =?utf-8?B?Q3g0am5CQjR1TC9wM1hnVGlNTU15WUFqa3NNbGszaXVWeXY2WldGT2JUck1r?=
 =?utf-8?B?WnlHR1ZKQXp0OGdMUXRUQXNMbU55Q0FKalFHVDdrTnJwVnVPOGRtM2JBYnBU?=
 =?utf-8?B?NkRLMjd5UDVSVndnWUd5WEN0Y2FzTlV5WmR2eHcwbzFLamxlQlVKNXNHRER0?=
 =?utf-8?B?cXRIV0ZLbUg1SzdSbHJuS2VNL1BpOVRhNXJmcGd4RVpRdlZmTGIrdmFLa1dS?=
 =?utf-8?B?eXJVZjBwVTgwMnRqbVBJeEdidXl2aWhqOTlCMVhrYzlMdmhid043UmJJWWEy?=
 =?utf-8?B?d1VzUUlTOHM2TXBIU3VRNHZKdWRmeXpqUzliaGpra1lVVlFzK0d4cHhDaE1l?=
 =?utf-8?B?R0hQWmt6Vk9JT3gxRHorM0lydjI4MGUyZGJtUEJJczlQYUpIa1NqZWRQRDdq?=
 =?utf-8?B?ZzBzaUs2SjRDSCtKRTcyRGhSWm9uT0FkOW9mZGx2R0pTaStES0lrVmhDbmt5?=
 =?utf-8?B?MWkvdHhSYVErUnRtK05FU3kyWFZHek8rbjVjbUdaUDB5Z2lxcmFOQjRkTEZX?=
 =?utf-8?B?cVlPNDVYNTNOZ1lQL2pCUkxyT0FkMW1PYzh4NlFQanFFK0xXVk14dmdCZHR4?=
 =?utf-8?B?cG8raXVxaHZBd0I3VU5IZm4vajh3azNYRlBkMTlRc2VhRjI0NnZlQlNlYzUr?=
 =?utf-8?B?MlprbU5NWlR0L3RPU256cjd1VnVod0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR02MB10909.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGppckU5VlUvZkdaY29KNWhVU2hhRWRSR2dLczR4SE5nSmI0VkZQNk1QdURm?=
 =?utf-8?B?TUoyandpTWlYSGtwamp2SUNhSEhEU29OMFdESzBTUlJGU2YrNVVxaFRJWWVv?=
 =?utf-8?B?SHBQbDhyM0krRTU0b1pHUXRjcTVIZGdZUDhYVkFGNmMzeU43M2N4U2UxNEdY?=
 =?utf-8?B?eVVFKzM4bWZRd2xtTFBsS1B1ME1UOUdWb3RUQ3FPWFU5dnZTZWdsY1BUNlZQ?=
 =?utf-8?B?anl2cTM0dkYrTFk5T2xNMXlTM2JIb0pJTXI2ZTZYYUNzalpxbElSR1BVVVNm?=
 =?utf-8?B?SksyOWdSaEF6OU8rbG5NbDBaUmhoMitZWDFHOGl3RCswQXBVaEh1cm5ZVnFv?=
 =?utf-8?B?SWZNZHE2L3Z0Ty9jelhScjdVc3hQVnBCMUpoU0hUdGd3ZXVoVEZkbXVSTU1v?=
 =?utf-8?B?d2ZIQlNlLzVHQWxCNitFUm9rTTVBSzQ3YzJsd0JvUVZTdEhBVVZjaktDY3Q4?=
 =?utf-8?B?akhQb3MrNnF2YitkSUlPdndIQVJ6emRzeEtqSGJSMndOOUc5cHQ4U1Z0T0Nk?=
 =?utf-8?B?L0ovendiY20ydWxqTHZBbjkvbVR6QVpXd1B4TTJEMWxQQzBjbzRSUlk1Q0FI?=
 =?utf-8?B?MkVZSWhwQlMwbERZSjNuRTRUWmdGd21IM2JacmwxN0RNRUlwVWhtSnh6eWtv?=
 =?utf-8?B?MzdRSUorUlorcWNlakdYaVJ2RkYwcU0vZW05U2tzR3NsNVF1UlU5UTdUWGZS?=
 =?utf-8?B?OTJodVFKZUN0MWlvaiszdlBVVkN5MXM5UmdRSXd6dmFTdCtpZzFYQi9ZOFpN?=
 =?utf-8?B?eUw3Qjc4Qkg4Nk1Wc05kR0tYS1Vpa1hSN00yWW9QcTlYZE1hZWxPaThTaWpF?=
 =?utf-8?B?bkdkamhPSFRKWE5ySkdIeTZ4b1p1YU5SOHVYK2FhdW1VSlUyblBubTJ3TUpJ?=
 =?utf-8?B?VCtaUGl4Z2l2K1ZLeUdkek1obkFEZVVOeFFPeUVRaGQvQVJ5L0x4Z0hvSXVw?=
 =?utf-8?B?aFc1S1F1aWt4NVBKckhRTEhXQnl6VUQ2ajlnK1lTN25wcDhVNG9Xa0hDZDRy?=
 =?utf-8?B?a0Erenc2R280aDB1b29QWkZ2REF5b0lESVd2WS9QT0w5RzRrNUlGbUpPRTdR?=
 =?utf-8?B?aUNoeEJLRzhEN0NDdTZyeENlMHczazRhMGJsVEhjclFPOFlZbnVub0xSQnMw?=
 =?utf-8?B?T2lrbVQ2T1RJbUpkZ1JxZVViQkhKVFhESlowT2hMMjhBNWlZQmV5TkZDbUNj?=
 =?utf-8?B?Mk5RZlVCcWltOUgxcnY0UUpBMnNNWk5idHhBYzNWNFdHT0lEWnVvU2dSTmhE?=
 =?utf-8?B?cGpBYlZmWEZha2VlNFNxNzFzSWlSOEwxc0VWVlkzdWlkcWVxS0ZndFI0cklN?=
 =?utf-8?B?aEhwR053a2oreFJ0RDI5WnlpNmZ1NjJyajlJL0ZFSU1NaHI3VkR2L2t3Q1pk?=
 =?utf-8?B?Y1A1QzV1TC9ETktnWU5KYTNnYlRVY1pUUDUzMXFNSnI2b2x4ZytVUUd5WGdL?=
 =?utf-8?B?TXJzVk5vTGl2NjVJcFlQUmhXdVYvK1ZaRk5QelFMYW1ZaUhxV1dZSVdWRUdj?=
 =?utf-8?B?MDRVc1JxeUxtdDRCY0RIdWxybTJCZzJDaW5ITjh2S3J6UDlaQ1pla2xMMTVI?=
 =?utf-8?B?Y24wTWFweDRYUlg3SFNrd2VyOUR0T1p1Wno3QzlmakVTNmlONHRtTTZ6SUJs?=
 =?utf-8?B?K0wydTdNVUxXd3dHNmJqa255SWtZSHFMaC93N05Mb0FQRitRWVZrV1Q5R3Va?=
 =?utf-8?B?aW1FeDRycldBQVhZNGl2Z25KOER2U0Z6TUJMdUI5MDFnYUF3cFhjYmVseWxp?=
 =?utf-8?B?WEFQdEpia2dHY1c5UWgvYnl6K3k4SGRmSFZvVUorZW9ZQk9wYkp3TG56Umdh?=
 =?utf-8?B?UmRIZitIdVdoT1EwR1NOSE5pQ1MrNEY1aEVWMXRrOFJ5WEF3U3BZMVUyaFlz?=
 =?utf-8?B?UEltSlpvdVZqZTQyNVltcXk1Z21SWnpkenBFV1R5ZHRaVXlTcHhWbWh4TFBZ?=
 =?utf-8?B?ODJYbkhzR3pJdlRhL0NhbzZvR0s2azVPK3hoV21ucXVHeEdGTnZSTjJXL2I1?=
 =?utf-8?B?dDh0VWZGZU9qOFMxTmRta282SUtPV0tCalJqUlRmaXlNdjZ0Mm1EZjVpWDMr?=
 =?utf-8?B?bEdpSjNwQ3gyTkNlUVdvbkFDOC8vRjJpc1pKK0xlYnlyVERKb2dKc2dZMkQw?=
 =?utf-8?Q?M2E1gX/sw4BbvwVn7EyD26CJY?=
X-OriginatorOrg: axis.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49277110-2010-4f30-a0d8-08dc758bacec
X-MS-Exchange-CrossTenant-AuthSource: GV1PR02MB10909.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 09:36:34.3441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1RZXx3fIn/4YJTaFar8JNndGFfZEvjArCAWElq9oT6hifS/3G9bpLPH+n5aww8Gty7RgVl0VMsENHZSIC3gaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR02MB9381

On 5/16/24 03:10, Yu Kuai wrote:
> Hi,
> 
> 在 2024/05/15 19:57, Gustav Ekelund 写道:
>> Hi,
>>
>> With raid5 syncing and ext4lazyinit running in parallel, I have a high
>> probability of hanging on the 6.1.55 kernel (Log from blocked tasks
>> below). I do not see this problem on the 5.10 kernel.
>>
>> In thread [4] patch [2] is described an regression going from 6.7 to
>> 6.7.1, so it is unclear to me if this is the same issue. Let me know if
>> I should reply on [4] if you think this could be the same issue.
>>
>> Cherry-picking [2] into 6.1 seems to resolve the hang, but following
>> your discussion in [4] you later revert this patch in [3]. I tried to
>> follow the thread, but I cannot figure out which patch is suggested to
>> be used instead of [2].
>>
>> Would you advice against running with [2] on v6.1? Should it be used in
>> combination with [1] in that case?
> 
> No, you should try this patch:
> 
> https://lore.kernel.org/all/20240322081005.1112401-1-yukuai1@huaweicloud.com/
> 
> Thanks,
> Kuai
> 
>>
>> Best regards
>> Gustav
>>
>> [1] commit d6e035aad6c0 ("md: bypass block throttle for superblock
>> update")
>> [2] commit bed9e27baf52 ("Revert "md/raid5: Wait for
>> MD_SB_CHANGE_PENDING in raid5d"")
>> [3] commit 3445139e3a59 ("Revert "Revert "md/raid5: Wait for
>> MD_SB_CHANGE_PENDING in raid5d""")
>> [4]
>> https://lore.kernel.org/linux-raid/20240123005700.9302-1-dan@danm.net/
>>
>> <6>[ 5487.973655][ T9272] sysrq: Show Blocked State
>> <6>[ 5487.974388][ T9272] task:md127_raid5     state:D stack:0
>> pid:2619  ppid:2      flags:0x00000008
>> <6>[ 5487.983896][ T9272] Call trace:
>> <6>[ 5487.987135][ T9272]  __switch_to+0xc0/0x100
>> <6>[ 5487.991406][ T9272]  __schedule+0x2a0/0x6b0
>> <6>[ 5487.995742][ T9272]  schedule+0x54/0xb4
>> <6>[ 5487.999658][ T9272]  raid5d+0x358/0x56c
>> <6>[ 5488.003576][ T9272]  md_thread+0xa8/0x15c
>> <6>[ 5488.007723][ T9272]  kthread+0x104/0x110
>> <6>[ 5488.011725][ T9272]  ret_from_fork+0x10/0x20
>> <6>[ 5488.016080][ T9272] task:md127_resync    state:D stack:0
>> pid:2620  ppid:2      flags:0x00000008
>> <6>[ 5488.025278][ T9272] Call trace:
>> <6>[ 5488.028491][ T9272]  __switch_to+0xc0/0x100
>> <6>[ 5488.032813][ T9272]  __schedule+0x2a0/0x6b0
>> <6>[ 5488.037075][ T9272]  schedule+0x54/0xb4
>> <6>[ 5488.041047][ T9272]  raid5_get_active_stripe+0x1f4/0x454
>> <6>[ 5488.046441][ T9272]  raid5_sync_request+0x350/0x390
>> <6>[ 5488.051401][ T9272]  md_do_sync+0x8ac/0xcc4
>> <6>[ 5488.055722][ T9272]  md_thread+0xa8/0x15c
>> <6>[ 5488.059812][ T9272]  kthread+0x104/0x110
>> <6>[ 5488.063814][ T9272]  ret_from_fork+0x10/0x20
>> <6>[ 5488.068225][ T9272] task:jbd2/md127-8    state:D stack:0
>> pid:2675  ppid:2      flags:0x00000008
>> <6>[ 5488.077425][ T9272] Call trace:
>> <6>[ 5488.080641][ T9272]  __switch_to+0xc0/0x100
>> <6>[ 5488.084906][ T9272]  __schedule+0x2a0/0x6b0
>> <6>[ 5488.089221][ T9272]  schedule+0x54/0xb4
>> <6>[ 5488.093135][ T9272]  md_write_start+0xfc/0x360
>> <6>[ 5488.097676][ T9272]  raid5_make_request+0x68/0x117c
>> <6>[ 5488.102695][ T9272]  md_handle_request+0x21c/0x354
>> <6>[ 5488.107565][ T9272]  md_submit_bio+0x74/0xb0
>> <6>[ 5488.111987][ T9272]  __submit_bio+0x100/0x27c
>> <6>[ 5488.116432][ T9272]  submit_bio_noacct_nocheck+0xdc/0x260
>> <6>[ 5488.121910][ T9272]  submit_bio_noacct+0x128/0x2e4
>> <6>[ 5488.126840][ T9272]  submit_bio+0x34/0xdc
>> <6>[ 5488.130935][ T9272]  submit_bh_wbc+0x120/0x170
>> <6>[ 5488.135521][ T9272]  submit_bh+0x14/0x20
>> <6>[ 5488.139527][ T9272]  jbd2_journal_commit_transaction+0xccc/0x1520
>> [jbd2]
>> <6>[ 5488.146400][ T9272]  kjournald2+0xb0/0x250 [jbd2]
>> <6>[ 5488.151194][ T9272]  kthread+0x104/0x110
>> <6>[ 5488.155198][ T9272]  ret_from_fork+0x10/0x20
>> <6>[ 5488.159608][ T9272] task:ext4lazyinit    state:D stack:0
>> pid:2677  ppid:2      flags:0x00000008
>> <6>[ 5488.168811][ T9272] Call trace:
>> <6>[ 5488.172026][ T9272]  __switch_to+0xc0/0x100
>> <6>[ 5488.176291][ T9272]  __schedule+0x2a0/0x6b0
>> <6>[ 5488.180618][ T9272]  schedule+0x54/0xb4
>> <6>[ 5488.184538][ T9272]  io_schedule+0x3c/0x60
>> <6>[ 5488.188714][ T9272]  bit_wait_io+0x18/0x70
>> <6>[ 5488.192947][ T9272]  __wait_on_bit+0x50/0x170
>> <6>[ 5488.197384][ T9272]  out_of_line_wait_on_bit+0x74/0x80
>> <6>[ 5488.202604][ T9272]  do_get_write_access+0x1e4/0x3c0 [jbd2]
>> <6>[ 5488.208326][ T9272]  jbd2_journal_get_write_access+0x80/0xc0 [jbd2]
>> <6>[ 5488.214683][ T9272]  __ext4_journal_get_write_access+0x80/0x1a4
>> [ext4]
>> <6>[ 5488.221392][ T9272]  ext4_init_inode_table+0x228/0x3d0 [ext4]
>> <6>[ 5488.227298][ T9272]  ext4_lazyinit_thread+0x410/0x5f4 [ext4]
>> <6>[ 5488.233066][ T9272]  kthread+0x104/0x110
>> <6>[ 5488.237069][ T9272]  ret_from_fork+0x10/0x20
>>
>> .
>>
> 
Thanks for the patch Kuai,

I ramped up the testing on multiple machines, and it seems I can still
hang with the patch, so this could be another problem. As mentioned
before I run on the 6.1.55 kernel, and never saw this on 5.10.72.

The blocked state is similar each time, with these same four tasks
hanging in the same place each time. Do you recognize this hang?

Best regards
Gustav

Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021142.outbound.protection.outlook.com [52.101.70.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DCA2AE9F;
	Sun, 21 Jul 2024 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.142
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721572857; cv=fail; b=kCbJM91SUiYqyGHsxR/zHiLq53uRxWh5y2pLnNZJZCW/Ituy6ICdOFxJH52iaotzaq4JKxExGTnhjNqk5kd+O2a1WnPbOXpyS0mxE/KT9OH0F/cwIKnO0TFslkQ9fTb4QvFPH3LG47S8H8vNhJc2kcPdM9N85PggtPLbsFesJP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721572857; c=relaxed/simple;
	bh=PqFJQOiA7RXR5LPqC3KGG3TVEmrqvtNWPOO8G1JT3AU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bpKILS7MaARVRHGabDPpf2+P1j5xDlZVF7ibsCpWEyG8+EjW+KqDYZCMY+vE9Mff+sIVZGt3cy8FtHigXCY3cKfNWRwFVf7sCTRtee4h/fiHd9cMGaZVE9JRz3+BhQnFx0krb9yrmq+6r/IdXfMLJaX0MoUEBsL3fb3u7Pu3km4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=OwRmJrLJ; arc=fail smtp.client-ip=52.101.70.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="OwRmJrLJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u9dSv2wxqOtl6MAXN54fSs3vdjz0qTQ7z7Xc4BcpNU5q9v5Cx6Fk6iymC3k2B//8a9+RhpSGK/vMle1LW2eROmTQe5lXxxrDo8HXQ/YrdmgN68v0AhLLh+iOrKjP/sIHJzjeBFD1IzlwcPH8qXg3PsdD4wYF0Dk/pPQDfUuwdQmvcT5zMTFEhJliaV0F1FSahnLX9E/i0/HgAjsMH7tPc2RvZEJB9RUuDmy1H8VL6ljEf50KlqOXqDhJKuUQfTcjCHHI282TuDARI5/sMcJOIw1LLdKl7GRyDJhadeon9f1JPkhKONADhBDwoYDhZHvSyC13cXhS+nbApwtALiDFfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PqFJQOiA7RXR5LPqC3KGG3TVEmrqvtNWPOO8G1JT3AU=;
 b=eHvD9AHX9oRTpAL3W1f0Ljt0KluOSMpYZPs0vioaqHkZz6W1tfiqHgmdebxQJA1rOSCprhQuO1VEPfZQuNaFgGtywicuGehuKp2wPxF+ub3vkuM73weQYnYF6eolzJWxiaaRbH5Qw+6SvqOxzQKU1/gowMwIorPJKcwwTTTu7vAdMrDrZNGHQvOm2apLUUL/RL1Z+bVhVqQz/vFj53DaFNXasTjhQPrtoeP7KLqWO0T1IJfzlIxbOD66PReawFzTWL7KRFStj9LqzN4lbkAtOtdoYsecjQAGNyBNzxSITHQgc1d4RaqaQ/+8Jp6EaBwjTox373KgldzpQsCKUAhhLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqFJQOiA7RXR5LPqC3KGG3TVEmrqvtNWPOO8G1JT3AU=;
 b=OwRmJrLJBfJqAVT1F9OeByeX1zBHwXMTATRinGJVIauPGLMcBt86MOMAIyqKE9kUQ4D0X0eTwX2MXzXau9EoLU2KsQXtJ8fEC1BgUMaOLz3T2Ph4nqhIuw8keaiA39FzBPHe/srJTtaTbTqE/MEy9AIFaYqh9FXWxe8M08q+/vOAPNrcbZwDi6rVvGvG7SR3XzuMZXE/te6nWaG0qWGTevsaXDaYWP+EVrQy216kdprZpORmFz78KZm+2Cr8lAAldPtWEaY639WUFLl05kegvLvTn7ThbO7d9sSbwB8J9c+ISzAsnA9HqITeloK2637BzQbUANZ2UwyeKvwKYwo9BQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::20)
 by PAXPR04MB8655.eurprd04.prod.outlook.com (2603:10a6:102:21e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Sun, 21 Jul
 2024 14:40:51 +0000
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7]) by AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7%5]) with mapi id 15.20.7784.016; Sun, 21 Jul 2024
 14:40:51 +0000
Message-ID: <eb9475e5-5a86-4331-8dfa-55e342e1cf37@volumez.com>
Date: Sun, 21 Jul 2024 17:40:47 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH blktests v4 2/2] md: add regression test for
 "md/md-bitmap: fix writing non bitmap pages"
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: shinichiro.kawasaki@wdc.com, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, dwagner@suse.de, chaitanyak@nvidia.com,
 yukuai3@huawei.com, linux-raid@vger.kernel.org
References: <20240721071121.1929422-1-ofir.gal@volumez.com>
 <20240721071121.1929422-3-ofir.gal@volumez.com>
 <8aac874e-f4f5-40a6-9e3c-1c88a8c49378@molgen.mpg.de>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <8aac874e-f4f5-40a6-9e3c-1c88a8c49378@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0015.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::11) To AS8PR04MB8344.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b3::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8344:EE_|PAXPR04MB8655:EE_
X-MS-Office365-Filtering-Correlation-Id: 496f536f-e6c4-4302-4d54-08dca9931e3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlNWdURhaU1ZaEFJdFlKOGpmN3orV3dGSUpoN05aTkpQS3lqT2kyZUQvWmsy?=
 =?utf-8?B?RXhESW94b1dmWnFNYThOMzZtK1lQZW9EbWJQcFYyL0JCVXljcjFDL2VhVmZh?=
 =?utf-8?B?VmxZMGlsY1FUWlJGaU1XMDluYkhIeFhGbXorSnRHQXdnRlVYR2tEcWZiTUtQ?=
 =?utf-8?B?aXhKaUFIN2p6cFJNWU9GcnRNL2JaM0VSREs4ZTlKaTZwby91S0tma0VmbWNi?=
 =?utf-8?B?ZWdCUndLeGc5dHJlVkViQXVFNkRUSUtnNFY3VzltdVJCc083S241M1A2RzVp?=
 =?utf-8?B?SVkxbzZURWhZVFFHK0VrRjVYcTlnc0g2UlJwNTJMS0krVDRNVVhoQ0FVYU96?=
 =?utf-8?B?NnBodVNISWNvNkNuektiMjJ1UU5LbUFPQnJRUk5kWlBFWDFoLzExRGN6ZXdD?=
 =?utf-8?B?YnN1STMvaGs4UE1zNERWQUZRdXNhMmRHVzdaWmpCVVJ4YnNuTWFoeVJvMXdr?=
 =?utf-8?B?dlo0SlhlM1NjVnlWekU2SDRwV1F5dW0yemlRSzA3MmN0MWt6NkpEcldUTHR6?=
 =?utf-8?B?czl0cTAxalRQZXZib05CWUd3VCtqTldNb3BUOFpsSmc1TlpsTUNTdHVTSnhX?=
 =?utf-8?B?MUF6Tkh1M21VVUZpbjRnZU9DWXpmUDhKMUtjckRoaE9yQjFKTnl5QlhtbjJt?=
 =?utf-8?B?ZzdNZW5ZcHp3b0pFcUI3SUFkek56N3FBU0VWcEx5UDlBazJPQVBPbFJZMmdQ?=
 =?utf-8?B?Y1UxSS9xWEVTd3BEOUE3bDFVYjFCaDljangrRWtDaXBmdDBNbzQ5OGwvM1Ba?=
 =?utf-8?B?b0hrT1RCTFB0TXZFdWhncm5BTHptWmVEOTJKMjZLbUdsOU03cnAxMGpuTVRh?=
 =?utf-8?B?RTRhakI4Zm9IQ3pTdlMzQXBVSE5QL2Z2OE1zckp6STFyRVlvYStSSHlSSjlS?=
 =?utf-8?B?R2J0RkxwVjVkV3lIaUpkdkpMeHpzUFpkUDYvQ1oyYktjKzVuUEN3R2RNb3Jp?=
 =?utf-8?B?ZWpOUkh0QnM2VHZhYWw3OUFGVUVTMnB4QnFnNnAzOVBwK1J6eTllWkpRMEJF?=
 =?utf-8?B?a2dWN1ZlQ0pVVGROYms3MkE0OW1oa1A2Q05ja1hnalVjWXNtYzNDTjRkN2NN?=
 =?utf-8?B?UExnMmUzZ1VaSDZaZllPRFk1SUVyT2dkRWtuNHN2V3F0YzZHakV4RXFKdG5C?=
 =?utf-8?B?MXpBbmtSQjdLbUNiWUc0ekU4RHVsOFk0RGZubW9uU3loYW1OUGxhaHU2bFNZ?=
 =?utf-8?B?cVZlcTRwTHZLaGF3RlVweElUc0Q4RXZ3Sml1ZmhXNjRFUjdoM3NqZGx1NEN6?=
 =?utf-8?B?VmFybGJxUmc1cFdzbVU4bDhWWWlWeUlDNXNMMCtxSi8xUjBwMm1KcVREa1c1?=
 =?utf-8?B?SWRWOEJJNVc1OFlHNzJqc3hiaFcwZUN2d3NqT3NPTE1HUXBPZ2hWa1BrVFRy?=
 =?utf-8?B?cnk0dzVWWlNPRU90dzNUWXhJdzJxOFRCbE5USVFndSsyRW9pcTFWVWxwMUI1?=
 =?utf-8?B?K3Vxa01Vd3p4MWRVWThIb053MVJNRmk1MzJ2dDhJTlh1U1RWcWR0dWVqd29P?=
 =?utf-8?B?eFVwRUw1THNKa0hqQzBXZ0toVzk0ZGFJSm9qSmJTekJZU3U5bEYwakMySnRm?=
 =?utf-8?B?N0kvQmdwU1h1N3ZKbUkyclI4NWdDdld2bTVYeDBtTlArMDdGZUZ6ZVZCZkg0?=
 =?utf-8?B?Ky9OZWNPSlg0dzd0OExGSHRGMlo4V2lrRUF4RWwzdjFZSDVNekNqbXE2RGtq?=
 =?utf-8?B?QXlNWHRNeGRKVXVsSy9IMWQ3VUtmWkRCbXZseTd0QWR5dHI1SVBEMkJpVmd5?=
 =?utf-8?B?Q0FUQi9hbmNndUZKblhvRFBMMXdtUHhKdm9GSWEvRXFwZWs5cFNHcGlieXRB?=
 =?utf-8?B?MDRYNktGaEIxNzc3dmhGUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8344.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXFUakxTcW40Qk1yVjYvekl3QWw0WUswYXI5bm1qb3VoeVhpYjhmd1hZMmpi?=
 =?utf-8?B?OVBlREJQLzdXRlpCdERmRnJLU2NNQUMxdHg0VUdtcnduQ2dRZU9KQStvRVdw?=
 =?utf-8?B?UXE1V0Y4U1V1bFJBUStlS1lqSzBYTUdjejlYWkhmOUx1ZWpJcmo5QWJWZUNn?=
 =?utf-8?B?ZHFQRzhVQm9Yc0gwODZhREJOQ2d6dFk5aTFhZEJTbElQaHNlTmJmdGRmczJP?=
 =?utf-8?B?d0o5VmtML1BUNGJaS25UUUYyRXpPbk9GMFY3OGJzZEZudWEvb2VFM1oycDVl?=
 =?utf-8?B?QnBqM21mZ0RoOUI1SzdGVytYVTMybkRhakFkZ0NOdEozYUtLWDkrNFJXdXRB?=
 =?utf-8?B?SUFuVzkwVXpGUHAzdzBjbFVOU0Rsb1liUnpwS0Q0NHdxQlg1VFhCUG5BR3Qv?=
 =?utf-8?B?YUo5RU1oMkZGRkhrVnM5TnEvT1crRVRmelNlaTlYaDc2azBybzcwenlvOUpL?=
 =?utf-8?B?TFZYYWFZbzlFcjBseldiL0JhQks4RW1aZitENEZXVWJMWW5qMG1PalB3VDIv?=
 =?utf-8?B?WEZyOGNxNVcxTzYrUkYvS3dhS1ROVmY5UWNBU2R0SWFsd09ZenA2NGNweGVF?=
 =?utf-8?B?OWJZQkoxYjBzN3E3eVlSeGFTcGRJVkUwbGFZTUFkeFJsQnBJWGtBd1BCcUJB?=
 =?utf-8?B?QjBVaWVUN1ptZ2hmQ2xmbmFLYmFpdVBMdkgreWRYemI4OTUweUNqKzN5ZTFT?=
 =?utf-8?B?RU9jV2lscHY2dFNUQml3Sk0yQXpvZ1V0cFEzYXNOMnczdWRvQjdIcTJMTVlm?=
 =?utf-8?B?ZkxpS2d4QUJRWTNoRUp2OFBFT0dHbDVjVklsbFdpeDhsK3BKRGJYdjJyem9N?=
 =?utf-8?B?S2MxeThIcjBoT25oUldXcUtoQTg1Vks0STlmVFhGR08zTWIxTkNFK2RHZTBi?=
 =?utf-8?B?dTFoZjZHTnRmTkZHUW56R0ovVlJ6bEQzMVJaZThTbFlkYTNBb0Y5VWw0K2RZ?=
 =?utf-8?B?VWFGbkJobUFnSGM5QUJGUHB2QS81TVFQK01wY3pUcWVSNGRvMVFuV2Y0bE9Q?=
 =?utf-8?B?aUpzS3ZZakROOWVhQTNxanNITlpSNXFtNW11RGRXQnFzbm5PNEZ0aFNFbTcz?=
 =?utf-8?B?ODRKQ3ovVHpQSUEwOFpVa1A2Nk9RcWowK3VtbFRFOGUyYVBBM1Nid0YzUWlD?=
 =?utf-8?B?dVVvNGZpK1o2bk5lUmVuSjdMWjdpR1dDbTIzN0FFckFrRFlJV0NPTmhpeHJG?=
 =?utf-8?B?dGhiOUphMWs3M3BkOGdZSkF5a1ZWQ242Wk1YMkdNKzAzYmtjd2Q3ODZrR1c4?=
 =?utf-8?B?cXNXMk9NVU5FbFBPTEVndDFkbk0wV29pMnFvbE5NTWovblRXTU9ocnBlLzRr?=
 =?utf-8?B?d1hpa2thSVIrWDZ6UkJIOEhiOVlQNDh2OS9Wd1doTUNteE4xV3VyeW5jNnJt?=
 =?utf-8?B?UGpDb2xYQzhqS0E1THNqMnR5VDJNbmw1Ym94dWNBTTFxaGFadzJxdS92b09H?=
 =?utf-8?B?TUt0NnVmVHJlYWkyVnlFRTM2NForbjZWOWpQZlN5NUJzRVR3eWMwOWl1OW92?=
 =?utf-8?B?ZFFyZFhId1BtcUkvYXRiekpJUjFCVzd3RVM2MktKQlNnTkM4OERSMy9jN1lL?=
 =?utf-8?B?YmJnSzRwREZwMG4yeXVDQ2NVTzcrOHYvdm9jYTE5em0rYWg4RG1ST1hrSU8r?=
 =?utf-8?B?eEZoNHJhM3NKaXZBQjhQN2pKbzBTa09ybDk0WmhrMmlFUTJ4ZjYxQks0WnpM?=
 =?utf-8?B?MkhBc0hvZXFmKzZ1UUIydlFlbldNTCtzY0ZtaEVoZWFqbG5ISmpLSW44c00x?=
 =?utf-8?B?eEZnWlZxRG5hNElwWk42b1lHWTFGYk9lNU5OWFdRNVVQYlA0YVNJWkJVQmxD?=
 =?utf-8?B?NDloaGY5dUVQWEZHbTZqT0hjOTF6Q25La2hrbjUySzVUeEtvVy9Ob0pDU1B1?=
 =?utf-8?B?enBZUkhIY1M3b3YxbUptdjVNMUFZOWY3WiswdlNlRWRrZGpObWdzWTNWTE1t?=
 =?utf-8?B?aDlzZDNESC9LbmhTdTVkTlJ0V1ZIK3hSNENhQ0l5b1F0QmNvazhoSWkwcHox?=
 =?utf-8?B?LzA4UzdWSEpqd3hRRGhKTVFRS3Y4cldWeDZ6ckF2L1RlZ0M1d2E1M3AxL3VW?=
 =?utf-8?B?eUs0V2thcCtEclNMQktaOHJ1MVpQNkF3K1pjeW5LZVBzMUx2YUJRUC8wZEZV?=
 =?utf-8?Q?jnvTadk9rEwbqitOVf8yV17Pt?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 496f536f-e6c4-4302-4d54-08dca9931e3e
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8344.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2024 14:40:51.3423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmi/EiGMSilwAynsIlePxdBTWGpzxwHjHjl9mqMKSjM2PM4LfZ9mobN42B6tvdW7cRCeMf3MMiRVo4jnj0csew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8655


On 7/21/24 13:23, Paul Menzel wrote:
> Dear Ofir,
>
>
> Thank you very much for submitting a test case.
>
> Am 21.07.24 um 09:11 schrieb Ofir Gal:
>> A bug in md-bitmap has been discovered by setting up a md raid on top of
>> nvme-tcp devices that has optimal io size larger than the allocated
>> bitmap.
>>
>> The following test reproduce the bug by setting up a md-raid on top of
>
> reproduce*s*
>
Thanks, will be applied in v5.

>> nvme-tcp device over ram device that sets the optimal io size by using
>> dm-stripe.
>
> For people ignorant of the test infrastructure, maybe add a line how to run this one test, and maybe even paste the output of the failed test.
>
blktests already documents pretty well how to run the tests, people
should read the docs of the infrastructure. The expected output exists
in a different file (md/001.out) as the infrastructure demands.


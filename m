Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2085.outbound.protection.outlook.com [40.107.105.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571A224215
	for <linux-raid@vger.kernel.org>; Fri, 17 May 2024 08:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715933101; cv=fail; b=Ooagm37T8DWNB6fQ8ppV4EPqaFc4oqIHjvcXilOOKRYd04RnyW47niaFBLyymADyJSWCM+GN5maQDv8dRGQkFGYRc+pire6+8VREjzCrIXTxZC8AVzmL9/UculAlBSDASKMBi7SCPlZOnc4A3IFKmyUNiBBSmbuv0h+ruiQSL10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715933101; c=relaxed/simple;
	bh=WkbTdr7USLICZCZFaiJSLUK0mFx6nXHZuqbk5ymEm2o=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=itCxHll2RamvhHNPVO+4DM+jS3F88FD9NDo+kNeOj9STqN57L0ZE207QosffjG4y46YMS1SUrietpAsyR3js4nd3+3FHJ1Cg6zSwibMyFTPpf22F417Mxe6bxfIn6NIx6Cj2KORJgohAzREodaXtANjKQ7BEnl2j7/KIV1IAwl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com; spf=pass smtp.mailfrom=axis.com; dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b=IMQflWQ3; arc=fail smtp.client-ip=40.107.105.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=axis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b="IMQflWQ3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfH+bUWfo68oppzTiEq25SMhGoihbQdnreWz4bD1JZ5psPyBuCZNDqGF/Lyaak6MyXYvkPzkbkXCbfnUV0UayTUWpLOt0AFunNNGoqOflQuEjAOFY1QGcbqXwwtvB+qAcfPeXB8AA2/APUheqkYbJTw5runEJm0cBpzBNzFMphycltPJkH1ANu+IVj2TM0urKmhSsRH3gUQy6YU4TGZqJEoBswnn+lRaYrkRikqNIExROqZZPaR9ZBTGnYCtNc/oP/KlltYBvyNVdPcVKUgJxdY1MGV4hdqpE9GxzLTVIywQqcu6p0aJDFEvf3mrBKdWg01NmEfYmdAiqsJBtIV2kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASneKMp9UYi8zHzjTllE2IW//f/UOg0B9B6wb4YCS1c=;
 b=JKLZaqmnB6l8pARIKh6SEqEt5J2aGIWyvS1Le6rdgwg1VPw8byUl0XftzoslhbH9Z2dGTACSBLZaVSfBbDi5v2mVyQhwG40EMJ7lhKUMqjtPykNSka7eg79aYgg6CbUi9T7efzivSijIqP9HphlHrpc2XT2rASAcIW8ed9Ub84YD0nXUrpXjdiddUuRO89mmcjmTpkKSc7suPMP0RijfoPgCWO7o99v7xi9ebwVfynftBb6gdWKH7gdFrUZ+Fqm3WR12X3z1eSlgFd5mSYDjFukN4vwpxc2t/CD+m2qaKTgHmud7ShY4cMp1T3TYM7t5vEiHvQxntz+UHmDMLPJBww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axis.com; dmarc=pass action=none header.from=axis.com;
 dkim=pass header.d=axis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axis.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASneKMp9UYi8zHzjTllE2IW//f/UOg0B9B6wb4YCS1c=;
 b=IMQflWQ3Nk8TGQo+9cz10dZWJV36wArHJuw5wwl93PR1yL9UtXY4PO847Ici0nfzB4tFH2oMLJlArERFzkTDKmmJJwHy1OOScW7wcXrJkQ14mjLuRwj3mSE9lEFPqc4N0589w6jKsVjnLvzjX7I3gRD+qkptXXDEFWRnEXI5GX0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axis.com;
Received: from GV1PR02MB10909.eurprd02.prod.outlook.com (2603:10a6:150:16c::9)
 by AS8PR02MB6950.eurprd02.prod.outlook.com (2603:10a6:20b:2e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Fri, 17 May
 2024 08:04:55 +0000
Received: from GV1PR02MB10909.eurprd02.prod.outlook.com
 ([fe80::42d7:280:d9dc:e5be]) by GV1PR02MB10909.eurprd02.prod.outlook.com
 ([fe80::42d7:280:d9dc:e5be%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 08:04:55 +0000
Message-ID: <b1417467-3cf6-4086-9edd-5ad0c059f72b@axis.com>
Date: Fri, 17 May 2024 10:04:53 +0200
User-Agent: Mozilla Thunderbird
From: Gustav Ekelund <gustav.ekelund@axis.com>
Subject: Re: raid5 hang on kernel v6.1 in combination with ext4lazyinit
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, dan@danm.net,
 junxiao.bi@oracle.com
Cc: linux-raid@vger.kernel.org, kernel@axis.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <3bb2549f-846a-4179-9e23-407235a06753@axis.com>
 <8c4b871d-83cc-8f1a-c409-2ed8ec79dba5@huaweicloud.com>
 <39b79a1d-17cb-479f-b5c2-629e66436f07@axis.com>
 <40102c57-9197-fc54-c8d0-5c6e906aa38a@huaweicloud.com>
Content-Language: en-US
In-Reply-To: <40102c57-9197-fc54-c8d0-5c6e906aa38a@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MM0P280CA0004.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::18) To GV1PR02MB10909.eurprd02.prod.outlook.com
 (2603:10a6:150:16c::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR02MB10909:EE_|AS8PR02MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: caf3562c-cf91-46df-fa33-08dc7648097e
X-LD-Processed: 78703d3c-b907-432f-b066-88f7af9ca3af,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFc3YW5Qb1c5bDJWd3VyQ0pPV1cwdzJ6RVN4RmtpNzYvUW8wTlNablB2Y3V6?=
 =?utf-8?B?SVBFZDBGNE04OTZiQXNMTyt5cWpZWUxrQVVWUUE1YUpQZmJwODgyeWFNR011?=
 =?utf-8?B?Nzc4anZraGxwSjVBSzFmbmNSSlRnd3Z2cU1IcWU5WUE3Y05WZ25FUFkvSUx3?=
 =?utf-8?B?Ni9wUkxjQzFtQXlLa3JLclBnczJTUnpEaDBYd1RneW8zdTl2SXJRN0FnMlZS?=
 =?utf-8?B?RlBZTjZQNFEwbTJXSVI3cUY3TnJVZVgvNzlRbWF3NnVaM29iamNqamRqUitw?=
 =?utf-8?B?VHhrdDVxS2x6NXpucFZHOFF1YnlUaHRaWkJKSHp2TjROaXRrU1gyc0tZQVU1?=
 =?utf-8?B?MnBoOUpobU9ieDNGQXoybUlkNFUreDdrWEtRQnd5dEd6aGNQQUpHejZienNz?=
 =?utf-8?B?T0NYZ0svVHJaRFlqSnVYUG90TGNPZHJueVczb0xJT3JxQjl5MXZYeUllWnQ3?=
 =?utf-8?B?eGZmV00rUjd1TkkwSVR5MGVvSURLN0hNNFZqLzhuS1QveDM1dHJxZm95c015?=
 =?utf-8?B?aGcyWXlPR3ZNaXNNOWtwVXVJaEEwS2VtMG5jdFFqZCtGTTRjaGZTNVUvaERk?=
 =?utf-8?B?TnVqSUQzTDRlOVNmMk1vOXp3QlZ5UkEvQlAxU1V4WE1nd2tTRmdYNkJrNTJR?=
 =?utf-8?B?SWNFYlgwY3prOXgxaEJMUkt4T1l3S1ZUZzd5SDBPdVN6Qm9aZ1dFWTFqWXdw?=
 =?utf-8?B?NkYvZ2ZRWGNZaUVNaFhDMXM3Z1VzRHdpZWI3UGZvM1FWNzNqUS92eXB6UWJP?=
 =?utf-8?B?ZDB3TFVkMXpiSi9ydEpURlpYRitBSndSd1BNUFhZdWlGSDNORzRKR1plSzVr?=
 =?utf-8?B?TnVXeWFBVHBwSEo2bmZpaWtQeEtVLzl5OTRoUWVWRG1GMGM1RmRiV29qb1k0?=
 =?utf-8?B?SEl1TUhBZzNFc1htYjJnc1NkcDNSanZ1MEMvNnRYV01wYUNoWGRLY0xCRjFJ?=
 =?utf-8?B?VS8xWkNwWkdubUozRHBJelA0bWpRb2xtVmdBcVF6K2NIUFVsaDk1NnRlMDBw?=
 =?utf-8?B?b2E0SFV1MWhEVGo0dHlqTkZzUmpaVktuc3gxVFNSK3puSFZyNFRHb3hFbS9Z?=
 =?utf-8?B?azArOU5pM3RuWjgzVElVZjdpS2t5QUJRTVY5NkF5UDMybHZRTVpNeVJTZU9W?=
 =?utf-8?B?Q200amtFcHdzeXBBQnFIN3lmWVc3WXVGZUNxTHlFQ0YycDEwQktFYVFLV0Fp?=
 =?utf-8?B?UlFmLytZWG9hdlZQS3Y2amFIMncwemptZFNmWkw1N0NJU2pDakhZeUlCRzFs?=
 =?utf-8?B?SW5RWmxSZGhIQzQ5MnNoUUt1OXk3RFZwdlNzVnpZM3JFR3dBRjl5RWlTMFFt?=
 =?utf-8?B?VW4wbWZZV2t6eGhCQVFZRkZIdVRXNWFuMWdZd2hCVTd3aWFndlZBK0IveUs2?=
 =?utf-8?B?c2p5enp6aFcxckhHRDBiQ3M3cFZpQUI5MGRKQnBlZFlaNndHSnpNck5aVmUw?=
 =?utf-8?B?NTBqdzk4dmVkRWk4T3dPVWFCZzNia1pNWE9CRWZGL1Btc0x0Sk1Ea3l2aGxu?=
 =?utf-8?B?NGxKNzlQTXRnMlg4Zlp5eGNXQ0JKVTNtMHlQSC9XRXNuK1puUWg5dElPaFIr?=
 =?utf-8?B?K25mVjAwQnFhNFI5alRxeVNzd1RWZVd4dDNhaUtCaHpFM2tzUlBaT1NUcExO?=
 =?utf-8?B?RTRuOFF6TU4yS2FRRElvditJVmJXRVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR02MB10909.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTA5cm1Sem9Vak9qOW1oY3cxNDNwdUdDNHZOa0o0VFJmNWFkMnpPYWpzMDNB?=
 =?utf-8?B?N0s2YWNJQUp2dGR4dkpQVFA4ZkNDUFE4ZmlmSWdGaDI3bVBJZElYd3lLQTZl?=
 =?utf-8?B?ZUp5c1R6UHBVQ1NuNEI4bVJEK1Rhb0hhaExERUhZdVY5V2FNUGhyMmpneU9S?=
 =?utf-8?B?K0dnbTJnVmMzVjdiai9yb05HdU50MFpySXZmM1U1K2pnL2VNaU5yVWNyQ0pE?=
 =?utf-8?B?U1VRRGdMWUt5eExmSUFWRmRkZy9lNW1YWTg0M2xSS3lsbmp4TDRGY1B5WFJz?=
 =?utf-8?B?blZiMVF2UzMwZFppaVpjdGNjWXFNaFF6VnRlYURSSFh6NWUvLzh1UEkyeFUx?=
 =?utf-8?B?bnFaMFlId3o0dnM3UXBpNTJpYzRhaXhWMmNZNmJaR3cxL1h6UVpqR2dJRkFp?=
 =?utf-8?B?K3RpVEdZQXlYeDQ0RllrL25nbUUvMmYvZHBXZEViN2Qyd1NuaEUvTmZOTFNY?=
 =?utf-8?B?OXdYMVhLc3pCSEVSSG1aVjNCVWpNaHAvampiWlFBUmpPSjlpT2pNTmoyclp0?=
 =?utf-8?B?SXBsejNtem5EbWZGcElOU2VnKzlRRkI4SUM5cXJTQ0diN3FVSEJCamVSZVJX?=
 =?utf-8?B?WlBLcFhsK2kzNDQ5KzZlN1lid05SU0ROeGJGUWppWWV6cVpJcFB2cjVrcVN0?=
 =?utf-8?B?SWFFZUZMZ3A5RXgyWTlJcVpIekl6dHpDRVZKbm5sM3BtVU9KMWVZTEFvNGJv?=
 =?utf-8?B?eTZsWU5NekQ2VEY1Tyt5M3lpbUJrSmhYK1RuTitmTy9KVGhNVGVpQ2p2M0dP?=
 =?utf-8?B?NjF2YTcvSVB0Nzk3Y1d3SlFrZHdGd2JxL2prWWIyWnNIYllJZFJVdjdIK29V?=
 =?utf-8?B?Q1VEYW1jZTYyQnFkaHJzSk1oR2UycmUvRXlCbmNEclM4OEd6UE12bEZ0d2d5?=
 =?utf-8?B?TWRyYVdtcjBZemErY29vS1RaaXFRcE9KQWk2VmhrdzdBSGxyUzNCTmQvWUVm?=
 =?utf-8?B?MEJTSVAxNHlpWS9MYlkrWUdtWjVid3JKZHdLQ09mMTdPSUFJdFJ6UldpalNj?=
 =?utf-8?B?QnFtWkgwQVBMdWtFVURoM1VaYUNXWUZEemY1Nnh5dGJmRXVyL1J4T2x2TFRQ?=
 =?utf-8?B?SUxBZEx6NHVIampEYW52a2puc2VZejFyNFFoam5IVHFtTXFWb240Z2pybUV5?=
 =?utf-8?B?cnNXcFN1czAxK0x6VGlhMEZUZHBVa1NtWDVLbUNsOC8wKzVwOWVlS01VaE9q?=
 =?utf-8?B?NUh2U3c2TDh1WWp1WDk5QXFFaUJ5eWV4OXdhSlF4aHp6NWVFKzY3MTBSalJP?=
 =?utf-8?B?a1FvbkIvY1FxWTFnbXZBRStRakRmU2xLdUV6WFhjNGlFKzZhTGUwUXJTdVZl?=
 =?utf-8?B?V2tPUU1NeCt6NVlXcHQrTzJqemxLMzZWYXpNRXp6aThKZVBkTU9xS1BzckpE?=
 =?utf-8?B?RGdSUXpJb0RkVXYrdDVtZ2RNanZ0SU5WTnl3dk4vbTZnUisvZGNUMTZTOCtr?=
 =?utf-8?B?ZVRaRmhDOUpvamxjVHYzVURkTmM1dHNNcFB5cXNzclJKcFMzcEphMlV6Zm16?=
 =?utf-8?B?RWdkN21idVJPL09abkk0YzA3Y2h2TkVJOUVha1pjbkNHTFR6SEY3NGhMOU5Q?=
 =?utf-8?B?dW9MZ2dYN1F5ZVdpSkYzTUtESWpGRkw5dDRlVHl0QlVoQ29Ib0orNjhIZTM5?=
 =?utf-8?B?Q2FTL2Q0cGpFUDZrQ0lVNGJtSVYwSDJ0UHVIMUxSMVhkNFNIdHUvNjBKaFcr?=
 =?utf-8?B?NklSc2dwVVRmR1h1eEpnNk1iMk1iVFhnbWxSRkJkMmxHMkp2eXlZdUhtb2sv?=
 =?utf-8?B?Z3VuUURMNFFHQkdsQ0gzSUcvTlJaMVJXdThlYUI1K1NsZ2FBZnVuU3A2YXNk?=
 =?utf-8?B?RUhrUHQ5ZGJwd25vblBxVXJMejIxOE1mNU05aTk3MVl0d1N5VmdLVDlFaDBZ?=
 =?utf-8?B?b2pIT1pQS2JSSWcxcnprZkZZNm1kY0JlckNVUWRlUkJyV2U4YWRRUlo0Y2xp?=
 =?utf-8?B?bkw5WE50QXlGL1NBMHhzVk84dzFzWjZiWTdOVjBOMXRxcVlFT0RrTHE5MjlF?=
 =?utf-8?B?Z2FIa2lhQmljLzF1QWNBQnZIWWxqc01uWWMvNEVsVHJvNTVZMDdpSEhhQ2hG?=
 =?utf-8?B?bFBXQ2lFcnk3NHZTdy83aXEwT1lUVjB1Q293c1hIa25YVXhyWnhGTGgvL0J2?=
 =?utf-8?Q?S1xI=3D?=
X-OriginatorOrg: axis.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf3562c-cf91-46df-fa33-08dc7648097e
X-MS-Exchange-CrossTenant-AuthSource: GV1PR02MB10909.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 08:04:55.0262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrtQQiK5uOsGrdCrWQiwHjnsUhSPh76+QV47FVoPK9EohfadWz6/lkvNj1zbuvHy+POJK4fdlauRcYRUwyX/xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR02MB6950

On 5/16/24 13:20, Yu Kuai wrote:
> Hi,
> 
> 在 2024/05/16 17:36, Gustav Ekelund 写道:
>> On 5/16/24 03:10, Yu Kuai wrote:
>>> Hi,
>>>
>>> 在 2024/05/15 19:57, Gustav Ekelund 写道:
>>>> Hi,
>>>>
>>>> With raid5 syncing and ext4lazyinit running in parallel, I have a high
>>>> probability of hanging on the 6.1.55 kernel (Log from blocked tasks
>>>> below). I do not see this problem on the 5.10 kernel.
>>>>
>>>> In thread [4] patch [2] is described an regression going from 6.7 to
>>>> 6.7.1, so it is unclear to me if this is the same issue. Let me know if
>>>> I should reply on [4] if you think this could be the same issue.
>>>>
>>>> Cherry-picking [2] into 6.1 seems to resolve the hang, but following
>>>> your discussion in [4] you later revert this patch in [3]. I tried to
>>>> follow the thread, but I cannot figure out which patch is suggested to
>>>> be used instead of [2].
>>>>
>>>> Would you advice against running with [2] on v6.1? Should it be used in
>>>> combination with [1] in that case?
>>>
>>> No, you should try this patch:
>>>
>>> https://lore.kernel.org/all/20240322081005.1112401-1-yukuai1@huaweicloud.com/
>>>
>>> Thanks,
>>> Kuai
>>>
>>>>
>>>> Best regards
>>>> Gustav
>>>>
>>>> [1] commit d6e035aad6c0 ("md: bypass block throttle for superblock
>>>> update")
>>>> [2] commit bed9e27baf52 ("Revert "md/raid5: Wait for
>>>> MD_SB_CHANGE_PENDING in raid5d"")
>>>> [3] commit 3445139e3a59 ("Revert "Revert "md/raid5: Wait for
>>>> MD_SB_CHANGE_PENDING in raid5d""")
>>>> [4]
>>>> https://lore.kernel.org/linux-raid/20240123005700.9302-1-dan@danm.net/
>>>>
>>>> <6>[ 5487.973655][ T9272] sysrq: Show Blocked State
>>>> <6>[ 5487.974388][ T9272] task:md127_raid5     state:D stack:0
>>>> pid:2619  ppid:2      flags:0x00000008
>>>> <6>[ 5487.983896][ T9272] Call trace:
>>>> <6>[ 5487.987135][ T9272]  __switch_to+0xc0/0x100
>>>> <6>[ 5487.991406][ T9272]  __schedule+0x2a0/0x6b0
>>>> <6>[ 5487.995742][ T9272]  schedule+0x54/0xb4
>>>> <6>[ 5487.999658][ T9272]  raid5d+0x358/0x56c
>>>> <6>[ 5488.003576][ T9272]  md_thread+0xa8/0x15c
>>>> <6>[ 5488.007723][ T9272]  kthread+0x104/0x110
>>>> <6>[ 5488.011725][ T9272]  ret_from_fork+0x10/0x20
>>>> <6>[ 5488.016080][ T9272] task:md127_resync    state:D stack:0
>>>> pid:2620  ppid:2      flags:0x00000008
>>>> <6>[ 5488.025278][ T9272] Call trace:
>>>> <6>[ 5488.028491][ T9272]  __switch_to+0xc0/0x100
>>>> <6>[ 5488.032813][ T9272]  __schedule+0x2a0/0x6b0
>>>> <6>[ 5488.037075][ T9272]  schedule+0x54/0xb4
>>>> <6>[ 5488.041047][ T9272]  raid5_get_active_stripe+0x1f4/0x454
>>>> <6>[ 5488.046441][ T9272]  raid5_sync_request+0x350/0x390
>>>> <6>[ 5488.051401][ T9272]  md_do_sync+0x8ac/0xcc4
>>>> <6>[ 5488.055722][ T9272]  md_thread+0xa8/0x15c
>>>> <6>[ 5488.059812][ T9272]  kthread+0x104/0x110
>>>> <6>[ 5488.063814][ T9272]  ret_from_fork+0x10/0x20
>>>> <6>[ 5488.068225][ T9272] task:jbd2/md127-8    state:D stack:0
>>>> pid:2675  ppid:2      flags:0x00000008
>>>> <6>[ 5488.077425][ T9272] Call trace:
>>>> <6>[ 5488.080641][ T9272]  __switch_to+0xc0/0x100
>>>> <6>[ 5488.084906][ T9272]  __schedule+0x2a0/0x6b0
>>>> <6>[ 5488.089221][ T9272]  schedule+0x54/0xb4
>>>> <6>[ 5488.093135][ T9272]  md_write_start+0xfc/0x360
>>>> <6>[ 5488.097676][ T9272]  raid5_make_request+0x68/0x117c
>>>> <6>[ 5488.102695][ T9272]  md_handle_request+0x21c/0x354
>>>> <6>[ 5488.107565][ T9272]  md_submit_bio+0x74/0xb0
>>>> <6>[ 5488.111987][ T9272]  __submit_bio+0x100/0x27c
>>>> <6>[ 5488.116432][ T9272]  submit_bio_noacct_nocheck+0xdc/0x260
>>>> <6>[ 5488.121910][ T9272]  submit_bio_noacct+0x128/0x2e4
>>>> <6>[ 5488.126840][ T9272]  submit_bio+0x34/0xdc
>>>> <6>[ 5488.130935][ T9272]  submit_bh_wbc+0x120/0x170
>>>> <6>[ 5488.135521][ T9272]  submit_bh+0x14/0x20
>>>> <6>[ 5488.139527][ T9272]  jbd2_journal_commit_transaction+0xccc/0x1520
>>>> [jbd2]
>>>> <6>[ 5488.146400][ T9272]  kjournald2+0xb0/0x250 [jbd2]
>>>> <6>[ 5488.151194][ T9272]  kthread+0x104/0x110
>>>> <6>[ 5488.155198][ T9272]  ret_from_fork+0x10/0x20
>>>> <6>[ 5488.159608][ T9272] task:ext4lazyinit    state:D stack:0
>>>> pid:2677  ppid:2      flags:0x00000008
>>>> <6>[ 5488.168811][ T9272] Call trace:
>>>> <6>[ 5488.172026][ T9272]  __switch_to+0xc0/0x100
>>>> <6>[ 5488.176291][ T9272]  __schedule+0x2a0/0x6b0
>>>> <6>[ 5488.180618][ T9272]  schedule+0x54/0xb4
>>>> <6>[ 5488.184538][ T9272]  io_schedule+0x3c/0x60
>>>> <6>[ 5488.188714][ T9272]  bit_wait_io+0x18/0x70
>>>> <6>[ 5488.192947][ T9272]  __wait_on_bit+0x50/0x170
>>>> <6>[ 5488.197384][ T9272]  out_of_line_wait_on_bit+0x74/0x80
>>>> <6>[ 5488.202604][ T9272]  do_get_write_access+0x1e4/0x3c0 [jbd2]
>>>> <6>[ 5488.208326][ T9272]  jbd2_journal_get_write_access+0x80/0xc0
>>>> [jbd2]
>>>> <6>[ 5488.214683][ T9272]  __ext4_journal_get_write_access+0x80/0x1a4
>>>> [ext4]
>>>> <6>[ 5488.221392][ T9272]  ext4_init_inode_table+0x228/0x3d0 [ext4]
>>>> <6>[ 5488.227298][ T9272]  ext4_lazyinit_thread+0x410/0x5f4 [ext4]
>>>> <6>[ 5488.233066][ T9272]  kthread+0x104/0x110
>>>> <6>[ 5488.237069][ T9272]  ret_from_fork+0x10/0x20
>>>>
>>>> .
>>>>
>>>
>> Thanks for the patch Kuai,
>>
>> I ramped up the testing on multiple machines, and it seems I can still
>> hang with the patch, so this could be another problem. As mentioned
>> before I run on the 6.1.55 kernel, and never saw this on 5.10.72.
>>
>> The blocked state is similar each time, with these same four tasks
>> hanging in the same place each time. Do you recognize this hang?
> 
> Okay, can you first clarify if it's still true that you said "Cherry-
> picking [2] into 6.1 seems to resolve the hang".
> 
> There was another problem match the hang tasks, however, both 5.10 and
> 6.1 have this problem:
> 
> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#m62766c7d341eca35d6dcd446b6c289305b4f122e
> 
> BTW, using attr2line tool to change the offset from stack into code line
> will be much better to locate the problem. And can you check if mainline
> kernel still have this problem.
> 
> Thanks,
> Kuai
>>
>> Best regards
>> Gustav
>> .
>>
> 
Hi Kuai,

The patch you sent me the first time works.

I am embarrassed to admit that when I ramped up the testing the units
accidentally got the wrong kernel (without the patch). Sorry for wasting
your time like this.

So to clarify "Cherry-picking [2] into 6.1 seems to resolve the hang"
still stands true, and the patch you sent me which looks similar to [2]
also works, I get no hung_tasks any more. So I encourage to backport it
into the 6.1 longterm.

Noted attr2line tool for next time.
Again, thank you for helping me with this.

Best regards
Gustav

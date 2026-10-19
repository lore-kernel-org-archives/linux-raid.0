Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792443493;
	b=qZ6shI3uSgHy+5iT571FrpCFF0iDUYryrdUg6IAAITKZzk48PZF9CIOAynQOKoWcv+ot
	 I7oxP2mqCknOmrUsmBwtTF3KLzvFA2NHl6BCkYS9OzI4fGyovhqiIB+U4f8hdvph2OTIA
	 aR/bmib0DqgcP8acb4dbp3jq1f0DOggT4zxdTtoOlMJcuY3JUgbgh9T2MY622hksaoZWn
	 fuiyUJ4/gox0YiZatGo3OFi/Rgl+yKEzux3T3B6nleDI+XreuD27+q7fmvvNy2Xwl97UT
	 vhgC1an00plivyyEA1uFKxt4qgEv8Eu/R2605O7e+oWtZXK5pQMjyA/iA8UUGuZe4GQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443493;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=k2R+Je0C36oBOsBfU18LA+tQ8KzwFdRaccPAtISp5to=;
	b=duWGlT0BAYPZMuEd2LqSrz3c42ETZb7ZICxOpXmFIzMVjRG7LlfKXCEUsJNmbZoHwf3S
	 TTY2LTMRVzbHAXbqrh15kvlSMOFjwVjowshy8yxReTxyLjzPLQ8bUDOEy8f8JMwaOh6ti
	 4ZywwfmntAaR67jJO2k+tjOrD92GuTKW3W92tGH3BPkFytH/baPzM8yeIbL95BM1BZA84
	 MG+QarizuXDZcG5na+cXE+cVZirIr9M47rnPFahiOFdtuBNKdBXpt3EnmBA4Tk1IpJxBT
	 rURaakz7wF2mQ0UBcz4v4+7CywMfSEMpQKIO2VL+kZFv32dzF91/3TRnjzt3QWt5bCA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=CUD5J2Oa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.55
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010055.outbound.protection.outlook.com [52.101.84.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A66606A319
	for <linux-raid@vger.kernel.org>; Mon, 19 Oct 2026 20:58:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35A66606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=CUD5J2Oa
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F8YT4I/j5R+2yj22pP4vSH/NhazNlxg9YowZ4DcGDHsTqdE3wKotoO9aAbbK8fVXL2T+v4HHShweuwT6+cmI9YnJPjJwSPJgLf5qJfkFyhYqXcWBLl1DXE6YhbCFCj4liSzi6QiH8ZTE/rN4sKtL3ljh327HYmUv9CcYou+m0ksIz9J7JgTmxBrgUT0wwHhXQo//AfhavVBS7hj9tPS/K36qTVGLGwZygqmpkJS+8SNqaO/HgjShg6HKHi+b6JE6M09lHfVBmydTmhMAihjckQ13UBolynHQI5lqlRYTe12+DuGyHWgX++wT0974F9PMbU39xBe5L6Bsj7hk9Dudyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2R+Je0C36oBOsBfU18LA+tQ8KzwFdRaccPAtISp5to=;
 b=swq/P2mWd9RhQuVTVD2RYz529fd5jp3UsaC+5/1O/jw0e/9WrdgtRNscCD1Z2qqPZqmRjwrw7VyN9FDGcOoeikRHOp+TQyDYZ9C0vH12WsMCFkTdY15Di0PXZ2hkxdAopGpZJDQpbAG+bMYQewotPJ6otdc2WLUlyKrmemvAWegADVBoHKYNb1Osn0afMTiMiY3CIvj0+O8O6x63Njn5eAPrLpM7xOFRfldfdAH2qWMrFdFpS4JZD4VrQh5OP0DOaUPyzMv7IWTWW+2bTiN9e4q4B66+PJX5VrHkpZBfmrstgpMVNOaeunQK6EQbem7Q7MGh8GjdrI9jRyaye6Xj5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2R+Je0C36oBOsBfU18LA+tQ8KzwFdRaccPAtISp5to=;
 b=CUD5J2Oav7NLMosEoOyPAQjp3b2raP/OnANkbc/6/bmIrhexE5hg8sHpz/bC1r48EfIZLiOfJxiq6jM7DlPNIKt24wrxRwUp30ZBIVSgmf3VD7pqFZuuKrtx5h18AHrj4gFcjlmqzjcfD1wtDqT2VpNbYktYLPxdtCs9RF+4Ez9tTZZadnjMxstQ4S13yXDJPPacnLkj+EDKxkeLgL0nkv1xgUOzMfE04Py1f4iGfPFs9QsILY5mbzq7RDZuI5+ohdmBe9i11P6+pHG6MBPVEaSsH8SzW93HNHw2h4roJJJY9rZ7gAWjvAPJ8Mp5hUQFs/5DMOtSA1xhX09kzYNZXA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by DBAPR04MB7302.eurprd04.prod.outlook.com (2603:10a6:10:1a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Mon, 19 Oct
 2026 20:58:08 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 20:58:07 +0000
Date: Mon, 19 Oct 2026 15:58:00 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Alex Naylor <alex.r.naylor@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Dan Williams <djbw@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH RFC 2/4] md/raid5-ppl: replace async_tx with synchronous
 xor
Message-ID: <ataEWMqQ0xpa2RFi@SMW015318>
References: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>
 <20261015-asycn_tx_remove-v1-2-056a7085e0a1@nxp.com>
 <ab359253-846e-4a8b-944e-06718b17a315@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab359253-846e-4a8b-944e-06718b17a315@gmail.com>
X-ClientProxiedBy: PH8PR02CA0048.namprd02.prod.outlook.com
 (2603:10b6:510:2da::16) To MI3PR04MB12438.eurprd04.prod.outlook.com
 (2603:10a6:290:76::14)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|DBAPR04MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 4169c315-16b6-42d6-7273-08df2e23ad3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|19092799006|366016|23010399003|11063799006|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/Cz/+lGSGP8Xx/fx+g0WCNOcJEzSK+7dInwG7ZVSuTowQg8+PGD1DZv/tVab1yUMzp4inB9SsP4675IsaNjm+RsVBP/Y8DouWa9nfImj5hnl7uknZ5A6qcEjhtqYKk2Z8Eijko4DoDxmxrdLtZJvvqZAYU2tVrtISPv90jjQ2Gsy5fyNmoT9QdI3WN4g4Up+HIrGNMUS4PTejXBW++5RrWCHptlDC78oK7pXahK0kbgU8ij2PlYaHINfF56n1vV7DNnPHwPambcRGa9JYlN+Tx6oQDOP3qGf4wHnfuX72AYlp0RgM/B7KmyP7I/oRHtqSp/BTxgTh0UWxN7lUmmQ1SF2tuzMdF2WSs5w18nzrRW/H5j8vD/it36Ldcibf49H52kuk1pJIn0edPQAmhGSMY6/4FTkRPa8r4uxT16o41pwSgQM1+Opyd6kvlRHTRmuRUlxongN93GA9n8d/4Ly4l0DIdZMTiefgWmTyIl6srIIZmVDENxJuuS21OMFbgJ9d0iac+wcZXTCYM6s10Ckw3IgjT4YNjZxBojWo8ykUTPl94dLV2agA3oCOU1elme1PO9OMDe8hsANV7k2+mgPTzqW9xle9x7Ste2CKTRBpOx+FLygDQYomxm2qH7PCaehOle0O6ffVgqn5kBR8RsLl2rLv/WlwD8Lsxqe+V3neNg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(19092799006)(366016)(23010399003)(11063799006)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZRL3YhgZaDVzI1wbEXSjPWDSFyXh73EiEr+COKjpzk1m2mS4sZPjeKOZKZM/?=
 =?us-ascii?Q?ewhdtrl+TjxqhWBgtJC/zE7ovu8t+ft0+iIjvWK6Tdboe2QjefhsoOqPaC1/?=
 =?us-ascii?Q?c04tg8R59zByD9wEMsDQtLQbzodY8938GJ+sTyQJTCJqReYOlXWL0uYom5Eb?=
 =?us-ascii?Q?KYlhI0I1gcCvGhOEZNeIZtpcZSm+Nho7tBViIgifmlJrpc5zAlORInoQMpKX?=
 =?us-ascii?Q?9BS9xkCTmTR0o3d4r44TshTkmiJqrZoOw9nL4ljf7DtzDBHZE96SB/ZT6Q1v?=
 =?us-ascii?Q?Pt2PkNXXmgXzpL54qy6ZNFUBuxCJKVt3Lqu10GY8YuB4x/r8uQHnwkf2yA19?=
 =?us-ascii?Q?4NOV4ZV65UGCcsskExKS9NAhBSqofmfaYLRNubDrZ7V4ymrsg5szmD16lYJU?=
 =?us-ascii?Q?uDKEXSh7yvSHaO9+jQP7r9j15Y6EyDLOqvuQfK/tAzN3GCsoMVjsw+CrvRuv?=
 =?us-ascii?Q?E/0Maz2amle5FVgicC3Hu+EqAFQ9bS6QrEyIfNSJbPNxw/eMlrLWHsNhAvgD?=
 =?us-ascii?Q?tJjJ1kCIbYMba5hzQFZ5UkzaB/1xrRWOqm30q2VDtM2rvqrC/Sl+PXekvjhp?=
 =?us-ascii?Q?21JAOw7YBjCmZkdee8ddiEh0EloD+von2212pGvD78fHbKUs1Y3DlqxnAHVU?=
 =?us-ascii?Q?CMn/SHUc4R+AGmhXJw1zydjZACxZ2DNqYT1bli4U8ooGiOFQQCGv55MJnSRM?=
 =?us-ascii?Q?iG8Lz8W19nttzVhvDJXCFoxrxfh2NLbY6dzZkFI197V8m4GEEUGDIfjJLpOe?=
 =?us-ascii?Q?fKCI3HY/PRNfMGyKjDMdSQlM/SOwCAmIkbG5L42cU/oqxJsK7BIF7Rv4eKe+?=
 =?us-ascii?Q?pphqcUqvdUF+Jj3J+TZYiifWZL0GzrJOJGRwHONbqu/ko32p1ZpQ0AukpQc9?=
 =?us-ascii?Q?5kFsh9ChCJwlxyUyT5kXDDBejOZR3pqGVcCKr67CKxYzwXzmn8ARxEELeh/e?=
 =?us-ascii?Q?VkDsuA5f/9WKoIltsKQTZ9lbV//3N4qpF+VpZtf/W4EUNVlBSwBxQqpHJcuE?=
 =?us-ascii?Q?lw/1IiKuCcR34IcQOBqr0PYLAfmZcgUzyRu7g5O9nXO6ATE1kdGGACrDfHQ0?=
 =?us-ascii?Q?3OrFlkLNp+hbP9iIYFShgtNKaJ5qBpJq8mDINqgKECdHrb0YFNRdaeJ2hlav?=
 =?us-ascii?Q?7mywV9YoIBKZliYOkwos+DVb0GB3U22v78b7duCaWAxvPTho6yOFwKn5X656?=
 =?us-ascii?Q?ZCYswL/B1FbTcSkjLrr7UXdaPpZcchqyHFahxGMXNpOPaE0xFBTgpEibFkVj?=
 =?us-ascii?Q?LMTvb+Y2atSQSlZxGMF/ck7SlOtPsliFlIHVRD0N+vHkXULfqeOjRkFuH/Nn?=
 =?us-ascii?Q?AKBQJ1iEyG5f+49p27SyG+BSj3Edrshev36UPRdIC1p/HZvPOopTQJIIVoYO?=
 =?us-ascii?Q?+GFt3CSc0vqFHldJwRmxMt55UVdHjKd67k08uLFLclAnE3DZByR6jzaBBlEX?=
 =?us-ascii?Q?MfLcuCa8h9EK2x17TL1aHK3VX4yvGWpipY7+o7+pzfOxTfZqFZKrHRVExXsg?=
 =?us-ascii?Q?9BCU6U0LcY1z7LlCP5Nm8xchrwzHUVzdtZTBj0nakEB7n5uIjSC6iLLxgQnA?=
 =?us-ascii?Q?6orMfHwM51ygEyOy4oFbLBosdzxpuBeSGrfSr4S48yiE1oh3TNBa2Gyz8wna?=
 =?us-ascii?Q?36QQxNRxFizPa5ZhnwXvfXVsyo/ZM16RmRDdreuvxG1oymhaZmaKHDxQWVis?=
 =?us-ascii?Q?w/h7xOpSIFzwyayOKNzwXFlkev9SpiSrm4AhzbEdqhDHk7oEdSW93tZ5g+Lk?=
 =?us-ascii?Q?HY2KeJ2mGH8GqaYsyCh4pOU+Pz/P71+WZlMYu/6IDLli7truuONX?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4169c315-16b6-42d6-7273-08df2e23ad3a
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 20:58:07.6982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NcoNM1+fjtaExMhHnG2S/bJ/+v38XF2ku9VLaLmpEK+zGZb2tgp2imL8UDGUHgDbjzcp3hdpB6z/41RDUnek5Mbtw5v3+OWrXO694LSEFIsEiI2BnGmEr4SBi1ogaSkt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7302

On Sun, Oct 18, 2026 at 05:27:31PM -0700, Alex Naylor wrote:
> [You don't often get email from alex.r.naylor@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> Hi Frank,
>
> I encountered a PPL recovery failure that appears relevant to this
> proposal, on a QNAP TS-410 (Marvell Kirkwood, ARMv5).
>
> The system runs a custom Linux 6.1-based kernel with CONFIG_MV_XOR=y and
> CONFIG_ASYNC_TX_DMA=y, plus a local PCIe startup-reset patch. Storage is
> a four-member RAID5 with metadata 1.2, 512 KiB chunks and PPL enabled.
>
> After a power outage, array startup hit:
>
> kernel BUG at crypto/async_tx/async_tx.c:269!
> PC: async_tx_quiesce
> LR: ppl_xor [raid456]
>
> The call trace included:
>
> async_tx_quiesce
> ppl_xor
> ppl_recover_entry
> ppl_init_log
> raid5_run
> md_run
> do_md_run
>
> All four members had matching event counts and valid superblock
> checksums, with no members marked failed.
>
> The apparent issue is that ppl_xor() submits with ASYNC_TX_ACK, then
> passes the returned descriptor to async_tx_quiesce(), which asserts that
> it is not already acknowledged.
>
> Disabling both Marvell XOR engines through their device-tree status
> properties, while retaining the same kernel binary and modules, allowed
> the existing array to assemble and the filesystem to recover. No forced
> assembly, array recreation or PPL-policy change was used. File transfers
> are working again.

Do you means mv_xor actually broken at kernel 6.1?

Frank

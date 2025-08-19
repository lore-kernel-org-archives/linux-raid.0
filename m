Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023132.outbound.protection.outlook.com [52.101.72.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC21281366
	for <linux-raid@vger.kernel.org>; Tue, 19 Aug 2025 07:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755589128; cv=fail; b=mZahZdEzZVDzU8V0O57vWsnX89Fy0Qogq4PHllcWIOd/3Muh9MfJLNUXzri8fVDMTasDhY3PkzONj3yMLBTxDr8AyVVrCUx/OGJ2v3l6QSKcp1jS1PbYyNrW8f9GvjoI4ISBC7PZnheaJsGA0hT4lxzW4BN7yILQ67hZE0Q4kSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755589128; c=relaxed/simple;
	bh=OtDTOC2zNRmL2Zl+AlxxCS6U9FoZQgaTuSSzFcUD4dw=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=cIJeXB0WxTqQ7/T1NqHaHNQ/jdNxWagxqgYLZFt67S2HaHyRKd8VNgodZr5TfxYGSFfDGfWLLHjwfE/x1/0RzshqV4DvUxADij3y5Mz66bchdPUH6Vxh9Tbx9iozQJUzK5Npojry5pNpF7ZNYbvAdp0czv4BsH3LWSXt2H/ypRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=SidtNCUC; arc=fail smtp.client-ip=52.101.72.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="SidtNCUC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PQ9qnG/KS/YSMRzRgLZ0oPoS1OHkJUNN9fWQziOZ0bg3E8wQainLhd8eLqb66ztBheu9Uzec4GqGUUF4ylhw2wgomU+6HrvpPC2ynrFpK/cMnau7b6AB+UOvLrnGAJy4SgNeQtDsQpsIcbGPtOv3Z98RpsfeL7073yefNcAD2jRBr1L6cbKWlKw4iZ5ssgZx7Vqgq7rWzl4b1yq7K6QUvTd5vRskpUHTmra9uZAlne36UtNrg9/2Nurswid6YX0MmoVV/9rzSNnxBBNOuT9jSBUyT5U7BibsoEmHn4L8VNK45qyuA5EDU4oaguWoq+SeZqaFc0BR1NJ1uEw4IgCuzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ficSDCkORMpSmx830bvR1Wu0BneKC+PYhDgB+7EZijg=;
 b=vTpZFYPaV/9FV8LBbazKRBqYRwstjNgJzH64OSUGQHi5+irV0kruf3MrDJZXyBvH5/XKquzomqjQrKSUUh7BOh58ep57LlYCd22XDNP12nYIh2tK5/i2iclIUTnO18V/FgN+S9Z2p3Gts25qukKyPeVvhmXo79urotlTCOk4doseOnPXf8k61HbrL9hzNoSDzNGJpzy5v6n6gnCinYUhvBWegb/HxX0RFj+XELdafP62dN4rqpNA+nO5YrfkTH647G+NSpZZizGR4Huux5ReLYtId/emD5ZtKKYQ/tK9LJntjJa2d+RssvXyj9yNJ3REFySoN0kyImWZoqGRso8Qmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ficSDCkORMpSmx830bvR1Wu0BneKC+PYhDgB+7EZijg=;
 b=SidtNCUCh/z2irOPbKEVk6rTxagkRjpZ5JpRkwYrAOLDvrH9Mjt5RvX+ApXGWR0miTAtKpCNIiH/ThAyAN8UtY3ZNOngwerP70X5P82whWvMiRxhnk43PFfy0HkHAme3ckMr0aSbD8DKPLT+nJpq+d/WFhqJML3z5CTjSvpr1WzlvgXIaVankuEPsNBBrFiquD5BnQV/ud7ru8gXyQlDeivKADT948lK+j0uvBi7sS9PbsefwAv93ecv1aE5tPQpEuqBYS8l+71JmJwx601dcke+MRVdcFppxffLIAxqGO7L02UzBNIizEJ+IcahdgNVtoED1LL/bcuciWaKwgMijg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
 by PAXPR04MB8576.eurprd04.prod.outlook.com (2603:10a6:102:217::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.12; Tue, 19 Aug
 2025 07:38:14 +0000
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8]) by GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8%5]) with mapi id 15.20.9052.011; Tue, 19 Aug 2025
 07:38:14 +0000
From: Meir Elisha <meir.elisha@volumez.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	Meir Elisha <meir.elisha@volumez.com>
Subject: [PATCH v3] md/raid5: fix parity corruption on journal failure
Date: Tue, 19 Aug 2025 10:38:06 +0300
Message-Id: <20250819073806.1501782-1-meir.elisha@volumez.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TLZP290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::17) To GVXPR04MB9927.eurprd04.prod.outlook.com
 (2603:10a6:150:118::22)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR04MB9927:EE_|PAXPR04MB8576:EE_
X-MS-Office365-Filtering-Correlation-Id: 418c9bed-72e4-48bf-bfdc-08dddef35ae6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3ZPNDNkejYzOCs5emN6eDhsUWVrRGo1emhISXRCRm1mV0p4aWFUaW5Xa2ph?=
 =?utf-8?B?WUlPNThlbEdJWHFOT3FqZWs1YUdBZ2FoWm9nQ0sxbUpEdE41SWFPQllGM0JZ?=
 =?utf-8?B?djZNTDRRQ3NxSm9kc0hVMm9KdzlNVUVMczJaN3MraEtMd0tYa1k4K3psb3BH?=
 =?utf-8?B?V2FKWkNUd2xJN3Yyb1gyV290eG03WG9TVWRDZitjL3NjNklIN01acDdzNzZC?=
 =?utf-8?B?Wko2dzIwZnNTaU11Q3Y4VmJsbEZITFYzOGJCNXRlREJ3bWtDTVVlZ0FWU0Fu?=
 =?utf-8?B?NHh3Snd5R0xvL1pxcHljb0t1cWQySWJTdDBUNllrYkxtWGJkOW82bUtVRitN?=
 =?utf-8?B?cTZWOERxM2hwQnBWaklSbDVDK0xUWnRBRklua1lpWE9jUjVNV0xheXZTa1p2?=
 =?utf-8?B?SVk3STF5ZDFVdzdleWRocmtoMHR3d1FTVjVOQlltWXlEODBLVHJxQU1LV2FX?=
 =?utf-8?B?VmIvNm05S1hsNnRlZzVPcW9TT0dIZFZ1M3hId0Q1dXpoME5zOElQU3RJZVow?=
 =?utf-8?B?MVVlRWZqZXREQldZMFRxdDZxZlpOaUtFNFlBZVJzK0o0eUdOeVVrdWs0WXpj?=
 =?utf-8?B?OFZwVXQra1M2TlFDNk5EaW9pMkNLSXdvc3N6aEdpaTFuYTBHRnJqSmtNdmRK?=
 =?utf-8?B?SFpsQ3FSSlZRZmVjbzBWRkZmaXZtd2tDSUlIbHB1TWhiazJvWjJTM1YyVlkz?=
 =?utf-8?B?V0I1QkFpWEFqcFErQnRXcXFoTGNSa1BnUGxmcEVXYlFHekR0TmtJVURwVUNr?=
 =?utf-8?B?Wm9FLzBoQ29JV0VyNHhwRU5FcjNEM2xDR3h6UENtYlFvamFXMUJpOFpWYkdB?=
 =?utf-8?B?NFltZnBwVDZrN0w4RGErY1RKZnRZd3djenlGa0ZJenRsaDNTR1VwaENleStG?=
 =?utf-8?B?Wnl0UU1qY0EwbFg2alozcUdPN3l0U1V3Q0xCeU44aC85NGpmMXZuV1pMYXJw?=
 =?utf-8?B?N25ZSlFqay8wVFBkQUd1UVJEVUFsM1FidDNDeE1DdVNqVWdPRGRCSXUxZ3hW?=
 =?utf-8?B?cHpxN0RPTm1GMXlNVnJWWkNwVUFlU3hGSXJqVlNoVytKejBjTjd3M1BHL3hR?=
 =?utf-8?B?RlpleHBxTnF3VTk2OUpySWpYNG56MndkeXMrZXpIOXZ6ZnR0Y05IR2VUUFZx?=
 =?utf-8?B?NUF3aTRudWtncjFaYXRRZUcyV1ZJMWlRRFdqNlJaR3RGY210YU5zT012VkFC?=
 =?utf-8?B?RngwbTdObE1GMnpMNFdiaS9WUGI3RnFmUXB4NWp1VDhoQ3EwNGpDbTh2L2hB?=
 =?utf-8?B?dVlCNkpWTVk4NkhpZG9LNmVsNW9HbWdRbGhvak4yM0hQQytPVElGY2doMFpF?=
 =?utf-8?B?aDRoVDhOK0xRbmZVLzcyZHQ1d2xqS21NL2h4czYxMDQzODZPazdsUWJVRkR5?=
 =?utf-8?B?N1NQamRwUDNxV1hJTlFHUmNrendldGdxd3gyUDRKZDZvUUVwVmMyUHdMYlZK?=
 =?utf-8?B?VTNPNnB5VzNqVTFnME42TWhkenp2VWxXdFhNdGJkSklEOFdHTWl4QmtZNjZj?=
 =?utf-8?B?cDJjRjJFTEhHa2JEUzA0dXhZS3FnTkhNRkpFcm83eGs3eEtOY1NnSEhvQVhU?=
 =?utf-8?B?V2dLdmliOVM5RHhpY3QzUjlRalFGUXhMR1dNYTRlRFpJbHBiNU8vdmZhTWh2?=
 =?utf-8?B?WjBTa1B2VUNQbXFkMnpJS2VheEg1aHRJZkVsZmZtWTZmZ29NY29DRmY4N2Jn?=
 =?utf-8?B?c3VOTWdmQit5L3ZMU2kwYU5IclFSUVdqTkhoYTM5bWhab3V4WG0rR3dvdVlx?=
 =?utf-8?B?ZVhYbWNXelFCczNGaHRqdG9rZzRhcU5kY28rNzlBU3V1U3grUkhlNzc1SnlF?=
 =?utf-8?B?TzQxNDkvYVRGb0JSQnVhNE5iYU9EdnROQXVDb2tjM2FCUHFXTnFxRkZ4WmFx?=
 =?utf-8?B?ZlpBUzRLR2Rnanp1d1dKbmhoRDNVM3FJS2hrZUY3d0sxUTZjMStmRjNva0Yv?=
 =?utf-8?B?SHJYaDNDemRPcDhUOGxuVjhyTnJMUkZxSmR0Si9uWVJkWDFRK2JmOTRyamNv?=
 =?utf-8?B?UFVQUWtIbGp3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB9927.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVk5endJQmdZQ3V3bFVBSFR2eENUS1VKRjJMVCtzL3FPczFOaXRURGViZHhu?=
 =?utf-8?B?d2wxSFFUNE9uN0JwRTRJWVFZZUZqbVVzcGFUS3MwL1dPc3FjQ3JCci9OeGZh?=
 =?utf-8?B?eTc2dVNoTEpzRjBBTnEzNVlWZ0dsbCtURjBhTDNiMjN6T3MvUHpwOWZRRFNX?=
 =?utf-8?B?Skp0M3Q0NFZVZmg4U2FlcVZHQVpqeUpLaXc4ZjBDYzRGQk1ObkVEdnlCQ0VM?=
 =?utf-8?B?Wi8yYUxsc1pEMmlIWkJPZkNlRW5nZkF1RE5aZjRwUkZZVE55TlZyMFRNUWli?=
 =?utf-8?B?amcxYnFjUjFWT2Z1SFdQOHVrcVhreTMyTXNta3Y2WVBrSldTYzZoeFFOV1Fx?=
 =?utf-8?B?NjZ5ekFaQWF6T0FyQXJQbDlFRU0xcjlvR0Y2dTRHcUxCakVKSjdkSFAvTW1n?=
 =?utf-8?B?bzdLVmp2ZTNDTVo3SnpZRlhoYjVmNGQzMjQxa3k1WnFBYXdBV1piTENQNE42?=
 =?utf-8?B?WnorODRKYjdWSytveDd5MHpIV1oxV1hMY0Vxek9mY2hRYmVoTWd0SXh4Sitt?=
 =?utf-8?B?T1RhaVQ2YmJ2Y3VFUlBRVi90U0ZQTVhxUmtSOHRUcm5Ia0QyQlRId2c4b0Rn?=
 =?utf-8?B?QkUxdVVtRE1Xd0NrMDVucmZmMkMwL1h5azFJMjVSRzAxMlNyRlNHUzhjNG9a?=
 =?utf-8?B?WExEeU9hRnNOSmIwakxhVVNZUzFIeHM5OEQ5TWVsNUpwOGw0OU5wYy8yRkdW?=
 =?utf-8?B?RVQxOW94elBMQXpoSUw4a09YbVNJaGN6dTd2cUU5RTV5WjZTMjIvcHk0SW52?=
 =?utf-8?B?aVBxdXRIbGRRc0g3RmQ2ZFFUR09XTVFpMENDcWhoaEFFZUxGOEVIWWFWaUNM?=
 =?utf-8?B?aUNqaHJOMjZvSG40aVNTdGdMSjg3Rm5XK3N5M0dGY2VSSXlIY0FwSkdqQ0Nk?=
 =?utf-8?B?a2NkbnNXSzlHK3ZBcjZiakh3R2t3ZnpQalk2R0VmSXdXd0RkeU5BTnpzRVho?=
 =?utf-8?B?S09YN2lKK0lZelFKVVQ0YlY1dGpaTE9IcW43MG5PWlRwTGNUWExFdzNEdEtG?=
 =?utf-8?B?R2M2TGVMQzZVMmtOdTVreW8rWFZVMUUxWWE1S0FLOFZkYlhqWHJET0dwWEU5?=
 =?utf-8?B?UnMvZFE1cEtSMitxOVF6T2V6MjVBSFFpdTNRQ0M0WWdNb1JRNWhadkZxMGhq?=
 =?utf-8?B?b1RrdGVMOWxlOHlIOGFlQkpYM2hqTlhiblJIZWp2YzVINWlQQnpCNWNKeGlx?=
 =?utf-8?B?ck5YOXMyOW9HR0RHdVBZSFFCMnFGR3FHR0t0cTRZYnJnSG1QUjNKbEVpZ1pC?=
 =?utf-8?B?d0pPLytQZEJ0WGNNa1Y2djRHQkh6NEs5R2xvUGdXdkVnMXZMaTdhOExsUWln?=
 =?utf-8?B?d1huazlXQ0c3am41MGdFTms4dVhnVncwVytVbmw1Qm15VHdzeWxYbmFlQXBi?=
 =?utf-8?B?TS9SMmplL2hUYUVuandSWHdiRVJtY01NbE40bmc4RWN4dU1CZnEwS01HVFRF?=
 =?utf-8?B?REp5dzB4LzlicTIrZURWSVh0RS9VRlJtS2NuUUZqNUplMCtPZ2lmaDhKOEtR?=
 =?utf-8?B?MUxpeVZ2YUxsTVRwNTJDVkNHN0dpQWRIdmdFc3FOOHQ3Qk9QaWp1SkR3WVd2?=
 =?utf-8?B?NlRrL1ZSeVdFN0xiVjFlaFE1dnFaZjYzcXE2dDY0WXZHemxPZ1RtVHczWVY3?=
 =?utf-8?B?SG1ubDNVaktEWmRjbHNvMkN1RDVHS0g4MjFXWFJRUUowZUdjMi9TcHRISEhr?=
 =?utf-8?B?V0E3N3NtS1JqRFQ0WC9ibTlvZUZOeTJwZ2xjNjZJSHF3eGpYeWlrcjFYRDM3?=
 =?utf-8?B?K2s0MEx0eVJBb0szc1FDK2tySFExc2xyMVpSbjBqZ0lFQ21jV0dNVE8rU2V5?=
 =?utf-8?B?TGFna1JIR1FoM3FhQWlkSlpBNnRPKzUzVFc2dWtPK3ZSTS91TEhoRTVyWi8y?=
 =?utf-8?B?N00xaXcxRmRZTS9OZUppcTVNL3VCNjFyMXRSY1diNEhWQXNnV3cxcG84L0tL?=
 =?utf-8?B?ZW9OU2RUM0FqQncwL0tURWJ5MTlWaVBmTFFQcDRvbW5NZm5rblVTaTJaZEtv?=
 =?utf-8?B?TjZKR3BSc2FHdDdDRWFVMnNXNnF5eGVRbE1hSG1yWWgrWDQ4dkhIZVpuQUVm?=
 =?utf-8?B?N2w3c3c1QUVzY1RtcjdPcWdmZ0FqWG5aMXRFTi92S0R1Wit6YkhCTCtHS3g5?=
 =?utf-8?B?V3M2Vkxjb3R2QnNJZFo3T1BVRmd5NEJQc2xwd3djQjVvQndtSGxJUjU1SnR6?=
 =?utf-8?B?VUE9PQ==?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 418c9bed-72e4-48bf-bfdc-08dddef35ae6
X-MS-Exchange-CrossTenant-AuthSource: GVXPR04MB9927.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 07:38:14.1250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSf7ZVSjJZW69wyKsdRDH7BD89nkI4i8/HmAHYxaEojjEfhYba9526DJw9T8u8cZQimBpNgMPpRejq1vsbJt4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8576

When operating in write-through journal mode, a journal device failure
can lead to parity corruption and silent data loss.
This occurs because the current implementation continues to update
parity even when journal writes fail, violating the write-through
consistency guarantee.

Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
---
Changes in v3:
	- Remove unnecessary braces in ops_run_io()
	- Adding comment on clearing the R5_Want* flags
Changes in v2:
	- Drop writes only when s->failed > conf->max_degraded
	- Remove changes in handle_stripe() 

Wrote a script for showcasing the issue.

#!/bin/bash

set -e

RAID_DEV="/dev/md127"
DATA_OFFSET=32

# Arrays to store disk states
declare -a BEFORE_BYTES
declare -a DISK_NAMES

cleanup() {
       mdadm --stop $RAID_DEV 2>/dev/null || true
       dmsetup remove disk0-flakey disk1-flakey journal-flakey 2>/dev/null || true
       for i in {10..15}; do
           losetup -d /dev/loop$i 2>/dev/null || true
       done
       rm -f /tmp/disk*.img 2>/dev/null || true
}

# Function to read first byte from device at offset
read_first_byte() {
       local device=$1
       local offset=$2
       dd if=$device bs=32k skip=$offset count=4 iflag=direct status=none | head -c 1 | xxd -p
}

# Function to calculate which disk holds parity for a given stripe
# RAID5 left-symmetric algorithm (default)
get_parity_disk() {
       local stripe_num=$1
       local n_disks=$2
       local pd_idx=$((($n_disks - 1) - ($stripe_num % $n_disks)))
       echo $pd_idx
}

cleanup
echo "=== RAID5 Parity Bug Test ==="
echo

# Create backing files
for i in {0..5}; do
       dd if=/dev/zero of=/tmp/disk$i.img bs=1M count=100 status=none
       losetup /dev/loop$((10+i)) /tmp/disk$i.img
done

SIZE=$(blockdev --getsz /dev/loop10)

# Create normal linear targets first
dmsetup create disk0-flakey --table "0 $SIZE linear /dev/loop10 0"
dmsetup create disk1-flakey --table "0 $SIZE linear /dev/loop11 0"
dmsetup create journal-flakey --table "0 $SIZE linear /dev/loop15 0"

# Create RAID5 using the dm devices
echo "1. Creating RAID5 array..."
mdadm --create $RAID_DEV --chunk=32K --level=5 --raid-devices=5 \
       /dev/mapper/disk0-flakey \
       /dev/mapper/disk1-flakey \
       /dev/loop12 /dev/loop13 /dev/loop14 \
       --write-journal /dev/mapper/journal-flakey \
       --assume-clean --force

echo "write-through" > /sys/block/md127/md/journal_mode
echo 0 > /sys/block/md127/md/safe_mode_delay

# Write test pattern
echo "2. Writing test pattern..."
for i in 0 1 2 3; do
       VAL=$((1 << i))
       echo "VAL:$VAL"
       perl -e "print chr($VAL) x 32768" | dd of=$RAID_DEV bs=32k count=1 seek=$i oflag=direct status=none
done
sync
sleep 1  # Give time for writes to settle

echo "3. Reading disk states before failure..."

# Calculate parity disk for stripe 0 (first 32k chunk)
STRIPE_NUM=0
N_DISKS=5
PARITY_INDEX=$(get_parity_disk $STRIPE_NUM $N_DISKS)
echo "Calculated parity disk index for stripe $STRIPE_NUM: $PARITY_INDEX"

# Map RAID device index to loop device
PARITY_DISK=$((10 + $PARITY_INDEX))
echo "Parity is on loop$PARITY_DISK"
echo

for i in {10..14}; do
       # Read first byte from device
       BYTE=$(read_first_byte /dev/loop$i $DATA_OFFSET)
       BEFORE_BYTES[$i]=$BYTE
       DISK_NAMES[$i]="loop$i"
            echo -n "loop$i: 0x$BYTE"
       if [ "$i" = "$PARITY_DISK" ]; then
           echo " <-- PARITY disk"
       else
           echo
       fi
done

echo
echo "4. Fail the first disk..."

dmsetup suspend disk0-flakey
dmsetup reload disk0-flakey --table "0 $SIZE flakey /dev/loop10 0 0 4294967295 2 error_reads error_writes"
dmsetup resume disk0-flakey

perl -e "print chr(4) x 32768" | dd of=$RAID_DEV bs=32k count=1 seek=2 oflag=direct status=none
sync
sleep 1

dmsetup suspend journal-flakey
dmsetup reload journal-flakey --table "0 $SIZE flakey /dev/loop15 0 0 4294967295 2 error_reads error_writes"
dmsetup resume journal-flakey

dmsetup suspend disk1-flakey
dmsetup reload disk1-flakey --table "0 $SIZE flakey /dev/loop11 0 0 4294967295 2 error_reads error_writes"
dmsetup resume disk1-flakey

echo "5. Attempting write (should fail the 2nd disk and the journal)..."
dd if=/dev/zero of=$RAID_DEV bs=32k count=1 seek=0 oflag=direct 2>&1 || echo "Write failed (expected)"
sync
sleep 1

echo
echo "6. Checking if parity was incorrectly updated:"
CHANGED=0
for i in {10..14}; do
       # Read current state from device
       BYTE_AFTER=$(read_first_byte /dev/loop$i $DATA_OFFSET)
       BYTE_BEFORE=${BEFORE_BYTES[$i]}

       if [ "$BYTE_BEFORE" != "$BYTE_AFTER" ]; then
           echo "*** loop$i CHANGED: 0x$BYTE_BEFORE -> 0x$BYTE_AFTER ***"
           CHANGED=$((CHANGED + 1))

           if [ "$i" = "$PARITY_DISK" ]; then
               echo "  ^^ PARITY WAS UPDATED - BUG DETECTED!"
           fi
       else
           echo "loop$i unchanged: 0x$BYTE_BEFORE"
       fi
done

echo
echo "RESULT:"
if [ $CHANGED -gt 0 ]; then
       echo "*** BUG DETECTED: $CHANGED disk(s) changed despite journal failure ***"
else
       echo "✓ GOOD: No disks changed"
fi

cleanup

 drivers/md/raid5.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 023649fe2476..da7756cc6a2a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1146,9 +1146,21 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
+	/* Successfully logged to journal */
 	if (log_stripe(sh, s) == 0)
 		return;
 
+	/*
+	 * Journal device failed. Only abort writes if we have
+	 * too many failed devices to maintain consistency.
+	 */
+	if (conf->log && r5l_log_disk_error(conf) &&
+	    s->failed > conf->max_degraded &&
+	    (s->to_write || s->written)) {
+		set_bit(STRIPE_HANDLE, &sh->state);
+		return;
+	}
+
 	should_defer = conf->batch_bio_dispatch && conf->group_cnt;
 
 	for (i = disks; i--; ) {
@@ -3672,6 +3684,13 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
 		clear_bit(R5_LOCKED, &sh->dev[i].flags);
+		/* Clear R5_Want* flags to prevent stale operations
+		 * from executing on retry.
+		 */
+		clear_bit(R5_Wantwrite, &sh->dev[i].flags);
+		clear_bit(R5_Wantcompute, &sh->dev[i].flags);
+		clear_bit(R5_WantFUA, &sh->dev[i].flags);
+		clear_bit(R5_Wantdrain, &sh->dev[i].flags);
 	}
 	s->to_write = 0;
 	s->written = 0;
-- 
2.34.1


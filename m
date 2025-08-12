Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023118.outbound.protection.outlook.com [52.101.83.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF42710E0
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 13:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755004117; cv=fail; b=K2DMf+/tv1CCjZZlQdsqg65oFId+COnJemTWEpNO+/GzCfvZQcZgylk5ayoFN9d6Q0LM0R5W5tCiuoFzk5l1SUpzrLSWmix2vmUXlpqLQr30v2sD0AgfZklhufD/GRocCPxIi2czJ8OLJvFY/FNDd+PmTrxK/L1HWETU3BK6sjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755004117; c=relaxed/simple;
	bh=ZU+31ioL14b65t1rnxMzzNdP9DA2VasYjHgFT96hngU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=qjIRjq7MYmtq/e0+h9m90CVGyUJEeRraMftIzURpsnF2i6+14xRK8L3wGPCJ56TK8R9AOCxcK6IJ4JO9gBvLquTQeUgi2XTUsvDhLfUYssb4+UZbxXDUefMOoEBCDXcfYybWOm2VutEHfzsTRowPut77evR7X04tZtW4nDZLfVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=C6IFdFDw; arc=fail smtp.client-ip=52.101.83.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="C6IFdFDw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IIfjHW70yAMqRGJSg9/tNfwDES229a2Kjw80GFXX+oxieFR99nwU6ZHxWrAQ0HwT0XF51gYTAUEyDeigeq18/sUqNQQfbMZbun24jEVHxdlMsPyLBTQwQijD8jVUQqiwaoeKFis45gLrb++dnoWOD67H44vGMnC5jH9y4stXInPueAoWRMbp2bmMW2CZpNDuCLKGC/orrkgDn3EhJgjI9Wirw0nEvOhwtWltmcGxN2SUfmHt6OuoKzqZ67OexyvHOD9jz3/kMxCIV8fZHv9t2I4SFqYqnqxzPj2iTVsUJB0U/bhWZo+RBb0knx03AvFf9CdQukQUnmZbd4UhtRpQSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1QPovqKpQZ5a5ayfZG+EWZsC+K3ibfN5R5THDww4eU=;
 b=B44MkjCB6/JLGWnIajlgPJeSDmx4s26/DESLoPMn+DnAZfR0vzURd1h6PSJuZtXDyF7qPfvJx0VoLEZpPm/+gcCgovUxXDmFMy3jL16uTVs7hdLmqCcF5XpPIrCoeOgKFRh5jhxo1hqyQET6EBVjdUa8TyUHX2SrL/iZ7VdWoevJ8C6yONyWKQ3Kp/hv9ImfNOFLo/XLGc9DYLo1oQ9+XbmJlyLrgWCyCXpSq1rFR5t+l87m5PniE0EYMQZGfD008kbXdDyPNHHO51iBmBH4v13M9vxNHNTKP3/zx8VAc7E5xgnLs3Oi547LUYYHUIdtECev4uYuXvkItvYNJ5u6tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1QPovqKpQZ5a5ayfZG+EWZsC+K3ibfN5R5THDww4eU=;
 b=C6IFdFDwL8YSJxdSBNuc38QtwegjOWppiakOoFSbLkhe7pr3X2BtCJ0tSmOoVuLRHGSzDw6YrjLnAGr8H7VlaYN60cIkyjuNa1S4nWuhbtf7Asrknq/m1Us1P6xfHh8ioMnrwCeoHWgvbpH5qdqUxKJvwDxiaYWEo9ro2HweONRenh2Gwb3nudaedQzncxxemMifYh3fRjhwnVZpSSRWyTZoU0KP2GTNtwREU+jEg0VDvOsdW0PS7tKrHKbFNIbFDC8y1hyODzkp2nvQXuhYiWj1uxf55V0llcpPpgK+uqvgnoaMCrHsrYDGu1v22hMnmLT1Y30Nbm4Bo2fJlxXi7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from PAWPR04MB9911.eurprd04.prod.outlook.com (2603:10a6:102:38b::22)
 by AS8PR04MB8514.eurprd04.prod.outlook.com (2603:10a6:20b:341::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Tue, 12 Aug
 2025 13:08:31 +0000
Received: from PAWPR04MB9911.eurprd04.prod.outlook.com
 ([fe80::475a:ebf6:dc66:b49f]) by PAWPR04MB9911.eurprd04.prod.outlook.com
 ([fe80::475a:ebf6:dc66:b49f%6]) with mapi id 15.20.9031.011; Tue, 12 Aug 2025
 13:08:30 +0000
From: Meir Elisha <meir.elisha@volumez.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	Meir Elisha <meir.elisha@volumez.com>
Subject: [PATCH] md/raid5: Fix parity corruption on journal failure
Date: Tue, 12 Aug 2025 16:08:21 +0300
Message-Id: <20250812130821.2850712-1-meir.elisha@volumez.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TLZP290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::20) To PAWPR04MB9911.eurprd04.prod.outlook.com
 (2603:10a6:102:38b::22)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAWPR04MB9911:EE_|AS8PR04MB8514:EE_
X-MS-Office365-Filtering-Correlation-Id: f7965ff1-4dc3-43bf-eee1-08ddd9a15593
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b0F5dCtFakNwbjJ5VGJGcWxHZXdCOTlQcGtrSG14ZmlhM0xLRUsvUDQ4ZGx1?=
 =?utf-8?B?Vk52SkdkWm0wb3l6RXFlNmxWMFhpWWc2NU9DeHU2MGJEWHpmamRobXAvSGNB?=
 =?utf-8?B?Q3lrM0NPc1ZQMFI1QVdPWnovZEY0TDRKRFhzNHp3dnFRM0MzUU15QnRYc0p0?=
 =?utf-8?B?N3M5aldRaEc3NnBUczN0R3p6ZVRsNlA5K29HcThxNnJOZDk1c09WbGpJR1VH?=
 =?utf-8?B?ejNQMkdCRHR0YlBVakcxZURsNnJ2WW9qcmNBRVpIa0pFOTJsd21lRXZHTFRw?=
 =?utf-8?B?NWhOb1RqUjRwdklaNEpCMFg1QmhRU0hOVEVvTTNtYTV4ZFJpQVJqdzlYZDJv?=
 =?utf-8?B?dEVlTlhQaGl3NXJ1MXppYzl4Ni94Ymd4ZFBoRnB4WTlOQ0w1Uk1GWmdqY2VC?=
 =?utf-8?B?cFd5a2Rya1FkekVFMlhWcFVqQ1gyeVdSUVE1NW1uTUlZcG5yQlNmQThOYmFG?=
 =?utf-8?B?VGNxZWtxYmhMN0svQ1hhKzY5MVc1blBEZGlDRUtjVGdEZmd6M2hDTTdTeUVY?=
 =?utf-8?B?OTNMd2dHMmRETDNlVW5rT0JQWnBIbnZTb2dlREpveVVVSGdFQ3ptUjNpNm80?=
 =?utf-8?B?SmIwZGdMQlBHZkpZZ1ExZzNFUVV5clhsR29GOEVUd2dRRm9ITENtRUsyb3Fk?=
 =?utf-8?B?VFViaVJPb2pJWk04Z1VxaEtXTWdlTC9OcGJWRnd0M0NjbitzRW9vU0FMazU1?=
 =?utf-8?B?Zm82Sk9LOTJQa2RmbFFLZ051czlNUjhFbUtnQmNYRUtBNFZ6Z0wvM05wRUZ2?=
 =?utf-8?B?c1AyaW1rZ3lLNFJYMXRsWVlRUk9UNnBYMG5yYUxaa01NUHVLdUdaNlJDc2NY?=
 =?utf-8?B?SklXOUtiV2Z2d2NRZG9XaytvOTRqbCt1THptV2J2R1RwczA2YWZhb2VrZmRS?=
 =?utf-8?B?ZUFsM29qeVZOaGsxQVkxQ0hIdTVOclRFUndMUEZtR2FSdzRhNTlxWjh0MnFL?=
 =?utf-8?B?VE4zWlNQNGpvR3E0MEVxcDQzdzRQWEJneUhBUWgrUFZpdFdsaEtQUnJLU1pZ?=
 =?utf-8?B?cFlKRWVJemp5QWtKdUZxaURxL1NEbFVrZXNZMkNxM29tK24yQjg3ZHdXUkd3?=
 =?utf-8?B?NlIxc3FjdXMyaUdRK2RQc1EvMUdJVktGWU1QYXpjSGxLa1Ztd2RxZ0U2YzE4?=
 =?utf-8?B?QjlsUmw2elZYZmwzaGFITlNENWdZZjFURyt5UVluYldkWi9Wd2FmWmphanNI?=
 =?utf-8?B?TS9PQnhxQWR5MUVwc3ZpSDNiejlyZ0FIdGxPdnVBMHM1S1BTSDNzQTFKdXps?=
 =?utf-8?B?UHFHZGdvUFhkZ091ZXpCbVo3YTFLVUtUaHhzS2pXMWp0OHp3QW1JTHJVSjFI?=
 =?utf-8?B?K0NBZGF1aS9ONytSVVNZWnpUQXJjWkxvMlNRRzdqY3YrZ0duVFAxSXI1UkxW?=
 =?utf-8?B?eGx1ZXhZWTZ1aVYyUC9iRjRKU0w0TDM1OGxONjExS0l5elZpdWtvWmFmcWxy?=
 =?utf-8?B?NkJoYUFkTlhJWU9oTHpUcE5ZLzAzU1IyVEpmU012NVJPWmg4eCtWRjZsUTdq?=
 =?utf-8?B?clFWMW1RS3VzdFlvRmg2TFM5d3plYURNcGluL0FiUW5XMW5tYUM2TS85UDRt?=
 =?utf-8?B?Rjh5WWsyaFlRcWpVbFlzVGh5QU9BRDFSOVdLQ2JuQkp0MUZac0pxTW9OTnFH?=
 =?utf-8?B?WmlzNHpLc0pSS09ZVERGOVExOEJ3b1VaVUI1ZHR1Z2ZzZkhSTmN6MThXdEFK?=
 =?utf-8?B?cVE4dC9uazlMNDBSbTEybVJBOHEvaC94WTU4TVdGQkMxaUVEUDNJN2pjQkZm?=
 =?utf-8?B?TlhDeHdCOVhiaVBkZ1RWOHBqeWFCNXZaL0JuVUhDeDNLaDVFMlQ3VlZaZS9W?=
 =?utf-8?B?SjI3aGpQQlYzNDZGYnJITzVpbXNQZjJJVi9YMWd5UFk2SmdxWGpCcE03S2hw?=
 =?utf-8?B?QXd0ajBHbWtvanVhYW1Rd3hMUjJydE1JbXlaOEdLU3RmTGNpMGRjbUFvNHpT?=
 =?utf-8?B?Z0Y1OVBKM0ZmaUpLTkxwSDFJcEt3bFV2VEV4b0ZRS0M2ZXhxa1FvazJ0clk1?=
 =?utf-8?B?L2cxUDk5YStBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR04MB9911.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1BoLzhOcEhBaWdibGlNNzY3dlpOenFrekVLaUoyRWN3cTdGbWJtR3R4dTVH?=
 =?utf-8?B?YiswN1FyVlZ0V0hYUUhVSm1DL3VHUmkxK1NrbHFaVmdMYmdCZW1ZMXdDNFg4?=
 =?utf-8?B?dzF2VURZRzY5UTFhUHVRVkdNSGxyZzBNWTFvYitIamdYTmJJM3UyNjRYQUps?=
 =?utf-8?B?VTEwUkxVTERQZjA3RkFWT2QvR0RmUWxYT3MvSFZabTllUENZNy8vRmRHZTBR?=
 =?utf-8?B?YTEzdnFzcEgweDM5b3dXSUJ1azE5eXlvcWd4L1hCcFNMNU5PVllNL1NVUm96?=
 =?utf-8?B?UmdHQUhrM29ad3hnOWdieGJYNnZUb0ZoVDB1Q21DUlVMZ1RibzFod2I1WTRx?=
 =?utf-8?B?dExETE5SNXBadHFVbHR4S2pjSVdlV1RkT1dNTXloSHBua2pJeVZOOUgwV0V1?=
 =?utf-8?B?RTJTOGRSS0FFUmNjeVBwL3g2KzF4djR1U2l6c0ROandYM2lEKzIxayt2Tnpo?=
 =?utf-8?B?QmRSLzB1RWZ5WXFnZC9CSVZnTGVQazFtSmtqUFYwL1REWWhIRTZEemtzV3NT?=
 =?utf-8?B?VmZFVTdjZzRYSkx6TE1jVHJYbHZzSEZWRTlOdEtQMlZEYm5qeVlEcExTYWFs?=
 =?utf-8?B?MnptcS9aYjBwY2VBcHRpMW5WblJyQlB5d2EzRGZkMGo2bWdsWjlLM1I1MHd4?=
 =?utf-8?B?Tkw4N1p4QnAvR0ZJRTBhNTV1emd1ZEY5c2tOZ3V1eG9sSDFGVDQvdUE2VHZW?=
 =?utf-8?B?bUVSbklZZW1FMnNLZkRad2xydEJzejgyaWFUdkcwTjBMSGV1bHQ5cGE0WEw0?=
 =?utf-8?B?YzNuNlpLTmpwR3BmbXE3MDlWR3lzT2xSZ0oxQTJrcCtVUkNrWlZXYkVocWNN?=
 =?utf-8?B?TWlvL1dSYkJSakRSK1R0VTBWUzgzMVFhTnYrSXh5ci83WlI5SXg1ZGw1Q1FO?=
 =?utf-8?B?V2ZITHRsSVhmcUNWeGVadEgxdUM1Y1g2a29CZzNaWjUxY0tEUzc3cnFUcmVF?=
 =?utf-8?B?dWxaRmNNd3hWTTEyL3BMdi9VdjhmNWYrWVh4VkczZ3NUZExSMTYwTm0yZkpG?=
 =?utf-8?B?NnhMeXE1bXZ3UlQ2UTEyME9UM3B6bERlbHZPRGlqZjZGU25vdmtES1REZTVW?=
 =?utf-8?B?VlAwMUkzS0NGZUJjcm4ybjRwUFJrRmIrLzVvcTFJNVgvZUwzaU9oTEgzRElu?=
 =?utf-8?B?dHZ5eTE2Tng5bVYxeExnTThkVnNOUlNFcmg3dE9xdUloV1lwajF1NkNYM1p2?=
 =?utf-8?B?Q3NwRUw0M3diMTc1czg0ZDFCNGZXcUFGV0lEV0JmWDBDVWNKc0ZPN1hERVZP?=
 =?utf-8?B?MDg5dFBvMUZrVWdJbEVWcHd2RkIyN0x4cTQ5c3BJeE9jYk9qbVRvMkZyMmp5?=
 =?utf-8?B?VEFkM05nbHYxU05keDhlR0JHdTcxRDJ2QkI1QXYrZi9NbG9ZWUg1VllKdjNn?=
 =?utf-8?B?SkhIS2Zwc3RvSFlOQzc3U0xocmdzOURpSmNKNmg0a1dSR3ZpMUJUMWF3cUNr?=
 =?utf-8?B?Nlc0UXBicGhNRmtXaUNhY3ozeGx6elFqditYOCtLakNyaDZ0azR6WVVoWGhD?=
 =?utf-8?B?a3FzRUFVSk9zQVNpcUhVWWlSNWgrN1ZaNnEvdHlXTUJzSC9Jb3VxRFBGVWlk?=
 =?utf-8?B?WFVRZHlxMmlTU2JlaTVad3JENVFNd0RsNDlCRUs4QUNzSDhVMWlsYlArZXB4?=
 =?utf-8?B?TWk0bzExQWhkQmgwVVgxUkxSYkF1SllsYXBaYUtIUXpIcldHNmxRUVg4S2Fr?=
 =?utf-8?B?RW03aDk4Q0ZvazB6cmdGS3JnT3BDZ2ZoRGR5WGZDeDFHWjBML3ZKNXg2dFFr?=
 =?utf-8?B?WTByMER6Z3NsOGx6bldCOTdhY2g4NlRiYUZBS1BDN0x2SzBib3pNamJvK1Nl?=
 =?utf-8?B?Z3NtcUFUVk02Y0N0MmtqditjZm1lOTV1eFZZSjVWcHM0dE1FNDhtWHpmQXlY?=
 =?utf-8?B?SUhONFd3OFhubjM4bkFDVkRzYXRLUGl0QUc0WUpoVHdiRFg5MDFGcERrSDVZ?=
 =?utf-8?B?RVhLVW8zNGFoTnFsQzVpZWF1c2ErYldnR3MzekVBdDc1RHRRTk0yeDFmWnZi?=
 =?utf-8?B?YW5SMkdpV1dHblVOVjN4MXFSQktlK0tBUWloYXRmQ1dXRDV1RUMvZmE3Mlhl?=
 =?utf-8?B?M0JSTGdIeEtZa3R3QVl4NU5POW1GOUJhMWVKZ2M2T1ZxZW50azZwUG1ka3NK?=
 =?utf-8?Q?FZ4OHrs0NiAISHwaG1DMMjXJ5?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7965ff1-4dc3-43bf-eee1-08ddd9a15593
X-MS-Exchange-CrossTenant-AuthSource: PAWPR04MB9911.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 13:08:30.7619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iI3y/29nIMz5r2C1g/RhBteWkbg69/PpAnhjCwGcRSYxbEa63NEduqK3dbinnnvfU6L+rH+c1qhUm4lK3RJLvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8514

A journal device failure can lead to parity corruption and silent data
loss in degraded arrays. This occurs because the current
implementation continues to update the parity even when journal
writes fail.

Fixed this by:
1. In ops_run_io(), check if journal writes failed before proceeding
   with disk writes. Abort write operations when journal is faulty.
2. In handle_failed_stripe(), clear all R5_Want* flags to ensure
   clean state for stripe retry after journal failure.
3. In handle_stripe(), correctly identify write operations that must
   be failed when journal is unavailable.

Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
---

When log_stripe() fails in ops_run_io() we keep write to the parity
disk causing parity to get updated as if the write succeeded.
shouldn't we fail if the journal is down? am I missing something here?
Thanks in advance for reviewing.

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
    echo "✓ GOOD: No disks changed
fi

cleanup

 drivers/md/raid5.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 023649fe2476..856dd3f0907f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1146,8 +1146,25 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
-	if (log_stripe(sh, s) == 0)
+	if (log_stripe(sh, s) == 0) {
+		/* Successfully logged to journal */
 		return;
+	}
+
+	if (conf->log && r5l_log_disk_error(conf)) {
+		/*
+		 * Journal device failed. We must not proceed with writes
+		 * to prevent a write hole.
+		 * The RAID write hole occurs when parity is updated
+		 * without successfully updating all data blocks.
+		 * If the journal write fails, we must abort the entire
+		 * stripe operation to maintain consistency.
+		 */
+		if (s->to_write || s->written) {
+			set_bit(STRIPE_HANDLE, &sh->state);
+			return;
+		}
+	}
 
 	should_defer = conf->batch_bio_dispatch && conf->group_cnt;
 
@@ -3672,6 +3689,10 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
 		clear_bit(R5_LOCKED, &sh->dev[i].flags);
+		clear_bit(R5_Wantwrite, &sh->dev[i].flags);
+		clear_bit(R5_Wantcompute, &sh->dev[i].flags);
+		clear_bit(R5_WantFUA, &sh->dev[i].flags);
+		clear_bit(R5_Wantdrain, &sh->dev[i].flags);
 	}
 	s->to_write = 0;
 	s->written = 0;
@@ -4966,12 +4987,9 @@ static void handle_stripe(struct stripe_head *sh)
 	/*
 	 * check if the array has lost more than max_degraded devices and,
 	 * if so, some requests might need to be failed.
-	 *
-	 * When journal device failed (log_failed), we will only process
-	 * the stripe if there is data need write to raid disks
 	 */
 	if (s.failed > conf->max_degraded ||
-	    (s.log_failed && s.injournal == 0)) {
+	    (s.log_failed && (s.to_write || s.written || s.syncing))) {
 		sh->check_state = 0;
 		sh->reconstruct_state = 0;
 		break_stripe_batch_list(sh, 0);
-- 
2.34.1


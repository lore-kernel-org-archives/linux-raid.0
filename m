Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023136.outbound.protection.outlook.com [40.107.162.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E06B7DA6D
	for <linux-raid@vger.kernel.org>; Thu, 14 Aug 2025 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755181705; cv=fail; b=OzbafHL80gfSJLwOFRXVQ3iFRORGeHxRsi/Il5TqjNUZDKBLA2UX2Wl2r4rIsFeIi6SPY181Cx7FiHxzGNhbhEHNXguA0r/2q9jCpIY0HTCz7uNF0uLaEmGIn+iJG3c3/XAXsTpz2hOR7p95rwAZAI7fKd9DxMHmGWaZVqu5lDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755181705; c=relaxed/simple;
	bh=7Mrzld5Mj+V8PehEKK4YidM1T+x7/u6WrfxVn8eoAMI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=efYxY7kTw8wtGKS2Hy1BS1TJaFk3zNaB98yVtw8Y//KwjF5lp1hdRkPySqwg7b9ceezLwfIFY+G+ZbtqAw272NEI8HSVOr8BPchQyGkz7qNzGXQFoAEN/c3ih63cYn8+Btan0YZh5+OBLEEfiD1crYPoK30o/88+Jj8aBJIYxzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=IS+yNB/l; arc=fail smtp.client-ip=40.107.162.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="IS+yNB/l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fsrbz+NQC/9i8vOoPFEvS1j/ymOP1WTVPjFzZdQqEAi8q9mdjUvg4ZmrilD1mD6mNujlILjiWek/a2Jt301wlAHmHVngJRjlqRZ+3bHSTVBK49xprzDDHTJ1zKrDb7i9tHYYmIQxPYD7p6v/8xc4DXPx8TqNuLfOuu2rreIKWJw6lqLQvRxQVolPkDcTk94yC2WFhoy6aT4LjkDCCZYWnoLivJBxrr+1p7bICWnLjNfQqU4QBF9AGNIA8+RclB+OKYxc+NKaLKoNaLvjj3aiNi04obt+AXjLDsVT0A7RZsDZTsmTlbinKrLZpTan9mckQ2ofhxeXkyhE9Unq6pjReg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QflbQf6DJ8YFhiVTQYmGY1I8M759b86hrVbJ/mNiEXA=;
 b=NJSmM+e5pkxn3nJqVDaU7DFgEnCFbRj3n5qjKgi+fG7BqE95mUY67NFuw7HmHgtzrF2Sfes2DhTxTJehiox+/v4TmG10BYNWgcu/I+SKD8KK8pMIe4hqXT3foE9fPenly9azgLAPidSqUSTkJvm+AEOUG8Cor37lMv4qfkD66zo6njlE6r0jV+sBsSWHIIfvPBvwwxN3Bxg8L4RWgeJEsVT+QBwsygRK1oC6hPQsQosepgSi7slsOGvnjZP3WMaYYtZbBCXYRD5qnevUt8Ns6Z8aY4fieyQwSrmDsspA9mYeh4jYRVULCpx0j0RmbG7qmI0CyW0d1iP9ijWuCvyn4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QflbQf6DJ8YFhiVTQYmGY1I8M759b86hrVbJ/mNiEXA=;
 b=IS+yNB/l8TXfkUd4+J92Fi5P/duvsRCgFOrDrofy/+/McyoQMfxbVTTdQJUxwDRkmFOZleAwxdn/HT8ZjaYvjnfMvbjZzC/5Dju1MGJs4PT3qXlqseDLhsBaYm3j1oCBdaW2DCLjq3EMHDN2CQX7jtrTywENSsI60g0SmFa/xEgrKD1/PC2quuzCmzQ+P4q6xARiHWR8HUJK4L49BaRy7QKWIrIGoabOD5fkR6Nz7F4X2qEZOPYL3FR707UjhplJ0qa9DnQi5wIhxvyRyi4gbD/Jr1bgwLyO3BJ83LM1JESk0LpCPGD6/7n7oQz/tEhE7Xmp4jwQthYqizfLDEaunQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
 by AS8PR04MB7509.eurprd04.prod.outlook.com (2603:10a6:20b:23e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Thu, 14 Aug
 2025 14:28:20 +0000
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8]) by GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 14:28:20 +0000
Message-ID: <30c8d3b3-55c3-4e21-9ce5-62ec95a1189e@volumez.com>
Date: Thu, 14 Aug 2025 17:28:16 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: Fix parity corruption on journal failure
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250812130821.2850712-1-meir.elisha@volumez.com>
 <37d7a46c-1db0-f600-baaa-d8b14ec8f710@huaweicloud.com>
Content-Language: en-US
From: Meir Elisha <meir.elisha@volumez.com>
In-Reply-To: <37d7a46c-1db0-f600-baaa-d8b14ec8f710@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0004.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::13) To GVXPR04MB9927.eurprd04.prod.outlook.com
 (2603:10a6:150:118::22)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR04MB9927:EE_|AS8PR04MB7509:EE_
X-MS-Office365-Filtering-Correlation-Id: 67f285c9-54d6-454a-3819-08dddb3ed124
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tkl2T1Joc0xuYURUcHdENVFMenhSM0EvTjNuczhjT1B3UDVaSjBTeEcrSGpR?=
 =?utf-8?B?MzFCVURTQldoenVUb3luSEN4MGVJUGIvYUxPQXlXNjlyR0p2bGh0MU9pN3BW?=
 =?utf-8?B?QXN5WW1XKzJSZ092ODJaZWtCNFRPQjRhNUN3UEFqQitIQ1VLZDFNcUhmb1dt?=
 =?utf-8?B?cTdvdXZrY2FwOWxtR2RMWHZZY09yRWxpSTduMWtSWnZRUngzWGVQcGR5MTUx?=
 =?utf-8?B?Nzk3eXUxMXZ1ZEtkYnZOa3VYY3VvVVQveHBTeGsyMlQ1S2ttand0ZmNFQy9F?=
 =?utf-8?B?b3VGY3NNUnFSdXcwTVQ5T3Uwd3MvNjZManE0TG9CajNFellndE81M2Q3M3lY?=
 =?utf-8?B?Uy8zcm1IQTNlUmw3WGdoVzhZaXpIS013UU5iMXpyb1kwYVowUGE4RE9jZ3RU?=
 =?utf-8?B?dVBFYnU0OG5memhmVkRlVFRPQjMyQ0x6eVEvcGNieitqOU9lbk1XNVZOdDU2?=
 =?utf-8?B?MzhDbCtjVjFSdVBpNXlNTmhhNUdaN3hWNUVXZ0hUNEtMRjRNT0haNmVZMUMr?=
 =?utf-8?B?WTlnd0cxUG0wdS9sL1RrT2piVkU5ZDhCRThNWDFCZjk2T1JVVmlqTUVLOG9X?=
 =?utf-8?B?YURCS21sWE5oR0c0K3ZiNzZjWXBSMmhhdTk1b1EvczZseTFWd2I2UFk4Snhm?=
 =?utf-8?B?Q043UDNBYlU5NTlNc0tjTnVHLzRsYTI5UGZUdTU5MkN1elA1dm1YekVURnFV?=
 =?utf-8?B?VTJlcnZaM3NzVGtqWm9IRCtmSjQ5MkFkelByWWNGb2hqQzczaDVlU2E2Mjdz?=
 =?utf-8?B?OUZ6eDgxaGRmMERrMVd0cSs3aG11Y2FxT1UyWklLS1ZGTWZMR0NJNHNoRmVH?=
 =?utf-8?B?T0JXamZjUC8yRXNzb3oxMG5ucXozREsvd1V4TU83UjNKcmp0bS9DSUNhU2g2?=
 =?utf-8?B?R1IwSGtqSVN3VG1aQldoNjgzN3YyckZMYjZCT1BwZlBBcnlFZzhwWmZaWDRU?=
 =?utf-8?B?cXFpb0ZGMzU2UmNuVGxCWWFEVHgzZEVRTXNsdEtDUlZFTlpMS0hvZmRsQ3lM?=
 =?utf-8?B?M0dIWDJWQWk1a29UZnNPMTc3WEdCcDR2SlZNeUpUeHdmSVRRWkNQY1M5Qlla?=
 =?utf-8?B?OHFuK2VMd213bmtWa2pEeFBBTE1MazhDSnF6ZHZadFRxTFR0N0Vjb25Pb2Iw?=
 =?utf-8?B?S3RManlwNm9rY0E2VnBtMGtvK01tc0gvU08yNFdrRWJUTGx2SlZRU2tCUHhB?=
 =?utf-8?B?VUJFUStqdUJoY2ZNVjlYZkwwZ1Frbnp4Z1BBV0hicjVoVzJhTWhXdE1NVXh3?=
 =?utf-8?B?VG5Gcm9TeFdEQ3I5YkJSbktubE50SktZTmVsc3Q5RnJVeEkxN0NxVFQrTHNC?=
 =?utf-8?B?RmNPSUFEVWI0NGU3d3ozNGxPcmVlWXdRUVlVdHhIRU9UUXhSYUlERjA2TmpM?=
 =?utf-8?B?SzcyU3NybVFEb21hSjY4SExaWHBsOWxFZlhuczFtVnpITG5kSElFQWhEVXAr?=
 =?utf-8?B?aXJrZ244QloxdFZ4VnNmK2FRVmtudXJrNmwxcWl0UkcxQTR5bDdwUGgzdVcr?=
 =?utf-8?B?dDRYdGdlYllreGFVYURPU2hOUVdKR01nYUYrS0VQL0orNitHRjc1Y3dHbDI3?=
 =?utf-8?B?L3Q5SmxlODNYMEMveU5jZEJXdStXRHg0VmlJT0JtYXJTUFZKbFVkWG5nQWpU?=
 =?utf-8?B?YzYyaXRmenVKYkZWS20vc3l1Y1liYXZOUzFwWDNUbDJvenAyUElXRi9PSVQ1?=
 =?utf-8?B?cDRoK3dCRWZoSG1jaUJER2VyMnZnbmZ2aVEzcHE5REEzOHc3NWE3cThKTG43?=
 =?utf-8?B?UDVjWGZjRlF1RUxrOVFndnRDUEEweTIwMThwZUJ6YlhONUR4UVBkdCtSVlZY?=
 =?utf-8?B?dG9ZSXVWdVdNMzY0SzhGY0grYzh5RVVNbmpvaVcvdTg1SVZWZ0FFNTNWNGZB?=
 =?utf-8?B?eW1sc3Q2em9CbzYvdjlnSTB2Q0txMHBWMCs4a0xJNlAwUEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB9927.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGVHT1VIaTRFU2FmbXdmQlE3NzlSVjRRRURQaUowNFNqeEh4VGp4aENkNzRY?=
 =?utf-8?B?SU0rbFBoaWtVMUhUVEVURSswTXV2d0UyMTA3UzRxWXBidmlrZzkrSmhPTFJW?=
 =?utf-8?B?VzdyTVFLVGJINVRjQS9QVm0xSmE0RVhja3FpK2V0VWVLYUtrQ3VVOGliMzNV?=
 =?utf-8?B?aUUvVmYxWDVuQ3d2K052REpKQlFlVWZmNEJtTW1DUmNNVWZIK3lQRGxwblZh?=
 =?utf-8?B?dVl0S2R0eU1Odmo3S0IrZ0xrVVJYdHUvQS85S1lNT0RJcFVuMWtSc2o0K3BT?=
 =?utf-8?B?a3JNNFpUdFJ4aVUreFlobVJVcllhSDVUdkR0RzlKYUFhTWpQY01xdVB3QjRV?=
 =?utf-8?B?RWswUklFVEFrWTZteWlwU0RiTDNvZ1BNRm1WVjl5VVk3b0x3WkZKMDUrb0NI?=
 =?utf-8?B?ekQ1aURKYVByWkEyMGdYWUNITjdiNzUvQU4xeHYxZEVXZFRBMlpaK1RpZC9h?=
 =?utf-8?B?cDF5T3JBS2QreG1DUy9HWmd2UXZjbzhNU0tMTCtmMGFYbUdGWm1jQUZ2MUpl?=
 =?utf-8?B?YUtYaWJEZXM5VVBoQVQzd3oxc29jTDdYS0t5cmNoNmI3ZE1vQUF0UTg5Vzl0?=
 =?utf-8?B?SU16TzQrMEhNcjlaNTUvNlo4UktIMTYzQm13cHVYTTgySlRqR1VvUm5veUZq?=
 =?utf-8?B?ZUFUQWtvYU5HSEgrUDh4enh4TUs2elB1bXF6Q2t2dlZUaTBXRTI5UlZIQWZh?=
 =?utf-8?B?ZGQrSHgreWR6bGpvT1hRUSsrSDQ3Y2FOemlGNmtMZDJ4VnpVZGkvb0wyeWpy?=
 =?utf-8?B?Q1hVaGNnSTRIRXZWOUJEY3VHZGxFNERTd2d1bS9FZXBwZmEwdmt3WFFkb09a?=
 =?utf-8?B?QTZpZjM5QU1EdjJ1WmE2bUtIY0FrYVZNTmd5OTQzdzlaQ2tIUmsxRlNid2Mz?=
 =?utf-8?B?cnhYZ3NPb3ZxdW1VMFhuSjBwQkdIR3lPTm55eGU1U3pwYmFjRjJITXdqM1dT?=
 =?utf-8?B?R0NDbm1UdTNOYVpRWDhBRHlDUE1oZnNTbnpBWEJJWlVWYkhsUVFTVFdMSVBp?=
 =?utf-8?B?dWV0eHh6NXpYa1dpTVdKaFBscjgvR0ZzMi9LenViTC9qOS9SWUozaXlaNjR3?=
 =?utf-8?B?VWo1ZGJqRzBYSmNoNDY5L3BreFQ2aXF2dThBaXFsT2RIM0xpNnoyQS9JTGRv?=
 =?utf-8?B?emFMNEkrK2lkMnBTdmc1ZWpiVmIxd09hbUFjeUZ2NkYvV3poRDE2VytvWmpH?=
 =?utf-8?B?anY5TjZSa3B1WWNaVzAra1ptZHZlWFdwQXgyYUZyTFNEVjZ6ZHEzOEcvREJw?=
 =?utf-8?B?eFkrODBobHpGbVpYcHJ6QWFqa0hqVm5kTVIwdHlHU2U1MHZHNS8vZjA1S3Ft?=
 =?utf-8?B?OFhWcmdDM1NKNUxxZGpOeEc1Q3AyMnJJOHZDV3lPa1Bycm55a2szQmNYWElG?=
 =?utf-8?B?OXpROUtZdjFJeDlMRnByWHQ0Rm9RakczL3d0anYwUFZ3bThGejZobHJNdnMw?=
 =?utf-8?B?MG9vZjU4NWdBTkh4cklaOFdVaVg1MG1zOHVmOWExYzJmbklid2ZkNTlXUThT?=
 =?utf-8?B?dG1JSlJJZFFYbG5uRENuY29wejlhMWRLMkNJajN4dUt5bDhGMEVvcVBqT3Zk?=
 =?utf-8?B?ekIxZ3ZwWWpIK2JOdCt3VjQ3bUdSeEx0a3FzckhLeUs2VGs0SkVTcHh4NEUy?=
 =?utf-8?B?M3cwS2orSTRXR1cxZG9WQURpenRBMTZtRUp5SWQvVkI3akI2eTZYUExOVytz?=
 =?utf-8?B?QXNUNEc4VEN3ZVhTaW00eTBnV1kvcTR0MmU4eC9FNTJBeEp3YjVkUFFCS2xp?=
 =?utf-8?B?ZzhPc0w1d0tLVllJMGQwZ3Q0bmdTVTgrQXVqQ0JYblh5ZURlSVA0b3ZyU243?=
 =?utf-8?B?NEUrMW02VVFNWmh1WkloTmRWdXYwZjVhekJvT1M1ZFpQdjBsRzdoSGIzaGVj?=
 =?utf-8?B?MEtLeDVMclVEUXFpWG1QZ0tWODJFZTJCQit3TzRFMkM2dk5CWEk2OHBKQlds?=
 =?utf-8?B?cElvbnRDWmJudXo5bXZIZXF1THZOSmxnN1A0bkwxMkdMQlFJVm0zUHdXZ29Y?=
 =?utf-8?B?THpnUHNHMXgrVUMweTdmTk91R3V2RWQ1VVByOVMxblc0VDhNUERDMnJ3VERW?=
 =?utf-8?B?T3BxOTdTa1phNkNMRXFCZEFjMnlPZ3k3S3ljR2ZQVGVLVFVWTUdPemtPUXlk?=
 =?utf-8?Q?T2ADFX3jpzqMyM1RhaKFezkIt?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f285c9-54d6-454a-3819-08dddb3ed124
X-MS-Exchange-CrossTenant-AuthSource: GVXPR04MB9927.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 14:28:20.0947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z49azKsCxmd1fBWiDEgtXEPsWhIa2jdADEFTU611qdCFEjFQomll7EK13HqGgyxdWAwpZutPO4/mtEsu23OH1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7509



On 13/08/2025 4:33, Yu Kuai wrote:
> Hi,
> 
> 在 2025/08/12 21:08, Meir Elisha 写道:
>> A journal device failure can lead to parity corruption and silent data
>> loss in degraded arrays. This occurs because the current
>> implementation continues to update the parity even when journal
>> writes fail.
>>
>> Fixed this by:
>> 1. In ops_run_io(), check if journal writes failed before proceeding
>>     with disk writes. Abort write operations when journal is faulty.
>> 2. In handle_failed_stripe(), clear all R5_Want* flags to ensure
>>     clean state for stripe retry after journal failure.
>> 3. In handle_stripe(), correctly identify write operations that must
>>     be failed when journal is unavailable.
>>
>> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
>> ---
>>
>> When log_stripe() fails in ops_run_io() we keep write to the parity
>> disk causing parity to get updated as if the write succeeded.
>> shouldn't we fail if the journal is down? am I missing something here?
>> Thanks in advance for reviewing.
>>
>> Wrote a script for showcasing the issue.
>>
>> #!/bin/bash
>>
>> set -e
>>
>> RAID_DEV="/dev/md127"
>> DATA_OFFSET=32
>>
>> # Arrays to store disk states
>> declare -a BEFORE_BYTES
>> declare -a DISK_NAMES
>>
>> cleanup() {
>>      mdadm --stop $RAID_DEV 2>/dev/null || true
>>      dmsetup remove disk0-flakey disk1-flakey journal-flakey 2>/dev/null || true
>>      for i in {10..15}; do
>>          losetup -d /dev/loop$i 2>/dev/null || true
>>      done
>>      rm -f /tmp/disk*.img 2>/dev/null || true
>> }
>>
>> # Function to read first byte from device at offset
>> read_first_byte() {
>>      local device=$1
>>      local offset=$2
>>      dd if=$device bs=32k skip=$offset count=4 iflag=direct status=none | head -c 1 | xxd -p
>> }
>>
>> # Function to calculate which disk holds parity for a given stripe
>> # RAID5 left-symmetric algorithm (default)
>> get_parity_disk() {
>>      local stripe_num=$1
>>      local n_disks=$2
>>      local pd_idx=$((($n_disks - 1) - ($stripe_num % $n_disks)))
>>      echo $pd_idx
>> }
>>
>> cleanup
>> echo "=== RAID5 Parity Bug Test ==="
>> echo
>>
>> # Create backing files
>> for i in {0..5}; do
>>      dd if=/dev/zero of=/tmp/disk$i.img bs=1M count=100 status=none
>>      losetup /dev/loop$((10+i)) /tmp/disk$i.img
>> done
>>
>> SIZE=$(blockdev --getsz /dev/loop10)
>>
>> # Create normal linear targets first
>> dmsetup create disk0-flakey --table "0 $SIZE linear /dev/loop10 0"
>> dmsetup create disk1-flakey --table "0 $SIZE linear /dev/loop11 0"
>> dmsetup create journal-flakey --table "0 $SIZE linear /dev/loop15 0"
>>
>> # Create RAID5 using the dm devices
>> echo "1. Creating RAID5 array..."
>> mdadm --create $RAID_DEV --chunk=32K --level=5 --raid-devices=5 \
>>      /dev/mapper/disk0-flakey \
>>      /dev/mapper/disk1-flakey \
>>      /dev/loop12 /dev/loop13 /dev/loop14 \
>>      --write-journal /dev/mapper/journal-flakey \
>>      --assume-clean --force
>>
>> echo "write-through" > /sys/block/md127/md/journal_mode
>> echo 0 > /sys/block/md127/md/safe_mode_delay
>>
>> # Write test pattern
>> echo "2. Writing test pattern..."
>> for i in 0 1 2 3; do
>>      VAL=$((1 << i))
>>      echo "VAL:$VAL"
>>      perl -e "print chr($VAL) x 32768" | dd of=$RAID_DEV bs=32k count=1 seek=$i oflag=direct status=none
>> done
>> sync
>> sleep 1  # Give time for writes to settle
>>
>> echo "3. Reading disk states before failure..."
>>
>> # Calculate parity disk for stripe 0 (first 32k chunk)
>> STRIPE_NUM=0
>> N_DISKS=5
>> PARITY_INDEX=$(get_parity_disk $STRIPE_NUM $N_DISKS)
>> echo "Calculated parity disk index for stripe $STRIPE_NUM: $PARITY_INDEX"
>>
>> # Map RAID device index to loop device
>> PARITY_DISK=$((10 + $PARITY_INDEX))
>> echo "Parity is on loop$PARITY_DISK"
>> echo
>>
>> for i in {10..14}; do
>>      # Read first byte from device
>>      BYTE=$(read_first_byte /dev/loop$i $DATA_OFFSET)
>>      BEFORE_BYTES[$i]=$BYTE
>>      DISK_NAMES[$i]="loop$i"
>>           echo -n "loop$i: 0x$BYTE"
>>      if [ "$i" = "$PARITY_DISK" ]; then
>>          echo " <-- PARITY disk"
>>      else
>>          echo
>>      fi
>> done
>>
>> echo
>> echo "4. Fail the first disk..."
>>
>> dmsetup suspend disk0-flakey
>> dmsetup reload disk0-flakey --table "0 $SIZE flakey /dev/loop10 0 0 4294967295 2 error_reads error_writes"
>> dmsetup resume disk0-flakey
>>
>> perl -e "print chr(4) x 32768" | dd of=$RAID_DEV bs=32k count=1 seek=2 oflag=direct status=none
>> sync
>> sleep 1
>>
>> dmsetup suspend journal-flakey
>> dmsetup reload journal-flakey --table "0 $SIZE flakey /dev/loop15 0 0 4294967295 2 error_reads error_writes"
>> dmsetup resume journal-flakey
>>
>> dmsetup suspend disk1-flakey
>> dmsetup reload disk1-flakey --table "0 $SIZE flakey /dev/loop11 0 0 4294967295 2 error_reads error_writes"
>> dmsetup resume disk1-flakey
>>
>> echo "5. Attempting write (should fail the 2nd disk and the journal)..."
>> dd if=/dev/zero of=$RAID_DEV bs=32k count=1 seek=0 oflag=direct 2>&1 || echo "Write failed (expected)"
>> sync
>> sleep 1
>>
>> echo
>> echo "6. Checking if parity was incorrectly updated:"
>> CHANGED=0
>> for i in {10..14}; do
>>      # Read current state from device
>>      BYTE_AFTER=$(read_first_byte /dev/loop$i $DATA_OFFSET)
>>      BYTE_BEFORE=${BEFORE_BYTES[$i]}
>>
>>      if [ "$BYTE_BEFORE" != "$BYTE_AFTER" ]; then
>>          echo "*** loop$i CHANGED: 0x$BYTE_BEFORE -> 0x$BYTE_AFTER ***"
>>          CHANGED=$((CHANGED + 1))
>>
>>          if [ "$i" = "$PARITY_DISK" ]; then
>>              echo "  ^^ PARITY WAS UPDATED - BUG DETECTED!"
>>          fi
>>      else
>>          echo "loop$i unchanged: 0x$BYTE_BEFORE"
>>      fi
>> done
>>
>> echo
>> echo "RESULT:"
>> if [ $CHANGED -gt 0 ]; then
>>      echo "*** BUG DETECTED: $CHANGED disk(s) changed despite journal failure ***"
>> else
>>      echo "✓ GOOD: No disks changed
>> fi
>>
>> cleanup
>>
>>   drivers/md/raid5.c | 28 +++++++++++++++++++++++-----
>>   1 file changed, 23 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 023649fe2476..856dd3f0907f 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -1146,8 +1146,25 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>>         might_sleep();
>>   -    if (log_stripe(sh, s) == 0)
>> +    if (log_stripe(sh, s) == 0) {
>> +        /* Successfully logged to journal */
>>           return;
>> +    }
>> +
>> +    if (conf->log && r5l_log_disk_error(conf)) {
>> +        /*
>> +         * Journal device failed. We must not proceed with writes
>> +         * to prevent a write hole.
>> +         * The RAID write hole occurs when parity is updated
>> +         * without successfully updating all data blocks.
>> +         * If the journal write fails, we must abort the entire
>> +         * stripe operation to maintain consistency.
>> +         */
>> +        if (s->to_write || s->written) {
>> +            set_bit(STRIPE_HANDLE, &sh->state);
>> +            return;
>> +        }
> 
> I think this is too radical to fail all the writes to the array, even if
> log disk failed, everything will be fine without a power failure that
> should be unlikely to happen.
> 
> And it's right, if power failure do happened, data atomicity can't be
> guaranteed, however, please notice that we will still make sure data
> is consistent, by resync based on bitmap or full array resync if bitmap
> is none.
> 
> I think, if log disk is down, let's keep this behavior for user to still
> using this array, user should aware that data atomicity is no longer
> guaranteed. If you really want to stop writing such array to make sure
> data atomicity after power failure, I can accept a switch to enable this
> behaviour manually.
> 
> Thanks,
> Kuai
> 
Hi Kuai
Thanks for reviewing. I want to reiterate the scenario I've tested.
Got a RAID5 (4 disks + 1 parity) and a journal(consistency policy=journal).
Starting by failing one of the disks so the array becomes degraded.
then, I failing the 2nd disk and the journal at the same time (using dm-flakey)
when I initiate the write.
While examine the parity disk I've noticed that the parity got calculated as
if the write succeeded. this is shown by the reproduce script above.
Not sure I understands your comment on resync since we are in journal policy.
if parity is invalid how can we guarantee data will be valid?
Appreciate you response. 

>> +    }
>>         should_defer = conf->batch_bio_dispatch && conf->group_cnt;
>>   @@ -3672,6 +3689,10 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>>            * still be locked - so just clear all R5_LOCKED flags
>>            */
>>           clear_bit(R5_LOCKED, &sh->dev[i].flags);
>> +        clear_bit(R5_Wantwrite, &sh->dev[i].flags);
>> +        clear_bit(R5_Wantcompute, &sh->dev[i].flags);
>> +        clear_bit(R5_WantFUA, &sh->dev[i].flags);
>> +        clear_bit(R5_Wantdrain, &sh->dev[i].flags);
>>       }
>>       s->to_write = 0;
>>       s->written = 0;
>> @@ -4966,12 +4987,9 @@ static void handle_stripe(struct stripe_head *sh)
>>       /*
>>        * check if the array has lost more than max_degraded devices and,
>>        * if so, some requests might need to be failed.
>> -     *
>> -     * When journal device failed (log_failed), we will only process
>> -     * the stripe if there is data need write to raid disks
>>        */
>>       if (s.failed > conf->max_degraded ||
>> -        (s.log_failed && s.injournal == 0)) {
>> +        (s.log_failed && (s.to_write || s.written || s.syncing))) {
>>           sh->check_state = 0;
>>           sh->reconstruct_state = 0;
>>           break_stripe_batch_list(sh, 0);
>>
> 
I think the changes in handle_stripe() are wrong here.

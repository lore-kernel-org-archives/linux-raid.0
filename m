Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023118.outbound.protection.outlook.com [52.101.83.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666E3299924
	for <linux-raid@vger.kernel.org>; Mon, 25 Aug 2025 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756138151; cv=fail; b=Qq/Ozf5KUKEQwy3+XxlEicx4gZw/1509RIDMqaZZ5kwLLk/8AIeCQjCPdiAXpyovDTCV5LSLRfl9BoAdQuF9G8fJ7ibi8k327WDYj4tOLRBgLimdhq9UDkiKiKVo0/998AI14TCGMH6ITreeRhMX0oFCHynVlhM/UEdI8keTqYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756138151; c=relaxed/simple;
	bh=F/XnjJ8x1RB6m+wPu5jj7ADuvOFccMvunIpXnayXfEo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XFPEJBC+/vk8Gcohuj5peo1Ng1M8KlD6eTDqg8FnXKH5qg46IWtGOiMqV9CmsUjVul/iyLUmV4IEtngGYU5UZHRdfizSBltuEi/lqUVK3uEel+doYf42TD9aFBSBAhJKTjmfzW7zvMo5QJrfycQLuaTq40T0Oc2UTmKDZ1KRdsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=ZiyzDgAJ; arc=fail smtp.client-ip=52.101.83.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="ZiyzDgAJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jyQwTUht8UVXVPFmLl0iV5ffOkNrR2sOSWu20YBmjhoiz5Z4r7PWgdRrMCzgmv1TOiRTvPt6rv8wl3wpkiiZxgyTVlxaDOrwdHjfyDFyxBS3WpVTbxQ3zeQivMliJrjv/W5gypzCjAHCeZuj1FLs4vlFgkRflCepo7usPYRWdKolnm8koN6roOJlSNg1QM2stjghvz8rFJ24atqEDpJsTJQbAumm42ce5lta6PefqShlza4Yd4V73r/4kLJkYSTddzBykmjEXIvojv+iifAdn0bMbtf6JWa5t9Kt96WNe9HLSSzOsFWs0YoLq20RY8OvnNUN+xlZ/VjnJIyY/P1bpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mYlqObNkQ2R74dzpb5Ge8qdRLJFxr8wW2VRas3lEpzY=;
 b=PbGMniAmotSmWaDpNodGq51iKYrgkUwsaLIV464QXENR+VKY3GPMV36EbWm/Fi0EH4mGpmANZm9INONTQa8xdWfmis1geW4b7PnSqHgEXhCdaeI3KsRceslRsSe6lf7Q/nSA85iB6Cb7+sNYv7RTpVNiitxsUM5tKmeYloCFOy6/7ZC1tJsXdqRXDZAFx2o3IWzdtKtCOpbVLj/NTLF8CTMgUWVqG8cVhbl5y255sBZolIbP9TkRV5dv7MALV5fhJaYsqcRj3632OlTQ3grypkh4X5HV19nTTCrWuEav7/62bs/3s6AFwmg5j3vFxWwQrG8O0SSSNEyiO0tC+XAmaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYlqObNkQ2R74dzpb5Ge8qdRLJFxr8wW2VRas3lEpzY=;
 b=ZiyzDgAJ5XOftZND3q1lStcSezlg1gynLkhG/ZNkHgBHrYz0zUaMLLyPi/T/P2TS/TJoiib9CK4TX8eArvEtyh1gCTVJsjg6wrqK2VeSO1Z4wsNTJSKj1hKXDu15+0PeqVF6iCgjvWW5Q10yDyZzLNM5W55KRcZqaKyH1RuiGPHLPZQOi7bNJ5/xx2g+wOQf555swu01pUuCYzl7COsBZXX64xqnAa6Lk9MB70xqvJgeVlE3ucDeA6xkDTmV9dvYV3CyBEIGQhz+TAxmT6WRtQCfZ7FqI7jR51cyaFBbyBwGTWUUkTgBmR8Cjcjyn0EuPS7smxsN3ZcLHeLwVkSeaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
 by GVXPR04MB10272.eurprd04.prod.outlook.com (2603:10a6:150:1bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.10; Mon, 25 Aug
 2025 16:09:03 +0000
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8]) by GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8%5]) with mapi id 15.20.9073.010; Mon, 25 Aug 2025
 16:09:02 +0000
Message-ID: <a8f680b2-eef0-4fc6-898f-e1fc2fe54599@volumez.com>
Date: Mon, 25 Aug 2025 19:08:58 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] md/raid5: fix parity corruption on journal failure
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org
References: <20250819073806.1501782-1-meir.elisha@volumez.com>
Content-Language: en-US
From: Meir Elisha <meir.elisha@volumez.com>
In-Reply-To: <20250819073806.1501782-1-meir.elisha@volumez.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::11) To GVXPR04MB9927.eurprd04.prod.outlook.com
 (2603:10a6:150:118::22)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR04MB9927:EE_|GVXPR04MB10272:EE_
X-MS-Office365-Filtering-Correlation-Id: 641d9a95-7f73-4fa7-05aa-08dde3f1b558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bzdZd0U4NHJzdng0QjU3VDBINStnOUFWYkYvaS9GVWJrMGtrYjNjWUJIYXps?=
 =?utf-8?B?NjJEVUxZWTlJMmdUWkNxT213bHdPMGJxUHhJaTFnYTBwa2lEazhjT1JINlJW?=
 =?utf-8?B?VjhZN0xNcktGTC9seTU0MlhTUGlKeHB3NS9mKy9wRXIwdWhSYnNGOTNMOVN1?=
 =?utf-8?B?VDBNcG5PaDBaU0ozUWYxSlZRUldDZFJicEZqdXNBN0wrbWVOSHNUdVl2cVpS?=
 =?utf-8?B?YUFFd2loTEg2MTJVSTh3d2UwZWJaL1l4Zk9qMDMxeGdFa25kOEViWGcydU9z?=
 =?utf-8?B?U1VLc2M2blNnQ1FGRFhtSXJiVUhKMlUzaWcyK3NNNHloUEphS3dZZDZ3Wmdq?=
 =?utf-8?B?TDlMYnBQMUN6ZVZaalM0Z3hRSmhVQ2Q0ZENyaW9Yd1BEY25PS25YdVdnQmdt?=
 =?utf-8?B?dXZua0JpNElkQkI5cVdyZ1Z0V1FPNEEyOFpUUm8zK3FsRnlnWHJ5N2FzY3dX?=
 =?utf-8?B?c2MrMDBSM0NPYVgrY2tvTE5CYktFYkFyNHYwMEpPZDlMQ2VEUWM5Q1grMjFM?=
 =?utf-8?B?eVVtaWs0cVpLN1UraTdBOHZwaHhPQndBSW5TNFFKeXZjNXRHc3RIamYxazBi?=
 =?utf-8?B?TkFRRGJuWnNuUW96YWd4cGF3TExCRk5oNzZrd2I0Z3NHSVh3YkU3cGVsSVFM?=
 =?utf-8?B?VzIrdUlLTjF6SW5ONHVudnVjNDZ5QTlERTVrazNuc0dZaFU4aDFHWEI4NCtw?=
 =?utf-8?B?djFDQ3l0RXUycG9mVU9ncitkWDBPak5RZEVjS200NXFjR1dIQ1FzR2ZzRDVS?=
 =?utf-8?B?d3ZnQUdvdXFrTDRzeGlCN0pnQmFuRHJ2UXF2TVFQTGNuS01aQ3M3YlNBR0lz?=
 =?utf-8?B?UDFMMnFPaUVVYi9BUGliQW1jaUttejdwUE5pKzczQXZTRngrbEY2MUIrTUxv?=
 =?utf-8?B?MDRUQm94RGsyTXBuQlYxZERTMU5CbWc4bnMza0RNWFkxYWkvN0JhTkNIZ3Fa?=
 =?utf-8?B?QmN0bGxQQmZIYzF5MEx1QzI4S1d4YVd0NVB1M09iaUtDVXJlVHhTMVQwWlVR?=
 =?utf-8?B?eVdQTjcrdXZvdEY5TTk2STNTS3VtZCtUcjhnU3ZLNzNBZ3dXY0QvL1ZrSGJr?=
 =?utf-8?B?OGc1ZG5XaFRZcG4vSmd3bzRERS8ybnBNQVY3Lzh2VXI5Q05OQ1BRNkVjZnJ3?=
 =?utf-8?B?ZEtOTnJYVDVpRm0reFl6dVNQS1UzRS9rcUtMczFUU0pvb0FOa1Z6dy9Da3dF?=
 =?utf-8?B?Vjd5RHRwTHpNbGoyRXlJVXpHR1RiZFBLZi91eGhZSVhNcnZVK3F4Snp1dnZ6?=
 =?utf-8?B?TG1PdDNVMWFFcUlQOWJsN3VsRGZhdW9EVnlnV2FvK216T1VzZ3JDS1BaTi9z?=
 =?utf-8?B?MHhxNHlrYXovNEVXVy9LMG96bFRyTmFCbVBJeHhBN1BlcHp0NGpSVEpSK0p3?=
 =?utf-8?B?K0paeXBqbFRwYm9wdXc4R1ZiZmVJSERHYWJVSllJdU9xa3lndmdXQXhsYzJO?=
 =?utf-8?B?SXQ3RGlwQklMQlcyaXRhb0tkbzVmYkwvWi9EQ01ieWtYTmU4WFlBV0lIMUE2?=
 =?utf-8?B?SzJXcEJBbnhlTi9kQ2thZGwwVVV4OWliai91emw1WDFWTmlJZGFCYS9sUHF5?=
 =?utf-8?B?UUFYTm0xenowenJmd2dMMUpOYUVhckcyaXQ5UjJ3czErWnNsWjJaZWlVQmx2?=
 =?utf-8?B?Sk00Q0c2RmtDT0Q1V09DUWdUWjF4NGllYVkzdkNEeElya3hkRUwzajVaVXZh?=
 =?utf-8?B?QWV0R2VnalRWS25sSjBTZG1wZzk1dG1ZNUZJRXJaZnRmVi9iZkt3K29YNUN6?=
 =?utf-8?B?YTU2K0l6WmlZUC9lclgzRXJ6ckVjbk5ibXBIcmRnYmVnMHQzcm5yL2xISGM5?=
 =?utf-8?B?NFB2SjNEbnFneGhzYzNwTkdBWlVyQlcwM0RRNDdCNWYxUUMxNGtHc2JRRWF1?=
 =?utf-8?B?T01zdk9hZkFCRHRxTGF4RTRja1dNNDBXREhzRmpHTWJWYWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB9927.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUVQdGNXUllONzU3djBIRE5pb3dPZFh1Tm1teWdPM2pjRlhoUWNpMFJRNUFa?=
 =?utf-8?B?UCtzditUMi9Zc2FVNVJndmxKTFVORkhMVkhDUlljN2I5R3ErR1p4aVF0SWJK?=
 =?utf-8?B?YmdndjE5SWRacFVEMUJHU0RxSk9SMHNBVzVQck5iOTdxSldONUwzVnBXQ21m?=
 =?utf-8?B?TC9CVVlCNVBrSW1peTdBNTlyZWlMNThHL3AyVnRONjhUT3R3ZE5adlZpZ09H?=
 =?utf-8?B?Rm45emM5SHFzWUlGQXAveklWakRBYVhWdjRmVmp0UHdVMzNsN0VWZk1ZbnZP?=
 =?utf-8?B?SVBOclpQSXdPVUp1SDZGa3picTVrVmhDdGZ5cGczM0JpdEFDV1dsaDV3Uzk0?=
 =?utf-8?B?bk9Mb20wUEJSMXdvUkdyNHgzU091ZDdxUk9weVdFWWFkUHZRTHVIY3VaYjlB?=
 =?utf-8?B?Qk9ueHJpRmtGZlJ0ZHJLUmJOMWJjMkhHZlZPOFFhQytqTWVzTVFRdkNSZWhv?=
 =?utf-8?B?WHZSSlYvbTJJenlwMDZUb3g4Yk83WXBWU1MvWmtQQ2xDUEppRTlydzI1OHhZ?=
 =?utf-8?B?N001cWZJU1A5VW1veFdlcUwxKzBsaWtLMUJVRENFSWZCQ2ZxQ0VUOUR1bGxK?=
 =?utf-8?B?Unp2bFk2N2ZpRi9VRHFDMTdGVmdqMFIrTnlWcVJsaThhb1dBbE5jVUYzb0tv?=
 =?utf-8?B?V3Z1RDBIbnBNY20xaGJBbWRQWitQMC9paFE5ZjJ6blBaWVBZb01sL1hXSkVJ?=
 =?utf-8?B?YlVlL1dRRERQV0krYjJDSjBnNGdKMHVxZk4vRnJ1dGI4TGFSdlUwM1NtV2dH?=
 =?utf-8?B?Vlo4ank5akNZeWNDeHM3RWJ5U0pzNC9lSS9NN1htazllZjRHZXc5a1dHRHZv?=
 =?utf-8?B?QUxKeElncjVvQnRWeTdyMUhtMjhYS0VQZ2FqQ0tkblRqdDZYcmRFU01lRzFP?=
 =?utf-8?B?R09CZW1OUmpSRzNiNnk1RUlxWDBYQlFCclNNcVJuWktGVnNQdFp5Y3cxcnVy?=
 =?utf-8?B?Mk9FOWFiaDJLKzI2NGp1MmdkV0F3c1V2ZFFkeUlxc1ZmcUFsNWd6dmphZGVO?=
 =?utf-8?B?QUtDck5NMm5BK2MwVGVyTGQ2ZHpJQW5CVGtkVDBObzNRQS80cUlMMFRURHZN?=
 =?utf-8?B?Uy9EVEtoMzVGWkFORVVpR09SVUk2QW1SQUJySVlNbjByQVQ5NG5LSWMzSkxX?=
 =?utf-8?B?Ky9GQnMrVFhqdXpqb2hMTmlNeTEzZGthTzVMWE9lOCtrR1NzYlEyc2JHVkY3?=
 =?utf-8?B?QmIyM0dwcmdCRzFiTmQ0dXplclp3WW5jOHVCaFB5bFJsL1dmVzZFZUFkeW9t?=
 =?utf-8?B?WTIreVVTcjZmaERvd0l5UzZSS25rblA2TFI3c1BGZWpmZDV3RzVobFgyZ0gy?=
 =?utf-8?B?WHpudTZOUmhJZ0loMG9YOEdiRDk2dzV4c2xLdjIyQ2lwbC9heHllNksyaW9J?=
 =?utf-8?B?R2dzRllBNU85bzk1RzB6eFFuZUd4NldPTjBaOUFHTnEwNUZocE5KSG10WWEr?=
 =?utf-8?B?QXhEZStCUGhuL0J4ckR2SDFjM3U4YTJSWU1TWUZ6cVMvZEFuWWp2alBRaEtp?=
 =?utf-8?B?bFozNlRHbUtTQlZXVUlPZzFtWlA0bVJobzVsNnJVL1E1RmcwaG40OXVYOXh2?=
 =?utf-8?B?clljaVJ6Sm5jSGFaSjMvQmErL09FY005Y3ZLblorOGFyNWhoakZjVG1KZEFS?=
 =?utf-8?B?YVJtYTB2ZG14dmJKaTdESTdpTlREUjRFRE8vbjl6N253R0RNS0E1ZnRPVjVW?=
 =?utf-8?B?REJKb3pOMkkvVllMdFZ0WXdPY3E0bk1XTUk3SVQ5SFZ6bHFCaU4xczFERUYv?=
 =?utf-8?B?M2FLMEpjRlhJODh5L25wb2d0bnNXOXlqUDJGL00yVGJDYTdoc0FJMTZuTVFJ?=
 =?utf-8?B?Z3pxOUYxYW8vU0Jya0NBZXNrcmF4VENmR09ldXc4MGpjbnZWS1IrN3pSeHNT?=
 =?utf-8?B?cjhITGFZQ0tvdmdSSEZDRVQ4RklyVWorWGVvemM0d0xjc0dvK2E4NmZGVjU2?=
 =?utf-8?B?L2YwYnJGUlNJUG1SR3lTNnJIU0EwTWRWem5SMVpiMGQ4N0hQSFBsNHUwRjZK?=
 =?utf-8?B?QWZNVkR3L2RLU0hLcytvRWszQmo4MVVuZ2VPZHpRMk45UkY4YnJzTHBRY1RE?=
 =?utf-8?B?bVljaE9SdHRVK2xweHRjSUVFR01vVVY5T203eTczZkdZczQxb0pMV2JyUVpy?=
 =?utf-8?B?Mk9lb3BXZStCRXhQZjZ0dGZtUjZSZGZ6anU1YkpuQ3U2ZE01MjNzT2ZxcjIr?=
 =?utf-8?B?dWc9PQ==?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 641d9a95-7f73-4fa7-05aa-08dde3f1b558
X-MS-Exchange-CrossTenant-AuthSource: GVXPR04MB9927.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 16:09:02.8049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GLazkCQ/3N0xsgxNRl1mSEL1CEst6K6sf8T+HWgBOpR1M0mAg5pPOgo8MtPp4q8fUeTDJkBQAa/SbROj6KUldw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB10272

Hi Kuai

Appreciate your thoughts on V3. Thanks in advance. 
On 8/19/25 10:38, Meir Elisha wrote:
> When operating in write-through journal mode, a journal device failure
> can lead to parity corruption and silent data loss.
> This occurs because the current implementation continues to update
> parity even when journal writes fail, violating the write-through
> consistency guarantee.
> 
> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
> ---
> Changes in v3:
> 	- Remove unnecessary braces in ops_run_io()
> 	- Adding comment on clearing the R5_Want* flags
> Changes in v2:
> 	- Drop writes only when s->failed > conf->max_degraded
> 	- Remove changes in handle_stripe() 
> 
> Wrote a script for showcasing the issue.
> 
> #!/bin/bash
> 
> set -e
> 
> RAID_DEV="/dev/md127"
> DATA_OFFSET=32
> 
> # Arrays to store disk states
> declare -a BEFORE_BYTES
> declare -a DISK_NAMES
> 
> cleanup() {
>        mdadm --stop $RAID_DEV 2>/dev/null || true
>        dmsetup remove disk0-flakey disk1-flakey journal-flakey 2>/dev/null || true
>        for i in {10..15}; do
>            losetup -d /dev/loop$i 2>/dev/null || true
>        done
>        rm -f /tmp/disk*.img 2>/dev/null || true
> }
> 
> # Function to read first byte from device at offset
> read_first_byte() {
>        local device=$1
>        local offset=$2
>        dd if=$device bs=32k skip=$offset count=4 iflag=direct status=none | head -c 1 | xxd -p
> }
> 
> # Function to calculate which disk holds parity for a given stripe
> # RAID5 left-symmetric algorithm (default)
> get_parity_disk() {
>        local stripe_num=$1
>        local n_disks=$2
>        local pd_idx=$((($n_disks - 1) - ($stripe_num % $n_disks)))
>        echo $pd_idx
> }
> 
> cleanup
> echo "=== RAID5 Parity Bug Test ==="
> echo
> 
> # Create backing files
> for i in {0..5}; do
>        dd if=/dev/zero of=/tmp/disk$i.img bs=1M count=100 status=none
>        losetup /dev/loop$((10+i)) /tmp/disk$i.img
> done
> 
> SIZE=$(blockdev --getsz /dev/loop10)
> 
> # Create normal linear targets first
> dmsetup create disk0-flakey --table "0 $SIZE linear /dev/loop10 0"
> dmsetup create disk1-flakey --table "0 $SIZE linear /dev/loop11 0"
> dmsetup create journal-flakey --table "0 $SIZE linear /dev/loop15 0"
> 
> # Create RAID5 using the dm devices
> echo "1. Creating RAID5 array..."
> mdadm --create $RAID_DEV --chunk=32K --level=5 --raid-devices=5 \
>        /dev/mapper/disk0-flakey \
>        /dev/mapper/disk1-flakey \
>        /dev/loop12 /dev/loop13 /dev/loop14 \
>        --write-journal /dev/mapper/journal-flakey \
>        --assume-clean --force
> 
> echo "write-through" > /sys/block/md127/md/journal_mode
> echo 0 > /sys/block/md127/md/safe_mode_delay
> 
> # Write test pattern
> echo "2. Writing test pattern..."
> for i in 0 1 2 3; do
>        VAL=$((1 << i))
>        echo "VAL:$VAL"
>        perl -e "print chr($VAL) x 32768" | dd of=$RAID_DEV bs=32k count=1 seek=$i oflag=direct status=none
> done
> sync
> sleep 1  # Give time for writes to settle
> 
> echo "3. Reading disk states before failure..."
> 
> # Calculate parity disk for stripe 0 (first 32k chunk)
> STRIPE_NUM=0
> N_DISKS=5
> PARITY_INDEX=$(get_parity_disk $STRIPE_NUM $N_DISKS)
> echo "Calculated parity disk index for stripe $STRIPE_NUM: $PARITY_INDEX"
> 
> # Map RAID device index to loop device
> PARITY_DISK=$((10 + $PARITY_INDEX))
> echo "Parity is on loop$PARITY_DISK"
> echo
> 
> for i in {10..14}; do
>        # Read first byte from device
>        BYTE=$(read_first_byte /dev/loop$i $DATA_OFFSET)
>        BEFORE_BYTES[$i]=$BYTE
>        DISK_NAMES[$i]="loop$i"
>             echo -n "loop$i: 0x$BYTE"
>        if [ "$i" = "$PARITY_DISK" ]; then
>            echo " <-- PARITY disk"
>        else
>            echo
>        fi
> done
> 
> echo
> echo "4. Fail the first disk..."
> 
> dmsetup suspend disk0-flakey
> dmsetup reload disk0-flakey --table "0 $SIZE flakey /dev/loop10 0 0 4294967295 2 error_reads error_writes"
> dmsetup resume disk0-flakey
> 
> perl -e "print chr(4) x 32768" | dd of=$RAID_DEV bs=32k count=1 seek=2 oflag=direct status=none
> sync
> sleep 1
> 
> dmsetup suspend journal-flakey
> dmsetup reload journal-flakey --table "0 $SIZE flakey /dev/loop15 0 0 4294967295 2 error_reads error_writes"
> dmsetup resume journal-flakey
> 
> dmsetup suspend disk1-flakey
> dmsetup reload disk1-flakey --table "0 $SIZE flakey /dev/loop11 0 0 4294967295 2 error_reads error_writes"
> dmsetup resume disk1-flakey
> 
> echo "5. Attempting write (should fail the 2nd disk and the journal)..."
> dd if=/dev/zero of=$RAID_DEV bs=32k count=1 seek=0 oflag=direct 2>&1 || echo "Write failed (expected)"
> sync
> sleep 1
> 
> echo
> echo "6. Checking if parity was incorrectly updated:"
> CHANGED=0
> for i in {10..14}; do
>        # Read current state from device
>        BYTE_AFTER=$(read_first_byte /dev/loop$i $DATA_OFFSET)
>        BYTE_BEFORE=${BEFORE_BYTES[$i]}
> 
>        if [ "$BYTE_BEFORE" != "$BYTE_AFTER" ]; then
>            echo "*** loop$i CHANGED: 0x$BYTE_BEFORE -> 0x$BYTE_AFTER ***"
>            CHANGED=$((CHANGED + 1))
> 
>            if [ "$i" = "$PARITY_DISK" ]; then
>                echo "  ^^ PARITY WAS UPDATED - BUG DETECTED!"
>            fi
>        else
>            echo "loop$i unchanged: 0x$BYTE_BEFORE"
>        fi
> done
> 
> echo
> echo "RESULT:"
> if [ $CHANGED -gt 0 ]; then
>        echo "*** BUG DETECTED: $CHANGED disk(s) changed despite journal failure ***"
> else
>        echo "✓ GOOD: No disks changed"
> fi
> 
> cleanup
> 
>  drivers/md/raid5.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 023649fe2476..da7756cc6a2a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1146,9 +1146,21 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>  
>  	might_sleep();
>  
> +	/* Successfully logged to journal */
>  	if (log_stripe(sh, s) == 0)
>  		return;
>  
> +	/*
> +	 * Journal device failed. Only abort writes if we have
> +	 * too many failed devices to maintain consistency.
> +	 */
> +	if (conf->log && r5l_log_disk_error(conf) &&
> +	    s->failed > conf->max_degraded &&
> +	    (s->to_write || s->written)) {
> +		set_bit(STRIPE_HANDLE, &sh->state);
> +		return;
> +	}
> +
>  	should_defer = conf->batch_bio_dispatch && conf->group_cnt;
>  
>  	for (i = disks; i--; ) {
> @@ -3672,6 +3684,13 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>  		 * still be locked - so just clear all R5_LOCKED flags
>  		 */
>  		clear_bit(R5_LOCKED, &sh->dev[i].flags);
> +		/* Clear R5_Want* flags to prevent stale operations
> +		 * from executing on retry.
> +		 */
> +		clear_bit(R5_Wantwrite, &sh->dev[i].flags);
> +		clear_bit(R5_Wantcompute, &sh->dev[i].flags);
> +		clear_bit(R5_WantFUA, &sh->dev[i].flags);
> +		clear_bit(R5_Wantdrain, &sh->dev[i].flags);
>  	}
>  	s->to_write = 0;
>  	s->written = 0;


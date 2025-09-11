Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021090.outbound.protection.outlook.com [52.101.65.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06EE31DDAE
	for <linux-raid@vger.kernel.org>; Thu, 11 Sep 2025 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757593361; cv=fail; b=Xi6RDRCWn4Qcg1nxaIuo0TpyFOrA4vZuq92tnFhFGhXfH5xy4P9/el9qRBoEFGvAswwaNM8VGUeWn66qHhQhbxqlknnrjx52OLo6/fX1ynUsyuKwufAW+kAPKtdCIYtnBGM6a/Ud+7+hNTRzJkSNM9X+Pw/rvU7Cc9WdEf6fI6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757593361; c=relaxed/simple;
	bh=PAZ1RXcelQZAI/mUYGVcH/ItpRtG6D4+NHbDVIUXoXE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=evYXYsrQZZRwVUgvndyEMGg37do6+FmHjHUOwzhksrn3569mrvqS9jAulBeiwrUIoKM6CaaeuKfWHnYa6ByUfvLiOfmC0wCMKm/UE6z0OEummfPfi3ShU6/Q5IZCxmnsPi8F3ToaRI5v60IPC1w/DokSA//3IS3F+THo9LPJBm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=VZvuvZyc; arc=fail smtp.client-ip=52.101.65.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="VZvuvZyc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hOBPZf3pPqbYnMaX2auVOBjN9XrZBrsSY6aRG8Pw1akdgh30pK2jHs+SF+VVXW3uXTWDGcuzrKKom4//uZJk1v30Tc/csqohfnGRpc9n9FUPpCn8xZY9AGLKi9jJ9UTJ9SHS3GNuA0D/G930zNiE3R9BunTXiKhCepFerpNlcLubcX4ULfEydJA5HfIqDJawQm6kvdWZMk74M367Q/rF0AgK0y6Yvp4l4kdg0RY0j0ywGC/S5EINWNSeyY/8ptfD+AfoIP8lBOpy48xyM2QmJpZj+dZSj5ztuqUTzMLP2Em5h5/s7dYOWoqRFLB/0pTWVwpGuMQs/7/uiq77+LjlVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pEU0oFoDX0SRjtnPSdubZ0gOABQxQt/lDdjB+RMQV2k=;
 b=hmJ4U6ydx4EeO/u+CAbcwolJtC+Fn6dT+7AG05ZsG2x6d8CkOk2O5HNSNrhyBtDOxNwJfeemX8xGaOaE7hkqEs91H9OCVJbsM0Hwbmtw4RY+m6ExGJ1+PeM2kJK3Mz8mjF0rKtYxy7VcgsCuAYtrcMdG/13Rnfc27oJ56IWIqfvcX0ZdTwlz0wH4FDdPQ4jnGWCVZqTwqJRkRPU1smi0SPaXjMa5f7IlWv90/AZBL1J2heHlox9VDqI4Y/5CbBmZvG2rLZwzPH/mlVTg9QY57xyMIlvXdYEZfsICXAj0xsNVbmSyO4JVOlEuEc2WcAKN27U5nNGmoU80X7E7rDBHuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEU0oFoDX0SRjtnPSdubZ0gOABQxQt/lDdjB+RMQV2k=;
 b=VZvuvZycpw9t9FcBBmPe/e7wF8kQhcpSfChTrBAW/h3l88v8WWLaPKwRvSttzWS5pZX5g/Z8xhf0UgLMj9SId2VoYT7DZcHOT2q6+kCmGl5/V1QUjXolEgn4cnY0xNSh8tP5ejBuxJquTAoAbFEIKDXMEfCZG3seMB3JdKTG2q+LRD3GYAlBoaF2BqnbjJDeUZywpevskERrXHQNotTLVUuOkXAzKVQ1CdiPlp8+cL9raM8IaBhXw1lq3UJJbGizOi0Dx8dNR0pNcpMU2KZwhwLUm9scFTKEjihfc/psKJpn7Cns9l0iAkTTDVfX35ekcwu9vswyZgmUlSU1MtvkAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
 by PAXPR04MB9398.eurprd04.prod.outlook.com (2603:10a6:102:2b4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.15; Thu, 11 Sep
 2025 12:22:34 +0000
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8]) by GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8%6]) with mapi id 15.20.9115.015; Thu, 11 Sep 2025
 12:22:34 +0000
Message-ID: <b77b3cc8-f068-420e-9c97-399d756d6aee@volumez.com>
Date: Thu, 11 Sep 2025 15:22:28 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: Fix recovery hang when sync_action is set to frozen
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250908140806.153159-1-meir.elisha@volumez.com>
 <59772acf-a9e5-7aa0-80fe-62f0476f22b5@huaweicloud.com>
Content-Language: en-US
From: Meir Elisha <meir.elisha@volumez.com>
In-Reply-To: <59772acf-a9e5-7aa0-80fe-62f0476f22b5@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0015.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::18) To GVXPR04MB9927.eurprd04.prod.outlook.com
 (2603:10a6:150:118::22)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR04MB9927:EE_|PAXPR04MB9398:EE_
X-MS-Office365-Filtering-Correlation-Id: 83411500-6785-425a-208a-08ddf12de2d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0FLZmxvQldleExsakwyRi8xWStmUFlZVlBXWWZhRG5zNDIwWnhacDdrQldT?=
 =?utf-8?B?T2Zvb2tST0YyN1ZHODczWmgxY2lFZ3Q5UEVnSFBqTXZSbXY4Z1JGbDNGeU0v?=
 =?utf-8?B?U0NocXcxQzVxNlBOM24wUVpKYUE4VUJHZzk3S29KclBHY0ZyYzFaZG0xV09i?=
 =?utf-8?B?SDNOUXh2eE9zMDdVYVZRVDR6VGFDbE9yRHBHdkFzOUowc21VMUZCYmVNakRq?=
 =?utf-8?B?bVliY0pxUERId1JQSTl2elIwVFZIWXVxYWY2bkF0TjRYd1IrUCthNEgxaGR6?=
 =?utf-8?B?eUpMSzJSN3RvTDhYV2tmeWlDbERja251MlJwb2pzM2x3QU9ncEk0SmpUL1Nu?=
 =?utf-8?B?SjExbmtXY1Q4ODdhQlMrR3gyampNQnRPNGVaOFZwL2ROL1pnTjdFalgycnEy?=
 =?utf-8?B?Q1dXSmFhRFYyZ3EybitqK2VpaG9aMzBFQTdiLzE3U0VFdCt2RS9QRUpBaUhO?=
 =?utf-8?B?Nm44WkpOV0g4QjFYVUlvalIzbTNvNHM5aG1EZVZxRDVPSVBuMStMSHZEbHdr?=
 =?utf-8?B?R0MrKzlOeGhBQ0hOWTFBdG9sYVJGM1dCbldqa2c2YU9CZWZDYUU5SlNmUVFE?=
 =?utf-8?B?QVowRmMwaXZUMHhLQVRpMVhvZTB4SE9yaTFVSzUwUEJOVUVQbnh5N3RHeFhC?=
 =?utf-8?B?TzR0b21yUTZQSmVaMUtIM1VWQVU2V1k5R21iT1RONVVQZ05RWUdQaFdoUnJY?=
 =?utf-8?B?SVNuR095NmExbWhyQ3hlUjZZM0Y5TjNqWnBYNEgyaHdyR1piTGd5WmpNM3pi?=
 =?utf-8?B?VDR0RGZZc1ExWjdEOEIvWVZJNVNBR3l5cTA1aHVSbDdHaVB5SFRXM2hVK3E3?=
 =?utf-8?B?SjJVMXBKYmZqYzE0bjZSZXNINUVMWHR6WHRvbWkvOTI4T3NsMFByVWlDRFMw?=
 =?utf-8?B?NFBCRXpUU1RObWZUNDN2ZVM4S3RkRzdIa0Ruc2JWcjU3Q09aK1A2L3VVamQ1?=
 =?utf-8?B?bHJ2SzEyOEREODdwVDA2R3kzM3dLUnRkdFlFdW9VM3Fra2JyMnFTQjRaZXd0?=
 =?utf-8?B?TFRmWTB5QjJNMHdURFQxRFk0bHBpbk5MdFdQK1RvbHJnVkM0cS84UzY5ODZ3?=
 =?utf-8?B?V2J6V1EzQjRYUDdPRUlJeTBsK1dpM0tmQytqdWY0THlZY3RvcVl0NlVkTlo0?=
 =?utf-8?B?ZldqWDJpK01GajIrbE04c213N1FNSndPa0NuU1EvOWVEVTRxb3h0TkNzOWRa?=
 =?utf-8?B?di96SEJoT3QvTzRGeHZGbFAvbVljOCtaSUJMOVZPbHQrUFgrYXVkaGQ0MnNj?=
 =?utf-8?B?MlpXVy9rRGRYOXI0dldWTm9zVllCVHh0RTZmZXczWGwySmQxeFgyYzZZdUVz?=
 =?utf-8?B?TlRkRU1KM0tVZ0hnQkY1ZWFzdUtkdWxsaGcyWVBQdXhhVUxvVGtXd3JRVTlm?=
 =?utf-8?B?Vy8zUTYzQkg3dU1JL0Fvdm5hVEVoK3hsTGg5dGltTEt0MUN0YkFIcHQ2czUy?=
 =?utf-8?B?MGlVRDdGMmlTbEFDMTBGQ2w0SzFNY0o0c2FoT2dOaU4zdUtvc0xPbUxIaFox?=
 =?utf-8?B?T3pya09YKzFONEt4Z3dyT0pPNWMrdC9aRXp4T1hSRnpuaFRhUll1RXU0VStp?=
 =?utf-8?B?SlFuSlVHMmhISjkxNVBSQ0FlV0xVTHA0Tk1BM3Z4T0c4VldhUDJlNVoyZVFU?=
 =?utf-8?B?SHkwWTdMSHZEMXBvQk5ROVNsMHNVNkxZTjgyQ2Z4elN4K0xVNU5rdlBDS2xx?=
 =?utf-8?B?V29GaWdxNE9rZGZkalBXWmkyeitIbkNaeXNhNnlPWUlQZkgzZ2pMWnY3OVBX?=
 =?utf-8?B?YjhIODJaK2k1c2VGcVo1S0tocDN1aEpjZm1aOGpJWU1yYjNFSE9NbnJEQS9O?=
 =?utf-8?B?cUF5eEYwWERMNk5HY2dnRks3ZHFhRjJ1RnV2N1ExOUZ3Uy9XcW1tY3VCVXNl?=
 =?utf-8?B?MCtkOUJGM1NPc1kzYkZRbzhudVBVRDZJc1lodGNmK2xSemcvSVI2aG9yemhs?=
 =?utf-8?Q?d8uZ4IFzdEY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB9927.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T1RMSVhhM3NHMW8waVgzb1hnYVVGZnQvSk5oYW1teFpJb2l2WmVNdHovZFNq?=
 =?utf-8?B?a284OVNZN1BhYi9HczZUTEthaEdZMzZrUkJvZks3d0hXQUplaEdYcUFiR2tU?=
 =?utf-8?B?NmlaMno2NFRMMXdlK2VIMkwyS2Y0a3hDbXhOL01SY0lFUWRoSThDN2hDd3Ru?=
 =?utf-8?B?ZXpyQVV6ajdwWnNPSFRQNU1odVZ5L012SlhCNTFyNHMwR1FuMzA1Myt5Mi9U?=
 =?utf-8?B?NTFXRGlVQnI3ZlpXbkVQaUhXZTVPOW82TVdUUU81T2o0ZTJMWlk5Z2VwS3l1?=
 =?utf-8?B?aGJLb1Z0STRuV3E0bDdFelAxaUs0dTRWNWdsUnpGMXNmcUd2eXZTblB1TXRh?=
 =?utf-8?B?eDVaaWkvQm93ZEtNaTlsM05DQjNiYUNkWGNvMENZMU44S2ZKZ2JRNXpMRS9I?=
 =?utf-8?B?OE5jM0xhYVRzMnQ3OUhIeTNma2FMSEIybnF6Y2ZueEM5bzhCR3Z3UXJMQ0py?=
 =?utf-8?B?cHphQWc1bU9aT3NGbXFiYWNkVXhuSWFiZ0tCZ1g0anFqeDNGbERuSEtxbU1O?=
 =?utf-8?B?ZEpTazVhQmw1Rjk1TWwxeUdpeWg1dHhCMHhHTWFRS1c5ekN1MnR6Q3R0ekpQ?=
 =?utf-8?B?OGpRazdsd0l0RkV2QU1CaEtFRGdoMEhLdnZmT2lMYkxYTkdIaytRa2RnN0I4?=
 =?utf-8?B?TWNnODFEbDA4OTJjelVFTVdwUlZaaXdpMGticUttbHNsSFVmTEs0Z0V3ODNR?=
 =?utf-8?B?Yk9GUFU3Vk5nazgrWk1pU3JmNkxmOEkwU1NaTVV2eWZFZExyYXY2NEliZWpV?=
 =?utf-8?B?aVpkdnVkYnEybXdxeWV1bGVna0hMRkZXVVVPRzFNWmNUWCtlZ2duQWt4MlEv?=
 =?utf-8?B?YWIrVFpNUkhybkZKNmsrcVA1U1pGMWUrNWh6b0JsTHBVa1BjU3Nlb2ozNkdT?=
 =?utf-8?B?TDhhSjdsNk43bG1lRWNqNkJINnF5YzJoMVlqU0V2R3ZUNDJyaFk3UmZ6eitr?=
 =?utf-8?B?WExheFhaR2I3dWxuSXBreHhiMFdqWXc2UUR6c21tUmEzaG1TbTNlVTFBZ0FS?=
 =?utf-8?B?NXhkTWsralRmbUtiQVBzYklQSlpmSmQwT1hWbVl1RkFXeWhjTzUzMjU5OTVL?=
 =?utf-8?B?RUExdlFjM3p4Tk1ZbnFiQ2Nwb3FXZVRFQWxwTU41UjZZa01PNGZJenVmNlJ3?=
 =?utf-8?B?aENRQkY2VWorUW5zNGNVRWYvOW5ZcGgrM3FYVE1uMnVPaFNGeXZlbXc2RW9k?=
 =?utf-8?B?SVJjSE9QajBWcmRYandRN09JZzdlZURCZyt1NWtFaFJCcFdOTHRYeFlRdkhM?=
 =?utf-8?B?T2FuZUJ2UWZ5Q0tjdWROWDlQZ2FyRDU1QnVTS2FGbXpucWhZZS9CRENsVEs5?=
 =?utf-8?B?WW8zcHhxZUZBSEZzdVZlbkkwV0tid0pITmJ3WUdJUVpOVlpOVEI2d2ZHVEF0?=
 =?utf-8?B?a2tSZ0hBTDVkQkhXcXdIVG5IV2tYMmVvaHhlVGZtSWtCQ3VFK1NrdmVpN0NL?=
 =?utf-8?B?ei9TdTdVZmNPRlp4allib3hlZ3lZa1IzSEZva3NjWHo3VXc5Q2d1RXJWdXgw?=
 =?utf-8?B?UUxMQllGSTZhc0QrOW5QLzhpOW13d1p1c3pocUEzTmQxUExYNFd6TnhhcVFT?=
 =?utf-8?B?RmUxSnROK0lHUE1SR2UzaHBuL00wSFRWZVBONWo1R3ovYks1bFdSL2k1bTBE?=
 =?utf-8?B?VFp1dWVPOU01cm5ocEpGYndhUDlZRUVRUXoycXQ1Y29iMUVwcFNsYzA2S0dl?=
 =?utf-8?B?amZZb1JaMzJJQ2dkdUZCYzVXVWhWK25tbm1JMXlkT3dpWlBuZ1RLcko1V0F2?=
 =?utf-8?B?Znk0Y3gvTFJ4RGFvVVFuSm9LazZ5aGF5VmJHOElDVWR1cENEQkpKeXpWZVUy?=
 =?utf-8?B?MmxDMWNTTXFoS2xURXk2MzNqWXpDN05RWTNZd3NhZ2VmeUZ1UW1yMDE0WEJr?=
 =?utf-8?B?WWVsU1h6cDRlRzNLdmtHY2xHckpxcWR4MUdPUUVGSU45d3h5SzliZHphbTdN?=
 =?utf-8?B?UEc2VjZNVDdnb1ZCcHVta3NvMlExTGlqS2JHcmptZXIwVVBja0Q3WlBsZFFi?=
 =?utf-8?B?L0NmZDhLZzhkRFNDV3hGWWZZa2MreENTRjM0WVRuV1YxRlBMazBCaHBWTExq?=
 =?utf-8?B?aWo2RDRzb0RKNHB0VmJoU0hFRTMzNVN1M3crUWhycURMWXpUYmtLYkJtK2JW?=
 =?utf-8?B?aDVhalRqdDd1WlJ1Mmp4N041N256aTBybGROaHdFZ1Ztb1RoNHIrL0l0czNJ?=
 =?utf-8?B?R05vOEpwSFdzMmZjTjc2Rk8rS0ZSTHVBQ29xakdtbTFDcTRPaHZIaTlaMjlV?=
 =?utf-8?B?UTZGdmo5QlRPVk0rZE90azNNcGlBPT0=?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83411500-6785-425a-208a-08ddf12de2d7
X-MS-Exchange-CrossTenant-AuthSource: GVXPR04MB9927.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 12:22:34.0542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yEMMU0nuwFcDgkwshFx5PQewKUDfl6rXmtT9RoilAH5+2HXMtFuRWbh0FI16B4dr4FEpb0YeeOIa8/ZAmyJWYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9398



On 09/09/2025 4:00, Yu Kuai wrote:
> Hi,
> 
> 在 2025/09/08 22:08, Meir Elisha 写道:
>> When a RAID array is recovering and sync_action is set to "frozen",
>> the recovery process hangs indefinitely. This occurs because
>> wait_event() calls in md_do_sync() were missing the MD_RECOVERY_INTR
>> check.
>>
>> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
>> ---
>>   drivers/md/md.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 1de550108756..1b14beef87fc 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -9475,7 +9475,8 @@ void md_do_sync(struct md_thread *thread)
>>                   )) {
>>               /* time to update curr_resync_completed */
>>               wait_event(mddev->recovery_wait,
>> -                   atomic_read(&mddev->recovery_active) == 0);
>> +                   atomic_read(&mddev->recovery_active) == 0 ||
>> +                   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>>               mddev->curr_resync_completed = j;
>>               if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
>>                   j > mddev->resync_offset)
>> @@ -9581,7 +9582,8 @@ void md_do_sync(struct md_thread *thread)
>>                    * The faster the devices, the less we wait.
>>                    */
>>                   wait_event(mddev->recovery_wait,
>> -                       !atomic_read(&mddev->recovery_active));
>> +                       !atomic_read(&mddev->recovery_active) ||
>> +                       test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>>               }
>>           }
>>       }
>> @@ -9592,7 +9594,8 @@ void md_do_sync(struct md_thread *thread)
>>        * this also signals 'finished resyncing' to md_stop
>>        */
>>       blk_finish_plug(&plug);
>> -    wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
>> +    wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active) ||
>> +           test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>>         if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>>           !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>>
> 
> This patch doesn't make sense, recovery_active should be zero when all
> resync IO are done. MD_RECOVERY_INTR just tell sycn_thread to stop
> issuing new sync IO.
> 
> Thanks,
> Kuai
> 
Hi Kuai

Reproduced this issue:

30511.653859] INFO: task md_vol0000001_6:9483 blocked for more than 622 seconds.
[30511.654079]       Not tainted 5.14.0-503.31.1.el9_5.x86_64 #1
[30511.654321] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30511.654550] task:md_vol0000001_6 state:D stack:0     pid:9483  tgid:9483  ppid:2      flags:0x00004000
[30511.654864] Call Trace:
[30511.655015]  <TASK>
[30511.655165]  __schedule+0x229/0x550
[30511.655339]  ? srso_alias_return_thunk+0x5/0xfbef5
[30511.655514]  schedule+0x2e/0xd0
[30511.655667]  md_do_sync.cold+0x98d/0x98f
[30511.655820]  ? __pfx_autoremove_wake_function+0x10/0x10
[30511.655976]  ? __pfx_md_thread+0x10/0x10
[30511.656125]  md_thread+0xab/0x160
[30511.656291]  ? __pfx_md_thread+0x10/0x10
[30511.656432]  kthread+0xe0/0x100
[30511.656577]  ? __pfx_kthread+0x10/0x10
[30511.656718]  ret_from_fork+0x2c/0x50
[30511.656862]  </TASK>
[30511.657003] INFO: task bash:9559 blocked for more than 622 seconds.
[30511.657150]       Not tainted 5.14.0-503.31.1.el9_5.x86_64 #1
[30511.657312] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30511.657475] task:bash            state:D stack:0     pid:9559  tgid:9559  ppid:6631   flags:0x00004006
[30511.657759] Call Trace:
[30511.657895]  <TASK>
[30511.658026]  __schedule+0x229/0x550
[30511.658160]  schedule+0x2e/0xd0
[30511.658320]  stop_sync_thread+0xf2/0x190
[30511.658466]  ? __pfx_autoremove_wake_function+0x10/0x10
[30511.658606]  action_store+0x103/0x2f0
[30511.658743]  md_attr_store+0x83/0x100
[30511.658883]  kernfs_fop_write_iter+0x12b/0x1c0
[30511.659026]  vfs_write+0x2ce/0x410
[30511.659169]  ksys_write+0x5f/0xe0
[30511.659332]  do_syscall_64+0x5f/0xf0

Debugging showed we hanged in the wait_event() call in md_do_sync().
If adding MD_RECOVERY_INTR to the wait condition is a bad idea,
Do you see can we prevent this hang?
Thanks for your feedback!

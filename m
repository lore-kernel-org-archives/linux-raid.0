Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023095.outbound.protection.outlook.com [52.101.72.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0F0202963
	for <linux-raid@vger.kernel.org>; Sat, 16 Aug 2025 12:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755347299; cv=fail; b=LZIGGMPxoKfOSeCyQ9R+pUOpH18N3+UavBbede0n/X5AsZGlTgPsHRqf+11NlwSwKrOGDLedm4CThsQjSEIxP+rnoYqxuNybJh8LWVc/x4PRmbphfw4GruAaZhVCIt3u4TUWnNGwiStEv33ETLUBdHSas2OIv2Agw+jjz5XFy3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755347299; c=relaxed/simple;
	bh=eynRDJwcZPXep1UKjmj42iRw+zb+jExVvyodWkt63Zs=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=HnIko2mVf3eKXsyeXgZrp2PyF9xD/acsuMX+SOtx/DZnjnWnwqQdHLDOP7Pk55G1ABLUmpmPRJ9qLFHV8qGle7QqyYJJEBMmpC+cQm+nOjVgzDlcFfeinBxydsZOuTbp+nnAxkVx+KricfT+u7aW4ujyfluTPMFxmTi7pKq6HSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=awS1Bxrm; arc=fail smtp.client-ip=52.101.72.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="awS1Bxrm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pakUDMmQHKgtws/YF/c+tR63yJ4CNtqFj+58uLp74AX6X5gfoEPO5fD+Teu8ps5Zqeo6iiIgdJoURNctS/VDUDeMV5A6l/ZMF9bBwN3LFC2ju8FCSaO2IANFFyN8px6LioYInDIhLMwP7cm5255nNG4Lw4akIilO2gJtc/v1CQCRIWfLJEYE06xdUkYUmbWStpUgoBurafSQ7qVJH2qGP2+Rqpcivfuw1FhgMzezpXQz1Fu/SJ+HqCxWuhEqDmsQuYBDdahhfU7laVwiWIwnb5teF96T8PKNf6PMFN/mvc7+JdY1H/zIpxVrDfwHL2Syh3sNYBYm0OU0mbDhL1/6TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUg85qLuNv0SMlX6MgE2ihXGdKWN3V0ywnFvMEROPYc=;
 b=GS4WSxRG1hKtCG94pqAlLW5ZrOUkwr5vxFW+c5oHTlY6n0hOYUGxMhshF6nRqvTipuAH0mdpg8HAjy22aB5GGa5VM8QelcPIDOw7vdix9LIGwyzuNTrOi9/KKj3CAUT4OKUdR6BwBT+tm/RtZ/6bQsZRcgkoKFZlMKTgfq2gyk5Ih8/RNpBBCEcslFUBa3gqpcRzx5aA2rtnwNbYAzT0GhFFyQgpj7rspWeI3HGSKeJHiIKXhrTHtWrtDxqofW+Iyc1THiW3eeGbMG1hUU8lRjo+QYKiGwW8b+8hNqkLe/5tP7JuKBBUHImm5/pbdaP5HSYvHvBUYUs2f/LQ2Esnuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUg85qLuNv0SMlX6MgE2ihXGdKWN3V0ywnFvMEROPYc=;
 b=awS1BxrmXJbDUoTFJ/1A/ECA6OM9VpRE1dFpk9QZJv5Fb0gkahLMvJUdyohYHp0nwnDw5BGqzggm1KQvxBZW/7CGjXPGaaPdz+uxoQddUXkXqzIu4KnHOtPyS8+iFMAaoCwFhMyT3ShQrP/Fsbp2PzEaG2LL1Be+feXiiOqld7NeQRArZ2Cl4IoAvypouXjtXxyYptAV3NiXrgjdXJQOMfRJTa+HYIEzz2wTyZYPOOeS5JmnuynB4rcMuFVy/dqcqyy27KUFW2eRwGunPIiQx05rurkywjew+tHX++G6a0FkrWmkyGphCMKy2tgGe7kRnI1/AdKBQzYG2vHZWwcraQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
 by AM9PR04MB7602.eurprd04.prod.outlook.com (2603:10a6:20b:2db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Sat, 16 Aug
 2025 12:28:14 +0000
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8]) by GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8%5]) with mapi id 15.20.9052.007; Sat, 16 Aug 2025
 12:28:14 +0000
From: Meir Elisha <meir.elisha@volumez.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	Meir Elisha <meir.elisha@volumez.com>
Subject: [PATCH v2] md/raid5: fix parity corruption on journal failure
Date: Sat, 16 Aug 2025 15:28:04 +0300
Message-Id: <20250816122804.1007376-1-meir.elisha@volumez.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TLZP290CA0004.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::15) To GVXPR04MB9927.eurprd04.prod.outlook.com
 (2603:10a6:150:118::22)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR04MB9927:EE_|AM9PR04MB7602:EE_
X-MS-Office365-Filtering-Correlation-Id: 20f40ef6-7265-46da-5e9e-08dddcc05ef5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UitONlRDV2NYd0hCbXJFSTV4MnFmWXpPMnlBRTd2V0xseHJuRFpyY21xSHJU?=
 =?utf-8?B?UXhuUnE5NW1BZ3ZkM2YrSVJKVUd5QjY1anArb3JlOG5oRnI0VDJia0RXcmZY?=
 =?utf-8?B?aWxuWjZSTUxTNm1RaWNuOVNRYmlMbVJ6ZWcxWDF1RnlRUkpmOEVWWDJlMkY1?=
 =?utf-8?B?QWo0UEpndVNQKzNIVUY4N1ZzLy84WlU3cUd2RXdENDZWd2FBMTl0QzFVZzNU?=
 =?utf-8?B?MzUrYkpiK0lWcUhKaXVDa1FNQVBsMmlTZXhHZmlRTjVhaGpXT3lHekw1Njdh?=
 =?utf-8?B?N0dmSWJEQUdyWjVRZXZ1MjdyamdMUkpxaGVMeThEZko4VTAyd1Y0WUdZdmpF?=
 =?utf-8?B?UkdITEo1R0JROXJxNFpFeHo4QjIwYlhUTVBicjl0cVA4Y3p2NGdFbDlFRnM0?=
 =?utf-8?B?SWVhUlp2WklJTVBtMkVIT1dLNkxlYVZxczhHL0hHLzIxVTVqWC8vdXhQNE01?=
 =?utf-8?B?NWw3cVVCWWtFcnp4em5WdmI5MDNSQVZZbmkyb29uQ2swVGo3ajFyYjhtMGUw?=
 =?utf-8?B?ZFdVMEt5N0g1WXZWVnhqSlNJQVZpMEFjSk9VWUZHTERKcW1EbC9ZaGs2dllQ?=
 =?utf-8?B?MmN5TEJYTE5GVE9qclVIMzlmM2svSmpXWmN1U2hqVXFDNlpDTzRrc2V0UHd5?=
 =?utf-8?B?QVhqR0MxUWRHb2J2aXhrWWZxTUVkNmFXUFJsakE4RGFaTGRpR01WbWJtaUkv?=
 =?utf-8?B?V0lNTlpHemRocjQxeXpRYSthU0tqWklLTFlWb0w1TW91eHh1NHdyLy8vVkdZ?=
 =?utf-8?B?dXlhVXhXNmwvS09Vb3VkVHQ4ZEV4cDg4WHNERlJaRHd6dzV4WG5PQVJUZXVQ?=
 =?utf-8?B?MlQwdlppd0lJcEF2MDBhaEp6OVJmWFEwbysyMG5iQlNxNFdjNzRLVERzYmJ4?=
 =?utf-8?B?djFqbmpKZUpnRkQ2UE5tUDBXZmUxNjhxV0crQ3JrZTRRZTRCYkhQUmp6aVox?=
 =?utf-8?B?a2JSbWl2SkVEMUovTmYwbm9oVEJxcGFiRVFJOG1IcWd1dGpWSklNUWx3cEsv?=
 =?utf-8?B?V0ovV1dXaGNneUQyQzU0aXpBNmhTVW1rQ3VOZk1CZlNFamVtUXNuOWRPSmwr?=
 =?utf-8?B?OG8vR0dwN0pBdlo0V3hueEh5VzcyNmNRR0xyRDlTL2lXVVprbEdNVHJTS040?=
 =?utf-8?B?QXAwVXo0WEt4aUt5aEJRUGdIaGNSb2JrTCtLbmJPT2N2NEpGQUtoT0VPTmk1?=
 =?utf-8?B?QVVtK1JLMDkydkVldmxLdXhnNklXNWVuS2FQZFE1UHBhLzBicEZuSWxOZ2Rv?=
 =?utf-8?B?ajAxNEEzcTduZUYydFlpR3R2bHJJSGM5ZGVSZ2lqYnlXT3RNajM3TythYXRP?=
 =?utf-8?B?MitBS24zZDU0cWlaVS9WaE1YUG5EUEZlbWM0aWxIUngzaC9ZOWtCUVRBNStj?=
 =?utf-8?B?YzFXNVpwZ05uenM3Ni9DTUJGOTdDb2UxbEg2M3hGdlE3a25ocU4rMjViYW45?=
 =?utf-8?B?bk1zNm9GZnR0Wm1RdmpUNnkzeWFUSVNYSWlqczZzTDQ1VFpMNVUra3hPcDEw?=
 =?utf-8?B?UE1rSmRHWkZuV28yaThoelIvNDhzSzVqUjMxUTIrQkUvYVNiZE44TXFuVmVo?=
 =?utf-8?B?QTNWQ0huazJPRmVsYjVUcU1nbzQzM0JpVmNuMkNRejVYekROaTBqU2k0Y1ND?=
 =?utf-8?B?c3FpcnpvUE9FZXAyU01nbm03MXpkS3lrTUZpb0dnSTBoc2JXYXJoMnRmMFVp?=
 =?utf-8?B?MW1GVjR1M1JITDMrQWtTVlU5aUx2eHh3VnFpTjZqWTM0SFpBdTFXVE5HWjdJ?=
 =?utf-8?B?TUgzeGxDTVd4SzRuV2pqQ1ZpNWlPK21MQ05ZRTU2VzZJMUNpeVNsb3VrQnlW?=
 =?utf-8?B?eFg2VlpNQmpPNVVjV3pMYjlWWlJjNGEwS0Exa1VUVmlxYjlZT04yei9WQ0dY?=
 =?utf-8?B?VnVmNzY1VnJQNW9LT2NoVnpLTmFaUzFEOEgxTHNKcVJSSWVwNTkvSnFVOW5C?=
 =?utf-8?B?a0E1WW80YXE5RTBJeHJwRmJtaFpOd01RV2V2Umx3eGZvd2lvMnNzK29nVndo?=
 =?utf-8?B?aTNmc1FVL1ZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB9927.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(52116014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFJxR2dIWHlibUpTMVpQdlhlbm9DeU00N0xKRjI1ZlpKeCtBRHl2TWF0STZV?=
 =?utf-8?B?ZWV0YkZadXl0dFFsOE1aZWJydVlOWnZjbUdOWldwNHNvTFRvM000ZjhpMk1R?=
 =?utf-8?B?SVM2emxYM21yZSs5MEpvaGJvZ0YvSU5RdlNCZHowc1RyQkM4a1ZEZjBMN09L?=
 =?utf-8?B?dzl6VEdKdkpaVDFYSmgrNEJ4dFljTUxtdTFZVGxYN0hVUlk3YmxhTmVKODhP?=
 =?utf-8?B?cEExdmQ1ZWR1cm9CUjZlUU5FQ3Y3OVhOOE43akVxVmY3dUljUS9OVEo1WWhK?=
 =?utf-8?B?YUsxNTNVWDVvS3JvZkVsekdEMm9BQWgvWXNaY1d1TnI0MmV5L3B4NG1oRmNC?=
 =?utf-8?B?Ulp2SzdYTnBhQ2dueDdRakg1NGU0SERLM05FakV6TXdKbkxqamM2TmdTN0hy?=
 =?utf-8?B?aUMrOVlFcWE0bTEyWEovZndFL2QySlhtNjlhV200VG1HZ0NkZ0F3dGxCMTFK?=
 =?utf-8?B?NURMckpUQmZPOHV1cUtTYVJlWWZLZ1o2Nm5nMHRtZFdDRHF6aVhIeDhGNkFQ?=
 =?utf-8?B?dFZXTWlvcmk4MTBnNVJzbWlnNXYxOWRzbm1kSDArek9oTDYvZ3ZmOHdZSE9q?=
 =?utf-8?B?Um5vUkRnZWRhVjRBR09HcnZsK0VaSGNOdHlKcDRsT0ZkWU80ZGIyem45YVYv?=
 =?utf-8?B?YU12TDU1TWtObk56WFdUeGhTOFdGMjFRYWxFUTRPRTI3ZzAzN2ZTT0VOUkhO?=
 =?utf-8?B?bC9oeUx6K1E0V3NnRlBYYnZ2S0lkZjRiNURadHNLTDNRc1M5SFNoNTRhcVlj?=
 =?utf-8?B?Q2hDRVZnT3FJbllTQTR0NkM3cFQwWi80T2p3MFMrYU01TWtqd2doWjBXMmRV?=
 =?utf-8?B?YVRpUUNkMGZpaUVtZzM3b0hKZGpzOE5xdmFoNGk0em91VlRENlA2aXg4OTFX?=
 =?utf-8?B?ZWFvZGFmaHVMd3U1Wlo4UTVuM0Y3Ty9yTmdYSlN5SlVYaHRVQ05rNjMrb1Zl?=
 =?utf-8?B?K3VmN2pIaWtvOUpCQzhZdnIxdkU3WlQ1OWN4bEl4dXoyOUprbTdPaTlXNlFO?=
 =?utf-8?B?K1dOc2hBc2MzcjlmWDJSL0duR282VTZxWVp4TGh6QkF3S2VGY3c1RS9NN1Ir?=
 =?utf-8?B?MHVJS29IeEdDdnh0Z2E3dWJTWnFOditRamVERVYwNXRubGpUY2lleWRRd0pE?=
 =?utf-8?B?N1BDY3VHMnpwcUdRVFQxSE1vWjZPMlF6cHdMeWhSTzZTSklXOVRWaEVmS3BF?=
 =?utf-8?B?bWZzQ0xqR2tnUnpWLzc3RWZjV2dhM3h4dmhySThWWmlrY2Z6TGZOWjM2SjlG?=
 =?utf-8?B?ak5mMENCZDJ0QlpQVEZQYktZY2xaSW5QU2pLaFU0a3FIZzBhdWtlWEhLdmN6?=
 =?utf-8?B?TERRWGlTejZrZnZlZ2FwNUVzdTZVUkFidkZSQTYzeUR1TDRuWDlld1lmaVpW?=
 =?utf-8?B?c2dmREppTVJkQjlEQWREY21kRzZydGJKVHMvcGdydUd1V045ZGJaTlZnTUQ2?=
 =?utf-8?B?WE1OOVZJeVNoQks4SlAvSEJUQzN4bS9oSHVobEplTXRyZUVsL2ZYdHhzQWht?=
 =?utf-8?B?RldLejBPWVI2MW1yei95Z0JiekVJWVp2L3pXaVF2QlJUSTJidlFRbHZScnlW?=
 =?utf-8?B?cUEwUytoc0d0Zml1bHlYL2lrVlEvM1pYbkRqbjcvejJCa0Z0a3RYZHA3Q2Jo?=
 =?utf-8?B?dTAzREcvN2NxYUgyWEJKcnEzRGNqT04yalZTa2V6dGd0NFdEaEwraTlnTHVW?=
 =?utf-8?B?VGgveHdVWWdzaWtRcEl1emtnRXlUS2J2N3dmV2xDVGpPK0FBcTFOalU1SEMy?=
 =?utf-8?B?V1kxWjhCZ1ErU242SXhwUWh1UmU3elBIZG5BTWljYTBtZXFqazhUcjN3RG9B?=
 =?utf-8?B?ZzREZmU4LzlPa0c4MWE4bSs4MVBhNmx6dVJxMUNGUjFsMFUvc1lLdmY4VnFR?=
 =?utf-8?B?aFAraTZoSElYNTQ0aUlSR2hwTjVFbXNzU3RCTGp3NTNlSHpZK3gyZE8rbTk5?=
 =?utf-8?B?K09EOUtSZDdTc010QlpobUpxVGJ3dmJKRzJVakZyVXlydUpoNFVib21QMFpm?=
 =?utf-8?B?UkRUOWZRTmN1MlpzTlhUdlNZbFhVY0YybkVMMEJtbnhXYmliS2RJbkZrL3k1?=
 =?utf-8?B?dG80UHRETjBBb3paeDFmVzloVDJPQmVZaHhhNDJvczJxMDJod3VHMlZIUjR5?=
 =?utf-8?Q?gu4e/mmkvWn/K2W8jU3KizuHS?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f40ef6-7265-46da-5e9e-08dddcc05ef5
X-MS-Exchange-CrossTenant-AuthSource: GVXPR04MB9927.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 12:28:14.2933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGqLptZO8MGQUqwVShcYyhudeySXm9zOwm6NjMSVtxX8T7mcxv67DZMbNBPh815zrcN1ITDiOaDXjOKQcs5iGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7602

When operating in write-through journal mode, a journal device failure
can lead to parity corruption and silent data loss.
This occurs because the current implementation continues to update
parity even when journal writes fail, violating the write-through
consistency guarantee.

Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
---
Changes in v2:
	- Drop writes only when s->failed > conf->max_degraded
	- Remove changes in handle_stripe()

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

 drivers/md/raid5.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 023649fe2476..509ab5673cf8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1146,8 +1146,21 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
-	if (log_stripe(sh, s) == 0)
+	if (log_stripe(sh, s) == 0) {
+		/* Successfully logged to journal */
 		return;
+	}
+
+	if (conf->log && r5l_log_disk_error(conf)) {
+		/*
+		 * Journal device failed. Only abort writes if we have
+		 * too many failed devices to maintain consistency.
+		 */
+		if (s->failed > conf->max_degraded && (s->to_write || s->written)) {
+			set_bit(STRIPE_HANDLE, &sh->state);
+			return;
+		}
+	}
 
 	should_defer = conf->batch_bio_dispatch && conf->group_cnt;
 
@@ -3672,6 +3685,10 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
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
-- 
2.34.1


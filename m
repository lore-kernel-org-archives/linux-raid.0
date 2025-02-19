Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05992147F2
	for <linux-raid@vger.kernel.org>; Wed, 19 Feb 2025 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739988150; cv=fail; b=A0rvgKs2f4qXgmwdm7EFOTqmDSSeAVngmPbx0WIHmsoAeu1uxtLT/zd1mX8OmeGbNVlHxQCrq5gePHiXhagGpIObX7CBt+TPiUQo3JIC+Hm3hiNYb5xmkDl2hjfEMBkWoi5ywWL7/r4A1h1+sgsF4b0+N9jatXvhvwQqK3yfCTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739988150; c=relaxed/simple;
	bh=ZnS6N7y0ZGRWhfSADViT8794D/jK6KTvEWej4PJVi7Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YVNZEv9hkO89IFamHJ/76652d3pSFpe+jAU/YgZSymnuK1xXyRxEItavU5ZCtyG/oMn3cLp+RLBkOz2xBlvptUHpmJ9qXIcSCQ99zSz2JZQT1WCdwJti05SjEb9Wo2p1st6IxDnWQ3kO8RG7N/92teD9qtD8rx6ej9WJbi5lj7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eGFJkwoK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ESHtJLb9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eGFJkwoK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ESHtJLb9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51JHMX2O030033;
	Wed, 19 Feb 2025 18:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ZnS6N7y0ZGRWhfSADViT8794D/jK6KTvEWej4PJVi7Y=; b=
	eGFJkwoK4VQHPB0DvbdVuppHza1BGTrrBPC0s0K674RvPKUudTcGWJbsUzrmBAQI
	Cse56EB8C8UiKmvkJyAulTh6Q0q+d8XbU8p1vToPM5IJ5+9L7WsvwdbpVyIeYXMq
	IsqQFWu3RuenWPYmKKzci3yH370IqsFwlGSYdKEd6BTTbn3gAVmRzXZciOtN/Lag
	DWMi+nmPPk3VWm2Le2z1akhneLtbg1lVIdg1Ppcn1zPI1axMoZWMM57lENjf9dI8
	my20tvq362w1ck8I1RFzJ8ZNuCYZAP25IL/u6QLGNVyCr7/eVFdJKuyBE7QhFn3X
	7gF/a+grhZzJh+qp3z3Www==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00nja8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 18:02:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51JI217D010447;
	Wed, 19 Feb 2025 18:02:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2043.outbound.protection.outlook.com [104.47.55.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w07duy0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 18:02:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RcbXwt+cIj1m3IFJJb79b8ymiYV9gmtY8vQ2a7jKOa0Vdyxy8Gf5uSRCb38EEnCOWiqP+58q4ue2s3sS8H1/oV2XvEw9CbOlOrHcjF+8y6gCPqfq9jCuROxX62DPGKZlqENVc4MiaLj0dCAm4TJzWYqRwZxVnHH+5H9xH2lz7cJt+ksuZ4MCtAhiIBgQq1g8ukQvyvmfO1NMX/oAyjbX0vjsQiaPpzRNIwRxLyL56rsbf2XvBh2Dok5b/UBgCkbgfjqW/iQ4R9p1ZI02m9UVG9puDIiV6J/FDViSVldwEHDPk/TOn9jCcCX3DSzSTEU2A3Uont3GitUKnWFjBk2Qxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZnS6N7y0ZGRWhfSADViT8794D/jK6KTvEWej4PJVi7Y=;
 b=UJuC/UqXIgFa1QcpvGx6jmfGFMky8e6WLILXsfl4f+oP95mACuddG8nMXkMsFf2T0zYDBnGMrOaYu4zAke3URqEHib3rVCU0gNTqlPZYFgM4mOtccW3LQ6FI9FCPlz149fpWghiGe2h/PXdG99K0+xICec0bUC+dqaWMTlj48hWQCdCRIuE/BVQSxdvj4FAsUmpI/tV7+Hw2QC/H8agPnStReQ6jyjxehaiAle4dnO1X9UMGOFTKOIMu76+1DpbSO4d22mLLtcYvXrO+/r+ys/CR+gzVU5US0hzJieGHJiYeotwPv1zeZF4SoJycKmakabBABiliwPKEP5OGuTQ0lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnS6N7y0ZGRWhfSADViT8794D/jK6KTvEWej4PJVi7Y=;
 b=ESHtJLb9zFJ03RO8v/8iSDcxjznUXFjtMFqm+s4SrpLDJOKlucSOM9AF9UBdCG588GQHiziIQyEoGQm5tnTG/puV0pfnC/B0/t4kfFGEY1X2L5R4oHxL2WqGY2gUH3Sw2Mx9edHbtC6E0ZO/eGTwJFrYWjSfHgIaS++4SZZY8zQ=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by CH3PR10MB7647.namprd10.prod.outlook.com (2603:10b6:610:169::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Wed, 19 Feb
 2025 18:02:20 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::a472:6f6e:39dc:d127]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::a472:6f6e:39dc:d127%4]) with mapi id 15.20.8445.008; Wed, 19 Feb 2025
 18:02:19 +0000
Message-ID: <2cd3d398-d6c4-4beb-acf0-ff0a638f48db@oracle.com>
Date: Wed, 19 Feb 2025 10:02:19 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mdmon: imsm: fix metadata corruption when managing new
 array
To: Blazej Kucman <blazej.kucman@linux.intel.com>
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org,
        ncroxon@redhat.com, song@kernel.org, xni@redhat.com, yukuai@kernel.org
References: <20250210212225.10633-1-junxiao.bi@oracle.com>
 <20250212110713.1f112947@mtkaczyk-private-dev>
 <20250212225016.000060d9@linux.intel.com>
 <6d5c8902-ec3b-4d2e-baed-c926ad99cd8d@oracle.com>
 <20250218192228.2997b2e6@mtkaczyk-private-dev>
 <2170b01d-33a0-4cc5-984b-3e0d91f42e9e@oracle.com>
 <20250219165446.000010b4@linux.intel.com>
Content-Language: en-US
From: junxiao.bi@oracle.com
In-Reply-To: <20250219165446.000010b4@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0119.namprd05.prod.outlook.com
 (2603:10b6:a03:334::34) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|CH3PR10MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: bdf3b5a6-74f4-422f-24c2-08dd510f8d97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTlUa2ZNejl5cEpSbW52NkR2ZUY4RTlxN3gxRGk0Tlp4OXAvemlkTHRaNi9m?=
 =?utf-8?B?MzIvQ09UREtIUEd6VWFkeFRPcVpGRUE1alFWOXlCT1YwZWowVUtaQmxONkVE?=
 =?utf-8?B?RzlZVGFLeGgxalFnYzZqWnp6ZVNhYmlqTERjRnhVMXc5Zm1XMTBOcWcrMnRO?=
 =?utf-8?B?em1CWnFjWTllRzQydXBxWkVYVjhxWVdhaU93ZmlOOHo0Q3l0bEFMMEJMcStH?=
 =?utf-8?B?ZFJ4YzAzaUxpbnQwb3pNWDUzSjNOS2F6WUhRN3lnREtkNksxU3lHcm9mSXVM?=
 =?utf-8?B?Vml6bG9jYkdZeUVDWTNCcnlNdUZ6YTE2MHhHdFZlZW1rWTRHM1BpVDI2eS90?=
 =?utf-8?B?SHRBSlg3QmVlanNTU1JONzRxZ0hlakl5RUtiUDZGOStZbmU5N201alJab3Fw?=
 =?utf-8?B?YWVnQUI5dHNQTXR4cWsyMWxpc1B3aHJ6UFdyVldwYkZyUVAzd0RnZllDa1ls?=
 =?utf-8?B?OG9wdThSbVNYVjNydlh5SHh1VEhtME1kaUpKeDJPalZpY2NrdlNrS3FrSjgr?=
 =?utf-8?B?NEtkaWh0OHZmTmFXd2ZOTG1XVGJpTERnTlNzdFJML0RDMlQ5S09qaUdNRmJu?=
 =?utf-8?B?c2ZPSUFqQ2ZDNW1uU3EzVmRtbUEyTHJ6UWJ3REx3Q3NZUlVuVGhIdDZRNm1Y?=
 =?utf-8?B?Tzc2ZGtqQ1RpMnBaY1lDOHUrczVlWGh3elJKb2tnSlZ4U1Q2ajhueXEvWENy?=
 =?utf-8?B?bmlIWlRNSGoyWFA4cUg3L3phak5KTEhYaXh4aExISjN0a3U1Zmx3TGgxWlRZ?=
 =?utf-8?B?Z2xYU0xWSTVBSjIzVHlPV2thTGlQT1FkcTFzdnduTHVwb2dVMnpiZzVUclow?=
 =?utf-8?B?MEs3cGdyd2RkRjJhbHpHakw2a3NMUVM5SlAvak9XbEx0NlFFNElaNTF1SVR4?=
 =?utf-8?B?dXY0Tk9uQkYxaVh5eStwd25xazNaSHFtTVlrVk0ydWorV082K3F0Q2FidXNH?=
 =?utf-8?B?MHFseEM1ZUYxVGhaTXBpMXhYSnJVbTlpNzB1cm9FTC9LaWd5SHdBOGhTOUpZ?=
 =?utf-8?B?Y0NldHZGeUtBdzZLcjAyUWpxa0V3L1NOT09QaUtEQk03bGtENU91UmsvaHpD?=
 =?utf-8?B?WjVHS0N1alExS0N2clZZUVFJd0ZCYmtseDR2eC8zOXhEemQyejBGWHNlOXhw?=
 =?utf-8?B?aGxNVFVMWE9Yb0k2MFZQcTRxZEtZNlRaYWVrSVRxYlR6VGY1aUlUVHZpVGU2?=
 =?utf-8?B?YlVwdGp6eE5lb3U0aGhlRXRDM0VHVFhPaFJoR0NXdm54cFQwbzFRY1p6OUgw?=
 =?utf-8?B?bGVxdVBTM1QzblA2dEQrdzEvZXpJbUpVdGlJekdvSXJMZHpZUXYyNE5SWEtO?=
 =?utf-8?B?WFA2RFhpaGwxeEpOR1hXeFlkTTV4dTVWWFFCT1ZQTmFPTVJqRlR3YzZYWkF5?=
 =?utf-8?B?NzJyZlJQa201czMwa3U4SDBGZlhGWUhUTEVBaFhLSWlSRk5ZUS9jM3pRcnRv?=
 =?utf-8?B?SThUMU1yTjlXTTZNaHlQcG1tWXRldHhmUjVpMW1aanNrbFlNTHpORyt2TGFr?=
 =?utf-8?B?M243WmxXcFZ1K0s3elR2dGQ5R2JMM29mZ1U0N25SRTlWYlcvbUZwVDVJTlRX?=
 =?utf-8?B?a3A1WGpYSXhNcHBLWDdEQmVJNGYzK3lCVWphUjZKRW1rcnNHQlZjL1FDMXhH?=
 =?utf-8?B?S3dqM2pHRzJZQkpsWHQwNGUxVmk2SitkQWpNWnNlNEMzVG1Mc1l3S0dlYWVO?=
 =?utf-8?B?N2ZKTnVvL0RVME5ORzVnQi93bFhYSU9KN2UrU2VaeFkrbkY0NUF2cUhBNEpB?=
 =?utf-8?B?cVRDMWVMbGtQT04xTTBkdHpVQWIzQ1c5N3UvSWlaWWZPdFlpQ0NtQmZVS1Iv?=
 =?utf-8?B?bzJxbXFSSlloT3pSTjlkcHl0Y1ljWkhpQWdXTkEzU1J6OG5UQW1TMHUwNFN3?=
 =?utf-8?Q?2B09ZQTaBP+91?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1FTNTQvS2pJV1hoTnpqM2xHZG5zWHNqUFg2ZjY4SG9GUjlWSFdVRnZFU3FB?=
 =?utf-8?B?UmpRZSsvR3BXcmJTVzdZbHhVUmxDUnNyTXZqLzNBd1N1VE5XanlUeUdCaElX?=
 =?utf-8?B?YXZsOWhUNVNFeTlWdjU0QTI4RXNZR0dpSFNzRTRBVVR6ZEkyd1FHL2tObVlx?=
 =?utf-8?B?V3VVekMwTzg5YVRGU3RNN2hPbnZHc1ZFS1dUb3JXakRQd3A4SkRyOGYyZ0xW?=
 =?utf-8?B?TXFKZXNrdFBFUHZIMDJHT2FIRnJybXozNzNBNDB3SmV2cG9pZHRhN011Q01F?=
 =?utf-8?B?MmUxNU9QNFlRRmFlVUtGUlhhR1BSamJuRnFzU0xVVDNaeGlsaW53MEJEb2tS?=
 =?utf-8?B?bHMzY0NCWVNqZjZocC8wakoxWWFoV2dyT0NoV1R6NXRVRXZrZ2lPWXJodjd2?=
 =?utf-8?B?Q1ZydDJYWiszL0R5aVhhSUVPZ2RTTjV5TGxxWDk4YkJGVGZETjRFcGhPQzlx?=
 =?utf-8?B?eGsyNWhZeWZVbzNSdXZ2Q0NKbGZIaTFtMmM0WDZHeGdmSUxGa0hWMGNIVmJK?=
 =?utf-8?B?UC9taDVrQlFOMU5Ob0xRNk5BalN5b05zUTRoYkdFN05JeDIvL2xIbVBoeTNl?=
 =?utf-8?B?LytYd1dlMWQzUkJkNzlCRnJxTFpwN20wc1JCeXZ0d3hpRzNqWmR5aUMydW4r?=
 =?utf-8?B?TmQ3VHN3WUtxajlTMS9VSFJvOEk0QUdSWko3d29vUWRkcHg0M3BWRzBUaU9z?=
 =?utf-8?B?U0sxSFduV0RWbFJWT3lrUExnMkM5eEtVelkzUmdxNURpb2RCYVFVb1Q3OGpF?=
 =?utf-8?B?dmRxV1FOZWtYUi9Eai8wU3ArWW43VWtGMHkyTnFlZXRtTVArZ2FmNEkzWjBH?=
 =?utf-8?B?ZDhPMTRVQUpCQjZDWWprU3IyTUFuT0x0dTFYSGlZZ0p5Ti9pK2pJNXpJc2U0?=
 =?utf-8?B?dmkwMk4vUjB4NGdVM1pPYTlhOVZPVTIwNmRIaSt1bEt0UFB2NzlETXNJVHNH?=
 =?utf-8?B?eGlPQ09saFFaUHlyVFFOS3BqbG5ReFdINDdqNmpPdUl5eGwwSTc4YXBLR294?=
 =?utf-8?B?Z1lJSjZlTUd3WHlXSDlnQkF2RldKOUhZL01YUFFYbUYwdnlTdHI0QTJMbWIy?=
 =?utf-8?B?eXBudklXN1diZ3pGQTZ6QU50Z3gxeHYveVVKYWdiNVR1Q1BINkUwS3VMVXJB?=
 =?utf-8?B?K284bDRRRm9LcEJqS0lkc3FlZ1BwN1hyUDlDZ09pRmxjdWJoWTV0TThvWHBK?=
 =?utf-8?B?RzhyenRZWG02aUE1UUhFbXVNQWlISnBGOTlzdmhjbFhWSzdxR2RJdFFpRWtB?=
 =?utf-8?B?dWhGN2doSnJHUkszc24xcFRUY1pRQ1VDcDRtRXVUQkYvV2lXM0RDZkFldXE4?=
 =?utf-8?B?UnFBQUtkSk13UWh1Ly9idGd2anhiUE1ZN2tGMTVvWGpEVldnRGlSRlZDVXNt?=
 =?utf-8?B?R3N0K0YrV25tZWJYL0xrbFp1UzNkQkFja25mTURGVk4vSVNmT21wekdKd245?=
 =?utf-8?B?MlM1YWlkdU9FRzBPTWFZSUtWZE9YUGFuRzR2ZXFkQW54eEFUT1R4ZXZqVXFK?=
 =?utf-8?B?KzNTeVovbDV1VjBrUGs1OWZIeUgyUGxDTWxMMW1wQW9Da2xrMDVVV2FkaHhy?=
 =?utf-8?B?emJDVy9NWEFvWTd0SFRPd1BKVDdSZXlMZDZNRWVpMTVCY0wwdlIrN2EwWVhO?=
 =?utf-8?B?N1pNczY5UlpINDJ2UmI4K0ZDQVpjVk53RXlqbHpPc292blJIekY4dUNKU0l1?=
 =?utf-8?B?bU40SzNTL0ppdHpBV29kc2FkZ3FZUTVyWmdiSjJXdkZ1Rk44TFBOZWVXS0tr?=
 =?utf-8?B?M0gxSDRmamI0OG9FdWIyNTY2TnNtRTExaTdDTTFwUXU2RVhSZnZvSzBWYm5x?=
 =?utf-8?B?a1ROYTJVck01WFZEVVlMTUl5R0ZINUhwZEJrelA1RS9jUGMyQ2w2dzF0Tk9j?=
 =?utf-8?B?R3YwNDNKMUdFTmp4TC9NY0o3dFNReklpZHg5QkxZc3lrcENrY0VGeEI4algy?=
 =?utf-8?B?N284Y1hXazNabTJTd2JueEI1VEZyRi9WTlVPTFpXTndxQ21yWk51aVFGdGUy?=
 =?utf-8?B?OUdSZVZQdDk3TWdaclJKN0hEaWl3RUIzVEFiNGVWTCtEMTI0ZWoydmxHY2VC?=
 =?utf-8?B?T0dmejQ2S050REpIMXVXSU9ZMENTS0lzaVFoVmwrYW8ybFRFTmZOTWZ5N04w?=
 =?utf-8?B?N1ZGS0JRcy9rTXRsT1VCTWVLbFcwaUhqNEoyUDRQMjdWckhFV0xoNkc3WmdP?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bSgOgxhPWOCL4qe3ZuueUYbK03HIitFjbNnfqfPK5N//xMo16a3CdxT9WyhX9mCkjxfiQD9VF8rVKTZLJwgAN01KhXvxjNn10XLiYhRx482LSJowBrhrQypPSjmHwIK8EFR6Rgx8uohO/2Mmv1Mr0lS2o5UHvJeEutw0fMWuiRF00gP7FlZkUp0e+EF5wiK6iq3xqPi4vfir/bj4sGv48ALwKq134w6FJPdTcSzXlW/R12L1wGLqojnI2zY9pKHBOlWh1MF4A+XPljX/j46+yIpJlb1a1P7PjPRQ8BnEBTjRMVXDdORZJCSyFy/HJ1m04aXtymXBzpo7q9HrG0QrBK6Jyi3MhkC7MgrfDDIHylbIblNxLZs4yvfAFg2wPHg/BEVs5wzlu9RdLj9wq24/Z0/wh5TIqjkS3IVsYt1JgGWW0Oe73+H2taJL8tINiCzHzKSHTqHYdHElLfp6kNpy6aNM6VVjLBOx0S3A8JNHEs07NbrKhtJQd0Iw1MrvoTPEBiudtFKXQ5iv0pMH2KjNww6gm1OYpMZZDczlrjSelctdO7AWG122/7ISsOa76FcZ++nRg9XVFdWjEplnw4XIq5QDKKtSaoyC9nlsUN+D4Hw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf3b5a6-74f4-422f-24c2-08dd510f8d97
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 18:02:19.9055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vL+3mO5RFKH6Ly+R6PdldqhsXAfXtxo8lE9/PNhcON2EJdcEai9z4VJTFLJGFjq8Sc3A2d+VZCRbn//zMyeLfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_07,2025-02-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190139
X-Proofpoint-GUID: 7dhh9lyJIoEVU6L1MLUAnX8QTeWWYGIb
X-Proofpoint-ORIG-GUID: 7dhh9lyJIoEVU6L1MLUAnX8QTeWWYGIb

On 2/19/25 7:54 AM, Blazej Kucman wrote:

> On Tue, 18 Feb 2025 10:50:46 -0800
> junxiao.bi@oracle.com wrote:
>
>> Thanks Mariusz for the review and share the test details.
>>
>> I have sent a v2 to address the code/log style issue.
>>
>> Hi Blazej, can you help review the v2 version?
> Hi Junxiao,
>
> Sorry for the delay, I need some more time, I want to run this through
> our internal functional testing, but unfortunately I have a CI failure.
Understood. Thank you.

Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C42D26F47B
	for <linux-raid@vger.kernel.org>; Tue, 18 Feb 2025 18:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739904658; cv=fail; b=Ic2f4fL06SAHM4yd34ofUQM1aRlc8oB6u1wVCtf3CoafpA227gReSBaqxQ9A77G+L01uRzIiAuAeRZxvJPMYWmdWL7vavzLRaSCwoc+wb1Cwwlp8Shapy6B1KVydPSvR5yUZX8awlo0K4U9mDKoiriWnBRp7Ui62aAQh/kcEJ8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739904658; c=relaxed/simple;
	bh=h+mz4SHkHMrLMePimFSbEYRf4ZE1+OEcIqa2PVa1VSE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WXOl+dYSTZzILuCnuqAaweN/iphrrBlj6wxQGNv4LWaiSUoB+BVt5SXT+x2N7oNxE5FR5iXNEB5oJ5mM2d/IfAFIn92MjziMm0WY1apK4AawV90hHF/lqa+Vb3Z70ZCgUFGahx/+drQ7PuhTp8BLtmZc2pLc/HWCBJja5QWP0jw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LpI/hFVN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qAWX01NF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LpI/hFVN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qAWX01NF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IIffVS020060;
	Tue, 18 Feb 2025 18:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=BSgbDB7yzuDtxWKF94jBW0LskEn2eqDZMg3n4JQHHbw=; b=
	LpI/hFVN2uNiJvSh8yGF5XsPvpmMHvOv9FWTdoDad9w0TJWYlX9W3hMxxykA6foC
	d2uPQk/MfdHs3j66pdtCnKxFNZ9Fo/Dyy7GuWl0ZH8VwN18Xxl/EAsvwVqSfIJYB
	haRJ3yoO4iTsgzfLxx5W4rImqVFb8U4zu8wZIdz2fv6U1VNjhkxthm8ec8VT1/7x
	Fl5XyeGdKCVT5jluMc7nif4CH1ilcoszn24jVilGXKUe+IGAWydRTbQHkJ/EVupX
	je3aUxSpgjQku15Zj398uSvV7HI/qlVgQ9N+kspVmcShbGaZ5QlSfvj79EXiu7L7
	DhzTSidQBnxKduogJrv6yg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44thh07b3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 18:50:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51IHLvDk025056;
	Tue, 18 Feb 2025 18:50:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44thc9eenc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 18:50:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TFLBSVSbBieVWZLXY0aianvBWDqMfIsx5K/m92pmAjVzuaM6kA6EKwTxIUJSEuK/H8jl9rw6tyICQkJgCQgGQ6qArqww1RZAz295wJy8ddDnSy38LGCFqM/B9mzCgRiOW14FvPHOtRFwk4x8FabtrPGAhzyqkbICeTm6t6XGvIEmW35lohYUcTh5bImc9lXY4HhWqUnsCG0He3oZ4MWfLEHzEkbcXbK5rD6DY0dYWvzztNVYtWUa3W+f34+U6CNYg4wxoj0DNdHO5R9wLvNe1+eGKzwdui6R7QFc29JH4HKTVV5Hk0H2OtfELsUMtlIpUEcixD5Unjj7eygrE9ykag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSgbDB7yzuDtxWKF94jBW0LskEn2eqDZMg3n4JQHHbw=;
 b=VeOuaX5Tzt9I01KuDxB6DDA/RtdqyNwLyBAZlWVw/2ZmLnwh0GyJOtX56/7FQbGmMQcLSn/lh1P2RmSfO5ntqThYtxBJXPqlV5NvJro/z25cQFTehEk13laF57DLyP6vbkeEjTfY6166kO5cgkgp6gVOCGe8VEjxv0SfHMf/STe52d9pr3BMtlYJEYwhzgHuCib65rIKLNeavfgZrUF8wLbUI977R/EA7nRSZhjzMDDvRuHlTdoAqBTW4bV6Gl/rOlxI3z+xOPPXYpltscZ0XZghNaiktkUZIHrxghM3KWS1ox3Mnp0vRBIBHGXFZs/Ue8xCnAHHZia+aW7ugtz0Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSgbDB7yzuDtxWKF94jBW0LskEn2eqDZMg3n4JQHHbw=;
 b=qAWX01NFvVVoXpTobLVe1S8Xlq8NHvtpPh//zpWHAF0UL0k92UNcTWE31dvrlyKWs9scoKfEyPPSgGPJq+77AEfYI+0XNlAKyhfvKcqokM+iugfI5+NPDnFEozY79doebc9N3RwXM8mt7m/h0f+P1gyn5VyyD/6F9rLG4pA2pVY=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by PH0PR10MB5657.namprd10.prod.outlook.com (2603:10b6:510:fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 18:50:47 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::a472:6f6e:39dc:d127]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::a472:6f6e:39dc:d127%4]) with mapi id 15.20.8445.008; Tue, 18 Feb 2025
 18:50:47 +0000
Message-ID: <2170b01d-33a0-4cc5-984b-3e0d91f42e9e@oracle.com>
Date: Tue, 18 Feb 2025 10:50:46 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mdmon: imsm: fix metadata corruption when managing new
 array
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>
Cc: Blazej Kucman <blazej.kucman@linux.intel.com>, linux-raid@vger.kernel.org,
        ncroxon@redhat.com, song@kernel.org, xni@redhat.com, yukuai@kernel.org
References: <20250210212225.10633-1-junxiao.bi@oracle.com>
 <20250212110713.1f112947@mtkaczyk-private-dev>
 <20250212225016.000060d9@linux.intel.com>
 <6d5c8902-ec3b-4d2e-baed-c926ad99cd8d@oracle.com>
 <20250218192228.2997b2e6@mtkaczyk-private-dev>
Content-Language: en-US
From: junxiao.bi@oracle.com
In-Reply-To: <20250218192228.2997b2e6@mtkaczyk-private-dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::13) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|PH0PR10MB5657:EE_
X-MS-Office365-Filtering-Correlation-Id: 63d0a1fd-67eb-458f-ea55-08dd504d27ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTVNYkwvWjAydmFIcGFoRGwxNlBrbVl5WDFRNzNkaVQwUnZma3RBbFFBOHJl?=
 =?utf-8?B?VVRvc0JXSXRUUEhBTS9PajdGVW9vekRkNTJObkI3WG40Y3NrOUcrMW1FZit3?=
 =?utf-8?B?ZldqaXl6ZVJBaG5taHNjSUhHMzBOM1BpTFRqT09WaVU0TjBMTHJPOTRMdFdu?=
 =?utf-8?B?aENKZ3l4THVHV2hmWUd1aG9GZjdYYnAwa3dJYXZyNFVYV2tCaGhRZGVDUzRo?=
 =?utf-8?B?MlZXdVNTT3lMdm14Z3IyWmJiTEFVQXlWTGpXdDRnUHIrN3ZhLzNqRXNJMXdK?=
 =?utf-8?B?Rkt3UzRRU2pMQU1PNjN0bjFzL0JDWUErVUNoamVSR1kySzVPTS9LbDlDemdL?=
 =?utf-8?B?WllwT3VvVThTZGpmVkxDQjJYSnI4dEdEaG1FT2ZMMnhFOURYRWRNc0JBem95?=
 =?utf-8?B?RUJZS3Z2T3Z6NFU5TEJmbXFodlFUbmsrK3I2NGJSZzRtZThESmNHNlpGeDFk?=
 =?utf-8?B?SUJHTmFCVzNORmZRM3JtbE5lM2oxazJGVlBsMnIzSEZxU1ZxbXZ4MCtsUzY5?=
 =?utf-8?B?aE1wc1BDRkRkWXEzMzJnQ29KK3pxZFVTZkxlS0xrSEpoeDRscWNpZ0FrRi9l?=
 =?utf-8?B?Q21GU3NOSWhXUmZDdE9tN3ZwVzQvdkNvcngxNjNIemk1bGFwRkdjQStqM1FR?=
 =?utf-8?B?T3hUcWRyK1BLNHlGTmxIZUhQeTJ3YnptYTN2bGdxL2VwSnZLUkhiMjJPR2Fh?=
 =?utf-8?B?bC9TNy9NOVI2UTlQYzVNMFEvelpUdWR0ZWtSK2xTLzdpREVGY3Z1ZTJHNUhj?=
 =?utf-8?B?ZWhZaGtqMGZac2loZXkwNXBnRUlFKyttK2tNWXQ0N3hkcEZ6T1NKK0VDbFVt?=
 =?utf-8?B?eGVIbkpLT29QZ3h3WFZ5dFFVbjF0MlhoVlphTzBGa2lNU0pNSEJRNllyMDE0?=
 =?utf-8?B?a0x6Rk1JSWR5bzFQTEdla3UzMTUrdXFZd1NGQkJIUlpGSGI0aXppdFNzdWdl?=
 =?utf-8?B?OGJCSEo2RndaZ2ZCR3c3cVdMMEQwdURZWEMrYTNlZnVWQ2JxMVZZRG5lV0Zk?=
 =?utf-8?B?dlFNbnR2ei92TmtUWkpRaFYrNGloV1ZMb1cvZ3ArZVI4SmdycjNnakI0cnZN?=
 =?utf-8?B?WGFVOGFQQkpha0QzdUY0RXBwMUNQU0F2RGZRZUFGdVNFTDNhQ0hMK1ZINkcz?=
 =?utf-8?B?dGtQaGlmNG9GYVJTVjNDZGY0U0hDVTNjMVhoT1JEcVh0UnFUdnJmOThTejJB?=
 =?utf-8?B?dER5bHNlcnh4aHRiTk5TVG40SG10OHpxU1VXL1JqVElmejhYOWFUOGRkVmNX?=
 =?utf-8?B?SmJKazBJVlZIUHJxMExyRHpHcWZjbTJOT2FSeXJqWCtwWjA0RlRlUVVSME5G?=
 =?utf-8?B?UlZFWXd5UENPZHRFY2JHM0pxbkRUQVBNTXBSVG1KVUZucjJVSTkwYXNjcEJz?=
 =?utf-8?B?aktTaEVjOGx4a09ZUHg4cVVFbm8rVmg5OUlBaGwxUEpQOFgrQ1BTMGZFSkJv?=
 =?utf-8?B?Wi9WLzVZUDJkeHpvRk9pTy92Ujltckc4T3NWSFlqQ0NIVThhN2trV3gwd1RN?=
 =?utf-8?B?Tm1TYVVMUDVLVWVFQzY4bVl5d2d6UU9qdVJtTzN0TVM5aVRuVDkyNllGanBW?=
 =?utf-8?B?TUpnWUI1QU9FZFlhS1dic2VCQU9VTWZ3MmRkc0NINW1XSnROSG9oZXNVYVJw?=
 =?utf-8?B?L0RYZTJqSzRZamIwUFlac2h6L2VkUFBVMVZBcGtWaEs1T3FpN1g2SFgrM3Zy?=
 =?utf-8?B?VU92a3ZYUnFnKzJVMC9pcmo2aFFkYjR2NGw1QW4rUENXbis4eUQvMDV6T0JK?=
 =?utf-8?B?aGNPTUtsMG12QTdwYVF3VVdRQm8wQnM0Mk8rYWUvZm5jTHVEK1JTUmNkcmFy?=
 =?utf-8?B?L0FzbjhpTElwV3AwYjRua2pmL3pzOXV5dlNjdURjQnFuOUl1dUlkWEdROVc5?=
 =?utf-8?Q?+xWMjb2z76N5o?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUtxNEp4WXZHMjY2WnJBWllUNG82MlVkQVA1TCt5NWRVUzg4cmRoSHVQNDFy?=
 =?utf-8?B?S3pFL01NTDRKZjY2dU5DZkZaYnUvV0RiTis1aGtvRlZ2QnpId2JMb1hFRXMw?=
 =?utf-8?B?Zm1PUkg2TjhMam1INDVnekVBclRnSDF2cDhqN2pyRkZGYUhySU9MNzlRT3JJ?=
 =?utf-8?B?N1ZCazBLUFF3c3A1UnNkREhRQ1J3ZWxBRzZiaWNRTmNEbFRZVnVnT28wUmJu?=
 =?utf-8?B?QVRmZURmTHJNZi9CU25NQWFiWnEwMzlReG94WjRkZnBSUGpmZUdZMjlRc2Qw?=
 =?utf-8?B?clRnMFFJSUgyOGF5b1RwbkY0MFlsL1FlTG5MTURZRTdCdVpIdEkxZlcvdi9S?=
 =?utf-8?B?UWtFamRsWHdETEY5RTN4clY1bHZrclR0b3pIa1kvcHpaVnV5UTBWYytReTJM?=
 =?utf-8?B?OUo3RUZpYUJVU3p5ZVJuVUxidFZsNE9TckVUSC9qZjJ4LytyaDVFejkwWkpN?=
 =?utf-8?B?NENVN3pta0RhbEprZlBST0xoa21obWdacWkxWUsxVHRhYmVwRCt1YTViaTE2?=
 =?utf-8?B?ZEJkaU5WaEkvTXA3QmJrVTRrbFNjMWdTTlpyRk5mY3ltb3grMllWMGNmcjZX?=
 =?utf-8?B?QWh6ZndGR29mUG5nRWNqanJGd09HZ21kKzMrK0dlbDZCTkx3Q0Y4QzZLZ0FP?=
 =?utf-8?B?eFQ1Z1RFOUFJem5vWFpVUllzcGJhcERwRzVOZ3NqUXJlakhKOWFJc0tGM3Nk?=
 =?utf-8?B?aUZKS0ZqUmNuc25nbDNaci9jcFlLdG5kc25aS1VpQ3A4V3NVWExIK3BKUWFu?=
 =?utf-8?B?RHdsY1VDMGZBcXdGWHVxSWU5Q0Q5Q3Fqa0lQWmgwTE5DcTlKNmFRN1Evc2F1?=
 =?utf-8?B?QkRJSDR4cElsekZCc1E4aVZpRE85SGNzQ0M0bDNkUUF3V1Q3cnErREFNMTJL?=
 =?utf-8?B?Y3VndmhsMFlrbW9vSHFkNTMxMWl2M1VGWjhJT1VrN3Z1a1ozL1ZWM0c4T25u?=
 =?utf-8?B?cTc2MWJqb0RDVkJEaXNWK08zeXYwQU5SOEdCQW00SWdlRThWU25Gb1QyT1E0?=
 =?utf-8?B?NG1NZnYvb2dqemlHTkRUV24reGxkY29HczlFUFcrQkJOdEV5eUNtbUJvSVpz?=
 =?utf-8?B?Zjd1L1U2YTNrRXN3MjZqRUpLdjNVRm5DN1AwMWhqRlNibkU0RFBNdDhnRHNp?=
 =?utf-8?B?YXhFaUVrVE5FUTk5WFh1dW96dzROaEJEYkpxRmxBUFVlQzUvZjQ4a0hrZS9y?=
 =?utf-8?B?MnVkNm1lckE0TTdQQ0hiMXBJZ0psMmhpSUdLSjBFMEVRNnBVaGtMbmlURFp0?=
 =?utf-8?B?cGd6RkE0RmNnZE0vNktNOHpsd0Z1RjJKa0tLUWFFK1dkaWtnNzVCek5JUDlC?=
 =?utf-8?B?aUFDWk5OeTBKU3MrME5sR25lcFh4ZVlvQ3RQUWFjbTFwYmY1K2tzbEFMQVV1?=
 =?utf-8?B?K3Q3K3FOb1hldS80Z1YyUVB3eGIyVlk4NXJtT1FqbzIxcnRLTndKV0lmUGJq?=
 =?utf-8?B?aUJUVTdDZUwyNUhBS0lRUVJ5NERBeWJLc0x2TEpOVjc1MzUyRzNRWGQrQ2hR?=
 =?utf-8?B?Yk9iZnk2WW05Z1BnTkdQV2dpV1Nhc0g1Vk95WXg1OWo0NDhXZnFLbHJ4bHVz?=
 =?utf-8?B?eHdxYmlTSUZrY3EraVJDMmQ2bUVRdHRyL2hnM1F3elNiK0Q0NXdLY3ZrMHU4?=
 =?utf-8?B?aTdRWHRlZ20zaElxNU84QTdBUGgwRE51ZnlXTzF4RWh5Y3FNSGJ6UGZ5NWdQ?=
 =?utf-8?B?azAzc3plUzZVMzJ0NEU3VldOdkxDWmtxcHk0UHNnbVQrMUNuUzRxWUlEdEJU?=
 =?utf-8?B?QnBJZFVlRHhCTk04d0dRV3Z3Ymh0NXBBaWs0ckkvekRBUW9zZDRYRVNEMWo3?=
 =?utf-8?B?ak8vU3NpZGhidHNSR0xOKyt6L01kMGhMckpZaThpUVZrT0dNVHMwWGMweW1P?=
 =?utf-8?B?cWExMWFjSXVWcTBseFluemhvd3RDajFEL3RXYVNrWjNBcHNHclo1ZjFJTEhI?=
 =?utf-8?B?bFIxaHIyckdGZ1JTVVQzeDNSME5xa3lLTnZDQisvaDNMbDdFMzRNZEFSK1RS?=
 =?utf-8?B?dDhFQktSMS9FNkVaVnY5OVFTcUx4d0t6c0cvTlA0anllbHIwVkkyeVBvdy9G?=
 =?utf-8?B?c001dmJSMGpGLzNIQnlPNlF3bUgrMVcrSXF6d1JPRmFWZU0xNXFOMlp1dTdj?=
 =?utf-8?B?QkVWenB2aGR3d0VOMU1pZUlyRnNMQVZUNVJ4QkoxR0xMTjA4M1VNbGpWREtN?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yLeuoO114y2+3zZEjFzIYRgvRaGILYi2DRgaxhr2QsLzV756G8wHfKUiS2hT0kGxn1Y/0H07DeFrb9HgTxhoDauQXzzd0Za3MtIpVr62wgaMs9A5nPJT6aI6jileGdfPPIZHXmMgvy6ua1WS+XnfFOBREskxfmn58DyOUiKDaILEVbkh54EtsFgn0ffaz/9/WfswR4/Y89u4a5ZhDVqDTLc9rbjk5kO9D2sNgc0mCOyJ3c2KLCrxMZdKtrhEbL1qIYUAtQQMuJbWkzTlyrbum95NzYUWRDinrFdUrK8pqg2ogXSyQ/K3ASJCSIvUKlh7m2jACJFpPurnXIBty4xFH4kP6TmICTcBVwVqXdlcIpuEwM9zNbNWqRZb7QHTsYqPRM0Ttb9Agjf0lawzF0767UG3BoQcI3xLG+U9yOBQ+aqmOxR+fZADnizvYTMx7Vs1MJz1r1sVxBk3dURbkvlIo/BQ2ZSZTloRC9w4WuX9fN3O4Ic8fIxpjrCF6Mm9JJnNSd0aVlciPU53+7eHrZ955mpSJHO+7vowwR121Y+RbIot/rRtrJOcBXYNnTskQ888gBuB+qXUunXCE55kazX6jTk8Ib5tnOF8F9+7faNIR6Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d0a1fd-67eb-458f-ea55-08dd504d27ee
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 18:50:46.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUMOe428X9T9y9H674K753QdVIZmV67/UGaalRae0wkO0Z15zWKK9kji3+15JnTBJHt05bADC0hNEVggFTyL+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5657
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_09,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502180131
X-Proofpoint-ORIG-GUID: MQXCOObK_eIQofokVFxeRN7c4dDz6tEG
X-Proofpoint-GUID: MQXCOObK_eIQofokVFxeRN7c4dDz6tEG

Thanks Mariusz for the review and share the test details.

I have sent a v2 to address the code/log style issue.

Hi Blazej, can you help review the v2 version?

Thanks,

Junxiao.

On 2/18/25 10:22 AM, Mariusz Tkaczyk wrote:
> Hello,
> Sorry for a delay.
>
> On Wed, 12 Feb 2025 22:38:13 -0800
> junxiao.bi@oracle.com wrote:
>
>> Hi Mariusz & Blazej,
>>
>> Thanks for the review and file PR.
>>
>> Please check other comments below.
>>
>> On 2/12/25 1:51 PM, Blazej Kucman wrote:
>>> On Wed, 12 Feb 2025 11:07:13 +0100
>>> Mariusz Tkaczyk <mtkaczyk@kernel.org> wrote:
>>>   
>>>> Hello Junxiao,
>>>> Thanks for solid and complete explanation!
>>>>
>>>> On Mon, 10 Feb 2025 13:22:25 -0800
>>>> Junxiao Bi <junxiao.bi@oracle.com> wrote:
>>>>   
>>>>> When manager thread detects new array, it will invoke
>>>>> manage_new(). For imsm array, it will further invoke
>>>>> imsm_open_new(). Since commit bbab0940fa75("imsm: write bad block
>>>>> log on metadata sync"), it preallocates bad block log when
>>>>> opening the array, that requires increasing the mpb buffer size.
>>>>> To do that, imsm_open_new() invokes
>>>>> imsm_update_metadata_locally(), which first uses
>>>>> imsm_prepare_update() to allocate a larger mpb buffer and store
>>>>> it at "mpb->next_buf", and then invoke imsm_process_update() to
>>>>> copy the content from current mpb buffer "mpb->buf" to
>>>>> "mpb->next_buf", and then free the current mpb buffer and set the
>>>>> new buffer as current.
>>>>>
>>>>> There is a small race window, when monitor thread is syncing
>>>>> metadata, it grabs current buffer pointer in
>>>>> imsm_sync_metadata()->write_super_imsm(), but before flushing the
>>>>> buffer to disk, manager thread does above switching buffer which
>>>>> frees current buffer, then monitor thread will run into
>>>>> use-after-free issue and could cause on-disk metadata corruption.
>>>>> If system keeps running, further metadata update could fix the
>>>>> corruption, because after switching buffer, the new buffer will
>>>>> contain good metadata, but if panic/power cycle happens while disk
>>>>> metadata is corrupted, the system will run into bootup failure if
>>>>> array is used as root, otherwise the array can not be assembled
>>>>> after boot if not used as root.
>>>>>
>>>>> This issue will not happen for imsm array with only one member
>>>>> array, because the memory array has not be opened yet, monitor
>>>>> thread will not do any metadata updates.
>>>>> This can happen for imsm array with at lease two member array, in
>>>>> the following two scenarios:
>>>>> 1. Restarting mdmon process with at least two member array
>>>>> This will happen during system boot up or user restart mdmon after
>>>>> mdadm upgrade
>>>>> 2. Adding new member array to exist imsm array with at least one
>>>>> member array.
>>>>>
>>>>> To fix this, delay the switching buffer operation to monitor
>>>>> thread.
>>>>>
>>>>> Fixes: bbab0940fa75 ("imsm: write bad block log on metadata sync")
>>>>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>>>>> ---
>>>>>    managemon.c   |  6 ++++++
>>>>>    super-intel.c | 14 +++++++++++---
>>>>>    2 files changed, 17 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/managemon.c b/managemon.c
>>>>> index d79813282457..855c85c3da92 100644
>>>>> --- a/managemon.c
>>>>> +++ b/managemon.c
>>>>> @@ -726,6 +726,7 @@ static void manage_new(struct mdstat_ent
>>>>> *mdstat, int i, inst;
>>>>>    	int failed = 0;
>>>>>    	char buf[SYSFS_MAX_BUF_SIZE];
>>>>> +	struct metadata_update *update = NULL;
>>>> If you are adding something new here, please follow reversed
>>>> Christmas tree convention.
>> got it, i will move this new variable to the top of the function in
>> v2. Should i move variable "buf" to proper location as well?
>>
>>
> Either way is fine. I have no objections to do this.
>
>>>>   
>>>>>    
>>>>>    	/* check if array is ready to be monitored */
>>>>>    	if (!mdstat->active || !mdstat->level)
>>>>> @@ -824,9 +825,14 @@ static void manage_new(struct mdstat_ent
>>>>> *mdstat, /* if everything checks out tell the metadata handler we
>>>>> want to
>>>>>    	 * manage this instance
>>>>>    	 */
>>>>> +	container->update_tail = &update;
>>>>>    	if (!aa_ready(new) || container->ss->open_new(container,
>>>>> new, inst) < 0) {
>>>>> +		container->update_tail = NULL;
>>>>>    		goto error;
>>>>>    	} else {
>>>>> +		if (update)
>>>>> +			queue_metadata_update(update);
>>>>> +		container->update_tail = NULL;
>>>>>    		replace_array(container, victim, new);
>>>>>    		if (failed) {
>>>>>    			new->check_degraded = 1;
>>>>> diff --git a/super-intel.c b/super-intel.c
>>>>> index cab841980830..4988eef191da 100644
>>>>> --- a/super-intel.c
>>>>> +++ b/super-intel.c
>>>>> @@ -8467,12 +8467,15 @@ static int imsm_count_failed(struct
>>>>> intel_super *super, struct imsm_dev *dev, return failed;
>>>>>    }
>>>>>    
>>>>> +static int imsm_prepare_update(struct supertype *st,
>>>>> +			       struct metadata_update *update);
>>>>>    static int imsm_open_new(struct supertype *c, struct
>>>>> active_array *a, int inst)
>>>>>    {
>>>>>    	struct intel_super *super = c->sb;
>>>>>    	struct imsm_super *mpb = super->anchor;
>>>>> -	struct imsm_update_prealloc_bb_mem u;
>>>>> +	struct imsm_update_prealloc_bb_mem *u;
>>>>> +	struct metadata_update mu;
>>>>>    
>>>>>    	if (inst >= mpb->num_raid_devs) {
>>>>>    		pr_err("subarry index %d, out of range\n",
>>>>> inst); @@ -8482,8 +8485,13 @@ static int imsm_open_new(struct
>>>>> supertype *c, struct active_array *a, dprintf("imsm: open_new
>>>>> %d\n", inst); a->info.container_member = inst;
>>>>>    
>>>>> -	u.type = update_prealloc_badblocks_mem;
>>>>> -	imsm_update_metadata_locally(c, &u, sizeof(u));
>>>>> +	u = xmalloc(sizeof(*u));
>>>>> +	u->type = update_prealloc_badblocks_mem;
>>>>> +	mu.len = sizeof(*u);
>>>>> +	mu.buf = (char *)u;
>>>>> +	imsm_prepare_update(c, &mu);
>>>>> +	if (c->update_tail)
>>>>> +		append_metadata_update(c, u, sizeof(*u));
>>>>>    
>>>>>    	return 0;
>>>>>    }
>>>> I don't see issues, so you have my approve but it is Intel owned
>>>> code and I need Intel to approve.
>>>> .
>>>> Blazej, Could you please create Github PR with a patch if Intel is
>>>> good with the change? I would like to see test results before
>>>> merge.
>>> Hi
>>> I've added a PR on github, I'll review this change by the end of the
>>> week.
>>>
>>> PR: https://github.com/md-raid-utilities/mdadm/pull/152
>> I see this error reported from PR test, may i know how to access
>> these two logs?  This fix is for imsm, and ->open_new for ddf not
>> even touch "update_tail", not sure how this could cause ddf test
>> failure.
>>
>>       /home/vagrant/host/mdadm/tests/10ddf-create-fail-rebuild...
>> Execution time (seconds): 46 FAILED - see
>> /var/tmp/10ddf-create-fail-rebuild.log and
>> /var/tmp/fail10ddf-create-fail-rebuild.log for details
>>       /home/vagrant/host/mdadm/tests/10ddf-fail-readd... Execution
>> time (seconds): 27 FAILED - see /var/tmp/10ddf-fail-readd.log and
>> /var/tmp/fail10ddf-fail-readd.log for details
> It is known problem, so far I know Nigel is looking at it. There is no
> fix for now. Execution timed out and logs has not been copied for user
> as expected.
>
> Here you can see the Nightly report that is executed on top regularly
> to at least determine if fails are persistent (probably not caused by
> your change).
>
> Sorry, it is not yet perfect but at least something :)
>
> Thanks,
> Mariusz

Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F2E332EBB;
	Mon,  1 Jun 2026 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780305094; cv=fail; b=EO+JRPindH1qFfcZHxHHVaQ42qEeskDVALuSoYuWaGMQl3k2ndsI4/9MoCavi8k9+jNoaEeVtiXwo+EW3SBXmQCcpIJQacOGOYVGotOsPBOSA70HIPdBoYAF75DYLeXpYDEkz/HVHqelr8yQ/vRWGsGJnZfAQMnXJ2wLRkCjp8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780305094; c=relaxed/simple;
	bh=zk2ICxM8Prd9byywVJ8qAvVlKdAl2jD+v9LfVK66ygg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kMz/kJ5MqcTb0jgGGVgTOYUXq+NdB2MnNeDAkO0jMWiW/dKGpLN2I4NYHyBoPmz4OUj9n91sxbqJ+DvXc2f2mobNO6NL+R6BuIVECGY9I3ZBMsAjEIOgLnWmBOFL1QNXvhM0Mn3s7vQF2vxUiwO2/77QnJU2eY6z4UUeDVG0COw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o4Avg1Rt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WSZmjzzm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o4Avg1Rt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WSZmjzzm"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6514OAnJ1832591;
	Mon, 1 Jun 2026 09:05:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5700G7p9jWaaDUHDG3RsONvps0OC8J9czFEkGfDBay0=; b=
	o4Avg1RtULEX/FlWbRsaWyA0iZKhsN3RMUCM+cFC0c1xlRirsRwK1ATVYZ2TDCUc
	twewXCl8oxmY5B3hsTHh0QvXHdkvM+rnS7pCDjal0JNGKqZsJwS+ulkqpTHgM4cN
	8LoXdtJgpskDVI9u4irP3ZvoRcq6ufJrucDNmbzBtCgSwDREpmx2XjhfVmUbAKA+
	VJ474HxMYr9ZubhQ2e9Ff/lNcsIodw1hNZjA6jUgDj16Stv3Sv9B6s2GcBdR9t9z
	szOmV3JhfO/BaWy5geQBk6AZLpUytnEyAvaIu26ZCJiO24Ar5uZaOm/UBx03a1x/
	najqbl7/ZMJFnoMrPzT8vw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpfxswmt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 09:05:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65194qIe026441;
	Mon, 1 Jun 2026 09:05:57 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011019.outbound.protection.outlook.com [52.101.62.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbb71ew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 09:05:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gj4ZgIJ5jgr1nCgb3JGl0BHMl2MlqLk5RDwFPpGJirNB5PdOvwMrU8AW534+gk+28KV/EIuAgCw/uJRFXZt3/Av+oGtx3MKVI7fVDF6MZ6R019fDNCE/PDu4K3xgaleGUZuN53TpDM3YSETVDC+u88lSMwulH9xID+JyuhsYyVqqlWO4fWvmHy4YbthF19Gjrofryxszon9MfBmCWr8R6lsh+k9zHwu1WxNWRkwB5sWv0CqxoxW5JKN4DOvGGiVRSlIqc3D0sRnPoLJ/QSX0ap9OLExafdf3pPPvAoYeCvx55EG1A++ZdIXbAZEy9QS2j0NLoKUV6t60Ry0xUXG6iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5700G7p9jWaaDUHDG3RsONvps0OC8J9czFEkGfDBay0=;
 b=IibiZsO3O7SDdsjKWd3NvIhI3pRhFisGzGsbQ31fcW479+mzOwUrTbT2FGVRdXpiaVVV6inbi3IpaqW8KzH6dhQ15SJ6IgbRA3COcY5xk13BlKyKw4iMy5RvXcrgJ6yxCXkNA2dQydWxUqi2R0jYdr9LzXGbIARdYJoBeiHJYBrwbf5AvzDDh0QfK/waEeYh9q137Nie6y4r/FWuDAcqtzO0uxpsPGI7pQ3cMSRYnFDzwFQevELbaHidu3/ZKXUAYdBSLZ8lXGV1omI/dVLU6sKhFTpNunOU1VdBUKjj1kFZ33vN/0zIG0Nl0WQuE4raMrFKdP5CuRTAtZJA6UynsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5700G7p9jWaaDUHDG3RsONvps0OC8J9czFEkGfDBay0=;
 b=WSZmjzzmX/UsJK6EWUMGCTkBwusu2jVwNwL0x/uRTSaVIEXg55d3CvRLQGCNWF8bw1r1R4WpGI15IdqItZmAK9iGohrtKG/UHG73uJq0JfdHtBr7kKpCx9l4deZb9dWLkyJIGAoPD+um48wFMlOs6RJXwHXlIuisIyDipD6vVdE=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH5PR10MB997759.namprd10.prod.outlook.com
 (2603:10b6:510:39e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 09:05:54 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0071.014; Mon, 1 Jun 2026
 09:05:54 +0000
Message-ID: <8f8ca66c-aaa6-4b51-bcd7-54203603ba8a@oracle.com>
Date: Mon, 1 Jun 2026 10:05:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] raid1: fix nr_pending leak in REQ_ATOMIC bad-block error
 path
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fnnas.com, linan122@huawei.com, martin.petersen@oracle.com,
        axboe@kernel.dk
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260530151411.4119-1-abd.masalkhi@gmail.com>
 <d9c769f5-19a3-4724-b805-3e2f30541c64@oracle.com> <m2h5nmljj6.fsf@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <m2h5nmljj6.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0205.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH5PR10MB997759:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d893e4f-e1d1-4f1c-bcf4-08debfbcfc14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|18002099003|4143699003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	hXWSDj8NI0lAN3DhoT/q/FLZ164q99kKxsCRY4UvKOktl7f2/t+SbhOBSFWQeKWbVZ1br0WoIlP2aINMaMHXp6TwQYwgWdJOs4fkBnoZ/I1OIaO79idVlSwrr1gayUfIDu7J3r2CDdqjKruoxTGkRKFXWQokNXv64zmX5k7W99j8kQ2u/vVZYtpf7DjQqmxRzUhBwgQZ7eH+3R2ntTDSSr45Vtf7dTDkQ2zO/zvf5dVAHS9pBveJQV8rXQ3a56A9OCMBe1UC91zMJUd5I8mUOi4jXlm+HSSwBTl0T6+ESsuCw2ioxV7UhgGJpcfWqGxBGnD3n7tCssk49XZPtR4LjvHMAqZ3OQUOO1AkW6RJ6LpO2Z8htFQcWHUClM2zWiCoRLr0kxvnKmGe2MjNrJOc86smGrwCS79iLwAF4OWW9di3pv0LpFL801N3b8XQa8u+i1B2Qrg+tBcVRat8KPrFA6l80sJFPH086zra7nQ/FRHDsYSHLsea9zABCFkAPlUKZONCjBxUbAhEDeAjnF/ilQGrShixgbuJVjjX1aGqdheDzRI03flxhORLvmJEzmtuwWSWr64EDtYuFL6D5SztSZNHDTJbfPSJf9Hik3gkTpBnS/qrPhVaoxf4KjSGe9PM5bI8Wl86ojqsnlXcPGpSZtQjFvXioTYw0RYB5kgfjK02ltaeiPTMmC6JI5wUYTDAguZA//yDG//a137ug0Rlog==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(18002099003)(4143699003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RW9BOWlSSjdtYlpLaGo3bkNBSlRnMGJid2hCT05lTHNIdUhxQnc1SE9qenRn?=
 =?utf-8?B?YkNnRHlpcE92ZmFrSkNHU21adUtpdUFBRWdxRldMbnpidlpYbEF0eHFwNTI5?=
 =?utf-8?B?WGNmRDM5Tmh0Z0ZmcEpSY0dudkZRRWNuTURUVEVlemlUVEJodlAvcGhwTkJ1?=
 =?utf-8?B?VDZtNVdtR3BJeG9CZFBmWVdsNU5VZ21TRllOV1B6K0JUeEZ6M1c0bG9vSDVI?=
 =?utf-8?B?WXBuUDFrYnZ2dDcrK3BrQVBnaUdIU1paREhvemRaenZyZnk3Ty9Jc0lNaGFG?=
 =?utf-8?B?Tm5RUDk4Yno3dHJ4YWZWdTc2eVg1VlhyZzR3aXRhb29mR2tJYWlTNmxaTkRy?=
 =?utf-8?B?NFd3NFloRUorMktPU3NVelJraElRNk96dmM5Y21ucmNDTWFFZCtLOUVxTUYr?=
 =?utf-8?B?YVRnWXlqTW43UnJBYmlWS3RLeVdleUlGZ2c0OFpYM0JIT1FqdHFNTnFXVzh1?=
 =?utf-8?B?SnBpbXVzQ2c4cDB1U25XLzQzaXhQL3B5Zm1SbkNlb3dnRmlmaGFFeG96c00v?=
 =?utf-8?B?SjEzUGlnVEEvK1pSU2tNSFdwalExclo3VUl4dFJHWXV2bzZzdmtRNVJEQTRm?=
 =?utf-8?B?c0ozVUt3dk00YW9xcVJiUEpVWEtWY1o0STBleHRmdDNyeGFhRlZPbU8rTWdz?=
 =?utf-8?B?eklLeTRIZ0RmUU5vY21sd1ZsRm5wZUpNalVmd0JHVFppWUppOWVPSFM5c2sw?=
 =?utf-8?B?dStJamVCM1Y5bHhQRWprYm9qWjRvYlZNWVcxTzZ3aU5MVkJPdHRoZGUxMDBi?=
 =?utf-8?B?Q0hNMXE2ZnJDR2lzWUsrcXlvQVEwd2o2QkFzUVJPdUx1N2lRNmc2RWZMU000?=
 =?utf-8?B?dHBaZUxuYlp0UTZPSGtkSFhzWGREUEFzZjU1SDB3ajNLTU4wSVNMYThseFgv?=
 =?utf-8?B?L0xYM1N4RThSZnNkN3RNc0lHaFI5ZkdZR1FnZ1pER1JDcW02TG9oZ1ZTT2E2?=
 =?utf-8?B?MGwvYkdGcmMxdkJDUFgxT3E1Skl0UTB0QjlXQ1Y5dUVFNjQ3Wk1UL01HUVht?=
 =?utf-8?B?eG9WU0toblpUMVpURGFEbU1rTnFUeEJEcG5kZy9qOW5kNXgxbjh3NVFKRCtr?=
 =?utf-8?B?YUJlYnVpSFRidStESWhnMG85eWs3R0U2dGZNM3pmZHg2by96V3dmWWFUemJY?=
 =?utf-8?B?dVhuK2l0WTRTSUxwMlcyWFdRSHM5V0lIeXBUQkRMWmhXb0NGMzZMcEVsUEtj?=
 =?utf-8?B?NFdnZFViTzRvZzVCcFZuWG9QRW1JQTU5Vys0dWk0a0lCVDlhMU1vMkdScmc3?=
 =?utf-8?B?cDB6VWNmM1pnZW9EMzdWdEZjUUpWT1FEVEtBYmFSMWtnamNnRFJSWE9CZGFI?=
 =?utf-8?B?SGcyT2tYSDN3cHBMMzV4SVZDdkFiRlpTakZLTTF2bVBKNTdEcHBQY0pIUzJL?=
 =?utf-8?B?MktvcXVwc1crd0pTUEp2WVpKeVFJZ2E5TVp1RExUUkkrWTh6U0d1b3RERVFQ?=
 =?utf-8?B?V2FqemxHY2ROeVNIaWoyUVJsL1Q5L3IvZ0ZBWnJ4MjZFakR5T015dkZXWE9T?=
 =?utf-8?B?QVpyWFVESkJFbTVpenc5NGpkbHg2TGZEUEVqajhPMjBkbXBtS2pNc2xoak9q?=
 =?utf-8?B?S0tSeWZ5REFPNWM4S2srNEt2MFFzMTJBei91QXJVbytKQVlKczdhSFlhY29y?=
 =?utf-8?B?WlZJelROb0FySTJMOFFWWjU5NjZQbW9CWnhYbGVoQnhaQWdLYkNHYlVqL1pZ?=
 =?utf-8?B?cDFicVVEOUdQeUp4N2t5eEhmMXZaUzJubmM3bWRLUDZOU000eFhyM3FMVGdy?=
 =?utf-8?B?VVlrS0NVaStHbWRPVDdjNDVuZldKOHJDUE9DcDVxZFJUa0c0Ri9qN0ZyUllE?=
 =?utf-8?B?VFRZMGk2VUR4R1dUWlFURDV4b05OSnJrL0ZzZ1RmSDdJcUUvN0k3MkpEeHI1?=
 =?utf-8?B?Z1BxYTM2a053Qi9CRTNSZkw3MUNHeG0xNGVhLzFrOTF1T2pDbGxSVW5TalQ5?=
 =?utf-8?B?aVBmTmhTMk9CNU1vMnIvbENmTnRjM0djbVNiOE1IM00vUVIxekhiZ0JsU2J6?=
 =?utf-8?B?Mk8xU29taVFQRVZTWkVWRERLejdEaTdPbk1FN1h0eEkxbHVPZHlHdHd1c0tP?=
 =?utf-8?B?N0FlZGM0VnltUFFsRE5xNjRQM3NnV01DWmZiS0kvZ2tiUUkyZzlaZnJiblVF?=
 =?utf-8?B?T21PUHd0REdUeWJOV0NTMHdteUhyRlBsNEp0ZU5Xa1JjczJRTVhULy9hZ1pY?=
 =?utf-8?B?TmNmcU9VK05vVXh1ejlFZ0V0dmtUV0VTRlUvRFdFVFdiV0lTajhWcUpwRFdz?=
 =?utf-8?B?d2hIcm85YXJyTXNTS3REL3NxRGQ1VVlvbGR1aWpXZmwvSVRuR3JqS1NVNERS?=
 =?utf-8?B?QjlzUDU4Z0ZQK2drZWNyVW5hRjY1NXBpN1I4UU9RbWNBdTJVRGFnQT09?=
X-Exchange-RoutingPolicyChecked:
	MTqI7oJH6OJnROVwH7S6L3ld6P2jQ/F5KCE2UB5juCvvFClAzw2MfXA0mOLpkkm2qyLkVVA6LQNt6k44O1RaNE04duNW4WmzNlKtAlgC52qtnQmJI0RgzsS3R6OpRLJW0XECZCYojzeww0lGU3RyLFiRIkgxRwLsbUHCDUxFdp/5dLFFvR4KI+3q8j3KCj6v0B25my+4BQUV13FycnuGu9oNibycrTmn4z6Kt7TCfXzMXUH7sNycz8ZkVvlBb6S2Z3FMYyyyYlg8DX8QX0G7TRCu00IMGUoBiUqdUfn1oiWZP9o1lQi4dYzCS69n/sAMGrDlMkbzbh2zHgf//Q/6OA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o0ONCu6HGgIKIjF8fiWaganJECtSoRBMQM+gj3HZhqVNchJNcwaeCDIQCUEnupe93wk4xAGlPaaRtxOmtKUBji1qWaQY3IkQ47G5mz7RIvsqksaNJt2tcomA4G3GNJhv4r18IapQ4E8rR0jRmF4cK0gvCsPlAQvmdrwgfE6/GmFQwlKD8ZpCaBLlvbJEbhifoXM+Uq5nkwpI7Ra4akq64JvmKP/2epuxxNUC7troKEZJ+mK/J635sKorGnlU26j3GlaOCKbNcYXa5VR1PJ0rdkRwYsALMvn2VluDMMvZd2ReRAsCHb8GEhT8nGiu2nrOcDOzWXvZOgHP4jr8xczhQelAH6Mk4dYM1vMPVBt4bqb3JP5SxPGbtebcYAqacc58jywFdQxYYVSbldhBPQmdTMOEP8Mjlow/rD24qgVO0JKBC6CjnrkkaI+u2IufPttsL2rH7qKqikaPMk7HMOtk6DFf3LD/aMsh+Czn+ooAMUZWDxhqH3QxW2wAzX5cgVZmtOdS9sLrvesP8ntartAhfUWJdD+Z3mGCV1lrdO0d0YcGx3Zff5HF3fv9tTnjDfOjVxFhCmD4RDyAz4NhGfHEcB3JbsrE6/eWWc3X/p61Y0c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d893e4f-e1d1-4f1c-bcf4-08debfbcfc14
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 09:05:53.9580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXbgYd5WU5I9pJxENrizV0xhuMn1tFrUMI+DTvHiIx51NpiiSz/8i07TkGaIO6A+zcCYnNBnnQ0e27qWRf+uAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR10MB997759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_02,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=950 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606010091
X-Authority-Analysis: v=2.4 cv=FOMrAeos c=1 sm=1 tr=0 ts=6a1d4b75 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=JAS4JhiUETvcljJG4nYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3-gDPS9S5TIxpii6mN2-iF3et5g4CjKx
X-Proofpoint-ORIG-GUID: 3-gDPS9S5TIxpii6mN2-iF3et5g4CjKx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDA5MSBTYWx0ZWRfXyelToTYeaevB
 ujOlMwbYJ5GgUEqH3MfZdpojraX5YiLnyAdN267mMectQmRWZX4ZEEPGqFtwD7loMu97oc7Z0FG
 P27Iw3KiMOkqp7BMNDNumEbM1Hnma6Lf2bVNk1ZmYTYcxgGMYmWNa6aZC6T13Nubt1m7HLJM7Fq
 vC7EbFTtB3KVx4sQ9Kfk6yUmit6bkpm9wla1vTvFcKM7RYDeXYMJmlGy4DE9wXVL+872OsabTAl
 7zfNsweLKNsuu4+fhaxdrnJ8nFvViDgdNNjhKTMgbf38WHdzdkrnV8qVZV3xAFeg9boJhVt7QFa
 eBl1QJJZLLzUTZcp0l4mmYDGRwL0nvBc3MkfT2sCpwTOCRuvNqAqDzXj2MDAI2eD6essUrTm8uN
 1A1cSR1ym+B3MjXxVE0jdFXPEhni4oVPNkf1yejYbqCj8eXzkzCqL9vAohQE/vo9l/I4CpglTa+
 yPZV2pHYuLZ7Oh6VkQg==

On 01/06/2026 10:03, Abd-Alrhman Masalkhi wrote:
>>> +++ b/drivers/md/raid1.c
>>> @@ -1580,8 +1580,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>>>    				 * complexity of supporting that is not worth
>>>    				 * the benefit.
>>>    				 */
>>> -				if (bio->bi_opf & REQ_ATOMIC)
>>> +				if (bio->bi_opf & REQ_ATOMIC) {
>>> +					rdev_dec_pending(rdev, mddev);
>> It's not so nice that we have 2x locations that does the
>> rdev_dec_pending work
>>
> Are you suggesting deferring atomic_inc(&rdev->nr_pending) until after
> the if (test_bit(WriteErrorSeen, &rdev->flags)) {..} block? The patch
> is already in md-7.2; should I send a separate cleanup patch?

I'm not suggesting any further change. I am just mentioning that it is 
unfortunate that we have 2x locations which does the decrement, which 
makes error handling harder to follow.

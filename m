Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFDE286A3;
	Mon, 23 Sep 2024 07:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727076485; cv=fail; b=Yq02vOczesMqT5iS4tdKpKlUyiyIkckBsFP5QTA/4dudMnSsTmm4dDGrLcJGI6nYNoDxRNh5uOzU7OHTdgRfPGLOVsmWpCsXy0ibosXt8giGvjnhy5xOwHydm6fLUeTnVAh7BJl3eOmMQkBYAAY1uoH4rTmNWdSZC9wjcmpcz78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727076485; c=relaxed/simple;
	bh=X9aQhQKdVmMltOfVKWaHfFHcGX0tUCEcrdJC1mLsRX8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BI8pf68RfX7B47DT1tjVIcmGbDqQabwFH8y25bSCAv1kxLhp0gzr8o0wHbyoUtB++QWyvRxTIYoGuF9odTevBre8T/vFLjBTBLGbMWNJvrxn0FuIRd5YPviuclne7lxuRwk9ZHRpQAVLBI6IGIQ4ftp+F4I7+gu1RXl27pYQMDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NwZBf/jc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I7z0Ht0t; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NwZBf/jc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I7z0Ht0t"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48MMZh6M010051;
	Mon, 23 Sep 2024 07:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=EWPN+bovzw2VkiimnIK628skJx/qm5hrBtabehSubQA=; b=
	NwZBf/jcwW1S4837SgQzbg4rKfVGx/I3SIlt3L0aD21XDNBzSiEtEYmC+TR/V8ps
	tyHDO8NQZM1+VG+vLv06cKQcSMMDugPm7/j91rLj8lNeSOUPNEHbOCLcBHmAuT5C
	oBbd62PZIls4OUjv3/O8Ny1JBsWUcCHX2ihUlyHiyJZd9u3kBqPf7nUtUtCeLftO
	XdMEYT3rEQRzbi4BWgsVpnRLPmZlD5NQm9cUXpuqm1px3E/B8qe76jcknpoG1xdu
	sloKwRxAqIq9RDsEQoGvtcz5+YDdY0N6Z6hIrAREMDqEhElocbGgv1HX0TRnvdWb
	Vh91WdXffbT45w7lKshzAw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41smr13yfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 07:27:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48N7KVdV028307;
	Mon, 23 Sep 2024 07:27:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smkdp6mc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 07:27:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTGwu5vUORuhGcm4ad1Oa0XtDgx4/hSBSbtej0loWXATTNG+NPkDIAs243BIZG3YBZztwj9irhAZjGf9CeBS3BZowRI2kt/zWJK0/gz5kRIurSHiBIhLeR5j7714lCPOGtiKVpAY6EJpNW81QMRtWTBJtmxETVW0n8qKFBUmyPI3VTQOdCFvjifCaGX2QpVLY4DBPb9B4XlgfEBNEhVbONNlCkvVmOlANFv3k8jTigLkbhSpNaUX3hTFkwbqIInQyHcEbY5AjW+WZmKIiL99VW3KQ26sRLkQ0homz2pNIezGRBESVH/tpSJdYPeZuQg42lLSj5W1nagrX6Vun5M21g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EWPN+bovzw2VkiimnIK628skJx/qm5hrBtabehSubQA=;
 b=JpyV/PXgYKUfAlQ1KGfnUzOYZuC7vkjQtvZ2LOwlXm2LW3uiTC3hgZLpH8rxk7NHqMJ0UXHwyIukUpCnSkliSSQuX2giJDoDbR98NnOvXGoMcyfLNmds9cNIM9G4hJneUKOpxpMyDxQi3eZkrjXeJzTXsfES/UfhjNrXqN5mgf5n8vi8PLTmFIguJX/RuKHKq7e5C8S6oUNVcn27Z6SzBAGKkpbNrZC49NoKqV4hhvf6fHFOVW7KXFpHuyMXbBSm+Ynhi+gtzCSU7N1+rxIOnuujzKFqwFfRZIDHdA3jRTR+GYxehCA6FRBcKMQv/QByGF7cjYntr1rhZFtnMhQZSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWPN+bovzw2VkiimnIK628skJx/qm5hrBtabehSubQA=;
 b=I7z0Ht0tHUkt16As1y4EdPmu7Eny0PjmdR421ZlbED4g4nLTdUO5+yXXQXcYRtnS99efaVl04eBN4G+r6OAr6vC28lnWjEkBZiOcv+A49lITnP49Mhx0rdtY/cy4tZlCWwU4deOTeEwqDEvY2GfpFUEEQf2/G7BQ6t6PzB7xogs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8005.namprd10.prod.outlook.com (2603:10b6:8:1fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.14; Mon, 23 Sep
 2024 07:27:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.010; Mon, 23 Sep 2024
 07:27:52 +0000
Message-ID: <583681d2-2d1f-417c-b58c-ceb5407bdff5@oracle.com>
Date: Mon, 23 Sep 2024 08:27:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/6] block: Rework bio_split() return value
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, hch <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-2-john.g.garry@oracle.com>
 <cbe3c6f0-cc84-4e92-bae4-5433ee0549e2@wdc.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <cbe3c6f0-cc84-4e92-bae4-5433ee0549e2@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0201.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8005:EE_
X-MS-Office365-Filtering-Correlation-Id: e9b8607c-f1c8-4f43-67ee-08dcdba13c23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTZTbWpOdGZYMElCYmpkT2MzZzJFMTEvTXRFb3BwSXNPYjYvMWRHRklWR3Iy?=
 =?utf-8?B?dlZnOGViOVhTeVpvZXo5c1NFZnBlK2hVMTlNOEdpWDVNMmdmNTBKOWRkaTdj?=
 =?utf-8?B?bnBpQUhIVmh1c2VPVE40Z1hNdXNqeHRNMWNMbUx3WFpRcmRPUWRlTUtna0hk?=
 =?utf-8?B?MlBYK3FnQjdLMWtRU3JlYTBpQ1U0QkhKUUVOYTdXZy9NeHRWdVJOZ1d6TWI2?=
 =?utf-8?B?SzRhUHkzY0ZhSzJmanQyMlpiNHZ6Rm9PNytvSUxqRzVOdnBlZTY0UXNuUjJa?=
 =?utf-8?B?THdoK0pRZFBpeHRqbUxwZytOdXdiRWNHVFN3cnAzWTFNVlQ3aERLNGRyTWMw?=
 =?utf-8?B?cytsOVhXYURKaXZNVHpsWXVFcDQybzkveXlrR3cvS0Y2UFNIRklST0hCWFRW?=
 =?utf-8?B?cGxJTHVTVmtqak9pbzBJeWE3clZ2cVNHZTJMSGRwaGN3YldtdkJDYWtoNWU5?=
 =?utf-8?B?dWsrRGs1bjNhMFZWSGplN00xUHhRNWJKZXF4cklJOHZpaHF4RnVtdnFTRC82?=
 =?utf-8?B?Y1F6NGhXVTZmZDd5WDRlMU5CT21FSUNmaVk2MmZwUXRUb1NhRG9PeFRvenZz?=
 =?utf-8?B?aEk5eGdKOVJ6MUxnV0pmNFhDN214aDBjSEQ4OWFMZzg3NjVpa2ZVcUw2ck1u?=
 =?utf-8?B?cnRQRGZIYWhCeVVLdTZ3Nmo2NHNYOFEyRDJrRU1tcFpybFF0aEhZZEtZVVRH?=
 =?utf-8?B?dmM0Y25iY2JCdzZEYW5OTFFLTHlZbi9lTVA5V0NuMkxCaWhZY2FiSjdzbldn?=
 =?utf-8?B?MUd2aWJzNFpDNlBpeDBHT0NOTSt2RjNyU1p0VEdKZmVxSDkzMFpCSXMxdjFG?=
 =?utf-8?B?RFR1TnFYRXdSYlZZK3NBelk3ZjFLdHFhRGJZY080ck4xVG1yWXdtck1OaWVy?=
 =?utf-8?B?Z1AxcDVTcGFTZnYrd0ZXMWNObzJvcjJPSm9mL3gycXRtL1gvNEhhL2ZlSm5O?=
 =?utf-8?B?RVY1U3RWb1I3UFFOMG9iY2NLOGVsNllWaXdqc0xveU1mL3lZaUd4bGsySUlT?=
 =?utf-8?B?RC9VRTVicndkRmU1bG1pak5HY250TjlIbmI2cG5mRnZ5NkRvTmlEbnVzaExY?=
 =?utf-8?B?NFowcndtb25VaU1YeitDdTZ3amF4QjY1VEYxeldVbW9pTExHeEw3ZGFuak1i?=
 =?utf-8?B?UFJxVmpRaHhMZlZnT0NjQjg5KzFSbzdVc280anBoMDU2V1oxN2hSbzF2ZDda?=
 =?utf-8?B?R3hoVjhOUzFndVlFWnJ2aURqbGo1UVAyUEtpOE00bE16MHFsemZpc3R4YjJi?=
 =?utf-8?B?aWZOMjNhUmpBYmZuVDlUcUMvVEZ2WDArT0R0RU5wT3QrQy8wdXk2SFo0Vzlw?=
 =?utf-8?B?SGxncnhSdHJXSWxqdExsYXZJVUIwOHFrazZ2aWJ0WnVrV3RJM3BUSytYcVo4?=
 =?utf-8?B?TW1xaUczaEpuNzRPb1ZaZU1MaEJiTW51MDZXKzdrdG1YTWZ1YUJzT1g4M2tP?=
 =?utf-8?B?N1V3UDVpN1pKblY5d1FlREhRTzhVTVM5WFExQTlxeGNwRXQrNlZsNXAyTXlq?=
 =?utf-8?B?K1BucVhwMStONFlwRnRQQ0RsUGJoNEdweXhJd1lHWm41WkM0ZExtbmgvTWsr?=
 =?utf-8?B?NXhTUzJsa0dkSlJvb1lXaEFtcXdLWVJmWFpuVlZiNVZUNnlpL1hwY3NaVEdN?=
 =?utf-8?B?V2gvQ0U1bEticVFVN0FQYlNUY3dKRXlnbjhTWmJFYnBhRTd2bXo5eUE5RUtS?=
 =?utf-8?B?MU5jdTRLQVJuK0Q0Qmd1dzJDK0pFTDhWbjdGZ0JOWkpvRVdpRUFqcWNORklF?=
 =?utf-8?B?NWtiZTI2a3lTakthZnlEK21aRzN0dlZkb2JDakdCZWV4K2VYZ3J5b0RDSkpR?=
 =?utf-8?B?dXo5U3p3eEJYeFdQWFdWUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tk1waUtBaHU0V3pZbUNrcGRXSHpQdnpIdmlDaC80dWxpRU5qbG1tVS9ENnJ2?=
 =?utf-8?B?MG4xRGpLbXNLTE45VGE2ZHdTOGZqTFNEUGRQTjcrUUt5WjJ2WFFBL0U4aTE5?=
 =?utf-8?B?SGlORHlvdlhLZ3o4a00xbUQ1QTBOcEJMMDY3UUlLRUFRcDNvb3RHSUVIcEdY?=
 =?utf-8?B?UXdCM0FRVUhmQ2pDQWQ0cENJN1Q4SHEvWU1EL2VBOWZCTUtnMXhlK0FXMkhv?=
 =?utf-8?B?WUtTcklrNHFvclVyeGlOci9LVkJBcWhGdVB2WjZRWlRicnlRRWc2MVJsSnBZ?=
 =?utf-8?B?amp1NGRFYVpOSW5YekdFbUtUVE1Uc0NDa1dYK013RVpsSkF0bVlKVzNSeXBp?=
 =?utf-8?B?Z0NpUzdONWJMSTBURHY2YzBsZ2xCaiswM1FsdHlNWXFmSHdmaGxLVE1kQm5M?=
 =?utf-8?B?bm1oOFprSE56N3V4elhMR245MGh3dDJQbE9ucEkwM3BTTkEwVGl0UjYzaDZT?=
 =?utf-8?B?dFdmL2xEZ3M2R0V1MjZOTVZhd1dHNW1FUWpUcDBJV3M1YTZWVUQwSCtQOXhT?=
 =?utf-8?B?aTV5V2QrYVp4NThkWW5qTldaL3RERkVqU2NJaHBVdjZxbEtxMHU3M3d6eGJ3?=
 =?utf-8?B?ZUdMS2dUcnFXMFJoWlNwY01YR2JNWVVDdEs3dWU0S0hpcTN5d2hDN05PT0gx?=
 =?utf-8?B?UkRNd0lXYlZLWkx0ZUtvTkM3c0J1NWlCV3I5RUgrWG9kVGRmbFp5b2VGMkx5?=
 =?utf-8?B?WUM5eUVSWkQ5ZElDcDBSQ3ZkaTdnU1AwSWM2VkJqdTlTR05Xc05kWE5neno1?=
 =?utf-8?B?cm5ZY0R0YTl6blUxYjRtZVQ4WXVBbWRuTnZOU1pwdDd5RmFTTHFGbEZFWVNH?=
 =?utf-8?B?eTNPM3NGcUU5WjdyTEtMR0Mrb0JIelYxbWlDWEFSQThxYXpEQU5FcDhBMmM5?=
 =?utf-8?B?N3NIMkZneUcwT241YUI2RzF1UXhkYW9mWUxTTmNLVUxnZHA2MEJvdEVCNHBn?=
 =?utf-8?B?QmRXc3NUemZ3T0dvcGY2TzhkeTg4TUR1V2VqMlFsSnhUVi9MWFhBTWZqRlk1?=
 =?utf-8?B?RWJrWDdSMEJkaXB2U2VDZE1tTFJBN1dpc2xWQTR4b1I4TUNBdXpGZ0hTSmll?=
 =?utf-8?B?dHRtL0hpUFA1bWhvZlI4TStzTmYrb1hJZTdTellFbC9Oc3lpbkh1U1Fubmd1?=
 =?utf-8?B?cnhmVTNiT2p1Ky8veU14Q0xRclBjODByMXV6SjFqUTgzczNUTVVjL25WLzFO?=
 =?utf-8?B?TDlvcDRJSDFrcnhGaVN3b05iakVBblAyNTRaVVBpSjVkYXBtNWxDVWowQ1JR?=
 =?utf-8?B?WjhRZ2ROUFlPY0hubjY2OHo1Mkh1Y1l1M2I0bmFXcnZsb2RxYWdiVnl4Q3Bw?=
 =?utf-8?B?ZEFWNnhGU3dYWDNWTC82d29hRjUySkdER0o0VXo5QWxwajdYNGl5bEhtQ0ov?=
 =?utf-8?B?ZmJzNkNZcXFSbi94N2pCeStNRVlDY205MXdnek5UNkcrODNvdW5qdC9WSUlx?=
 =?utf-8?B?MkEzM1JuR0xzY203VHdEUkNaZ1RSRXEyQkF0RWxWN240TTd5bnozRVhxbzVm?=
 =?utf-8?B?aFRyQ3BtS0dNZ0laalpNa3l5SnhrTGFBSnhRaTlwbm5mUjFTdFR6QzhYMW0w?=
 =?utf-8?B?RFMvN3crVS9SV094Z1lTelVWM21aSmlJZzU4SDJoWEd0Q0t1dFBsWWUyU1hJ?=
 =?utf-8?B?Q08zZGJnMHRUbzE5K2dCMlhONGxXdFNGTXNHc2JOV0Zua1l6T3JWWmhzaVRE?=
 =?utf-8?B?c3l5NFA0dkhhUnFUdWQrRVhFSXpUQVhKVExoazZvUmFPQ2pqdDJ2VHhIK01I?=
 =?utf-8?B?K2s5VG1peW93K1RGR2dpRXBpWTFSTmxjMVFtN0VaV01lY0dmMlNPUDZGQkdO?=
 =?utf-8?B?YzJjR2d1RHVjUE9YL3lsM0RuZ0RTN0ZNRDU4WmMzTVNsMXlOUno3L1BHbFg1?=
 =?utf-8?B?SjRVcytReGFlQVd3QlZvaFlQc3MrS2FMVS9qb01UbFlxUXNIVTVjZVU5aFpY?=
 =?utf-8?B?MVhSR1lBTHltclBjbU1MajRPVlJoRExnZTB6WEc0c1M2ZnAvcVI0VjdSMTdm?=
 =?utf-8?B?TXVTNUZSNDJqMWdYQ0VJZnhoUVlmU2VsWFBiYm40VDRmNXNBSXNDSkxXSFZX?=
 =?utf-8?B?NHlQRVRGdWdsUE9zR0xCaTdVdWZadlArV1htTWtaRnJEbTRPT0tTaG0xM09B?=
 =?utf-8?B?NlptS2NTaVd6N0E5ZDRmR29tK21zK0F6SWt3S25QVEUyRVdKRHRWcDJXLzZk?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Br3G8FcRGKV/fN4TMq+x8p1PWtNQcLWbm09zZiH0TsxFWWPkqvfWXopZGbK/mb+Ciur2FEanDxaetOgitx/3WlrFI7aLwSJx1/HD6HHiMaegeSXf2IyhvDlGO0D64gEtvZJaagCmIOx9iJVT4Rjy1BSg8Ji3hN90JfdTq7cS4YOJD3qUot6/c5poMJSda5cj/XrTSsPHlArECGdyPyN43OeFPXljPCSA7j6T+eg+xGCac7iiLtB615CnE15xaxitTNKL3wz58Z0ddrL0K2rO1gRt4/MiYDWtgAP2WzolclLPnYlk1y0ITyXKP2HTEdv+z2xF2Mt4x30d7d41qgE+inEQ8zga3UyYAeh8DCTmT09Y6hq4v7P5TCj+rKXUfcGliJcUrgvsi3ThD3QuFdyGggTA1ciBGbd9+csah+jBGyQzzfJKAi67uGe492K/DQWbLab5Jm3N1r4dJt9p96QOqZT5wRq7UjNk1Rr7hoZCUa5H6Fc4N3MfbXwS/caU7tFj9Nv2CzkwXZaITNiRYhTPCMWpsL5krc2C2xlE9E+ZmhTgT97Q4v7ZCTgO0E3T9rb046HqwHbxWY6LiIGLUYoVzr1h1DJIIMmHnibNozRJlA4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b8607c-f1c8-4f43-67ee-08dcdba13c23
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 07:27:52.6902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EJVYDt4BQRkeP8rjWFVECvAjIRLlGodHyJJkFCOSJ6RGooq/dfNFNpeZvYUcuXaAsDuZhbAnidtKCodjyNlChw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_04,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409230053
X-Proofpoint-ORIG-GUID: nSrObuZhXuYrj94PE_gqQ1FWUsMzmGKf
X-Proofpoint-GUID: nSrObuZhXuYrj94PE_gqQ1FWUsMzmGKf

On 19/09/2024 16:50, Johannes Thumshirn wrote:
> On 19.09.24 11:25, John Garry wrote:
>> -	BUG_ON(sectors <= 0);
>> -	BUG_ON(sectors >= bio_sectors(bio));
>> +	if (WARN_ON(sectors <= 0))
>> +		return ERR_PTR(-EINVAL);
>> +	if (WARN_ON(sectors >= bio_sectors(bio)))
>> +		return ERR_PTR(-EINVAL);
> 
> Nit: WARN_ON_ONCE() otherwise it'll trigger endless amounts of
> stacktraces in dmesg.

Considering it is a BUG_ON() today, I don't expect this to be hit. And, 
even if it was, prob it would be some buggy corner case which 
occasionally occurs.

Anyway, I don't feel too strongly about this and I suppose a 
WARN_ON_ONCE() is ok.

Thanks,
John

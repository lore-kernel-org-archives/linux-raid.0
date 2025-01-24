Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679CA1D6DC8;
	Fri, 24 Jan 2025 09:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737710020; cv=fail; b=Ol8QKIP2LeFrsRIsGu48o0n97sUEepx8OxHoO88sNt3366LPIs3UmwyYcQ7QpsVKSMTMdWpLJF5VQjuvMhkPp5VkvWO+8H68kisxy2kJrrVYHrofJdxIIN3x8FZAJOnCO0SPH8k5uAeZStob0ooWuG1gwZ4/g1o8L9M7Ilmngvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737710020; c=relaxed/simple;
	bh=jk2Eojs0EaM5+Jh/HogECJIYj7YzvdNCU9q9ongqsic=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GHPy36GVODcsHk8GFj45I33AdNYdr9v1m4V6uEkHP8L3BIZPyQp+YhjXh6OCnD2JOr37JMWH1XiFVme4/CfA3IhaFkMGeNriN8oYlQP3KkvhXdfTIEXZ0SNOp3NovSOeOjAzz+x9lXjGzleSJmSYdAGf692BBTR9h+HmGM/b798=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HoQv7SCZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=obFawR5M; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HoQv7SCZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="obFawR5M"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50O8g4dZ002183;
	Fri, 24 Jan 2025 09:13:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=sYS/KarMNwgj8T1qSYEhvlGTWlOwjlsp3XRQSe/povk=; b=
	HoQv7SCZi1XhsO4OeLPk28s61RQAzS1UzEQitr5PR02PBEt6wMV4WBHWELk89NQ9
	AJ4NrcMuCdcrO31cQ+VOVQdv62Qf/v3FGw35Rwo7XvT+HPe6WA2b9d/dhtU/c71D
	KpUCij65DCF+7Y9iCMPBqDFOMCbGFPDHzQbcwkpOK3i54F0dVLjAgAV75YU7xVcg
	K9RAgccA2+EviOu/3JbQkyBh/043jKAWer/cJGbvOhgEFJTzXnXwk7c/uY5iPQ2y
	2rtKcFI6mhP1AIUtS0nYrxYNKELoOHuy9afG8+wm+0LU5hvaQX6l2CKoviuIDiZ2
	Jz3j82LMRdCtwg41cpSsRA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44awufveyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jan 2025 09:13:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50O8UK9a005670;
	Fri, 24 Jan 2025 09:13:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44919836ex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jan 2025 09:13:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K/LMOTjNEAE98NvZdVgexk7673z33WvhFuuKtESK6G9lrRkMUZDqSqkPETub5RagmKTjMGjXsAxb71UHaiSG5AfD25x/mmc5g4rS+FhcM0FuxMANJcRCQ6IypekMFlIZOk7dt/Xhnh9aoMj39thjcraseQXio9Mfu4G5iB+VKWM5LCPk5et3Wzsx+BLHKYxwuOWiP2Pom7IJ/bhxnBqvkVz9egRfXroOvPcjUovkQ5uwO1oVU/32gRENaWNgUAcGNinRsN8/tFmXkrVxEuxUZ7IsEL1O9waUXxMxHXlTV5d0wLZLEqqbo1ekpl+KEZ+Z2ZJDDXSZxbzgu29Ztlk/Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYS/KarMNwgj8T1qSYEhvlGTWlOwjlsp3XRQSe/povk=;
 b=vldUjmGY9VcEvqAdE31yqHwsDwBBTJMjlhEF78yMss/jje1GR2lJqZxsEgrN7y36QLGRpTrZBfLPiz6uy0u2oygoY44riH0TydZmVozekHdfOpXYaBLevGZh3moUNVoDQ8bMiOrd3/0wAPKqEjFbdT3wiuGhHMYrmstYWTYRjN6xA4M7dtxtUXVjDbdyA1C48nBtiykyT81Yt4SGxipMDd/dCgXEUpTVZpQptzS4+UOXR+xgmqCTFlIoMyNEuwia0Zks4XVoOpWh6FgMPgEQPh5njxsQSHjufQ4dzbe7zrC/lkI27wLYoUhPNNs6ROXmwaAwGG/gaaaimqfU0VXDzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYS/KarMNwgj8T1qSYEhvlGTWlOwjlsp3XRQSe/povk=;
 b=obFawR5Ms5yxqS4CYM9j9yunSTueFlANtSffSoMCs0S9227LZO9A6v2WCo4Mp82tXrSYavadBnlYTxf3jOZmxVX+PYyI9jalXPrw43rUIZmy8E0Nzk1FDLklTdlqqBNc5Pb+XYrmo/gGEv+fobQ+N5OYhtOY8nep41Idy0rPlIE=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by MW6PR10MB7637.namprd10.prod.outlook.com (2603:10b6:303:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.18; Fri, 24 Jan
 2025 09:13:08 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8377.009; Fri, 24 Jan 2025
 09:13:08 +0000
Message-ID: <d44234eb-202d-4022-80ae-6980b67d25e3@oracle.com>
Date: Fri, 24 Jan 2025 14:43:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] kernel panic at bitmap_get_stats+0x2b/0xa0 since
 6.12
To: Yu Kuai <yukuai1@huaweicloud.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        song@kernel.org, pmenzel@molgen.mpg.de
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <ca3a91a2-50ae-4f68-b317-abd9889f3907@oracle.com>
 <e6b8d928-36d3-d2e5-a773-2f73b8f92bbc@huaweicloud.com>
 <6b72aec8-cc23-27d1-38ae-827bf800f21d@huaweicloud.com>
 <48589759-88c1-4d13-9f08-321484180a7f@oracle.com>
 <92e93025-664a-2312-c856-681f8cb55a3c@huaweicloud.com>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <92e93025-664a-2312-c856-681f8cb55a3c@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0081.apcprd02.prod.outlook.com
 (2603:1096:4:90::21) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|MW6PR10MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d3db058-2b7f-4837-0f3a-08dd3c57518e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aFg1YkNxaGRKQW9NNU9rSG1RRTM2QkZiVjhVc3kxRnRPMkhKNzB4TjlUcUlU?=
 =?utf-8?B?a0hRaERjZjFMMU9uekJTTmhhR3VYekFSa0dRSENrUmFrdUZ2SjcvRlFOd0Mz?=
 =?utf-8?B?TlBGWUhjOHVjVTZOSGxoSnlGaXJDblNxY0d1aTZ1YjJubTRyM1RUWGhkbnpR?=
 =?utf-8?B?TGxGNUNmUTZyb0o2VWxFN2Y1bW50cnozVzRTN3RBRERubXpvaFN4dHhGTnRC?=
 =?utf-8?B?QjA4bVI0bkRudjF3anlwZHdOR3N6bHhDUzc3Nm5GM3JQd004c2dFcGRtR2VW?=
 =?utf-8?B?ZHFxTGVtU1daQmE4THF5am8yaG9VVXhGS2UzbHhaTlIrTGU3MnYxSEpWK01G?=
 =?utf-8?B?Q1IyVTlmZTFWUjAxZy8ySVRrRWdKU0JLNEtCTnZGMHJJRGRiWm1yY3JFYUll?=
 =?utf-8?B?YTd4aVRVS01XZ09tL2s1VmdSVnZlRm9VY0xIQ2NqeWpUNURhSURYUjlyaUs0?=
 =?utf-8?B?ZU1peDkxUVB5czhHa2xQL2FiNEZMM2lHZkNwSHRYWnlzd3o2ejVPODQ3cXkv?=
 =?utf-8?B?d1NHRUtqK2g3ZkVVaGNGNmxneEtFajRReWM4YkJha0tEUEZnTlhSUE9OR2VR?=
 =?utf-8?B?WUx3YXIzMFp4dmVlaGtXZXRHeVRzYXIyUDFZekxTVENBL2VBWWxKaXhiYmNS?=
 =?utf-8?B?bVVKWnZrZGlDeUQwY3REczd4ZHZHZHU1YWxNRnQwN0RXWW5Xbm9zQjlJdUln?=
 =?utf-8?B?MXVFc0FJajNzcjQzWTlLSHR4Tm05bjVxbjBGVGp6TndBMTVLTFg4bDBrVjY2?=
 =?utf-8?B?TVFFcWE1dEpJSUthK0x2TVdPaTQxeng0ZlpsNHpQdEdEbkFtVVVLNHRNL3Bq?=
 =?utf-8?B?aVFhZUU3T0NxeEpONEhoMUU0eXkwRjBIek1EMm04eXEzU24xT01TNzdqYTdR?=
 =?utf-8?B?OFQrcCt6a0ZzaUpUSU8zYWlWcE1JbFhSWXkxakRQUytKNVRWOXlTSDF6NnpL?=
 =?utf-8?B?ckRWVkRkd0VHSjEwZU5pV2RYNTczQWFON2k1Rmw2cFNIckpsSXI3RloyQXVj?=
 =?utf-8?B?amNSUjliM0xuK005ZktQNDc0MWYzTktMQlkyTmxsekdpVXAvSzlIYTM3SnNQ?=
 =?utf-8?B?M2s0Tk0zU3NBNlB6N0VTT1lLNytNOUE3d1U2d3h0SldqTFNyaGNsY0NLYWtL?=
 =?utf-8?B?bFhWVmF5aHpwZUx0VzhzVndPOTJ6Y09KOWcvZmNuaFg5TFVJN0ZLTXlXOVZx?=
 =?utf-8?B?VUtrV25TQWtabWhObVh5WTByMURYWnRiWWtpMWFXbW1uV1V4c1JxSExZeDA2?=
 =?utf-8?B?Yis3di9HWEMyVFBrUWh6RmdheDFJQXEwSlAxZEdkS2o2eXBJemN0dFViYm96?=
 =?utf-8?B?YXIzQ052YWl1aXRqL04wUWJsNVNOMTVpbVYwSmt4cU5qRkZJRXVlaE8zOVdv?=
 =?utf-8?B?RGxGQS9SbXVBWDZNRXRxWm40NnJjVC9vRzdrOGVhQkR0Tk1IU2hzL2VYajhI?=
 =?utf-8?B?UXZ6SE9qRFhIUDZqTDE0eHJzT1N5eWhVcFdlOFdXclZCOURpNjZMT0FhY3hG?=
 =?utf-8?B?NlpDNDhmei9na3Rza2U2MFp5eG9BQkN3MEYwYjlIdXpXaU0zRzVFOVhBcVQy?=
 =?utf-8?B?czRLOTcxWWF4bVBWOFVLZXAreCszVGZVVHFzMWNDNWNtenRLTGxPZzg0S1o5?=
 =?utf-8?B?TW5NeVIvUmV1WVU4L0xoVjB6d2VoVjdFRXpxVzd3Z2xHWGk0bkZkRUUwS1BD?=
 =?utf-8?B?VjdkUnJGV3VGbGJnWEY3N3pUTWNhakQ3bGM1NllLaU1lUFFzaCttaTJIUmpm?=
 =?utf-8?B?dXl3N0I5cXFZM01UNHdzQzFwV1IyQkRRNS9SV3ZwMytXV1c1SU5RRlNmd3hq?=
 =?utf-8?B?amxlMWxmRjlqY0VoTTBROUhPUWdpeUdlbzFJeHdSU1VIdDhPZkZ5UmR2bzlp?=
 =?utf-8?Q?+nz3iy2cg0mlf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWtFelRPOVIvajl0QzJTZVlOZ0poQVpWYVRaK2tqdXdVZ2FuQVFxWTFHQi9k?=
 =?utf-8?B?RlhyS1ZSRFNUK25td05MVFBhbVFZOTNRVWF2QTMzekt1MjVMNVRGNk9UZEMr?=
 =?utf-8?B?bEw4aW1UZ1l2U0NtVHlCQXJaL25Gb1VYUHNjMThLMkZ4SGlTdXVBN1kyQXA5?=
 =?utf-8?B?OXRNOFhVekVmMTIwc29YSVZ1RFRzSm1rUlF1SGZrazBabFhKTWRMWGdReW5E?=
 =?utf-8?B?QlBvT0tpVDdTMFdSYnM1bE1tYmJ5QlhwVm91TlN1cjluSnRJNVFCUFFIcXZu?=
 =?utf-8?B?aWdhWGlLeXpCRTlkZFN5Y3JyK25zVUNtK0xIRlJtQ3ZkVnNwMDFiVTluVEYz?=
 =?utf-8?B?OE1jUC9VZUVFUmgrRGtZRHI3dStIQmtta1FESnMyVUdNeDkzbWdUc1pxTVZG?=
 =?utf-8?B?Y3l0RnMrdmEzYW1vckJydnpWbFBvQWsyYlRCYnQ2WXM5TEsvdDl1MkVyVlRF?=
 =?utf-8?B?ODl4V3JuWnJkTkYvVWsxajBOdkVZdWg5NUIwMlJlaDgyaG1MdE9FWVJ4RnA4?=
 =?utf-8?B?YUFOMDZMQ3ZPYTBGRi93YWs1TDNwNW96RnNpZzc4OEhjSmpmcmNmdnhDaTZa?=
 =?utf-8?B?VU4wRjhVb0VGZk9la01uS3ZFWUJxQWdsM1pVUUw4dkpCdjJ2WllxUEhobG9R?=
 =?utf-8?B?dnBvL1FnMVhkeXBsTU5MZW82UmJhM0RRa2llZlAzazIwbTNjQ2xXcWxqSHdK?=
 =?utf-8?B?TmgxMjJ2MzI2RGUvNVRSdTJONHE5ZTUrMjVpZVNQeEticFpoRmdiUUZjSTM3?=
 =?utf-8?B?U1lhM1o2RUtMTHpLV05lQ1k1RXQ0bW1uM2Z1YUVLSHkya3hxNWg4NVFmbzVU?=
 =?utf-8?B?Wkt5K0hHMndLMmlYYVBnK01xQVFJeW5idUxZVDh3RU5lOWNNWXlrS2tDbjdz?=
 =?utf-8?B?V29nNkwzRjFUU3Q4RGU1NVg4dEp4MFN2aGtwbHpXSTNHc2NQR2lQbWY5clV2?=
 =?utf-8?B?SVRhQmZwY1YyMkFWd1lCZXZRYnc1bUZ6UzBjSlpVQkhyS0pBOHhFQlRlYnor?=
 =?utf-8?B?am9DQ1pTUXYzZDdFSkR6OVNCend3ZTcxa1hyMmh3bEc3MmoydXEyL2xCWVcx?=
 =?utf-8?B?S2Z6b21TenBKbWUxZklFeVJ2aUk4OTB4d3BTc3BYTS8yS0xyRmp6Y0dDK25n?=
 =?utf-8?B?UllDbS9NL0JBR1Q2Smx6MUtnNTVMYWxKa0d2OVpianhsWTJwSHNPVlV2ZHZP?=
 =?utf-8?B?MWh2SVBsbGhZa3FRUStmZUkzaVQzR21PSjBkeTE0Wko4NXNSdVZiRU1ZZVBV?=
 =?utf-8?B?TTFTYW51Rk95YlF0RGdZSVl4TVZLS09nTEE1NTZ2NFZmcG5rOXV0NThxV3lx?=
 =?utf-8?B?bmpXYzVxN3hBdjAvU0ozL1JmeHhEY1FHQkJ6Q1U1Z1dxVHVSYjlpZGJCWktW?=
 =?utf-8?B?MmEvcTVKdzZCbkVQMitZQXNUTlV1a2MwNEVBTG53TnkxN2kzdk81bzZZcTVI?=
 =?utf-8?B?S3hTU3JSY0JQektPa3d2aWpOMFkvalRMVzMyZGJRZGFueVRuMGdkOHMxQnUy?=
 =?utf-8?B?Yk1nR2xibEtOTDhMelc5bWFwMWxZOVg0ZVhDUWtxdUhYdU1OYzVoOGZZZmtN?=
 =?utf-8?B?dlpob1lMSlJNNW50ODkwQThlUGxQa0RqaVVQRWhndFA0a0xnWno4ZEFpZWp1?=
 =?utf-8?B?MURiK1JyNWxwL245QVpsenVHM1FCYUdWb2lBbTNDL1dncUVaT1o1dURpTldP?=
 =?utf-8?B?eXh1MW9sVDB6blFydHRpOUpnZXlPdWs3cDFRRnd6cE51RFVEY3VzSlBBbDFC?=
 =?utf-8?B?ZWJRL2d1aGhXMHdBckJlckRJUWFMMTRidzFlU1drWXNHWEhmTUZiNjZOYmx5?=
 =?utf-8?B?S0Fac2VNRGlONlhueXI4aUxURDMzdVlnRFVybCtLWGpzMFRXcm5qZjI1RUFL?=
 =?utf-8?B?eEg2UEk4YURPaFgybGV6QjhJdmFSdndiM0NRemJxNlhZR202cEFQdjg0SVpl?=
 =?utf-8?B?ZmE0WndhOXN3ZFVnU2JrNjRLeGNzSjRvS2EyVUNBQWtBTHJBaTZySzhITlZP?=
 =?utf-8?B?dWV5MS9sbURqd01SRjNNbXJ5cnozdWFpRzJhTDUvWm1YZDMwTFoxUFNudGNz?=
 =?utf-8?B?OG9MMzQ0ZEZwTXVrR3p2UXRLUkRSbkZzYTEzNjh1ZzNma0Z1S3l6V2FOVWFw?=
 =?utf-8?B?U1hDbWFHUlRwZEZnWngzc3FYTHY5QnVnSUpvWXI2L1FCT20xWGM4dUgzRi9S?=
 =?utf-8?Q?o+lWj6hQ1b1DlUYCXw8sMFE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3pNQtfJtl9L3ZCnoo2XpEIsi+lYZLMgAaJ6nZCTWLn1BrQLSACcrJSEWlLvECErYYqUs/x0YLs4SsNAozE4LG4uwXJwF9t1C0JYuBzpqjfhIUrP2lQz7zDJzHWiQhRbq+l4jzAsjbZkEoTI2EpO0mea4CD5AdvjYLsgZe0aqt0AdQHLaYPQvLVBWKF1wAkGAysDnV3V+9+1lpZNR/VuTjvuYRZ0ERWVsydlac6FSQcERWWkKducFG+j7ni9cpwbCvUmHikXDGyaf+ID99noXN1TUN0TQhlHQuatjpCgwUeUh2nA2W6n8v31PWiGddmf54QUIy4gKRedNSr/KTLdCcdIGsYzgFRBKBtN20s4/bHiriqg0TT7nHsx7Qf7ELsf2f/wbtUvD7GZTXGUiaxSCTKUbFIRabii++mWukLfS5pOKqTOHMrYcJ//0LaQiueQ7lXYqWqxUMenR3f85ntK39f/e9xQR880IsSn8THFWGwJwzcvz2GoOcJA7bsvjuIOTLYL9XhpOFNal4l5nvz1rPYzbI6+B5jFM2CcreCP96jccfiNr+O1vUHmeoxVRv9A4WGWa2/hsLv4m2/4tmK/4ZNWhBhVLF+uYsGZ52jBzANc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d3db058-2b7f-4837-0f3a-08dd3c57518e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 09:13:08.7842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0TIYvnukP9FVfd9kNNiypDDwpZdyOfPhsJc0J9uhr6eh0bATv5Or4YjPN3YvZ8dOEEmqTZwdpba4n9adZt40rJi5Ev1H0RxdwYuikFw0vXoDqTetFPMuxzcvLSCmx6o3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7637
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-24_03,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501240066
X-Proofpoint-ORIG-GUID: KBDhiuohlBpNKnCYdKW9Cy4R3hVIpGR7
X-Proofpoint-GUID: KBDhiuohlBpNKnCYdKW9Cy4R3hVIpGR7

On 24/01/25 14:41, Yu Kuai wrote:
> Hi,
> 
> 在 2025/01/24 16:13, Harshit Mogalapalli 写道:
>> Thanks for the patch. After applying the below patch the problem is 
>> not reproducible anymore. The boot succeeds without panic.
> 
> Thanks for the test, I'll cook a patch soon, with following tag:
> 
> Reported-and-tested-by: Harshit Mogalapalli 
> <harshit.m.mogalapalli@oracle.com>
> 

Sounds good, thanks a lot.

Regards,
Harshit
> Thanks,
> Kuai
> 


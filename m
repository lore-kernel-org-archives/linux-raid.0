Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDFC1A2642;
	Wed, 23 Oct 2024 11:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729682493; cv=fail; b=IWrbn+CrM2UFUawIdnONysDy9lkH7JcYpyFFQcIf0tsIlFe/aaE5Xl7UYvw/a1ucaN8zDJAmWOSx5+QdgPEZ+Ixvk/2S2A+P+iFPusOml80YNuaGSHV8TJxq0dxqpaN73+m5/4EWAbh4abPTfJRcSImW5wQ4iHVaFhIgYk5wBtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729682493; c=relaxed/simple;
	bh=kKfKoI7DUVOzShcdxBiuTm8RNqXb0ex/2JailTKvVYQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=repvIPFUAS0IpLFC/ZXV1A1hFGFOhzSV6FvnzkIA4viadccRWusGRd+iQKU7eCvbg4/Ax6AL15m3ebmzi1kUPqQE3Pz2SKHmuf3RG1AapygY/1RVsrjNk5aOS851ae8npjNic9LT6+ocH3kT1DZICt9+Ln2RHP4AgFqG2iT8S2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=euz4fuJ3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iqXHet2y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="euz4fuJ3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iqXHet2y"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49N7tgHl018250;
	Wed, 23 Oct 2024 11:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6F1y0PBEhjepcjZh9bRvPJ7kiQzx5Wo5HDhEWErNuvM=; b=
	euz4fuJ36m1SXlxX+GFDyiduF/VUyXU+0I86GF4KuoXPgwxNfN41CDRQDeB5qwnW
	UtSCC195PNfRuTCnQDxS3c/e9Rc+WIk9ppCgQLqZiH1byB9EG/jzEPKNvPkYEHVW
	R/lMg5h/JxxvvhNefOvLCRSBzA2kZR9fgn+Vgj0lEQvs0Qgfulyg8emfnVYGg+mb
	4CmpYkj3Yk6SugIMUkzpBE2kRVzabECAQgQdpKpZpvSEEDTcd4IFwgRxnaI9r3h3
	KEnsWDNjZf3n4qP9kENwlGEN1zGm2ORp18soVlDy+gPJzSxGPX3sDWF6SltCPZQY
	VDl2pjubMWWBKnY6wkg2oA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55uyubq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 11:21:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49NAB8vN036236;
	Wed, 23 Oct 2024 11:21:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42emh2d162-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 11:21:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZQBwDxKEF1QN1L66xOH0zMxQtxTkggkJsrusJH7sYhSxeza5Bpm6WEAwPLQ91shMLi/e22DHVH49JwOS2T6oSBIYkXxkQ+kL2yCGGixua8Yk8csUbD9msLy7B5bmd2ftv28Sg6ZY2zMygwhBqODf9xDexvWhNFgcv/b40cXssGJgTjyz2EqlDVwi33mv/oxuAhKZZ+ar8cV98G4FPhzCMU6ikXYVpBfoCuUJsTjaiRdWikOuB/9C/ZZKI82Ciuvk+Ko97ABPwQY3qO4jaBgBHk7MvnRCht2OTarcHeukrvzFfRjvoKb7IlifuUSM4Ch7IyqTEG1A/5zu3WRf1uz3tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6F1y0PBEhjepcjZh9bRvPJ7kiQzx5Wo5HDhEWErNuvM=;
 b=XDxniIDHMy3/h42r8FNJubQWD0zqpJ4T0XhQM5gAK30aM7C4Wg0uUJDqzHDUesMGo7qJXXeDSr8F2bbcewUb1Jrrv8LOLYkPG+zSW9G4fuC8W9+8cG6pLcJDGJZocd0K33xTSwBj5neRul3NbyE1PYKsOvJ/ach+61rWABtWpeqPX4CrcWUs0a8K5iKuDKzUThfuWKMdndleUGgisDbbWLok0STzr4CD2vt3IYKVGR7t36a/uaVrdNHlPjW4D4Wg4RnKNinT0VigH5b1fbftAWVQ8LvEPOKYGFMhwUAeJeYVX6PnF3mnj6EkJFKHU7p3/dHwuBNI7F9e0bKDNOF/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6F1y0PBEhjepcjZh9bRvPJ7kiQzx5Wo5HDhEWErNuvM=;
 b=iqXHet2ypxnEDTnQ6hNKk1lk1D9ZDmsb8Hf8tP7Y78S9PjSz7bKjyIc6tNQElYApeF85UrjO8JYTx6h9AeKMM0zx9PCoPMd9eB+v/LLpL7k/F7h0xFDDP0ZGWH282Lzyx2z5BDjlspjQSkM3fVprIkN+Iydl3sXkRvAMVTH9oQE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7132.namprd10.prod.outlook.com (2603:10b6:8:ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Wed, 23 Oct
 2024 11:21:04 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8069.027; Wed, 23 Oct 2024
 11:21:04 +0000
Message-ID: <68d10e83-b196-4935-a350-464b82c30e44@oracle.com>
Date: Wed, 23 Oct 2024 12:21:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        "yangerkun@huawei.com" <yangerkun@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
 <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
 <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0223.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7132:EE_
X-MS-Office365-Filtering-Correlation-Id: 05d4b4fb-46f1-4299-d213-08dcf354c7f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?REZ1SGJIOWpVUUhudjB0dUMzek1XS2ppMlVUaTZqUDErRmxnTXowekxyUU5k?=
 =?utf-8?B?S2xmTjA0a3lLckNEZTJXODlZdDQzVXBTdmRmdjNZMEFJU0xnSVNxZm91cHZR?=
 =?utf-8?B?Y2FUS0QxS1lQL2Y5a2RYYmNGRG05THpobGNJNUdKNmdCTTdsODd4ZnU4ajZK?=
 =?utf-8?B?eDVHRHdpOEgzZFdITkxKNzkvQjN2Ym4zajNTWFZKSkJ5NmtVU0VyR2RUR090?=
 =?utf-8?B?L0FTcjNIc2RWYzJveTQ4Z1UvK0RZNWpvbXEvQWFSUEJIdU1EMjQwd0JxWk1M?=
 =?utf-8?B?OHVZZTV3b25UbjVzMTVvWDZVeVJXUHRUTlJxNzlCMStYd1hqMWdrSHEvNEhk?=
 =?utf-8?B?ZjJLMEt4RTNweU03RFJySmtZVHJYdm5VQy9pb0RzRjJxWDl5elU5eng3dGJx?=
 =?utf-8?B?aG1wczZ3MkYvMTg2TStFa09FZlFTT2FjZEJrcTNsVUh5YlJoZTRtNlFBbWhX?=
 =?utf-8?B?c0ZrSWxxUk50blh2V3FVZU43Q3h3d1RvSUY5N1BJVE5sNlBCOHVRd3U1WU1h?=
 =?utf-8?B?aCtjcUU0bEx6VGc1YnQrVU1SSlhMRVl3R1c1cHF1bVdHSXk3MStod2Z0ZWJX?=
 =?utf-8?B?S1RIZmhOUFJhWlkxV29zRWtxcWxBQ3VJOXZleVlEaElXRnpqZzFWNzZ0b2tS?=
 =?utf-8?B?UXlSNFY2U2ZzcWkvZHEyR1pTVmhrSy9RZm94N1kvcVhwUFExNWt6Ny9ObmpT?=
 =?utf-8?B?RUVsSG4zeGFQUFJCSGpZRGxQZXdnYmc0TjJhNGhoK3NQMFlsY0xiODF5bzVL?=
 =?utf-8?B?TlJxWVk1d2FqenZSbkIxWjZuK0lLN2gycmRVcC82Y1pySG5nZXlZckQxRk9x?=
 =?utf-8?B?UUxqaHI3WnVpQVI4TGFPZFd3TEhPN0FtQlVoZEUyRXZiMkZ3Qmp0WVIzQk5U?=
 =?utf-8?B?eGkyL3VOTkhneU1OREYvMnIzYjdwL1d2c0RJeFlHUU5NM1FvbzBMWDh4aFdP?=
 =?utf-8?B?cEpwSjRTN29QaHBDRlYwSUZIWHdmOUdCNDNKREZPOXlESDNHcUJ4OXVqUXda?=
 =?utf-8?B?Nkt0VVl0cE10TEM3YktLS0VQclhrQWloTlAzUURGa3A0d3NUNjhqWFo4b1BH?=
 =?utf-8?B?S0U0OFVpcEZuQis5czVEbmNObVdCUHJsOUwyZGFQK0VUVGcvbndmS2Ziek9C?=
 =?utf-8?B?RHd1dmJaUC9PcjFFTnB3OEY5VU11ZlZnOXJrUnlCdXcrMG45d3hjT0NreXVt?=
 =?utf-8?B?SDNXemdGbWRZM2VSU2hySWNNSFVhYkUrZmtIdG9WU2tUeDJZTWU4dElZOGVI?=
 =?utf-8?B?UE9RSHhFcFBpNW1CTjh0TG9yR1RWTGFjSjhPSjlwVGVLVDhoMEs1eGp2dVJZ?=
 =?utf-8?B?allsMkd0eWlQRGhzMDVFbWxnTkQ1bnRKNWZvelZBeEJBNmtEOHowT2lvNkVL?=
 =?utf-8?B?OG1rN2hOYkNmcW5ZdGpSazhYbVNXeGVsUUthSEg5Mmh2S085TjVMdU1LWTEv?=
 =?utf-8?B?dlR0bnlCQXhGMWlrYnBud1ZFUFdqQzlMeWNKdk51RVlkeFJvK0JQeGI5STRk?=
 =?utf-8?B?OEVXTXROUmx4M3dUWC9CMXpQRERVNzNWejhDTHVHTSt6c0dkaklYc3hxOUNO?=
 =?utf-8?B?NHZhYzBIZjdRclBXTlVjUi9mNGVodkIwUnB5cU5LZnVGRFpZamZ1ZFNlUWhN?=
 =?utf-8?B?czVaVzQweWxmUHdPL1IzQzUxMVBpcGg2NFdGM3FPY3NMSXVjS3UwdXJrSHBG?=
 =?utf-8?B?c1doN1A2RU5KLzlsM3FNTUVxRFFoQzlDeXRCdlRmV1BMa2hDS29aeUpFYmgr?=
 =?utf-8?Q?aJW+ECQmZ7/w9/2rQo1fxJgTs1OFb/7iuXcqOZu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTA5aGFwVGNGNUd3VldDaHlyaytoMlhzc0hqUTU0WXZrUHdsMlBXMmhnV1NN?=
 =?utf-8?B?dWh4TlVVbVRvZnRmbEdOYVcrZ29QWk5uT2FSeVE3ZmxXNXJadStjaVl0L2pw?=
 =?utf-8?B?VGIvU2l3Y2JBYmVDZS8rajF5Wkd3bFROU01OVWVlQ3o5NTIzbnJ4U2FLOTBT?=
 =?utf-8?B?a2E5enpveW1YclRGN0pHcjdSTjFabGdURmNnZ0t5ckluVy9MRGVEZGYwU0VU?=
 =?utf-8?B?d1NTbmhpREt4WEs3ejhWNW5NUzlJQTQ3Y1ozRmY3b2RhK0xLbW0zN2Yvdkdy?=
 =?utf-8?B?R1R2Wlo0d2doTGRkb3gyWnU5NUFPRW1vaUo2cjRuU2Zaai9iZDJLeVlneU9L?=
 =?utf-8?B?NVhaQzJ0NSs1MUZidXNoQmZXdFl5YkE1N1Qrc3JVZjgxaFBXZ1JoUkJYaVkw?=
 =?utf-8?B?eFlicUtEc2k3T0pZWEYrckFZbDFDaXhRUjBtNDltb0tDdzU5Z0FjOGRDQW1k?=
 =?utf-8?B?c2FCUmR5eWw1N2VwcGtwaXhQcTBwbjFnY0xEL2ZsMVlOMWlTM0VEU3pabHR3?=
 =?utf-8?B?aVY3dGhhVTRSVm5QM0hlOXFFSzZVNUxrQU4zUnpSOGNIY1BZTXIwaEtUamtp?=
 =?utf-8?B?ZVEzZHVkUExPS3A4WHQxaEhVWm9NS0JTcWJHS3Nia0wzdUJuMmYvdWJ2TkRQ?=
 =?utf-8?B?aU5MUHd5ejdHOHdkTEI5VUhrbHExMmNTTjlsZmNNVFFqaFNBUkV3bmFqbUk4?=
 =?utf-8?B?ZkhtWVVRdDFyZGY5OVZIa0preU5zeE9TaGx2RE1LMHpYcGRySk1KNDZUVERY?=
 =?utf-8?B?d1RCQ3lLNDlrb2FZRzNFZXZldnRxK0x3bVdvZWl1QVRJSTdmd2ZWOEZQMm5t?=
 =?utf-8?B?VlhBKzVDZ3BESnhRMDBVdTkyMG11UjlzZGQzL2pOcjllSTBnMkwvemptQVZq?=
 =?utf-8?B?akswRXJzQ1pQZWJjT2V4aGNMSlAvOFNrRzdVMkgyNEx3cTVrM1NLcEE3ZGxp?=
 =?utf-8?B?djIzVmJka094V2RSYzcrRVgzUTMxSUVmQmZuenE5TXlnR0ZJeUlINXArdWV3?=
 =?utf-8?B?MlVLSDlsRGVrV0xBRTNHMkdZZ09XS1UvWkI4L0RYaVJMYWJtVW1SbHpBSzlh?=
 =?utf-8?B?bmE1L1A3WjJtYmxRSit4OWFJSFBIbUlLUnB3aHVZMHpqZ0pZVFoyMHJ4dytW?=
 =?utf-8?B?cFFHdTVld0QrWEdZMk4yWEtqdk9UcE1jVm5yQ2pSZHpvK0NYNERtMmlGM21X?=
 =?utf-8?B?eStULzh2SzdQQXd6ZmN2K2VjUkhGZkNiUHFOTW5QOFQ1UU1ISk5IWGFCcHZx?=
 =?utf-8?B?aGRPaDJLL3RoMTZVRGRNRFNYTkE2VUlGNnRBbk85NEZRRUhSbXhVZXk2OFFw?=
 =?utf-8?B?cUdmTFFETStUYjNoc3FsL1gwY0lQOE4xUFhSc0RRM0tNZEVHQXhjNUNKNW91?=
 =?utf-8?B?UFhYWlM0OHdsdklJQkFad3lLVDlMTlFsbHk3NTRMbmdvdS8rRUwzY01kMTl6?=
 =?utf-8?B?eHFKVUJIMWoxekZ4NlI1YmI0UXgxWTBwN2VkaGhKNmxKa2I2bmlpUUxaNVBQ?=
 =?utf-8?B?TFVrRzlCOUpyL3htWXgwZGJXbG1yOEE4YldhVlVoYi9BVVFBQVFyL1NLcGov?=
 =?utf-8?B?eTE0aFJIdTNEc0NoallUUnpqUkkvcGFpYU53VkR0MHh4b0o1U0Z2bG1ILzJR?=
 =?utf-8?B?dlMwUUVVaHUwWGJlWXMyYXNGWTErRHR6RTNZeXZtZ2U0MGVSY3lZYkUwYXhx?=
 =?utf-8?B?SHJCelZrSUZHTmZWQkdGZVNZVWNyY2k1Y0JoN1NweFI0UnN1WHBSZzd6YkYy?=
 =?utf-8?B?VERNNldGdjdiaWV3cExZeDQxUkJVRWthUW1pbS91ODh0M0JKSzNsNm9CM2VH?=
 =?utf-8?B?MjUrTFFIczBCN2xFcXkyNklwZmNQWU1mc0tXWE1ydDZnYk1ESXlGMUVYZnhq?=
 =?utf-8?B?SlM5bUZoUmtGTUxOeVVQbVBVNXpXRnF1enpzL1VmSGs4aWZTNnJUbnFBOXZ4?=
 =?utf-8?B?bW5xZUtJU3Q3ell5eS93bldSNDNFMXBBTUhtYUtiM0w5Sy9aZzVEM3pzeDI1?=
 =?utf-8?B?SVlTQkdYMklyNGdQaDhqZHVPdlNRNW5rVjkwTytyc0RlVzM3aUFuWmtLMzcr?=
 =?utf-8?B?dkRDYzlFMDVBaEdaMU5DRjM3c1lXcEZvaFQ0Rlp5akZEUGhkejU1T3J2MHBS?=
 =?utf-8?B?K1pvR21ZV3phcTN4S2o0cjlFd1dkRjd3Z3NiQU9acUdpaDJCaW44RElSbmNo?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1Rd7VVlkdFmC1sJloNlbiDSwxnyOZrMhvVUUFMy0O+jiKnaiSlgfG/HjQEoy+Lt439pLRgjeZ2WSYw51haM7/qZPjIPGnZ8EVsfveFlNzcE1HTD400ndX+Uxi/5/YJojlCx394GcD065BHFDCz2Kgxe+nelGxmmZw0dYQ3ckKqCP+fHa90TPA+L37SjJ2zH15mJDXWFcW3CqNduicYeg9FPml+B2LPAU71eeQ1eAJIvxUuYX/zxAsrdvGBAkFqCIFd+l1D8nKdIJC4g4pA0jRt3usjYkAWgaJ4woiDaKK/iOBYIQhZbuOEaB03QFqf+yxSTP/lc8gAy0Fqxag3TTj5yg6/qLOSjsp93zgRvzJMdbKJh0sBPZl3isiTRtMA3I+X/PTFJWXScvR/fs9leZq/7TrPcjDSbI3uz6Ycb6Xe+u6+aI2xPoTAIW8iRUsl+LUPPRr+1Y8sE27fDayl/ZU5jJnFbPg2CWinhhk0/uJq91buxD8SGku6OuMQZpbNtEcgo97QeWxaXRhYDBkIrqzQB8i953UYLDZ8xl4fDwPii166FZnpFAD360j5A92HeP45kJZmJHjZXLYhcv7NxYiOgrUcNM6/PUw5qk2avoZQI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d4b4fb-46f1-4299-d213-08dcf354c7f1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2024 11:21:03.9808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wuJdSwwVdKhVKKHdzMkrpE565iIb0yQcheDtTmurBsm4qSUnqvsgIWa9NdTdHR1C+4FubAOjgbecfZ6CNGKwWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-23_09,2024-10-23_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410230066
X-Proofpoint-GUID: aJPklSuUSzFlMkubdmZfIvDIIyRaA6GT
X-Proofpoint-ORIG-GUID: aJPklSuUSzFlMkubdmZfIvDIIyRaA6GT

On 23/09/2024 07:15, Yu Kuai wrote:

Hi Kuai,

>> iff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 6c9d24203f39..c561e2d185e2 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1383,6 +1383,10 @@ static void raid1_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       if (max_sectors < bio_sectors(bio)) {
>>           struct bio *split = bio_split(bio, max_sectors,
>>                             gfp, &conf->bio_split);
>> +        if (IS_ERR(split)) {
>> +            raid_end_bio_io(r1_bio);
>> +            return;
>> +        }
> 
> This way, BLK_STS_IOERR will always be returned, perhaps what you want
> is to return the error code from bio_split()?

I am not sure on the best way to pass the bio_split() error code to 
bio->bi_status.

I could just have this pattern:

bio->bi_status = errno_to_blk_status(err);
set_bit(R1BIO_Uptodate, &r1_bio->state);
raid_end_bio_io(r1_bio);

Is there a neater way to do this?

Thanks,
John


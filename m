Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01FC1D12E6;
	Tue, 19 Nov 2024 17:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732038321; cv=fail; b=LpKzFALlBuh1fgGYUnY8K1dt1XXTSdmD1tyGwICqIL1CcduQxw+szvJiYyH0VdIv5ntxZSDqEqpQBLp6vWAHphvKDyXBQLskasr2uE5OhDbeZZK8ExYad+hgE7noQCyqTtZArONWv/W749V+y+F35jOU0tuWWU1QYeZJqwVbDOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732038321; c=relaxed/simple;
	bh=1zPy1n9H4eUqnZ3TRvLK5x2kKkB8jsVRa/TuyBe3Dgw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Eqt22dR8VhZBNKP5QPBdMzFGVQoydGmQv414JQJdxI8W8bqiFn9M+G60Z6FGiUxmsfC3L/maJiJpAY3BQzgU0D0YwguFdizJz2yGf5Ho3FyHPygtDYVsXBcGtitYVPZEyrF7JrD5lLdCG2QWv4FoxLkoJVob9a4wWNorecbc1DM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=igTZFyBi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pAc12Bsi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="igTZFyBi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pAc12Bsi"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJHBk5I011428;
	Tue, 19 Nov 2024 17:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=1zPy1n9H4eUqnZ3TRvLK5x2kKkB8jsVRa/TuyBe3Dgw=; b=
	igTZFyBiUsrq2p8pf4oMCYYGt5jObhlbgGSkRCIQypmp6oGoMQ99iQ/JeGP0FvqJ
	I3nDkgARxe8Q3gQ17Do4+9XlulZ5sx2iCT4F4Q0epKBLYXKFa3HX7gOgLBGy8o/x
	zmjkXkz3ZERta8q+GtZi+tK5SrGlmvKlzfVbRp7x60r63a6YIsTp+ZGBhFiPu2GG
	WLKfJa6/z/GjTfstqQTyoe71+REeGWCcmY5wpXRFnz9WE/SHsMFP2MGn/EOLAbF3
	ZoKOzE9BQozlqc4SX9xVzTHJBCTKdvSfbMmu5dEX6lx23DVuj45TFWAnlLkVmt+A
	Vvj5128m9CJ7H//0VkEcYQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xhyydk3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 17:45:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJHNwVT007796;
	Tue, 19 Nov 2024 17:45:07 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2041.outbound.protection.outlook.com [104.47.58.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu8vbk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 17:45:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CYRUhRSNgwiJ8cxQxhf6Zia3A/DAgCX25XETRlfh9KspVy1j26rhP4faqqL+9VavHZBZVYJA9VtbPxswp6/84CqGA3v5fsaGzyjLGcbg1hxP8WMWMSA5X5N8wPWObjGFmdQYu2vtv35DjkLvRWR2Mw2TueSyeGuuoxbx1IF+1AlZex3qLDu4+wFMAbHa8KwnheI6u+VURYsgK+LZ66Zlow0ngNy7Ivk+HAEB9WMyMCWgs4LCmIRMWWKkIJ7ZqsZOLHoWgMTXqf6k3P+BGbrD05znFBG2wmmxJ74+Ey3M+f5K3aYjjIbM/6SKTiZ5lOqIvWV4Q2Sw8XOUva80HwD1xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zPy1n9H4eUqnZ3TRvLK5x2kKkB8jsVRa/TuyBe3Dgw=;
 b=Oh4tAwvd/9S41ZwtzVEs1brXzvGVc+DPCyvJvQb8MnLCQgBdsRP4QHxqgfplg6WDW5jzdEXLaGyiyNKQ+6NQBp4bpZAXv0m215S3Jr/Uwe+MSR+XlXf8gwnt2jkPqMZlAGKIvYrUGykRAAMNKZuVTFXB6ASqdXaALqKHVU/smCUKaUJ+/XbatbUAIYN+KnuJ7BbDWWTLH4ihGVXRe+NJPKkCcuJ8XS2CYG7FI+D4PsvpW3KHIQKdDfZDEDUwOWnT8XgChiFVijFepZ7eKLeJsStvibdjHzzDtaFejSDoXSd2UlhmWZCKv5g4Jat9l9kKLx0Go1XcDIdk6oVyiLfqrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zPy1n9H4eUqnZ3TRvLK5x2kKkB8jsVRa/TuyBe3Dgw=;
 b=pAc12BsiaZP4lFpV+NVijO8eovPzKyW2vPku6lY7ShFEzOqXCaa0wnUGxstpLC/H7rU8XUqo9DdP7vgVHO6Sxsl6JWvSeuIBpGBWxQ6EtBgimsOuaJxcuK5IQcWiUZgJWsY3CXeB6Xm54zV9OZMsns30BRu8cgqB4yaTtE2/yZE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB6760.namprd10.prod.outlook.com (2603:10b6:208:42c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Tue, 19 Nov
 2024 17:45:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8182.014; Tue, 19 Nov 2024
 17:45:03 +0000
Message-ID: <632a0b08-d7d8-4805-9530-8001e50dcbc2@oracle.com>
Date: Tue, 19 Nov 2024 17:45:00 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] RAID 0/1/10 atomic write support
To: Jens Axboe <axboe@kernel.dk>, song@kernel.org, yukuai3@huawei.com,
        hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com
References: <20241118105018.1870052-1-john.g.garry@oracle.com>
 <ef021fd8-1cfe-49d6-a6a2-c9745cf61441@oracle.com>
 <4daaa186-14f6-4d25-939d-90b9b2088051@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <4daaa186-14f6-4d25-939d-90b9b2088051@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0002.eurprd03.prod.outlook.com
 (2603:10a6:208:14::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB6760:EE_
X-MS-Office365-Filtering-Correlation-Id: 6337ee53-5542-4f4e-475f-08dd08c1e5ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnVlK3gwelZ5TzExODJFRTFUMW5jOEZJUTRKakhGbHBVT0tueTVQUm1SbDVS?=
 =?utf-8?B?alh0LytXYVYwd0hSMGZUVEFqMWYxUFFUSkEwbWlTcVp1MG1obTJlOWNQUElu?=
 =?utf-8?B?VDRrdkk1ZEhWQ1pLdFpZckpTaUdYYVVKbUNSOGs0YWRrNGU1TksyZThYWG91?=
 =?utf-8?B?QW01SnRmRU5FZ1hpNmFhUDQxN1NWY05TalMzRzZKbHQwUDVna3RPWG5EeDRz?=
 =?utf-8?B?NlcxMWFyTzZiSkMwbW4yYlo2RHhGQmJ5Y1FoTkJDVVhSMmhUTGRkNjNDQ2Jw?=
 =?utf-8?B?RFd5SjZwdmtEbTh6bFUwUWxsKzZVTy9HNHRwOFVhdlNPZHBHTVFLbWl3T20y?=
 =?utf-8?B?NDZKVmVvb1JVclJBQWJtVG9hU3BpM2o5d2tQbno4RDRCelUrNUJiV1hTNWpw?=
 =?utf-8?B?VkVwYWpsU21laHNNa2IvSzRwQ25rcDJ0NG5OZWZIRHluK25pYjlac2MzUzVY?=
 =?utf-8?B?MllEYWo2VXNOL1BBUldqUzlpUjY1bjlsb0haTTVKZUhpSnJ5cit2N1B3dnZz?=
 =?utf-8?B?VGhITUxyU1R1NnRpUjFpckdGTW1DS1dDdXVuN0Rmd096eERyWEg4OVRyZ3lm?=
 =?utf-8?B?aDlNNkZXNnpkVngwL0JWNmVVWGJiSjNaaU14emNKWlJHbjlOOHhaMFNLck1B?=
 =?utf-8?B?VVJJSmMwdlRtZ2NMY0R5bm9WbWdGREhGRkEwTk4rcVRiOVkzendmQ2FHZzVG?=
 =?utf-8?B?dkRvZWgyRTd0Z1I2NThPK1N6OURrQVluSnpLcnZZSnV2ZmUvNU0vSk9wRUZH?=
 =?utf-8?B?ejJDa3VnZUhmVGx5ZU5KL0NNWE0xL2d2R2xIOXZNN0VPTnVyUmxqdkFUbnJX?=
 =?utf-8?B?NVNSRzZPWGxabGRFdmZGbTUrZGJjVFdmZzVSNnp1QjZ1NU5JRTBGb3hBS0pU?=
 =?utf-8?B?MldDSHRoY2tPSit3M01HSlZ3Z1V6RHlBc1JIZzJrdlZDZXZScGMraU9TVzdn?=
 =?utf-8?B?K3Z1TmtPSmt4S3l0eDVPNmdJRmhKRmtoT0lQK2xnbHVHdGp5ZGVLbC9ha1ZI?=
 =?utf-8?B?VDVXTk0waGtmeWxOdXFsOE1hVTlYcnVpRlUyMXNqRXA2cTUvamZBbnpHenAz?=
 =?utf-8?B?YVVEQStlVHUrQTdRMEFyWG9aUEhqWWZEaU1vTGhSUlp1eXliZjloOEZDWm9m?=
 =?utf-8?B?Wk5rY1V4UzV3SlhrVDdCZWVMckd4Y3ZnZ2JwM1dBVGs2U25xaXZLWHVTcTZu?=
 =?utf-8?B?bDl1T1JzM1VUTTJPdGEweTZPRjNxRDg2NXpZd1lMNnhrL1RwVm5PRXV2S2Nl?=
 =?utf-8?B?bmwzbzlHczQzZVVhVHhmKzh1aWpqUHRqQWVocS8vUHN6RGI1Zzd1VDNGNG02?=
 =?utf-8?B?eWZHNzlJNHMrcEpxQXRuUVdKS3NxWHFOMTBLYndPSjdOb1JicW5NeW4wZ2Va?=
 =?utf-8?B?UVRwV0Z1U3ZEZEJJa1NhRlpsNEx5eUprdTdyUk9BZEhhTmg4RGM5OUZ1aW4w?=
 =?utf-8?B?QldWK1kyVTlxb2hJRC9yZ0lmZDVMRGZIQ0gvTTY5OGkrbUY0ekk1TmNtd0tz?=
 =?utf-8?B?VjYyMklnd2pjdWtSdFZnWmljRkU5MllhWjVlNk9MQ3lTRkNWOUNUVDZ3SnYz?=
 =?utf-8?B?N2ZVaG94QWRjOTlBZWRDeWZLVkhmL0x1L2h0VC9IbDlLQVNjVVhLTDIxOWlM?=
 =?utf-8?B?ZTBrOTRWbVhzSy8zRWQ3QWc1V1lIelNMNWtTOEFVMnJUMFJ3S3M4WjhTckVV?=
 =?utf-8?B?U0NvVlVyaG56Y2pjNEFOM0ZmSFMrN3hGTi9XYjdHMm5YZ2tDWCs5SWtHM1F1?=
 =?utf-8?Q?ToOIlPYj45+9cWM5uA1R+SKP3PK2Ks6UC832lhb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bngyMmpUR2lmUGtVRXpFQVl3U0ZON0JNbHoyOGtMcmhpallNbkp6R1E3UnRo?=
 =?utf-8?B?Wk9XWHdTRWtZT3lWM2dsTzhxaHNNK1lhMzY0d01COFFDMWZaTzJMY1dJU1FG?=
 =?utf-8?B?cDRCdUFtNzRnaXBZQmVZdk1RZU9FaHVNdWhQeThYaTNXajM4bUNFZzYrQVdY?=
 =?utf-8?B?TzlQSGF0UE9OZ0dWVWtqU0xXQjlwY1BPdXA3ci9pU3dXaVRVM05tNnNCU2FV?=
 =?utf-8?B?YmRJekVTUG9qb1E0VnlhQVV4UTVJYzRodnJaak51N2hBWW9EQk5zbGY3N1B6?=
 =?utf-8?B?a01nZEdSN2R3WWN3M2JaZkljMjVzSEk5aGMvUGNONU1BRnNCSlJIY3FseXVh?=
 =?utf-8?B?R1J4aEZGSjg1Z05qZ3JNWW16U0NvQzhBU0h5VmhSY2w5SkYydWxvWXYxUWEz?=
 =?utf-8?B?YzJWVklCNUFvaDllSlk4ZHZPUlY0eHIrUGVXaUJKR0FOcEZCcURsVXpCRnhM?=
 =?utf-8?B?RzQ0a1I3Rm4yY1crS2hTSmJVQVBtc2dOTkZOdk9TOG4xQlcvTGs0RExoT1k1?=
 =?utf-8?B?by9LU216a3NTdXVmWDhPazh2NXVxck14bkE1SjlCYmxNeGZFZlVDOVc0cklr?=
 =?utf-8?B?N1hUSEtBRlZ6eDFWSk4zL3YrOUd0anQwdmdVUHRCbzhSUjJ0VS9EK1JHeXFj?=
 =?utf-8?B?Sytqb1Uvc1pPNlBkZUtvRGptTUtZaEh4cngrNFllZjdQa3VVSTU0T0JieUVT?=
 =?utf-8?B?amc0Nm9yMzhDMGFncHhVUXh0eGJKcVNkRGdoa3hZSGNCc2pPZE1UK2FWZVIr?=
 =?utf-8?B?Z1A0T0k5V3pxTlBieWF2WHNyZUZmWVoyV3l4NnFpTFJMMGFXUFBsVGFsTmVl?=
 =?utf-8?B?UVRuS0Z4WlV2aUI4cm9aLzY0ZDRzVmUzU2wxNlpqR0tDQXROL3RlNlY0M0xs?=
 =?utf-8?B?YllBTmwvQyt5NExtcWg5ajR1UlJFaW9uNHptdXNCeW11YzJDUmpsQit0RUNP?=
 =?utf-8?B?YndRV1NQcURWNmZTT0dKRWlISk5yZGpSYkZMd1ZNdXhzTGljYXRNNE5ZWjI0?=
 =?utf-8?B?NHFVc2Q3WG9YK2FtdlBxUFk3bExTZnluU0ppaUFSbFdyOSs5cXM2NzBwOG9W?=
 =?utf-8?B?WDVqSmNqcS9tMW1vRkFqcUgzRzZac2xpbGNHZzQxaXI0azJUYWVEc2w4aGRt?=
 =?utf-8?B?bjk1aS9WY3ZWS1cyNFVrMUNlQWE3Y3VERWRJZm5MVnFPMUVyMTNCaEkwY2hl?=
 =?utf-8?B?SmhhTjVWYlVZTU5vd0tHUTFGUlZCSzZYQjlXVHBySEs3ejJ4dE1HbGVGZzZO?=
 =?utf-8?B?Rzl6Ly9idGFCSXlwcExVNmx2UHVqY0JSV3Y2VnFKMU9CejQ0MlNRbG1QZzNM?=
 =?utf-8?B?TlRNa0RyUHJoWWY2b1lvV2dPNXlWODMrOGdzamE3Qk5hY3JDbDk1Z2VuQVh4?=
 =?utf-8?B?SUVDUzQzRjFhMkJ2QjFwUHNET3BmWDhobFh3ZWg0YmZ0aDVQS2JlNHh3bk9y?=
 =?utf-8?B?S2psR3VOSlFmRjNEVjB3OExiamw0WjZZaDY4M0N1S0RyMTlIL0dDMng3ZEJt?=
 =?utf-8?B?Wkg1WHdrSEdRNVJKL1hLcWIxRDJxZllQZURkZGh2VzBobzRKUC9uTlRYZFFq?=
 =?utf-8?B?VU9MU3hyYVdKek81UFZKZ0QyYXpLcHdsb0l2U2JYWkJhTHZ2NkpkTkJvUDY2?=
 =?utf-8?B?T0c2KzZic05kZkNlL3BSMGJjVU1ubWdrSllreEtVa1RER3ZkeFk1TmYyeloz?=
 =?utf-8?B?UjZiS2lqd3NaeGliSytXWWwvdldDUnlVeEhjUVlPSjVNZE5Rb2NhTElXZjZ5?=
 =?utf-8?B?OVhZd08yOVg5SDZhYVFmWC82bC9xcFlpZlpvMVhoOUYvYUVaQUZ4d1JUZ1N0?=
 =?utf-8?B?a1JpeXdWaEdsYks3N0Q5WUxOMXkwMWNiQTJCQ2pOWWVoWWJDMCthMkZiV2Jm?=
 =?utf-8?B?bktxditiVjRscTZ3VDM2L3Z1bDQyK2lTbklJMGJva25CZElhRE4vSnJSYk1U?=
 =?utf-8?B?T2d4WTgwNzlBRXUvUFhHeFozMEVuY1RNNER4NUhDT012MUpVektlaEUyQ0ps?=
 =?utf-8?B?R3doNHBQSjZDcW9WQUJGTTJFNzhkU0tTc1hwU3NkcGdzSDZSMWRtelNSZnJk?=
 =?utf-8?B?QnpSWmpCbTM0WjVmY2hQZjc4VEhDU2lpTS8zckxCMEdScDlUbzE2VjFRRThR?=
 =?utf-8?B?K1FQc2VtNVFXVFZEK3pDeFNDMHRxekdJZ3ZERVd4elY2Qk1nVXdrRm1HVGNv?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UhdOSdD8/ItLn95Cs4Ma6wzU3AbiXIg2cHwTjdKHNGgDk58qpMhPThyFGv6zir7Iabok6uFyi5V+GlTEjYNi1EXKH8IrtHEIcHObCLQEiPCOJOqr6HZLhw52EpNBLMrzn5KX813Bb3CZV7P7G1zvjHfGOEGWbi+EP/QIRCEoqHW3cozk48WDxY9rqo4qh1vezEu3t+ufrCGrQhU/462IibI1M1tjonwXgIMnZQkpsa3P3lJbC92I9RW63TyRgcezQ3EZtQ6iqD5zQXDAgDEwrRgu+BL1ZbtD73xGWTwfFwzN1XFUa8yGrNSq0kuVeoe84iH09ha1gAjaoYlB+MBKF7BYjqndFTtLUZnCeu8dbAaZkzSS/INlTe5otdgK10VHRlkzPdTJ9I1PR2k5D3X5hzjdeVj38VcQm3n6v02TrZX91eccpjitKWf7KgnM5TsvvBVPVc2GtIVDrp9L/rysdBEcCiI1FflgAutt/XpKMBKMDSk9s+4VWuaATvkLenzE0c6abU3wLZAi0pEAV0MQ8JuWZW9msyf2oIqYN6rBSN0oG9cf+3v3Do0atxrXHDuKUaCqihLgAkbey555bN59LjL707ntRdhH18QdpZYMXTE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6337ee53-5542-4f4e-475f-08dd08c1e5ba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 17:45:03.5185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7wB7t3ed7ay6rDs7LBVhXOObAITbxo/rxIIpq175WeTuDdXyMEAghFJwJn3d7sfb8tarnm/KXpH6HVkP6mXRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6760
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-19_09,2024-11-18_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411190132
X-Proofpoint-ORIG-GUID: ECoMNMdxF2etlircxqvoeCtWlR1Pi2lg
X-Proofpoint-GUID: ECoMNMdxF2etlircxqvoeCtWlR1Pi2lg

On 19/11/2024 17:29, Jens Axboe wrote:
>> If not, I'll repost for 6.14 later.
> I think we can do 6.13 for this one, I always do a later pull week after
> merge window starts. And this has been posted previously as well, so
> probably no reason to further delay it.

great, thanks

Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1736E2EAE4;
	Tue,  5 Nov 2024 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730827027; cv=fail; b=Dde+FJSpxCaYa4y4jvAIYPoZ4nU4M9OU5AHuwDPsbCDcWAginEkOxnbmltVawbMf6b+rT0LdB2lKXdUzXktZBObFzr1hhd/vLG+YM8ufbfntGFuKns06QUbYPEsCSOXyvl+b1IJXylTZ0wZrnpNjFbg2xfmQFbPT8s3L5ttpK2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730827027; c=relaxed/simple;
	bh=p0AzE+VqfqKb34CyJVQurjWmezBod+IQFCoqXQBXYHk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nh8znvRlAQgZyh1kkLc5aGmyrgtVzdrl/KdAmqISpi8sQ2xQjzsorpzpkseln1yVA50KH9HCa4mYagUGCPgiejhY/Nw+d67cAUwo/H9jWEraNYTvGWGENS6RjwwoCoOCVSwtbbEKpugtizSULgjja8N8/6XluP06WQquNP+re4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VPkxFYV8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DbFSRjw8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VPkxFYV8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DbFSRjw8"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5DiZep030190;
	Tue, 5 Nov 2024 17:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5FRIi46gzoTLQl9jKYcpW2bjCmOj0n7HkqBgG61bgAc=; b=
	VPkxFYV8NTuuXty1Q97LcFH7nsXmPb0JG0fl/lVV03u/aZ6tsxs8QClkDnZaGVjG
	WOhYE3/P59S6w5TR2BpdzC6Lj2SZsRgxaLbn3UC+SE1Wd7ccUwSQGo8APSjg9dP2
	nXWDDLpwqYaKxg446vihCAb35RzTuKOko7GdbYwFVTZVEpI2E6jur8BDrKpiAVQq
	QwHhxVClWDneKuN5lBzZ3JZoD5STi5LWnPGGOR8axhJ5TbPvauBoH7nmqCG1Ttj9
	ktRTknwSlC3HWSvpeCHbB8QgbFTVsWJ0hrrmvCmKiwo83dDoOjTLjd5/0L5RYpb7
	d5wN+c0xWo7VlgYKmrtd+A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nanywysb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 17:16:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5G01Nw036767;
	Tue, 5 Nov 2024 17:16:49 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah7cwdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 17:16:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yh8la/xDLNFpDUaMKbqFws6xhi87HySPLwAmv5av/48ehvJTfcWCOM/aJPd9X4Ss9WeOy2PN5dmm6QQCspupsFYXGVw50ijG/DQDbQFUU1hMbOK6qUNxAvcykPL1cYMwixMM9bA+pOI6U5EtSTizHSFqWhstSiRdqB00rtVCiVQh9G/xfA460C5C+nC81w3BYE3c3uED/Bki81+Oqmu3mMeKRpuWdbrljmRhjYTMLtuUQxoU56Zqz5yOflMHCtUy9rpCrrmrx90UJibyvAyy0FG/Yy6KNlATDsajnB5TQQR3JLzn1Ha8B1RS3wgG0I0xcr0o0s4/2iK57fOfWOTJvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FRIi46gzoTLQl9jKYcpW2bjCmOj0n7HkqBgG61bgAc=;
 b=TqC2dUvW9GjbApVv7m/WG3Lg1cxpKpAhEDOH3r8FqZNCEKg5NP2yMf3RyrfvXJ/cOEYdZ8+IAicE0m+xUfxSpGQD8oYZGchNFO1WYYdXbAhikrWuXj+jIai8ztBNpvbHcXjjjwdGYCzplv+5wFAS3y+N6rmJIRgHPyc2K8x1AmxIXbIs5ADyRgqP17q8OaQzhR3nr8EeqilyNgIL2NK38wGK1k8QYIA7upnIwHO9GRYvP20SLubCVPWSrEmF0Bz+T7iz5WL1yi2weV+zXycSA4IcXJty/nNA/nD7QgdlQVl9RjMAHO0g4SpfnV7dQr707+7gHshkjdgvDmM5p1+HHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FRIi46gzoTLQl9jKYcpW2bjCmOj0n7HkqBgG61bgAc=;
 b=DbFSRjw83haJr9U4p4dLZBtFpkASDNegZTYvBxGmc2XM912+6Co2RBHyOTPMJt3o87kPMrz42nbtUTuybYODa9G74TbL2fO/GRUzol1HJAE9mZuacxrmti7zhJO5Cxxpq6m+K0q75dI+CPlYGqrgizhyEDpKwCmPTIOiY7qUnk0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7480.namprd10.prod.outlook.com (2603:10b6:8:165::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 17:16:45 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8114.031; Tue, 5 Nov 2024
 17:16:45 +0000
Message-ID: <7df194bf-a5e3-4ec9-928b-67c68eb48eae@oracle.com>
Date: Tue, 5 Nov 2024 17:16:41 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] block: Rework bio_split() return value
To: Hannes Reinecke <hare@suse.de>, axboe@kernel.dk, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <20241031095918.99964-2-john.g.garry@oracle.com>
 <c3102f97-df59-4859-9af1-d241a357d02f@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c3102f97-df59-4859-9af1-d241a357d02f@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MI1P293CA0008.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:2::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7480:EE_
X-MS-Office365-Filtering-Correlation-Id: fce2f4f7-402f-4365-c46a-08dcfdbd9f98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vk5UdGtLdmlMdUUxKzMrZFl2TWdVS2JqdlVXSGNGczNqanBBSkJHTlc3cEhs?=
 =?utf-8?B?VlJiMmUzTmN5NVVsMnVZOWFrSlAyWFE5SFZnSmNuOEpZcy8wYVlNRjVlRUtm?=
 =?utf-8?B?UXU3NktwQUdIOWZ4ZzFJYlJQWnp1OER0elFXOFZ1QVhacnNldEFJSmdROUNU?=
 =?utf-8?B?bXJUMDVZREluVTNLYjJldDZsMXJDdGwySDdOYlJpUzBCMWcxdUg5VUtCVVZB?=
 =?utf-8?B?dnI1K2Z4cmRkZFVsdTI2U1QwU1h6OCt1aUpkTitHd3pKTlduU0Q5ZVh5R3lQ?=
 =?utf-8?B?bHY0ZlNwQWxNVkQ5b1RWTGhGZHdzLzRKUjRmNFlocU1RMWhpTmlubWJUVTFI?=
 =?utf-8?B?UFA5QmFJdVA2TndGZ08wTk5yV2xqTkN5bnN3dzl6aUVuSWY2MXBwdHFYbDZ4?=
 =?utf-8?B?Z1J2b053cXRsVXhvVzNHT3dpSFFnQ0I1b1pOaU9KV20zRUxKR2pXZ1VJTk83?=
 =?utf-8?B?cDliS0xlQjNWTHJMY3FDSlFGVXNSZnFTNlkyZW1PZXZnL1pyUVNOVXVoYTZ5?=
 =?utf-8?B?bUtFUi9tZ2tDTkQ5WFdlbEtqYVBLcDdITDhJUDBvSFoxa3dCS1RkWG5uTnlY?=
 =?utf-8?B?YXlLN0xNMmtNYzZBQzhyK1VxWWhhRmhSS0g0UW9KMS9GYzZzNGFVOGVaWi9i?=
 =?utf-8?B?TXhSKzl5L1QrTVE4NlpBenMyZlZiOVEvdXJjQTlOeER4NlNjZXVEaEZUR2hI?=
 =?utf-8?B?Tjd3eGZSMkhNUlpzWHJGZ3ltVmlxL2NhSXZXeEtCaThxN25uUmhhbm5ENGxv?=
 =?utf-8?B?VTU1NTRuSjFOUit1eFVpa05CMXVGU3VubWZiUkJOUVIyQ0poUm9lNDB0eTEx?=
 =?utf-8?B?OVd1T2ZCaG00Mlg0OGxEdy9MZFF6Vk5RakxiTGdlWURidDluUXpvQUtzSm1F?=
 =?utf-8?B?WUF2YlpucDVxa1JDdi91K216N3JKT05RV2d3VHNNN1ZwNzR1em8xT3o0UDY1?=
 =?utf-8?B?Y1h0VVJTM1FJSGx6eVRXa2RWTHdRa1ZxRHg4MVorT3JnOWc4WENMYklyOGpt?=
 =?utf-8?B?T2hMOEFQWDdQcE8wODVNZ3VWY1hrQTBkUWd4eFZMQXJhZzY4ZFRnZjcrTHNi?=
 =?utf-8?B?M0ZHWm1zSDVySUdxRlNuV1Y3MTNwcHg4cjh1cnZtcWx6YjVZcDJBMWJPNWFG?=
 =?utf-8?B?Y21qSmlNTkJCdkpienptNWp1YnIyZHZneHUyc2tsMEVBZHVXM2NkU1NiZ0tW?=
 =?utf-8?B?Z0k2YUgrbHdIMVJZYWxzak00ZmVoMkRpUC9DeDJaSFJzWkRDMzF1UnlEVWlK?=
 =?utf-8?B?dzNjNStFZUNvcjNndUEvVDJWY09UMkh5bUhyOWI0cUlONjlEZGpOUWw5V0NV?=
 =?utf-8?B?ZE9Rcm5GZlhhUCswRExYRTdINkptOE1CRUdWbThrWm1jb1lmMEZRYitFVFl6?=
 =?utf-8?B?Yjh0SWlMQlpaTkJDYURrNi8zNkJVQi9ETnJSZDJrSHlLMStQVS9kYVJVay96?=
 =?utf-8?B?Nm9vLzE5SVVOdElvbW8wNGZVS3E3WGpEazdZTVdGK2ttbDhPK01TcUdrSWRF?=
 =?utf-8?B?QzZSZWp2RFZibkNuVjg2bHFJUFIwemt6TUJxdzl5WGJWL1hyUlVROHFVNjY1?=
 =?utf-8?B?U2FwK3QvdnVMWkFjOHJaeVJhOElQUkUxN3V4ZlM3NHgwSUFnKytOcCtBR081?=
 =?utf-8?B?YWNkaWN5UFFjaHg4Z2NKODBWc2g1NXhlZWVCMThsenY0dCtoS1haNURGeFJx?=
 =?utf-8?B?R2wwYWFGSXhmRm5Yb1VjVStOOWNuMkVuTU0vRkFwUFNzMVZkbVVBU1BCTTBs?=
 =?utf-8?Q?L070tac6LDcf4H6XRY0IC2+Ev+WkpcSYKn7w/BJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1F2SWlYRzRwaDlWUUJ3MWh5UXNRR3llUEFzMmVQSXVmQ3R3c0ZadW9yKzhC?=
 =?utf-8?B?TnlpRFJGNmQ1TStmMFQ3YWw4NjUvZnFSTDRlZkNMMHpKZS95L1VVKy9MQXgz?=
 =?utf-8?B?cGpLeG1HVDUySUJLbDExSG9pREhRSkhhMnZjaXk0bUJoL2w4YTg1S3VIeGtx?=
 =?utf-8?B?U0M3OGw5S0VYTnJJeVpvYjhVaU9UTVBsKy94YlBmcnhrNmVjZXkzN2VVL29Q?=
 =?utf-8?B?YnMrK1h3SjNWcmx6d1YyMlEvQ3dFK3BTZVJ0N2VGaVRzckYzdUJUN3I3VDBt?=
 =?utf-8?B?dmZFQzhkUVJaaTZjTFE2bFpkWWpWeTR6VzQxWWRpTDNoVkpLMjExbXB4NUNi?=
 =?utf-8?B?YlVIalR1ZUtNTGN5dGhuRzZjVjJPWVZoa3JTdGZRWDBkZVZuUGtJcXh4QmJN?=
 =?utf-8?B?bEYrNWVFYlBGWVBLUFlYYzNnQndneHpVYXpLRTR0bk41RktNZTZxODl2bU44?=
 =?utf-8?B?blBnaEowTTJlZ01JN0lUZnRZMFZOcDZ5SVBBT0RGQ3lrZUFSOU0rdzlPeGI0?=
 =?utf-8?B?WC9VSFlpMGkwSTZhaW1EZHdxbXNQemsyQVRmWmRsV21VR3JrMWpsc0lWS0FK?=
 =?utf-8?B?NkVQeFB4VUlJTW1aZlVNWDk5djRRQ1BqTU1ST2ovZjJRVU5GL29XU282VXh2?=
 =?utf-8?B?dXorNWY2Z0JlYWtsWHozc2xhamdGa3NpUnRIanpGcmt1ZUovSVQ2VXJrVkJH?=
 =?utf-8?B?bmswT1g5M0R1Tm1rZ09XRTNhOGxjU3M5c1c1c2JqTXlaSC8vSW1scDdZWTJE?=
 =?utf-8?B?OG9GQy9qZFlUNzBFQlgwUU9LV1dJZ0diaU5KQUtZUENBSk5GcUdFVDJWSUlK?=
 =?utf-8?B?UzYrZ1k4N3A3cEpDUXVjOEFGWmpWUzhVdTJEL0FFYnIra3lBbnJ6eWZtY2pa?=
 =?utf-8?B?aDA0VDFOUWRiQVpoRXBGc1dPUVRZN3RxRXhXMXNnR3IreVB1eUJWbXMzMWhs?=
 =?utf-8?B?ek1mMnIrYU1aK0hJUG5LN2VjN2FBVjJidnRuRU9UeWc2UlJnQ3d3K0VCZVNJ?=
 =?utf-8?B?SkVQbEx0SjExc2RSZi9GU3p4cDJvQnNFSTNKUTVPUzRpTUdMVDRFNzg3UWov?=
 =?utf-8?B?MUxJV2JXVEVOK0lrR1UwdzIyUDRWL0laZzNVckZIZnVmZE54aEpLcHZNSjBB?=
 =?utf-8?B?OThrU0EzeGVVMmpCKzVzZWFvK3UxSWpHWEVwMytod2xDVTBJU01FNUxZczNX?=
 =?utf-8?B?NE1oRW12K3FaUG9iOG9GczNjOEJpQ0pzdzdYZ3pwbVNFWHpuK2tqZVpud3RL?=
 =?utf-8?B?QlZKZUt1OUMrc2NtTUIxVDBrYXgwNUttdmNJSS9sZGFwNzZoZ0hDem5EOTY1?=
 =?utf-8?B?aVdPS3NSY0JZdHYyQjczUWFzU1o2c1cydHZqRkFpWkpjek56V2xlSjRkVDBP?=
 =?utf-8?B?SE9OazliQ0hNZ09VNmQxZzFrMUEyYndMNGpwYmlKZXIwd0M5d3FKMGI4bVRn?=
 =?utf-8?B?VmFhNXJtM3Y5MnhYeG5hemJWZEp5VkxraGRoTDNad0NSK1pkOUg5NVdleU93?=
 =?utf-8?B?WHBFMWl5ZllzNWtKQU9XUEdRdmRreFA2aUMyQkZCbmlmdHhVUDY3cE5tNjlu?=
 =?utf-8?B?dk5CQUc1V3hFTkdWVGtubm1pUEpoem5NU0dnRTBWQTI0VWJtUDVHcG40QUxj?=
 =?utf-8?B?TENxYkh4bnlLc29ueGZGQUVlUitPcmN6S2FlT3UwWUpSVWNaTzd0cG1GRmti?=
 =?utf-8?B?RFVMSXFOaHllOXN5bW1nQno1OHFUcXNyeUxnTFpLUzFBeGx4cW1HaFZWZWdq?=
 =?utf-8?B?R2hVTkFXb2lUVDliQ25OdSt0R2xidk9zbDNEQzhVZ2JnYkxSY0MybHRWbmEr?=
 =?utf-8?B?aG85VnRKUUFDTGJLaHZMM0hRMEFIZ2RPTUlxS1VJUEZxUmhIem9Kdy9uS0Vs?=
 =?utf-8?B?SlErTVR5Sy82YlZaYXY1MmkyQnZ3dkx0ZGp0VE5JZ1FrKzRldStjZHNwUmJU?=
 =?utf-8?B?a0VrcG5KeUdrbU9mVHY3UFFJWVRiN2RkTFFhTUpRSFFZeXdyZVNpNDZNTm0w?=
 =?utf-8?B?THJNSDJxUTF1UGpYcFNRem9qaE5xbDdab2tqQnBlRE11TG9NZ3Z1RHdXd1Z6?=
 =?utf-8?B?OTQwZkFvcHR6eklzNVdTa0FWZTh1S3ZxUW9qREVhWVVZL0dyYnZlUWJ5cE1p?=
 =?utf-8?B?KzF6Z1lZZGJtQlRlNDFheldwR0NPbXU1VEg1Q0oxYy8yQWY4L1hBbmc2cFFx?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K0I/Jl9i8LWZ6rjGePoQRGVz+JGkLiKAqtkvd7WY7J5FwmMIuB8nYDr9JMImg2QZWUKZPOC3rdfIi/YTQgwb4nehEBADsy7Wjm1P8gOmR1nrsKOryOutGyAJppULR+jz+poT15j/NUhf6bO/ojfbNL4t9+/Z2ik0lPEksklFlNPtKQ/3twmp6bdgNg9HjcXYn45zcD6L03vzy5Q2BqcMJ8nmoT4r1UsvsZSTqgciBCiaV6yaAI+tTunRn/lxqqWB2z/Po2MMdA6dWSr1tEHBZn/b6o4xnw9aXR8yc0q/7VL4EuO6FMshjvpNMnzRX+ABHaHtmLb1GGUKl0NcDyKAZfqrkbiLsAmDgErbxkLQm1n8zW/6vSh4IY5QEMv/JX6uMzm0z39syIFIrXXXP11MnB34dXYvqTteiNjuJqZc37orpsIsVVksozc+4A+NEVimi/JExClEizDEtgTyWjY/tEPjprFZIiZy8G6H2rA03TKdaDnrgO6qL1pOa14yGMZrz67R9ivyv/GS07vswhDwB/k//F+x2/wH8w8YtFA5/ZsXYBSS8B4TdzwIcaP67oDNkWz28Gp+jiND/93Kg/EVQlum57zLrCR5zq1a6cqqylg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce2f4f7-402f-4365-c46a-08dcfdbd9f98
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 17:16:45.0967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4t5+wawlEGFHsUiDXxokOnwHTMzDr5VUqIdvMi5I/e2Tr8Sdtw50O82RrOft0NtNp3tEE9GikMHolWqU23Gww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7480
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-05_06,2024-11-05_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411050133
X-Proofpoint-ORIG-GUID: mP2txhSLecs8UibMM0lmMjRu9I3qvqG-
X-Proofpoint-GUID: mP2txhSLecs8UibMM0lmMjRu9I3qvqG-

On 05/11/2024 07:21, Hannes Reinecke wrote:
> On 10/31/24 10:59, John Garry wrote:
>> Instead of returning an inconclusive value of NULL for an error in 
>> calling
>> bio_split(), return a ERR_PTR() always.
>>
>> Also remove the BUG_ON() calls, and WARN_ON_ONCE() instead. Indeed, since
>> almost all callers don't check the return code from bio_split(), we'll
>> crash anyway (for those failures).
>>
>> Fix up the only user which checks bio_split() return code today (directly
>> or indirectly), blk_crypto_fallback_split_bio_if_needed(). The md/bcache
>> code does check the return code in cached_dev_cache_miss() ->
>> bio_next_split() -> bio_split(), but only to see if there was a split, so
>> there would be no change in behaviour here (when returning a ERR_PTR()).
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   block/bio.c                 | 10 ++++++----
>>   block/blk-crypto-fallback.c |  2 +-
>>   2 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/bio.c b/block/bio.c
>> index 95e2ee14cea2..7a93724e4a49 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -1740,16 +1740,18 @@ struct bio *bio_split(struct bio *bio, int 
>> sectors,
>>   {
>>       struct bio *split;
>> -    BUG_ON(sectors <= 0);
>> -    BUG_ON(sectors >= bio_sectors(bio));
>> +    if (WARN_ON_ONCE(sectors <= 0))
>> +        return ERR_PTR(-EINVAL);
>> +    if (WARN_ON_ONCE(sectors >= bio_sectors(bio)))
>> +        return ERR_PTR(-EINVAL);
>>       /* Zone append commands cannot be split */
>>       if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
>> -        return NULL;
>> +        return ERR_PTR(-EINVAL);
>>       split = bio_alloc_clone(bio->bi_bdev, bio, gfp, bs);
>>       if (!split)
>> -        return NULL;
>> +        return ERR_PTR(-ENOMEM);
>>       split->bi_iter.bi_size = sectors << 9;
>> diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
>> index b1e7415f8439..29a205482617 100644
>> --- a/block/blk-crypto-fallback.c
>> +++ b/block/blk-crypto-fallback.c
>> @@ -226,7 +226,7 @@ static bool 
>> blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
>>           split_bio = bio_split(bio, num_sectors, GFP_NOIO,
>>                         &crypto_bio_split);
>> -        if (!split_bio) {
>> +        if (IS_ERR(split_bio)) {
>>               bio->bi_status = BLK_STS_RESOURCE;
>>               return false;
>>           }
> 
> Don't you need to modify block/bounce.c, too?

Today we have __blk_queue_bounce() -> bio_split(), but the return value 
from bio_split() is not checked for errors (NULL) there, so it is 
already in a poor state.

I will look to remedy that and other callsites which don't check 
bio_split() return value for errors in next phase.

Thanks,
John

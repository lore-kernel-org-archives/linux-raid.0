Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0448530C37E;
	Mon, 18 Aug 2025 09:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755510736; cv=fail; b=eoOnxcAiJ4qTeAwOYWWPK8Gsf1gok4Hjm6tdP9MXo9NjP1yIEDD9GAU1H4+WETIe3fQld/7eQk/gnwcDrA9xl/TLe8Q15LSzpPNACIn4LPHVDsPiwofv5kN2jTNcmsECRtRqZx6/ptQoCcIQtGACBot1TUM0Z1L+lR06UDbjn6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755510736; c=relaxed/simple;
	bh=O09r3eDZfoTtcmTzDtzY8qL6oYMcMGSA7HgknScBBuQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dAN1NjWG2mIb9O+467OOWQhu2jnprlR3WutEm3GL0iwnv539l04y8fh52x5zY3Wz8zy3+/zfQQspA4g0gBOxO4/vIfexF7S8S1utN1MJa8lEXcsjb0GvcBgZXFn57fAC0pItIZBwq8iuLUXL4QiD5hnxCNxe5yFXsV8i2j2Bkgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PoBlCcKy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fCQz7PUq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PoBlCcKy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fCQz7PUq"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57I9esfM016851;
	Mon, 18 Aug 2025 09:52:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rv4erUAy71G2enfJSZz+WBxXBTlgMgXz9rkESt+4Bpw=; b=
	PoBlCcKyx6jj7hFxK28SsdnvJ7yLkZ4HgByKIQx7VS4vBtuZXM3swqIhliIZP47v
	PbCENDQCKK7HPFccmvy3v3SENpV4vHVv7mhj6UwCmLCb/VetKw6QrpMHcIi/jb7c
	GbZ79hEnT+s7aRfDJvmM8b1+YSFOFh6V2xSlOW0YduN0JKr8vLPnrEArykiTNSE0
	Vy/yUfuFyCCVEBVXbzKL1r2CA5VnasEqb6OUxUkYN5nZjin/6QcEliyWD70N2M+W
	UVnCDmBfsycbJTvE30xVmA8Q47pYF3SiFNmypq1J34yTCQXhgfBkH5WhJCNrslGt
	uV054RK9G4z9z7YK+S4lFQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jhvdake4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 09:52:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57I8eipM011581;
	Mon, 18 Aug 2025 09:52:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jge90e0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 09:52:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ty/ipX+ka1918yRVHjIU+w6Fdu2MtBXMkWvA1ED/d21T6MzrCXy7/5tOYWiGWp8YdXaAVZ2ALp31weiTVdK61Wi414Q8HLMiEy6NNIICFsxvrpFtfHGf8Q40/V8MoQ3QrD6tw0Ni41tYEVkcX3FgzYqO6z/h20MEmlB0DDTM8//kW5J2qyx/xmqseOXxANyAeXMsTxRniNsUOLtmBcykW0oGS1tVPyLTpBknzA1Sw/sgIpX3DvH9qhwVd7EZ0Mk41nDXJ4/7aujPtx4yZ5XcANtv3IsVu/+e1H37yGN1aHjvbEnlZhkAFmG9l2i4hh7gdm4Q0VLnZGVCjdf/tJBAcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rv4erUAy71G2enfJSZz+WBxXBTlgMgXz9rkESt+4Bpw=;
 b=s0fhSlctbiuKSaLj40NyW9pchRWvoIaY08MfMg1f57sR4/U7pATeiJhxvni374ULYTsJq/JMrC8bvATe30+2jIpYTCx/8DcagXE868+QXw9ni6BLqPeXPsum4/xi+rX3r0OtRjbt0u5twq6T7AFEDh3LuJC5khenC26QY8yLOlH8wDSprRR2kvYKmu4x3GJZ7rdUWQe/SvVZcqbAP+HvcMpXLJa39olPvhR/Z3zrY67clXNfaw3dKB5jM3VuLcu+XJiT6ZHdHgtQnjvrk9aTGfu7O8gueywOVqfiCHrxDtOriX2tmWvReC4FuNOG2f6FepaoCNqaEm/iSrzADrJmuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rv4erUAy71G2enfJSZz+WBxXBTlgMgXz9rkESt+4Bpw=;
 b=fCQz7PUqw7qkvoacFTx0p02P4jV7WYhjbWBXm6ELKnaSNbT0h4dACwNWncVgeqAaK8Gxj3u5Wf/6LzjfPo0bOhN3elxt5Pn5ZdlrdzqYFojs2YDMp3GBDe+Dgzn3bbhLWd3kF41uCH6y/UcDWOobiMM7prETvNXGCwDixqkLVRc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO6PR10MB5635.namprd10.prod.outlook.com (2603:10b6:303:14a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 09:51:58 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 09:51:57 +0000
Message-ID: <8b627eed-331c-4ce5-b095-e682bbf8ebe7@oracle.com>
Date: Mon, 18 Aug 2025 10:51:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] md: split bio by io_opt size in md_submit_bio()
To: colyli@kernel.org, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, yukuai3@huawei.com
References: <20250817152645.7115-1-colyli@kernel.org>
 <20250817152645.7115-2-colyli@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250817152645.7115-2-colyli@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO6PR10MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: ae5bac47-9c4a-4ce0-3d1f-08ddde3cdeda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHZueWRYcUN2aXExcDBpSEVrWmdGRmtrREIwdDRoZUpGaDMvd3Z6MXdqTUdQ?=
 =?utf-8?B?bHRBdVJTdDg3eUdkRFZFWHlRaFd3dzA1cEZPZWpwR1R4WHQva3NDdUZSd0J1?=
 =?utf-8?B?YkZKT045MStjb1NCS0hvVWIxYUYzYjdTSzNYbytVWXhKcWtnN3NqWjlaRzhX?=
 =?utf-8?B?YWhUL3VjSXZialdDNExsVExwNkh0U0JqOTV6TURUSVFVeTN3YldsQ25OQjJx?=
 =?utf-8?B?QjhVL2NwN2JVYXlnYTRQdVFJUFFRS1BLRWdEZjBYTmhTMDE5S3JoUDVQU3dB?=
 =?utf-8?B?OUJSV25nbUVJbjRDanNWRitJZ0oycHhsTm9FMXFsRmUwa1VDNUZQQWFzd1Np?=
 =?utf-8?B?TW5SMXlBY0dZYXI4alRzcTVJNldtTXBqOTNDL0JlbHNLZXFKMDFNcGVaV0Ft?=
 =?utf-8?B?WVFBOW1XWTVHUW9oQVAxQlNUbE9uN1hwTlFhSzkrWlNpYVhoLzJ1a1R5ZFJO?=
 =?utf-8?B?cHpJZjQwWmFnVklGdDJycXFKZThPeURtUXpBUXZZNzNZbmJVMXRPbU9Tb1Zh?=
 =?utf-8?B?aVlsUnA2WUQ2emo1VHFNcktlUzlKekg3S01ONU8xMHdLdTVzRkZVYUlDd1Y5?=
 =?utf-8?B?TEQ5STFmc0dVOE1jUktabWtzUnhpQmlqWmtkUkpiQXR2TmV5NkxVOXdMRG1r?=
 =?utf-8?B?dm5lWDB6cDJBd1dqOVQ3TXRkUzhmbFVnNmNzVEVjSUxVZnNjRUlCSmZPNFcy?=
 =?utf-8?B?ZXhJVVMvMXBOZWsyMUxQVXY5dnM1L2xMdEFEd2Qyd2RHTkU3cFNxaTQ5N25r?=
 =?utf-8?B?VzkrNys4NEVaTVpFTUQ4Ry9BblNUUlIwQVJoZXpaUTJaejcvYkpXMHd2OTBT?=
 =?utf-8?B?Y2prdTgwLzExWHIrYUZSbnpIdXdJVVl3d3B5K1Qwc2lqSDg0ZTlOWkJYNlZy?=
 =?utf-8?B?ZncvRDRtTVdPVEFHMFkyZzErMWlVZ210VDVKV3B0YVRtUk05Qm44NldscEFM?=
 =?utf-8?B?bHNZL1NJYk5ZZU9TV0NnUStUUU9rVm0xZDJYY3duM2RVVCttNDRtK0JpWVdR?=
 =?utf-8?B?Qjc3MS8vZHJJSGowOE9CUXJNcVhNajZpT0NYWVZvc1kyT005c3FmdFhKWUxX?=
 =?utf-8?B?ZXZTa2E5UHJ4aWE3UG4rL3BtUHUydXE3YzZ5WnhsaXVGbGtLQVd6cmhGODVQ?=
 =?utf-8?B?eVNyWWJiSDN4MzVoUlEyMEgvRzQzSHBLMmpqU0w5eE1qaVpVbGlHK2NMUERh?=
 =?utf-8?B?OTQ1ZzZtOEd1NnUxSDVNZzhMQkFDTWVqa0U5K21SVUNhZHE5elRncGl5UjhP?=
 =?utf-8?B?ZFhldUJjdXZRVlhHUEVRdjlZQ0E3aDhQMmNEeW9NWC90OTE2dnROa0xnSlFZ?=
 =?utf-8?B?U3Q1bjVrektnZXZLakFyRlBCaXZxbmxEc3dLeUVMSS9TYU40UWp6eFpzLzV4?=
 =?utf-8?B?UzJUVUpBNFpxRXBObjNYY2FuTVlGZlhYakdaK0Nla0RNTGxja1Nmc3NwcUpK?=
 =?utf-8?B?bjJHQnJBWXhUZ3NXV0lwS3FLZ1ZwRk1jSWlxTDFVSCs1UFltdkJxalN3SGZt?=
 =?utf-8?B?Rm5Wbm04VmVITDRnblR1QXcvUmJpS3BVOWY1N09Yd3VZYTA3eWVCb2dmYWt0?=
 =?utf-8?B?TDNqRWt5Z1Fzd2FBMVo5Y2FxU0tCY0tieGtvTEx0WlcrMXo3K3hFeE9MRHhx?=
 =?utf-8?B?SXBMdzFKa3FTdjdVU2RESVNSYndYZHd4RzFNVHdjcElMNmdYWmZKWUNUajBs?=
 =?utf-8?B?UkhnZFBKSFBTRTNhMHBXZThvTUp0ZnhmZE94ajYyaE0zeGoyNzBZUjVmMi94?=
 =?utf-8?B?cWt3VFlXbzdwcnBmaGZvZDFXYUZHdVR0UGs5SWFDVUgwZFpBY3RSSkoxZlpp?=
 =?utf-8?B?aXpscFFiZHdpQlMxYTZTK0xDdmphVnNiQlYwd2RkTjFtUnFZeUtZb0xrWmIz?=
 =?utf-8?B?aUtEakM4SzdWUHAzeVFJVWZ3NVY0UGNDQ1FCUGlwTWlqN2g5Z3dOaUVidG9Q?=
 =?utf-8?Q?TRCIwaybPFk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVZVR3VQZXR2aHdjMk9WWlFJN2xlVldSc1AxUEF4UUphZmZCRDRtOTlFd3NF?=
 =?utf-8?B?c0lSZVN2SU9ORUw4VGwvUUw3RjBmWjRxZVFLUmNWS3lGcFJYR0xwWkZXNXJk?=
 =?utf-8?B?aWVDZUdCb0QvelpXeWQzOXhwb3VvMUNFUEp3QktKSDdFaDVzVFZFaGFEVEhq?=
 =?utf-8?B?UTlESVZVam45MUw0bWM3UGl0amZGYU55YWdBamV3clJFZVVPalMySit0cWJM?=
 =?utf-8?B?R0trQ3NjV1VyMk1ZbzFWUFk2NnlyK0lRSFIrRlNMZEU5RGgrT2ZFdFFJYVJv?=
 =?utf-8?B?U1VoRWc1ZjhsdTVTZW1TeVdKbDF4Rm9FQWh3R3lrWTliRmZhT1ZTNjR6Y2s3?=
 =?utf-8?B?UWorNVZmblVBVXRSWUh3YUlGdlhVT2lYNExKWHdGWWFxTnpMUllWcWcwWVNN?=
 =?utf-8?B?SnpuWk5DRG0wSUM1V0RwY1JDVW5vNDJUb21lZUxScHI1OGJ3NXRjRjZ3V0hC?=
 =?utf-8?B?Szg1NVJuWFpmdFVDSHhtTmpmbTNBVmpYcC9uSEZtd3JTZ0lDV2Zua1d0TzQ5?=
 =?utf-8?B?QzE1L1N2QU1zcWxhVzc2VEZRYm9WNk9FU1BHQXhzUVhWV3BaQldyNzZyTFNM?=
 =?utf-8?B?d0xYY1lwbHpJY0lsNUNQUzR0MGgwRU5DZ2FOL0NubVB3Y1VRa1RjWVFOcGpa?=
 =?utf-8?B?RllBL0ZwOGQ1SDlWSHBtUWVBKy9oNnBIaS82YVhQOWtNNCt0ZmpoRGZoRUFa?=
 =?utf-8?B?cHRLWXVESjlNL3F1SlJlZDQ1K3lneDFTcFk0cXdKK09YemlYQXVpb3QrNWh2?=
 =?utf-8?B?YURSVFo2MGpHUUVYb3MyaHNGSTdvNmRKSFN3TVp4OUNQaWlyL0gwVUllV0F0?=
 =?utf-8?B?TmNtb0ljQ2M0TGhVelBzcDBZL1pHTndYVG01RkZiUzFMM2ozMktqVXl5bFhh?=
 =?utf-8?B?Wmd0RTdFNlpJL0N1QVBIQXhKY2dWOHIvdXVqZGtyeWFJUjBJbDNBQ0pUL3Nn?=
 =?utf-8?B?NnQxenRYVE04aFJzdTUxZjVGQlYzUU9Zd3R0VDdRdVFiZDUwRU91YVVJQXNE?=
 =?utf-8?B?ZWhkenVCaWtUNzlkOHlNUjlVMFVnZ2w5ckpGNVRNdHJ4RTROYXR5TDg1UmRD?=
 =?utf-8?B?djFGdlpldVJHM1hNSWxIWHhoM3JHTHU1U1U2ZXRJay9hRjFBS1ovdGgyM3Bn?=
 =?utf-8?B?TWxhWDd2NTQ5MXM1eFFnZjdLMWVWbWl0VDhIZDIrNE5RSE9oNGR4aHgwN3d1?=
 =?utf-8?B?dmZ2bFdOTGRLNytTWEZNdnBjNWQrRTJibmIraENJSm5wT3lMRy9rZVpiMHFy?=
 =?utf-8?B?VDV4S3FtTFBLTWd3SjkvRnZ0YXZFc1lJVXVydjJSWFBOY1JKYjEyc1A4TmF0?=
 =?utf-8?B?cFNHMlliUGNTb1h0WHZsSExjV2Q2dW9wOGNPQ0J3Z25DYzV1SmF2RWV1ZnFK?=
 =?utf-8?B?aUhocDZiMnkySkdRcmpBZUJaSUtIcURHS1hTbnNYYk5maEZOWitUVm8wNWNE?=
 =?utf-8?B?Zm5xR2dYQUsrWG93WlJZbmlHcDRmeUpwOXNBMUZncFVXdDVVSGMwNStEY3Bx?=
 =?utf-8?B?T3doRDVoVWZ5NThhMDM1QXhsSE1zQ0RQSzI1WEw2QjBVSlpNc3Z5ODdkZzho?=
 =?utf-8?B?bEhNSFRYcDBGZENnY3F0NkppOGh5YUJJSm92dWNHSGYxU1hDOGZORkI0L0th?=
 =?utf-8?B?ME5jbEN5bHZWbmcwaktmQVhiSG1ENGhOQmtzZGJnOXlXZ1FaWTlBSXJZLzVC?=
 =?utf-8?B?LzJ6RE43NHBZOVJ5cENXd3JtTWVUVlB1UVRiV2hXeEt0ZWxoOWRodVh4K0gy?=
 =?utf-8?B?ZHNGRkJEamFFT0VmYXNUUWMvWVhhN3IyelNKVFhMMU1HOVJwcnBLU3l1R0sw?=
 =?utf-8?B?R3A1dmMxYlgxUG9CUUxmeW9nQ1BadDJ4RnNXVzFldzUrU3V3QXZKVkp4SEZs?=
 =?utf-8?B?V1ZqRWU5UjlyMW5adFlVNVNJRHREb3g4bFV1aFJaUVRLajZZVWtNc1d4MHhl?=
 =?utf-8?B?MTRmUlZPb3JVWUg5clhOWVF0UkI3ZXN5VWh2SmJGb2VpZEg0Y2pubUZ4Z3V2?=
 =?utf-8?B?VHhwNWw0L3paeTl0bkZ2U2JQbVg5MGw3bWNWMkhLRWRsUG5FR1lXR2YvL2NX?=
 =?utf-8?B?dGErSE9hS1NXMTBGSlVTNWVsMU5JNGVleHZHSURLZEViSG1oY2drd05vYUha?=
 =?utf-8?B?TDA0cnhUZmRhREVONldHOU5KR3dYblB1NjhFbWpmR2grTGNvNE4vNWw1Q0hn?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q52gvcs9PseoYgqp2rmtd0ED2heehuOaIt2yLfCHkXrH4ixJ2Rsj9aotM4JzE01KBHjSHif06UUU89u8bS+nECHhDy2YmdQsOhvMJrLt1N0aF859N7lpcAcs4FE2D3rfu+SYuouldtq1/Esc+5SF5FP3Ck6BfhGeBlppCEZyuU/fbIunsJkClH0htAR4V5WqPzjnYEGYvFLmmyG9ZhKBjJOxlo2+h8MqoaZBgiGkB3hUZaVlM3hbtCRD5rcBsjbo5P9xTw6o/525Ye5QpbFppFPBTViJfnfGCXDb8Iq8eUI8bXOY5xD1CExzZNBmNMwgrLr6rg4NuBxYGsTrw2BzdmFgKNPYUL5VSHz6hk7mpg2zUVuZIXmHPPaqhB4/8c8kYEqpC488/IGQHhLbz0UBXtybLPzVOhwfZsVj/I7S8cIsKcEU6vTD8znK5l3wi1xYN2L0wce564cIOKsHOZjGIKTAWujaY4qIcjbOuN1aNOrzEZHdgyd2QGU1eCvNX4v4gcK0+SfjAewEVz6nIBtuX9T1bI2ZNeYlJD9hW9fSqbLZv3UdtVFQisCDe03+/326QFJeYwddcgnLr3b5pc0QBmJTEWqL6xA7lTvGkSy127E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5bac47-9c4a-4ce0-3d1f-08ddde3cdeda
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 09:51:57.8616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u72nmgJfY4YoA4a+9LshkvFZQ7nv0ByzkLtZ0G0NYIngFmpQt0F+erqLtpRUkVjDGMfKCLEscRAQmby2EUbcCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5635
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508180094
X-Authority-Analysis: v=2.4 cv=TNZFS0la c=1 sm=1 tr=0 ts=68a2f7c4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=NVFB1LBUiSm_tSYZoewA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDA5NCBTYWx0ZWRfX03npYdTHMaS+
 U/hRXKMty7YTitCYD8x9AEn/YcA8/fsGaVCJkopKmKgfy+CxechQ8KntmFTWHaN42IEzzsP/XY1
 ZaQX9p0ioP9Cd9kvF1uohevsCVoLgzxBpnjwuDhCRRdwalXw5Y2O62eAeyo5QXFlDlYKitLaz7i
 UvGcGRw/DnKGVvOWiKmbyd4G5SwIFXrRW7udd3SLrCjLoMNudQJCL+SngsZ8itu6Dchv4xGfBsA
 ahypIGPeGo2us9ZEAWqeQKd70BYYq6ld7zxeL9gxo1mSN5TcnYIL7RpTEeKNoHhBMiWzcUajuqp
 WpgXbYNV4rVVRwrKwzYYZEe9HLPDGlzNrrm6bDxTvuy0SO7J1R0cBPY3X+UONTHbP/Vqs1Mkng7
 surXxFz8hkL9xzfX2Ngm7VrOuz1uro2mIxafaMLRYsvszmT08/CRJ0f8MrM5C88IXSclbkPS
X-Proofpoint-GUID: hyqDdNUTKnpt6xdN0oh23i_IXr1vObZE
X-Proofpoint-ORIG-GUID: hyqDdNUTKnpt6xdN0oh23i_IXr1vObZE

On 17/08/2025 16:26, colyli@kernel.org wrote:
> From: Coly Li <colyli@kernel.org>
> 
> Currently in md_submit_bio() the incoming request bio is split by
> bio_split_to_limits() which makes sure the bio won't exceed
> max_hw_sectors of a specific raid level before senting into its
> .make_request method.
> 
> For raid level 4/5/6 such split method might be problematic and hurt
> large read/write perforamnce. Because limits.max_hw_sectors are not
> always aligned to limits.io_opt size, the split bio won't be full
> stripes covered on all data disks, and will introduce extra read-in I/O.
> Even the bio's bi_sector is aligned to limits.io_opt size and large
> enough, the resulted split bio is not size-friendly to corresponding
> raid456 level.
> 
> This patch introduces bio_split_by_io_opt() to solve the above issue,
> 1, If the incoming bio is not limits.io_opt aligned, split the non-
>    aligned head part. Then the next one will be aligned.
> 2, If the imcoming bio is limits.io_opt aligned, and split is necessary,
>    then try to split a by multiple of limits.io_opt but not exceed
>    limits.max_hw_sectors.
> 

this sounds like chunk_sectors functionality, apart from "split a by 
multiple of limits.io_opt"

> Then for large bio, the sligned split part will be full-stripes covered
> to all data disks, no extra read-in I/Os when rmw_level is 0. And for
> rmw_level > 0 condistions, the limits.io_opt aligned bios are welcomed
> for performace as well.
> 
> This patch only tests on 8 disks raid5 array with 64KiB chunk size.
> By this patch, 64KiB chunk size for a 8 disks raid5 array, sequential
> write performance increases from 900MiB/s to 1.1GiB/s by fio bs=10M.
> If fio bs=488K (exact limits.io_opt size) the peak sequential write
> throughput can reach 1.51GiB/s.
> 
> Signed-off-by: Coly Li <colyli@kernel.org>
> ---
>   drivers/md/md.c    | 51 +++++++++++++++++++++++++++++++++++++++++++++-
>   drivers/md/raid5.c |  6 +++++-
>   2 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..d0d4d05150fe 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -426,6 +426,55 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
>   }
>   EXPORT_SYMBOL(md_handle_request);
>   
> +/**
> + * For raid456 read/write request, if bio LBA isn't aligned tot io_opt,
> + * split the non io_opt aligned header, to make the second part's LBA be
> + * aligned to io_opt. Otherwise still call bio_split_to_limits() to
> + * handle bio split with queue limits.
> + */
> +static struct bio *bio_split_by_io_opt(struct bio *bio)
> +{
> +	sector_t io_opt_sectors, start, offset;
> +	struct queue_limits lim;
> +	struct mddev *mddev;
> +	struct bio *split;
> +	int level;
> +
> +	mddev = bio->bi_bdev->bd_disk->private_data;
> +	level = mddev->level;
> +
> +	/* Only handle read456 read/write requests */
> +	if (level == 1 || level == 10 || level == 0 || level == LEVEL_LINEAR ||
> +	    (bio_op(bio) != REQ_OP_READ && bio_op(bio) != REQ_OP_WRITE))
> +		return bio_split_to_limits(bio);

this should be taken outside this function, as we are not splitting to 
io_opt here

> +
> +	/* In case raid456 chunk size is too large */
> +	lim = mddev->gendisk->queue->limits;
> +	io_opt_sectors = lim.io_opt >> SECTOR_SHIFT;
> +	if (unlikely(io_opt_sectors > lim.max_hw_sectors))
> +		return bio_split_to_limits(bio);
> +
> +	/* Small request, no need to split */
> +	if (bio_sectors(bio) <= io_opt_sectors)
> +		return bio;

According to 1, above, we should split this if bio->bi_iter.bi_sector is 
not aligned, yet we possibly don't here

> +
> +	/* Only split the non-io-opt aligned header part */
> +	start = bio->bi_iter.bi_sector;
> +	offset = sector_div(start, io_opt_sectors);
> +	if (offset == 0)
> +		return bio_split_to_limits(bio);

this does not seem to match the description in 2, above, where we have 
"and split is necessary".

> +
> +	split = bio_split(bio, (io_opt_sectors - offset), GFP_NOIO,
> +			  &bio->bi_bdev->bd_disk->bio_split);
> +	if (!split)

that check is incorrect. It should be IS_ERR(). So I doubt the 
functionality earlier for handling "and split is necessary".

> +		return bio_split_to_limits(bio);
> +
> +	split->bi_opf |= REQ_NOMERGE;
> +	bio_chain(split, bio);
> +	submit_bio_noacct(bio);
> +	return split;
> +}
> +
>   static void md_submit_bio(struct bio *bio)
>   {
>   	const int rw = bio_data_dir(bio);
> @@ -441,7 +490,7 @@ static void md_submit_bio(struct bio *bio)
>   		return;
>   	}
>   
> -	bio = bio_split_to_limits(bio);
> +	bio = bio_split_by_io_opt(bio);
>   	if (!bio)
>   		return;
>   
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 989acd8abd98..985fabeeead5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7759,9 +7759,13 @@ static int raid5_set_limits(struct mddev *mddev)
>   
>   	/*
>   	 * Requests require having a bitmap for each stripe.
> -	 * Limit the max sectors based on this.
> +	 * Limit the max sectors based on this. And being
> +	 * aligned to lim.io_opt for better I/O performance.
>   	 */
>   	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
> +	if (lim.max_hw_sectors > lim.io_opt >> SECTOR_SHIFT)
> +		lim.max_hw_sectors = rounddown(lim.max_hw_sectors,
> +			  lim.io_opt >> SECTOR_SHIFT);
>   
>   	/* No restrictions on the number of segments in the request */
>   	lim.max_segments = USHRT_MAX;


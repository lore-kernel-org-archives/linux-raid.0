Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF7C20512A;
	Tue, 29 Oct 2024 11:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730201833; cv=fail; b=Yyry4cygbpU7xMW5yn7D5Vb20FdglgLl7A2j3LebCMcbntyijvulwPKxum7qeiR/KbORcfQYHL8nAC/a/iFVoKvmeDUVZjXX3q9GcMPiRg3Mahb+z3afRGDqUzDudbxVBupKbOYcc55Km8iD+deNCg/E2I1euQpZwmXunpcvzxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730201833; c=relaxed/simple;
	bh=sKjUA/EvhNddrG66bYvFFoN05N7SsaHzi9TfQGO0ou4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZwUW/p2pHjPSp8S/6rmijJ3ySDO7LdM/QZgYPwRy0xNmofEjjhOkT9rlDNWIcyfbCDXCCCcZx80uZyYz0nxMUD7LC1v/qNpychYklu4Ye2tzQh8sPPXioo0eqAJT+9JX3iHw/cooLTwmAiIdg+qvpAjou19yCXZL7V6oNU1I1kc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JHdLnlHp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FcTZmbGU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JHdLnlHp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FcTZmbGU"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49T7tZ7v029741;
	Tue, 29 Oct 2024 11:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=K9NEqFX52W6OMoq9JofRxNk2WOctJAtt/T6ybScTKxI=; b=
	JHdLnlHpGNtXVQjpCo/Xmy/QTZoXYDGyF/3QKm0+et4Aw6lXJxVG/+hpVy0rCBtU
	tZTmpRn5LPMg0if5coCN3CrVSo7OJvDyEhKpPnKl6sra8K+5QcOQD1bmRF8wiUMf
	4MzJEM3F0dQ70HaE0lezSGvzlJZT+guVOsuBlZ76hJWolMWg4O2NfsaPM9n3gsp+
	zDcQT/kraDwBD7Jk0ayig2KDwm5z6H/p+mkExQvJzo6UDM9WyHA7mRC+Py+g+qKm
	TIehw0NC3gBGqfzNk7CKEGL7e0f2yRPJoZH3UkqqcCPd8bdpU5Bv8wS2uOacPlS1
	c54hs+lVzUXOUwH2AoeP5Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgmd76p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 11:36:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49TAOExR040239;
	Tue, 29 Oct 2024 11:36:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hnap0c65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 11:36:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s5ZPRfGkkVyKnxJaQB9cKqYfoWFGe84TfPmlypW0Dg0zBCDhUzAkXyByJSYv+ZgF3BlVWDSBTEpOV9Q8xVpvIbQuEsNT4s/bq4lqwRlAyiPokT/XDgs9d07PgGVYZhF+vHgCXosrOvpptpedrahqLobMu+ninsfrPTrR5tUy/ls+TMYOJmovlPzM3GbQItieAHxtp45mLbXIttKxGwvu2LXNAZFh3EX0JPRqMNEaHiCNeyN6CKj1EA6qsZRdAzlFoWkJ8DL7sKmpFjZeWYDWv5qQQnis3H9gAdGruRy6/6CcpuxZhT9C7clWP3bcJdpYAarJhNVa5oqtSHcPbrvm3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9NEqFX52W6OMoq9JofRxNk2WOctJAtt/T6ybScTKxI=;
 b=xzD5iV1ZNWjufMC/EXul88eaATFWNSkatebfpVJqzuxQWEbHqaq7lnmkuEQUal0yYos05dxigxQmSn+j6SR9THb5MszsPOux5GW5QuwQ0RpySEeZ3qXxI8FjA3aWyK5jdf/Ynf3DO0UY0s6tHYPjUDshpBJ2LGOmT89K+v629Qwgx5PjYiooXjhF8H9gMqld/yuNPOfTCSKdA8rxTZfksxl9om1hJNSgr01Ojk7i51+QhED7eoxbe9tbnTQZW5AM7xuQ/B/UCE1IFhIq7ntdj6tMgmf+SqwG4IHIbD//lo/c5kT3RD0fWwSbIMdpBMaDh5gWMnvuoWyBTwusY6kPZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9NEqFX52W6OMoq9JofRxNk2WOctJAtt/T6ybScTKxI=;
 b=FcTZmbGUVE76i787mD2lDQHMOt6JADo9QMLvfHlLBWJUs5yqCxQMaODzylGUPPCaT/6wfZ5bCcCUPuXE5uPXr9yCTjZuU16sQmNGPkNx1G/XNAOgJzgZIEfLA0AK/PIX1Sax4kGkQrOsuhQ/qbRyp2+fy+Ob573PTjr3QsD2KP0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4602.namprd10.prod.outlook.com (2603:10b6:806:f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.18; Tue, 29 Oct
 2024 11:36:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Tue, 29 Oct 2024
 11:36:42 +0000
Message-ID: <b62cb76b-aa7f-488b-ab19-4c158eedf34c@oracle.com>
Date: Tue, 29 Oct 2024 11:36:37 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] md/raid1: Handle bio_split() errors
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, song@kernel.org,
        hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-7-john.g.garry@oracle.com>
 <c79e7bb4-6f53-344e-9651-fc146b12d240@huaweicloud.com>
 <879c8b67-2eb4-4e9d-81bd-8f207adef7e1@oracle.com>
 <6325d143-b8f2-7287-201b-d3a2e53a556b@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <6325d143-b8f2-7287-201b-d3a2e53a556b@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4602:EE_
X-MS-Office365-Filtering-Correlation-Id: 2171c027-aebe-46d1-5875-08dcf80df5ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RlduR1AwcHZPR2cwd3pYdXU2YmQ5ZzdaeEozY0JCU2F2UG0veDh0LzVCVXpV?=
 =?utf-8?B?QnpOV29ZQ1ZGRENrVVBFSzh2VkRWZlRkWDEvODVaZno1WVFnWk5jRlprcFRi?=
 =?utf-8?B?am5Bek5ZSkFRdHpZT1ZKOGRiYWpRQytock5wc3hZZjV5SlhkWVhXY2pkWC9Q?=
 =?utf-8?B?VzBiT3VCbjBURTFweVFyL1pIcUxNSFBMdjgyZDhWbEhmVkV0cVlOR1JYR0tU?=
 =?utf-8?B?dU84UDRKbXdreWwzY1FoY0JhR0RKSmJOTWgrZHc3bitIN29qSUN0c1h0MFJk?=
 =?utf-8?B?M25Vck5BSnFpM01LWU1oTm53bGc0VW0rdk80ekk0aGlSVWE3MHg3VHYrR3BZ?=
 =?utf-8?B?eFU0eDlQQjFESVF1TTVtZmFlbENqK1JDaFNMdHViNDV3TWtXRVlIS1JmUyt0?=
 =?utf-8?B?MFlKV1kwelRqMDNqU2V4NjgrcnlTbzhtbUJ2Szd5dVRVVlpVcDJkUzRsc3dW?=
 =?utf-8?B?c1dkaUxsRDBMb3lJVUl2T0JvcTQ3R3pqOTFsMUdTMkFXcXdxN2xiTldzaVJO?=
 =?utf-8?B?RUszWGJJM0hNa3VvVHRZTk5jRzVGZTFpcUFVUUU0cXVBWE9ubEhBSVlUSFF3?=
 =?utf-8?B?a2NNOWNZV3ZFdVhSNTN2YkVUYStaN1ZueFpjNldTN1VJN2FaU0huVEluOWRv?=
 =?utf-8?B?U2M5VUNhSzVLRGhwMFZmdHUvRVQ5VnZBeWplVGlMRGJNY3JPdmlCNW1zSVJl?=
 =?utf-8?B?T2dFOWwrNkdYeEJSN2VBWnU0YmpyWVpsVUNxNmlWNlFHY1E3WHFCZjBFckVw?=
 =?utf-8?B?SXJXcS9OcSt6V0dOdm9WSGtFNEVTYk5HejZnTlQ4ZXMyYjhRM2tyQ3g2SnhK?=
 =?utf-8?B?VHhrcFplZ3J6SFlTTmptMHhIdkJLSXJOTXA4anZOQk91YjBETjhmaTlGejdV?=
 =?utf-8?B?ZkZVVzZ3ckQ5eU5ic29KcWhuTmlJRGFKR3BsYUkxYzZZOGlaOTZNTS9tTk55?=
 =?utf-8?B?UWNwTmovR0JENGhzcXplTTM3eWQ0bWhLT09ubnhjdEZnVzdrR1dXOTcvWmVo?=
 =?utf-8?B?cFNmeGVhYmsxcGc5blhmLzZSbGo1V2hJcWo4eER5R3FQTlVJcUpMQnN1MFNI?=
 =?utf-8?B?NHRPWm1zWWJFZ1VyZVpUaGxrbXN2MnN2TGdYWE5nU1pQMDZMc1lxUWFtOFpK?=
 =?utf-8?B?QzFOZ3BnM2Fub2JoUng0bTVuRWJrejU3bzUrZjdEellhM080Ui9wS0RQOURP?=
 =?utf-8?B?M200a0EzY2ZCSzlvYWR6RFY1eU0vMWZGcWVNMTVIOTl2cWJtQ3NUTWtKWjF6?=
 =?utf-8?B?aFhFdDBhWW11d1A1ZzJwdjI2c0V2SWp1ZFZxNFFhcVpRSldmbDJQSDFKVU8r?=
 =?utf-8?B?SllTNFJMUW5aV1gxL1ZHRlZPM2VlQStKblR3T0VQSGh2QnljTTVia3FwMjUw?=
 =?utf-8?B?RGFRU1RGS1Jvc0ZTb0hHSzh6S1dJQU5UWjRDNnNTVFFieEhiY25leUMvMW5i?=
 =?utf-8?B?V0w0aHpvcnp4RnhFTGltSEdBVk40emVEbjhmWSt2NG9RMkhmWUZEckhNZlFv?=
 =?utf-8?B?RkVHUEl4dlZzaXYxZ2N6L2lHZkVBdnlObHltQlhGMVJJME1ZTnFRM0wvTkFB?=
 =?utf-8?B?QTNLTGlxNy96VkZOdkl0Qy9hM0JyNmVaV01scXlPMzdsQ3cvS2RNVWdTVTVn?=
 =?utf-8?B?L2xoeWxPZUtETDBCK3NSM29ZWGVob0hOcUc1djA5OWpGNE4zeVZvR0NOTkZS?=
 =?utf-8?B?VUpuOUcxTWE4d2RPalBnQmRrMkxybk1tRm1zQUFhMTZhSkl0QWEyekZTVXht?=
 =?utf-8?Q?9xv0G998iSYnbyld1zNUoK13lr8ZJOy66+YZGbh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzJtaU5tdlVrZlBPZXp3WlhZcWlWdndvYzc4Qy9OTnNySkdFRld0d3hvaUNX?=
 =?utf-8?B?eGg4VlN2ejZHb3E2a0l1K1NoR2lsQ2FxUEsyUWkyUHUzc2VBSXJUQXhYby9u?=
 =?utf-8?B?ZmJWbXdYZDRGM0tyK205SERvTkoxR0FVQVJSbDg0R3NUK05VZzdnZGtNM0sy?=
 =?utf-8?B?blpHOG5QcmU3akg3VnlzQWlSNWFSY2t1VUZ4VEdQSlZsazhKY09LaHhKc1Nm?=
 =?utf-8?B?SjAwS3Rnai9oS1ZjTEJ1SzB4bEVVbFB1WGl6R0ZDbkZ3RWJNMGpqSkJYd0NR?=
 =?utf-8?B?a2VxM1YrYTNJMnhYcHRweU5pQVA5RS9Ra3lOMFIvdVhrdUlyT2ZDMHZUd3Vq?=
 =?utf-8?B?bXFxNTVJVVNLTTJROWpJQk1Db2NIbHlVSjFFbEhOWmJuYk5WVGhodUhwcTlS?=
 =?utf-8?B?cUxYTVJMTURBL2hUMis3aGViUTliakZzSHVuOE9vR1p2S3hvVjhveEpuZkx4?=
 =?utf-8?B?NURRcW1UTGpQTldGWmg2ekQ1MzNJRFBPNmF2NXRxbHNyZWpIYTQ3dWlWVDRJ?=
 =?utf-8?B?NVVJYW8rdno0ZnNRZXR1ZzB4aEE4bXFOTmJvR24reUZDRU1HWkZCdWU2WVZ4?=
 =?utf-8?B?ZnZLdGQ4UmdDMmZZUGxXYzVCZHhqWWZGRGZONEpGMVhrNUpvQzd4NDlwbEdx?=
 =?utf-8?B?b3FteUhtWW9RYlpmV1RmT2kvOHdSSWs5TEJtMGo0NnZpR0NVM1JzQ1NyT0Vv?=
 =?utf-8?B?aHk0bmkxa2o5QWFveWNCTG0wQjBhS0g3eUNGMmIxSWtuSklHMjZiMDAvbzBN?=
 =?utf-8?B?OEpZUkxFVEVXWmRPRGcwM2NOR0NjNGtjOE00c2dBY0NVTWdIY2N4WHZMMjB4?=
 =?utf-8?B?V2N0Nm1tTnVrSDFHb2x4RkVCdHhVajAzVEt3aDQyY2pYVlFvR0d3VEVrdnBO?=
 =?utf-8?B?SnFSd1RTcW5BYU1uNE5HMHYxMEZ4T2dTUFB4R2NDQk1ZN2hITzloR0pOOVBD?=
 =?utf-8?B?RGhkTjZVdHJRbFlvVndUSytjcWFiSUFkSXZYQm4zMlk5cEk3QjJEVXF0WW1O?=
 =?utf-8?B?Rk5qaytoZXUwN2ZwMWNMa25Vdk02bUl1N21rWHZVTnlZZkw4eFE5UzVhay9y?=
 =?utf-8?B?VUxqaCs1UHl3eWJCYWhML0JWZS90S1gxbksvK0RWMkx0aHhsVzdPeGV5TG1G?=
 =?utf-8?B?Rkg0MFU2S2ZZRzRYaXU1allWRm95eXRCU1pCOWpKTWlrNnBhVkx4QWc1Q2Y4?=
 =?utf-8?B?LytLbFpVZUZhMHZ2OFJDV1JWY3FPdzlSV3h6bDhEL2JyS1IwTWtucGM2aGNa?=
 =?utf-8?B?UHRPT0NmaFhGNlZ1NnppaXhpWXR6a0RRQVVqS1ZUQ3lURFV0clAwamZFd0ZK?=
 =?utf-8?B?VkJ6RjR0S2ZWRElDdll6S1YwbUNGaHNaN1VVWU5lYXpoaURYSUk1U2J6WUxy?=
 =?utf-8?B?YVA2N1F6TVRYaVRQU1NFUjA3aUxJd2xqbVhGSXpWVmlQMWIvVW9QdGYxVDFy?=
 =?utf-8?B?UTJyVHpkeldFRGUrS0V3TUlWTU52OXpzWXJvZnBFSFhZeVF4SlhlOTY5RzFO?=
 =?utf-8?B?QzZpVlNkOFNlcDIwZm5qcEVEaklONzJHbDVoNU1qYnhOVXJ2KzZEWlpRMGNU?=
 =?utf-8?B?dUJNUzRwNlQ0TlJYQXV4ajlVdmNJUkJwUWlkcUxKYzRyVnIvUVNUbXJsRFFr?=
 =?utf-8?B?cWVjaTJuVktya01SdDdlejRLTisrcmlKL2J3MVRNcmozNmhaTXJMTDhRNVQ4?=
 =?utf-8?B?RXVKSWxRTnc1WVBlSjBIc2kvQTN6YTdtc285cGw0aTQveTIrQzFicDR2azVN?=
 =?utf-8?B?THJVV3M4b0NjelQwMEVvWE1zQS9UQ3QzUjFCa0twblI3MW1oV0RPb0VJdk1C?=
 =?utf-8?B?VGZaaVprRjNaTUE4OE1zVXZzZlBzS0ZkYklpdC95UVFBZTFXcW1RU2V4U3Ex?=
 =?utf-8?B?RFg4MlVYYlhQWmhaZVR4OW95eGpQRUxGb0FTY0hXYW1mNXhWcU5nOHJRaHdj?=
 =?utf-8?B?bWtEcVR3aXlxcFRKV3pXOWtFdmNpTjlBMDk2bXFIUHoxUVQreWYxUDdSaUVR?=
 =?utf-8?B?YXRXMGYvaUxNQzV1dmF4cDZTZDN1dmhSbVlpZkJwZ0FQRXRTSjVEcUF2Nkk0?=
 =?utf-8?B?Q1NpYytlZEpRdXI1bzM1bEc4aWxESDZOQXdzbGdCWkpLOHM0SnkzMWV4WHZx?=
 =?utf-8?B?TlJsRHRCajl5R2QwOHJvWGQ1alNjNWt5TkIraktJOGM5bmVNV2xqWjdlUVQv?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rxnUAx0m7gcNdSQkik31koYIkKn5VVLunIwJcP/u12Q67llc3Ds0fCnFRWjX10yVnZsjgEmuGqbuFnLn8x6M7IpfgVBrqQQrK+MlGz0efaQuUSGOxKoKSPVzBiSr5TZgVahB0MLpCmyOGH6ogikyrVDNuW7hmvhirt1vADuQvcG778Rle8mRkIjdRA3EfPPDnGL9SpMWc5uthF2O8lJOG33LiugXzwZNIDKWQ08Q/ByH/I/VFym5r4mHc0QlZslGZ9uScyv/7VdoizcWfrR/RllptbBCrlmQ5Zkn/EfuqtXduO9b0V6U9LOoH/zAN2hpChMIuda4R6igy72WALCJO3MpTDzyomAWaOlYGFAphvC/YRMK7zFMebmcgsZlSwPZ8HAp8LXpW4qQ4M4Z8VMqPVyXjQxEqfF1D4xQvjO9G/5NiTnFQhxmWvhF63+Dp0RaQzG1f8XKApE4WwKvINYqTTO7RIIyHLLQsnZ9014BG5eju0fMoGibJf9wey2biuYBQJoPZTK3iF4VkNrlsalnumcrx9eKOSca/1m8towci7Z17dygW6JH9bnUEt7Zkpxf7BvHoEZhHqcy6SuewN/Aocug7r+h5zlVfx6fHHCjOvw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2171c027-aebe-46d1-5875-08dcf80df5ef
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 11:36:42.6421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQxHLOLOsl59KiXCkRWQR3gyPQaHHVNIkQnlytsibni3B9psf70YJaJNkz3TSquHUCyALKWnsF9rhlJfdryB6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_06,2024-10-29_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410290090
X-Proofpoint-GUID: cLKZ5GEjk1aLKKuSo2S8r6Txsk27dk_R
X-Proofpoint-ORIG-GUID: cLKZ5GEjk1aLKKuSo2S8r6Txsk27dk_R

On 29/10/2024 11:30, Yu Kuai wrote:
>>>
>>> Or is it guaranteed that IO error by atomic write won't hurt anyone,
>>> user will handle this error and retry with non atomic write?
>>
>> Yes, I think that the user could retry non-atomically for the same 
>> write. Maybe returning a special error code could be useful for this.
> 
> And can you update the above error path comment when you support raid1
> and raid10?

Sure, can do. I am not sure on a special error code value. I will think 
about it.

And I will send update for 
https://lore.kernel.org/linux-raid/20240903150748.2179966-1-john.g.garry@oracle.com/T/#m5daa8d32d825d74422bbff272c9b25b6c4fc2788 
soon with this suggestion.

Thanks,
John

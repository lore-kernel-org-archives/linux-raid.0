Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50537136656;
	Thu, 25 Jan 2024 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201729; cv=fail; b=DrPWohsj1snRT181KuXb0TvOt2hX9H/+joAmZlzhWihjfLL3vmvBfmNxndLj+T6y3yK1osE6tihujuD17JNgwnxFbGWdbRTFxkaoSlWG8AzPwADYq/4CTBWo5j0WqJ0gezZgx7XNX1YRQBoLoO2RDtBcPgOUIPh1GVBh1NHyjUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201729; c=relaxed/simple;
	bh=wxOJsbGBPUSlv1vuwRV1/5720W7mN2KfxLyJScGhGEQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X2y0PSEwmuXraCl/BBDywtUkpzMS/U8C4KhztSrfCAm9w2FyfnVLf8S8PU+UVM59fEce5vJBGb5U7eYymKQSC7CqpxruB8JMLzuGcnTLCv+uFSkwZ6ogpjhEmn49R6FyBTMxXj6lL/ZCukUB2K+3050hXB8VrUPrd8rsl/jngDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WroaqUZf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qU5u3TWn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WroaqUZf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qU5u3TWn"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40PGr74c023638;
	Thu, 25 Jan 2024 16:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=McuMecwg0VrMhLRvChN9rMH1xQ6i1+lVG5TNxELgDBM=;
 b=WroaqUZfvLO1gT+b8RNuM5VnTUZd/daVQvVrxL78sFV/ffW1KF4PgbRWEmkB6RhyPINT
 pJCe8VFl1P4kX9Urrw5hDtD402D2LHkbSlYMHKusOa/XYg9kUvS6XWfC9hrXyeCK1Ov+
 5CQM29IvE95132uJvYWHN3vKK3vzx4hGyLTUPp8IyUNycyPR0AuUUHheTTTuYr0/Gj2L
 blqPohdDyN061HGIvZRTa/P3mzCEAK8bPztJDAigniNiQNE076sAb51SvhldKfaPpaqO
 Qg1kBLgDxDK/06vY1VZS7L6aC839TfGoxlITF7VFdRVAFLJ87XdrT2wyBndcXLODy9QM RQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cy725d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jan 2024 16:55:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40PGYN4q004363;
	Thu, 25 Jan 2024 16:55:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs32uq6q4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jan 2024 16:55:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7TiZbpdXXVtzuBP5LXdPoFoMBfvTnb4Ym7VjX8zzWjBGDtfACaQjkSB+F+0qOGeflP9gZ9I+Psoj1uoyX9ymAv+tj+iWHGdovluMpE11qm5n4K4GfWeQrMSTitZOMXyQGE8gwmGlMQBbdv5yY2sbS3KbKJObcl3ihdUNppdXnfcikR6qAfkTkk89x5dhmGn4PVkL4qCga2aaI0QJUGuMP3hU3Up0SZDAxfBZnQAtU8GNlYapWh9XQyIO5gswDUmMNcN0JDzH3CC9I4FhKDIuhKsLHhrBgZhTmKIF/qH7iUa3CeIY1Y9TxnR0X/9XtDHVYADSlSeyqqqm7PxMdF62w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McuMecwg0VrMhLRvChN9rMH1xQ6i1+lVG5TNxELgDBM=;
 b=VNqCE/HUlQAd0GGoVafE2a2CmvHNraeiOk9CO9+8KSgt8XpnQS7UIBuuU38Sm9ed6oZatHz3HqOceWXlH2c4mCtJ4u6uYfKpQrLlOZkafx0UZ4WHfyYxtxrK2TRL0LXwN7Xj3M8ecwkTLPGC/niV8bK0zz0ptdfzvmDx9nIBjOVyijNF4YHKlpemy5hrB8GNajUqD05nf33/KizTIgtMQAf6A+AZhcUTwW6jiESSZ+oFxuIEJiKuy1WgQBDrmbxjFL6qxma1IInowddjBSqRTDmxNwuCvZh+K32Tz7VsZTyClcR4pI3fdLceAre5j4qYlQ1Y2te1QQW6m5xWMXfF+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=McuMecwg0VrMhLRvChN9rMH1xQ6i1+lVG5TNxELgDBM=;
 b=qU5u3TWn3yqHD7QTKJg4MFBjI7NGFLYIsp6B+XrkZSlF6QebiceCxMbn7NQPg5iQti/Jb4Xj2C6o5WoFfYjRE02DC9/zA7tH3e9Z4CpGUORBJF3KHhc7kxyTFFE9/aXD/9nUYSY06hL/9jz/Ab/t9f5LhFvEO1zlWFPccZoxnPQ=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by SJ0PR10MB6350.namprd10.prod.outlook.com (2603:10b6:a03:478::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Thu, 25 Jan
 2024 16:55:01 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::1b4d:a7ed:2ace:8f3]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::1b4d:a7ed:2ace:8f3%4]) with mapi id 15.20.7228.027; Thu, 25 Jan 2024
 16:55:01 +0000
Message-ID: <7d7e4a51-1ff1-4f69-9812-2025043b066c@oracle.com>
Date: Thu, 25 Jan 2024 08:55:00 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING
 in raid5d""
Content-Language: en-US
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com, Dan Moulding <dan@danm.net>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>
References: <20240125082131.788600-1-song@kernel.org>
From: junxiao.bi@oracle.com
In-Reply-To: <20240125082131.788600-1-song@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::24) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|SJ0PR10MB6350:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f847169-74d5-4aaa-5971-08dc1dc65f24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	z8cr47xWHhPjucuieFCCxJeYyDaYgyyLWBJB0hOwYdh5xqBUQ5lMraLGc5EOu7GDacUEUlJzZj4rrnCe47rMBTfHw77uDyOj0JB5L9fvZIbiyD0hZ/dfb7tgleFBOv0+qY6Gszdfl+NOq80AKTk8CZeGO+Dvh3kMEUdeyEp+ws5NLj7JnvqgzErl654Fn/bdEa/3bWvvZLV7yEvcaESe3w4SGSvJyfdfBBZiSV1T9WOlFYKj4uLCLiu3jtJDYB3mKz8qKvoah08VXlYHU+d4130Nrkeu1muzcQU92l/xTFSK1mSLILNAg8AuDq2zQHsYjwlr3RF8r90LO82wx6XRhHYv7yFRuOY2G2us/CpV9fLynfwEVzg6bcnTNIr0sIjN4DPpNiUN/ZbGIffH3cWC58PfcReeZATUV2BwkyPFTym8iuxEMW8UWf3/mdFkA8zBIYG/pYpltDU/1brmTHkIC+HvJin+uqg5BDxGLS5aqLXGNXUh1FUpbcAbuGRDx8gNkrKoRMmSKbmtyTYHNqlaBcXXlk614uqeNT2ytFmWzDJAPPFKJmsvpLaVXJJd22rBiPIoQXVnGr+mCaiiECjzVXRFaR7aa4xK7h+tIHZ03XU4lj5e1BZcmOtGPkuML+Z8
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(366004)(396003)(39860400002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(31686004)(26005)(8676002)(966005)(8936002)(66946007)(54906003)(5660300002)(66476007)(316002)(86362001)(478600001)(66556008)(31696002)(2906002)(38100700002)(6486002)(4326008)(9686003)(2616005)(6506007)(53546011)(6512007)(36756003)(41300700001)(32563001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?S3NVN1ZLbmhsTzJJV01oMzhaOVdGbEI5Z21GV3ZvU2VRMjJoanRRanJpaXpS?=
 =?utf-8?B?T2RrUk9yZGNiUzVhRUk3SC83T2F3bm1WYnczbkJ1UDdWWnl2M080Zzh4VDc3?=
 =?utf-8?B?eHJ4NEgySnVaZTFMbXczL0dOa1V0TnRYTmw0NnpibCtVV3c1QmVjbmgxQTY1?=
 =?utf-8?B?cUIzU1VVa1d2ODVwS3lTNkhmMlgrMHN0NjFscjErdzFyRmc3WnFCaTJTOWJZ?=
 =?utf-8?B?bzFGb09OWTZNbTYxZi9kYmZrcHdMaW1GNnlkUW4xell4RVpBSUtjQ0VHRFV3?=
 =?utf-8?B?V01tcWZxUEJ2V1NoYjYxdEtkckluSkpTcjcxR0JNL2ljd3dSS1lnaFg3REFp?=
 =?utf-8?B?bW5MMVZjVURlUFFZWTVTUkg4cmVsK0NEQmNUOGdYaHZGTTR3eUcwTFA3K3Za?=
 =?utf-8?B?VGt3TSthM3NwbFI0QjFNSHNOOVMvcHUyK1QxV3JUMVV5RGlwa0tNTzJpQU9l?=
 =?utf-8?B?L3kvdjFQUlBFQzlVdGdSTjZ0YTFDbWRpSHlCelAyRk9OL1JERkpxOVdVbGov?=
 =?utf-8?B?SDl0Mzh1Qk45bmVkVXUwUmQyZFhWU2Vmeis5Q2JRMDFzL20rQ09kZG5JWXlm?=
 =?utf-8?B?V3lpdE9LcWVybFVlZTN6dk1xNEdBcllSSTZ5SXIrRSt2aHhzQzAyTXAxMU41?=
 =?utf-8?B?VDFlYUNzc3FsMWFPUlF6S2VYTlNkMU50dUt3SlVLR2FLN3ZUcUVJOG1xTk1R?=
 =?utf-8?B?SjRrZzE4SDR1ZzlGV0FxY2RtWmVSMWtsM0UrZDdHTEl4RWJaRWhvOXhRa3VJ?=
 =?utf-8?B?ZG4vM1BjS3Z4QTJyZ2VCWkFvWWZyVGxUKy9pRHBHYlo4NzRFYkdQWmcvMkY4?=
 =?utf-8?B?RDdRUktQVE9OQUVKTnV5UWpXOEVpL05YZ21MTVRZSzRTUzQzZVhrcGtGRUZU?=
 =?utf-8?B?MThCZmhFUWJHVlRmbHlBQ3Nyd1BpbEhOdmw1ejJub0t1Zk5HSWJkZlhCRTQy?=
 =?utf-8?B?NGhyUG05UmxReWR4V3JqeHc5cEkwaWY0aW8ycFNQc3R6UFBFSjE4RXdaakR2?=
 =?utf-8?B?elRxZVlPbHFsc2ZQSlB0Y29qQk9jWWkxK2VmeVlxMjZBRWtkZHAwSjQvWU9i?=
 =?utf-8?B?YTJ6OUpzVS9ySGpHR2NJNlIvd3RtbkY1eGgxOExtUERoaWJKRUdqSlZnSkZY?=
 =?utf-8?B?T2dubjc3Z1dKaDFZditWMzBuU25vUEZvQ3Y5anA0aFFDT0tycWFRd2xmcGFJ?=
 =?utf-8?B?aHh2Z0g0cFdxT1RtemxBRmNRTnNrajhXM1RRa0xNNEtpeTg3NGwrekxVWmxM?=
 =?utf-8?B?Q3c4QXcxazhzWnhycGozdG1jQlRrdEkramR0Q253ajJNV0pRUnVKdTR4eGln?=
 =?utf-8?B?RHU1Z2VqUEdlSVA2OUxqTGthVUZRMzlFcDZibDl0WkY1UlZaTVp5dDRGTE9n?=
 =?utf-8?B?ZGJZMitmTnZiWWVEcFlJR1VVdjVzcXd0bmJHTzNZeTdWRHVqbEtpRHFhejVG?=
 =?utf-8?B?WnQwNFVoTnR0aDl3TGVOc21JZGpSOHMzb3RzU2NpL2xxWFh4b2JTMFhGR1Bl?=
 =?utf-8?B?bWpJOUNtekJnb3ZneCtySldyK09Qb2QrK2RCVWY1NXB1UUtmNEIrUlFUM1h4?=
 =?utf-8?B?YVJ4MFJ2RmYwZ004bEhTRnRuaXVQSVM1VjlzcUh2RnF1emkxWDVENVg3d3BS?=
 =?utf-8?B?VXM4QVBYSkYwdFAwSFg4Y25qTkZ3REJaUEU1c2NFSGZyeFlyL0tBZGs1UmE5?=
 =?utf-8?B?UWNpTGdRNzlkdElubXk3RGk0cnE4ZjZnY2l3TGo3ZUZKYkYrL2dENldweWtC?=
 =?utf-8?B?dFgydmcrL3RwQnRuUmRkMjdSNjJpdnJBeDM0d3BkR3llRmJDMExqT0FFTFlj?=
 =?utf-8?B?UGloOTBkV3RRNlFoZkZhRXMyYTVUTm15YStjVG9mQWhnSzRwYWxLV1pYTnJL?=
 =?utf-8?B?cXZBYTdNdjZ3cXZpejB1QlRaS2IyazZWOGtZTGUyVmVQZWROWk8yRDRZVUZw?=
 =?utf-8?B?YTBnYUFEU013UGh4T2RJUVJMM1dKcHBRdDNBai9qZTZIbEl0M2RpWFB4MDRO?=
 =?utf-8?B?cDhINUtuUFhEMmtnMFF4eFNvU3R1dklLYnR6TndSaEhTdk1HR01qZTRwSHoy?=
 =?utf-8?B?aXgyRkpXNmx0OGJZc0NBZ1ZhVTlxeWZpcGErVHV1QjFNN01vQTFmN3EzMjRi?=
 =?utf-8?Q?jpzIdEmWMmoY8KGyRK0ltYUFi?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	JZDS6x+PhCHZyGSTvOsHT2ClhLgbFsrZfBzVkPcDAnix2k1ervVxq/lhQub9eySh8puDiJIhJypfELU0czYfb1hUMBcirr0L7I7grO1FKUa5BXGcC83LVsEJ87P4xCViGmaU2BEkNKiRUq8itfycEH6z6YtKSvUmW/KPbFsYU3qgel7PkHbPwOmNBrS+8153LMhwbfFZ7hdJOPExufL8ziWj5DBIGfGMqiy8sAus80g6fV7rXaAI/yANDCgfyTwDC3pIuQzTh7RPC4buuG/iMqezZnakT94V7lKzInO2I1I9wh52IlNRQfg1QiBsXvTVteSccq92n/rsqxy3QLQLCMf3IHM2OKi3xaOdVuioc0fAjksi9IeMf7pfvuUENwnjkoSaOdYVI3GsmhIOVIbMV5iB2/mJX+A4NV9OypDsp8ZG+ae6/XyiF3Kpet6exXAjOTormuMnHVzl6mrKl/wRte8+WyqaFBRPzyC3bIPpF+D6yWrQv4fQOHYdMQMFGfp6l1W/jVMpSnEitD2lypTZWwXwbmBPHQy7BE0TFhWVVQrqL/Sfsegzdxdllyvy95TNaB/Yn4woaHvljmCZdNEGoys8jx+Yh4PmJVbMPj2GCM8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f847169-74d5-4aaa-5971-08dc1dc65f24
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 16:55:01.7463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kdUz2vfVvmu3QSyo7O8Qw+7tyxMcii1gVq5PZgEcNis94x48zXWZoWVs8x/oPTnVO+4xFUa0ysLCnqmWnyMMWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6350
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_10,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401250120
X-Proofpoint-ORIG-GUID: f6PoTT4dF8cp-G4svMAB-DSixbA9IwY0
X-Proofpoint-GUID: f6PoTT4dF8cp-G4svMAB-DSixbA9IwY0

Should we get some understanding what is the issue before reverting the 
commit? I am not clear what is the issue, already asked Dan in another 
thread.

Thanks,

Junxiao.

On 1/25/24 12:21 AM, Song Liu wrote:
> This reverts commit bed9e27baf52a09b7ba2a3714f1e24e17ced386d.
>
> The original set [1][2] was expected to undo a suboptimal fix in [2], and
> replace it with a better fix [1]. However, as reported by Dan Moulding [2]
> causes an issue with raid5 with journal device.
>
> Revert [2] for now to close the issue. We will follow up on another issue
> reported by Juxiao Bi, as [2] is expected to fix it. We believe this is a
> good trade-off, because the latter issue happens less freqently.
>
> In the meanwhile, we will NOT revert [1], as it contains the right logic.
>
> Reported-by: Dan Moulding <dan@danm.net>
> Closes: https://lore.kernel.org/linux-raid/20240123005700.9302-1-dan@danm.net/
> Fixes: bed9e27baf52 ("Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"")
> Cc: stable@vger.kernel.org # v5.19+
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Song Liu <song@kernel.org>
>
> [1] commit d6e035aad6c0 ("md: bypass block throttle for superblock update")
> [2] commit bed9e27baf52 ("Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"")
> ---
>   drivers/md/raid5.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8497880135ee..2b2f03705990 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -36,6 +36,7 @@
>    */
>   
>   #include <linux/blkdev.h>
> +#include <linux/delay.h>
>   #include <linux/kthread.h>
>   #include <linux/raid/pq.h>
>   #include <linux/async_tx.h>
> @@ -6773,7 +6774,18 @@ static void raid5d(struct md_thread *thread)
>   			spin_unlock_irq(&conf->device_lock);
>   			md_check_recovery(mddev);
>   			spin_lock_irq(&conf->device_lock);
> +
> +			/*
> +			 * Waiting on MD_SB_CHANGE_PENDING below may deadlock
> +			 * seeing md_check_recovery() is needed to clear
> +			 * the flag when using mdmon.
> +			 */
> +			continue;
>   		}
> +
> +		wait_event_lock_irq(mddev->sb_wait,
> +			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
> +			conf->device_lock);
>   	}
>   	pr_debug("%d stripes handled\n", handled);
>   

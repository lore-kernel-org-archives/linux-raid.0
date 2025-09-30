Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D53220687
	for <linux-raid@vger.kernel.org>; Tue, 30 Sep 2025 10:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759227551; cv=fail; b=A+5TuRgOp/LedDYFsuSeZ88sccb590wMXNkbH5bUSDp8DU8o9IM5pDAMaortXgM7ZAx4U0/2yJIGN8hH/CdfkXn4eyNXHOWyydoC0wQpLedP5HIAAppS0fTKKsK3MUHy7gGf7s6UFlJQYmjCgw2+O5wWG6wnRXrrcnTkWV14CU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759227551; c=relaxed/simple;
	bh=+JdJfckJ+3q9fH6VqPvkxwizDvtFzRNidZ9AC2yHPXE=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jr9iClSL9aAP6y2IjGlDHSII3XF9SVb0VPLpLh25/sFDSqZfKTBVtzM762QdMeWrwEQlvmNZBNpseclmXlodfEVP71beWfZq33Lu65w8SXqugY4kCPpvawuPRfWy9NNyZKv0h+wcY2+nFrWsLNP6dqPved1EGe5smVAm3nmmz9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PERFm2lo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bZlxfuf2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PERFm2lo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bZlxfuf2"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U9JbJD024427;
	Tue, 30 Sep 2025 10:18:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xj46etyS7n0XkNYW/SnIHQs7mrMSvmSwODe2398Z3JE=; b=
	PERFm2lo7T72VmgOCVsYIW3p+to09v6vyYy/yQBfsZHLFwp1v3KHsEzWvSfPCJnw
	FHvHr39nYVlHPwX32d95D760ppGzTsryvq16kQk/tkJYHGWsjlPHbZVrbCgyse3T
	pcJ3b/G0CFNmR2o69XEwUsF9N061lvTuTv26TZlPWKMFun93d6iXvAv6yqlNx4w+
	FfNc9aUm1X+vrTxl58CVpnDByCjjCy4evYldrU/L5+y92jlsFfNpcdDoOfXBxYH+
	7GEsU8qB6y6RvLhCNDFiz8QEAFVOx55AagRTlfxsWikHk/dWSZS6G2B6o5X409ZB
	H6NuFaG8VnRkdlOWkZ34eQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gcfkr3rx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 10:18:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58U8YOY4040692;
	Tue, 30 Sep 2025 10:18:51 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011060.outbound.protection.outlook.com [40.107.208.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c7mgvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 10:18:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J0jAdUo/xtbop7iouCDrGI2JFq0y2bi+lJ6TKTNUu4pup3zz7pdsLP/iz5/NTmbzcbCaL/WXZsipkT1GZV5cHsz2dhjeOzfqmB2Euy1zs1WBrJO0mQTi70FctEHdbQLACSEHUOVkDhcdsU2Fqqr32/JoSaV2SNKX4gGDwejhnxiPmQh5jSAU9uzhq7TLYFjJY/r1ME+8j0+xTltRlULoRw6W6P2htwrBYg5NuyKHHTzoRH2v1FChvjGnyiuaTIql+QrMMo9QGgMpdX4L/pbLGeyySRlRqsjSGIOAFShujeAFo9JhFIJIka6N1r2gUH3+h83ZFovUfGGkiCJaZmIoVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xj46etyS7n0XkNYW/SnIHQs7mrMSvmSwODe2398Z3JE=;
 b=CUzuOLOoaTB3H2qPPP90TZnkDukvm1UIFP3TiyVo8svtMjhmoymsRn4w+cSDq9REls3wBgSocpSTY6Yhhx1gwUwitm/i9dxGwaMxGKt0zAa2vsXzVKAg0X0hmviDYYrZ+b/GXZeLTXcd3sEPF5Oc6ZWZXPPZj+3GEaNAKHRej7eIUbJ40eDEucY/89z9fjISBeHXoiL6vShT4Rri7hSLASy/FvEEVcqf8W/NrGg7dCy7n/njH+80YMz2lOPEytRy0RPxwa0u5KmKOI/IY2kLiZBPgolfk3JXFeVFyuXuQ8G90NU/r6byPNHQv4N20QVNm00VXMvjBDLI/EDmOV0F7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xj46etyS7n0XkNYW/SnIHQs7mrMSvmSwODe2398Z3JE=;
 b=bZlxfuf2kjPXIJ5ZhSlwVjj7EUaddfgxOvtVfGGtnKuwbaeWT4crZck6WqOzGvRc5AwShMElH6DyaBJ0wuDwMcjkTsW05PKpgdlLr/sbE3OEwQyDQbayMS091QFWyIUgAVmIb1Ig9UsVgbVJpE4faWnoyD/61uyWqYDNx0yf4Rs=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ0PR10MB4814.namprd10.prod.outlook.com (2603:10b6:a03:2d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 10:18:49 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 10:18:49 +0000
Message-ID: <0c4c3fa1-127a-4ddb-b940-7964d16c8fec@oracle.com>
Date: Tue, 30 Sep 2025 11:18:44 +0100
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH RFC] md: disable atomic writes if any bad blocks found
To: Yu Kuai <yukuai1@huaweicloud.com>, Li Nan <linan666@huaweicloud.com>,
        song@kernel.org, hch@lst.de
Cc: linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20250926125825.3015322-1-john.g.garry@oracle.com>
 <035a04da-7663-e9f3-fc05-3b84ec2554e5@huaweicloud.com>
 <1a548dd4-50f4-4332-977e-c29a2fb68194@huaweicloud.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <1a548dd4-50f4-4332-977e-c29a2fb68194@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0483.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::8) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ0PR10MB4814:EE_
X-MS-Office365-Filtering-Correlation-Id: 1865a37b-597b-4a04-5297-08de000abe7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmpycndpakRWL0hPRXNwNjI5ekZDT1pmWk5JTUVTalVTQWEydkw1REUrOHc3?=
 =?utf-8?B?eS9JdHc5YWZyai8wY3hyL0RGQS9EYitQVy9NeFlGS1lLRFN6MHhsZmJDQXkz?=
 =?utf-8?B?ZkpNYlBkNXdDSXYyYkNXZm9LYkRvRGlXVUFycXNPa05lSitFVWo5WjkwTjVD?=
 =?utf-8?B?Ykp4empuWW9VdERVcHF6Mk5RWVBJRW4wNk1xelNXNEJTWWNKbjZQdlUyWkh6?=
 =?utf-8?B?QUxwbjZQU3V5ZU1ENWJWNlI1YWg4VDIxcWlUS21wbkxvZlB3MHVHUlJjOTdl?=
 =?utf-8?B?clMvZjBjcVFYRGd5OHE4MFhzdjREdUliSjBDaDZVZEs5TG9OWU15WmI2cXNV?=
 =?utf-8?B?MjA4ckVzT01rVnVyeENhd0J0eFJXM3M1ejFDUnBCMXpQdHNsbjQ1ZzllQUU2?=
 =?utf-8?B?d3ZDVVVzbVcrY1EzOHA5N1hUUGxiU3VZaFM3emVxL2NQVUZXQzhBLzg2cWJW?=
 =?utf-8?B?a2RLL1FiNEN0a2tsK25TbHBHTDBJbWVwQnNKQVMrZzY5emJsTUxVTjZKY2Iz?=
 =?utf-8?B?L3JKTXFqTW5PMTkveVluWURHSnhia0c5RTNRQ1hlNXd3RXZKQVUzSE1kSGlL?=
 =?utf-8?B?TWR4cjBKQnN0SVlDS2I3RnVKdnQzejVTRjdGUEEvZ3I5eGtZTXF4VXJhMEw4?=
 =?utf-8?B?L0lNVDIwUytqUGhzVmMwR2Q1bWRxWHpRNG1ZelBEOEtwSHozUlN3VTAwYzBV?=
 =?utf-8?B?SGlMOEptTk5ZeEJHa0tpNjJVNTdHSE5mYmFjQ1E1TVVwQVJuNXFkendRc1Fh?=
 =?utf-8?B?Y1dMZUlBRzRhdFdNaWJWaHFBWk45bTYrQXBFMVNCa0FJR1F3d3ZNWjNKWExE?=
 =?utf-8?B?L1M4aFRIRzRwS3FBUW9ES3RjM1g0YVNQTCtFdDBmS2hPekZ3NHc2NzNSL2NY?=
 =?utf-8?B?T1E1ekdTTkVzMVBJQWpQWHl3M3FZYWJrd00zQTkwZThVcXIvdHZSMHk3U2g2?=
 =?utf-8?B?M1E4L2MrUVpuYmMwc0h1UUExdyt5dHc4c0dJeGFLOWZuTWg0ZTRuNFdBV2Qy?=
 =?utf-8?B?a3QwWjZoOXo4MXFVeU5uRyszSzZXb2pOVDQyaXlZWjFuZ0IyblF3cWtEVWNW?=
 =?utf-8?B?UlhrUG9ULzh6SklqUnBCZVZSYm1TQ29LcDZENDRiV2J3YXdxNmV0SjVMSUkz?=
 =?utf-8?B?UzR6R2pQVHlRSDIxb29UTjNBdzBLbXlXSmhTRWRHQ0xtSXBHWXhzS2dWc0Rp?=
 =?utf-8?B?Y0xHNncybWhSU0tJMlhlMm1rdXl5QnJYTnVROEx1M1prMkM1cmgrWkxJOTFi?=
 =?utf-8?B?OVJhSkloS3BPTVRKbGVnMlhIeXJRMjVrcFBnMkZJbkpLditQK1BWSlVRM3Ez?=
 =?utf-8?B?MVNFRDdyZlMyZ1F6RFYxS2k1ckJhbklZSTRIcEJzbjRVZXUwYXpKVWViQjVX?=
 =?utf-8?B?ZW5RTDRuNWNsL1E1S0Qyc0tnU1hvOVY1K2RHR1liQzNPUTZqT1RFY0hNdWE0?=
 =?utf-8?B?TTR4SGZWY1ArbjI2WHNYV3JBL1hHeXhtRjFsempmOEw2QUpxd3N6SFRSNXBr?=
 =?utf-8?B?SjlxdGxCSzNPYmp1T1F6QkpERmFuOWV3blBhcDRzNjFlRzVBK2F0U0ZhQndF?=
 =?utf-8?B?ckFtdXpka2FrRnFHckxHL1N5bU0vRnRYNGtJL3Q3NnkwUDAzWHZDWkRDY011?=
 =?utf-8?B?RFUrR0hIdGMvZWwrUDY3aWZSelc1MitzVDY2L2p2a0lhb0ZBL1ErdE9qVEhH?=
 =?utf-8?B?MDBzWVdFWkRZNkw5ek5pNTVBTHc1ZnpNTXdFMEE4ajM1bGNTL3UrSzlRWndZ?=
 =?utf-8?B?OE9ZYzI0eXVla3doTUVvb0pFUWo3d1A4bUFEb3JsUk5ITXhBNmRHOElsbGtq?=
 =?utf-8?B?WTQxOHZzc1hSS0FmV1ZOSkpqN0hsdTREZGpCVUxoQnRNc1NidGZCa3RGRUQ1?=
 =?utf-8?B?ZC9GV1hENmF2QSs4K1RVY2p4aGhLL0xWR1BTMEhIWVg1d2pXWTViTkZYL2Yx?=
 =?utf-8?Q?2aN0/dbD6LdxNCv5hD7iIm7YRvP1rZm4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3N1U0dwWmNNREQ2YVQ4M2h1eENCZHhkTzFLTzlZYTY3Wm9mbi9kaENvZEFt?=
 =?utf-8?B?UWhLaEh4cnNVT25OUEtMdjlTejljQ3AzYzMyWDVpbkx6bGpyZS82dW1HNWVt?=
 =?utf-8?B?TnRMNXFOMHJ5ZC9Hc2V1S25jSGphVm43WmU4emhhUDNLRjc2UGtlYWc3YXlP?=
 =?utf-8?B?dmlib1ZUSXF6VVZXUkptMmJHaUJxVWhMK1RTdmRCdDRZZ2ZRVGlVNlgzRjF1?=
 =?utf-8?B?YVprOGJVSTVkaUVwSUdQVzErZCt4QVVpMEFGRkpXM1ZNNUVaOEw1N2dhWFN0?=
 =?utf-8?B?Q3MwTGluWXdUOFFuYWFsK2NPQzczaUs3azR3djlRQ1NIcmpLbWwzSHUzaWE0?=
 =?utf-8?B?WTMzb09YZk9QQ0dNOHRsQXc1a0p4czJjRkl5eWRCWkFVb3ROTWNhWEZIdnBG?=
 =?utf-8?B?VXVLOUhOM0l0RFVHSk5RSXpOc0RiWFR2WmZFZUMwZWl4NG1PWTVkT3RsSGlw?=
 =?utf-8?B?Z0Z4OHY0TlRLM2JuMjV4OXFSelV4cnNRWjc5MkdTRTg3eTZYV3VENzBISG53?=
 =?utf-8?B?YUJCaDV6RmhOV1owTkh4Ly94Q2h4Z3k5d0VFODN5OThMVXZiT1JzcFN1eHV3?=
 =?utf-8?B?Q1R0L2dRTHpReGNicDZLMW9SU1p3SXRMRkRYTE9aeXdTQmI4V1NzZVNSZXQ0?=
 =?utf-8?B?dkZGakNoYXV3RXFZeWNBUU04dUpYZ04vQm9mNitsR0pBYWJnRkJvVmtMOVg5?=
 =?utf-8?B?Y0dlNzlOT0gwNmoxdHpKWEVtMk9sR3hMNFBXcktHMWpkRU53emtoNXI4VEYz?=
 =?utf-8?B?N3RRNlZKM2U0SzAyTkVHaWpTbmUvZHZIbUNvbG1pb0FHWlRhdGE2RWJQSkFT?=
 =?utf-8?B?ODRWSExtOTZtb3plQjQzR3h1WmNBWGRPMlAyVDZpdE1rOERjWXk5TWZCUVZh?=
 =?utf-8?B?M0pDaGkyWnhGVlhLVFBoaklYbGsxa0huNkc5SzV5Q1FHWE55cHF6TStzaFFm?=
 =?utf-8?B?TzJQOHlHWEVvay9qNU9LMmE1Ymt0WjkwL0lDWTdEeStYbGRUbXhIS3VXRTlt?=
 =?utf-8?B?SFFJUFNuUDlvNjRxWkpZczQxby93cXNpSko1VFFSbnVvWUlpd1VkWGgxZVNw?=
 =?utf-8?B?V0tVVVJuZE9idVpPM3BnQ3ZxRjdTZXVzVk1Vb1NhS1BYNE9USytrL2JlUXZz?=
 =?utf-8?B?MnZseTB2aExNc3g0Snk2QlV4VUM4VWh5a1ZiV2NCOTFPcGpkRExoa3lnWUNX?=
 =?utf-8?B?Q2RBcXY2NUwzSTNSNzN6MHEzVEJ5d1kvdXduRGtQcGpSek51bmNrM1d4SXZ2?=
 =?utf-8?B?NGtRVnRob21SNE93dzE1aFZ1NmEvc25HWWI5UXltUnVyOXVEb3JJbmpZbFVn?=
 =?utf-8?B?YStvSyt0S2xXd3lZMkJDdXE5M1ljaTlBNyt3cEZhTUE2WFd5aWRXY1A3RUNG?=
 =?utf-8?B?Zy82Vkx3YkNoU0F3NVFWeHlqcXEzOVlqQkd2NGhITFRDWkZnTmZINjQ2cVFt?=
 =?utf-8?B?cTVjOS9HKzltbFEyVE04SFFkdU9uTm5XaVZSUDVEME9GZENQdnliZU1uZTN1?=
 =?utf-8?B?UmVQUSt5aitsNERQZUptR2I5c0EyaXFaOXdKd0VUMkY2UVYrZ3FVMXREV1Q1?=
 =?utf-8?B?eWFZTkF6dUw0dzRLYWNMR0RHak0yNHN3SEFWTVo4bURGUVpIVW5LbmVQaXF4?=
 =?utf-8?B?VWMrSm9hZnNyYkljQ045YytDZjZhYkxqR0NwS1p1RGRDTHNHNC9tdy9XNWgy?=
 =?utf-8?B?MnhuTlV3MFhKVFd4S2QzcDE3QXNjdTRMeHU3dnJJSGRrdkl5WUxxNFd5Z0pU?=
 =?utf-8?B?VDRIY20rbENTbHRtS3NFdGYrWXBDeTJKV0lxRndqdTBRWlB3S1JiOUpVaFV3?=
 =?utf-8?B?czNPUjNlcWsrRjgySGFzNy9DVy9qTFVEWWlQMkVGWkNXZWQvSW9hTlNad0hE?=
 =?utf-8?B?cDJsL0ZobUpzcDl3VzR2QVdQd2NlTUpxT3diVE1MZ1g1K1pLZlhuZll4WFFB?=
 =?utf-8?B?TGhQWnVtVDgyRlZIYnVsYzBrNUFySFlReHo2SGM0UExISkJLR1BXMDMwSUdk?=
 =?utf-8?B?QklRTlk0UTJ6c1NVRVd3UnZ2ZVN3d3dyakNlMEVZSThXK2RycjZya2Z0ZHZT?=
 =?utf-8?B?dmMzaVRMQ2tZL09WT1FZQmQwRXJPN3YzM1orZmlUV0pxdEdSTHZQb0RBY1lZ?=
 =?utf-8?B?ZURXOXpLejVoYUhFWm1raSs2RTJtUkpwdTlveXZ0MUxJUjdxMmpzcjMwM0lx?=
 =?utf-8?B?THc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	isI7AlRz0izTup4MyPUHK7OxtO7T4DADF1Qz9HUzcgVRQDlTnYCCDUD7QD0vQxg8N3JaJAgWJ7RXiokqP/VSrtJNkjEso5G+g4qnDcsbs9qgVYcryjDY4Oub5QZEr/NXu+5Itj3MSafoys3uVKvcI9t3w+U9q/lQjVC5Rp7bO8PpUGL0ISpARDzRz2I4llcJJQnFflZtkHiS6pVOZ/uvLJGfsTxobxgnKWJe4NZqKomkWK5Jz4+nYhwhhLcXE/l7PdQJirzH76XIQkSi+wOxdPdt9pVBdX9JLU8yR9pMQ93Q0orI9RiqSBaPmU0u6qg7cgsqdqRmLsiQ2sFQLf9Iu1a1S1gp5ETQKW0Ll+7fs8rJXyncFg1QBGeeB6AJHeX0y9dqI7cDdGX9DfTacvWyh+K/KRB8NzSnAioJjtduMREOmz8vuZ21g2Fqctkuz9cXcuod7JKshKNrNR6EuDQFbn2rw27u0+hePgwOEEzlh1jUGreEWVOpQ9p/lUHbwhhdblWT0YrHKRN+wGIuOYSo/sSZ7YAURjTQZKmk9KuIfHoP9h+8/zfE+SaDx73f8Pg9SYRKeOewtkY+geMnxkIq/StC85Qu8WuczjZkB9+BRcM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1865a37b-597b-4a04-5297-08de000abe7d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 10:18:48.9559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+f5SqLyKijal23jdWAYQj0dhshRiOs+h2e3iEp4a1le69VIZ3xARMuBgaIMcyrc52kMDh4RmpFRotwnBWQ/OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4814
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_01,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=855 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDA4MyBTYWx0ZWRfX2kMen9xrC1uq
 8RQpRTc2r1IeigjCZqhH9YkSEY0p9kkSaN4P9pBSKSzI2zRybBt7j5mJPKMKCCHv6LLbIPFtd/t
 1N3thqTGYQCvXd2qoBnSAtnxFVboSKOuTwo/Oe7oWCnDMf6KWUB1Fs+CdTQD1//O1k9VqjHbll2
 VTojQDeuXCUSVcussGfqCC7CHOzmXwHzmWIgzAHLDqzibytaanuxUcG5cM/ZUeoj8qnkP6evngI
 gCcYJ50tR/rXnVeJEeiftBv9t8mWThQASyoDP5h72IKsrASypYPV9zEukHnMbuq+UeLMGs9dshM
 3KZXWx51Q16QFOLSohNCDB4LmK5L+yPbQ+dtWK2RHGuGdkTZ0ALHlBI79lJcvxccqQMrihYv0yj
 r/Ls41OjhKAI+6cpsn4y/WuXYD7lqVOWXm21wFpth4L11wCCa1w=
X-Proofpoint-ORIG-GUID: DB4hEbxrGTD0cJzwsYNI0YFOhpN2CInp
X-Authority-Analysis: v=2.4 cv=eP0eTXp1 c=1 sm=1 tr=0 ts=68dbae8d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=K5RN6Kn2nrLXPx2WSTMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12090
X-Proofpoint-GUID: DB4hEbxrGTD0cJzwsYNI0YFOhpN2CInp

On 29/09/2025 10:06, Yu Kuai wrote:
>>
>> If badblocks is disabled, devices that have been recorded badblocks 
>> will be
>> marked Faulty and kicked out of the array, becoming unreadable and
>> unwritable. That outcome is worse than a single atomic write failing — is
>> this the expected behavior?
>>
> 
> Yes, I think we want to create the array with badblocks disabled, not
> disable it for a created array.

Yeah, so for this we will need to introduce something like 
MD_FEATURE_BAD_BLOCKS_TRACKING_DISABLED and this would require mdadm 
changes to allow that to be set for the array at creation time.

> John just want to disabled atomic writes
> if there is badblocks, I think it's fine as well.

Christoph wrote "claiming to support atomic writes while it (bb 
tracking) does is actively harmful", so for that we would need 
MD_FEATURE_BAD_BLOCKS_TRACKING_DISABLED.

If we were to introduce MD_FEATURE_BAD_BLOCKS_TRACKING_DISABLED, would 
we want it enabled by default for creating new arrays.

Thanks,
John

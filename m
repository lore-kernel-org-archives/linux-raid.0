Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E276E163;
	Thu, 14 Nov 2024 08:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731572568; cv=fail; b=aAsXv1NdWEvkARFmvl7LD+22an8+PPoynOio9zXc/6jUTI4uzLPQH0LzEri6fjFMLZOaL29uLKKZNFGxfvUeRVSer/SQtm5O+JXiK9q2o+DzEowDISz3l5zPZNXc2o4f8F5IsGlxxHhN5CYtifstDfgfTddSDbivlnJ9tQxhEgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731572568; c=relaxed/simple;
	bh=iTgtcMJXfz4pfOC1RxaJu7X4YhR0HkljW/kfitXjrfY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b6+9G0xYgiLs0a29UIuEAErgnIXPbQF/AOsyAbA7d4Nd7RIqP1bSFsWhM5tYX3GidXOJa1ZkZEz2F7Zk3AbolO8/V+AQPI9hK7oc727bwTaRnYQZWGlSvRiomq/tT8JC9ghelINGZ2TBqjvw3a4k6bMiD8KjGH36XkAR5zpJmlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JZBI9gxE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qv520Ivg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JZBI9gxE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qv520Ivg"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1fbAo018585;
	Thu, 14 Nov 2024 08:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0RxUsifgDjyCZsQmDhiDQmPFY1U0HV5k6Bk0eMkWqk0=; b=
	JZBI9gxEME3aQO0aobPAmq9qLShCycjbhcVIQ1sMBTj3DRb6Hqx/CFAofABnMIUj
	Yn6ekeR/cA6GxQMep3lyOJ04uuD9i0QB1Y9BSD+sD5hDdsWvr0BcF/kQzXlMJMUu
	88bwijlEN1ip01XZIAPyV0kRhQXlh+MA2drshU72XlFnwwgoEq4BkFy8Unb9Yx4H
	1FIACdid3cMCUheoffImq0Jd+xO8O7H68A8b5cQO8uRwSmIE7nGMjWEBgnmtuSkX
	KMeVzqyJlqo1poa5uJETGUy/Ytx3jDxHlMmKe52ANDYqzpw4cHtZdM1R3IIDZpDc
	rTY3TJJTaebONiF7JQh/CA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0kc0s5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 08:22:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE6N8mC022780;
	Thu, 14 Nov 2024 08:22:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0y630-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 08:22:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HPhN6kzsYGsOZ93Rmy1Ew0f+ZhodsMKyhCTu6MXdIqN7TE063fexQKc2pfuSyQtc2azDhRTNEmeo5k72w9xI3NN49IgK/fWsAMixRGSj40FwUlkG6UUIe+ZwgUcAemGfAyg3uKb8YMKGvG3OG+9ahxCLtc1hYmZ7Gghq/yk9QJKZq+yR3iH4+bRf4PeCpS+Fbv4z70/pKQaaYmeE7CVyKIIcs9H0udqEt0Rw5BwLE4aWCv81CKuWFbHUO4hexnSnyXYoqx5UmskL0YhNKY0JAPhe7TuNuLusPUKzdXBaoLMPskmr8owcFOZk5jtAzVBVc49Cdm30M7rPsXZYWdOdWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0RxUsifgDjyCZsQmDhiDQmPFY1U0HV5k6Bk0eMkWqk0=;
 b=l4RtbKb4UZXOPou5GYj3g2ZR4YRKZgS3UxCwNmzs2KQ0NtsSiAbsVBga2Q2UhIW8f5Tq6ywSg92IG5nlnwlpsQkZXZQtWukNN1LDho+HtEwqRynYHTAi00irT/FJXug5DSe2xoT9QHA3yfQgrYVpUSkBtTzV0z1frCbEPlTxShj0t1XfzIvyXfKpQhi74bYkfuZwa+uzDg0y4EmNX3sqFgfP4+GGwB1leVDKNhXZqDF7qwhViup7ZVVFvcq8m9HcmOoaMC2aAKEcgissyKFp2abhLv8wALeWma6RrO5Q9brIglenXaOf1Xj6CX1/u85gN9Fq9p1eCheMGtNxcatpQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RxUsifgDjyCZsQmDhiDQmPFY1U0HV5k6Bk0eMkWqk0=;
 b=Qv520Ivg0if9sw2sWOauewGTX1A0y4I8Viz2Vf8HpzYEOU9g3h9PA9QHwYwBt2dQluwHHfRkFrZbnuDbFzZd4TRvUp28vA6GPhxIn8rP6vLYmau+vDn7l0OEQ8C7gyi54yYA7na7qSRbm7POFKhR5RgmzLngPmzw0cQ4KTKsS4k=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA3PR10MB7022.namprd10.prod.outlook.com (2603:10b6:806:317::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 14 Nov
 2024 08:22:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8158.017; Thu, 14 Nov 2024
 08:22:29 +0000
Message-ID: <8b3c057b-123c-4e57-9221-447ff1b073a6@oracle.com>
Date: Thu, 14 Nov 2024 08:22:26 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] RAID 0/1/10 atomic write support
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com
References: <20241112124256.4106435-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241112124256.4106435-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0180.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA3PR10MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: 80f2232b-8e35-434a-e8a5-08dd04857aa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFJHWWZoWU45UzhCS1IzNFdnbFg0VVU3TFlYbkpRbDhJVVhEK1QxZHFvSEJr?=
 =?utf-8?B?ZFdEY3NWeUUrbjNRRTlrb0RYZzJtV1F0Q0gzYkdGb0llMEQ4WTFjb0JTYi81?=
 =?utf-8?B?Y0svdXNZenVKblYzQzlaSW1WRmNjYmU1SEdCZnRHQTRWL25pYk9Nd0hrbnlB?=
 =?utf-8?B?enZWRkNXa0tldE00ZWFpa1c1eHIyb0YvRzY3T1B6QURINUJFSDFVTFdWTjIx?=
 =?utf-8?B?RGhNcnhJNm1oUjNIOFhhME5LTksrcTAwaEpaVEJiV3Y3NThJYzVxWEJZSEx1?=
 =?utf-8?B?US81Z3A4RGt2REpXYzR6M2hsUFlUcGtuRTF0cXJuREtsRG83L2NqOVo2anBv?=
 =?utf-8?B?U3FxRVRvRzhTeTJabHNMbmpzYnNuMDB4QnZwWnprOUlJOURwMk1vQzJ2UGxW?=
 =?utf-8?B?NVdEWkVaaFFKRm5VR1YwODdodnRSTjNXOW9kZmZCb0c0TGRrMWJteXdQOGxE?=
 =?utf-8?B?NmhhcXc2VndwVkdXUjhoOTVkUERNN08xaWIzUWlTbkQwS0xDNnp0SkQ5N1Jn?=
 =?utf-8?B?cC9tSzlMWGZVWUJjU2creFJtUW5FRlkzZ2U2QmQvZ3ZqNTJnTmVkMytzUkpi?=
 =?utf-8?B?OUthTWlRenhOVmJxMGZqQlIyY3VCVityRGtqMDJPOTRMaWZIazBsVzE5dmNu?=
 =?utf-8?B?ajkxc0FpNjZ0aHJBWXhudG81M2k2Y3FEZkV6R3FsR3ZoYzM0Tk5BZS83VW1v?=
 =?utf-8?B?MTZ0YUROdXhJdThLWWgvSndWVUtBV2t2MVlTYmVVMjlCZHlLc0xsRWc3eDJm?=
 =?utf-8?B?MEhTYmNGRmxIaXcvb25rQ09IZ21Bc2p4NmtuT1hubHZNZWh1TmtiZkxHcFJx?=
 =?utf-8?B?aFJPWnUvN2hGT0FLS3RzenVlQzBjelg3Y25ucU05bTFkRHhiK2lJUnVOS25O?=
 =?utf-8?B?VUw5eWVwcFgzYTVGUnU3bDBmU0pMUGRoN2VaYXhLOWNsTXB3d0hta0diS0hR?=
 =?utf-8?B?TUJ0OTJwY09rSStLWmlFMlZUbjg1dm96MjVhM0ZqNnN5WEhrampCSlNWazBq?=
 =?utf-8?B?VkoxZys4NEFCTEI4N3AvenNUc1NXTFhaWUtsMjlkd2lYNGZxUkRMZVVDV1Jv?=
 =?utf-8?B?cGNVMklzaU80TTMzQk13WUtJOTIrdXVQUFRYaURVd3Q5SkFNRHFsck5NSzA3?=
 =?utf-8?B?a09nR0t3OUJRVUg4YjhmZjhPU0NtaE5sbmdVK1FnVVBkbk5IdjhFMStrLy9x?=
 =?utf-8?B?d1BQelJ3dUl0TEloNEs3cmd1dzhxOXFya2xiTnpkY0dXYS9xUHhQSThpWkE0?=
 =?utf-8?B?TjM4cUVPOVNKUWJ6dUJzTURvY21Xa0Y1R3VmNlpCSFgzc3QxYzZxUTRlWEFq?=
 =?utf-8?B?MEZNRENLQUFNWkVzTElSTzkyNE5LSVJZbnkveHJxZzZnbUZqMUFRUWhmTzFO?=
 =?utf-8?B?Y3RwSkxTUTZhQ3h1OWVManJ4WWtHbjRPdlZXUlBmR2piU3E3MGRsbnZERmlJ?=
 =?utf-8?B?NHMwRERhRnJxUUhvWExjTklDTHozbXJqRWlMRFNKZklVdldzWnZxRkdrQlBY?=
 =?utf-8?B?Qkt0ZnVrc2t0akhWOStXR1NXSmQ0d1hGVGt6MkdtRHdQc1RYc1lJUm0rN1Jy?=
 =?utf-8?B?SWdTNFprQkl4RzU5TUkvQXNXYSttUjdXeUpzMTRtWFFzN1RXSzNHYVNQdlRO?=
 =?utf-8?B?SVNVODA4QVhsaEZTTWdobFUyWHByV0EyMUhtWktuT3poUFR0TFpQMDREVmRS?=
 =?utf-8?B?Y2c1ZW9heVAyV1F3UW5tZXpYeUUxSG9VY0hCVmZKeXpoMnR6cGhuOUlZZnN4?=
 =?utf-8?Q?TV9OfnFYZD/03IeQfAotlvSKaKN6BUOOP+rdDWv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGg4eXNIb3pnbVR4R2tsbkFYYTl6YUlRWlhIQTNsZWNqOUVrSm85dFVRR0tK?=
 =?utf-8?B?TVhFL0pGL2RpeWtMZWFNWmVxN1JFbXNhTmFGemZCUVVJeXVnR0ZPaGZ6UXNi?=
 =?utf-8?B?aW9OdFNNR1REc3JvRkUxQ3hCdlBORzl5R3lYWlRRbUtGM0VYTWcrbTNmTXMw?=
 =?utf-8?B?OFhJQUlmTGMzOWpmZnpKbVBsMFF3RHk2ZXpadWd5QjMyRFJYNGhkalpZTVp3?=
 =?utf-8?B?dkxjVkxBUHlRYW52bFB6ODBPSDgvT0RLUGpUWStUOEQ5a25Ibk4zTTBJK0Jp?=
 =?utf-8?B?bTJJeDEvZ1psUEY4V0Z3Njh6Z201dVMvVzl3c2lGRnY3RzJZT2dUTzlibUpX?=
 =?utf-8?B?NHo3Wnh4WXVwSTNsMHRjNHh3SEpsNCtqQm9jRUk2ZEZSMG5kazBjWm1GMGFX?=
 =?utf-8?B?aFJBcEJjM04yRHh6WnBIVGVmNGpXS0RjTjlCdjRzbFQ3V0lFU29xdDUwaGVy?=
 =?utf-8?B?L1JVQ0wveTZZaWFBdFlseFFORCtqOG9iZVhZa3YybUk2bDA1cG16aEc4cWxG?=
 =?utf-8?B?c1BKL01iTUxBTEk5ZnNjbG5rMGFnb3l3WWtDY1ZaQUVPVGt6aDFIZkdWUGdF?=
 =?utf-8?B?L1dZMXhYRWhpK0k0ZmFRYmtUcXBoN21CRXMwRndzVlhvcEg1NzRuREU1Q0VY?=
 =?utf-8?B?ckl3Y2J4MU5CSTZIZDNGbWg5dmw4cjJ4cS93R2I1VmVxOFd1ZzMyc2hGNTVD?=
 =?utf-8?B?UFJxakVaUU5tM3lMQTNYU0RneFNEQXdtMDBJY1c3ZXlDS2tUaXJhNW5aUjNM?=
 =?utf-8?B?RERlTHJDNU0xMmpSWTFIUzQxdUxvUnNUdEU3WExoYjZvcmNWL1NmOEJ2NDE0?=
 =?utf-8?B?dDVFem1mLzdNcEM2MXVFdHJuTWEvclloQkRZM3Z0NENRZXYyUVRRTVg4M1Fp?=
 =?utf-8?B?R1RxRjN4dTlLOXZTVW50ZC9SVEZwMHdDb2wvaTg2WGR1YnRxejI3U29ST2s1?=
 =?utf-8?B?R3hncjFBVUY5YTVJN0pnOW9GcVNYZXFzSjVKZGxQaWwrYlI2Q0MyQmVEZ2Zt?=
 =?utf-8?B?SUxSa2VQMVlvWE1ZRkdVRnQrVFRRNGpPd2RndU1MU0RsaTRkU1lnaVRhd1Bl?=
 =?utf-8?B?bEs3YXorbndMbjRxNU1VSHJKSG9lWktCOHlud1hnVDJ6aVQrb1h3SklyZ2RM?=
 =?utf-8?B?d0NEeVBUWlFQb2RkVFlIeSt2VitQTGpNY2NScENlRm82ZmMvdFNEeHhSMDNG?=
 =?utf-8?B?RnE1OE01Wmw3UzBXWVloZGtGbFhyRWVIS2dwQzBtaVVPMFRRZVIwSE4wZ0Zx?=
 =?utf-8?B?RzEzMjdBdEdMNjA1d1lZTk14WnZrR1ZvUXVnaW9kWGphRUtlTHhsTEFhcDEw?=
 =?utf-8?B?MGVzOEgwUkpVVkg1Zk80bS9Ub29kb2JjVG5XSzBFYnNsd3FkaUd5aHllWnU0?=
 =?utf-8?B?QkZWbzN4UkxpQ2pmRWN1bUpZbjZhdldsdGxlSU00djZxbkxDMGNyaVVuQ0Uw?=
 =?utf-8?B?TEhDMUUrTWhIYUxhaUpQMllycyszM1Y3Z2hpQ3Z1OGx4VVlZL1g5c1pzSVIy?=
 =?utf-8?B?cTFRNjE4WHhZTDI3UGQ0WkphZEZvNWJpeWVGMDZ0RFNIZFBVWmJXMFdyVm9B?=
 =?utf-8?B?UzlaUDF5QVdLemc4QkJxUHlkSnlEcVNiNmwyNmlKY1hBRS9kcUdISTlFMmg2?=
 =?utf-8?B?WnNJQ3pIUURYMHVHNVFRSEF3K05xK1hrZjZYSVBWM0hEUi9mWkxLdlVaRDNi?=
 =?utf-8?B?UUhWbUNXa1huUXlyRGVjN0IyRGlMelBZNVEvdVdsbmtEL0cyRnJjdUFSY0Qy?=
 =?utf-8?B?aFNJRGQ2czE3RXowRHg1NHdiM3U0UEVpQ3VCNHNsMGpNZjI2SjJWVmg0RlBV?=
 =?utf-8?B?Vlp0YWFoU25OeVZZZXUvSTN4LzFFWlNJVU5vdEU2bmI5ZlNZTmZ0bkxnL3Q1?=
 =?utf-8?B?VDViaDVOTk10WFFoSzhCTEp4U1Y1UElNeGFhaHk2NlJoajhnZDVXQk1JSXFQ?=
 =?utf-8?B?dk1lNDVyNllJQ1c1R0xhNnEyeDRMQ0hScmxxUGxpOFdIMlRPVjFYcXRaMlFh?=
 =?utf-8?B?b3p4NngrSHBCbXBOSXNrdTYxZmh3bjJQZUw5UDloQUlIL2QzcUM2Uk5rbE1H?=
 =?utf-8?B?SGlqUkx6OW5OOWZiWVhFckN1cHIzQ1EvTGF5S3N5V2ZVNEYzWXUxUXhwT3hk?=
 =?utf-8?B?RWFaS0d2S3BNZ0FCc0dFTzRNSlM3VGhNQVBTMFNOanhIM09kL3FYMWc5elNa?=
 =?utf-8?B?Ymc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lsBQXpC4tDS4/lKiVS/z+AmmBxiaDweCkrVzQni1mVaRmo8BiKxT5gBinUj5naTnf+f9Z+Nu5jWVOmxlEwHNOGnZyotbpcMJCQA4J1oku9NqvkeZ4dv21V/kgNbIWl7WSzHH4iQ1Dh+c74MWlaHjfKDnXQvwMZ+e4j+etfl+6vK0FbDjRpExMsvLwGC9MRsHPULKNcEuHo48IhGUjt1iBTGYh5rT/bgEw31bsdQHk8u58UMGawPhT+EoJE7D28NEtdogb3ADBnBAQl7h9H3TKZUHq75YoI7CTTLUZDs25BQPQBQP3W8Od6XMIoOdJUR1QXaHdbfBMD4LvMjV+iny1M1MmRSwOGhzQ4KHzV74k3AWV7jgHl2jB8DtdJqrQHPkOHEgp2ZlxWWOVkcnVb356qF99NmqJMBrx+kHsWFEWv15JFeaueS3ohZuImEnRGIKzOZJDeVfymW2ynkG7jgLBIdJzdUFpcGvRMfr4zHndiH6lhOb+jKeMZMFVC7t1jlMYlpECHtDkPkn/C6HN2Fw1rTEiMVJdXZbLi8c4IeHCTM3IGir7A7GxXyU4yNLLAI6EFNwL7/EKjpt6EZB5IH5UftnBiPEvfj9yOSwQ8oNNdQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f2232b-8e35-434a-e8a5-08dd04857aa3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 08:22:29.4614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EPA/JLL+MXf2JBWrJpWa5ujL1Ut9YVgDlnwJ9Jfhqis7KpOROtkFb3Wd8pKCAkNlegrNnlDw9qWJmVJboj0IvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7022
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_03,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140062
X-Proofpoint-GUID: HX3SO8_H5MvvCVJtB2pIAVntwoa5PCUr
X-Proofpoint-ORIG-GUID: HX3SO8_H5MvvCVJtB2pIAVntwoa5PCUr

On 12/11/2024 12:42, John Garry wrote:

Hi Song, Kuai,

Can you check the remaining 2x patches in this series when you get a chance?

I was hoping that I could get this queued for 6.13 via the block tree.

Thanks,
John

Ps. I do appreciate that I am pinging on this quite early, but those 
patches mentioned have not changed since the last revision.

> This series introduces atomic write support for software RAID 0/1/10.
> 
> The main changes are to ensure that we can calculate the stacked device
> request_queue limits appropriately for atomic writes. Fundamentally, if
> some bottom does not support atomic writes, then atomic writes are not
> supported for the top device. Furthermore, the atomic writes limits are
> the lowest common supported limits from all bottom devices.
> 
> Flag BLK_FEAT_ATOMIC_WRITES_STACKED is introduced to enable atomic writes
> for stacked devices selectively. This ensures that we can analyze and test
> atomic writes support per individual md/dm personality (prior to
> enabling).
> 
> Based on 0b4ace9da58d (for-6.13/block) nvme-multipath: don't bother
> clearing max_hw_zone_append_sectors
> 
> Differences to v3:
> - Add RB tags from Christoph and Kuai (thanks!)
> - Rebase
> 
> Differences to v2:
> - Refactor blk_stack_atomic_writes_limits() (Christoph)
> - Relocate RAID 1/10 BB check (Kuai)
> - Add RB tag from Christoph (Thanks!)
> - Set REQ_ATOMIC for RAID 1/10
> 
> John Garry (5):
>    block: Add extra checks in blk_validate_atomic_write_limits()
>    block: Support atomic writes limits for stacked devices
>    md/raid0: Atomic write support
>    md/raid1: Atomic write support
>    md/raid10: Atomic write support
> 
>   block/blk-settings.c   | 132 +++++++++++++++++++++++++++++++++++++++++
>   drivers/md/raid0.c     |   1 +
>   drivers/md/raid1.c     |  14 ++++-
>   drivers/md/raid10.c    |  14 ++++-
>   include/linux/blkdev.h |   4 ++
>   5 files changed, 161 insertions(+), 4 deletions(-)
> 


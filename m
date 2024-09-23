Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FCC4CB4E;
	Mon, 23 Sep 2024 07:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727077540; cv=fail; b=a232l9VC7hY/J3omm5SWhiQaVUtfF2R8zSblEe7uoWGueks3CSfr3IIftD1Eujs3hIwfw0N8p3TcGjt7X1Vy7DoNFiCtDKRMseOv88Mv/7WI1vosEX2dvCmNbWPkcByTAVY3qwXOZanYHWxGgOrwOXafAStlCrFE7Xiyr1C8zQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727077540; c=relaxed/simple;
	bh=S7oa1KT0Mr9TAJJWeCRXlVvIH8LgXhbnDl87EnIMOiA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J1t4kWnanXdt2zqM4Aa6J6cEqqJ583I0FmUsW3No6hTnKj7hfXuyitYf0UXyBwQS3SL6oHYg2HS5/mV8ZwprnLKMZMxygWiiCRr4Nq2oZxwvsfkg/8yfqq85Xp9YdSzVvzmmmv37HZFZEhC3yCzzM2nfaFmxAJdP8shYb5u/vqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dz3hEcQz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WWui4fGh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dz3hEcQz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WWui4fGh"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48MNaZJa024446;
	Mon, 23 Sep 2024 07:44:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=+D2OZhQj5jgRvkeoS5rca5ATQti2qTC+1tIt8k3Uclk=; b=
	Dz3hEcQzPI7sBbygvFP3N6z5UCqJvjeVj1ewocmHKmWl0p88P0YMsl6oUCaGK3ne
	SAeCxx9AcJb4GYE/V5Masq4kswspsP89rHJes/ZF52ns2E5y/AroUj9iTVIE1fih
	yYbWBWplr0n/G0Zo6A94XGNIpIFS/wdEzGVzUUYqfVWl/153NdmSarUJOZ+7lyGs
	DNiWD8kUAcnLmnXa09PHlhOc68azx4KMTFL4XWDD7DIOZUetHwFYzIbeq/YPIWKV
	Uf8Jva5Hhxp1tiUw5aC4n1KU9yTgbNkKMheJvWMP9luCNjCUWNqPGVCoIlN8oMg4
	wyxG6j7NBUAwW2j5LEHN9A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sp1abxcc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 07:44:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48N71CYF038055;
	Mon, 23 Sep 2024 07:44:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41tkc41r8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 07:44:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XM8ZSbCpbzpCl6pq7AibcwEpFCrX9mBXx7OH3Rb5j0rAYgOfaAEsplT3iLcPU6kVnLMQIjZS1NB2l0hKmBPwvMpkbq39+KxAnG+TTP7ZJCf1S4pForVFTHyg3sMJoNVUfcxPptb6JCMh2H4IvQp5xJ/nomKk30Kw4b9L2FkFeyvqsva1mVWhqNAKoyTdXVUOwW/Fgveq7D1/TX5F7NRAv8qsJlflVf7jJRHY5kcsYRxwkkXvhIeAJVqLyss8U6pVXkF7KcyAlM653R5amc/x44HisQIYUD07THBxBrls35DVf2PMEdVZA3KB/HgzfRpkxdxzSxxTeUuTkp+giqZluA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+D2OZhQj5jgRvkeoS5rca5ATQti2qTC+1tIt8k3Uclk=;
 b=WUby1ZK/CES1uAEJkv15w/Sidt4gbm8olfV8uwOqNaydl28lJ0w5vMQGWtYolOSbEa85EKDaT7Y1VeU2AYRBeGF1Or9p1+S4NwyXeyMsAsKla1dWBQnXD/Ug/rtgNl75IBvxrc49+FJRFTX7+3eZSWSuldygOEOvnwiT8o1ObLRlorhjj5DcmBt3UH5maENdWAoB1niulZlAwxY6C/zKAEWa+wVKU8xs+3FR7w6eZ16U5IZVQnvJnBE7Gbmb6iU+rBkc6W96OxqiDqR8obcE/ganIG3Z53ngj64/kpXuHTg7AU/zQQAOeqLAxRK2EB6XBwqGOTLMN/SQbdiGAZpx8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+D2OZhQj5jgRvkeoS5rca5ATQti2qTC+1tIt8k3Uclk=;
 b=WWui4fGhx0yQ6U+u/V4RUawjca4ZZDqwLmr/Z79d4RD+9/PB2zRxYm/vLU7SXufz3UsxHlCixntkxYbF5QOe2bZ79REU3yPDjC0/padE7lQ8yxMlL5m8NE/q49mGd+Z6jZJv/Fjt8vcWtFrbPNrqKjLWAAHBTdKtxaYzF3lSmz0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB6688.namprd10.prod.outlook.com (2603:10b6:208:418::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Mon, 23 Sep
 2024 07:44:19 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.010; Mon, 23 Sep 2024
 07:44:19 +0000
Message-ID: <44806c6f-d96a-498c-83e1-e3853ee79d5a@oracle.com>
Date: Mon, 23 Sep 2024 08:44:17 +0100
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
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0156.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB6688:EE_
X-MS-Office365-Filtering-Correlation-Id: 258161ad-d4b7-48c9-de00-08dcdba3882e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEtDbkNuc1BtdzhFbUFycC8wVG5Ia2dVajFnb1YrS0FFQTZ6VGlyL2o4Y2hw?=
 =?utf-8?B?R3Nmakg0RjB6SlVzaVBwZjUwNEtsZFdrK205aC9ocmR5Sm9TWGlJMzdqWUFN?=
 =?utf-8?B?ejNsSlpLYWkzYzB0MGp2UklwL2FCM0pEUjZqQ3JsaDlzOVh3b2dOeWxuR2tU?=
 =?utf-8?B?c3ZvRlk5RXI3S0tZQ2p1ZWE1UVVoM3ZvQ1VGUEVNY2p5NmNRdFRpek81QytM?=
 =?utf-8?B?N2FRejkzY3dyMi96Um54NWoyTGZPWW50UVpZTEtTQTJubG1aVWFXbkQ1N0Vu?=
 =?utf-8?B?dXNIMCtBWi92d0NIaE8vYkRxWmZNb0txbTBwdXZBc2kxTFZwbjRrcWdFbG5r?=
 =?utf-8?B?SWhBOWdnZHhpdThlRUNxeWQrUnp3ODlDTnV5bFV5UWdTNHF5WkdIVVRjVW96?=
 =?utf-8?B?ZmhhTDVkc0R6MEhjUGdCOUNNWDdIanBKclI5eVZPSDRzbnRMem5LbThSSkpv?=
 =?utf-8?B?c1FRMk0vR2ovdFVrRHVXazFUYlJrd0ZueHRKWkRvUmNhR243azNwOWlQTTNY?=
 =?utf-8?B?QVlMOHNvcG5JQ1BPOWxuMDBKT1A3SncxQnNwQXBMb3pXaE9KRWN5bFpoT3BL?=
 =?utf-8?B?NXJEaTZ5NFpLL0JQZVhkU3BqMjVJU05LSndtQVozZHpBWE5ZeUdQb2d3TldD?=
 =?utf-8?B?cDZHcnZ4VUYxd3BEanljSnM1UWQxVVFseDk0ZGdacS9ZcjlQY0RSM0w1Z2dw?=
 =?utf-8?B?TzdlZ1hQQ3FNcVlFTUVaU2dtaDlXWmRPUDZQY2s5RlNlUHkwTlJLK3ZGcDND?=
 =?utf-8?B?a2FvVFJSZkFGOVdhYnRFMFJBSy9BaUsvMGZuL2VMaEZyNFNrNVFCT0lwbSt5?=
 =?utf-8?B?SUNYR3RtSFh0aHdPV0ZxRm94UnVyT0VqR3lXdmlFVnRDZmZYTEpwWUkrS0lX?=
 =?utf-8?B?WnJhSFdRRG5hRktvMTEwdkthVGJieGtIMUdueTRkVUdsUnBObS9QRWhqUklC?=
 =?utf-8?B?U1QwdXdIZE1TNnFvNjBNblo4RGszV09QWjllTTNmeWFuc1RYRUFVbkQ5TzIz?=
 =?utf-8?B?aVBaM3lwV1o0NENtbGdXamk5TGF5REViT29oTnRNYmxwNGNjK0g2SS9WT0dn?=
 =?utf-8?B?L3N2angveERYcXhaZ0Y2TTZRTG84cEFldkxWZm9jVEMrRGlQQ1BmN0o5dVB1?=
 =?utf-8?B?R2IxVUxnMGxwajJPTGQ4YWRPZmk2RnV0TGZHNXpJczVHK0xJK1MxWjBsTDJq?=
 =?utf-8?B?TjBINnEwSjV3KzdmZlIxVEo1UWpOd0NTRzJJdU5SMnZlQzZ4RTNBY01FOXNF?=
 =?utf-8?B?MmlYaFdOMS9aS2hHdnlnMC9mZXQxSFAxQm92OFJUWkhIQXRxMEFxbmZKbkVC?=
 =?utf-8?B?TTh2MzhEbG1YQzhFNm51cXYzNytkNjRqdlNHRWVtQzlOSmlYREhBVCtiS3pG?=
 =?utf-8?B?bXlKSDA0aVBGTmNoaEo3cGpIMlRqUEhpYzQ1azN3WlEvQkZmUE1Zd2VKVmtY?=
 =?utf-8?B?VkRnMlgvdVpXKzdJdUtoM3QrZ2E4dnAzQ2tkaTRWNHd2Z1dIT2Nkd0lJUldB?=
 =?utf-8?B?ckVtMDNodlh0T3AxaXQ4SXdLdGVDdUFqSjd5bkJJOXRveXdlbHBJZzBaZ2VM?=
 =?utf-8?B?SE52eXJQVjlnME9XMXJ4REFSckdrZjY2alBzd3lRa3RPK2tCQ0JDbkhjckhK?=
 =?utf-8?B?dnFEVFk1Tjh6aEpxdStSSVMrTzVHVDZqb2t6a2JSWk8vd3BMZkZqN2RSN3lt?=
 =?utf-8?B?Z0xBdUZhbk1JcHRXMDg2Tk9sY0RSNWNjTWpnY3p0RHdjMXdYQ21yMHd3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGpvVUxxSEs3ZElQRzVCcjd1NVJWRStXdzRLZjB3V29pMEt3NzM4cDdxSUE4?=
 =?utf-8?B?bTlmUGtCMkJvQVdueWovY0h3MXZlUjFtYXJGMEQ5VVZLOXFOUmp1RjRRMGVE?=
 =?utf-8?B?OXVyUHdybXFnQ1JBT2wybmpkRzBKNzlMT2x2akpMQkR6bTVNNVJ2dThlV2N4?=
 =?utf-8?B?bGo0cXlhSGh0K3F4ZXBmVk9qeVdYQU9NY3NoWTBnY1g0eUdFeTRiZk1DMDVr?=
 =?utf-8?B?VU1SUklTM3BUYVNDWm9KZWd4bEkybmszRmJocHYvSkJuZFFoYUJFL1VPYXVR?=
 =?utf-8?B?R0p4aXlOQlFxNWV4L1N2UmtacEUrMEYxdlF0NzVhQUFQbXplNlphbjJudndS?=
 =?utf-8?B?d0VuVzJsNVVoYlowSS9qdVdtVEJCTlZjK2REZk9DdE90YW80eHh3bVE1SlMz?=
 =?utf-8?B?Y2cxeEZtSk85MUxQODJLR2YxSjZpNTZWUUMwSUd5aGtXNjJCNjl1MFlSVncy?=
 =?utf-8?B?Um8xR1ZyNWhEY1duZWFXVG95SlZVNzZ0Sk1LR1pHOTM0Y2tBelowc25hSmFV?=
 =?utf-8?B?WVFjTGlESkE1NkhiQXNHNU1RSFhSTERHWFNVUVVrWmJjSnYvaUJRemcrY05W?=
 =?utf-8?B?TnZ6RE1kc2tmeDZDTDd1bUNkb0IreTBvM3BCREF5VG1aWE5PKzVEdG1mbTI2?=
 =?utf-8?B?OVppZmxwb2c5aGdSa1lTQWhsYXVQYUQ0ZTZUZWhqTGRySVp5LzdPWTZjNHZN?=
 =?utf-8?B?a00zZWgyVThvVmo3UnVLeUtZKzl5YzJQK3hIQ1NZYVlrZ0pGeTA5ZHFPVFZ1?=
 =?utf-8?B?dDNDay94bThSM0tZSHRSYjFWdEpKYVQzVmpJbC9WclpCYmtKeno3MThLYmNV?=
 =?utf-8?B?cVZFMWsvZG9WNFFVY3B1TFNrTUZaaU1Eb0R4VUZNNXc3Tm9MS0hVWHMremww?=
 =?utf-8?B?SVNNbVMvbjRza0ppalNxQ2xXd3NKcXo5QzQrN0ZhNStzNHpXVXZEckdHRmlx?=
 =?utf-8?B?WGhHOXZmUzdsUnVMQnhFNUszMTIyTElrTlBaaGlWNjlwWlZOMEZOUk1mZ3B6?=
 =?utf-8?B?cHJ0VHVUUDQvYm1CeTVsTFZyaHZxL2djRlg5M2ZpSGxhUFdPRTk0Y095czZL?=
 =?utf-8?B?RHNlQTNFT1N5cVY1dTI4NTNZREVnTjlieXczajAxS0pYblBUUmYxRXFvMmZE?=
 =?utf-8?B?OS93NnhBdWc0cy9PYTljWityQnMwM0FaOHhVNm82aGhtU2orV2pUWjVmbk1G?=
 =?utf-8?B?MFA1ZzVOaWVCd0xlL0FTWnB4cTFoQnJiRnorNldoc25GZFlSZjFjWkxEZDI4?=
 =?utf-8?B?SFVsVjJVOG1yb0l0M1h4RFd1UVQ4d1NZTGluYUJFTDJQb3RablJxSDZiNlo0?=
 =?utf-8?B?TjVQVnhSOUk5OUZ2b2lNcTgvYlJSYm1PWk9IeVlBWUh5U2YrSUlEcFVhQ2xi?=
 =?utf-8?B?SmxiM3BMS29kVlZhRCsrM2FqT1pVditjR3JLLzEwK3JraVZMRyt2VStGbzIr?=
 =?utf-8?B?QlRCc21kdnJXWnFwbVljdk9YMWxuL2dnVDYxV1RZekVrTDBYazNOelRSVmZL?=
 =?utf-8?B?SWd2MGJjNGZBWDRIbTFJYkp1NWNxeG96OVUycno0Uzh0eDU0YUo4S3hkTGtZ?=
 =?utf-8?B?eERZeGFVaEpZUGRNMU5hamFhVGRlWmVpMy9teVY3aHJlZzJWdm4wV3puR2sv?=
 =?utf-8?B?Rzc5S085a1VyZzhLbURCbm80cjdYYkc5M0FzblRpc1p5TFAvRThJZ2ZoNzFP?=
 =?utf-8?B?NFV3TkMzcXdvakF2UzUxRXNLSlhmaVFJTm1ZZjZ6MjZxRWJzRmt0aGd6b2NG?=
 =?utf-8?B?ek9rc1p3aGZrempCQTFaUDl2UnQ2dVFITXZuTmlzSGUwNk5pcUhFSkl1NHE3?=
 =?utf-8?B?QWFQR2hTNmlOVkM3Z1pSSkVpUXkwc01ZUW5xS1IySy9xMThib2JoalpWSnA5?=
 =?utf-8?B?UFA0QmdERm5RRHBOeklCY0d0NURUTERIaGpHUG5KcUpDMllScUVqaWYzbnBD?=
 =?utf-8?B?TU1weTVEZzJwa2d2dTJiRWRBc3JZc3NCR0lOVjk1S2pwdFp3bHhFb1hJVjNE?=
 =?utf-8?B?eHkyeTJKWm55VnBOS096ZW9Fajc5YlVMa2wzbDdHaTYrakhnTWRPWlFvY1Jy?=
 =?utf-8?B?M3o2OExVZ1dTUzhzSjJvQk5QSkRTTVR0YXBUVlN6VmlOU3FtR1lEa2lJTlor?=
 =?utf-8?B?SS9DL1JybWNQYVJkY08xdVpEYzh0SUlhU0lYN0doVTRWSm1BQ3R1R1FRQTU2?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nLzoTgNU7ZyH0dCErRQR3r2poZeogmsuKvV1mHcTJ3wJRVDl8qMFQ5Y7yVWqqhm5SYCxzSA/BvV99165wbSc8mYu3qUrUp+FG2Y1coqzsbdBFF1xZtRSio3y1MEW+78yyj3s3VliC3rpMddE/yeqXgWZerVnD8urLutUzUWk435JY6EDO0tAoTB5zmNzbDYoQ0zayMJH1xoc0oO5V+i6c9cJqCwG26Uv4YOiONT6VDJx+reMVexc8YfZO/7oKwZ9ptvzQ7HnBDaCo1wuTw+WnTAUIhUsAOY/C9osXnon/6NGdjSm2Zj+xCFUnUd3kSgmSeCsEougasangR7Cn5/bBfNllieJjoJx5p04jvEkryf7ypJ5To4VdlGeLBOr76JyGc0vzZpWFMDq7pQmlI6JtAc3wQz9mncLLlGYNjPaAQG+Yru/VgQhd708+S1trR+xfsgs4HvbBPgDF+EQsrGnGXavbwZ0eBJvRdm0dvdmfSqkecwoZbVIZtax7wtfYhZ8gqC4g0z7oc5gxZJoopx0fj3MBuam3aabU+feYzX9/n5ygBic4GOjL0ySvht/HLbfqugXrn7tDeCXyWy516qzRQvkud64QIw72KIM/3FUahk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258161ad-d4b7-48c9-de00-08dcdba3882e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 07:44:19.3639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LXdhpK/pCFxX6RdqjDhyBAH+DzgdkXo12Y6cnW8E0WBYs67X1bXajdLJWoyhju/5CVEK9LwImeOe5BA28Z/Hgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6688
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_04,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409230056
X-Proofpoint-ORIG-GUID: Isct1fqu7AiLO4OQKtYGDKt15t_m85Cl
X-Proofpoint-GUID: Isct1fqu7AiLO4OQKtYGDKt15t_m85Cl

On 23/09/2024 07:15, Yu Kuai wrote:
>>>
>>> This way, BLK_STS_IOERR will always be returned, perhaps what you want
>>> is to return the error code from bio_split()?
>>
>> Yeah, I would like to return that error code, so maybe I can encode it 
>> in the master_bio directly or pass as an arg to raid_end_bio_io().
> 
> That's fine, however, I think the change can introduce problems in some
> corner cases, for example there is a rdev with badblocks and a slow rdev
> with full copy. Currently raid1_read_request() will split this bio to
> read some from fast rdev, and read the badblocks region from slow rdev.
> 
> We need a new branch in read_balance() to choose a rdev with full copy.

Sure, I do realize that the mirror'ing personalities need more 
sophisticated error handling changes (than what I presented).

However, in raid1_read_request() we do the read_balance() and then the 
bio_split() attempt. So what are you suggesting we do for the 
bio_split() error? Is it to retry without the bio_split()?

To me bio_split() should not fail. If it does, it is likely ENOMEM or 
some other bug being exposed, so I am not sure that retrying with 
skipping bio_split() is the right approach (if that is what you are 
suggesting).

Thanks,
John

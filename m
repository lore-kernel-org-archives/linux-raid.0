Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF31194A40;
	Mon, 23 Sep 2024 09:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727083326; cv=fail; b=KiTDNxtMz3kHiG4K5AdN03WIlFEAy1lQzAlqhgBTgFRyS9/8gz7ZrDcReEcrv7rFL6xFBLErfTfTbuJmaQs4AUo3imD8mc2dq+11GCfKU/qdiyeGvUHGgqhZ8q0yi3bBD8lC4hHBXlMYw0JLMWEKZkgP2rTR3rVYLZvMEvktYC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727083326; c=relaxed/simple;
	bh=k/1JnUpBL0K99fyDCLqJT40+TD2trzXCUGRFf1ZeTpk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ecnFX66vy4KXp5dLxHd1CsiE6xR3+cZaQSeC9c4hRNHiTbYimUGriMY1hY0RhhLkgw8F6fp5aMme7mpwMrz2ULzVGqxLZSqJ5fWpPvH4NfAPyjEbpCv0sSV6zrATP3js8H3oTsQXpIl30RIlncBgF9KHEnGsMuQzjRjwVxkY9rg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kYpMEJQc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AsN1mRvz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kYpMEJQc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AsN1mRvz"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48N7tknu024055;
	Mon, 23 Sep 2024 09:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=8QZKmCurEsW/iNdpfos5Z3IoRpLqwtOzb8e1c9X4nrg=; b=
	kYpMEJQc9EXuC/A1QV+RCn09IPRvye02ELHQIVzY1Nm1upESUdKQPRtAtZzsDp/h
	nI2O4BRyyZkDFk+k/oBBg/6DUtXprdAo50GROBIsbMjfzPqNrBE4VfyIJ6ZhwDY0
	QomAqWl0SYuYGkNZwIm3FabRrwHmYVeUc/XqidZE0rlB7Ya99XajTrtxnRzskxYh
	OEUpP215t9nUcUiQzxsiIQ6/mFoetMXVUs2aiAchD9R/g1YtWR0NcGPBh1tHIpnj
	R9kjmYgckKnC0Smp6dCPeZuVXWGOlBE6mkIDejrRfTRib9lTmY7J64CiFPrkUJMP
	yJxZiLW3HiDCPMuFvIo5Hg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41smjd1qx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 09:21:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48N7qoS5028270;
	Mon, 23 Sep 2024 09:21:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smkdsneh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 09:21:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TZkNh0Ay3O4z2q/EGPg9izJMqkKfsDw0gH0ZwxOWUHQOyuqo34NG31akkLCbqSZCqqoM81DxReDLNUwCpPgzpzD0yqk0knEoNk1cAwlA7I6bKe3SXLByBALA+gKySdfkG+AirZewh8q/EGPtnuFknFkbRbld1QHfMJ7MDs8IarFKnkFvIZDZuz+95a2RE9DOxhd/ta/olTYm0RPTBCaeGtCwShzJyPgiHw3VtLzK6fvGqCOHwGO3KhaFwgEdj8n+qK6F1Px3wXavPV2U46tR/FvIzT2R6Oovjiquecj2kE3IiAksBPc4uGFduzHyLRJFrXXv1pDHdLEiOtlJpLgJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QZKmCurEsW/iNdpfos5Z3IoRpLqwtOzb8e1c9X4nrg=;
 b=IL+RicMTjvZlk54AsMlgDNSTlsrd5XgX/If8VgFgQG8+hBs40Az1KmlW2KjCRtrj7suNTMXoJol/v20O2tHh/uexHpnz8l3VoSoiaeqJRFKiUnbTCxA5kykPXUBEXjUUJAXbiC7+fegzagpQaEU7swaLptiMVkhRnvObGkQGmz48vK0HCMUGMHeCfA9vxWhPEiMu5tc8Wd9/TyoUgFBFOhKR5pzig+qd1lS6EkhxjkrGwEaXdSM9xtjYkFDZGVRR+LdZGMLMS3PSP8qyUFAppsMd+SCLQYlApPSDyMa9f3VnWskP5zDpHxc5byqtlLevl7ObUBRFN4hFDmcUnJ7lyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QZKmCurEsW/iNdpfos5Z3IoRpLqwtOzb8e1c9X4nrg=;
 b=AsN1mRvzS8cpqVsZc0Gc/YtZrRa+blyIkv9lFfUterjUfMSbmABuleWSaUhto/EibeACHMg7uBkWNh1MhUUXQCJ8cY2FKK58WSFu25Dzy9tQ+w6oA75s2Ns8R6TXbHj2+e6e4G6dwVDIOg+SFdc0qyNHWb1aJyry4fliWD2+6w0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Mon, 23 Sep
 2024 09:21:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.010; Mon, 23 Sep 2024
 09:21:27 +0000
Message-ID: <6148a744-e62c-45f6-b273-772aaf51a2df@oracle.com>
Date: Mon, 23 Sep 2024 10:21:23 +0100
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
 <44806c6f-d96a-498c-83e1-e3853ee79d5a@oracle.com>
 <59a46919-6c6d-46cb-1fe4-5ded849617e1@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <59a46919-6c6d-46cb-1fe4-5ded849617e1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0034.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5128:EE_
X-MS-Office365-Filtering-Correlation-Id: d160da50-bf1f-4a87-1094-08dcdbb11a53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTJVUGl1d255RU05U1JBMWNnOUU0RDI4WjhJSGtWblphVWx1QnRRL25CbnlI?=
 =?utf-8?B?S1RGTWl4SU5TcmMvLzhDdUJVNHkySzNoYWQ1b0dhWHVwc0hjUG5Eems2U2FX?=
 =?utf-8?B?OHpFZWpYMmVuNzRjVVppUW5Fb1Nxck1OL2F0WnNJOVJpVDZuNStBZFI2dE8x?=
 =?utf-8?B?dTlWSTk0cUczS0UxcWtDZkxBeTlFNUpPWjVDTi9aU2dkS2hDMUdzTjNVT0tw?=
 =?utf-8?B?bEluQXVlMFRrVHpWbk1adldQS0lQQWFVSG1VUFoxbHptYlljbnFJK3ZMc1lE?=
 =?utf-8?B?SWV6czMvUTBtN05qSG5lOE5icGV4T1U0N0RVZDVzQzBxZFdoSjB6SVVpOW01?=
 =?utf-8?B?b0dPS2oxTWN4Yk8vY3JzMVV0RktoSlpCQkFDMkUzL3hMWVpUb2U3czBBbXls?=
 =?utf-8?B?NkpNdTR5bm15WWlDNk51UUdvODNLK1hHYVRBcWNLUDhFNUhrOHpMUkNyT05N?=
 =?utf-8?B?cHhublgwN1QwcmVaLzRZNEptVTdKeHJQdkxJUDZDSnBEOXZaN1NPckJVNWpU?=
 =?utf-8?B?YlZ6dHllRWkxUmYvaFRXZUxNNjdqa3Avem9zdlMwdVpWaVpoOUhOc1NBdmky?=
 =?utf-8?B?REpiYitBT1BIYUowaGwwS2ErMUVEYzl0UVkyZ3VmOEdKVitJM0hGUHNYNERz?=
 =?utf-8?B?VXN4NUN4RG1QOE9EZWtoZWgwNW1QUXlIdm1ROG8vak1tbEFxTlcxd1EwNjF6?=
 =?utf-8?B?eUo4b0l2VVNlaUo5QTZYczYyV3R4ckZhTjduUHRmM0Y2ZFQ2YUhHVmFjMjJR?=
 =?utf-8?B?aDFQckdITFRsQjlnb0EyM2h0TnJjSXNMbFpnTE92VnNvS3BBWE16Y29hQXNZ?=
 =?utf-8?B?UnYzRzhsdWZKRExiQ1VhaUhaUjUvQWJCTVUxQy82N0Q3UnJGR3EwMEN3bDhl?=
 =?utf-8?B?QjI5MXA0ZE9kU3FXTnZleWQ0L0FPbmt1QTZ3SVpndlRWUjFuVFc3VEo5dnNQ?=
 =?utf-8?B?YkxJM2NLUWozcGl0cXlUNE9WUUJMajlaTUhna2NOc1ZPeFNVbDlCNE01Q1l5?=
 =?utf-8?B?YWhHMnBTTFFObmtRdzJLOVJVM1c0WTNTcm94dE1NbC9LUlNSVUFBUS9GcUpM?=
 =?utf-8?B?LzJ6UXp5UmJVTnJENmhKakNsTTZGQ1NTSHV5dUhDdU1XcXluY29JZHhwVFpH?=
 =?utf-8?B?ejZPL0Zjak1nVmptekpwY0tFTXpRc2xkbkhGSlN1bTl3TEhZcXpGSFBmSzY0?=
 =?utf-8?B?Z2pDeCttem9yeVkxeWFrc3NCWXVVZ0VWd0g1Z1hMeHlTYTdhUWlBTkZSMU9H?=
 =?utf-8?B?cm1sYm9KREluSEozNVBBVm8wSWkvM2R1MUd6ZU85SC9BVC9KeFczTDcxazV1?=
 =?utf-8?B?Z3F5a1VuY0tBSUxrd21wcWxmaEVwZURQb2xwV2NJU1lVRzdNdjdwdE9JT3Rj?=
 =?utf-8?B?N0YyWGRpOTZRVDhiUGNXaDZUVFJzeHM2bzg2TUFkeVR4WkNOaVFXQU5aVFZp?=
 =?utf-8?B?ZFBWWWxncVk1ZGVKWE5yUVJyMUtkM3BmOExoTzNIaW16bElXcy9kbk1abURo?=
 =?utf-8?B?eG05d0tFVEU1RWh1c090NDFVK1V3U05ld2M3bmhoSTBYSDY3ZVVjTFlvNWNn?=
 =?utf-8?B?V05teFlIQlpIcUJGMWFWampLRWpxaURkTStqTkZXMHBYcGY4RWR6aWVIcFI2?=
 =?utf-8?B?eWlZakwzRU04aVZ6cU1aUG5IYzdmTmhvNGdmQ3BzcGZnWVdVaVZ4VExiTmds?=
 =?utf-8?B?UmJ5NFJsUUVTS3U5S2FPaU5VdjErdHRWTlgwbXd4MW9qbkdOWmdqODJBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnpnWWJITGlMY2pCekVUTTVFSUZFdU5uU3FwMCttTVVzRXVQb1krbjdCYjFV?=
 =?utf-8?B?QnZ5R04yM0MzWVZobUx2S3pEK2xyWjRsQ3c2bzZSZTRRZC9lK2ZIa25iOHM0?=
 =?utf-8?B?eVNQdlltMFgwc1F5d08xTFJxSms2U0UvWmV1T0FubDhuWEwxZS8zQldOaExI?=
 =?utf-8?B?RExQVFBoVjBmbjVVRDhlMmlYY2I2M0M0RzFVUzY1Sm10bEpNMmNjcDEySlJN?=
 =?utf-8?B?SzF2ckFIbk1JOU1ocks5Y0JKSzZ4UzN3Q1ozN3p6Vmw4VUlKeWtZUnRXYVJI?=
 =?utf-8?B?T1ZnUlJvSVhIZExqc3ltc1NWZVVKQVFqdlhQTm44Yk1pa2l6clZESGgzWnVn?=
 =?utf-8?B?UjQyK3FaYnpSYkNlbXNPeFl4bzJHc3c4Z2hkS0dmOGhhbDRFeEFHWnd6MlIw?=
 =?utf-8?B?Q2R4MjZWUlNCSTNHb0kxc1llT0ZocGdjMDV5QmZ1SzFtT1NTY3IxYW0zRHA0?=
 =?utf-8?B?OHNJWUZtbTZ1UkJhbG9meXNWYUY2VlZyMEsrRnA1TDNFb3dmWGxSQmt4N0xn?=
 =?utf-8?B?NmxqaW9oYzFMQ1lZY2ZoOVJOUDNUQlYzODNuemlleHcvOXpiMWxXYTlWRjZ1?=
 =?utf-8?B?VE1zeW1YNEgxSnZuU2J3V09VeDE4akN5WWE5QndzeWJIek4zbERLd1h4WGlI?=
 =?utf-8?B?Y284eWJvdGZrTTNmWko1Y3E4dm01dkgrMnRFaWczaWpQSzBCNVFKZDJ1ZGhV?=
 =?utf-8?B?bUtoZ25KRDVGYVdsdDNlWFFzckVzWTk1S0ZXVlRGN25yMEt0TCsvSERwRFpU?=
 =?utf-8?B?Z1YrcXB1SW9PNThuOWFlV1ZtWGJCRGI2T2FEZXp2ZXBKeUtsdXNjWUIyVW1H?=
 =?utf-8?B?cDNOSmc5WU52RWdmZG4vTTRDMS9DaFNnYU1kMlJSWHBsWTBNaTdEMWpzRkxl?=
 =?utf-8?B?NUtTb1hQbjN5Ni8xVndyR3AzL1QvTXFhYVBMdkxZL29NQ25rYkVYN1JnVFhh?=
 =?utf-8?B?a1VLZ3pYWjFBOGxqOTZJeTg5Q2ZuQlVzd2RxVDNDRkxGQk8vT1NlQ3FQQ1BE?=
 =?utf-8?B?S3hCS2xOR3MwZWQ1RXBvelBzdEMycjhjcjlEa2N5aEFGb2VvSnBiRTVJZ0dL?=
 =?utf-8?B?NFpqNlJqTjdoKzkxWkFlU3BtdUs1K1Y1M01jSGhpMXFvTUZiQnVCYnRXRVlS?=
 =?utf-8?B?ait2VUt6QnpINHFZRWdWNTVHNG1tZXZ4SnNQQ0pPVXRBc09YVCtzb1lJMDFJ?=
 =?utf-8?B?N21BbzFwR0pSM2xHTkZYNkxSUW85T0VVSW1peU1DWWQ2YXJKUUZCMk5tUk5z?=
 =?utf-8?B?SXFNTEVaUWRRbWVEYnF5bTJyTkZ6REY4RW1VOUt4NTkzbzNjbGtvczl0MHlZ?=
 =?utf-8?B?Rmp2REE4eHRnQThLVlhBVkl1ejNnY1pROFU1Q0ozeU5XdnVObFBDWXdUSksv?=
 =?utf-8?B?eEpPYzBEV2xTT2RFKzdpTmwwczVzMXZyV0RwWFNvdy8rTCtUSWdZQWg0am5v?=
 =?utf-8?B?WFJqWkdmTHVXT2RkdXNpV1htVDE5LzhOSWFrSjN6dmxiVFhSSklITVJQK0Nq?=
 =?utf-8?B?NXdaZzZYMFRVRUpFR1cwRW13Z1kxYmpVc0ROaHlvblJpZWl6cVhKdHNVOXMr?=
 =?utf-8?B?TkR3cFRWKzhoUFdZRDZOTzdxZk5iMm4wb1lIUnhHN2taZUgrWThWVzFZR2ZM?=
 =?utf-8?B?eitVSjRKNEZjSlBtazc5TE9yUDNPMGUzTnBTUUVmS3o3NlNqa1FhdHZTbktw?=
 =?utf-8?B?dTRlWFlGeVd2WThjajRlbURoTXNDWWxnaXFheTl4NGRWUUMwUFI2Qk5xWG10?=
 =?utf-8?B?amRiNmsyS3oyNE5YL0l4NjFJNCtONXU5RmhtZ0MrdkRMdTdjdlppUUJveTky?=
 =?utf-8?B?SFNpMDExQnRjRTRqeW03TzdpTkZrRHdiZkZMRUl1TVY5ZlpOaWRWcTdqcE40?=
 =?utf-8?B?Qm1pSFQwVkE2a0FwQUszQll3OGhUMC9hbFBoRkVibTJxSkJ2MmRYRnpwMkRL?=
 =?utf-8?B?VEtyMy96Z2ppWjVUQllxY3VWdzRFWHhIYmhsYXlydmVCQk1Vb3JTU0VvTG1Q?=
 =?utf-8?B?ZlZlZW1ETTRkVkRUekNMNFAyVUh3UGJrbkoyRzBybmZQZndvN09vYU9sVDkw?=
 =?utf-8?B?a2R4enN5SkY4N0N2eFQ0K3ZvVlNRMlBramtMczkzMnhKbUdWTEFsNUZVa2pv?=
 =?utf-8?Q?aI1sK5Mr60Wfnka40ITc+PQku?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bdr9TCRy2looWiotFYOOZgUn5pNBPn3QOzJgukzXmS8+Aau+miMiXt+d0WMUvqEVDa90p07AucwjJxedJumrIs/suWIZVzG4GuDEMGCKW7sHcgY9Azoxj/79y/CPYJA/O7eXHQbaIDsK536QN1SLBHuN+UCPdcbI/9B6KBRIH7SB+qR+iwhDay9u+L9py/6jUDYL90RAxElpQT32vIqx9fIxQxXyFK4V077znKkZP2bk8OnEVSNORpdx8hNICHQXFa+o0VbdeKdMxYM0s447cBkhfBHRAdrPX4yPWXomcfIFZCsQtJ9vEjKqwqQckn/IOfqKyaHPpgOZtC3n7x6r7tLoEXYS1ygtAcm0+kYTzbsTYbgfg+xeK/XMzgw/XR6HgXu51EeOF2L40/7YYUtS8VGXFdiGNOBnn+1FLMcDEl9h57FZDwd14fevrjQkfAxaDl+62qwRdyv+aDg6RUGS6lC2v6nm0lvV3DckAHvM2YWfn4jdrV5bakVFSelbLB+SOmHU5QcHK/VQt3RXfKTY9InaszYoDxmpL5dIctNdnPWn+f1ezqSa5M9Ets68BsFnBYTxrxGlRnkHle8gE39XjILJc1t9gO5+uyTV7XRjwWk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d160da50-bf1f-4a87-1094-08dcdbb11a53
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 09:21:27.9150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzaALyH4MYHROpMqNPwFuu++gVDDnPTsQAQ5BSfEYw9xcrtVepDUDe6s9Kd4YmkXwZnWDxp/HCZYY6++18WhJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_05,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409230068
X-Proofpoint-ORIG-GUID: 1qSLtqBRaolJYQItR37fLX4S7XcbXACK
X-Proofpoint-GUID: 1qSLtqBRaolJYQItR37fLX4S7XcbXACK

On 23/09/2024 09:18, Yu Kuai wrote:
>>>
>>> We need a new branch in read_balance() to choose a rdev with full copy.
>>
>> Sure, I do realize that the mirror'ing personalities need more 
>> sophisticated error handling changes (than what I presented).
>>
>> However, in raid1_read_request() we do the read_balance() and then the 
>> bio_split() attempt. So what are you suggesting we do for the 
>> bio_split() error? Is it to retry without the bio_split()?
>>
>> To me bio_split() should not fail. If it does, it is likely ENOMEM or 
>> some other bug being exposed, so I am not sure that retrying with 
>> skipping bio_split() is the right approach (if that is what you are 
>> suggesting).
> 
> bio_split_to_limits() is already called from md_submit_bio(), so here
> bio should only be splitted because of badblocks or resync. We have to
> return error for resync, however, for badblocks, we can still try to
> find a rdev without badblocks so bio_split() is not needed. And we need
> to retry and inform read_balance() to skip rdev with badblocks in this
> case.
> 
> This can only happen if the full copy only exist in slow disks. This
> really is corner case, and this is not related to your new error path by
> atomic write. I don't mind this version for now, just something
> I noticed if bio_spilit() can fail.

Are you saying that some improvement needs to be made to the current 
code for badblocks handling, like initially try to skip bio_split()?

Apart from that, what about the change in raid10_write_request(), w.r.t 
error handling?

There, for an error in bio_split(), I think that we need to do some 
tidy-up if bio_split() fails, i.e. undo increase in rdev->nr_pending 
when looping conf->copies

BTW, feel free to comment in patch 6/6 for that.

Thanks,
John

Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B272367DC;
	Tue, 10 Feb 2026 12:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.149.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770727640; cv=fail; b=KiXqU376kwjchsveN3Jk5o+/XmYaAH9GDzLFBw5RTJ61qVu0tArKZE1F2JHdj6p4wKijzW9RGJHNFyC+ZTjuJgQ5/GzDB6fGn+dEY6jlfPVT1LeGMzsD+QPQguOQYB3xwT2s+LxhhiJPoftmKWRF9nZ575x00zTGX5U3lJL2eog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770727640; c=relaxed/simple;
	bh=ou0enfek//ui83uVX08r5++mnXJobeMg6Xes6HkrJnk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p+RIWwCdlgmItiBZH2XTwh2oXOZ21yXdRAe93T7SNvRtCapE0hxK2fCBiu5CsMNVQkJTxUlnWmqpXebaIfPO8DR6IV+Bli0uXkw+EiaSzXipF9wicRM2/vojwPS+4/URofGq1IbG0J4cJK+hxc502Al2m6v98qG/rWo8ruoa3YA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=g1M13Aci; dkim=pass (1024-bit key) header.d=akamai365.onmicrosoft.com header.i=@akamai365.onmicrosoft.com header.b=c9RQxDQ8; arc=fail smtp.client-ip=67.231.149.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="g1M13Aci";
	dkim=pass (1024-bit key) header.d=akamai365.onmicrosoft.com header.i=@akamai365.onmicrosoft.com header.b="c9RQxDQ8"
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
	by mx0a-00190b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A70ca23754455;
	Tue, 10 Feb 2026 11:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=jan2016.eng;
	 bh=uwBAViopxzGVpCha+iZpfKwVDmIs4AGy8R3fslTrCRQ=; b=g1M13Acij7oD
	PkJsfQQIMwE2oaUGDpkAZtezYwSu+KV9ENNALdg+NqRgI9ACNxMKqDG2zVtAmKvN
	ElXFKfImHmiIkcnWfrAlIafh4ncsSsEwZ4H4ufTVHzI/EKCis/gYnQcjMJOuYlVL
	+SspOjlebOzaUjPBTNsVCax578Vc9XEep2yuGX2xHMh4IWa2cNlsi5shG+dZHP+S
	aMfbMeMgeVvHLq9w0vkwcY01okcxUrAr2oyKUK6yQkiUfWTF1Bz/RSu+iKm/ISkr
	MX2GQfJ8v8x/NS9GUKyEperttPxvVr4n98pGvSV1rgL+vNzG0USpSdWMvqRFjX2h
	tHCbGqC/sQ==
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
	by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 4c5xf17f4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 11:57:24 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
	by prod-mail-ppoint8.akamai.com (8.18.1.2/8.18.1.2) with ESMTP id 61AB75aS014192;
	Tue, 10 Feb 2026 06:57:24 -0500
Received: from email.msg.corp.akamai.com ([172.27.50.221])
	by prod-mail-ppoint8.akamai.com (PPS) with ESMTPS id 4c61m4muvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 06:57:23 -0500
Received: from ustx2ex-dag4mb2.msg.corp.akamai.com (172.27.50.201) by
 ustx2ex-dag5mb4.msg.corp.akamai.com (172.27.50.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Feb 2026 03:57:23 -0800
Received: from ustx2ex-exedge3.msg.corp.akamai.com (172.27.50.214) by
 ustx2ex-dag4mb2.msg.corp.akamai.com (172.27.50.201) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Feb 2026 03:57:23 -0800
Received: from DM5PR08CU004.outbound.protection.outlook.com (72.247.45.132) by
 ustx2ex-exedge3.msg.corp.akamai.com (172.27.50.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 10 Feb 2026 05:57:23 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h3vM6cO6+X/nWU5y4X5gsaDh8AkHZh5ik7+hQAe61kJsYq59ktFSIB7dTPiC7Cj+knC/gre6hriTN6caug+uwQSuODI5HK/weJQqigD7YlvBQTU3UbgOZOu0VolSOz/huWKz1uf813XD3TM3jNmXEg5TS0QHTFHC5EQKwfDWwCAiRjp8dJVKbXIa7onMayfNGCl5BkhDy1g299oS+I3rqF9Bcj37wggKabcgaJJWwlZhNRVIq+4q3CWiM8K72l+0qQN7gu6VBAO4JqM6F/o9IHtVOZtPif4VLRcNxf1fwRSQjywSJDFGxWcYpvuX7j17Z/CzkHQVJ07K0jm3+Te6hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwBAViopxzGVpCha+iZpfKwVDmIs4AGy8R3fslTrCRQ=;
 b=c2ul2GGC/VGNz1zWK/OcsePs2ti9v5LxiNFP17VZoAuuJxtVCMaOcl8gFc8dEebYA7gY7k7dQ54SGX45DZj7sl305Y1J8CGCXHRv0KN2AqrFLhEjXdDzsRAgLA81+EhKbEdFgCeWfZlgNlKbiJl1jg2OZZPEHKLk6kDLVbtu0Vvmjkbfk0uls3fF9ElWq6x/OEcESyq8fFFjDVCaHjqpKnHFdqhM/Qz9/XuqLHvdnpAI6yPhM9zz03lRp/vnA9ZNqHSctjOlPuu/2TTVs4JjQJ4kg1TwPR3EUaijrKJmGdQJJJU6wG6xLCwFV4FTqaPpvbA9O2xZCKcjWmk1W6s2WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=akamai.com; dmarc=pass action=none header.from=akamai.com;
 dkim=pass header.d=akamai.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=akamai365.onmicrosoft.com; s=selector1-akamai365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwBAViopxzGVpCha+iZpfKwVDmIs4AGy8R3fslTrCRQ=;
 b=c9RQxDQ8vMdUCJ+qmW6l3S89Am4RDp9nY5/p572l2tJTkJbObMCfV5efi/xUqHCimkDTUnYmu5ZyV1682vGk2rzY4vFpx+wQtcM9TlKEKPyuwwvV3BLt3JAemlbbOoUFTVW6a1En8hiqG8UIGc3qamrTX04LZqiyZKdB/GRtCVs=
Received: from SJ0PR17MB5087.namprd17.prod.outlook.com (2603:10b6:a03:3ba::5)
 by CH2PR17MB3877.namprd17.prod.outlook.com (2603:10b6:610:5f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 11:57:21 +0000
Received: from SJ0PR17MB5087.namprd17.prod.outlook.com
 ([fe80::ee4:f0aa:4d23:bac1]) by SJ0PR17MB5087.namprd17.prod.outlook.com
 ([fe80::ee4:f0aa:4d23:bac1%4]) with mapi id 15.20.9611.006; Tue, 10 Feb 2026
 11:57:21 +0000
Message-ID: <03af1d50-6afa-4f3c-8186-d864796a68a5@akamai.com>
Date: Tue, 10 Feb 2026 03:56:56 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid10: fix deadlock with check operation and nowait
 requests
To: kernel test robot <lkp@intel.com>, <song@kernel.org>, <yukuai@fnnas.com>,
        <linan122@huawei.com>, <linux-raid@vger.kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, <ncroxon@redhat.com>,
        <stable@vger.kernel.org>
References: <20260210050942.3731656-1-johunt@akamai.com>
 <202602101220.J4BofeDD-lkp@intel.com>
Content-Language: en-US
From: Josh Hunt <johunt@akamai.com>
In-Reply-To: <202602101220.J4BofeDD-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:a03:217::21) To SJ0PR17MB5087.namprd17.prod.outlook.com
 (2603:10b6:a03:3ba::5)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR17MB5087:EE_|CH2PR17MB3877:EE_
X-MS-Office365-Filtering-Correlation-Id: b2e675ee-6021-4e45-7bf1-08de689b8c43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VG5TUWJ0OFRHSWo5VlNCbjlrWFliNkg0TlpJZGplbTJjOXFhRnNiRzdIK0lR?=
 =?utf-8?B?MGtGVnlzL1k4djVKeEpVb1Z1NVY1dmtPU3Bia2RhbzlUdkNMNlZNaGRMMVNj?=
 =?utf-8?B?MFNtM2hBcVhmditqekIzUTU0WW1ZYXRFSXB4RlExT2kwN3VqR2xiMnNHaU5H?=
 =?utf-8?B?NFFKVmdEMzlXUnk4Tmd6Q0l4dE1iYnVFVkNkenkyWVpzMUJ0K3h1Z01qZFpT?=
 =?utf-8?B?WXJwYWFjay9idjVJakxYMVhUV1VoOWpWaEp6RmRQWmlzeUp5T3dwbE5nOVdX?=
 =?utf-8?B?N2hWMVJ0amVJbTFzMHBHQnZwM2ZWc0JpZzdFVEZ3S2NVV3dMUmRER0VCOURx?=
 =?utf-8?B?UUdkMWFlSXhsa1I0N09ydnIwbjJ1bkdPZTB1WXd5N1FwbGp5TGRzMWdBR3Q2?=
 =?utf-8?B?MlV6WS9ZQTRTRG1mQlZPMjFmNy80aytyK3NTZFF4U3YvdlA2cFhGNzJIQ0R2?=
 =?utf-8?B?NWQxMW04TmpMbjh6aVdDNW5yNnpoelowMkpwQlhrenk2dlUxNmhYUi9zRE0z?=
 =?utf-8?B?S0NoK2RuMmR5TVVuTHllQlpPOXV1MndRSmFoQnBGemFkQWdGRmwvc3Vwd0hn?=
 =?utf-8?B?NCt2b3ZjdEE3cGNCYk9kNWxBSnhNYmZPdlBjSTF4cXZKemxuTWZlRG9tby83?=
 =?utf-8?B?WlhXNzk5ZXRQMHp4eE9xZmJ5RktRdlVwQlA5UXZBN1ltQ2NPN25mbkg4aG8x?=
 =?utf-8?B?LzFsZ21sWVFoK29ob09VYkZpZE40Vk54L29sd2lhUStJeG51WmFpM1JBTXAw?=
 =?utf-8?B?ZDMwMVp2K3NmWlViTy9qL1NOd1hJcWJVMHNiTEt0dnUwbjlDNm5Qem1KTVVS?=
 =?utf-8?B?U0E4UHo5QUQ3MWxLUGhicmRmMllXSDVrMExETkw0TGRXS3JsVWxFaUcvWW9U?=
 =?utf-8?B?U2E2dUxZbEs3U2FhZW9YanhWd0VQb1MvRVhhbjliaW9QMzNtYkdHUkJXRXRl?=
 =?utf-8?B?cHRLd1JsOWxNSitCYkpTRlpwVVpjalcxNlNIeCsyaEVGZmRPYUZoWGdWeEZY?=
 =?utf-8?B?UXpmd0dsOVkwZHFHRjE1OTVNZzZvaERSNDBIZkNOMUhzeWtoRWdNR2dkbXNq?=
 =?utf-8?B?bzZwQ3RGcVd3RDRjbHI2MGgrZHFMRjY5YUN5ZmlCTU9oSGRucmhIcnFSRkFJ?=
 =?utf-8?B?MVNhWGt6Rml1ckorLzM4ZDVQQk5WM2pzZjN6MEVJM3NGMzkxYnltcXIrRnF0?=
 =?utf-8?B?ZG9tcE5Cc3JlSVNvSGpnNFgyRk5kZ0doUGlkdWZCZUJzRExSNG8rdEJhTWhs?=
 =?utf-8?B?azk1QmFkSXVtYXF0aTB2VFlEZlhEQWNNWVk4WHUvVFVEVmNseHR5N1BKRFhS?=
 =?utf-8?B?M01ZanlCa0Q2dDhjLytTNHFiYjFJS0xFTHRuSS9LZ3BYZXpwNUxLaGNtV1ZN?=
 =?utf-8?B?Q005cVp5amJMRDNQTGFTV3E1MHNjYXFQRnN3NjBjbTJaNGJuWWExOTdHWUM3?=
 =?utf-8?B?c0hFZE9IUVlVWXdTTk56aUhtRFpSYXRTeTg4eHZGQzRCbXF1ZFA3WjV4MVRo?=
 =?utf-8?B?d2JQM25wcnFsUFphN2ladWZpbmsra01yMSs1SjEwT0VoZ09VK2I0MHdnemY5?=
 =?utf-8?B?YU44SURWMU11ZFpLVVQxRCtOamgydk5ldGJBNm1MR1IzV3hvMlhYQ2FyRlpO?=
 =?utf-8?B?U0lCaXBtQXlJOEtYbkdHWnFyM1FGYzkrYUl5UmFVSjZjS3ROaDg3cDJzdEdo?=
 =?utf-8?B?T1pwU1VxaXp0REtmSFlhZW5tZUVQb1ZsRUJtZUExQ3BTNFBCTTcrdnc4dVJk?=
 =?utf-8?B?QWlxdXN3R2tyOE1EQ0MvVFowakZJeWtSckdKT0krWmd6V3hCaVZLaGNpZndw?=
 =?utf-8?B?YzRSV29TTTNhdjZvUU1tWUUrOU02ZzVEc3NLdmsvdldzZXBVNWlDL3UwRFlw?=
 =?utf-8?B?SC82c2gvMWZrRWhSdjczcDNic1VycjBRbDJyL0JSdS9VbVFYNDh6WFl3TXBQ?=
 =?utf-8?B?eXhhZUpoNVlBSFlpNSthV09JYTZrZ0NTb3crUTBCVW1pWlVmYy8rMVp2a1Zt?=
 =?utf-8?B?N1VkUFlVVVR6M0xaZkszRG1kVFF4cU1DM1d0L25vUXl5MWFnODFIcVpuKzgz?=
 =?utf-8?Q?gBh6tv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR17MB5087.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFFNM1A3c3BZeTAraFUvSklQcUU4WDlkekJFcitoZWxXRVJiVDBLYVIvL2hY?=
 =?utf-8?B?MUpDZXNmSGc3TE13WmlqdDdQRG1yOXFtdHpVUzF0dDBlanIvaDEvTGZPYmxq?=
 =?utf-8?B?b1BCdUh1OTRDZWpuM01OSlhZbXc5MXVXRjd1SjQrT3MyTzF1bnR0QTBsa1Rr?=
 =?utf-8?B?MnhSaWZjL1J2M2JYVjBzUSswMXpTajhQb3pMaDNxL3BBcy8wazJtbUZzQ1hp?=
 =?utf-8?B?N21ydnJBU1lOdlErVHd4ZWZ4aENxMWJlSWk3eU1XY1RDMnpNYmtLV3ZxeW5U?=
 =?utf-8?B?RmNiVkhVeUtMSFM4NHJEalJ6RU9jYVpYOEUyWWNFTlhva2VlVFJoY1FQMGVx?=
 =?utf-8?B?MWVQYWVCSWRnZlJ1ck4zVTZvc2hCeXN5Tjk3eXFQaTZrTDdXWkUzMDRnSE5L?=
 =?utf-8?B?SmVtR3M2MytDYy9WWXlRL1VXdTNrOXkwV1NzRlBkWEVESVJ2Z3NaRUE2RDdl?=
 =?utf-8?B?bGkxZEEvL1ZlaUV2clNxaEYzcHBmTkpGRCt0aTcwc1R3V1pLQ29xR1dHZjRI?=
 =?utf-8?B?UzRja09nM1IwSlRwZ3p5ZWV2MjZFRDhDZHNBeGhQUDlEYi9mWUtQNGNYbCtP?=
 =?utf-8?B?UTFIamZzaytvek1GVEsxNEozZ0liY2FUMTFzZHA4VlQzSEtpd3V2Z2t0QzYw?=
 =?utf-8?B?OWNCMHBsS052MDd0TlN2M3pvMlVPN2xPamYvckt4SS9NZ0RqRXNhS0VnS056?=
 =?utf-8?B?Y2pWUkNoM2x6QVpidVZmWkdZZjB6SVd0YTZOVUtKSEY1K1ZqRmJna0poWm9U?=
 =?utf-8?B?SDNPcUZSNDl2VnJGd1Z5SlhwRlVrZk5vZVJjdTViTmZEU1RnQ0F6UnBOeVh4?=
 =?utf-8?B?ckJBdjlJSExKa2lYQnJpOTNDaTFHUVEraEwxcnNnVElRS1phY3NvYU5nRzhW?=
 =?utf-8?B?NmRPN2lwWlpSKzZDWTJReGU2M2lOOGZZMTJLL0w5S2RlMTRjRFlIcThnU1Rj?=
 =?utf-8?B?K3VLMHJGYzk3QStlNUVucHE5aGpEOGFwc0lxTG1xY2RNY1JySmphV0R2VUhY?=
 =?utf-8?B?ZUlLSjlWUGQ1YkF2N3pXZlhrVm1RUjU5N3lpOEdnNzZLNGtYaURsU0hiaTNK?=
 =?utf-8?B?K0tCNWpPaDRLaGxKNzdNQXpmNml3L0MrUElvSTA2ZzZXZE5hdHRlcG9qVmZt?=
 =?utf-8?B?Y0dWenNJVSsyUWxJajI1SXNvQlRESnp2ZFJKU2IvVmpIZ3RVL0JVK21JZGlY?=
 =?utf-8?B?VFVyeENSTWR1OUtLWUo0TzJjUTlTTTRQdFlhbGo1dHJEb0hYMU9vd0pkeGQ5?=
 =?utf-8?B?Q2NLV2xrM0hMQzkzcUdYSDJyalRoTm1DL1JiN0ZWQnZ0Y2poQjlvcTl5NkZk?=
 =?utf-8?B?YVBTYU9RN1krSGQyQWZOdUs1cUhac1NIMnNwbjFhVzVOK0NhOEduMWxIZCtC?=
 =?utf-8?B?TVZab1dDM1FEUEwwaXZ2cG4wRE84NjNBSnY3QTNvMWg1YmNuNXhUWllKTkJW?=
 =?utf-8?B?RDNzQzNuVERleW9uRjhBRm1vbDZjTVFCeFRudW42RDVlUHY0KzVLa2xQK1g4?=
 =?utf-8?B?bW9XaVRLT2dsYVlvSTBKd0FXVVh0cFJwUHdjNGJ0a3hvbFdaaldDd294ZUQw?=
 =?utf-8?B?TmV4bnpWVE8yVitnd1ZvVE43dEhlV2cxaGpkTkdPNlBtNUlLQ2N1SVN4aHM4?=
 =?utf-8?B?N1dZUjNGZzZ4WGZZUUdOazRHTktRUDl0U2FIenI4OGxXUkVodUZGOHJsQjRo?=
 =?utf-8?B?a3h4N3l5dEtmSXM4dUNzcXY5VFB4MlpRbjZPVjd4clB0amtrdTh0SG5KQ3BZ?=
 =?utf-8?B?T1dTNlZkbHpMUTFIV2NzMmorRm84dWxHOHVDMTJja2ZPWmNjVHdoK3c5UlZi?=
 =?utf-8?B?TFppSHc2SXBELzhMbldudFZZSm82RGF2aE1QbTNjY3hONlZFcVdJT29TeHlC?=
 =?utf-8?B?QWFqTno1M2kxT2xmQzVJN0c5YllldXI2TEZpVExIVlJNb2Jxd1BuS2lwcDZq?=
 =?utf-8?B?dVY2cG94WFJlRjd1T04yc25HbXpkOWV6dmNrbzEvaUhHUlYySmR4SXk4Z2hP?=
 =?utf-8?B?ME1lKy9RcmJWQnpGQXNUd3J6citmU0x4cGFMNmFnS2JwOGpIUCtLQjIwVzhj?=
 =?utf-8?B?SjlGa0xSQ0hlUXkyUFRIM0xSSTg2d04xWFRiQVlhZ2l1RHcyVHg5TGVaS1Bl?=
 =?utf-8?B?TERQZnhRZzRqblN4S1RuS1R3am13azhkdHhXTlhSUkEydmVXMkRmaXBBN0xx?=
 =?utf-8?B?MXVucmlhUTJ0UnZOQ0lBeVdJV2ZtVitNbHhmVndQTEdCWTFsNWN2VjhXYmF5?=
 =?utf-8?B?aGpYV1hEQ1ZBLzhaOHZEY1lCVWszelpEdHAzT2p3L1lYMkFuNUJzcjJ3MHZa?=
 =?utf-8?B?SnBEa0xrMU1PT1BEMGJIUTFXb05jbXFlNU8xRjVSZTRjRWJWOWVKUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e675ee-6021-4e45-7bf1-08de689b8c43
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR17MB5087.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 11:57:21.7123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 514876bd-5965-4b40-b0c8-e336cf72c743
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GPh3v86mfaHbOzXC/zCdghzXPUfjawOaVPl20b4pWSNA5fb2MhhhuCJMolR7Dx6MuGARSNC+LGCC/UUFY/RlBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR17MB3877
X-OriginatorOrg: akamai.com
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100099
X-Authority-Analysis: v=2.4 cv=ePweTXp1 c=1 sm=1 tr=0 ts=698b1d24 cx=c_pps
 a=YfDTZII5gR69fLX6qI1EXA==:117 a=YfDTZII5gR69fLX6qI1EXA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=g1y_e2JewP0A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=anyJmfQTAAAA:8
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=X7Ea-ya5AAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=kiWGMK5hJOp9RmUwFOwA:9 a=QEXdDO2ut3YA:10
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEwMCBTYWx0ZWRfX14dkaTH4ESaz
 oVqbqgf7QDFQT038WYrRcvKSMCHYa73eJjL8hBxnTswsnxel2mWnsJ7ZIwbSsbnQpBS4BpSGkpQ
 uL0tWgu9I149uVyz3CjHY+ggK8pa2GJ9Qmc4xtQadYgIoUiNtsZQHvWuMdm+xn3wU363MseF1YV
 9+LZeIPdBfazKb9/OEkSSwi+4fJceFCXiE8j5TIe1SmzNoK0AzUYwEGMqkd7ySNIpV2lZz0H0Tr
 mtsittMH4E90jBF7ymO2z0JWwA9Dgj+PSmSZfuTvxp1UtAuIM0QPH6a2opDcg6WqdsRakgFx1X1
 0HExX0mLQr0yprVqEz9gHugGPJJztTlFWijbNBUDcAxAUi4Gbe2cbZaHIYySyNaL63bIHnbSv/1
 Mt3kYXNE1edrYu5LZ5F0FcLpnRuioXD7XjDoMYp78TN75S9baQ/L2ReHCNcc5p7aXWEXmPCuYJL
 8gzDhrm7VdM4tqw/sRA==
X-Proofpoint-GUID: Sfk_Y8M0SFNSpAX0MapHyo68gV-_4R4r
X-Proofpoint-ORIG-GUID: Sfk_Y8M0SFNSpAX0MapHyo68gV-_4R4r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 bulkscore=0
 phishscore=0 priorityscore=1501 clxscore=1011 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100100

On 2/10/26 3:14 AM, kernel test robot wrote:
> !-------------------------------------------------------------------|
>    This Message Is From an External Sender
>    This message came from outside your organization.
> |-------------------------------------------------------------------!
> 
> Hi Josh,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v6.19 next-20260209]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://urldefense.com/v3/__https://git-scm.com/docs/git-format-patch*_base_tree_information__;Iw!!GjvTz_vk!QT9JklLw7YgSInuzDS_0EDSnJkZTTG057ef2CiWO2UwIN0aUk9RGNuVtQ6XCy8sTbfadURM$ ]
> 
> url:    https://urldefense.com/v3/__https://github.com/intel-lab-lkp/linux/commits/Josh-Hunt/md-raid10-fix-deadlock-with-check-operation-and-nowait-requests/20260210-135305__;!!GjvTz_vk!QT9JklLw7YgSInuzDS_0EDSnJkZTTG057ef2CiWO2UwIN0aUk9RGNuVtQ6XCy8sTilUfWlw$
> base:   linus/master
> patch link:    https://urldefense.com/v3/__https://lore.kernel.org/r/20260210050942.3731656-1-johunt*40akamai.com__;JQ!!GjvTz_vk!QT9JklLw7YgSInuzDS_0EDSnJkZTTG057ef2CiWO2UwIN0aUk9RGNuVtQ6XCy8sT0QqCm3Y$
> patch subject: [PATCH] md/raid10: fix deadlock with check operation and nowait requests
> config: x86_64-rhel-9.4 (https://urldefense.com/v3/__https://download.01.org/0day-ci/archive/20260210/202602101220.J4BofeDD-lkp@intel.com/config__;!!GjvTz_vk!QT9JklLw7YgSInuzDS_0EDSnJkZTTG057ef2CiWO2UwIN0aUk9RGNuVtQ6XCy8sTZp6wg4c$ )
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://urldefense.com/v3/__https://download.01.org/0day-ci/archive/20260210/202602101220.J4BofeDD-lkp@intel.com/reproduce__;!!GjvTz_vk!QT9JklLw7YgSInuzDS_0EDSnJkZTTG057ef2CiWO2UwIN0aUk9RGNuVtQ6XCy8sTFU3cM60$ )
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://urldefense.com/v3/__https://lore.kernel.org/oe-kbuild-all/202602101220.J4BofeDD-lkp@intel.com/__;!!GjvTz_vk!QT9JklLw7YgSInuzDS_0EDSnJkZTTG057ef2CiWO2UwIN0aUk9RGNuVtQ6XCy8sTUPVdYDI$
> 
> All errors (new ones prefixed by >>):
> 
>     drivers/md/raid10.c: In function 'raid10_read_request':
>>> drivers/md/raid10.c:1257:9: error: too few arguments to function 'raid_end_bio_io'
>      1257 |         raid_end_bio_io(r10_bio);
>           |         ^~~~~~~~~~~~~~~
>     drivers/md/raid10.c:321:13: note: declared here
>       321 | static void raid_end_bio_io(struct r10bio *r10_bio, bool adjust_pending)
>           |             ^~~~~~~~~~~~~~~
>     drivers/md/raid10.c: In function 'raid10_write_request':
>     drivers/md/raid10.c:1540:9: error: too few arguments to function 'raid_end_bio_io'
>      1540 |         raid_end_bio_io(r10_bio);
>           |         ^~~~~~~~~~~~~~~
>     drivers/md/raid10.c:321:13: note: declared here
>       321 | static void raid_end_bio_io(struct r10bio *r10_bio, bool adjust_pending)
>           |             ^~~~~~~~~~~~~~~
> 
> 
> vim +/raid_end_bio_io +1257 drivers/md/raid10.c
> 
> caea3c47ad5152 Guoqing Jiang     2018-12-07  1161
> bb5f1ed70bc3bb Robert LeBlanc    2016-12-05  1162  static void raid10_read_request(struct mddev *mddev, struct bio *bio,
> 820455238366a7 Yu Kuai           2023-06-22  1163  				struct r10bio *r10_bio, bool io_accounting)
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1164  {
> e879a8793f915a NeilBrown         2011-10-11  1165  	struct r10conf *conf = mddev->private;
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1166  	struct bio *read_bio;
> d4432c23be957f NeilBrown         2011-07-28  1167  	int max_sectors;
> bb5f1ed70bc3bb Robert LeBlanc    2016-12-05  1168  	struct md_rdev *rdev;
> 545250f2480911 NeilBrown         2017-04-05  1169  	char b[BDEVNAME_SIZE];
> 545250f2480911 NeilBrown         2017-04-05  1170  	int slot = r10_bio->read_slot;
> 545250f2480911 NeilBrown         2017-04-05  1171  	struct md_rdev *err_rdev = NULL;
> 545250f2480911 NeilBrown         2017-04-05  1172  	gfp_t gfp = GFP_NOIO;
> 9b622e2bbcf049 Tomasz Majchrzak  2016-07-28  1173
> 93decc563637c4 Kevin Vigor       2020-11-06  1174  	if (slot >= 0 && r10_bio->devs[slot].rdev) {
> 545250f2480911 NeilBrown         2017-04-05  1175  		/*
> 545250f2480911 NeilBrown         2017-04-05  1176  		 * This is an error retry, but we cannot
> 545250f2480911 NeilBrown         2017-04-05  1177  		 * safely dereference the rdev in the r10_bio,
> 545250f2480911 NeilBrown         2017-04-05  1178  		 * we must use the one in conf.
> 545250f2480911 NeilBrown         2017-04-05  1179  		 * If it has already been disconnected (unlikely)
> 545250f2480911 NeilBrown         2017-04-05  1180  		 * we lose the device name in error messages.
> 545250f2480911 NeilBrown         2017-04-05  1181  		 */
> 545250f2480911 NeilBrown         2017-04-05  1182  		int disk;
> 545250f2480911 NeilBrown         2017-04-05  1183  		/*
> 545250f2480911 NeilBrown         2017-04-05  1184  		 * As we are blocking raid10, it is a little safer to
> 545250f2480911 NeilBrown         2017-04-05  1185  		 * use __GFP_HIGH.
> 545250f2480911 NeilBrown         2017-04-05  1186  		 */
> 545250f2480911 NeilBrown         2017-04-05  1187  		gfp = GFP_NOIO | __GFP_HIGH;
> 545250f2480911 NeilBrown         2017-04-05  1188
> 545250f2480911 NeilBrown         2017-04-05  1189  		disk = r10_bio->devs[slot].devnum;
> a448af25becf4b Yu Kuai           2023-11-25  1190  		err_rdev = conf->mirrors[disk].rdev;
> 545250f2480911 NeilBrown         2017-04-05  1191  		if (err_rdev)
> 900d156bac2bc4 Christoph Hellwig 2022-07-13  1192  			snprintf(b, sizeof(b), "%pg", err_rdev->bdev);
> 545250f2480911 NeilBrown         2017-04-05  1193  		else {
> 545250f2480911 NeilBrown         2017-04-05  1194  			strcpy(b, "???");
> 545250f2480911 NeilBrown         2017-04-05  1195  			/* This never gets dereferenced */
> 545250f2480911 NeilBrown         2017-04-05  1196  			err_rdev = r10_bio->devs[slot].rdev;
> 545250f2480911 NeilBrown         2017-04-05  1197  		}
> 545250f2480911 NeilBrown         2017-04-05  1198  	}
> 856e08e23762df NeilBrown         2011-07-28  1199
> 43806c3d5b9bb7 Nigel Croxon      2025-07-03  1200  	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
> 4e9814d1943b0e Josh Hunt         2026-02-10  1201  		raid_end_bio_io(r10_bio, false);
> c9aa889b035fca Vishal Verma      2021-12-21  1202  		return;
> 43806c3d5b9bb7 Nigel Croxon      2025-07-03  1203  	}
> 43806c3d5b9bb7 Nigel Croxon      2025-07-03  1204
> 96c3fd1f380237 NeilBrown         2011-12-23  1205  	rdev = read_balance(conf, r10_bio, &max_sectors);
> 96c3fd1f380237 NeilBrown         2011-12-23  1206  	if (!rdev) {
> 545250f2480911 NeilBrown         2017-04-05  1207  		if (err_rdev) {
> 545250f2480911 NeilBrown         2017-04-05  1208  			pr_crit_ratelimited("md/raid10:%s: %s: unrecoverable I/O read error for block %llu\n",
> 545250f2480911 NeilBrown         2017-04-05  1209  					    mdname(mddev), b,
> 545250f2480911 NeilBrown         2017-04-05  1210  					    (unsigned long long)r10_bio->sector);
> 545250f2480911 NeilBrown         2017-04-05  1211  		}
> 4e9814d1943b0e Josh Hunt         2026-02-10  1212  		raid_end_bio_io(r10_bio, true);
> 5a7bbad27a4103 Christoph Hellwig 2011-09-12  1213  		return;
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1214  	}
> 545250f2480911 NeilBrown         2017-04-05  1215  	if (err_rdev)
> 913cce5a1e588e Christoph Hellwig 2022-05-12  1216  		pr_err_ratelimited("md/raid10:%s: %pg: redirecting sector %llu to another mirror\n",
> 545250f2480911 NeilBrown         2017-04-05  1217  				   mdname(mddev),
> 913cce5a1e588e Christoph Hellwig 2022-05-12  1218  				   rdev->bdev,
> 545250f2480911 NeilBrown         2017-04-05  1219  				   (unsigned long long)r10_bio->sector);
> fc9977dd069e4f NeilBrown         2017-04-05  1220  	if (max_sectors < bio_sectors(bio)) {
> e820d55cb99dd9 Guoqing Jiang     2018-12-19  1221  		allow_barrier(conf);
> 6fc07785d9b892 Yu Kuai           2025-09-10  1222  		bio = bio_submit_split_bioset(bio, max_sectors,
> 6fc07785d9b892 Yu Kuai           2025-09-10  1223  					      &conf->bio_split);
> c9aa889b035fca Vishal Verma      2021-12-21  1224  		wait_barrier(conf, false);
> 6fc07785d9b892 Yu Kuai           2025-09-10  1225  		if (!bio) {
> 6fc07785d9b892 Yu Kuai           2025-09-10  1226  			set_bit(R10BIO_Returned, &r10_bio->state);
> 4cf58d95290973 John Garry        2024-11-11  1227  			goto err_handle;
> 4cf58d95290973 John Garry        2024-11-11  1228  		}
> 22f166218f7313 Yu Kuai           2025-09-10  1229
> fc9977dd069e4f NeilBrown         2017-04-05  1230  		r10_bio->master_bio = bio;
> fc9977dd069e4f NeilBrown         2017-04-05  1231  		r10_bio->sectors = max_sectors;
> fc9977dd069e4f NeilBrown         2017-04-05  1232  	}
> 96c3fd1f380237 NeilBrown         2011-12-23  1233  	slot = r10_bio->read_slot;
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1234
> 820455238366a7 Yu Kuai           2023-06-22  1235  	if (io_accounting) {
> 820455238366a7 Yu Kuai           2023-06-22  1236  		md_account_bio(mddev, &bio);
> 820455238366a7 Yu Kuai           2023-06-22  1237  		r10_bio->master_bio = bio;
> 820455238366a7 Yu Kuai           2023-06-22  1238  	}
> abfc426d1b2fb2 Christoph Hellwig 2022-02-02  1239  	read_bio = bio_alloc_clone(rdev->bdev, bio, gfp, &mddev->bio_set);
> 5fa31c49928139 Zheng Qixing      2025-07-02  1240  	read_bio->bi_opf &= ~REQ_NOWAIT;
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1241
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1242  	r10_bio->devs[slot].bio = read_bio;
> abbf098e6e1e23 NeilBrown         2011-12-23  1243  	r10_bio->devs[slot].rdev = rdev;
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1244
> 4f024f3797c43c Kent Overstreet   2013-10-11  1245  	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
> f8c9e74ff0832f NeilBrown         2012-05-21  1246  		choose_data_offset(r10_bio, rdev);
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1247  	read_bio->bi_end_io = raid10_end_read_request;
> 8d3ca83dcf9ca3 NeilBrown         2016-11-18  1248  	if (test_bit(FailFast, &rdev->flags) &&
> 8d3ca83dcf9ca3 NeilBrown         2016-11-18  1249  	    test_bit(R10BIO_FailFast, &r10_bio->state))
> 8d3ca83dcf9ca3 NeilBrown         2016-11-18  1250  	        read_bio->bi_opf |= MD_FAILFAST;
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1251  	read_bio->bi_private = r10_bio;
> c396b90e502691 Christoph Hellwig 2024-03-03  1252  	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
> ed00aabd5eb9fb Christoph Hellwig 2020-07-01  1253  	submit_bio_noacct(read_bio);
> 5a7bbad27a4103 Christoph Hellwig 2011-09-12  1254  	return;
> 4cf58d95290973 John Garry        2024-11-11  1255  err_handle:
> 4cf58d95290973 John Garry        2024-11-11  1256  	atomic_dec(&rdev->nr_pending);
> 4cf58d95290973 John Garry        2024-11-11 @1257  	raid_end_bio_io(r10_bio);
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1258  }
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  1259
> 

Apologies. I cherry-picked this from my 6.12.y branch which is where we 
hit the issue, but looks like I forgot to build test it. Will send a v2.

Josh

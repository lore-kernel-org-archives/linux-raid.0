Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C97324DCE2;
	Tue,  3 Mar 2026 01:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.157.127
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501654; cv=fail; b=OwIdoreZiZd/KiajGNJtvdafq8Fi69yowJomO/M4/fzOeTBsP8aAqIE2ef7bi2964sv8NFyw6si1BjkxIBrueXlpbT6LiMak+vNhE58KlUF8y/s1ur0vTFrTUm7ODs3eCamNZ4dfJT1OI6SK38CvcKY7r5gACWJQE7Va77cuDq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501654; c=relaxed/simple;
	bh=uzgMCO+UTqBC1I3bbZGwZl7z7PKeuRAELeWlZSJhpnc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p+7a3o+OCzm6Cu0rmS1gHw0EK1la5KOlIbpfAMY7rO23y6uN+bg2b0F27FDzgsmOgh4Icd7sM1v3aZjprWRzFYrTIl7Bxc1ABK7+Xy34wm9U7YdL1TlI+8EW9kt6Mqjh+QemGRSQ+XFx3mvDIqo0mMtGxoq7f8QStuDDFe14TDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=fail smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=Lc57O5Rw; arc=fail smtp.client-ip=67.231.157.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="Lc57O5Rw"
Received: from pps.filterd (m0409411.ppops.net [127.0.0.1])
	by m0409411.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 622Nt1kt2471623;
	Tue, 3 Mar 2026 00:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=jan2016.eng;
	 bh=dNjAl7OE2dibMVEE0noFIrSXTpg0ocJEF4jc8+A5vHE=; b=Lc57O5Rwg09C
	XtXMySar2bfj9ZCD1KGw2Xbd57CYQmo7H+qeVZd8vgFE8uuhntPbeeq7+yVWzOjh
	naz01dYALrKKMOFprdDAyJSqer/+KPM/4kZgMKbt2QT148nZS7mMsZC/3T3PNMTB
	J8BWQPDrXdA1c+9mfPIgM0Gd6Gpnvt8mkJv6tWeCuJHhKqjfwNCpwgA07h/YJO+J
	E9/0ZDvfz0e0n4wg8W+IRzeWwF9b9ZdoYuNJmPfzOkNjLxF2caj8nkQQPoysOtNw
	NrBn9+/PwZr9VjKRnkRrTTtd8kJDgp6dJdZNbS92cWQC3zPcQWwiA+M8K/D9Z+Kn
	wWzeN1yO3Q==
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19])
	by m0409411.ppops.net-00190b01. (PPS) with ESMTPS id 4cmak531m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 00:55:19 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
	by prod-mail-ppoint2.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 6230nlCG027763;
	Mon, 2 Mar 2026 19:55:18 -0500
Received: from email.msg.corp.akamai.com ([172.27.91.41])
	by prod-mail-ppoint2.akamai.com (PPS) with ESMTPS id 4cky6a247w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 19:55:18 -0500 (EST)
Received: from usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) by
 usma1ex-dag5mb2.msg.corp.akamai.com (172.27.91.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 2 Mar 2026 16:55:18 -0800
Received: from usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) by
 usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 2 Mar 2026 19:55:17 -0500
Received: from BL2PR08CU001.outbound.protection.outlook.com (184.51.33.212) by
 usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 2 Mar 2026 19:55:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wURbRapGZlntk0iwTqC3fYecdueZJgCNN3q/Zd2juQu1R+tNOQ2biBYoGWMa5CHZ0vbSfnQVZeOnf+2wkshGz55K9c2SU2uI/CHeO3MIMotVYsBQFi0yM8nLVBwYJ2TUU+ZSSVx8YwXgAnrx9gGk2lvmSxL3vteGjodhtzjKcwAeJR+eC8lJCZXAp3ZfNyl58/rJVnvh6Fe+mC2/pZHiBX2EKArM2HDvjb7iAnsmwwSJXZYhZPDZXJkNBS13pHLgbalFCeM5UnyKCvqA9o2U0QRlvmuQHSIo9THzTrE4nt3BAdT+SposLXeoxohnR85iV6M8+aZ5cC0NJ4D89Ut8tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNjAl7OE2dibMVEE0noFIrSXTpg0ocJEF4jc8+A5vHE=;
 b=GCU8hAOCG38+CgX/v1mjddMx58TJ6SLwqOS/bVVN1AEKev9dlMaqceoZnDyU6UmR6kyTG2PFD7WL46myn7FQpQLxQAH2bBpdnz2mWbHEPyCIaeABTIMcFM4NH4DBfUDvAq5e4TxSTcz9zEWv0QEI23Xyqq3IzMkMnKsSneTTp8YnDushw9VkK00t3cfcn955gYsb2SGpP/AWgjUSFS0wcn/IpUYaCrslrTZQ3D8NDCzMOkSjNUCQJMSuAaDM6S09CJiG2H1q+MC4ZCPBxgqjkQk+wUmJG+B4llWLm1HhvqwLsCE5UzSTdLvae6kTu+mb66SZXSjst6YGQAMLyrNkPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=akamai.com; dmarc=pass action=none header.from=akamai.com;
 dkim=pass header.d=akamai.com; arc=none
Received: from SJ0PR17MB5087.namprd17.prod.outlook.com (2603:10b6:a03:3ba::5)
 by MW4PR17MB4748.namprd17.prod.outlook.com (2603:10b6:303:109::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Tue, 3 Mar
 2026 00:55:16 +0000
Received: from SJ0PR17MB5087.namprd17.prod.outlook.com
 ([fe80::ee4:f0aa:4d23:bac1]) by SJ0PR17MB5087.namprd17.prod.outlook.com
 ([fe80::ee4:f0aa:4d23:bac1%4]) with mapi id 15.20.9654.015; Tue, 3 Mar 2026
 00:55:16 +0000
Message-ID: <5c3ff1de-29d5-4b08-b036-06a4e2098752@akamai.com>
Date: Mon, 2 Mar 2026 16:54:50 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid10: fix deadlock with check operation and
 nowait requests
To: <yukuai@fnnas.com>, <song@kernel.org>, <linan122@huawei.com>,
        <linux-raid@vger.kernel.org>
CC: <ncroxon@redhat.com>, <stable@vger.kernel.org>
References: <20260210165126.3963677-1-johunt@akamai.com>
 <f382704c-8a3a-4c94-8fc0-46938e720894@fnnas.com>
Content-Language: en-US
From: Josh Hunt <johunt@akamai.com>
In-Reply-To: <f382704c-8a3a-4c94-8fc0-46938e720894@fnnas.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0033.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::46) To SJ0PR17MB5087.namprd17.prod.outlook.com
 (2603:10b6:a03:3ba::5)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR17MB5087:EE_|MW4PR17MB4748:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a514334-0a4a-4bf2-bf56-08de78bf888f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: E6O/E3gMR9YKPyL6ZCQQOT7maYhNYMfPiBvx86Fwbz1GwWz6nZSMI1NepaP10xutF60cSfNzGN6zrgh+YKjkUWDVw52eCU8f8SutIhMqw3RTbcbCV5Dwsc7Xmhz6ZsNfs00LhiP0F8yaFA8JmTyboekTuMdkB1uPiUJMG8X/+WNdGuDTKDoTLkwssS/SROu1dP2xEViBE2unxjQqibCw5AIF8abh2Y7UEfMs6OEMKP9OUYpFnLRNsgGRSu3P7pyZEUuG9R2if0e76sBqkvoJoDnIuKV7TzIdZQK/inRMq7AB77D+uIrqFTlvzMOwL8oIg5th0j9BURce8IkaAWOyOhkuHn5N0mG9JLCovRv5jGP4ifNDilbMn6B4Z2PgwSZNFJb/JbJ+7jo8NJOK1pRL++r9VF9BF39sWRUEN2I6BG48iNjzG+LyDJyNca+LDhruV/NOp213fMUuFuFONCwrkYq8oEr0yAQZq5L5Gygk2tigWe0yYC0Wrws5dW1zUSnh5z36KI+OX+TzksHwyzbxyi+8GaI0ijoM0JxptVN1EJcG8QGrWPCriBitZSmmmSdBZwXcTDR3s/sHss2CtODtvgdBqNfYtySnWz0CY80VpIaTq9wi0PO14s/VLN3KQB687bm0LTX3+fVaUGMHJFFSR+sNYE9IdKzDbakflqxeOuLDkskC9B6ir3/86bAcHAdNdxIpjPk6bLbaGMntJdzWBk81aX5GDeu8HsaufJnksbQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR17MB5087.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUZndGVlUGR5dnBnYUZFK01jR0lTRVFoZ0p6WU8wWkRPNTZGMHRIRVZSaWFH?=
 =?utf-8?B?ZDV5NlZJbG5ncDNsbjJSeDhVbUU4bzBDTE9YQzl0VjZCY1FZVDVkcmhvTm14?=
 =?utf-8?B?N3dRV2wxRTBacVE3SVI3WjRaYmx0by81YXlnOCtvZUhRZ2YvQTRUYXlmNThF?=
 =?utf-8?B?RXlQTGkxZzFqY3kzOGhSTGRUZEpYdTBHcHVkM0xpM1JSdk5Ta28xSVVienpR?=
 =?utf-8?B?YjU2KzdKMERWeHRhWTUwMWRqeFl4WWRjTFJzUXlLQ1hnMmxPWklDN1A1N0V5?=
 =?utf-8?B?VWlFUU02Y0JjNzFPOEgrZjJFWnNXcVVrVWZxVW54eGVpN3pLNzdQakxucCsv?=
 =?utf-8?B?a0VlaGRQME1UYWY4OG02TXYwZ2pwZHV1Q3JGdkFEODlKNkh0Q3p6ejJsd04r?=
 =?utf-8?B?MXZ5NGZKT3l4dHk2TUJnWlNRSFgzK3p5QkpvTWtOMDVHdHozdE5EQ2d1elE3?=
 =?utf-8?B?cU5HMTExWDhsdWsvZi9QNkgvdUFNSDlCQ29NNFVEelJUa3Jmb3lyb1lHQk9J?=
 =?utf-8?B?V01mNlQxMGhpOFpOK3hvMnVLQ2MwelA4YnczN05LNDhJK3ZodVZtTFNVdXJ0?=
 =?utf-8?B?bFhkMnEvTTM5OWR3WjhLMnowMk9FZE9CdzdjVkQ2QVAwUk9lcDdoY1pxM2ti?=
 =?utf-8?B?RHhpY3ZTTXUzSHQ3L0FiZXNtVXU0ZzRRcWZlWU5uUGVHTjhwakl5ekx6Mldk?=
 =?utf-8?B?ZkNzcjcwaGFnWTh6aC90QzlQM1NiSDh4Um9PYWR1NG1JNWl3eEg1QmYwemhW?=
 =?utf-8?B?aHhJc3A5ZDJObnBVck9Ta0x6emNIc3BnUXhxVld4L1NTd0Y3ZDB1akE5Q1Ba?=
 =?utf-8?B?UGJvYm9CMTVWQnBvZk1mMThLS1NrekhTamVaNkJqSzFRR1A3dzZHQzhrQmk1?=
 =?utf-8?B?RkZNUloxYnNEV3JiRngyK0hGazdHa3dmZkJsUEhKc3kzbnhvTlhoS1FhR2h0?=
 =?utf-8?B?NVpWR0FuVUF5M3k5OUVZVmEydHczWFZ5ejVGT2NEd0xDWE56OTNaMGxjamlx?=
 =?utf-8?B?NWczTGZKMkhCYUtjUjdyNDVPUzV6b0h4Rm52dXZPQWVWV2N5UDFOMzdEdW1G?=
 =?utf-8?B?MFNkdFdOa2FSNXhzbENERWFxcG9OQTE0TVB0YUllb1V2bkpMSDQxNDErVjVm?=
 =?utf-8?B?cTU0M1BzbnlPS0xUTHEzOEZ5bW9YR05hdHo1V24xcU80UUp4Q083SE1LWFJG?=
 =?utf-8?B?RnFrNi9XSWpjNjJ5MHBrMWRpbGJ5U0pQOElCbHJaVVlwVk5OTUM0Q3UvdXF6?=
 =?utf-8?B?ZDJwZmhUK25DSUMwcjUwenB3ZnYyRDVsekVzRXErWi9veVlxMnJ5VkVwWHdE?=
 =?utf-8?B?MU9qLzlzU3VuY3hmd2RtWjg0OW5ZQVhBY0hhN0VOZHFnQ0t1NFBGb3dlT1pW?=
 =?utf-8?B?WlU1WDh2R2cvSjB2Sm5kNVJkT3Jqd1crQ28yMktuMWc1OWxDbzNpMVBxY1ZN?=
 =?utf-8?B?cVZnK3pidTR0NmN2VnRWOFpFV2hWUGxvaWYvSjJEalVyRUlnTE1pWTZENXBu?=
 =?utf-8?B?ajFUQ0YwN0dDZFZQcU0yT1EzUDBwWC9NdHRwRzduVlR1MVVVMCtNcllWR3lR?=
 =?utf-8?B?SGx5T3M1U0lFWkJRS1dCVit1aFQzNkUxUUxCWFZzNWdBU0V4L3pET2dmZ3h2?=
 =?utf-8?B?akM0S1FCMzllRWFVUTdONWNqRHJNVEFUV3A4OWs3TXhsTUZPamI2UkprdDhN?=
 =?utf-8?B?WTViSGdHamVPekNQclBHbER3THhpM1dTTnlHcmI2ZlJYTHhkVFZCYlZzc2hw?=
 =?utf-8?B?aWVVLzhPWFYvdDdReW8zaWM1ZWczdXMrU2ZxK0dLUEJDUW05THFabVMyWUxN?=
 =?utf-8?B?ZWxxU3FhYnYwbU4rUDhoTGNjZGIwSWV6amxVM3J2LzlMZzdvSExnOVZwM296?=
 =?utf-8?B?U2ZUTTVjbUROaUdkdmlCZzJoUTlQMWRKckNxdHZBZUxTRW1NdjF3dU1LVHRv?=
 =?utf-8?B?YVQvN2NQSlFGSFVmVzRJa0NzckxGck9QMUlYKzZENVlPN0FxbFdlUVY3VFY3?=
 =?utf-8?B?VzhydFhESXJmdEVZdjNtUGptMVVSYnhEWmFhY0doRTdxS1ltN3B3dTU4OVY3?=
 =?utf-8?B?NFZ3ZUF5bjZiWE9zNFNwS2NhQ2hvZTlTZ3l0VFNvdTM0cXRhNkQ3QlcyVk50?=
 =?utf-8?B?RmNhREwyNFJic3dXamVGVzM5MUNFc08rWFovSEU0bHhldUVKcWdLRGRRMEJh?=
 =?utf-8?B?QzNsbGgxbTFqWEhoa2pqcDB3NFhrY0lwVWpPc3hGOUtsUmszVWV1UmtMOUpN?=
 =?utf-8?B?WEczRjRWQjVYTlZSVVc5c2IrNGNrTzhjVUhjZUt2Ujg0bWFRUkY5TDBKeTZ4?=
 =?utf-8?B?czNCN0xzUjlJaDkzc0FVZDF5RHdNVm9ld21VMTRqayt6NEw2ZEM0UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a514334-0a4a-4bf2-bf56-08de78bf888f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR17MB5087.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 00:55:15.9943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 514876bd-5965-4b40-b0c8-e336cf72c743
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7rhB7LmYyXpu18ssrUnGioyAllkUyg9NT8VH90h/0Vh5EGDul0v+FdTQqJjV1k8VjNSz5ak+Me/zfIi4e2d/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR17MB4748
X-OriginatorOrg: akamai.com
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2602130000 definitions=main-2603030002
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDAwMiBTYWx0ZWRfX3J/T4paqmXxF
 UsKf3OH91rxwIEsT8edo0WYIksHChdSUBoIGNtwFfOiM1WmCmgy3R9FWerqMHqpPT/HIY5O2RWp
 Ez5ifN61Ndg2Al7/4zr6BQsQRHMPz4xLEmCvsg1q6Dpt+qOfH4LKIGzTYCNJPJeNbdoTPSqkReb
 clKtNt6duC93Aw9pkMvAWKcEeRR24w1Jm+dY9MrUSCEn1/G80spgoa+SMTy/xPn4U22lcJ14MCW
 spsVIrS3upGZi5WLKHfWLCaqB2AgcF/iJ0zUyxn0myFMZWAgLM75rlRx6sojZMabZPQVupNCzsD
 th8ivtZCwWLUibopNWE/Ot+WPDOkO9z9bV6x2KYJKLhBu74xPuyK46gjJc1X11ecIoeaXgeoujO
 pgmoH7KaQHPdkslufRWApfB9UTePSv9uzhVQwsusnrRJtkti8Uyz+fpn46iCZVSBmrs4O8faJjq
 rrV8os8iGbfQg58xzYg==
X-Proofpoint-ORIG-GUID: V8QxVQg3juo5e8w7ttwbMBtG3dMZEfzV
X-Authority-Analysis: v=2.4 cv=YcywJgRf c=1 sm=1 tr=0 ts=69a63177 cx=c_pps
 a=BpD+HMUBsFIkYY1OQe22Yw==:117 a=BpD+HMUBsFIkYY1OQe22Yw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22
 a=XKgOefoLEnF0tNwW78TB:22 a=VwQbUJbxAAAA:8 a=X7Ea-ya5AAAA:8
 a=algERDra_LIsg2YSb0UA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: V8QxVQg3juo5e8w7ttwbMBtG3dMZEfzV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015
 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030002

On 2/25/26 9:24 PM, Yu Kuai wrote:
> !-------------------------------------------------------------------|
>    This Message Is From an External Sender
>    This message came from outside your organization.
> |-------------------------------------------------------------------!
> 
> Hi,
> 
> 在 2026/2/11 0:51, Josh Hunt 写道:
>> When an array check is running it will raise the barrier at which point
>> normal requests will become blocked and increment the nr_pending value to
>> signal there is work pending inside of wait_barrier(). NOWAIT requests
>> do not block and so will return immediately with an error, and additionally
>> do not increment nr_pending in wait_barrier(). Upstream change
>> 43806c3d5b9b ("raid10: cleanup memleak at raid10_make_request") added a
>> call to raid_end_bio_io() to fix a memory leak when NOWAIT requests hit
>> this condition. raid_end_bio_io() eventually calls allow_barrier() and
>> it will unconditionally do an atomic_dec_and_test(&conf->nr_pending) even
>> though the corresponding increment on nr_pending didn't happen in the
>> NOWAIT case.
>>
>> This can be easily seen by starting a check operation while an application is
>> doing nowait IO on the same array. This results in a deadlocked state due to
>> nr_pending value underflowing and so the md resync thread gets stuck waiting
>> for nr_pending to == 0.
>>
>> Output of r10conf state of the array when we hit this condition:
>>
>>     crash> struct r10conf.barrier,nr_pending,nr_waiting,nr_queued <addr of r10conf>
>>       barrier = 1,
>>       nr_pending = {
>>         counter = -41
>>       },
>>       nr_waiting = 15,
>>       nr_queued = 0,
>>
>> Example of md_sync thread stuck waiting on raise_barrier() and other requests
>> stuck in wait_barrier():
>>
>> md1_resync
>> [<0>] raise_barrier+0xce/0x1c0
>> [<0>] raid10_sync_request+0x1ca/0x1ed0
>> [<0>] md_do_sync+0x779/0x1110
>> [<0>] md_thread+0x90/0x160
>> [<0>] kthread+0xbe/0xf0
>> [<0>] ret_from_fork+0x34/0x50
>> [<0>] ret_from_fork_asm+0x1a/0x30
>>
>> kworker/u1040:2+flush-253:4
>> [<0>] wait_barrier+0x1de/0x220
>> [<0>] regular_request_wait+0x30/0x180
>> [<0>] raid10_make_request+0x261/0x1000
>> [<0>] md_handle_request+0x13b/0x230
>> [<0>] __submit_bio+0x107/0x1f0
>> [<0>] submit_bio_noacct_nocheck+0x16f/0x390
>> [<0>] ext4_io_submit+0x24/0x40
>> [<0>] ext4_do_writepages+0x254/0xc80
>> [<0>] ext4_writepages+0x84/0x120
>> [<0>] do_writepages+0x7a/0x260
>> [<0>] __writeback_single_inode+0x3d/0x300
>> [<0>] writeback_sb_inodes+0x1dd/0x470
>> [<0>] __writeback_inodes_wb+0x4c/0xe0
>> [<0>] wb_writeback+0x18b/0x2d0
>> [<0>] wb_workfn+0x2a1/0x400
>> [<0>] process_one_work+0x149/0x330
>> [<0>] worker_thread+0x2d2/0x410
>> [<0>] kthread+0xbe/0xf0
>> [<0>] ret_from_fork+0x34/0x50
>> [<0>] ret_from_fork_asm+0x1a/0x30
>>
>> Fixes: 43806c3d5b9b ("raid10: cleanup memleak at raid10_make_request")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Josh Hunt <johunt@akamai.com>
>> ---
>>    drivers/md/raid10.c | 40 +++++++++++++++++++++++++++-------------
>>    1 file changed, 27 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 9debb20cf129..b05066dde693 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -68,6 +68,7 @@
>>     */
>>    
>>    static void allow_barrier(struct r10conf *conf);
>> +static void allow_barrier_nowait(struct r10conf *conf);
>>    static void lower_barrier(struct r10conf *conf);
>>    static int _enough(struct r10conf *conf, int previous, int ignore);
>>    static int enough(struct r10conf *conf, int ignore);
>> @@ -317,7 +318,7 @@ static void reschedule_retry(struct r10bio *r10_bio)
>>     * operation and are ready to return a success/failure code to the buffer
>>     * cache layer.
>>     */
>> -static void raid_end_bio_io(struct r10bio *r10_bio)
>> +static void raid_end_bio_io(struct r10bio *r10_bio, bool adjust_pending)
>>    {
>>    	struct bio *bio = r10_bio->master_bio;
>>    	struct r10conf *conf = r10_bio->mddev->private;
>> @@ -332,7 +333,10 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
>>    	 * Wake up any possible resync thread that waits for the device
>>    	 * to go idle.
>>    	 */
>> -	allow_barrier(conf);
>> +	if (adjust_pending)
>> +		allow_barrier(conf);
>> +	else
>> +		allow_barrier_nowait(conf);
>>    
>>    	free_r10bio(r10_bio);
>>    }
>> @@ -414,7 +418,7 @@ static void raid10_end_read_request(struct bio *bio)
>>    			uptodate = 1;
>>    	}
>>    	if (uptodate) {
>> -		raid_end_bio_io(r10_bio);
>> +		raid_end_bio_io(r10_bio, true);
>>    		rdev_dec_pending(rdev, conf->mddev);
>>    	} else {
>>    		/*
>> @@ -446,7 +450,7 @@ static void one_write_done(struct r10bio *r10_bio)
>>    			if (test_bit(R10BIO_MadeGood, &r10_bio->state))
>>    				reschedule_retry(r10_bio);
>>    			else
>> -				raid_end_bio_io(r10_bio);
>> +				raid_end_bio_io(r10_bio, true);
>>    		}
>>    	}
>>    }
>> @@ -1030,13 +1034,23 @@ static bool wait_barrier(struct r10conf *conf, bool nowait)
>>    	return ret;
>>    }
>>    
>> -static void allow_barrier(struct r10conf *conf)
>> +static void __allow_barrier(struct r10conf *conf, bool adjust_pending)
>>    {
>> -	if ((atomic_dec_and_test(&conf->nr_pending)) ||
>> +	if ((adjust_pending && atomic_dec_and_test(&conf->nr_pending)) ||
>>    			(conf->array_freeze_pending))
>>    		wake_up_barrier(conf);
>>    }
>>    
>> +static void allow_barrier(struct r10conf *conf)
>> +{
>> +	__allow_barrier(conf, true);
>> +}
>> +
>> +static void allow_barrier_nowait(struct r10conf *conf)
>> +{
>> +	__allow_barrier(conf, false);
>> +}
>> +
>>    static void freeze_array(struct r10conf *conf, int extra)
>>    {
>>    	/* stop syncio and normal IO and wait for everything to
>> @@ -1184,7 +1198,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>>    	}
>>    
>>    	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
>> -		raid_end_bio_io(r10_bio);
>> +		raid_end_bio_io(r10_bio, false);
>>    		return;
>>    	}
>>    
>> @@ -1195,7 +1209,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>>    					    mdname(mddev), b,
>>    					    (unsigned long long)r10_bio->sector);
>>    		}
>> -		raid_end_bio_io(r10_bio);
>> +		raid_end_bio_io(r10_bio, true);
>>    		return;
>>    	}
>>    	if (err_rdev)
>> @@ -1240,7 +1254,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>>    	return;
>>    err_handle:
>>    	atomic_dec(&rdev->nr_pending);
>> -	raid_end_bio_io(r10_bio);
>> +	raid_end_bio_io(r10_bio, true);
>>    }
>>    
>>    static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
>> @@ -1372,7 +1386,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>>    
>>    	sectors = r10_bio->sectors;
>>    	if (!regular_request_wait(mddev, conf, bio, sectors)) {
>> -		raid_end_bio_io(r10_bio);
>> +		raid_end_bio_io(r10_bio, false);
> 
> There really is problem, however the analyze seems a bit wrong.
> 
> The master_bio is already handled with bio_wouldblock_error(), it's wrong
> to call raid_end_bio_io() directly. Looks like this problem can be fixed by
> calling free_r10bio() instead.

Thanks for the feedback. I tried this and indeed it does also fix the 
issue for me so will send over a v3 here shortly. Appreciate the help!

> 
>>    		return;
>>    	}
>>    
>> @@ -1523,7 +1537,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>>    		}
>>    	}
>>    
>> -	raid_end_bio_io(r10_bio);
>> +	raid_end_bio_io(r10_bio, true);
>>    }
>>    
>>    static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
>> @@ -2952,7 +2966,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
>>    			if (test_bit(R10BIO_WriteError,
>>    				     &r10_bio->state))
>>    				close_write(r10_bio);
>> -			raid_end_bio_io(r10_bio);
>> +			raid_end_bio_io(r10_bio, true);
>>    		}
>>    	}
>>    }
>> @@ -2987,7 +3001,7 @@ static void raid10d(struct md_thread *thread)
>>    			if (test_bit(R10BIO_WriteError,
>>    				     &r10_bio->state))
>>    				close_write(r10_bio);
>> -			raid_end_bio_io(r10_bio);
>> +			raid_end_bio_io(r10_bio, true);
>>    		}
>>    	}
>>    
> 

Josh

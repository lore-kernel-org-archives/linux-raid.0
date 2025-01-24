Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82352188714
	for <linux-raid@vger.kernel.org>; Fri, 24 Jan 2025 19:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737747014; cv=fail; b=FmL15y/dqO+b3uiceuz4RYPf0D+mVJkd51bXgBjIp5cG8DXBUKIW6hdytMWkdPtB7BbwCSx+oohmb4etxXO35E1kzRtyV40HzkXrQz+Gk0P0WvijNt7DNMEPhPt3nGaeD8m7rH/8oXlrRQFX/h7FXfFGlALZj2mznb41fuPGM58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737747014; c=relaxed/simple;
	bh=PZm+C9VudADcmzkpSglDO8ZOrI2/PXigDlYp+zmmFi0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UYXHwCmVjl43a+6pIdQRpDouoMQW1ESMm+YDVr7vr6rRDKS7lSksG9vNqdp5LqLlA0KTyh3SKEtjmiKXFjOImfykITGwR03HjW+I1eipmtMjuqjoP/uLOX1jgXpKHbvRizmXZPM4JYSeOlS9x8sCSTEDedPJfSG8TWpzGjWO99I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=CT2VFFEg; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="CT2VFFEg"
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50OJ5tVa029087
	for <linux-raid@vger.kernel.org>; Fri, 24 Jan 2025 11:30:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-type:date:from:message-id:mime-version
	:subject:to; s=s2048-2021-q4; bh=8Uby/vIuN/eytiFPiGNokc8qzOdGQih
	hYIxm4aPcmZk=; b=CT2VFFEgIJvjFPLLIlTnzCRmx9XpsuJEHwpciCrW/SqudPN
	0P/eUy/V2ZGs+CmT3vChM/BNneyjh9KfDLrtQogy2fNP2TDsIlBgnU/M7YjMfH5t
	fxfKIjxerWmDLr9L92HzzMNT4ezFhsLdbrW8N+DJ7Iia/Bbzhv3Cww29rtQs/N+1
	IhmbMMSaX/kIqnI7WG8EI0hSp8anE3IyajjzX/WohqXEPbbrX6ttuhULh0dxu4QY
	U4bkQ3jRrlgRV1MMHLveIijXdFmRZvJgmog2jg5sffACsR0Fhe0ufKQFbRsJjU4+
	MYDWI8Efj6z/p2bXajyqhSKVYLSgB7R4eXIjNLA==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44cg3wrf65-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 24 Jan 2025 11:30:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bE7AP9gRtcVMxt4gXLHsP1lnLaoIU6kTEg9YBlO8+9ptz6/P5YQj3kNdpkpkQvHwhHg2N+n0lwW6CXu5xa2NFhI5ttKcC6MPKNaocwa8JpbrrNaPMz/bvicTxnEhT/b1w8EicJPiYJGPGh9hoQ51H+DdL5LOb9octSsJYeiwPRgnbITYMYc5FmH/ORcTnosE9Q1jBsdtIM4iVO6HHECjEVrt0zBLKWgB84ICgq85/uOP9BeixS3yObCRk9IRq64U8kxnRub9ZAolESK9yDomgL1KjArN565N8YFF/rkTLkzqr/rnwpse8ElwJu14IEF/SvRMKIygsXqOQ3gCp12JPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Uby/vIuN/eytiFPiGNokc8qzOdGQihhYIxm4aPcmZk=;
 b=cH4tX9gRCVEiF54hyMt1FWG5zZAtN7MCQ6GTsWzvwkQ9C1qD8lPWpJ3GJZNQQAOt9Uz3s5tT9Iqw9LBr7O+kdEBzJG5Fpp5osNWm/NAsQZW9RqZLxOwVu42KFecEDE1PpVQlsVmB6polspnrxD9Gbs/RF1oM9YNL/SjOBbRlFXXMQNTezTXFlTsBGRR1QZJekfJtsWcGYOz86ev0WSkiBngaNR9VXRiWoVRRsIPJsucZAErZuQUvrAZF2E/+oQjJ4Q8CVxvxIc84n3N2VPJQicT3CKAPQvhR9L8/tjzuWfGdhfHasmoXCXsG6jvh4Qr6/V/x4SRvWTJUmIDe3aPK9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by SA1PR15MB4984.namprd15.prod.outlook.com (2603:10b6:806:1d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Fri, 24 Jan
 2025 19:30:08 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::90bf:29eb:b07e:94d9]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::90bf:29eb:b07e:94d9%6]) with mapi id 15.20.8377.009; Fri, 24 Jan 2025
 19:30:08 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Song Liu
	<song@kernel.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        "himanshu.madhani@oracle.com" <himanshu.madhani@oracle.com>
Subject: [GIT PULL] md-6.14 20250124
Thread-Topic: [GIT PULL] md-6.14 20250124
Thread-Index: AQHbbpZgnBrUeEVeFE6IssQ2DQYT9w==
Date: Fri, 24 Jan 2025 19:30:08 +0000
Message-ID: <FF2AE8AC-2831-4458-9D57-6660160421B0@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.300.87.4.3)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR15MB5117:EE_|SA1PR15MB4984:EE_
x-ms-office365-filtering-correlation-id: 4b5e6918-777b-4960-813d-08dd3cad836f
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?61qkZVcLf1yqRYe9OHQxGYe3BWNyFso96vKhYxh3SBe5GVtLZTm7ZyeltxHV?=
 =?us-ascii?Q?8W3OR1E8bD8t0mJ9K/8nzffPozJebLfI3gvycb1SAf5UnYTsYGY41IIQw3n1?=
 =?us-ascii?Q?lVbZMphlWuvw2QH+lJu1xuRKVPzmd7y+kSp0xKXgOfH9Y6MdwnU6TlmvgwyO?=
 =?us-ascii?Q?vq9AegwR6nisXcfAUtUmY3jhKHCVX3pplTzVwBek6AkWPG5mrFeJUDL18HNp?=
 =?us-ascii?Q?WJqhA75GzFC0xid4ymSRIL6HMzyQYKdnjNvESsHEtv6t1k4W0D9RcIzW9viH?=
 =?us-ascii?Q?DwELTtiLpM2EH0htT+bLMVLa1+zPjjNRhY9iOyyeYaHAZwB2zcWpRVqDrzUX?=
 =?us-ascii?Q?sxzD1Ggw9M4nSMd57GkIBKv5BRAXPYZDZ4J97vMCgNBkMe9n/QO5rxzdzhNw?=
 =?us-ascii?Q?rJQ1mOlir3QAENevNMyNLtaiI2Ua+HUzSOjEH3K1rdW+04xuZsvKpWQaDoCF?=
 =?us-ascii?Q?ZatPodqZtb0r7QajgDSZghxts01kWQORUKI0o0Hj8I7yIiIT7LdXcUvBRm16?=
 =?us-ascii?Q?10LszN45cmd87trqJklDUvDSxogx9xpR+0oHBxxNEoH/WZsBWksnxTjOwMzv?=
 =?us-ascii?Q?QjHqnulEdBrmt15DWJa5spdtYk5NZJgE5CQpeJVUR87BIhrQKAtfebipEhbM?=
 =?us-ascii?Q?tHt8zbsX2VFb9qZEPAXEJ6rXRDt0ji5OZQKxfuxmyuwVcYOpWkFdPFo6Mycj?=
 =?us-ascii?Q?3hv1aelxzbAIQnTaTxfCoWb7EoJo0r6p7ORggJCOniNW5ad08GeUI9UFmAy8?=
 =?us-ascii?Q?BOsbDWElG5W7OYKmWGot7+b4jMfXD2V4my1GGq/IpPqsEw04NSEGxpZO9oij?=
 =?us-ascii?Q?brGdhx2dcbnf/NYOCxEdpT5hbOBmIpkJQni7tvIpSTIKob/1NSZkXCRSZo71?=
 =?us-ascii?Q?ftDch6M6e9lqtgeycByHfz4uHGNLBzJ2u+W8OEl1CM8Z1XEf0X7qxr7V3+3j?=
 =?us-ascii?Q?2WriR5DA+o8mVDIvVQ9oFvlRu8KNGVA+FD5BIi0W3t9mOOAzSUtH5+dIhv3w?=
 =?us-ascii?Q?bB9cJW4zEM5oC5s72wfIZbZZzoR3lOc58WBqPvWxkRXJoX6Wjbnxb/fngvTF?=
 =?us-ascii?Q?QHugWUH6eIJa29jwX7UrLw0FyNAC3EJJuSOr97SC/dTQIUSTBD++GEqZ2v3z?=
 =?us-ascii?Q?0j7WJKtVm7u9STFCPkzBMzHrh25d5kNFippTAAmEqh0z6Cs4+9l94Uv7aC0z?=
 =?us-ascii?Q?a6yhF0eyzYRAn5H0PpCh0xmYyJ5hWm3SAVrS+NRlKOuwaPVjLyPAj708DIKN?=
 =?us-ascii?Q?U5a+PBqjLPdOPzakBYhTwjW5v2YbfM9hb6ITO4TzxeOHzmp5W/JWdkRbLePt?=
 =?us-ascii?Q?DEspQRlDzwVDs1w/Ek1tfnpVqCOZIN0YshWz058hyZ5BpEotIVvjXYadwIwO?=
 =?us-ascii?Q?N4UQEOzjW18xo7RgD1DHKL5YzBlTTHJAl+hZSpWjURcsUp42OxKpVnPsRFWV?=
 =?us-ascii?Q?wRkcQlr9JVBut1cZckktpDuG07+S0TWK?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?pJbWll5P01w6Y3AMKjg/sQKYqqY5TdRyW8uCYGqTelKSabVTGvuw4t/5zSAp?=
 =?us-ascii?Q?zfRkZl46H0a08Av1SxzetdKq63VVpcMZsuYKUhqsexpoua3E5MPfkNFqsIE2?=
 =?us-ascii?Q?pjvLvWz7L0hwXlylPRAyLYevpAocICGTC8Xx5QgzDUtMJ1Zq2DuXGdQjWvXY?=
 =?us-ascii?Q?D4Kh7D+anJItn0r9+9sWKwDbKfnaKmmYrlhlzTjET8iQfbZHTJEf6jaq+4rU?=
 =?us-ascii?Q?tOYFOqAjBIyIEppHWng6KxCUB+PJF9Gk5nFERcW9S8uZvPHqQRn981n5r0+x?=
 =?us-ascii?Q?xKYslT/faWxUPGLaFNxpVYKa1MAole2OgJlPtB4zquRJ/DngzxDRypp8GgCC?=
 =?us-ascii?Q?5pRKUV1+2Tk8etVoOTsNv9sOH9MRs4bvBuHtPRxAzF8jVfi0c0Rl7BPxX6bM?=
 =?us-ascii?Q?uVYvC/r2WM7vwDfNjZh7wTgLvyIS4NubWPdDoKfiBdo5HMEBV12iY+b+RLC3?=
 =?us-ascii?Q?t3nCrRwBKXF7P/RAL3hTd2TKUJeUc88VPJyjVZJ3cFIlvE8J4QSfnyygAdVU?=
 =?us-ascii?Q?brd29ZT0WGWjq5E4ROknLudgUoiBctG8hxgTn1TewIV0iyml9DPegnpY9Kp+?=
 =?us-ascii?Q?jgCWn40EeR6k2BHNG75iagpD5HWnypWG/aNOdHQYWM1WXJS/esXKYCT8W4hD?=
 =?us-ascii?Q?HcyHKWYxc7SnuHmek81D7zex007kYvGb+T0KrweHJ+thXZAixXeOydEYJtXj?=
 =?us-ascii?Q?i9YbC2fu6ftm5DMZv88v/OVAJGjHGiJGoRACJN5z7pW8VqWvVXgZpKE7pAEy?=
 =?us-ascii?Q?QpbCoVSPnVyxnPqIhJ+O0IW/g8COkbinfQs2KW2P4ZfgGGwzwBuRKpAVQ2kM?=
 =?us-ascii?Q?vwMTaIXuWKOAH/Es73AaMyBy8LxfD8HHEqhc11/SijXZOaV9FGIf3W1W25c5?=
 =?us-ascii?Q?1GxxJmtf4IRxUEn8dUk/+LyCvr8xqPW4nwerlF+khLPV/dTJzkKZ0LVvL+VS?=
 =?us-ascii?Q?GA4WbtAXE+OWl0HdFA/9KrfkcNv1WGcIgmGHbebQRZgd+VS4PbD2wewPmDnI?=
 =?us-ascii?Q?nx3bI5DlIOQuMg+S0HbemVbU21Hr/jGR1fS0DyJARA3k7gD7/7myTztfY4Qz?=
 =?us-ascii?Q?0o26CTBeMB8weiODI97eEEIjzmG/lwPq4BGXZx2F7uWLauoJxuZ6DQdXsp21?=
 =?us-ascii?Q?xY3Krnijvqnh8qwuxFHaeX0zW1UVGXHeHKDbeF/dicMCqZ8xR0nLdzv3/LR2?=
 =?us-ascii?Q?776UIVXKlFs8Vei25Y+3YcHzcYdX+UpcrahC6rdrPFvDDaXwbkwiD3wm5ODW?=
 =?us-ascii?Q?tmjTQXFjIUYdXpuw8//nl9UmLLN5SNUcRLgM8YjcPfcBFU4Mb1DpSO+t6nlx?=
 =?us-ascii?Q?JsnIce5aL9QqCYef1cyfEjWMhxal7eCOFJ751EOtD9EgNr3qUmKdNngq72qH?=
 =?us-ascii?Q?A4Z/q/SxHD8A1ND8qWbLQhCXA0uskMeJ0pGLtFY9HULCjNVCAls5XhHQiOM3?=
 =?us-ascii?Q?r7kXs5G+NSe6hDmxMPgz8t7VazG1JETVV5JiMLSLr0SpSKsFJO98RA5ua4ss?=
 =?us-ascii?Q?d3OTBg5kIcGkdO0W8zNhaqrQhP/DZGe1RLhRzA94MtFaLCevO3E/3Pjywvnv?=
 =?us-ascii?Q?XgCYcX7mt2kMFH/cSLndA49UETE6nBui3Co8q9YuV2oPi+xZm92lTjjOlwVE?=
 =?us-ascii?Q?aDQZCSQ43WHi0NG4N9XMXmU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BBA9D77479358B40A9F2832C6FC6250A@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b5e6918-777b-4960-813d-08dd3cad836f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2025 19:30:08.8083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZZqVtE/D7Ud7Z+4WGoqtcFFkx21cKsYJ9Fxa8nGGh9mn3bYUTQqcfNZi03MXHuZNI6T2KrSLljx3SlTAd4vmeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4984
X-Proofpoint-ORIG-GUID: Z4Q1Zh3Yn4MC8Um7995INQa5D5SmASTh
X-Proofpoint-GUID: Z4Q1Zh3Yn4MC8Um7995INQa5D5SmASTh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-24_08,2025-01-23_01,2024-11-22_01

Hi Jens, 

Please consider pulling the following fix for md-6.14 on top of your
block-6.14 branch. 

This change, by Yu Kuai, fixes a md-cluster regression introduced in
6.12 release. 

Thanks,
Song



The following changes since commit a9ae6fe1c319c4776c2b11e85e15109cd3f04076:

  blk-mq: create correct map for fallback case (2025-01-23 06:34:32 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.14-20250124

for you to fetch changes up to 8d28d0ddb986f56920ac97ae704cc3340a699a30:

  md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime (2025-01-24 10:03:32 -0800)

----------------------------------------------------------------
Yu Kuai (1):
      md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime

 drivers/md/md-bitmap.c | 5 ++++-
 drivers/md/md.c        | 5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)


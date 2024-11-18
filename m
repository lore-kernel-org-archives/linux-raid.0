Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FCD1990C7;
	Mon, 18 Nov 2024 10:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731927055; cv=fail; b=DX6fermDn/l5CZAUzBRwHg/zZ/tAha3coK/2FQLzE9pO1gfVZbrVOBG4GPp6axBs0XvaoQaUpF9cRpUrUOB4bS+laDqTOUhyjfkvEAzppJm2NlrZSNpsFV7rB+onasCQplUXGVd8Nru3KoTUnxdIpA9Csv0HWBGBvb4/NXqMv9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731927055; c=relaxed/simple;
	bh=tGXd6v5fu75VTxyM9dYxDM9nikk6TaRYBXIb5eWiZmg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZbzYM6S9jbZ4gIszv/r7GlnM/+Tf+7rChIx4W5rzehe4HeDu4eTP9HmR5g4121I7kF9hNg6kCqWPVcil38y9Ve+5fYjONKrFEnxUjyZeo2EAlNfJajjN1es8ZoJHUKJ1bR2WDoy0eArTggbY1jBPDTzowyVaeFa0oQ41dXgJH0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MRyP2r01; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kipA+OQz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MRyP2r01";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kipA+OQz"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AI8QVdg004562;
	Mon, 18 Nov 2024 10:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=DN/Y8o6XwNHIgExlg0S9MdUL/vLdc51DmXKFpsr315o=; b=
	MRyP2r01+AR9MyrUEwd0MEMjFt6Z9jZpbpis8jvXdoXbFAHpTHzBcgWtsc4X0DDm
	SbK3ji7SyuXdcQw3OU0bHgu85KmwGr0OgKxCmGeBjQKxTvud/eb/EnFRj7rPobtJ
	OyKjkN6hJl9om4Dw5XUn+1NT9uyV0dS+2q0o94LITHmV/d+Pn/ELZbCDHPi/9zHJ
	qMirrrumt6Th4ssiA+CaLXqBO19eQ6S1mqb6YzViB0zPI+OH89oPnTSKsBZJQPHE
	UN8TUgj3TUCvbeGrebkU01wG6KNB9jv2A6+ZiykKQPOxShO6f9pQ9//mc7/2ipq1
	TLWXh+2DaliWj5eUZphmHg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xkebtd2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AI8wtWt008976;
	Mon, 18 Nov 2024 10:50:44 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu75scd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=USCoQN4FQNkphEXFkK0OBwBdkzrnIQZYnvry96zOg+SxDmDm8wq6ACN1hL9yo3jG9KT10vAaZOZleg9J1dUTZ6rL63TV135wmSMzh9Dmk65G6lcWwcktEn8CvBcfO2AtOJDCB1Oup5xCj4+I7dHU5bd+DZwer+Z2IKgiMZWWQnylXi+qyjhwAaFwsMKJcJJ1uJeQZSVe15o65Wvx9RowhHt1LMLvDguN9iqRAqaCXlRW3P+eOc+1RAVN8iShAXdGallnPXaWsWwxbBwj6pb9j+H7ucFYjYOIK330bpKn5a0ZVnbTG3UPTboYIAQWH/UvcHOF5KNnJKnLx9Tvewc9OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DN/Y8o6XwNHIgExlg0S9MdUL/vLdc51DmXKFpsr315o=;
 b=xAElU+HuW0UttrOFsNgwt5Bh/Af9knIkjRDDt32XTt8/y8+cdqBfZSJxUUlctLlDD3P44HR6620Zir5QxQ5ZhKpXNwzKkffTHtStYzHbetW7PhMG71M5POLzWJpYcXcSc6cCzCTspQLCOx79zhiS2Dkc9DEZKGMH/O1fKKtCfx6xsa1mWyAWtr9hcwlbBC4EARO/vlo7G7TyM0+2Dv+FB1krSmphQX8aXWevyxrAP1MPe7FmiPOFABLTEAHA7ym5CZB3NfdnfqzWAvkLr5zvLXxZcCLoJXk78oIjJFhMSxlWZRdEW34gF6n/yPBcbqVxzW1yvjOjwIPEkPtmTqlavQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DN/Y8o6XwNHIgExlg0S9MdUL/vLdc51DmXKFpsr315o=;
 b=kipA+OQztCG8ZLTO0LMoaf4iJTjYerKFR5tbQwICceEoD3STkXGPAffzWnmMxYKgfahi91EwkfOuZxQlqHB2/TW0KuJ8RV6ALNl2MEI21Z4KbDpEqQsRlm74QH+c0CzUBr177ETSLx+YtF8mEzqJ16MPSctLHOoK+w58ggtXktQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6812.namprd10.prod.outlook.com (2603:10b6:610:14b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Mon, 18 Nov
 2024 10:50:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8158.019; Mon, 18 Nov 2024
 10:50:41 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 5/5] md/raid10: Atomic write support
Date: Mon, 18 Nov 2024 10:50:18 +0000
Message-Id: <20241118105018.1870052-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241118105018.1870052-1-john.g.garry@oracle.com>
References: <20241118105018.1870052-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6812:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d0bdf96-7a2b-4ddc-f8f6-08dd07bed84a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GYlXsUxFrUrUQcAy6Brzjji+/mS+uW0eyngpzi7OYYqfsYo3QoWsGYSelKEG?=
 =?us-ascii?Q?/2fTULRMmj0D8u21hsCd4Tt2Nz6tWH6MEDmud2UKI9nYCF/SXcxxmZhbNT2D?=
 =?us-ascii?Q?zyAkRlyk3R9fWeYleM6qe3Uwo6fdapUv7S8VKIjP8cPdWlzm8gqLtKEJTx5u?=
 =?us-ascii?Q?2lE+bdjRTJLyu64CZmsM/MjSyM2S6DnpFYMqYo1M+MnTZy6RjyRpNqugi5O5?=
 =?us-ascii?Q?kZZqIg5An+ePxlGxkERR20wvwx135qkjF7ZtGaVu1mUlXozLsHFvs7EgWiel?=
 =?us-ascii?Q?R3T2B06ptwtNfUnlE3rYIisHcEjzgOeJeRo+4WgWqW++RA2Gp8Q4sduLGgMx?=
 =?us-ascii?Q?WAxz2QAfXJq/j4jp9rMI8M9gVDIu1iabK0JpMs5tajyGJ6OD4fDVeX5FO3MJ?=
 =?us-ascii?Q?GB4yzmt9r4CJJtbG3o6OuPMRkNvt8r8EaafOUylMDuOGCVJ7yoSbrsBUXQLz?=
 =?us-ascii?Q?iosc+g3sEeSYF5f7NZr3RC5EFE6OE50SlK4Qu7Ne3ltGoRUbcpK1fdhD8jO2?=
 =?us-ascii?Q?r+lhNPTDIoS8JeupF4RmGY3Is0tLmCcMJ4U7xfR0uDOlPGwRc8UOIY8CdMR1?=
 =?us-ascii?Q?PsSEUWscL1al/hQczaNp6eIyT2rbhRIwSCO9Svx3FzeVIWx8TTJeOQjbcAk+?=
 =?us-ascii?Q?3xiLDZUHBBLeqMmqt6vYKXdiEB0YNFNrZGEIIiFuoyA8N8esU0NzO5GfYJg7?=
 =?us-ascii?Q?q0jv1TdZB2zrRDMgW/9woxPP2x3Jzu0QJkaFh58Lr+HKxM7RzjFC7f0Y6aIY?=
 =?us-ascii?Q?QyTemtjCdv1dEHmEgs9ZN4l3Ew3Cz0OAqUT10S16cVIhnyg8+57dE/o/wAwW?=
 =?us-ascii?Q?0CZCJstDUS6Y/I/sG4evLwVFvn4kPsNtVAHX9u5by+1L4WNNGdjRb4rS4Zdb?=
 =?us-ascii?Q?hEWrSUQkEwUOJ6bL4uSIc/AYiZ3k8qXxMjr2V3r1nQWnsEtR0sJKHXv7QL1t?=
 =?us-ascii?Q?vNmNG/R1doUuT1TjQasmIU8pXgNkORmE0YZRWrDcNId6j3xGlrmALJm7sUAt?=
 =?us-ascii?Q?II2rlARTGl4n6Rk+eCA16aSk9X1ZWdph2xgvTOmbU+Q43YeFXFotEpNlCOeR?=
 =?us-ascii?Q?+SR2EiSUKgs0Z2bl69MTciYZy7MJ2gQVQJZ3JevgMJDmucjPJomRYGEhApVM?=
 =?us-ascii?Q?5CLeZpofCs8Rz8g1liO6DdTb0U+fiuDtPX5bjwLEQfK+kzNqjP1EKgl55efd?=
 =?us-ascii?Q?/CrdtNHeqIQS19wMxKlc5892Y1EkqL6rV2k4PSMB7F+4OlAa5Dj4eOCQBqQw?=
 =?us-ascii?Q?mdPatEa5oIlkMYET00vkZdqQcFKbFdCUAvPctXynC2+nms3bQI4CTXVI8f/2?=
 =?us-ascii?Q?sxB+/8M1c6rDAGLeQqXnXNvn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r3EFm1ddRO/77g7eLpwQxGuzjH4qSpsSR/I246q4xCFVriB6e9LpR5lIiv+B?=
 =?us-ascii?Q?ctQ8BdHZ96k9I66P0YoQf4s++T1uDjBa97rRiCYuTWmVySHEiKstN9GaVr6G?=
 =?us-ascii?Q?qUg8c1d1yS6DqUcwISbk1S6TIqFOzNH413FWSnu7/wIeSnOn1kYuNDfy7JyO?=
 =?us-ascii?Q?f/MKVW51LVZdtOQ08LaOJKgXriblQnoTFsUFIyTSfGLyq2ZkWYFkzIcOCK4T?=
 =?us-ascii?Q?zpPo9Uv4zDURS7FzAIW0DbU2xN6c2DDt9LFVoSxuJLgqqbAaucEAwozWG8Pb?=
 =?us-ascii?Q?3ucm5yQyhntiSDX1+8eu1Gpn1BLOpydSQh2SQ/m6xPbggjcTTV8BkFPKZPTb?=
 =?us-ascii?Q?5PyPBVhocq3cN4nyVCqu+EsmQjpNiimZ469vY+2ADXAhnXFmLqLmiJJX76Wc?=
 =?us-ascii?Q?3tNtya51m36XqTmoZ3wrZTQiuKOoOacuayvNFkhNBLpuckQyph8h2r3kZeVe?=
 =?us-ascii?Q?NeuIQXjuMb0yIZbnzGOMIt68y3dqHvYVrqX9AN4RP2s4LqsS6J7nJZPLY0Eu?=
 =?us-ascii?Q?eu6SHNZHtAiHumMh90NMcNlQHGDvu8dSOZ0VQkIFd+zx6UTv/Yn7skkfKET2?=
 =?us-ascii?Q?byjR0VJvVtECEbivV0dp+48wCI63zUIvxrKI7ypp/VxIAas+HS4sq9ZE0Xa6?=
 =?us-ascii?Q?taLTxK4tfhj9rIwhjuFsv+trb4BgwFZ2WDya7FKzpWhUqZjYrNjS2Xwxg81g?=
 =?us-ascii?Q?GJB4dkEa8Hd2JZagv23VU+0q/jZ0pDb8+71EaFypf4JIjfwJtWFZqbQTcQoM?=
 =?us-ascii?Q?lZc5CMGPjpMsBkbZSobcL6v0jOgEKOOO6cBqteHoTtqWOZwo3FVo+VYkOfOc?=
 =?us-ascii?Q?QujqueQIXtliwUanAAfVel7kbc17UT48IctUflH8gaS9L2R4rXBA6/IQ8t2U?=
 =?us-ascii?Q?Oim/mZI0FaD5zEELxTOqxsAJ7bR3mddDWTNRRaKFBWrYwhae2byfKAKrBgkS?=
 =?us-ascii?Q?REEUywK+UWuqktsy3Eui7LNys0LIIGYLiL6SLaHAXxWBKXfJbtlZ7MMZq7rZ?=
 =?us-ascii?Q?g3JwDCeHWKgZrhi94WYcNneFGCRgtuPLgSKhz1azMX2iozioLhTzfzOWkHSU?=
 =?us-ascii?Q?g/a4nxIBdFTOLy5gtRzcJjBxTM9bKCtBPLFoUwmJqxg7QH78PP7s/Md05uBW?=
 =?us-ascii?Q?6Ik+W9OPrQ/iyW2AphN4/RMOqZlkrIIkAYvSrITMT3EAmsQgZbtB3apAssbn?=
 =?us-ascii?Q?vuUuIXSe7ZG3Y+4Q2996n/6uLgYH4YffUiSh8Qrtzc7D2tuYi+NwCJIdi3VS?=
 =?us-ascii?Q?Tiu233fjuNU7p/ELLWB65fLSxJXlJOVNmMbwfK3PhSTVzr10PxA2JC5ZGMzA?=
 =?us-ascii?Q?RUHajaHQoUTXuXf4R1JDLX+QH0VTjZiGmhIzJkpvLTCpO8+R5lc8kFDDdq/u?=
 =?us-ascii?Q?SO1R60+QntUipp8208NrrCXCqumEVWNWBj+C4WXFSJA1We0XirKClzjeahgD?=
 =?us-ascii?Q?4FvQ1y56/RSxIh6pbeq+wur06Lgwnbi2/ZmcXiDzeGNSLDmTMEZZYaX3tVOt?=
 =?us-ascii?Q?C2x7bnNFuoDBDLS7F8YH+Qe6/xvf1pPMpje+W3UlOyiesbvvm2P1DSjzvhpv?=
 =?us-ascii?Q?XsQFe1VEtMIBHAc6Fwvb5/IFKSM/LAqBcEUSUkHR2uPCkd/Up1OwAQKZuhbv?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T3ILUFyn3SaDQXuHCp0Wd7i/7WThityM+GJUgdyXB8soAQssOKV7E8lC1sHKg5iNh+3jN91WzOhqy5jJiSBISe1uWfuzv2M/5j+Bs4i8fO8bJoIhi3vLWHSy4h+xMUPIjMGAj/5g5sUbPJUfYbwaCeMQa99ZAVVyvl/NfwPS1i++4C4X+KoRN49UpnYjajsAUYQosyATljngGm+HpssV3wjE57QJT847uY7AvIr7r6OEj7WwgWDoVwAqyRHwxymKlYAx4RlYfwkR6hCsDHFuzUN7NdEZqh82rFlCfk7osOqx3l4VptZGbIrp9In8rIZHVeNEjzOAnTFsL9CCly6IE1ncckQ9xaq+zar2m26LwWAgeZ1++AoKSuQzoPQ2R87H84YGfSLAOV2SS1AMPy6DMlqgGBRUAg36IFIzbU0Aw4oZm1hUbcWd1pxbQ3zkFjtE5zyNgB/kverRO5ac25/kQ7Jtn3Z7HBt8X4qH4N7r+9amH04zicLvQWuJNkHMFyiwq0uIBcNmHK9HP4Jf6znkw5bnuDy3m2EOL99rwdNvBTV7Yh0aFUyPDJamPYUIgP1lWonevtMPQsjV80UdTvxGTIWB9fINRPwEXgeRnVbacsc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0bdf96-7a2b-4ddc-f8f6-08dd07bed84a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 10:50:41.2100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HTB3cUeGooK20Ar/g6SpwQaglggIXMibRq3S19OVoOgTNFQNwwKg4VpG6OAdTev1ROC/V+8OM/KuXUP3w4iafg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-18_07,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411180089
X-Proofpoint-GUID: 0tL893VX0PLGvXHW7OuKVfbMuM07Pm_2
X-Proofpoint-ORIG-GUID: 0tL893VX0PLGvXHW7OuKVfbMuM07Pm_2

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.

For an attempt to atomic write to a region which has bad blocks, error
the write as we just cannot do this. It is unlikely to find devices which
support atomic writes and bad blocks.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8c7f5daa073a..f779d8225667 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1255,6 +1255,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	const enum req_op op = bio_op(bio);
 	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
+	const blk_opf_t do_atomic = bio->bi_opf & REQ_ATOMIC;
 	unsigned long flags;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
@@ -1273,7 +1274,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
 				   choose_data_offset(r10_bio, rdev));
 	mbio->bi_end_io	= raid10_end_write_request;
-	mbio->bi_opf = op | do_sync | do_fua;
+	mbio->bi_opf = op | do_sync | do_fua | do_atomic;
 	if (!replacement && test_bit(FailFast,
 				     &conf->mirrors[devnum].rdev->flags)
 			 && enough(conf, devnum))
@@ -1468,7 +1469,21 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 				continue;
 			}
 			if (is_bad) {
-				int good_sectors = first_bad - dev_sector;
+				int good_sectors;
+
+				/*
+				 * We cannot atomically write this, so just
+				 * error in that case. It could be possible to
+				 * atomically write other mirrors, but the
+				 * complexity of supporting that is not worth
+				 * the benefit.
+				 */
+				if (bio->bi_opf & REQ_ATOMIC) {
+					error = -EIO;
+					goto err_handle;
+				}
+
+				good_sectors = first_bad - dev_sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
 			}
@@ -4025,6 +4040,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1


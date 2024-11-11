Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3D41991A8;
	Mon, 11 Nov 2024 11:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731324154; cv=fail; b=qbysOi2GEOMbsjRwFp7mN3BY3yA6kOak7wl3VGrh05E4e4UbbFTV+vNz0LyttvV2WibW0uTtRUtLGoX0je9XHBanQpkwtAJ3TA63ICsAQqkCc6NQExmvOK+dGWIJwuhjq5zrK67vo9jpAhok28vLkZYX+WYkVWRjDIDIAF236OE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731324154; c=relaxed/simple;
	bh=T4yGx2wrthShkCYGE17VcAijgCO0w8DzhpTwGncd3rs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IEfbxwF1Tf80Ot3+9luVZQaxvPAbz1dBwr4eBo/aux40mZVk0PxlJNzDHWpY2/9oEtshbjbTQw6KFoM/ouIYsu5YjuSWBzZiaoqwNq3NU3XX0l4K7G/kF39MBbbWwqofzCqltYq6Gq1NVbsbdcIpj7DNchT1oxKkT/I+C4FUVVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hk8jMJpb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WLyEbvQp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hk8jMJpb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WLyEbvQp"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9sp9h016893;
	Mon, 11 Nov 2024 11:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=bvVqVn1C+fG6UvhbHOsRuxfwztl7EmpyqXk8gHMg/BY=; b=
	hk8jMJpbg7g29ZA/cqdPb2lF6ypuOYBtuia5y6IB1vmWS1HzNdgNB3DVeJZ1cgCc
	48LRjn3dHu2mnKDDdby8YZDwFfPM5JyQWFHjh3AOW9nZ1pizWc0yAeYeaHwy/u86
	nJRdHnH9yWWg7S+a/I7iYCQ4aTqVZyNV4s1k31IIbhNK58kBm/qci7uobhZP3iMT
	b8XHRtX23B/J33g/P4esu3PbCv+XrySq1toJm94WBxt9njhoG4OxeLLoaCOv9aKW
	8tGhCn1elRlTrD58LILy7Fsr1ob5fIoEZ3eqHbJZ45+HE7DbojDvhNdZ9SG2Kmra
	IVOqU8lqdYoBp/iZmCBbYw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0hna7be-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ABBINoR021562;
	Mon, 11 Nov 2024 11:22:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx66p8te-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fir79+uDBS2DRxg0KGUGBb/5/xyVviDVYkdPQ+KBQ/YNXT02Af7KBMy4OSRGGFRm2tLeXSrgw5euomcIoDlS3vZHTp5vDahLz1TSgWDhzTBaHBpdWX9u4LthpiL+1u56wrkcvxp3VBw44IHMp+h1ZNsiVHTpxH0HBDnvhiz78tIeYSaL8nT/iiKE1e0ibUbyGhznKJmolhVtolmtf0ufXpLVAyibP6gQr6eZQ3DAIY2XzSPk85iG6wMmo9Pb8DphQpA9nxntUor6h4Hkx4nJ/Bg00w9KmUOLisbNT8GUuW0/vRBY8dNUBNcWvLqXD3qb33ufs/GqQ0qaK8JpimXukw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bvVqVn1C+fG6UvhbHOsRuxfwztl7EmpyqXk8gHMg/BY=;
 b=pZZDFOnIFRIWY5CFINbz0GWNgj5xPPwQ0ho1XExuuVQ5nJsenYw+e5T1FgobMQvZ9NoeJufXPmUW+tXKkQtKCAezZ0MYTPrAzHbx6mw+y01FAK+hRtAVgGDpeoBvoVZsZ7jjsBUGs5zmFzp+V+dWr5RocEVMWLjm16chkWWB/vP/Ig9HxAGePXXN/B86y063liwM7OymA2zjzkWlglT5OHK5RioS25xlqomWp2CLQRdipGFlULnRlPRJ9gowv8G9BmzFtyvj8SVArTWlKupOS5mjblBbvlxDY99ttx78fSpRodU//q+rlKA6Ve/2o7HVwwQXHfBHOOMr3xXxV/211g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvVqVn1C+fG6UvhbHOsRuxfwztl7EmpyqXk8gHMg/BY=;
 b=WLyEbvQp6NNEd0jNMAQCD2xe93r2D6k5KtH+V0x4dQMiD2tkwESRNpnOFJmLkEXorJKVnnRjMWSoeHagIjDQ2Jfx33cZt8H5a2I4aUCROBUAL/lPZ6mDhj8l0rjWuHhdkd27Mz0Kk4D9msZudnyOAp8B0a/lxuXS+wv+4D6hCEY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Mon, 11 Nov
 2024 11:22:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 11:22:16 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 6/6] md/raid10: Handle bio_split() errors
Date: Mon, 11 Nov 2024 11:21:50 +0000
Message-Id: <20241111112150.3756529-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241111112150.3756529-1-john.g.garry@oracle.com>
References: <20241111112150.3756529-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::31) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: c48498f0-ef36-4ae2-16e2-08dd02431914
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g/VG2DhTBIa1yYEuBK60HfEqzE2+Xq1NVRquS5Zxs1w/wUXwGOJoC2xUiwm0?=
 =?us-ascii?Q?qSr7dtEu+6v8c2dn71aZhAcikjSbmnrCwYdCql1iWbIuZ7NIIJRwnzpZpbbT?=
 =?us-ascii?Q?q8OdhEPhVrQrpoh/WKn322gH6CsLl3JC6bktKL7qMhnE8dp5ld3zhaPCzxDA?=
 =?us-ascii?Q?YCRrGG4FiWPGDoruXBi68PjkNDErkzYcLuFohbMxdAlCjwMLpwxCfhhRMxXY?=
 =?us-ascii?Q?X32O/ltJghIzYKpA8I8D/5LFoimq3cW2oZzwgc+2ZKDbRDWfU5K3Pjgq7/GV?=
 =?us-ascii?Q?6YGz4Ta5iEkd6qLmpJ775cSsPQVN5zy747K4qTALUuenHSALXPo91qco2pa0?=
 =?us-ascii?Q?TJNGrUq4BElYEo/xVl+4MvLwJhtAjnzHH0y6chcG2doaTZfL57DDRXFShqQd?=
 =?us-ascii?Q?Enc+nBbRI140Ty132SIpsGiZ5r74hnzL4F4Zcst9RDtPfZ3D+HewfFyJ1Ei4?=
 =?us-ascii?Q?t/QElagn/fkIYrRQ5R+2OPE+JqeQX6d5v49A2joO8O4nOR6UVIxTWynz3LnR?=
 =?us-ascii?Q?xA4Ww5f08GDhN7fdusJG07ZZq0NKHmMWYYh6S7VPinqZpansKaovR6bB+y5l?=
 =?us-ascii?Q?soUZLm+1EhhpNNMtr40OxgeiV17vWFhgvSUo58pYBtqsIn84hMVpLstl7hNF?=
 =?us-ascii?Q?dbf/GdfcYcGvblb/j8a0jupdyGxRiChdX6lfKuRFblJU/uL9TvCuaCbrO4jj?=
 =?us-ascii?Q?9l9u+vT9BcwEJcGaMG1f+080V6zm3pVt9yy7HX5M4V8OVbkFJDfnLYFOYJmr?=
 =?us-ascii?Q?PJS7GrCP3AxhiCZi2yCfYocxyLqOPQF1iriM07RI8tenmL0PNGMlaIBpASws?=
 =?us-ascii?Q?7qdh69G4SyWCSUZnxYf00GxYKV9Mhrvu9FV2lLIhbKiuiMRQ3ZVHI8f+SC63?=
 =?us-ascii?Q?p6661n1WNhCaVuXjnkdfhVTOrlUscgLl6PW3FHwXp9dP8Bmi73l9s5YHlaE1?=
 =?us-ascii?Q?RHYRpn9QdNyt7Are6iLkuKPpLu4Dy4FTUYpTn+2dNu5gS/AwUXp0fRXjP5dk?=
 =?us-ascii?Q?2qJGfcZJxzFFg4xqQ4xLubEZU1x44HrxgFy8N5fb5J9V10ZfXR6HulkVYnO+?=
 =?us-ascii?Q?M4t5E01MrWa3+v7Rx+gIeQE3QkWn4girt8F8yYY3TAbR5Ie1CXozDkac+Iko?=
 =?us-ascii?Q?1Od6W6YD05PJ7+s6VVon2uCj/GRk6nREWYw9HoBRzeJ4y6LmC8ZrVgLmOahO?=
 =?us-ascii?Q?N2EjOmTF2Ezr5hyLtsdeWSY/UNfCHlMQ4ymXPOfi+t0RkbaTtrVzI1MCpwbu?=
 =?us-ascii?Q?rTx5famq6UcNFlD4huotcV3P/cyB4t+QZNapG+i2YZkbR+D/hlPoIsNtD3vS?=
 =?us-ascii?Q?W4E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dATdYrBeLGo88py9ro3PA+RI2n/w0EFNW6QFf7S8cil6wWxxcJy+umAiJqlU?=
 =?us-ascii?Q?Phe50u00TW2uJw2SSYpv4RbC28yn+UBSySgFqNUlKG4jUE8SbWBeSMRQKWTb?=
 =?us-ascii?Q?CC/84xYVlaYzVZB2vnUdlLLfrZcN5DOSiKhPFtjQkpFbwu8aDu1aCtnh3jmS?=
 =?us-ascii?Q?4D2hqh4BfZAhP/e8oyTh4611Z+B1UC9Kbljc+2jf074bHM6j5mN8LUs6ubXL?=
 =?us-ascii?Q?ryhw0SaPKEjCkJcXsKHFFrRWurlelph29l/KxEwCsXE2pvjIsiGaS6MvarQf?=
 =?us-ascii?Q?EfJk+jNWnUjDBls0iWtUNq04zIPIM0JgWxSHPpin5Rrs0ce4ovGfXXZMDnAf?=
 =?us-ascii?Q?4pTLBfrItyQGRh9vYVxegdpfP/5tauCOdXzpQa2HuB6SCBcHr/Jjdzw/86VY?=
 =?us-ascii?Q?BNVBW2y0O4zN4elS3v1fEgv2YmuPQzKhQmWghMfoXsd9gRynxk+wIluIdG9K?=
 =?us-ascii?Q?7jjvqv2VUPKXI+lWZBdvtbuhTX03+Rgynx93tfig0t+tC/qk+ANsctFf07CX?=
 =?us-ascii?Q?08YjjHZMYjq5aaCm8ovh3ercmqa9jZ70gaDr6UwhDkZnUZkVFhWuNiuE+VUI?=
 =?us-ascii?Q?y5pf+DZBwWKqjY5EEX28v6Vxt5b1gahZLW64gCT1kkhe3IXEfQl3Dc1I5RS6?=
 =?us-ascii?Q?mxik+Vi2N8+9H2OXwhuBWLq5vs8s97NDFyVOpJ6nlrNfppQukOn5k0yuQu+p?=
 =?us-ascii?Q?RSPlyFV2MVU3ELI6A+4wDimNb8e8yF+ZNfL6DfSDv1y6u7hDeEEo+G+UDgnL?=
 =?us-ascii?Q?BSHDHGX06GZE9uafiYfQyz7z1qNZ+E2MldfMogZycAIVS12TiWKlEm69b6XR?=
 =?us-ascii?Q?n9z3EceJ7BIFgaDTENdNJnUNnCcPDpqfwuO7pMgbETHQNnRPj3t+4ASJHEzU?=
 =?us-ascii?Q?/iQoUP16FaO9nz0iFZ78UZ8eqf9Ftlrsg8dVLtkHed+DXYxIGYH3aB/Eih65?=
 =?us-ascii?Q?WriRNm7WAzyCPzA+4v36dFThd6XE387xz4ZVzMdekRWFLRL8l0qHwvDVRyDT?=
 =?us-ascii?Q?wdKguqtp88zyLNStFrMQ5tXZe+BXVBdTvr98Bkqclyxf+RenrhWfBmH7+2wI?=
 =?us-ascii?Q?BqnQKdZ/KZ/sfSn3iH+fyVSXLZABBS2uNim4kCr/2SjFMFw/fvmJZFOTaxAy?=
 =?us-ascii?Q?UKaXJLO2xF0mP9gCXRvu9enR8OkjicxioLe0yQ9Nr93em9DA97D2vob409a7?=
 =?us-ascii?Q?/fdrA1jKSz9D9q8Os2UlhGa11Aj+FTbpr3pJzWSi05OerMUSSYW2z64WRO7p?=
 =?us-ascii?Q?7BKnwfDOLhnOtw8J0Ig2grTMHRDT0Mpgkn8FcqhdJek9O5lq+Qw6chsBR/TF?=
 =?us-ascii?Q?6fgD1d73Cti1GOKK2SM9MLeK4jAI+eM7P09c8GcW6f6GlCJ5XcEP2dfaQzMc?=
 =?us-ascii?Q?6y73tC9j6Lktd4Ucme/0+kCkBe0YOtVrbGACBtZXkvd+5WkKQ/mVsth7d/5s?=
 =?us-ascii?Q?GGdt+3cZw63s9L27HjCKEFP5AZ09BHIivCtegBYCtU7z2zvO+cCM+vyYLGof?=
 =?us-ascii?Q?uYkllV+E3/CdFvwNmNobY4P1k/C/suKBxAK5IKszLX/BkZ745lqTYK+d7aHe?=
 =?us-ascii?Q?2K88YYEPInvZR5O4y4WimkFWuXWe723Jmk+1q08BF22woYPXW2RKDmKQWDsf?=
 =?us-ascii?Q?KQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AsqWX3hqD8UoBB1f67WOZLsxbul40vviuE2zUyBJU6Ta58sbYMGbPIAqXHwR2yNCLsM65cHbEEQCjsKI4C1yxXbGjZ0bWTh093h4Gm1FGaeKMJBPbVsxLNkv7gWImRZ1/4RHU/xdcnaJ1THG2oVHQUybAjpm4B2iFqYzQTrbxUuDcL2ipoFEKzIXqk1XYFuYqvYe8ZdIPpMW9olzVDnsOdEQKT+4jkS6PoDrqSLnftzfObwhs6FFGi/uKNF7scNCDccrwp2tWcebLgk8q6w5wCifCQ5sIJg6OAJyjPw4U0eAtx1D0nk3IPAQLN5+PLIPyPpWvrQSvXJsompY6zy+V6gybCuy2dEFd30x3ZnNaZyuVJ5Z3CPLsMIiljoVqqf9ziScxVdipgm6Ax1uOBoyKHzYEGFEV45h3J/DzqFXnuJEhHDo4KsXRT89ygbW8AhSHtbDGfznqbz84VCr5ZthIghNVUCHGB6eDpUvTz98myoq+ExjB70ca+JzaKXuYuDNnVILY+WXPLY6lfeLP+Inbozfk7tgXGWGfrTYGf9YhJpjfts7F0P0qSkDd8zu3TNv+3ctAQd+NTamBof7Mkf70RwufuQVBCvnWsaPMP++hu4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c48498f0-ef36-4ae2-16e2-08dd02431914
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 11:22:16.4588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxynCyn+yHRze80+SW0H1ovbMGf8sdjKvT314OaFGJk0T/9+JgAldvkXzHzqm/0HrA7SHP3eReRT6Z0ShhDdzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-11_08,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411110095
X-Proofpoint-GUID: UPCKQt3NsMrE1r1jkL56-xVjbTJU90Ql
X-Proofpoint-ORIG-GUID: UPCKQt3NsMrE1r1jkL56-xVjbTJU90Ql

Add proper bio_split() error handling. For any error, call
raid_end_bio_io() and return. Except for discard, where we end the bio
directly.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ff73db2f6c41..8c7f5daa073a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1159,6 +1159,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	int slot = r10_bio->read_slot;
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
+	int error;
 
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
@@ -1206,6 +1207,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1236,6 +1241,11 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
 	submit_bio_noacct(read_bio);
 	return;
+err_handle:
+	atomic_dec(&rdev->nr_pending);
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
@@ -1343,9 +1353,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 				 struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
-	int i;
+	int i, k;
 	sector_t sectors;
 	int max_sectors;
+	int error;
 
 	if ((mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
@@ -1478,6 +1489,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	if (r10_bio->sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, r10_bio->sectors,
 					      GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1499,6 +1514,26 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
 	}
 	one_write_done(r10_bio);
+	return;
+err_handle:
+	for (k = 0;  k < i; k++) {
+		int d = r10_bio->devs[k].devnum;
+		struct md_rdev *rdev = conf->mirrors[d].rdev;
+		struct md_rdev *rrdev = conf->mirrors[d].replacement;
+
+		if (r10_bio->devs[k].bio) {
+			rdev_dec_pending(rdev, mddev);
+			r10_bio->devs[k].bio = NULL;
+		}
+		if (r10_bio->devs[k].repl_bio) {
+			rdev_dec_pending(rrdev, mddev);
+			r10_bio->devs[k].repl_bio = NULL;
+		}
+	}
+
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
@@ -1640,6 +1675,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (remainder) {
 		split_size = stripe_size - remainder;
 		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return 0;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the fist split part */
@@ -1650,6 +1690,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (remainder) {
 		split_size = bio_sectors(bio) - remainder;
 		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return 0;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the second split part */
-- 
2.31.1


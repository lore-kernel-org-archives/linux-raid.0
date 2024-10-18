Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4B256B81
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729269705; cv=fail; b=qqVwhcEz/V4XdcpbRWDuAjng/kt/OppvBk9Mm23OMo8FuNJie32Q+TzVQyd2TkAaK7hm39Zgxc5xBbj/SmyIKtsBXNNd2syd3RWRwMweNnkeJHRaZBcnwGfz6vT1PwTF7plNb3wCx1h9+SsgjPPpYZZIcqrrYVVeBRPQ8Zge/iA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729269705; c=relaxed/simple;
	bh=tpSkobIGH8xjruW3Ai4Pbvknmfe7ll8Z9a0FgUiCVQE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sP3PnLadHSE9s51IX4TdfvDHLFvCdAhpBa0uEo4H+kOrgRqeltdHz4uW6hDjcoypoXlKU+ox8YuYNRFXoeG8izSWQmtjXbcQCh3UOQy9Ne7YkCEN63re+4Eg5Wtoq8ViTfHVh6frKJ7W/OeSg/6VgPS0HlBNNz9quXbSsLsMtpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=kEJDaDHl; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="kEJDaDHl"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49IAf4xa022608
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 09:41:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-type:date:from:message-id:mime-version
	:subject:to; s=s2048-2021-q4; bh=trxz3O8GqC+skP0kmQv+vfl8fE6ZXKt
	fYv6JCCjnobE=; b=kEJDaDHlzSSbDUNMphtR8Lly8FzXxjXx2MWz3B8HRQzyb59
	eHQSbwtEjLTluWmxO7rUN+BXajTajRtRfQFLlrDZbM46uhKyY8M7obD2q26bHjTj
	5xFhNnlWpstg/okU6PZ5g72B1++p5Dqz6C2qNADDuj9eTfZp7ZXov3bI/4RuOjUP
	KgFwwDnd4ZBeZsK9Jnsptw9yRn4FJQrbz5UAkJGT65CXLR/qbqmjE7eC41DDyUS2
	teqGxQre3Chnbep6lcqHt062bbSLriaTSms9SC+2VU4tmNH0mW2glBb2gHCy0V8l
	RSZHHit3tntm0OfE6erJ03llH0UznEtJIshtLEQ==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42ar2ddsuk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 09:41:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nxzOgrkezb1cddZdAgetV47G4p59sb2+TXPjj0owS5RyXn0iuqPILaIHeoA4LbcUhjqpTy0YhqSJ2M7Sn5LlAlz34H7L+pKl5T06fX+nofyxRSD4iGcMVVHiodDI7mTBx7RXYXaa6fE+jpS2GjeT0dxIa5y09kAe0nfSapLwsGOfxAVRrPb8SHjAM4xqIBWzhApvYb2pGP20UV5NQ0OBj3ZtRxiJP3TE6vS/DZ4I5TrHBBG4bNVOSuTf2rPl0rUSqteQiBzkTj6UUtFi3Eem3dQRAW0dPjuKo7pU/rriPOn+BStUjWagJlp7vfwEZ/Aln8IRrn2AsVGlv5lFDRja2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trxz3O8GqC+skP0kmQv+vfl8fE6ZXKtfYv6JCCjnobE=;
 b=RYHPXSrtuHHvyt16p4/K/9nPkjrRqrx0Jig1siHV7JPp2i2rgqtPNF7N5FC7TWPTT57Nlqw+Gw0AtgR5KV3RUq/U69ve5loQVdC/FbOSY9gEwAUyAFVLHHDLLMfeVbB22Hlsr3fS4lP/5pulyetccJdviC36BSEwdJTbgvCVYZEK/wMcIMJDgsT1ZNSL97HPY0B3Cq8JhB+V4dSx3FZi3gCCplf+n3uU1FZoCbSSRhbKk47bcxSSLTGjadwqdVqh2x0WrbU0iY+Mu+k3Y2PkRPJvXPJ243vv29qYn6S+3CmVlWUQTwvgNK5c3lS4s47Uv7nXvgx8n7P06R82RpSZOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by IA0PR15MB5864.namprd15.prod.outlook.com (2603:10b6:208:407::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.24; Fri, 18 Oct
 2024 16:41:39 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 16:41:39 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Li Nan
	<linan122@huawei.com>,
        "linan666@huaweicloud.com" <linan666@huaweicloud.com>,
        Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULL] md-6.12 20241018
Thread-Topic: [GIT PULL] md-6.12 20241018
Thread-Index: AQHbIXyaQVoyAii9w0i0bkt4RodQvg==
Date: Fri, 18 Oct 2024 16:41:39 +0000
Message-ID: <9C34128A-7886-47B9-93F8-0AA772EF2532@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|IA0PR15MB5864:EE_
x-ms-office365-filtering-correlation-id: 5d9f3d32-d5fc-44e7-40b9-08dcef93bd66
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?uAZelXNFNIIjsuw+rePUTY6El8gSmFjlU3BTqGPVs27GL9JWzZOPMCtF8BCj?=
 =?us-ascii?Q?1sI1RtHJrYJYLaE83a85cIPKup4vBsdbd5+ynhCviiErERXhUzsmeXQwDHea?=
 =?us-ascii?Q?XCNaXIxDl6JM9C1Pc02wU2IS9Sd5SvCBww2O99zQ4x3sQ1pvk623OhGCxptb?=
 =?us-ascii?Q?Z1hOOxGxCstCxI1NyOO9Co0zq0m93tjv5I5LcPZTEfjQZVysLQk+WCJ6MKhY?=
 =?us-ascii?Q?jSxL/RBMB2krrUm5cYBr0F9Ind/otacXcRVhbM4HhjOB51DpAxpT0MB7m/+y?=
 =?us-ascii?Q?dlKr1hZzIjUrDHOnIunCCQZFCCjotZ2VhEsjWJQKFLal/ZBoVjtcsB7KYyIz?=
 =?us-ascii?Q?IV3gg0Xog/+lQ7SLNxsO43sCV5/EaEdND/gyBTM6PsgkO9Tc6jJUnu0NFwk8?=
 =?us-ascii?Q?Wy4GELGOJsO0vrUwYjTx0wjyRX0pOKca72Bp5EwVmSW6paqjEIRpY+2rSgMm?=
 =?us-ascii?Q?6y0W3nC8QCdXI5u3mkXEL/wO6ZEIU9jthn5g8vl9jSV3ygZlutieHc32GNj2?=
 =?us-ascii?Q?TomjIv+Hh0JV36DIEAieJG5EEgiAXkfNFrs65f7C6Iy39b3Ki2WpRpIa5UFu?=
 =?us-ascii?Q?31NK7eLLz7HszGYDfSpIOO+C6lMh6m4Vz8RmcrSN+Hsd/v10a7uHAKdiuoAc?=
 =?us-ascii?Q?pT/Vxe4ace8pPXeow5cO424L65BIQeN7AdBJ+BBmsQ1kSmYQC73DFzMlpP0O?=
 =?us-ascii?Q?r+oJLHjQYuKKaWbsoFYn6OZciKeHfF2Oozl5n7uXxRmMOxyMq+OXEYYH6Vpt?=
 =?us-ascii?Q?okNO3IWb1wSxFpuD0m09o+gXs+BZWwE8g81iACoXP3PwWkIwJQOHgQb3ZFtw?=
 =?us-ascii?Q?sH8uOms5485vCRNezZ6ILBqTrojmQIaKyNFFUG/eZ/UOknvBlNs0aclH/hZ0?=
 =?us-ascii?Q?iQbt100GH6c8DPL3l+HQRUq43Vapl6IA4jkoAjTLF+BpXZ08Oeh1zWmCQM1f?=
 =?us-ascii?Q?eAsp+zatVgH4f4r0n3c7ONuftZnIepTzttUfucppe/F5SCWY5uBey2Nph4GC?=
 =?us-ascii?Q?LQu5ioCyrzPFKeKRn3CHTChUqV9Brcv+VGe0rZZAgsOkE2xZ/toeq5nbt6+s?=
 =?us-ascii?Q?ff1tUAkXLRwafMc1Rf1eN4nuwDoIzSsmDh6nATWgeB9rc0vX9kQO7vzS6Nb4?=
 =?us-ascii?Q?YFRd+BK0aEZblAMokamFCxc0KNYt70sdMXEmv6jDNQfdbkHzx5x8cES2CAh1?=
 =?us-ascii?Q?iZI/ugVh4wahhJ8NDnwhLjIH3bTCJAI/kZydqXmPNCv6/KfE/0fq+naHKS4u?=
 =?us-ascii?Q?H4jkDHkIUvikT9vbzPCQJO00ZG0ggbcZKbzU4+SRizw7BaMSystV5JgydACj?=
 =?us-ascii?Q?0PSXA/2A/b9vWH+9sPuBxLPvFtOkXcWdvfLsTLJJ3Keo85Yv74pl2XpfMgWF?=
 =?us-ascii?Q?pkqMc4E=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?bG4vPUlXMvAv04qJnqO7+/hh+FNmY1GGdbhsqIfADj/exVmvJX3K4I/kThxf?=
 =?us-ascii?Q?n5G3YzvDLQZNdDrI64Ez9SBW69YSLQZ4GyxFZEGqSaDV7vQd9OZ+bXn5RtGl?=
 =?us-ascii?Q?Jh8Fl+3QKPxusxPscY8Goyc1Jpaqlx+Fg7KbIzayIc90e+PSMgwbBVexytEj?=
 =?us-ascii?Q?8Vh1opfW1ym5tYZVhZnwnVFt9yBLseq8fC9WLm+3nqbyQ8w7CRVpgyD8h1eA?=
 =?us-ascii?Q?KqfcJYad+3xOdfieeBk56XuX2WT76QFQiHYRFbLozBkIKkAm0PUS87f1Z0F2?=
 =?us-ascii?Q?/IgXHvEu1Wn+bSHSm2n5cHYom+AD9k6xvMCUT2nD5+AfIJmMN1ua17v7sP/P?=
 =?us-ascii?Q?kXQ4B7Dx3vKcrW5NlFdEkvydAG5162qG2QOlCFwsgssZnczdwRdjLdFD2sFI?=
 =?us-ascii?Q?CIXNsjCoGH26xAIPnGB/AH+yoCy2JNLu5G67kg83akRUzIlCOf6xAKWRUQWl?=
 =?us-ascii?Q?ebmFZv5e4TXrKgCbu0uakDfVt8UwlNpRxOTrKMQYzJ5lDzFTyrZv6bc5dKhM?=
 =?us-ascii?Q?amUJpc7xhiUd/12DFkD8Tm2TjmNgcr/EqudWGOzoiSLHy06bv4LR2m/lfEYi?=
 =?us-ascii?Q?/ly7LVtls+0fE1fedj6rsY9arnFnxgdPF5uTIdOM2Mm755PrTtdXxNd9RYrp?=
 =?us-ascii?Q?ImuyRrlaKaYBv6n6mCXHzdx9G/ITDAP7xgtz5w0/futI/JU9QxDaeaIcMJ/I?=
 =?us-ascii?Q?BXlFrXZjLQF6wudZ/q2jHrDRe8u6dtDGg9OTKREp0/eJZNuPeNOQC/TskUMz?=
 =?us-ascii?Q?QKZv6+MXfJIhw6kx2J136lOJM55AojbLc5F3c+8hYYAC6p2l1y8TpwvEktt7?=
 =?us-ascii?Q?i1cjg1Qx9Bx11j18ZTW6rH1qLQS3OIOLxt9+z+Oz+bZ8dTn1nGSnTbrkT5/V?=
 =?us-ascii?Q?SFWZJ7CSc2S0eGni9UUOBLJPArK9Y8S5oQzMQdMnZ6dKJvzN5R3NqaYNDQwc?=
 =?us-ascii?Q?NibJRKYBiPTd7C4I6ofusIzdrH7Vm8lsHEO3RfCSbZ2NRRoahZ8RBivBz5i1?=
 =?us-ascii?Q?icD3fygbz7qEU16mkoWX4gwp2UDJ6yAFCQor3kx4UvvvO7vh1EsZMix+FMeL?=
 =?us-ascii?Q?wphdOYFmSA53n4OND178O4mdJ7zA+9jgAJ6fRTrNMdagf015MXstmwSeDLtB?=
 =?us-ascii?Q?ksa08/33TQid0W8JKYxtCFBXYi/XSDRJ+8qRcvb9PyoO1vY8np57l/oljFvf?=
 =?us-ascii?Q?Tgo5WFn4j0PXLOhlZnYjEY8wIMbdi+hmBr3kWK1ygQJYp2ueWkEF6zJlmB3X?=
 =?us-ascii?Q?jv1tJExHo2k92p6H+LkPGfH5AepVx6KLIeBxuVSemboRslDpGSNt1aSAY+X2?=
 =?us-ascii?Q?0hUfqyUzNlprWWf+ZxpK5IJLcMn9em/K/IOTqrkc1T7rwRHfRiW1z3kFIjFN?=
 =?us-ascii?Q?tqiqOOpF10z/4a6A9GNThGZMETQW23tgovj5ta+FY2JEMNUePAqun8vjPseP?=
 =?us-ascii?Q?zzWtJDjoGDPNSs14TGigWR+Ox2LDg3f2otfSYg8L+0Xtww8gBIJGg3jGj5CR?=
 =?us-ascii?Q?03kDog7o3T9hp5XtFluCLCsQ76/mJCpjlNlAZ2r8N3YrDjezsq1AeEzOIPGY?=
 =?us-ascii?Q?8/owLOazHt2L+i+7hsDSPXrVpku5vhoVR0O6pqvothU6QRVQlewrcdksLUqs?=
 =?us-ascii?Q?dQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23DC0FDBA526A449AEDFBDC822E356DD@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d9f3d32-d5fc-44e7-40b9-08dcef93bd66
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2024 16:41:39.6041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oKl612YTh/cah4T6uQdf7SM0ZwL7umsU3O3dgoDD6oKRKFqz0GyIwYvtKa4FtUoQG68mqRlq8/SE0LqnoeDoVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR15MB5864
X-Proofpoint-ORIG-GUID: 3S6d28JfATK6209mnz2fo0x_WfAykcXZ
X-Proofpoint-GUID: 3S6d28JfATK6209mnz2fo0x_WfAykcXZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Hi Jens, 

Please consider pulling the following fixes for md-6.12 on top of your
block-6.12 branch. 

Thanks,
Song



The following changes since commit 42aafd8b48adac1c3b20fe5892b1b91b80c1a1e6:

  ublk: don't allow user copy for unprivileged device (2024-10-16 08:08:18 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.12-20241018

for you to fetch changes up to 825711e00117fc686ab89ac36a9a7b252dc349c6:

  md/raid10: fix null ptr dereference in raid10_size() (2024-10-17 11:43:43 -0700)

----------------------------------------------------------------
Li Nan (1):
      md: ensure child flush IO does not affect origin bio->bi_status

Yu Kuai (1):
      md/raid10: fix null ptr dereference in raid10_size()

 drivers/md/md.c     | 24 +++++++++++++++++++++++-
 drivers/md/raid10.c |  7 +++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

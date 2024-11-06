Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CC617995E
	for <linux-raid@vger.kernel.org>; Wed,  6 Nov 2024 06:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730875921; cv=fail; b=ZLONJL3ssYz5lNy1sgJV9/xGTsCS8dKKfnmfXaykEudalWVjAJkPutMCAazNAUi98A2GFWbOcpVnbWEpnledBJzNxJIeoxnJMjgSNl4TjlhBCZdjA0f2pQXafs0tlS2O0Rc3vMSji1B4Aqeoy5Vkkm4sB4mHEOzr9agQxxvA1Oo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730875921; c=relaxed/simple;
	bh=ZBQg6jCMZoVMiYE5dKLmJlg45sPjpqrCRTzRm1WpBco=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LNHjBT71g8pRKN4WkeT8LabbrBrXN2Ge5jJNiJ1IuIILRy//6CQ6LLuDJ4+Rkw3lkqr/h8F3/iyRJcQGt64WclhRarOCZraVyju57ZuaVps2gdjB6yS7L+DaLpR3BikAYr4o6JZv3coghtLmYKPHMpv0np9JcqWOd4qwlagCxY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=QuTdBJMG; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="QuTdBJMG"
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A66CK7i005005
	for <linux-raid@vger.kernel.org>; Tue, 5 Nov 2024 22:51:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-type:date:from:message-id:mime-version
	:subject:to; s=s2048-2021-q4; bh=B2h0xXGMJYo6e82jRmLHZchyf5PbWo7
	k23bwJzm0fAg=; b=QuTdBJMGfkWDKq0gO/tG0vzgvb3ws4j7ujObYPey6cGRKzg
	9T/FkPguamzkDuEgg3Mdg4awRGcoffka+LFFEmiZxKSptE548LBHIuZ0aP+n1E3E
	ysDHrqZDz0yz9CcGnwEwD1Jk6sqdfSapvE2JFtj2OfFFJTNkj4yrZm7DwMHOEnMh
	IeRiIrP6V8/t2hIp5mZtLsZPapJNmiUou9YQ13ubOW0x8ekc7pAce19FReAPlPGK
	LxbXyXBmTDu30nVOBtgLVK7m0ta9zjOwdV7t8kEXIEt5qG04GPkjbvQnsvkWM77k
	JzrurJcw5FAdorywB6N9Ehg9wYpxkMKz17m5d6w==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42r2c40ayh-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Tue, 05 Nov 2024 22:51:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=curfp0VVuHVAMVtpBb631J8KuIEL8ztFLAIfJQKr1nfoFayXcMfgM+eIR7IrShsWlojWqc3ctLTOA8DqZLY1zKnthF7Yk+82Fw0cKNa1ScDrndGcWVwWdC9xmyasdnGy8lggNlLKleDEYDbPEYjfDBsTp+vyShCTXTJQ1tybE2hqNTKIxwRxgt7YERUbt3QBdp4kNv7DT/Fp9A2lHa/8P/Y4NH9Sf2jJ7RXbhO25TUwzCp0jrHthmtQOCXVDSczrXv5ogAbnRgq1Vcsfg0UczNMV0IdUiOhSyPl8WtapHVuQQnIr3Ipr6rvVZwe4fQSAgbTOxeMUEjhHXyO+H2IKPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2h0xXGMJYo6e82jRmLHZchyf5PbWo7k23bwJzm0fAg=;
 b=MZes0UOhOR63NC12H2PNZ6vi8cljG/RiS3wxYsupML9tIqJQOv6b0I5FaUsMwV0T1nyE21FOAsT92lafPE7l952x7MjIgeo74+TsUGDPoFNKzgdjHFh55fP6TyDy1AYJ/Spk1FxfBlb6E+ktUNV7z1JGl7JMD+lzP9lLWrojbr22EALfucLIqFGjbET7o4O6TFbUX9FidchhYTLQaQahCKeDm1FP22UtHJck/J8xWsPwxZXwJHmJuP+A5giwhP1DtTESebJJ+37ddGdmJusmKkAtR+tk4WhUJQYXXDiRvhAPyLuIrHKKINbagav36d9g1Q+7C6kwODVbb2Wsdvf8YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by IA1PR15MB5983.namprd15.prod.outlook.com (2603:10b6:208:44c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 06:51:55 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%3]) with mapi id 15.20.8114.031; Wed, 6 Nov 2024
 06:51:54 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>,
        Yu Kuai
	<yukuai3@huawei.com>, Yuan Can <yuancan@huawei.com>,
        Uros Bizjak
	<ubizjak@gmail.com>
Subject: [GIT PULL] md-6.13 20241105
Thread-Topic: [GIT PULL] md-6.13 20241105
Thread-Index: AQHbMBhdetFpMHnRIkuxL3euhiID6w==
Date: Wed, 6 Nov 2024 06:51:54 +0000
Message-ID: <0894D5D0-A8ED-434E-B9FD-60B41C798B65@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|IA1PR15MB5983:EE_
x-ms-office365-filtering-correlation-id: f3a351d3-7f40-4175-db77-08dcfe2f804b
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?dtO6y/N5mX/cm2PRZ1Pp93qd4krw62Jmt8sClIBw8GJaal95egvo/cElpTMn?=
 =?us-ascii?Q?KDiej96wLpJrJm1B1gwhKfwxFXFFjpltTzz64TUO4L3QukgGxfogAQ57D4lo?=
 =?us-ascii?Q?Tc9vP8Bs+5RmxUxN88m+Dt8/NkXk2+IQBltv4qSNrOx8uNBPNgipdLVH51sW?=
 =?us-ascii?Q?3XqF1kyaqtZTZ96k4p1Sm7zGJqOj+DKTwXGZEJMMTr7iEK1xFYcv7/RmAX5T?=
 =?us-ascii?Q?Cg+g6fsK0mInh3iznlUEyyFbx9RunCmuoVAy+Pq72hIWy6jSli2zbLwzlmjv?=
 =?us-ascii?Q?K9fsDQHnLNhdyu3pN+30MnWtnuyCJJyFoQP6raa2FkzHIs550Gi4Uv6pvlBk?=
 =?us-ascii?Q?jW2yQcujBGpXYtQ2NvszcdqmqwWf5Ym//hdFsF0wFXDEiaW7VrLO9VGnY4cm?=
 =?us-ascii?Q?y2VKCJEsNL6qjwAHDVUJhAlwMaSePtSbLwJBOuJgDw+GMec5nBZvoxS6zE6i?=
 =?us-ascii?Q?oAGyQ5bm/77wtbi2DA3NmnGxv+HkQH7VaFRjIdcT5Hhfd6fgBhbrsszml2Yc?=
 =?us-ascii?Q?U/pIyNp/bNHKKVw1TYddJFTmgfnicOO4GF2ZXGLQMAzB1sQRZfw8jhHg58u6?=
 =?us-ascii?Q?4r7ja5lC2UkhK+7NHFXCHn92CD3Di7jjhPsBp4/4pcEr+1aSfJq6EmUtGFq+?=
 =?us-ascii?Q?zDqUPU5iIBiIKHAMocX/RRTcOzKInAwN1RUdOZTJ7lq13iv/VhZaaEWB+SJ2?=
 =?us-ascii?Q?mKXckRD75+NM8aZn+Knvzihlat+o8WW7qh61VvfvpObsjdIKHJVKF+voLF3l?=
 =?us-ascii?Q?vjnCKZIZoFKo4hTJt59EMf22P2igAsfnG6B89mweJQrL0KrPTduil/HgBYqL?=
 =?us-ascii?Q?7/wSXZv9UQf3C3HESD4JLQLJwBQsNsQYI5p4i6AdXAsMFwQNLTVrKdOx2/GV?=
 =?us-ascii?Q?D5bUBWNa2Sa8dcoylyxuiliABY78cfZLQQerGbQi/ykoun5ZDr8e5TaW2EwN?=
 =?us-ascii?Q?vfrbEwTGlUzhCpiXXvjpx7i0zBEOGnAhSWJJFs/1qUUuegNlJiLN8uAlu7Oq?=
 =?us-ascii?Q?EDeSzOzuFZhj3CKe8AeUG37OTDbdfpecen5Rh3tbF0b5n7NUDxvMkIgzPn4w?=
 =?us-ascii?Q?R8ZakC2nLV8xg3X21rAddTAnCUUhggtYP3xdTS3SjV8nHMrBlDJUBITun2Oa?=
 =?us-ascii?Q?ZRxptEdglhBJhDrjjPlHVX2hcSw1mBOHk5vo7cNueLjd3Yq/IoWAbDpaAHeK?=
 =?us-ascii?Q?3lArZIpSrVDzj+y+tO7xzB3eARSHOCtPI9lv0PLrtW6MDzqEtbda2d59LnZl?=
 =?us-ascii?Q?k6/jQ2VZyCVNW371lIVwcUMo6uyUAjQ79Y/naRPFbDbrDaV3Z5DkxwHnDFV3?=
 =?us-ascii?Q?i5YF93qswmVZoFAt8BOFI2Lt4kxqC8EFlWVIeL02PNxlbAsgQpDi9BwfM2Uq?=
 =?us-ascii?Q?Jw9yMLylyqR8QU8SOILdRxYhqAmd?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?FJvY9/RIVpdWlnBhvEQ8br1tkc9LtjsW/H//bH518rapQwagkRA1KYIOu1cX?=
 =?us-ascii?Q?z1BFJEBzTSPmd1YkGVwE5RquWpNxhpiA/wHzGXvRWneid9duva3fq25fKWYb?=
 =?us-ascii?Q?CNzvuxm8WIG31xflQ63Kqw6l8gxViEe2wWXvJ+fuT4LZQx7c6T+wRyzlK8uW?=
 =?us-ascii?Q?8phUhcvIiR7GIWoz19wkgZGfEJm1iH7OsYsN/GruGfp42c2Au1FHR+1Okruq?=
 =?us-ascii?Q?nWELHlVTxgc+2D00CSPTCgMNuh7a1cMWstka9NhQ8jWogTL6NkuruOqx3GWS?=
 =?us-ascii?Q?XSiJjOMZJM8+Lo0Z1YIVAHsWyWiooa2oQW38shILG9luCG6zuZ8mxkj8Z89V?=
 =?us-ascii?Q?imGrOuSjNh6IBW3C+G8LCZU2Hg5u9jkw4LV5u28gxhsq14VAtTyzXtTiU3/j?=
 =?us-ascii?Q?8WkO5GTGRbqLEYi9vFR/DvZNEjg0LkjI85oNILHqKSNIBXvYGMEzlco4aZp1?=
 =?us-ascii?Q?wFAF+EKvzYaUozzW/fxlsunmELichvQnAOck+JOJet2rzkLTPbLwP+e5Vsec?=
 =?us-ascii?Q?7eyxZgNBwNpTxmDCRTxNUS3Mqz/Fcmba2BTls4OAEPYVw5fMza/hx2BszDsV?=
 =?us-ascii?Q?9oNg90cPUXWnrwDwe17GrGzOm/KW+MRMFIIzwiMfw9bWpJf9gMPCONZAP7F+?=
 =?us-ascii?Q?bqbaSz36uBOGmrEGpOOc661kXTp2FReRDhcxn3vSGuH/2rg0/7lbo0gKJuwV?=
 =?us-ascii?Q?bI5CVDU/zG9BUfIcOe4Dlv8V51sjLqFt4r0Maau1CinovyKrSNhF6tCDHXlX?=
 =?us-ascii?Q?vxQXzXJVFTgwCe3Zq1H8vvMiL8snsNAoaIkisMK89gKi1/JxSaxlJn6TBgk7?=
 =?us-ascii?Q?LLrhxPokZfkCo4stQNiAdXGDs69VeumjPjQcoTNeRMsyC4FqWHfZBXtEwY5q?=
 =?us-ascii?Q?1moJAdgjYEp8UzAumYPYnASCuSxGaaerqTOMjZCZZTZEA+Oj2xHimVQCOKrs?=
 =?us-ascii?Q?ETIg0+RzR37Nr55dQlrfQ3OS1fbVUM/tQKyl3bYePfCUm6XFz+dUeflJ2qPW?=
 =?us-ascii?Q?gokZfepCiEu+/sHKP5bLYu4niKhejVwyD4zTbXz3ISsYf+DRq6omiyD344BE?=
 =?us-ascii?Q?fAZA3JQlxuAZGeOCYyk97C7OrEWahRbNer3QuudyGSft6ogKtT9D/LINMk11?=
 =?us-ascii?Q?HpSwHaJhFPsZTKO7cgaqXhwlfEcFxHBVeHCq8y2bsH7x108u3NfbxumzmR4X?=
 =?us-ascii?Q?z1sz2KplAwKX12IvlOZ5ZXC6+UBXWspIfY1xVZ0bTxkxPSd3psgDDLBMh+XI?=
 =?us-ascii?Q?THd1vYdF/H4rfxJabQP6d1kaX9S0EukR+hE6tGrMNhNcGb3bUkIe9KoG3Xjr?=
 =?us-ascii?Q?pOf6PcmC+QrC1SolkthtaJyzPjynutca6lyDPc7XeH3d2fMIn7XqpS50Fm8t?=
 =?us-ascii?Q?/VWPWUkXRm2EJjal1nNy3LOqeydS/mNMKSSnaL5287CupcKMH6JjIxnqLctr?=
 =?us-ascii?Q?vSL7H2yi0ugt3MD35CzxYjVkKmRloORFW9DFU2ntD7s1186dqZEXp26v744W?=
 =?us-ascii?Q?jJFf91pvyy5mF+JXIby6ZzPY5PhRcG3xISyC6IwmoqfoO3hVsVv1IS5fcA9Y?=
 =?us-ascii?Q?Bp+EDdAJLJFEKBiLctdXRqSlzMEVCLFclnbcH9bPJp4JvCYvjacuEUR4oxch?=
 =?us-ascii?Q?ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D18EB8375168324DA57A88B88802C3F4@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a351d3-7f40-4175-db77-08dcfe2f804b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 06:51:54.8817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F25NEEox45wX/29UPeTdqEYY/erXaWS6Z8an5pX1OOrIaUHtPsLALhoare+0ysn1p+NugYY8EwJZ+PuLhMK8aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB5983
X-Proofpoint-ORIG-GUID: QblbvTZabw_afNzAl-sKct8fMvPNl3Rp
X-Proofpoint-GUID: QblbvTZabw_afNzAl-sKct8fMvPNl3Rp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Hi Jens, 

Please consider pulling the following changes for md-6.13 on top of your
for-6.13/block branch. Changes in this set are:

1. Enhance handling of faulty and blocked devices, by Yu Kuai.
2. raid5-ppl atomic improvement, by Uros Bizjak.
3. md-bitmap fix, by Yuan Can.


The following changes since commit 2a8f6153e1c2db06a537a5c9d61102eb591776f1:

  block: pre-calculate max_zone_append_sectors (2024-11-04 10:34:07 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.13-20241105

for you to fetch changes up to 6012169e8aae9c0eda38bbedcd7a1540a81220ae:

  md/md-bitmap: Add missing destroy_work_on_stack() (2024-11-05 21:06:51 -0800)

----------------------------------------------------------------
Uros Bizjak (1):
      md/raid5-ppl: Use atomic64_inc_return() in ppl_new_iounit()

Yu Kuai (7):
      md: add a new helper rdev_blocked()
      md: don't wait faulty rdev in md_wait_for_blocked_rdev()
      md: don't record new badblocks for faulty rdev
      md/raid1: factor out helper to handle blocked rdev from raid1_write_request()
      md/raid1: don't wait for Faulty rdev in wait_blocked_rdev()
      md/raid10: don't wait for Faulty rdev in wait_blocked_rdev()
      md/raid5: don't set Faulty rdev for blocked_rdev

Yuan Can (1):
      md/md-bitmap: Add missing destroy_work_on_stack()

 drivers/md/md-bitmap.c |  1 +
 drivers/md/md.c        | 15 ++++++++++++---
 drivers/md/md.h        | 24 ++++++++++++++++++++++++
 drivers/md/raid1.c     | 75 +++++++++++++++++++++++++++++++++++++++------------------------------------
 drivers/md/raid10.c    | 40 ++++++++++++++++++----------------------
 drivers/md/raid5-ppl.c |  2 +-
 drivers/md/raid5.c     | 13 ++++++-------
 7 files changed, 101 insertions(+), 69 deletions(-)

Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C605170A0A
	for <linux-raid@vger.kernel.org>; Mon, 13 Jan 2025 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736789321; cv=fail; b=RGuwp3HtAUtPzdPtD+z5J55uOyjrPx+43jek/M9V79KFz7Iad65SUcEKxN9XWWjXP3XoI2S0Rc/AWqlr/8w76Ybja6uvBz3NFo0Tv2oQe1LDMolQWXj/bzBK2EQx/aexCh4/v7KqJuv5doMvciOGII9JKMdpScbZ8duPiSYU0RI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736789321; c=relaxed/simple;
	bh=aC5FFuVb73CNpSNuwq0dFvMcONOq+Z6CCcHCb7H+0RU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ObU3U7/y+Taenl560iLQyW+qCHu5g8XsMi4/JQ+2p4oKD846hGqDXV9LHHkkmfUnhBjdl4IE6lV/+knagwFyycLQMPcRurGWNIcC1r+tXRZeTLnNJgFWPznwCem8LxvVKR68pOzxZLHREB0MlZ9+nsoh/ujVrwbpfsXbYgrcKPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=M5qM5ta9; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="M5qM5ta9"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 50DHLjQD026490
	for <linux-raid@vger.kernel.org>; Mon, 13 Jan 2025 09:28:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-type:date:from:message-id:mime-version
	:subject:to; s=s2048-2021-q4; bh=SZQPi+miPrI7MF7b4LL9BL6wdddL+lF
	PrHSzi31y8os=; b=M5qM5ta9fUdd0YHpj2rmzpW3liMBiOCCjd2ZYZL6TziSYjn
	ebeHJnVVeB+TeAGL47T5TDvL0VEevc/ARf3sqz8u6pZ7EBQTXZtKcEe79LLfO2ni
	eN/lk7wiM5m3+BM35QT5ghF45OKA0eXukwIrzXI1Qb8zI/Bu/60YmHVMdoADCyik
	DQGa76Ff1SGW2wE+VKuHVGojOUV1tid6RlbgeML6kVKbn8B5nzYmt7BQiI1UFeGP
	v+QJ3LCo2nbDAQdvEYMFfJzqHag3YzjAFA7oj0zCn5OTYc5ugBiia/28tURWjLJd
	j6xLg19ANjdXa4lJJgy/oXXPwiuy3rxLSCCfQpA==
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
	by m0001303.ppops.net (PPS) with ESMTPS id 44575sg22a-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Mon, 13 Jan 2025 09:28:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykoFKUY5IbPhjeKMMK58YnP9tw4pS5pUA/PMxjULdY60L46uM3TCEzAs3keLmLWemBEuUgfPQF61zepLaav/9DUmXpa0jcDU+0dmrUFmVeYYrfWFknKB98KQ956oKFfjL6JuwrzUy6hP9LkXsDe87F6lXylnWodXY/zhxYU9xM55C4cwGvJxirjHDPq+OnpE6bsQE+FDvtDExS2gV/5pIG3QvodmTF7DVX8taHjGlpLK2SpU4PjbHZ7Mr6T3RUJOyjTr8AD8aJxnHt/erJ8gIdG6DLWN66XD8tZ4YPfOl6c0AtyXPYgFqbi5Igr62Kcq+S+BXcVvj6dmYVezq+9UTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZQPi+miPrI7MF7b4LL9BL6wdddL+lFPrHSzi31y8os=;
 b=xGEUhE4YpTLt/S71qNinM8qnBgDo4bXIX03UGHpMrf3ezxMqR7VKuMUAfAwtNLJYjGdERvHjXmGBl5/m2kiS8/bF6/70ZboDM7TuMV/lrFtJukUmNPLvAB3LXJ9zeFBOLQqal8+YiuyCp4k37eWoAqWg5zD9BELu3cAX4Xxm+Wlg0X833EO48RtmHmHCLlVAVflAE+abEKxsnhxQqZMWpVP0t90YvAfa7UeKc16fIuHno3uimTaitAbTlWHWz/StIqQD5VdyZMOd0N40EgtZ43FaC341wd4jWz3XRAixtJinHZc/cbS3bOK5dOgcghUMD4k27DqqjRfnG5svwkpq9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5257.namprd15.prod.outlook.com (2603:10b6:806:229::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.17; Mon, 13 Jan
 2025 17:28:35 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%7]) with mapi id 15.20.8335.015; Mon, 13 Jan 2025
 17:28:34 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Song Liu
	<song@kernel.org>, David Reaver <me@davidreaver.com>,
        Stephen Rothwell
	<sfr@canb.auug.org.au>
Subject: [GIT PULL] md-6.14 20250113
Thread-Topic: [GIT PULL] md-6.14 20250113
Thread-Index: AQHbZeCSE+dlSak2kEyCyQ5lWnseYQ==
Date: Mon, 13 Jan 2025 17:28:34 +0000
Message-ID: <B3AC6EF1-72E5-4503-BFA2-86063919F2E6@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.200.121)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB5257:EE_
x-ms-office365-filtering-correlation-id: 6a9463e0-f59f-451d-f05c-08dd33f7b55c
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Hj1RAxzAsmep2F2G1Zy+Lp6wLtT/Zo6Yjnlifc0TiuTyL/w7SN5eBiqShnqy?=
 =?us-ascii?Q?CcRm6adrW0e/MEdg0JTN8ZG3lwc16jyCDJjMaIM71nGw2cM/7uRSzUgE8kjv?=
 =?us-ascii?Q?wNtwJbR0cXpTLEHF7svicUmkJ8qKUSrWBK6JJVcqC0riVJukrm+FQ7r81QkT?=
 =?us-ascii?Q?RQ20VoD+epfdLg5RDod+3ucQZXnUgfLdSelkOT2gnw7P97G1oIIG6OsIQz4R?=
 =?us-ascii?Q?TXna2ksJzvT9pREFg85vcV309H8nSbQ+3mME0F/nuVmQf7JBGV3hKi5dA35F?=
 =?us-ascii?Q?4cDo7tTcQu7+vjGbVyUb/LR/+ajI/x6tH5eoc8S655M0BSw5QIho/HKIAfdE?=
 =?us-ascii?Q?gmr8D0RLFlcjISFv//Ni9YVAgiVm70BrKUCj93DksNEVXlUCFgWNr4o8TsDN?=
 =?us-ascii?Q?AfEsOxWEtRMSficReMzjG+u1UdA8gCpfylq1udye1StStyZ/blYTDXoTzw/p?=
 =?us-ascii?Q?2fln7r6naj7U3bU5wVu+MDNqbfZNqa6KaqD2tanR+9XCOpMUcj10LLzyWa1w?=
 =?us-ascii?Q?ZEpbMeG+sy/sQ92xjDGDD884jA3hngNXvImaGqzbmp6AsGG6ZXKzNajh5yUV?=
 =?us-ascii?Q?44XR0IM1ZDrO76OBbfBXPxb18TCEvLFaeomG0nqmIs2eCy7eATVGY9mY4TCA?=
 =?us-ascii?Q?nI/rBuzu5T7EhnC3oyDymuRXFGtfT4eePURDPVjk1WBe6YDNOs3isHhzkbml?=
 =?us-ascii?Q?5crDn0r9j/+n8naXGQq9QfxgpJDIEoYCOX2h4i0HVQ84ecv8KxkoGPS5l1UH?=
 =?us-ascii?Q?y8HafM1Ea4sf+T4P+f9bzAMKBImgU9VqbmHl8+jynJj1BNyQBn3MDZ+Z4Jt2?=
 =?us-ascii?Q?viESqT4LikoQWLjYAkCbtHTDIM96IF4IdcreYxS4ytBdhYoysaFXBRj03QV9?=
 =?us-ascii?Q?aHD0O4nI06EkDC4tK4J64zSahd3fZO5FlFXVT21V6S1S8tkMJyy6rxDSa0Cd?=
 =?us-ascii?Q?CQOU1idMkUiK7Pb708xHWRbGNNKXgEO7HPKl6NH+/vZqBd9rNmyIL+h9B4a2?=
 =?us-ascii?Q?GU+2Tlgli6xdjtESxHxsK/LEK/o8/qYKQtAIcTk7fXniRTv4Ph2+BzTXTxMs?=
 =?us-ascii?Q?C/YAMLE7RcKzWKL7Chf7keijhR3BCjoc8bfMH6FEm5fPsn/QUoyETgsdj83r?=
 =?us-ascii?Q?ob3dYXjkWDK3sJAdjUDfyhh9Olcgz1bsPgR2W2aHWP9AXtZALkj+GTcnq143?=
 =?us-ascii?Q?eN/d9YVycMB4ycbQORLcex6OBly/gIBSbYFG2zgbJHiPCE6FiFYryinEPgB6?=
 =?us-ascii?Q?1KBVR2c+qXFmI3pmiaD+RaFodGPZXSLlfEhHtbOuyv3u6keaGl5WoHktv15f?=
 =?us-ascii?Q?KIrz8pNvPPzVA+2wbtp4Ry0fn897Ao0ZiIbkfMY1jL2fD+0I1Ep151reGse7?=
 =?us-ascii?Q?6UioxUFsXvZEI/4n4gT2sbcpPdT/rfUWhZUVYSEZ60DrtpFuWyYRPRasubTE?=
 =?us-ascii?Q?dp/4oX3tosanB6/sI4rnAECYK6C9nQ0e?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?5y19BtJ9g+k47yJSaIJ0ff2hrA+FLIRJGl4Zx/iigGUmUnHR36rBVQjlDvxx?=
 =?us-ascii?Q?j9QbSbLNKo9c3ItGofABcVT9x4ydhY0AAXmWEj439WRBMjliE1HsxolXlbZw?=
 =?us-ascii?Q?HlFZDoMiDDPuchREzHktrxx1i9gXwqdlH0qskEkFR7lUpN1xcPn8neOreNBh?=
 =?us-ascii?Q?21uTPm1oTSOAmTurNcojZV0Vk1lHO3XH4rjeZSvyImTo5gSmVaigAybxoPy6?=
 =?us-ascii?Q?h4x3PqX0ntkhRRUYOrKyhTDK3s7MOiaFqlq3DZeievIq7CY6yQao/KaRvfPl?=
 =?us-ascii?Q?WZU/3fKXd7cjGByVsMShSKTXcUwWGnzNddMHITGt/XbEgj3RVtBpFDZTSIPE?=
 =?us-ascii?Q?1F/uPouBN6SJdvVqd7LKWPV6IOtmHipIbD0IRcVkdoZxFTSCgHmJxUPvPsxP?=
 =?us-ascii?Q?d1NfJ6aM0mfYjQa+/8ag6jnKwKjD8KE82NcEHKrQVZGkjFLMmzWwNmjkYwkU?=
 =?us-ascii?Q?GZ1Lhfs24zXn46s7RF13671NPiTEzVcW+sYSUsyM2C+izPterRJT5Qn3EiXA?=
 =?us-ascii?Q?8MzVkG8FqdsobPW+fP3vRqTgMe9+grRNAjGvYcUcfR6Dvk3gPOrVoArhggeV?=
 =?us-ascii?Q?AjVVbo3K3zGu1W/QoVxiUgBtZVOAXeqpcN/65NbF+ka0qARSWMkXue27UDN4?=
 =?us-ascii?Q?fmrPcKwJ7/prTn38wVM4CO0dh2i9c3+wzwwuaDWPHYK+VdRN+WJugXndTmcn?=
 =?us-ascii?Q?I9PK4GKp0LznQp3ZMfg8fi0QuMdXLczWLHROexJW+QChdpUGfyKkDQtBScy1?=
 =?us-ascii?Q?4FkyLLk0oKjaGsLGJtyFeyUnmYpSvSc0z52vsXw4gvnjsgyoUQoqJTyiLl9I?=
 =?us-ascii?Q?A3RZL35fyB2BwZZM8WfMzUO8KP/qu2nKzkWZ0v99tsojxVH2gjDRbiNR9asQ?=
 =?us-ascii?Q?iA/2fxnyxBzE73vEcW3upSR3CiFIDAG4C97Qdm61+4OCMW+FWtDUUiiEs2q6?=
 =?us-ascii?Q?7+g7NBtzNTVfoMteiHkPyqOIPI1xvNIbCHB6uzu/irYqadGsjGc/5KWkOp35?=
 =?us-ascii?Q?wj9OFiNqnWsLLF8n11iF6Xa1coEtnmvkFgWddflQ37QWnF+yb2z5Y9zujVks?=
 =?us-ascii?Q?issDj7I5QnVGS+/MWrWU77Z7FqYNiiU9imdZsV+j5uiHKlkOLFUVxVDtefyQ?=
 =?us-ascii?Q?n0znbC1bvlkXTwgRTELxAivC5Om0m8Z3xkC4kwU+RNjliwnHmRE8puDa38oE?=
 =?us-ascii?Q?Uif1cNESuHR8eZuJn9BzaSeCwjFCbJYgWxKd20cBJSg1gDMdhHQEmU4bTyNR?=
 =?us-ascii?Q?6zMJD9cvVbTousqA26gRZYDcLiChvrrp6BWBjrT+Cqa7pmYyzhLEam2ggUnz?=
 =?us-ascii?Q?EnUqOR9HPtYAObEjjUmhPchrquU4H0fWp0v2+hVwEyQh7NcnfGUdiOYIOHnj?=
 =?us-ascii?Q?qhuZS5kgPx3bruNmK4StwhJw50uNc9Q9ZX4379wJJU3E/14q+aqceayUvFad?=
 =?us-ascii?Q?vJiiJgIzcahJnMw9MXljmGhbMha0OpNKxUp/3zOrkgSGBdXBYraET4PMPTDO?=
 =?us-ascii?Q?rE0HI1MqigenIwIOIaFNaAhAJAYq/z0Ycpi1IxZD7v1mxF1uIdtIfl082NbC?=
 =?us-ascii?Q?dIkh9MuiSpZxSuPbtdpdVaUHPBxOIR/2zmqTDdS0AlAzSUuk4vlDW3QjQi2h?=
 =?us-ascii?Q?lta41599cA8qyJiQ4Hcj+tk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <079CCA5CA5F61B41886907AE8FE0DE3A@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9463e0-f59f-451d-f05c-08dd33f7b55c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2025 17:28:34.9032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZO8Rt9jI/kiEGgdVX6niXzL9vqF9V/c/hOdSkIO7ipOD1j3lAPknKw47Lumq9lh42KQr8ZoVgl10hmqNJscEOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5257
X-Proofpoint-GUID: rQAz3AVvXRh8X_FURtb9nQ5j2IGAG4KT
X-Proofpoint-ORIG-GUID: rQAz3AVvXRh8X_FURtb9nQ5j2IGAG4KT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Hi Jens, 

Please consider pulling the following changes for md-6.14 on top of your
for-6.14/block branch. Major changes in this set are:

1. Reintroduce md-linear, by Yu Kuai.
2. md-bitmap refactor and fix, by Yu Kuai.
3. Replace kmap_atomic with kmap_local_page, by David Reaver. 

This is the fixed version of an earlier pull request [1], and addresses
build error discovered in linux-next [2]. I am very sorry for this problem. 

Thanks,
Song

[1] https://lore.kernel.org/linux-raid/4A41A8E1-FF2C-405C-8BAD-DA2157E3CDCA@fb.com/
[2] https://lore.kernel.org/linux-next/20250113125142.001f056b@canb.auug.org.au/



The following changes since commit e494e451611a3de6ae95f99e8339210c157d70fb:

  partitions: ldm: remove the initial kernel-doc notation (2025-01-13 07:47:19 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.14-20250113

for you to fetch changes up to c9b39e51a301af677a1faaab75567077ce902178:

  Merge branch 'md-6.14-bitmap' into md-6.14 (2025-01-13 08:57:25 -0800)

----------------------------------------------------------------
David Reaver (1):
      md: Replace deprecated kmap_atomic() with kmap_local_page()

Song Liu (1):
      Merge branch 'md-6.14-bitmap' into md-6.14

Yu Kuai (6):
      md: reintroduce md-linear
      md/md-bitmap: factor behind write counters out from bitmap_{start/end}write()
      md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
      md: add a new callback pers->bitmap_sector()
      md/raid5: implement pers->bitmap_sector()
      md/md-bitmap: move bitmap_{start, end}write to md upper layer

 drivers/md/Kconfig             |  13 ++++
 drivers/md/Makefile            |   2 +
 drivers/md/md-autodetect.c     |   8 ++-
 drivers/md/md-bitmap.c         | 116 +++++++++++++++++-------------
 drivers/md/md-bitmap.h         |   7 +-
 drivers/md/md-linear.c         | 354 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.c                |  31 +++++++-
 drivers/md/md.h                |   5 ++
 drivers/md/raid1.c             |  34 ++-------
 drivers/md/raid1.h             |   1 -
 drivers/md/raid10.c            |  26 +------
 drivers/md/raid10.h            |   1 -
 drivers/md/raid5-cache.c       |  20 +++---
 drivers/md/raid5.c             | 111 +++++++++++++++--------------
 drivers/md/raid5.h             |   4 --
 include/uapi/linux/raid/md_p.h |   2 +-
 include/uapi/linux/raid/md_u.h |   2 +
 17 files changed, 557 insertions(+), 180 deletions(-)
 create mode 100644 drivers/md/md-linear.c


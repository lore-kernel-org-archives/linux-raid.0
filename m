Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBBE8C1E
	for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 00:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="NlCIER0c"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 409MV0DV006917
	for <linux-raid@vger.kernel.org>; Tue, 9 Jan 2024 16:29:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=qZLeQzncOFMa1/SMAkP6/YuJTiQtpNJyLovnTQhtbXY=;
 b=NlCIER0cNrwkQAOBX1e1/ntveWlIdloqiTjorCOMdBkq1611v6uejZneAZuOnGyFVFrC
 78ZyFR2XMLwKHKnpjbu3RrFBAP1qJgODQPM9vBNOfp7TdEtWQSdG54tSbukZapcMZrG2
 nWEiLvhrutSd3UKt3YI84ce1GFfl4K4L+1P4PvCk6aU3GLqNuAPAcr8NgwqbCfGs/FVF
 ZHCgB2dPB+kR9kCmocRzmmG+QUD2EnYZo4ZnAtE5LoVrKaj8Uw5AP34Md5GMDE17bJmD
 aXZeyu7g5ey/zeqxAkcXW2D+UxB0oA8CzMWmyt036n96ED8XKxjbXYwYb6xHN5DIsKme aQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3vhcmqhudc-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Tue, 09 Jan 2024 16:29:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5wgRtBWi0PfLhzdbHUZF7O0y1vGx5ZCvkNrKkuyMOY87nULoBFDTpDUaCsF0tUvI4aCI5LnVgbup6u80xmRv05WyIXmmUcDUY7l28cZ+nCrcqJO1cdetrvS4vARGtWXLmMXjoba6yZBj4u0lp8Iyw14bg2kcmX2nl2VatjXFls8WIDxbGQuIlDtDk400H3llYnINa9IoUbECnGKyt/ruYOgLPtb/MgELtDVPPj1f+BSDzNRrSqvewpKOb/JhBBZOF2+xfGNzWqS2y9nufyPYs2OGIagVqQB9WZ8NDRTHA1t1tfnY9V4eOeKLqoA2NrLjII3GBXGax5/OSwmfx1x7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZLeQzncOFMa1/SMAkP6/YuJTiQtpNJyLovnTQhtbXY=;
 b=ki8XRuxA/KiPLiCRv1rk9Lrsi84z/S8Z8oywwlRNuFk3YPSMIsS+1N2jUoEihum4+bs8bT9N6MI37Lt9HnZZ03k8pIuXUlKMKWLgk/nfUdKNZtKtISLPNWfAbc9+wI57gDn7Et796lMukZ4yJDRK8vyLJXUXE04D+/bcY0/VyW7aLf3PNKrs+FVyvyDYoxJxsYggXgf0YInjJvHHxUcFkZm+PzArpq6Zd3CdnJyJbjUaEERLO7Nf8LXvTp3jFYCSjR/cfRqfP5UJ4wsSoQXsuGdFfGJq/f04Z8Ur+MwN1NsCXw2a7eGJAuXA95a+H/D7bnXfwSRcb/ZWqIezldpMqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4756.namprd15.prod.outlook.com (2603:10b6:806:19f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Wed, 10 Jan
 2024 00:29:33 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f568:18bc:2915:d378]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f568:18bc:2915:d378%6]) with mapi id 15.20.7159.020; Wed, 10 Jan 2024
 00:29:33 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Bart Van Assche <bvanassche@acm.org>, Yu Kuai <yukuai3@huawei.com>,
        Yu
 Kuai <yukuai1@huaweicloud.com>
Subject: [GIT PULL] md-6.8 20240109
Thread-Topic: [GIT PULL] md-6.8 20240109
Thread-Index: AQHaQ1wVmz+mnstj5Emv7DePTFITww==
Date: Wed, 10 Jan 2024 00:29:33 +0000
Message-ID: <34CC54F8-1887-4DF2-A073-4E815510C3F1@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB4756:EE_
x-ms-office365-filtering-correlation-id: 1858114e-4bd1-4faa-5376-08dc117337d5
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Dwdh0lseQ46wA0JPfSk35F9j1WGrzbu171z8IFXkxFLpUg2aTyMlTWLMlvt5FKGjG6UOIrI3vopdtG908i68mFBUleBK5sWsKUd0+OKQSWcph2Ol76u1uHx3jJHGktyMnfbg6BxdQPrJhpD9jnFJtHfuNK05/LRGcXbGyILhdgS8zO85NFdoU2WdpSFq5Lk3brFZikhRswJJYDtxVnYkXzNFbefB3zu/g1kI8YLQzMlyj+iCU90/ujj/atz1ahzqg4zQ8Eks+FaKLvjea/UOWzZbUKCfl6mvbWNR+DuaDa5pitwlSzzr1we1CP4FlyaOH/nistHoFQDTZAU/d8bCuKROmW1xIC8KjDzKsw3QF5uyYMoEIcn4pEeMgZddqlOfK77mAa3dlNBMTrkjiTtB/wm9Bdoxt/Ryu88MSbIHNjQhTtMTqORECLCfKpuMWS6kwcMZb13ly9A6om9fP0DoeqHQO5zqRl5ltxh+43lchnyi1lOWtPPM2KJZvu0Y0nAt6uC0vsY5XyCYXuuUpiFfmjaHr68Ye5b4Pm837YxkHcpkg1Na7sXSXstcl1JvYKV3bXTWJXXRVtlDkiQqwcCCg0CEfOHkI6vxeTghlMo3dwk+tNqZLsp3WjW0dEVvbCc43ICfN773LaExj1uOkrbgwA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39860400002)(230922051799003)(230273577357003)(230173577357003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(66946007)(91956017)(76116006)(41300700001)(38070700009)(33656002)(86362001)(36756003)(38100700002)(122000001)(9686003)(6512007)(6506007)(966005)(66446008)(64756008)(71200400001)(6486002)(66476007)(66556008)(2906002)(54906003)(110136005)(316002)(478600001)(8676002)(8936002)(4326008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?aY282LP8Xs55dfHIQ9ECt2IQQndKB2BadKj42Kn1vQ9DjxallXuEsmmhdV53?=
 =?us-ascii?Q?f+5AvGeQZAA0S9woMmQV+tbJKl+et0bS7Ses/CbisaqDvuh4pPCbgCEeVvNU?=
 =?us-ascii?Q?XBV2rW3mc1oFUDrMqdSwDB3TlnePFWu/V5mtw+X7h6O/t2C+6Fu0W6lhE/b0?=
 =?us-ascii?Q?54I9OiLW9YStnPnzdN2LxjBTz6uNdJbTMR5807LYQMdOyS+N1ChkGMzVq+KS?=
 =?us-ascii?Q?h/RwCPQWBiRZyd6hw71U9CKdoCcr/VW0orc7RSoqb6ldeyEAd4v+fkViecXe?=
 =?us-ascii?Q?Aqp1tBX69Do/rn9/OP9eXCUm8k3s8nHKA7DpJZHbN0AuBQUr4VCKwAVpgt+V?=
 =?us-ascii?Q?LqPx/dsFX44Rn6CyrjBpK6KFGKcksNZvNxVkXTruZlxABmmeDR8BWx997uc6?=
 =?us-ascii?Q?H5P4n0A3ieqViGc9FEsos6edgQO+FTnWeH6HEsMOW/HtbmTDHjrs3ECrkNbx?=
 =?us-ascii?Q?W2qY29gWDQF1gT9ThR8e7XpL15aTAFm39zp0r+FPoMtj3BqvLbkYtci298sP?=
 =?us-ascii?Q?Y11LPg7JvLg5WaeTjRlHUziFKg39KK4WVa8sLjLIA2vfp6cS+g6WJZoHCz7K?=
 =?us-ascii?Q?1kR/eDJeWm71Hy3MD39/Ef3MKzMy/jM+Fm6AmLUPYLQH8Wf9rXL8u07Faahm?=
 =?us-ascii?Q?DnJwKpRmvZEdSUzBZPVuuheP8eebyOGuUBsO2QW5B1na4pnVLO4kwtEKIdBZ?=
 =?us-ascii?Q?4bRI6LYqaVDGDcW6VbRBdHPiEh+YnCUecYQsssrSNgE9eWm7WUvKKNAYwQKv?=
 =?us-ascii?Q?+CiqOUSY1QTGYU2yEWpwYXwME9uTFLiIxd4qeGeqHTYqv2YjBiZnX69M/iL9?=
 =?us-ascii?Q?/Vhnc2z+CHsufhakWmzsIZ0nTdJt2OECzkdk/ZZ1e/nra86D5ZXGYmyNaWwA?=
 =?us-ascii?Q?NXbSBHjjtniXCAxI0CYaBxZcFh0J5Sk9nS84U/atyCC4lErEVUZp3k7U9Mcg?=
 =?us-ascii?Q?5jXX7RAuK7u3WiT+1dacQ75KphQbx11Qxo9U9AKGTcLeqR976ERyFwMrGB7h?=
 =?us-ascii?Q?qyMAZ1qrZvoPZd6bI+5jS462cYzQyL2p80pWaGDE8yglCrtMfyQvOxiQurcO?=
 =?us-ascii?Q?9XAnPoYOZlMlacXfaeEXMbXaYb0br39rh/zTqvkDZJXsSovmrp2h9hLeaFl7?=
 =?us-ascii?Q?EfchTEcoQ7aqdbYi9oamhjKqN8xLMpQdxydN2juv3VoAkZvNVhUNtMeHcgya?=
 =?us-ascii?Q?wmfqwNElWW9nRGM6GXj06tw7IiH88jBeEQHZuTaLfvZf4F3TTJYb1526TyV7?=
 =?us-ascii?Q?Zbzt2cg+qus/+xgaVUfX3EqQrVPwR2+S7M2UV8s2QDlpNCnzN3LFPQTMKZO8?=
 =?us-ascii?Q?9SprVib5ykShp9inkawbF507FkycnsWPD1Ac4cyb1aQx4gejIo/AMQrBPGHg?=
 =?us-ascii?Q?9MFznygKWk3iYO+3P3R8IXtoN9WFGuEPe2Wrrnx89JVNWqlv6/bbNo54KZHX?=
 =?us-ascii?Q?lVvp9e8eGCQyTgBMadULTCeBhXAmxbtlNdoOVeGNxYxfzi3XMrXJhf/fQRSa?=
 =?us-ascii?Q?EBkwVjLWThvnPwLQhX7N56TlsVt2Ws1S8enDfIsXxt6L1Bxt0+AmhuEiUt+r?=
 =?us-ascii?Q?2FjuV6rk1pJFTgs0tJj/bdZJ0OuyhHQlil/BfJJbz1Q0VtKH5TfeAj6532jv?=
 =?us-ascii?Q?RAWJ48u5Mab50XGe5aBWXxE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BA6F09121C69F24BB3D8E360F7EF2CCB@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1858114e-4bd1-4faa-5376-08dc117337d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2024 00:29:33.4805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CbMb9YIytlcFzCaCrC960t3S/InE6W9nLjah2zOmgNF8ANcVN097uzE1vo1l+68njqEI2j1kuWo3etVREKujcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4756
X-Proofpoint-GUID: 55EX8bvzQdHW5RFORiZhxRD7xBR8bQSC
X-Proofpoint-ORIG-GUID: 55EX8bvzQdHW5RFORiZhxRD7xBR8bQSC
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-09_12,2024-01-09_02,2023-05-22_02

Hi Jens, 

Please consider pulling the following changes for md-6.8 on top of your
for-6.8/block branch. These changes fixed two issues:

1. Sparse warning since v6.0, by Bart;
2. /proc/mdstat regression since v6.7, by Yu Kuai.

Thanks,
Song

PS: I am updating the branch names in the md tree. Instead of md-next 
and md-fixes, I will use version numbers in the branch name. For 
example, this PR is for 6.8, so the branch is md-6.8.




The following changes since commit 53889bcaf536b3abedeaf104019877cee37dd08b:

  block: make __get_task_ioprio() easier to read (2024-01-08 12:27:46 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.8-20240109

for you to fetch changes up to 7dab24554dedd4e6f408af8eb2d25c89997a6a1f:

  md/raid1: Use blk_opf_t for read and write operations (2024-01-09 15:14:01 -0800)

----------------------------------------------------------------
Bart Van Assche (1):
      md/raid1: Use blk_opf_t for read and write operations

Yu Kuai (1):
      md: Fix md_seq_ops() regressions

 drivers/md/md.c    | 40 +++++++++++++++++++++++++++-------------
 drivers/md/raid1.c | 12 ++++++------
 2 files changed, 33 insertions(+), 19 deletions(-)

Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0599C7EE23
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jun 2023 16:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjFHQCV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Jun 2023 12:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbjFHQCF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Jun 2023 12:02:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35393583
        for <linux-raid@vger.kernel.org>; Thu,  8 Jun 2023 09:01:40 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 358FJ5n1026702
        for <linux-raid@vger.kernel.org>; Thu, 8 Jun 2023 09:01:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=CvcKBLBi5yCH0ftq1yobejnMemDjKgDbmuN/WeLMA4Y=;
 b=kO0z+L3l7nHJi5jpsD1FxnuYEVDXLHeUpKm463u/dBE9XE5Snko2zguHF5ejjgNLyARY
 kh9wZWTg4an/u+dx2U4pGDtBcmz/s3b6jK423CgKuplYcq2QCV+kddpyH13RixyBWYzI
 HdYkkTR+7FoyPH1qvo/Py2JzKO8cp+egIariSBAqSW0x9s91OCfYW5neGRSVeGzxp+WT
 Z3bf+rKN+AsqwQhA2+ilEKefRGqscOxie1gOvZEupM3qcuC2rqgdO075ZmnzEq8eiDv5
 7f7yKpfhaNVpUGF1jdzEZYyt3JXsyVXxDOnriSY7J6/SJUpsdWZ2EYzmC4WYe0bIeCMu yw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by m0089730.ppops.net (PPS) with ESMTPS id 3r35rxmqq3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 08 Jun 2023 09:01:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGMPMl3nfd5CiLIm/NFXVLCzcIsudYUKYk836kN8bZ1fDFOJQlEehnFcV+BbrkF5+dWQC3lEo5JMD/rKShYWfoRzSnjk4KxGexYN7/aKjf+E37l/Pi0ouWMADWJe1eoH1esG99kxyv2ETAtSrTg2TMohDilQpQQdtK8vcToYW/9bSE70rVyfwO8QWAUXhdeYtZFGjhnbbW9AatoAk7QevWzhJslTVwqgsFxRhLEIspjSwu2OK7MlCTPtlj7v3WRwziiefuGpwRQdRpl3SM8A1p5IpLqn+mPkWNvx2zP/2Up6MlhQn8IM6/u/5DPvOS+rG45bODJ3btVB1gRsCM8Vng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CvcKBLBi5yCH0ftq1yobejnMemDjKgDbmuN/WeLMA4Y=;
 b=bW62boLNkKPnOY7Pz8/l37oDj7isXOfwlOOw9c0j6ml+ls0rJPczqkUE9pKXQNYlFK8rSrjezOmMozrXgASky1JfSpqJjEQtEu88GAgJOXg+WRl2+rSLLfjdSuplaa6lI+KQBu3nHsGh6MVWJD7kcrFp7/B7FnQQtpmGkrTtDM1hS5ewnPXPRiT3oxgS48DuDx7Cz2xEh3WETqIR/13Oj3VL8YzUMSzr7EbRStryXWHB79GRyYmv72vtHA81TYhRgvpwLgnqWyC2aTsmZmu0QdfUfxoqsM+IUilg/Jq1s1e66K1/giRMH6odfzCM7xN3sRtLW8+i0G5qsnAh/RpaxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4574.namprd15.prod.outlook.com (2603:10b6:510:88::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 16:01:34 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%6]) with mapi id 15.20.6455.034; Thu, 8 Jun 2023
 16:01:34 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Yu Kuai <yukuai3@huawei.com>, Li Nan <linan122@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] md-next 20230608
Thread-Topic: [GIT PULL] md-next 20230608
Thread-Index: AQHZmiJ/pQeIKl4LJ0mH0Rp07EOZEQ==
Date:   Thu, 8 Jun 2023 16:01:34 +0000
Message-ID: <02757A41-9416-4C5F-BEBF-2326B4F4E750@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB4574:EE_
x-ms-office365-filtering-correlation-id: f6bbacdd-a3d0-478c-24da-08db6839a1f0
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a0Kbl5jCfLhSaS1Tatlv1R37V8sZC57y2dnwl0Qa8Bw5aJXyjEAIwssfuT+Gm+bxSIwt6fAxdF4NmecQoAphR5fXsG6aIOMjp1W/ToO6CMyMTtE4JwTCsH2KkD7+wARWCcfeQFC+788QAFfkbJ9a6p9syQzsphX4IkWvf6lYfGG+ykKn/Gt4G42Jq4y3qlG/nqU9e/QU11ZX63D8sCUNmqrSV0mtSjjNXcBROlax5Q1w4WY94ucv/VXxJALKSLiI24zERUieL+JiT0sppBvk3MGjVg+jB3sEQMaONExDoz9pNn4l/IhMTlEcl57gdNoWVs9+VR6wUAMzV4SMlAswinHVaveIH6mfxel58+Jt9Sl1cziI175lf+AKnCD+MWNblT1k8qCWp76SndRsQPw7g1jGhVKQthtIzSOhMxUFz7pPoYDS5SIlHmB2zTSKDfrhVq/+lzWYjOfPlMcsRHUcXTjBgTqu8TC/uQL36jONBOFbSoSb9ZsE56JOe54uPC6ZeMOw7r1zhj++Ia2R71QXvGutMQEXozTKEVifVA6Ai6lMLe1IlVGmf53zuBIzteu5kmAB3tBJZIf3CPekuLZj7ch/b1cv6MSTMQNE8K4Bpl4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(451199021)(6512007)(9686003)(6506007)(38100700002)(41300700001)(6486002)(186003)(83380400001)(966005)(71200400001)(478600001)(110136005)(54906003)(64756008)(91956017)(66476007)(122000001)(66446008)(4326008)(316002)(66946007)(76116006)(8676002)(66556008)(8936002)(2906002)(5660300002)(33656002)(38070700005)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2/NlvcVBEXgt6FEUd4hr/3V/WYST8KoJVsru6KV1+ISZGTSXfB0VYRY3u1PB?=
 =?us-ascii?Q?YxxZuJ9H1WxP1XXPbXasZt1A63ilSn60vT9fV5JolUuETEccdRrCKueDjWTT?=
 =?us-ascii?Q?tCZx7vdPH/X/zzz29gj8Zn+4JPuKxMzKTXmMwop3Nzs54e+fQSMeZCWcnlOC?=
 =?us-ascii?Q?mvDBBEyfc6l20w1owc/v+HovMiYR9YRu6qe0zMTDWzV8zuCUK08dwAw9vtsv?=
 =?us-ascii?Q?CDXR70+X+mu/W4W5RqHiZGEUNpKrxw2+dpdnwMU9drY8JMfWay7qkTqz1KOL?=
 =?us-ascii?Q?Kk0C/dgmEcjsIqna11cYSaOJq7y6WQ4DZlM27E2ihD2xgjKgmXsJ/hMSUbye?=
 =?us-ascii?Q?lVoj9v/p9sSpYGoPfifAZ9yPpYt559I4vldEaAgQxanynvB3g2eCMSn68oIP?=
 =?us-ascii?Q?NhzblvsN1YDmlpKsc2BO/Jt2T59izW4LZuCV6N/dlivu1yr9YqwlmV405lIv?=
 =?us-ascii?Q?aovvNycOHsoQ8JjvDGUUmQBlJxp8ZzzDr1CF2DSB6N4iX3Nkzh0dySBfOXmi?=
 =?us-ascii?Q?enI051FbWkFnZk2UxbVphPJYm8D5Z6kxv7NDNi10+fY+3H/VcCHZxbI5SEh4?=
 =?us-ascii?Q?A73zFX6Bf4/HhkoU7Dg9mql0Et2E6ztgeLMz+EcATMJJfx0lCnza+NQXKZ0c?=
 =?us-ascii?Q?vYIBJBDmiQyoEJYR3b9EGVFNm/OV5O0gqAGWaf/zEH5juTsj7/cixlC4mbuF?=
 =?us-ascii?Q?f2wTGYXRcTwbvmmCfgAo2j1byY3rZ5ixTry8FECdFRRcUSweh2WbDNiMeEd5?=
 =?us-ascii?Q?SG0CkDF/7xwV16GA/yCrZ9kSOWm3uUHW32OABZT8htleCwQsQPKXFgeZ7GIJ?=
 =?us-ascii?Q?zrD1WrbZRGCYZiULWMPwIf/uXxr3Glp2+V7Ta+3To18HE9JpnzruZfihtrX7?=
 =?us-ascii?Q?aDE+mSYix0vLPCaXM23MSvOPSIui/M+TY5pMBSA57VK38vafFRcS/FBVvATX?=
 =?us-ascii?Q?ZcvYOeWhzHLWV5DGG1PzfwbJxs5xaGzad5zskNF3kOquN2O3Pq76LmYd/Lf7?=
 =?us-ascii?Q?wPX0DJ8sDe69TKe75aFnbftxBao1yqnE0P0v9+SLzJ9wIfADF+uFJkBe2dTt?=
 =?us-ascii?Q?ntV9O0SM52GAgrLBKdniLUnPHlae2YbkE562G5tdLQdkwhoBcoHcdfrQccem?=
 =?us-ascii?Q?J9QQFAu5M+V6k+3xJucv/NpT0HqU/xqSVhmDcNjmADdcPgfM9ol8UqtpMEFG?=
 =?us-ascii?Q?1pJ/lnzPWBSOVs1puxuDy0CLTHXgyN66ArNU7VWxBy4k/jwol3VVS85b8G2x?=
 =?us-ascii?Q?4DPoUMCo6A7fcrD9QrOUlyHnx+7V4WCLnvGjbCn5y5sLjxXXFwgITwx+SqPY?=
 =?us-ascii?Q?8xD/tdofGLRBwmJeJRDct5aA78ekfptCJGk56hoCcBBdKOiNEsKGw9c+Vv0k?=
 =?us-ascii?Q?Y24oEFSzgR9FTkOG/OkRQy9//fdIhQfryZR83e0sdfmA0FtVTE2TKLRgWyT2?=
 =?us-ascii?Q?rHrXI+1ngN9bC9hqRegwIzEuzg9TzsikeslcWCPO0753y3SH0fao1FnlbnGL?=
 =?us-ascii?Q?X56/aToe1xEWPASUtoGeNRJfIE57mbHbnpHcmzFOX4Xi1L7RWT7zULcEHTHi?=
 =?us-ascii?Q?r822tjHQAuzTPxDjuJc/nQ8/9qZK2eOyNWUrJGv4YTtGNK0/8+12N+HCzqYx?=
 =?us-ascii?Q?R2JqDZf4Jq6nQqljr0y2zrg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23441146C958A6408E89C505ED6CAF02@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bbacdd-a3d0-478c-24da-08db6839a1f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 16:01:34.1755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cCn2tMxozPT+lC7iDKibb7c6jCWWwAr+MCFeGEdWecu5iY5DZ4s6/GTCisQ0735hGp/DsU4RQGctRuvVP6fULw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4574
X-Proofpoint-GUID: rJN1eYM6QthIK6lHnwIcym-fWRIXIrRA
X-Proofpoint-ORIG-GUID: rJN1eYM6QthIK6lHnwIcym-fWRIXIrRA
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_11,2023-06-08_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.5/block branch. The major changes are:

1. Protect md_thread with rcu, by Yu Kuai;
2. Various non-urgent raid5 and raid1/10 fixes, by Yu Kuai;
3. Non-urgent raid10 fixes, by Li Nan.

Thanks,
Song


The following changes since commit 7da15fb0318f18398feea2848d099a8d0d7b5965:

  pktcdvd: Sort headers (2023-06-07 14:27:49 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20230608

for you to fetch changes up to 3f38d83c0f18f5eaef5c248769f5a7eb368e9a47:

  md/raid1-10: limit the number of plugged bio (2023-06-08 08:43:28 -0700)

----------------------------------------------------------------
Arnd Bergmann (1):
      raid6: neon: add missing prototypes

Li Nan (9):
      md/raid10: check slab-out-of-bounds in md_bitmap_get_counter
      md/raid10: fix overflow of md/safe_mode_delay
      md/raid10: fix wrong setting of max_corr_read_errors
      md/raid10: fix null-ptr-deref of mreplace in raid10_sync_request
      md/raid10: improve code of mrdev in raid10_sync_request
      md/raid10: prioritize adding disk to 'removed' mirror
      md/raid10: clean up md_add_new_disk()
      md/raid10: Do not add spare disk when recovery fails
      md/raid10: fix io loss while replacement replace rdev

Yu Kuai (19):
      md/raid5: don't allow replacement while reshape is in progress
      md: fix data corruption for raid456 when reshape restart while grow up
      md: export md_is_rdwr() and is_md_suspended()
      md: add a new api prepare_suspend() in md_personality
      md/raid5: fix a deadlock in the case that reshape is interrupted
      md: fix duplicate filename for rdev
      md: factor out a helper to wake up md_thread directly
      dm-raid: remove useless checking in raid_message()
      md/bitmap: always wake up md_thread in timeout_store
      md/bitmap: factor out a helper to set timeout
      md: protect md_thread with rcu
      md/raid5: don't start reshape when recovery or replace is in progress
      md/raid10: prevent soft lockup while flush writes
      md/raid1-10: factor out a helper to add bio to plug
      md/raid1-10: factor out a helper to submit normal write
      md/raid1-10: submit write io directly if bitmap is not enabled
      md/md-bitmap: add a new helper to unplug bitmap asynchrously
      md/raid1-10: don't handle pluged bio by daemon thread
      md/raid1-10: limit the number of plugged bio

 drivers/md/dm-raid.c         |   4 ++--
 drivers/md/md-bitmap.c       |  93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
 drivers/md/md-bitmap.h       |   8 ++++++++
 drivers/md/md-cluster.c      |  17 ++++++++++------
 drivers/md/md-multipath.c    |   4 ++--
 drivers/md/md.c              | 226 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------------------------
 drivers/md/md.h              |  37 +++++++++++++++++++++++++++------
 drivers/md/raid1-10.c        |  63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid1.c           |  36 ++++++++------------------------
 drivers/md/raid1.h           |   2 +-
 drivers/md/raid10.c          | 179 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------
 drivers/md/raid10.h          |   2 +-
 drivers/md/raid5-cache.c     |  22 ++++++++++++--------
 drivers/md/raid5.c           |  68 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 drivers/md/raid5.h           |   2 +-
 lib/raid6/neon.h             |  22 ++++++++++++++++++++
 lib/raid6/neon.uc            |   1 +
 lib/raid6/recov_neon.c       |   8 +-------
 lib/raid6/recov_neon_inner.c |   1 +
 19 files changed, 508 insertions(+), 287 deletions(-)
 create mode 100644 lib/raid6/neon.h

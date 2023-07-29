Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7858C0015E
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jul 2023 10:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjG2KP3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Jul 2023 06:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjG2KP1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Jul 2023 06:15:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DFC1980
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 03:15:26 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36T9pfpE006352
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 03:15:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=dbMvjwzyYBOQmQ0gum8ofDj9ENIC7IP822a7omN+Uq0=;
 b=e7U60BAiJrGe0BCm5LyDZ3oSREu14PqZoOFx/k63G8A9naIAmnj2HL9Xh4qhH0heUcog
 RpeobB/s/OIrf7didY5oEW8fczdD1IZi/dG+poP36AwnqqYY2Z6/4GE5gSCozq8gpzm6
 mI+ftiEEqGtHY0XeoAQTUALI14p2bWeG3JB/Dg8QRO9Dyis4baMH5ARG62lPEGa0ozUj
 ShRIKwFR7rl+Iq3OVHLKMM7OrwDoJc4Xjkx7HVofciOAMCTyiDX6pZSlP3R+foL+qfiG
 hN65lcv0RUY6LcpZ+Cz8KDT1NRk+hWLJpSGQw54YxzbILQ3XqVVZbemXJbk0OtMvfFIn yA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3s50fq830k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 03:15:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVrkd9/DNX2qYLrqNZUrU5U9ZQlJwKiOiv5HEoQJt1Brpd3r2O6GY88V05a5P49jR1cag2TNVJX/7YtL3A8HVP4voMuTzBszqxWckY9iWrlRGBM9f4GgWDxl6swO8VYxc9YbhtPmzBPg1jhaf1xMi9gyPSrBAl7akanhA9SIghxUo54VwxNCuuPaVcK7rdtw7sjcgGTTdvaggUYESbvPfFLdbzfLz5WeoS37nJ4ohSyAHV0Qqq/gj91ORw9nq/SXTcxffAL0xdZrrASVQSQavKdRYMld/xGP+leKMXSEQYfjyV53ibYVX6O9rYuO4u7FRjC9mIJGfQs/JJldrPM+Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dbMvjwzyYBOQmQ0gum8ofDj9ENIC7IP822a7omN+Uq0=;
 b=hWGDKyDbRblVV0vDigtAlR04olAOc9ABnoxRcyEb+MNafTPVkL2cJhjUSZF0LSXP+EzmdRVJPN7QyVrqGFfP631g+8KLyhGr+VfK8CKka47rjAmsgI0CLzYUx5zQYgudOQ6rQZ2+e2PZI2ftMmUuhuwVWzgFie2+Wwz+bTtcGt2enauxsir0kt3jw8PrA8hiF2deGJ5B+Cs79tDaNeaMPW6ysZPvF1BeaHtV9g9lLlZ/IYOUzdb+flGQPUD8ejqRmqVDivUxHxCIToT87NiKqq3SIgAttp9jNYKV1tEYvuh5DQ27HlAnI80CLnNZGoluvk2JVQz6Fl0f0NikLDGKkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CO6PR15MB4227.namprd15.prod.outlook.com (2603:10b6:5:34d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Sat, 29 Jul
 2023 10:15:22 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::57f2:86c6:1115:ad7d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::57f2:86c6:1115:ad7d%6]) with mapi id 15.20.6631.026; Sat, 29 Jul 2023
 10:15:22 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai3@huawei.com>,
        Li Nan <linan122@huawei.com>, Jack Wang <jinpu.wang@ionos.com>,
        Song Liu <song@kernel.org>
Subject: [GIT PULL] md-next 20230729
Thread-Topic: [GIT PULL] md-next 20230729
Thread-Index: AQHZwgWVJItU10dkO0aLiVxcnKLdVw==
Date:   Sat, 29 Jul 2023 10:15:21 +0000
Message-ID: <BE8FC4BF-3602-44D8-B211-D8953D0CE136@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|CO6PR15MB4227:EE_
x-ms-office365-filtering-correlation-id: e6d4419f-f08e-4ecd-0543-08db901cb7b9
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lcaiSxRf8t7rC4ea1nwdX99atGJ56OSIxVZRBTtpp/Z6uPorShZ5hXU54Jx2Pjw9WFudyh2WbTnXjnPio0TuI1H3JrgEf0/ol9B9RWChfyYkiQzSn+iAfKbuMu/p6jUTej78qBfvFq5F5VthWe+zpzJ1phWgr630aX4wmSuM185iMnK5ryAC1rRme3jjsjCqbeYSdoIBa4q1ii07i44EzB3p8sE4PlOV8s+eLSgmSw4lBoRzhCbVzU3rfhheu5Jik+SAUK4zGzkPEPchUbI+aVRL1vzeXfgvK2pFDUaLfSbg0vSR0ADMxCiLYWLyBx/KPGoyAbMYrGY7AV7BKfnJK6fIvDHyzJCMyVUwAhYOyLncBu33VqYmj2MgtL+VLpKkQcA4Aekjw9ZiCsjKsUjGADxpTLaNr6Qh47ek/CavAkA/JuxOslI+pNi3XFmaLMKw53p/M3odnfiArnTbYqm4mP8X9jRAyDsuzyrAMkVOVZmWuSFVAcg8LzBLC5TaUw91DWvX+aCQFJhqMNZ46HPJufvk4eG/CSM5f0rfgZk/4ZqYatB3X+Q2RpQEv+JfbvPIP4MySgMpGPgvOI82wcX3mVAP9x3xsNPdO3EvFxmgFZU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199021)(38070700005)(2906002)(83380400001)(71200400001)(6486002)(36756003)(38100700002)(186003)(5660300002)(86362001)(8676002)(41300700001)(33656002)(6506007)(316002)(26005)(8936002)(66446008)(966005)(64756008)(4326008)(66556008)(66476007)(478600001)(6512007)(91956017)(76116006)(66946007)(9686003)(110136005)(54906003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4rNUiY7ZCxirp/7BDo1LE3peFA8+jrkg1a8IoGOmvlqV0tilxoKVuNEpZGQ5?=
 =?us-ascii?Q?z7xyMmdbhZWUYblLlH/yz623ZorCtXoCrD0JQikg5ZatQwWXTipuDQrnCsp/?=
 =?us-ascii?Q?szcF1/J37vJh8bQmalJWybHkMPFej8kg2OM6m5fJptotB9qRLCKt1cETe/CK?=
 =?us-ascii?Q?l/qLH8j1N1BwWGACNUUW6VJLEmRolxP5W6NXBcCq061fGvHt4MqRAxgyN9iR?=
 =?us-ascii?Q?+ZMD+joRjI75xmesnebeebuOGpJdU1DZJF1Cc6U822cziqdInh/1KIIKlzeF?=
 =?us-ascii?Q?4RpLiqN68QkRZuaaPuJceaWgAvELuMG1VaQI9xly1dXUcKRutiMOxmwYH/Ml?=
 =?us-ascii?Q?cX6TkkUKtURB+pjbo3bytWvAeJlTdax1WQIAZnwOjBgbmBxeCYyF5DZtivAE?=
 =?us-ascii?Q?acc9u+PDIzveWMaOvkp8/GLiItjwIuJnQ4TRxN2chhlo1ChXQlKie5hsc+z2?=
 =?us-ascii?Q?AEJUCu5PdveZLmlkeH2+ISyiISK69K8Pb5Yeg9pvZvWgEc6nSUWBkxLRgxG2?=
 =?us-ascii?Q?ogTQYyAolv/+xinAycXX/Y6qiGxstR7mLbBa9yixmF4sw2YCgIi15oD0mJPR?=
 =?us-ascii?Q?mY8jmnunhLi98kg0PAvO+A8ec/eo9B7aA2qnXuLYQtY8sp/4xswmoBb4i1qd?=
 =?us-ascii?Q?fMhGAQgQJy0saz/eJAy5Lg4l1XRyTaUXZSI6519ZqxKzdGPwzOrj5pe7PD5f?=
 =?us-ascii?Q?Mmr/MH247A+C9N9lU65wligPZtT57ZrjJhEO5oK551Vb/5MOju8S4oMHThrm?=
 =?us-ascii?Q?V9FvMmw5ry8vlrT4x7qONPIXBxbI1HbJfeqQiIc2BgGvXUIbCW7AABaGJgM5?=
 =?us-ascii?Q?aSQMUO1GlkEOEVP8zodZXCqr0aGIEfVSY93FTnxbWymQf6R3AJTpFQ2ajI0D?=
 =?us-ascii?Q?K+q+rt0lpnl2f+oP85UJAaQsOCL4b3pZ+8XH63j2BtdzNJZK8WANPv7WHMbr?=
 =?us-ascii?Q?8xnCkN1ZU2xNJ5/mHNMWZFqEeG2EPyt8Upolnb5LaaF6dvNiQnIhMxWWKZSC?=
 =?us-ascii?Q?MWjpwOOJqeLXyGg1ElUSB4aHnW1AruzThCcvt1N2+SWzQhWmFMuezo9VZHuw?=
 =?us-ascii?Q?LCOUFOYX+AEnM5Gtl/3gLj4XN4lKvPzz/rkuDnJMIw2dQxxbzzPTVUYhgiMz?=
 =?us-ascii?Q?2VI3WlCvJwkP/h9qQ5epYB7LmDIazb+kw4Sk3ux97ymJHMhu23IJOPuPvh4l?=
 =?us-ascii?Q?PvFLLui89X46KPbnUrESfKHxnr/BljIh8IOMauo/bgmZy8IKt5WE8ypOsljW?=
 =?us-ascii?Q?kYRCRVzTcD0tc7Fmf9QRpO05e1XVzt6YcPNfEwRKt1QUvmU+o5f+2f5yPkL1?=
 =?us-ascii?Q?/y3hhH01CAoPuBKpmIt6vccN8y4bGBOZYJXWJj73FkpUHcq91ahS4wl/NTwJ?=
 =?us-ascii?Q?DrGTgNmMqoOmCH5uhPKtoUeto0CIT84q0/ZA1LTTMUGboy8UDMznCixATAjd?=
 =?us-ascii?Q?2JYr4SFOGS4LmI3gPcjPkBmpxPuIzzWEOnsvrTHY4cXX1S9jfKKekMA7IIOZ?=
 =?us-ascii?Q?sXv3Am55qPSM/D2B9qHXqI3c1qR6B71KV30pZ817oLCELiEYGgqzRrQcQn73?=
 =?us-ascii?Q?FEAFD+N9F7doFNL+nBx2QoywXHD/hcYcJMr1lswm8MWwDfau9a5/79Z5LbAT?=
 =?us-ascii?Q?wA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F4855E6E2B339044AC40FDA151EFD290@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d4419f-f08e-4ecd-0543-08db901cb7b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2023 10:15:21.8866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Jj1eM7CAuUqFNUYfJ8y4K7Q85HrjrzOjj8qdjivaGtdSa/m6PlIt2NwGwoSWZVDDoXQqA5qtrymoP2JUEAgVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4227
X-Proofpoint-ORIG-GUID: GdBWhhQ9qfD-usO1PifEcjX7M8DyjXEb
X-Proofpoint-GUID: GdBWhhQ9qfD-usO1PifEcjX7M8DyjXEb
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.6/block branch. The major changes are:

1. Deprecate bitmap file support, by Christoph Hellwig;
2. Fix deadlock with md sync thread, by Yu Kuai;
3. Refactor md io accounting, by Yu Kuai;
4. Various non-urgent fixes by Li Nan, Yu Kuai, and Jack Wang. 

Thanks,
Song



The following changes since commit 51d74ec9b62f5813767a60226acaf943e26e7d7a:

  block: cleanup bio_integrity_prep (2023-07-25 20:30:54 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20230729

for you to fetch changes up to 44abfa6a95df425c0660d56043020b67e6d93ab8:

  md/md-bitmap: hold 'reconfig_mutex' in backlog_store() (2023-07-27 00:13:30 -0700)

----------------------------------------------------------------
Christoph Hellwig (11):
      md-bitmap: set BITMAP_WRITE_ERROR in write_sb_page
      md-bitmap: initialize variables at declaration time in md_bitmap_file_unmap
      md-bitmap: use %pD to print the file name in md_bitmap_file_kick
      md-bitmap: split file writes into a separate helper
      md-bitmap: rename read_page to read_file_page
      md-bitmap: refactor md_bitmap_init_from_disk
      md-bitmap: cleanup read_sb_page
      md-bitmap: account for mddev->bitmap_info.offset in read_sb_page
      md-bitmap: don't use ->index for pages backing the bitmap file
      md: make bitmap file support optional
      md: deprecate bitmap file support

Jack Wang (1):
      md/raid1: Avoid lock contention from wake_up()

Li Nan (6):
      md/raid1: prioritize adding disk to 'removed' mirror
      md/raid10: optimize fix_read_error
      md: remove redundant check in fix_read_error()
      md/raid10: check replacement and rdev to prevent submit the same io twice
      md/raid10: factor out dereference_rdev_and_rrdev()
      md/raid10: use dereference_rdev_and_rrdev() to get devices

Yu Kuai (18):
      Revert "md: unlock mddev before reap sync_thread in action_store"
      md: refactor action_store() for 'idle' and 'frozen'
      md: add a mutex to synchronize idle and frozen in action_store()
      md: refactor idle/frozen_sync_thread() to fix deadlock
      md: wake up 'resync_wait' at last in md_reap_sync_thread()
      md: enhance checking in md_check_recovery()
      md: move initialization and destruction of 'io_acct_set' to md.c
      md: also clone new io if io accounting is disabled
      raid5: fix missing io accounting in raid5_align_endio()
      md/raid1: switch to use md_account_bio() for io accounting
      md/raid10: switch to use md_account_bio() for io accounting
      md/md-multipath: enable io accounting
      md/md-linear: enable io accounting
      md/md-faulty: enable io accounting
      md: don't quiesce in mddev_suspend()
      md: restore 'noio_flag' for the last mddev_resume()
      md/md-bitmap: remove unnecessary local variable in backlog_store()
      md/md-bitmap: hold 'reconfig_mutex' in backlog_store()

 drivers/md/Kconfig        |  10 ++++++
 drivers/md/dm-raid.c      |   1 -
 drivers/md/md-bitmap.c    | 347 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------------
 drivers/md/md-bitmap.h    |   1 +
 drivers/md/md-faulty.c    |   2 ++
 drivers/md/md-linear.c    |   1 +
 drivers/md/md-multipath.c |   1 +
 drivers/md/md.c           | 221 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------
 drivers/md/md.h           |  11 +++---
 drivers/md/raid0.c        |  16 ++-------
 drivers/md/raid1.c        |  60 +++++++++++++++++--------------
 drivers/md/raid1.h        |   1 -
 drivers/md/raid10.c       |  82 +++++++++++++++++++++++--------------------
 drivers/md/raid10.h       |   1 -
 drivers/md/raid5.c        |  70 ++++++++++---------------------------
 15 files changed, 431 insertions(+), 394 deletions(-)


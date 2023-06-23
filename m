Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6208C001B0
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 05:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjFWFuJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 01:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbjFWFtk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 01:49:40 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E84EE46
        for <linux-raid@vger.kernel.org>; Thu, 22 Jun 2023 22:48:41 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 35N4VgPI002759
        for <linux-raid@vger.kernel.org>; Thu, 22 Jun 2023 22:48:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=7lEIA9QMjDsCT5Xve8wjTpOu4+pmU9sn7swIJgLRq7o=;
 b=WD0t+zS0PObeqkaJr14m+L/haMmQgWzbIV1peZclKyMu7dp4p0Sp56hw6C/7HQ/ZsZ3/
 f08ejdprlTxBaD6naY4r5xtjZz/8G7G1XWgEcBiThTHp65mhm6iMuykvO2pehbPUzwvK
 uK/N7DT4ZswboaXzCtLF1mzX5iKilvf6J68ffnMEuiCuhv28Y6mjVEKA5eXjhvezgQba
 D1dWgVqrd7fl0zxckyEScMGDw3f/o5wrmq3xw7O3P4pJoFzz7xLUzk45C44+oNE1IlHn
 Rqcrod7c4Ym9DfAj1zBEuijRCdrWURaYRe5AR0mp2XHSEDisyvYjUWuxV+tPF5y6Bpp7 2g== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by m0001303.ppops.net (PPS) with ESMTPS id 3rcq9kqp9m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 22 Jun 2023 22:48:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaEO9MIHRppMhvm8Xw1z1/xDhxZ0jMtcB7+isHnGPa76bnAPEmn7DujgMOw1sJPG5QdgvBcUOgWpA4tjOiDISFA0BzwMg8N2gZRlMaiS3/4JepkCgP8V0b2P03JRwoEJa9Lotost7DS7BcFxPLwN4EBPe0HTYC2k5LMtXD7Ai97WPH6+DhannkCMTwGPl0rEYtgkA4Ku3c4fKjKNVV/av/VT4yEGebU+arK/y4AYOlgO36Xtp6fTRFmjPVzzwjB9wKQxDLl6Eqk+uDbcCH0KP1c691MafqLHrIiC7bCdqr9H24xuAZX/wlRJGCRpHNV9rGgy5ymBV7V9nSK3sYV1ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7lEIA9QMjDsCT5Xve8wjTpOu4+pmU9sn7swIJgLRq7o=;
 b=ji8iFd8FvRirezyI9Hks7ZNNGRzVbyNttFGJdlkxV5aX2BgdBP1HRkHy7iAeE0upab+Z2y5q8NsQvy4CgH4vB8u01XW1Kv+pRlF4XjnlIcP4AczIK/Ot66xZgQU6orsIU9tvAIHfOBzX7TzT1QI0KorDNRtOZJWlJjauor1oRZkqKx3eoMXG8mFuf5pzfoNCbEjw3mDSzPrb+71QVW41Yd4n235TnNTiae2UbFqj3jpxHwmGicGCZa+H3ZprYbcxcAMi95Cw/atULAmjN+cdnamlc31zQHFi2/0GMv69zstPiI2ThiflhafJu7ocIXOv8U7EtUSW7TYNpBmZCWbH+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW3PR15MB4010.namprd15.prod.outlook.com (2603:10b6:303:48::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 05:48:03 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 05:48:03 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, Li Nan <linan122@huawei.com>,
        Yu Kuai <yukuai3@huawei.com>
Subject: [GIT PULL] md-next 20230622
Thread-Topic: [GIT PULL] md-next 20230622
Thread-Index: AQHZpZZGybBX055lAU6zSdjHrZX4Rg==
Date:   Fri, 23 Jun 2023 05:48:03 +0000
Message-ID: <BCD9738E-472D-4AA7-B4F9-CCF36B5DA0E1@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW3PR15MB4010:EE_
x-ms-office365-filtering-correlation-id: 961573cd-e3f4-4c7c-6d06-08db73ad6938
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uerbQyiaqEa/3kekzBmt7bBIYeOoojinGBXgRmIsv5gS5KhuMsUtFLI8FrvyRQHrJtPvBqObi2G6GaqBm7Sx1SvRMhlo+RqkerLYbxo7j2Q1IKIb2GZF3FLxvVZXEpRO1I+B2uFkG7S6Tjz4Ny+mUosp42wMgV7Uu/F/9DUr8fk+2t97OUJiocWgoyXx/qrqC/gf7qSAKsv4yxGwXjOFnfUfIEt4N30pKGBj4XFE7ztjq/iY26uYiRTCn2b49nLeFHOsf8eKw2nzxyAH4qlzMbdRID3UCuZvWv/60mVZLhjn0ryB+L4majSMliR1sHDNbkCpMpkVTxykg0esHOKWE0RtILhQaKdF7dasfI9uXPbixgT6zlj1xR/tLnxZiUV0g3smoFCP7+EAZh4E0QhbgCkEpRm910ZsZboRMNB0v28uI0bGAGEy1Aruu+RvwJYWrtxCaCXmiyUr/5lHxsIB6VKrxBjgTrAHEdwhxNtr/K5Gqkmu0Bt6dd4a/oVVsG0eZgJLl7s8qGEINdxnSgvPVZ+PQPLfgzzjmYQENULIInwzEgV3Sm+0wWN9gq+3QaWlx9EwfsyzbsF05IAatr8OeH/FKAlVjqqcEgeAXNB7pvI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199021)(478600001)(71200400001)(966005)(6506007)(5660300002)(6486002)(110136005)(83380400001)(54906003)(66946007)(4326008)(91956017)(76116006)(41300700001)(66446008)(64756008)(66556008)(66476007)(8936002)(8676002)(33656002)(2906002)(36756003)(6512007)(186003)(9686003)(38100700002)(122000001)(38070700005)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5xDMKOM3Qc8xkRFQIYnNXTAZXZmIf89R8lR9W/Mr8W0jY/55a8Y9WCcWoree?=
 =?us-ascii?Q?DO9BdNaAz/3VTRsMmAMdcS4safpiUX4vDGugPY750AvMKCjbofUzwehUYz4g?=
 =?us-ascii?Q?AhG98A3IKGHXV75/mxJwYbexQiq5HP9O031kpikaj0w0bJlWDBRy5NUbEP3t?=
 =?us-ascii?Q?rVv2D+N6IhRbZeDupPaehg5SqRv2U98MXXDJzBvGS56x70efYLDCLr37GZRj?=
 =?us-ascii?Q?+6DtQocLljBjqJ8yQdWTfXDMiuibnltDdq2+XtLn2eBKAkjJW0bRBxCILUyp?=
 =?us-ascii?Q?RrJvNz4dxRq1d4pppVh4eIFaXeH+S8h/PnYiTyxasizX7DON9r3VyZjyxhun?=
 =?us-ascii?Q?tiXa1FXcDA3fsvJ/I43qjxrIavORlv9+CkiX0/HwIMIsAAaeUJmWw+ALMpMP?=
 =?us-ascii?Q?1o/GYd9zE6CahIPPzsssVICAa1jmdX2OGxfoQtlI22mWsMfYEoJrcG4J3EL6?=
 =?us-ascii?Q?Jhszm54fb+dJfxSdAGpQooArQeiEEM9c+tdob+0BkNfs06nGQXxgFonkR/+A?=
 =?us-ascii?Q?6mpJIyIf9GJEktcRsSVdmw/i+R5df/pGZYF88PBqR4aLJ/j2UqswtDAIXUME?=
 =?us-ascii?Q?3e2hBxDJQMPH02md73/KJF49iKqjA91V46iYuShpvRmned3wVZ+Q5BOiDU3a?=
 =?us-ascii?Q?V4MogmaK7pM4OdSXPldy//0fXxaRysLeI9YvXEhHT35vgqWoBAibASQKKapy?=
 =?us-ascii?Q?j6oDweXWW+OQ0NhTYYt6GgqW6HfVSopOFe3lB1Yh4349jVddo92mMqyynQQE?=
 =?us-ascii?Q?sGoJuWEmEYJaDaOab1FDvSGkS0zjiUmbP0lVSr3shDHxbzG+8yH0HHoqvbhh?=
 =?us-ascii?Q?UU4teb8wWA8fVB3bafFV3bpz8yHM/x1nMq49nWyTk3ODi8dCjpBvks2/pXjO?=
 =?us-ascii?Q?obRF9zB5MjlsMLoqN2do+ds0OiYPL6Np5TT8Mt01UWJf2RlGNTbRdsiwi+xF?=
 =?us-ascii?Q?C/plbs/6n9kY6lxBN0KYlrRArPKFLUEG1YBsRrjoOjPhSeSaKt4MOUx5nVO9?=
 =?us-ascii?Q?lq1VBGSRUlfBUBFWvboPYlGfxgwOBTSEoQuO3f6SyZnPFVwINtNLbbH3+Xxi?=
 =?us-ascii?Q?ScxbP3+bXzQMN7YxPanRrxNhxqScSA34dlzFVZJLod6IJFBX3gxttXgViRTX?=
 =?us-ascii?Q?m9UljZBAFJC6LAjujd/SqFrNoXpCCKwfG41e0vpJmiCmBIUN8UnbbqDlExgv?=
 =?us-ascii?Q?pkfhx8VLFCvvYTBm1nm7L8eywqYM32LGj6riOmLPzglG4qVwZsdFuHwh0J1K?=
 =?us-ascii?Q?qw5lG2zwOaIyb/of7XrjC8rV571xitUJbmunD3eth8pgDG8rS+cGwzHsil+D?=
 =?us-ascii?Q?yBWLwNCDO3LGswX2QefWeuxccVFiK7pbJKQmLU4sZXgVAMaxbSEaDhM9dA+H?=
 =?us-ascii?Q?fUpHymkBHMaZFyrgzgqdxttUen/KOAfwHtj8GXZJtHptDwYs1sG2pec2UMnn?=
 =?us-ascii?Q?po7V4XcD1C1FyU94Y3wxmp2WM0ywqAODvFIFq70jqlO+7px0un3KD4/m85bE?=
 =?us-ascii?Q?o6bNc99nTxKgoC4K7V6mRkd5cqa1tJCKIpl7j/DZ/PUmlATm+dyYSzSUagdO?=
 =?us-ascii?Q?dunCwjjmcIJxJu8h9jaLuJuDmYc3qsw1a7ogFkw6R9nZvgCYnZrgjHkNF7sC?=
 =?us-ascii?Q?ZOXVnUWc9Ki0jHaBtO6ipBM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B67622C475EC4A448A6B384DD8B794AB@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 961573cd-e3f4-4c7c-6d06-08db73ad6938
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2023 05:48:03.4443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Hs/H9llw2jNT1XCLA+o67DjaFFPVjVW1jYkr9KlRJPvTYqVgUmBy95UmC4MLRgzpD8cM7tU9hXa+OrjFQVYmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4010
X-Proofpoint-GUID: Dub-eccoXDMp3YyeRRcCCmAAUxODxu3f
X-Proofpoint-ORIG-GUID: Dub-eccoXDMp3YyeRRcCCmAAUxODxu3f
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-23_02,2023-06-22_02,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.5/block branch. The major changes are:

1. Deprecate bitmap file support, by Christoph Hellwig;
2. Fix deadlock with md sync thread, by Yu Kuai;
3. Refactor md io accounting, by Yu Kuai.

Thanks,
Song


The following changes since commit 648fa60fa7de3ca6f6303e1721591ad73def9cf0:

  block: don't return -EINVAL for not found names in devt_from_devname (2023-06-22 09:09:33 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20230622

for you to fetch changes up to 41fb72ee7eeda723e619c6918dffaf05a55fc7dd:

  md/md-faulty: enable io accounting (2023-06-22 22:28:27 -0700)

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

Li Nan (1):
      md/raid10: fix the condition to call bio_end_io_acct()

Song Liu (1):
      md: use mddev->external to select holder in export_rdev()

Yu Kuai (17):
      md/raid1-10: fix casting from randomized structure in raid1_submit_write()
      Revert "md: unlock mddev before reap sync_thread in action_store"
      md: refactor action_store() for 'idle' and 'frozen'
      md: add a mutex to synchronize idle and frozen in action_store()
      md: refactor idle/frozen_sync_thread() to fix deadlock
      md: wake up 'resync_wait' at last in md_reap_sync_thread()
      md: enhance checking in md_check_recovery()
      md: fix 'delete_mutex' deadlock
      raid10: avoid spin_lock from fastpath from raid10_unplug()
      md: move initialization and destruction of 'io_acct_set' to md.c
      md: also clone new io if io accounting is disabled
      raid5: fix missing io accounting in raid5_align_endio()
      md/raid1: switch to use md_account_bio() for io accounting
      md/raid10: switch to use md_account_bio() for io accounting
      md/md-multipath: enable io accounting
      md/md-linear: enable io accounting
      md/md-faulty: enable io accounting

 drivers/md/Kconfig        |  10 +++++
 drivers/md/dm-raid.c      |   1 -
 drivers/md/md-bitmap.c    | 338 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------
 drivers/md/md-bitmap.h    |   1 +
 drivers/md/md-faulty.c    |   2 +
 drivers/md/md-linear.c    |   1 +
 drivers/md/md-multipath.c |   1 +
 drivers/md/md.c           | 245 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------
 drivers/md/md.h           |  15 +++----
 drivers/md/raid0.c        |  16 +-------
 drivers/md/raid1-10.c     |   2 +-
 drivers/md/raid1.c        |  14 +++----
 drivers/md/raid1.h        |   1 -
 drivers/md/raid10.c       |  24 ++++++------
 drivers/md/raid10.h       |   1 -
 drivers/md/raid5.c        |  70 +++++++++------------------------
 16 files changed, 372 insertions(+), 370 deletions(-)

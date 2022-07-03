Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD823C43334
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jul 2022 15:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiGCPNz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jul 2022 11:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiGCPNz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jul 2022 11:13:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F6BE1D
        for <linux-raid@vger.kernel.org>; Sun,  3 Jul 2022 08:13:50 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 263F9NSN008795
        for <linux-raid@vger.kernel.org>; Sun, 3 Jul 2022 08:13:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=rmUWgB/OwJOOrlFJaY/76OubjVCcr0VQglyKK/Uxh5k=;
 b=Z4SiqR2j4r1FLndO/fdMCrpJdt+Y9yWjcPf1Dt4oiAbGfupJlIsKLPx7axmW5DTOhF/I
 2zpEshMkrNmvrxqov2MHjny3B3gNT66RJKJHxW56nf+OVBslAodlMIQif1DUdUnVs3Eq
 Vgq1R3T8Eek77QYrHkyPvHDBuAgiiGHpZnM= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h3dg980n5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Sun, 03 Jul 2022 08:13:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXgiOXGFiB2FBi9oVzm2KGH8XKp7VNxd34dQnS292odmMkl+Kf8zKA9lLlHwcwLGnC0z47nLHIdUnnkJoIQ/A1/t/svcEPIhtyzJGUWUOr4pJRyFiDQOMSixi5EDobGd7LfykbAkEQxXbsAhHmTB0aNOhchAfgI7edflokxbvaDMMSRUmbqknxUnscbaX84tHEmu6J02fDe6JwFBbEkkOFlss8dRbk0k/CuptPvAliW3W2sjPzwoYDglI2zp6SypNyRkpQc70YNruyDHA60pSDzu6Xpg50WMIOs4Y9ON30lHPAh4+xNMTfPM1KRwk2ef/3d8QL1JrDC0Awdhg22VMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmUWgB/OwJOOrlFJaY/76OubjVCcr0VQglyKK/Uxh5k=;
 b=kzk07rqSLIFd9fKMJ/CFZbNSnjbPFhA8A01CkNySCEq5k7Qt9Lex0pbmIXrbmaQCeNW+MvKG0kbB9Dnge+uk5rpMQdPV0VuBiszpNeVCmO2GSGG/L5n3pc6evADpIPiZC4IyJTwNYTwNaFZcKY1NDYEDu5Ajo2BQD8hLnG1J502hea0hlgo6Jd+UTyXcJWBsq/6UvzW1a2IyxCIbjvS5aIbkuMQ/PqAHJK1mw8umeCcO0cc81rinl6QJg1MlwijVKXPQsF5MQ2wDqieqLa48V/KMLD102qZrFUdhVR1EJU8W9XpXG0AKPh2wvthcKMPmclR2kBUa1IAG7gsWr7HFiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CH2PR15MB4279.namprd15.prod.outlook.com (2603:10b6:610:9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Sun, 3 Jul
 2022 15:13:46 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%8]) with mapi id 15.20.5395.020; Sun, 3 Jul 2022
 15:13:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Logan Gunthorpe <logang@deltatee.com>,
        Guoqing Jiang <jgq516@gmail.com>,
        Chris Webb <chris@arachsys.com>,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [GIT PULL] md-next 20220703
Thread-Topic: [GIT PULL] md-next 20220703
Thread-Index: AQHYju99q0ztsCSPrEufa2zsNkeWtA==
Date:   Sun, 3 Jul 2022 15:13:46 +0000
Message-ID: <9727B564-F3B3-4CB1-A609-01AAD3C193F6@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1851a3c6-1e7c-48ef-bd4b-08da5d06a03b
x-ms-traffictypediagnostic: CH2PR15MB4279:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e3pl3yvD15FNtrZ9iktgVGEhKY+OZcoR8EbfWXck0bfzN2tq7Ksko0QGm/E/a5oJS3snT84o6kQGjLYgNKJ/AgBYFVmb7vWosw47qBmfo+Ttm9DN0eNf5n9VPXH7zTJuxch3xURZuohKhI1Y+dvB6IPPdD7/wmzurv26gVJepsnP9akWHO4s0Pmt/DcjF//P6p+pfePsg0G4ZeqKh0xe4JauoA3Jmnn4pOTTwckP+KCe7QWLQavWfgvx9UNvcD2dJ6S3ysi/wp/KXwPaFwXjQZ0TEKMtjdav4eSFyyvD7DLopEYnGO5CHDIXF+vrPhXCdFIJIQVt0f7GCkwjZ4GyjyOgQRAB7d/y2ygkMMwR/4zKg+7Bj2dRJEuZ1eJfT4bwa62lztbsFNRaBs05OvjDS5Ui32FWGALbPRK2N94XqwAPJcrbxN8s2VHma8m4PJ9+hPI0IHMz/yiB8baYaWwuZ9BHyVp30Ts3YF0Q+Ev/PSAtKADkOdkHElpm84R9EYJKPYgsMNLuUr+f4cAvlCEGGgwj8jvSFe9998y9NgKa52sPcwGgc4y3kabtt6p6CBLG5Ib4d6ynYfNTjBd0YVr9XI8h9QHbCBcBksAf5xzWfU3nXPzUE7ghTALnQSNnxKFoAOlWqMIEGJmt2a7jpayGh6OGvXR4vZVvArzO7fAIKnB9+JKfxLnBxkiNH+3OpQ7XTG42yl1frImhN3r5vtj8cQ6A1Euhuz0k70PqSMzbSSL99Z2/lCvIhK2UmVboGf0SrO+mFmkWPtHDqimBAyPIOMP4XidcK4TJItf3WlYPMv6+HvWpE5vtQlBdFtouoLm6c/ZbY5+DTUiooJzqNg9dfDBwWCcKgizYBJMEF0PC3fZ0+5qgqnPNZqgXzzSJuS6h
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(86362001)(186003)(8936002)(2616005)(6486002)(41300700001)(966005)(478600001)(5660300002)(33656002)(2906002)(6506007)(83380400001)(6512007)(38100700002)(8676002)(4326008)(64756008)(76116006)(66946007)(66556008)(66476007)(66446008)(91956017)(122000001)(71200400001)(110136005)(316002)(36756003)(54906003)(38070700005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qIsoc97z8hREjHjvEo4yWNjGJq+Nvy13j+EEYPoqnopdjQZdMjy3ajVitONM?=
 =?us-ascii?Q?0Dk10evxEOdl+rD6BDcN7yhBW2d8m+PnAwmJ7nH16EGVIQ41ZTySJtzHRBDG?=
 =?us-ascii?Q?C+60lSODMjJET20utBUFpy+mM04bxMRKfIlbBbc5M2OHzdNTXe06E+tpGcLA?=
 =?us-ascii?Q?3gX7FtD3unzAa+JN6SALEJBaOMA0YUXIrYSedhHSJZ1W39lWVk7poFR42lpy?=
 =?us-ascii?Q?aQxWBIuHn1+QMzFKk3XR0DY4j3PZe1t5DXR7sjQvMF6Wi4/3pT0OQ9vLEZn4?=
 =?us-ascii?Q?AVIiLuI8rsf3vogSDq1cwhIioGcx5Ax3sLEJQAng+bLpNTYCMFH3Mfvah9YS?=
 =?us-ascii?Q?kZ4Iyo49oJ3lo3U/GZdp6JUsOKLZ6eQ2/5CrqWw7XGmvVQN4umooE+6bJ4FA?=
 =?us-ascii?Q?N1m41XArTjIu9O5Nr5T54z5Q13TrMmeAFV6G0h1rwOvEyv6tYz9K7e9WE+X5?=
 =?us-ascii?Q?Y1KbTg71s2sc0/ICjLRmy/mxF3w5ReR0aqcX8tfnqMMnYrU+hV426NjpTpFH?=
 =?us-ascii?Q?Twmms3qvbFUh/tAsDHjnvfDZU2zFif8VdrvA45J7+z5K5ryO8RFOzBW/XBX9?=
 =?us-ascii?Q?89WTKMoDe2UBqOIRmTAAJEDe0ZaLZejHeszTFvNuKVBd5DDgud8+qbliCiKb?=
 =?us-ascii?Q?X1XkSRdc8XBJ6raednHPqXZVTvCbingPAQIcFl+X0qZhsOq+nXunZO+RBZIg?=
 =?us-ascii?Q?WZTjY0p3a+vl57lTvsoWBj+wdWcKUttpgoQig12ycAn2U3GTuYiiJ51XhPez?=
 =?us-ascii?Q?6wE0gJ9aJNOEWssyRX0prGK5eCGQ0rJPR29cN5gPcrHexilgLC0DpIpmx9Tc?=
 =?us-ascii?Q?iSFGpO4EMmo9xEscdkWCDHlx+cA5TNnfSAlinTO9+joryd4iwTYdgHXvSopx?=
 =?us-ascii?Q?JmnrY9qrsf+50funFSTsPFpmCfzEw1DefZktSKw4KzFeG9qtW1FhdWreA9F7?=
 =?us-ascii?Q?Zwms7UFsV+aNlbm2Bdc7UgITwNbxibL+cV9nE6oYEU4I5RF/xTjq0beFSaDy?=
 =?us-ascii?Q?LI0xz0WAj3KLROBphP8Ndck5CKc8+pxtLWh8R8f/he0qo9FzdbmnA+e5ICYc?=
 =?us-ascii?Q?6fsiKRj/fF61y7LWhef6yhW4+NjmP44szvZMbj1Te9bsHYOlqp6T1iQG5rYz?=
 =?us-ascii?Q?xske7dtvVGAeu1aNgAhPbrBmLNYWOnKvXR5y/XJxT58HuV5+O9vgafu/ZcMT?=
 =?us-ascii?Q?0B0xRxK1H0Orfigw376CC6SV6LhycAHH8DU9/MME4TXzp48Zem9omhwuH2ka?=
 =?us-ascii?Q?yIz7yfNPAfe4xim42vTi8fggasR4QsJahsJKLI7Xx2ByHWb3KtwhqGuypDWg?=
 =?us-ascii?Q?PuP1i94/Hju60WREOduRPbz22K4Qur52luLhhS3IWueDDebWygahANInjlg/?=
 =?us-ascii?Q?sX6tZynr9n9Ba99krBXylIrDQwO1gBhZ7diz8ELx5ngwczc/ORsqecSATnqk?=
 =?us-ascii?Q?4/VOT89VQbEiDpLZ6OJnv9nAsCqk1foECgpahrf63YqCI9fpzrUfSXTRxVXn?=
 =?us-ascii?Q?A1g1jFOkEiJwjpiAHuiLKQHcATus80C1F2Btxl6Q12LbjpdYJuu3R4p6NxWj?=
 =?us-ascii?Q?xsehq42UL6J/igqLGH/Aiwuy0qSpZOpHV0oxIkZ+xltxOo/tOy9AhhkanKXf?=
 =?us-ascii?Q?oW03ukDfrTDDynp/H83q3IM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <423B58E10F37D149883F55F9CDD67008@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1851a3c6-1e7c-48ef-bd4b-08da5d06a03b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2022 15:13:46.5334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xdETyyWlFZNOtEQzXy/kOmqRQI2J/vhtZUJUzk3G5V6yEcLwsG4WWZpRbSK+nqszYed3K+KxkLdVjCHqnCI5GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB4279
X-Proofpoint-ORIG-GUID: M6qzqfA-ORnTFf2R_mBwaE2FnFAgIybJ
X-Proofpoint-GUID: M6qzqfA-ORnTFf2R_mBwaE2FnFAgIybJ
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-03_09,2022-06-28_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes on top of your for-5.20/drivers
branch. The major changes are:

1. Improve raid5 lock contention, by Logan Gunthorpe.
2. Misc fixes to raid5, by Logan Gunthorpe.
3. Fix race condition with md_reap_sync_thread(), by Guoqing Jiang.

Thanks,
Song

The following changes since commit 197f80d97e9ccc8a496f4935ba939f3ed7432d53:

  drbd: bm_page_async_io: fix spurious bitmap "IO error" on large volumes (2022-06-27 06:29:22 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to ff4ec5f79108cf82fe7168547c76fe754c4ade0a:

  md: Fix spelling mistake in comments (2022-07-03 07:59:16 -0700)

----------------------------------------------------------------
Chris Webb (1):
      md: Explicitly create command-line configured devices

Guoqing Jiang (1):
      md: unlock mddev before reap sync_thread in action_store

Logan Gunthorpe (25):
      md/raid5-log: Drop extern decorators for function prototypes
      md/raid5-ppl: Drop unused argument from ppl_handle_flush_request()
      md/raid5: suspend the array for calls to log_exit()
      md/raid5-cache: Take mddev_lock in r5c_journal_mode_show()
      md/raid5-cache: Drop RCU usage of conf->log
      md/raid5-cache: Clear conf->log after finishing work
      md/raid5-cache: Annotate pslot with __rcu notation
      md: Use enum for overloaded magic numbers used by mddev->curr_resync
      md: Ensure resync is reported after it starts
      md: Notify sysfs sync_completed in md_reap_sync_thread()
      md/raid5: Make logic blocking check consistent with logic that blocks
      md/raid5: Factor out ahead_of_reshape() function
      md/raid5: Refactor raid5_make_request loop
      md/raid5: Move stripe_add_to_batch_list() call out of add_stripe_bio()
      md/raid5: Move common stripe get code into new find_get_stripe() helper
      md/raid5: Factor out helper from raid5_make_request() loop
      md/raid5: Drop the do_prepare flag in raid5_make_request()
      md/raid5: Move read_seqcount_begin() into make_stripe_request()
      md/raid5: Refactor for loop in raid5_make_request() into while loop
      md/raid5: Keep a reference to last stripe_head for batch
      md/raid5: Refactor add_stripe_bio()
      md/raid5: Check all disks in a stripe_head for reshape progress
      md/raid5: Pivot raid5_make_request()
      md/raid5: Improve debug prints
      md/raid5: Increase restriction on max segments per request

Song Liu (1):
      MAINTAINERS: add patchwork link to linux-raid project

Zhang Jiaming (1):
      md: Fix spelling mistake in comments

 MAINTAINERS                |   1 +
 drivers/md/dm-raid.c       |   1 +
 drivers/md/md-autodetect.c |   1 +
 drivers/md/md-cluster.c    |   4 +-
 drivers/md/md.c            |  76 ++++++++++++++++---------
 drivers/md/md.h            |  16 ++++++
 drivers/md/raid5-cache.c   |  40 +++++++------
 drivers/md/raid5-log.h     |  77 ++++++++++++-------------
 drivers/md/raid5-ppl.c     |   2 +-
 drivers/md/raid5.c         | 646 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
 10 files changed, 549 insertions(+), 315 deletions(-)

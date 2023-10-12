Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C203ECDB46E
	for <linux-raid@archiver.kernel.org>; Thu, 12 Oct 2023 06:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377275AbjJLGdw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Oct 2023 02:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343555AbjJLGdu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 Oct 2023 02:33:50 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CD5B8
        for <linux-raid@vger.kernel.org>; Wed, 11 Oct 2023 23:33:49 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39BLJb1p015038
        for <linux-raid@vger.kernel.org>; Wed, 11 Oct 2023 23:33:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=phDTaCQXELiqtAv0V9FSm5Xdai26Kuhk9ajyJVe0ISQ=;
 b=QAx18BMsKwaLU1Nzr9Y30ipIFXqm0xBALqix5XesO5HABEYBdhpT9+WE121NCh+BTxFt
 uHEkgvyDq7HDnjuYaeG7XcpUoSrfoJuKJI43nobG0DYpdEzHqmkTo9deQD3tkgA5Iozu
 U2xpEJosiUNnBOdZW1X9PfXC2Tpg6ZBlTmqRsWEb+SbKdiu+9iJgvZ+JpDjz3vO070Hw
 oM99mADLc3765rbtmNgz94MbgqLaIEqJX7QZg9GgsNWj1zZG6F+sGjrfgkQzghWm0qZr
 yIrXvgurd1BfvIWqoB4qg710PNDTSEOZP0SdAzOQ30Z8OA49CmxN2B69aKfjwMkRP2Mc qg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3tp166xaf8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 11 Oct 2023 23:33:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxwpA9vNdPOSW85JL3Do+OA+Vt8205zGtnPujRCkggQxVPVqL8P/ixy1Y4Axp8nIzjtPsYRqxXJOwNBWiLlKxt5hQ0RgTiKSHtsNaO3ZGcra88xomXuYXaliY7UYJjpOd6rTRSEnbwWtVMZ0A7G0oDvPOzUMTDf89HccKPXV5L05z/BexjJ8CwNAevDjiLzDG9PU8vLlQ7YxmPODe9LohXV+ioUi1TraawmC+FUvm42ZYO85YYbZaJd5UjqlF5Mts8ioxK6nB/PhfgJQRd3oJfMmTkxgJPiPneQvClV56/9fFEm7U4p51rUeMYbBzZGCgLSonwIZKaQKx5BjJOg17w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phDTaCQXELiqtAv0V9FSm5Xdai26Kuhk9ajyJVe0ISQ=;
 b=RUtqNawC9SWLdkpGYG15RXht6BMRyg4gtWS303oA5nxdG6rrfAJGTohIX5cFHOHucXztcPadgyV5PLSgvVtm/sZuAxGvvkldKzbq6vB6pwHGL5NoCZikk2S2NdoeDD8IjqBalSx8CIezeu5u+KGyrxkeTvlSkaSgMMlIebz+mzoKYqUe0iamQG8bfaZSX1X4zGQOmY6O4lfNXecLuRGzLDtGuo4xPjudfDcTIe2J/Wqoa/3q+Xe6wYeQHUbHzkWX378WtV+7sWXiELh/E/DsY2dVaSjGUQzMOFMyaFt16Glb982wDNnxQm/ybUzgQ1nW5/pf8fKTP8LpFfBCRuGDUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CH3PR15MB6477.namprd15.prod.outlook.com (2603:10b6:610:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Thu, 12 Oct
 2023 06:33:44 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e0e7:7606:7fef:f9de]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e0e7:7606:7fef:f9de%5]) with mapi id 15.20.6863.043; Thu, 12 Oct 2023
 06:33:44 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [GIT PULL] md-next 20231012
Thread-Topic: [GIT PULL] md-next 20231012
Thread-Index: AQHZ/NYM7mZ+CwUVMk2cTWm6MNbFqw==
Date:   Thu, 12 Oct 2023 06:33:44 +0000
Message-ID: <93D0A7F8-B4DF-43B1-983A-27DF9BF33663@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|CH3PR15MB6477:EE_
x-ms-office365-filtering-correlation-id: 6c6c927d-c537-4e06-d410-08dbcaed2e97
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1C+TKF0nRkQUyDmyRJlwMtaqGIgZH0iKrjLH4y72TKwdud6WHe3ADiZoJBOuv50ZZayH7+ZPZJTzsxPoyP5aS6VjHYaNX6OzySvGC6PMXuJJ2zuc3WsBbJhiRXetdSdrjSabytXqxUHifLqFL784MbSE6k8HQpdVE5c5l6SDdlY52jPuHUxj61JMy1yFT18wZhDKYdqqKLo1DAX2G4GiU7kxXNVzcTM5jcyp9zplwjxi+ZU0rUMGegqqPvBGFAp5zohCCp2ToB2quwQmIv1pIiGGcTBvm1M0sX/sBqwg9xnVxajxefirjpXSyTgWEANj7FIhr4RUC21oOQedXvQ+1HSfEKgeHghjvfp9GYxImuPfT0k9zLGUrdX9Xd0gSQRV+kqGB7jBoThy8gw/bm3ZxjJchneLt9E7aimMAbAvVhhwedWZrwAm5gj27jxQKIKeuCJRdQ5DzcyGCr9EUEYrtG7R6jC4NZVkoHreG6P51jFqam8ZiWYhGT+kfCHBNJNUz4GagAD26cYPqznDfM8N8oy5CuJmO4OXAAynvYsfn1RPC3E8GI9jeUbXnMkEjFZBG3UdjIaibB/RI1v8xxLbsmOMIKqKaMCVPFVrlY3NO8U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(366004)(376002)(396003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(966005)(71200400001)(2906002)(6486002)(478600001)(41300700001)(4326008)(8676002)(8936002)(5660300002)(66556008)(76116006)(66946007)(54906003)(64756008)(66446008)(66476007)(110136005)(91956017)(316002)(36756003)(83380400001)(33656002)(6506007)(4001150100001)(6512007)(9686003)(122000001)(38100700002)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bocxSfBFTNT9QP5U9u99dQ5QvOza5gMxBaANWvaGSze3WMl9x8t6U0nV/nM0?=
 =?us-ascii?Q?/HW411NUKhxxfeMykpBpMz6M07G42L11dgCzxOm3mPwpsgQYFpkEFDlBvxxz?=
 =?us-ascii?Q?KoNpSRwaqnm2zXX7jGpyWf+QHzQEvjlCFDnjGGSKfJTCdFkwEXK9GvA4QlHx?=
 =?us-ascii?Q?3rMtsTzGmw9Ug74HwLe/r3i9yO2mdpFvjkxlT5BXFjtR4tW33Oly4TOSUMA2?=
 =?us-ascii?Q?5XRXo/8Ls0WwOnQbYf3Ol+ISTiVZpmPVWPEbfZ2CdnqWyhHWJZG4wQJiMuaX?=
 =?us-ascii?Q?ZTMIPwlqTv8draD6yfOXEvi02zDZ0FqCASAOUNORjetdmn5jhJ2lqbjVZp3V?=
 =?us-ascii?Q?lZZ1l9YfFyQZ3J9sIAYzR/AGsRLjJbUE9s/ovkjoctpx9DN3lBZthNPuqcws?=
 =?us-ascii?Q?nHQP0DlcvUU6u0VdJiJPXkc0NRWWBfSwUA4VcjEkbNRAi/zUyeQqftXvNdKI?=
 =?us-ascii?Q?9Bhg8usn/lvwGWEZwEXTDiraT5TcYxJWYyiuhJqB9VIuRgY+Q43fhz9iBbAW?=
 =?us-ascii?Q?DSQZnefqr2vFGF896bjQYYwbdhtqcSjPtjVlClk/Y1RO8mKG4p47ST9bLUCg?=
 =?us-ascii?Q?BYdIGgpyZ1KdzluLY95sNBo+6qHfcvAeYvUNOlatHLcB6kIpOoe353Ff0A5y?=
 =?us-ascii?Q?agsA48K6SiqA6MO/3EmZ1YqvVLaVnXeulLt4zw9LQ9vKK5ML8EpcJNpUtZDc?=
 =?us-ascii?Q?96E/N9WYJdJV/wEerMdwIkkkUSjKd+PoCtT/EfYbk6XuEo8lnhcIMVpBlx3/?=
 =?us-ascii?Q?vZLZAWbGKJaJlelYaEJO63LrJXWDm6gUW/6Y4160JobYSA/zxL5UTr+VIsvu?=
 =?us-ascii?Q?t/8c9c8071lYqzqDQdwaujFw4dD9fWMahqacW9Q48+0vgPVbmBBH/F0bLmaa?=
 =?us-ascii?Q?o+Pk00CSh6qVE1MYyhdjoKhyQr9R/aPd+M7XiIpJQYko+rH+vxlVaHgXqhaP?=
 =?us-ascii?Q?ksLhwTJIAp1FF5UEGu7kxWES34CttWpvIbkMrA+qPz0Kk1BIrpsSwm1DddOX?=
 =?us-ascii?Q?/Q2tqQYJomzrWR8kFe5sHrBV8zNcDU/hEjfTpvCd91rJyOOhFNzvv1PqdLMG?=
 =?us-ascii?Q?xgrRFjND++qc10/1HBYKRRjM+YqVmTQq3bwT4gxOd/7pNfR/QQdk/xG1GJpQ?=
 =?us-ascii?Q?BZHIYzZ2ynPkwZFx26IJopXTgzLGzaEEHSAq5RrY6/UADel+0yNxByLxgI5u?=
 =?us-ascii?Q?gqzKYDmsk+hJLCGM4HNMW75pCSKKPvrPL7w/b+zzpciBfObstAUv2q3ff4D1?=
 =?us-ascii?Q?lT15Qq0NP57TffZChNJi2zt9/ViKF/HqMK8XhZrUA244mln0MuBUvyciQwBz?=
 =?us-ascii?Q?xJ0aVyDUaM1DIPrPseg/RPH3gFmZ69Pd9BskE4v5QvHnQ5EBzFLyCUeCxz/B?=
 =?us-ascii?Q?/Ii9K+ilM2o/Wkh9TN1GL4C/NFjIAMHbiRB0tDrF3vLR/cWOtaDWWnD2BjmA?=
 =?us-ascii?Q?n7OxOxmzzL9sry+dYDBIWrxBIwLagMyISKOC3fjtGVrZrQGoPdPzmFUs4js2?=
 =?us-ascii?Q?ojPMVjROF+L/heKs0ljVEBdw6fMrWWZV/5a2gZ32WaKdjXss2fngbUbycMGf?=
 =?us-ascii?Q?OmB9WXFsr8S0Y4w+ZW5Ic90jct3NOhZeURVWDGcjGKuScwobWNBL/2/i53Se?=
 =?us-ascii?Q?99SQTqDgNDnid+jKYIiYtlY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CD493F01DD9E9B4B94D75388949FCB1C@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6c927d-c537-4e06-d410-08dbcaed2e97
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2023 06:33:44.0721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BPTUvnIHDjuzwXW1ToJqRy1Kwt84PsB7MwFtD7fM08y2E/vwqtygrGR6cTIncydWgUnsgdZCxnuSzw3XslpnDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB6477
X-Proofpoint-GUID: ruOGtatkJvNl-aOZm57enLaphdQxWuwB
X-Proofpoint-ORIG-GUID: ruOGtatkJvNl-aOZm57enLaphdQxWuwB
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-12_02,2023-10-11_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.7/block branch. The major changes are:

1. Rewrite mddev_suspend(), by Yu Kuai;
2. Simplify md_seq_ops, by Yu Kuai;
3. Reduce unnecessary locking array_state_store(), by Mariusz Tkaczyk. 

Thanks,
Song


The following changes since commit ceb0416383988dbd5decd6a70141a3507732c160:

  md: replace deprecated strncpy with memcpy (2023-09-25 14:36:41 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20231012

for you to fetch changes up to 9164e4a5af9c5587f8fdddeee30c615d21676e92:

  Merge branch 'md-suspend-rewrite' into md-next (2023-10-10 19:23:32 -0700)

----------------------------------------------------------------
Mariusz Tkaczyk (1):
      md: do not require mddev_lock() for all options in array_state_store()

Song Liu (1):
      Merge branch 'md-suspend-rewrite' into md-next

Yu Kuai (22):
      md: factor out a helper from mddev_put()
      md: simplify md_seq_ops
      md/raid1: don't split discard io for write behind
      md: use READ_ONCE/WRITE_ONCE for 'suspend_lo' and 'suspend_hi'
      md/raid5-cache: use READ_ONCE/WRITE_ONCE for 'conf->log'
      md: replace is_md_suspended() with 'mddev->suspended' in md_check_recovery()
      md: add new helpers to suspend/resume array
      md: add new helpers to suspend/resume and lock/unlock array
      md/dm-raid: use new apis to suspend array
      md/md-bitmap: use new apis to suspend array for location_store()
      md/raid5-cache: use new apis to suspend array
      md/raid5: use new apis to suspend array
      md: use new apis to suspend array for sysfs apis
      md: use new apis to suspend array for adding/removing rdev from state_store()
      md: use new apis to suspend array for ioctls involed array reconfiguration
      md: use new apis to suspend array before mddev_create/destroy_serial_pool
      md: cleanup mddev_create/destroy_serial_pool()
      md/md-linear: cleanup linear_add()
      md/raid5: replace suspend with quiesce() callback
      md: suspend array in md_start_sync() if array need reconfiguration
      md: remove old apis to suspend the array
      md: rename __mddev_suspend/resume() back to mddev_suspend/resume()

 drivers/md/dm-raid.c       |  10 ++---
 drivers/md/md-autodetect.c |   4 +-
 drivers/md/md-bitmap.c     |  18 ++++-----
 drivers/md/md-linear.c     |   2 -
 drivers/md/md.c            | 399 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------------------------------
 drivers/md/md.h            |  43 +++++++++++++++-----
 drivers/md/raid1.c         |   3 +-
 drivers/md/raid5-cache.c   |  64 ++++++++++++++---------------
 drivers/md/raid5.c         |  56 ++++++++++---------------
 9 files changed, 287 insertions(+), 312 deletions(-)


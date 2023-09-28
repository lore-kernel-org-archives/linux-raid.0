Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35874E743C3
	for <linux-raid@archiver.kernel.org>; Thu, 28 Sep 2023 20:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjI1U7B (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Sep 2023 16:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjI1U7A (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Sep 2023 16:59:00 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D1619D
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 13:58:59 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SJWmPP011525
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 13:58:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=rcB5m4VrlgvMP2NnniMgQ3mK53v2fMS31m6gRQe4xyk=;
 b=ExHeUSXJ/gMy7d2RAY9I9oxC1Z2xmH8nJ1wQ9qrjWLjCrCZg2wO6KpC3ffQ+NBS+O+vn
 EQILifLiLSIbAxlyvLQQLS2ilYLABQU3MgEpM172HwPtG5o/Mdk3wofsU//9BD13EqlM
 AAxIEDiBOthigc6PwQZdQ//3lQziJoK4wjWbbhOp8sVhRcoZHP1KUB8DkVtOEWmAzlZB
 e1FBX3OW/jq8O/LiiIkcx1es0LCrEwKCSpo4KyVHrQWjp9BKtbCo8HUOhK+Bq8z918Yr
 LJ0WlW99pQ8cEwXkBfCdEh6pH5qUip7htchxBSQh7eJ8w5qxDY/nSrLtbWxoFDvLw2tL OA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3tdddqt4vv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 13:58:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jX8Uzx0DZa5kkj5SLpaohAQElFH9xy6ukjqLfLrhJ7XAaAw+Jx9foYEFRpq6bZZEGa5Qm6Znak7iO8kxxFPtV4gJo1Aah8q3eS3zKmAXDRzFNBYg/xrNNzXq32uOVx2+Rd9CCdo7Jx40rCcqHCvI650qwF4cI1R5chDKZ1VH11MFyDKlDtYTeRxdlA65KxhkuHkZSAgGb3fcLP9r7iysTEyxZrvzMZ9nwCUuULQlAZlndzbkYNgUC8Oe1z5CWmB6crNRA29lpDLW02ZnmYlvYs/d+fZDjEDCdYUcSLKQkGEGTSUpI1KJYqswRcq4paZ3auQJCaJHJXu7yQHhjexS+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcB5m4VrlgvMP2NnniMgQ3mK53v2fMS31m6gRQe4xyk=;
 b=P6V9pdI4bC2vg8ceRP74K5c/BSNSQ1nthpGpexG0m2xgxkfIwFx6tRKYiSl5tDuUaX4EdkMAHdct11/nRE4VYq4uWK4RMqfmWdQv6yuaRnlNWQP7cK10ZTR5fvblaFalnrNTPSKySI3FN7Dv+sESWQdyOyVkr/p7dzzkB1RguWVeUI+f3Nr44C68UPWwvz5XN7dXxiI28Q93ONXZFsTbk2JpmQRMcKXcBRzoFfFHcQQpVMhCidehqfGdvwF1CUyvT9yKB+lG0UlrKhJuukEdUstfI9VSYkVGYn8Aku0b1LZ+yoWmsZhzLWgZ2PPMpb0T1Xs1tp9FDznrCHXq22wMaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW3PR15MB3947.namprd15.prod.outlook.com (2603:10b6:303:49::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Thu, 28 Sep
 2023 20:58:56 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e0e7:7606:7fef:f9de]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e0e7:7606:7fef:f9de%4]) with mapi id 15.20.6813.027; Thu, 28 Sep 2023
 20:58:55 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Kees Cook <keescook@chromium.org>,
        Justin Stitt <justinstitt@google.com>,
        Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>
Subject: [GIT PULL] md-next 2023-09-28
Thread-Topic: [GIT PULL] md-next 2023-09-28
Thread-Index: AQHZ8k6YQ7NFHYhWFEipCa6VsOVb5A==
Date:   Thu, 28 Sep 2023 20:58:55 +0000
Message-ID: <956CEF49-A326-4F68-BCB3-350C4BF3BAA8@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW3PR15MB3947:EE_
x-ms-office365-filtering-correlation-id: a942201e-b83c-4b6c-43be-08dbc065baaf
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wwTIb+Ny2jeotVPtiVgmaG9itMDxrTo4zwkvmFZ5KmYbHLQQPTxiJCKCIPj4wRsmgIXDdk5GQfZ81zNWV0kySiUN8Exdm8b3BsKpgfK/sitOKhcPeSVDJNcIKaTY+yNl6qKE0NaNAwotrezWEMbfzdCSOWbxheEGbAExiledtrtzCM8frE96W9jiOlWY5ZmRjTN3de9+p3MIW4/iPK60PFHh+AXOT4fwHDz/10n1O0Az+ZeEU8xnhIPeaJvYcm7GPWgkWisVfeaGMg7/UBzABFn8Rt7VSYWtaheJaHyNCzQxwzRfWUT9APbM6sT4BtFCeByf9WcJQBBFcd506mc2EEInHyWzQI6KcpbD2Wzxeolm9wAp1hMMXAaWjWI38yg6jParXvOYjo6DLwTLV1pM54W07SK8wFRfnvZx1httlMUnZqkGJLmvsC/yt1rQ2nY82q76iIIEmk02GHcfPSobQxP62RkCc3deGvMClu2iXx/LbtepLZDk+xADO1s3Fy4YZZgHxfcKpog6PlrY6q8EknvxVuaUMpeMhqqDZUvdepxJ69yzPiHBzw+vigRfxZ8iWCjkudPHe0VUworoNr7OOU4k/2wZHJc1ubnq2U3ui20=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(376002)(366004)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6486002)(6506007)(6512007)(9686003)(38100700002)(38070700005)(36756003)(86362001)(122000001)(33656002)(316002)(41300700001)(83380400001)(4326008)(8936002)(8676002)(66556008)(66946007)(66476007)(54906003)(66446008)(110136005)(5660300002)(91956017)(2906002)(76116006)(64756008)(71200400001)(966005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zsOm3MdoHTbOOf97IMCiixKPXBnHZoPxLqv2NOhVYMdwVXZ7zHEYTO+mxcvR?=
 =?us-ascii?Q?d7l3dBDrMzwP6vnZlOn+/krwyQEL6L4Ca8lTKNqLtCmEJTZJrzCIXCeYQuI8?=
 =?us-ascii?Q?iv7YSFtaTXbxtQ//O+NEzZraHqefnb8UqmQy4vpq1lTVgBKp9qJ+p9r0oJO6?=
 =?us-ascii?Q?tY1KVYn7D2gAiAkrBCtPJ6HgbwEHkGoPKMCUkIlE53Bt3WyTbxVvVjbgyKmu?=
 =?us-ascii?Q?SG6SOvcQ6sG9lZLXDPo4xC/gjjnfSdALXYBPk/7OaZ5+HKtXvd1CN8BbuFlx?=
 =?us-ascii?Q?9zQL5WF7xwgV6l+uv3b6w6SXPDFX6bIfN7TI2tANKJbxm7PeUR3fO6Uhh9DI?=
 =?us-ascii?Q?O2Z2gWu9JkD/uYWWTa6YnRn5C/tBWI3i17U9CLye7GEN154xAEzq09QADros?=
 =?us-ascii?Q?XolPLSn6YQwkZ6nkyw1io7to342LmAd5ureXE4GFVInxv6QhH+dBNAXou1Bh?=
 =?us-ascii?Q?B+kiovGdSn36UhDhvtY3rMJSG/m7OpI4beXjhcpsuy3FA90rZ+kAAhj7QOdr?=
 =?us-ascii?Q?vmRX/q1ZMXUQNnRe9+zQWkfEXNCby72JnL720bQqDwWlEhflBVLkskNhFY9z?=
 =?us-ascii?Q?BkkzsPXxByZ8HcFN9aYcz3KptB6d5s92N3KUhqbjQwJASZU0Cj9eH/7YVm45?=
 =?us-ascii?Q?/2nBgVaNrtZSJbRC0wVcrUu0iFQc+R1rbDKPorCIInjpaBg/cyNjPpmvA8Ea?=
 =?us-ascii?Q?TJn3BSuos3cr9l4lprG8APOm+UNm+afeUpr7FmPHFvtosq6ahinTrusE/kcu?=
 =?us-ascii?Q?V9gM60yrDADJbpk85kCyzQmLnX8OrUXI/XpA5oTmjWvTfb+xfCFeGAnnjnD/?=
 =?us-ascii?Q?/eV61I4O1QFWE5Uvo6vaVXT/WvqzgPHzqQMY2w3d/XzuiLX+sBrIOrez0JO/?=
 =?us-ascii?Q?pp92ecn+vy02cKHSPTu7hjpabWHIpGVnNAKdpD9cNNqexENfaJoCTfD5J2+H?=
 =?us-ascii?Q?joHm90Uf5Or8q60akAH5QcUAQa3LugT4I7NcgZYbJjdj4aBXNM9BhLEwHfuh?=
 =?us-ascii?Q?MwZx8R2R7G9RZsq18TgWobtUUsFZKYqk+/IvisTphOkbbqzoj5EJMwUNIL6e?=
 =?us-ascii?Q?7/hmUL1w7unvcqa+FBPRkFoJRrDhxocL/cri+FH9GMkK4qJwSyE5MRUBkHrY?=
 =?us-ascii?Q?Id4r4zZ3tHmgHRJ6rFK8C80sh8atoGPt2o1PWihk5qO4apJPuu6azrP8mM2y?=
 =?us-ascii?Q?8afT7QSGvCfLnitO0VugeGtKfsH9TbPArXfb78dxB30fABeQrbW/0Y2/yTKg?=
 =?us-ascii?Q?ARChCkWCzogirrI4fyrpy1EzgpZ/N05mePz/rBpzo0GD+F8poj8bROCEKdxi?=
 =?us-ascii?Q?qhClPF46V6q7XPi/o6nv0AKT5sKjIRv/O/01QzxTwtqqyltdrWTxStGSybgV?=
 =?us-ascii?Q?drfOzxlGsd8111hZJVPGpaSpaJPRBcY1zd2uU73xgX/5Kpz/CMxyGawgvefv?=
 =?us-ascii?Q?oPOhtvDOXJaDlhuX6jR/mssR0i5xZS+Mo+w7mpikIOakhhvgNML3huK2k+l1?=
 =?us-ascii?Q?fvZsIgkRkJ/n3q9varEgIQSVF7VS/xg9Z9oXR4wMvIkfM9BvTWdczHr9DdH/?=
 =?us-ascii?Q?z8A1GrFSUzKWHmkSXig8wN94GQn2etQSsL34cl8etJPacJkvJp2W+iRI3JvO?=
 =?us-ascii?Q?jxeailaHElYG/Iri1fapwu8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4078B2B324088147B4DA32081EBE95D8@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a942201e-b83c-4b6c-43be-08dbc065baaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2023 20:58:55.8824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o7bgTwj0behbuDNdg/HiF7J/aXC5TSv7OSeLgAmCKxu8bZi6Cxv92GnJv2NtpBXUK7kLZlwWQiU+KHiMnyYPgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3947
X-Proofpoint-ORIG-GUID: 6vIR77v5OZiuRuokYpKcwc95oEuXEW4I
X-Proofpoint-GUID: 6vIR77v5OZiuRuokYpKcwc95oEuXEW4I
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-28_20,2023-09-28_03,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.7/block branch. 

Major changes in these patches are:

1. Make rdev add/remove independent from daemon thread, by Yu Kuai;
2. Refactor code around quiesce() and mddev_suspend(), by Yu Kuai.

Thanks,
Song



The following changes since commit d78bfa1346ab1fe04d20aa45a0678d1fc866f37c:

  block/null_blk: add queue_rqs() support (2023-09-22 08:52:13 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20230927

for you to fetch changes up to ceb0416383988dbd5decd6a70141a3507732c160:

  md: replace deprecated strncpy with memcpy (2023-09-25 14:36:41 -0700)

----------------------------------------------------------------
Justin Stitt (1):
      md: replace deprecated strncpy with memcpy

Kees Cook (1):
      md/md-linear: Annotate struct linear_conf with __counted_by

Yu Kuai (14):
      md: use separate work_struct for md_start_sync()
      md: factor out a helper to choose sync action from md_check_recovery()
      md: delay choosing sync action to md_start_sync()
      md: factor out a helper rdev_removeable() from remove_and_add_spares()
      md: factor out a helper rdev_is_spare() from remove_and_add_spares()
      md: factor out a helper rdev_addable() from remove_and_add_spares()
      md: delay remove_and_add_spares() for read only array to md_start_sync()
      md: initialize 'active_io' while allocating mddev
      md: initialize 'writes_pending' while allocating mddev
      md: don't rely on 'mddev->pers' to be set in mddev_suspend()
      md-bitmap: remove the checking of 'pers->quiesce' from location_store()
      md-bitmap: suspend array earlier in location_store()
      md: don't check 'mddev->pers' from suspend_hi_store()
      md: don't check 'mddev->pers' and 'pers->quiesce' from suspend_lo_store()

 drivers/md/dm-raid.c   |   7 ++-
 drivers/md/md-bitmap.c |  47 ++++++++----------
 drivers/md/md-linear.c |  26 +++++-----
 drivers/md/md-linear.h |   2 +-
 drivers/md/md.c        | 414 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------
 drivers/md/md.h        |   9 ++--
 drivers/md/raid1.c     |   3 +-
 drivers/md/raid10.c    |   3 --
 drivers/md/raid5.c     |   3 --
 9 files changed, 313 insertions(+), 201 deletions(-)

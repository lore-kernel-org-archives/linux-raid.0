Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D02C32792
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 18:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbiHXSep (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 14:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239783AbiHXSel (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 14:34:41 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D3E79A48
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 11:34:40 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OH7RCp024397
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 11:34:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=0w8ROEnarWRD6nHsbSCKJYhpHHVu4ssBEdjru9ru4es=;
 b=GmwDgej8geoq7t+oKlDrjxIS0opHqMNYdGpANDPjEhsQfypRg05wpgKdfzUpbvGRUYrk
 buC4ahyd9rIrvh1CMsRD9h0YnttvaA0qMMOqFp5HFQyYX+azQd11ViZx4zbLhymbzV7N
 +515o/goqZF7MEjdNSds3waxIbKpmLrCSzM= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j5a9fwf5y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 11:34:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aO0f7fizMajjOdRbCbzqnY8yQKfo0cEpaGvRl6Uw5CORgaIxQt7N/hPP86Tfixq99qXayhVh+f6kUjs4lOPx8GTBukvhnY1laExKLprRtLcKUut3dOCZknJsIu0ErcGlcHnD+B6XtWEPg6baW6mFDaitBUcvZRtRys0hyNLNsAZ4qP/o1pThdewqINhIYA3pZ1XtdXAuCd8uxt7XeCgk2JkdWwdvZpei3HRIeGwUPwGM/mywN2yXZyV3OQbTa7us0DP3guzaZFV92SpNVYYnzxxwW9qPxm3ZK8o0rz4omCab2vxesAu3s0JLoTHG9y239306nweSWhEj4qSVbxCxMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0w8ROEnarWRD6nHsbSCKJYhpHHVu4ssBEdjru9ru4es=;
 b=X8RunPz1xyjX6Etpz/Nn0yl3vYLh4FUpxXgFYhfYyJSr4nCXY8keu2CMNs7c5A5PB5uBml9R9Qodku2+3JrQlska7YIrj8BA8ah2DOO1Dwq+HYrx89ScLUpRSpy71P15o1GTBWlmU/NmCWilu8UFgRjj9GUktK+8Ips7vDOMd4Om7sP6J+23qzchDDxEA7XAz7dvUnSmLohKWS/T4aE3nHKmfqW6EZNIrVjWPe7iXjGYu97fIj7Fpw1mwgD1ZgTHXvi8wtBzZFoFznf6FTPsu+2prAIoRP90eQBcFeck3RP4fpSqBbA2CkFufdwTNxKEmWkaqCb+ZGXhaU5WeGQ5tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB5104.namprd15.prod.outlook.com (2603:10b6:510:c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 18:34:37 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da%9]) with mapi id 15.20.5566.015; Wed, 24 Aug 2022
 18:34:37 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Bart Van Assche <bvanassche@acm.org>,
        David Sloan <david.sloan@eideticom.com>,
        NeilBrown <neilb@suse.de>
Subject: Re: [GIT PULL] md-fixes
Thread-Topic: [GIT PULL] md-fixes
Thread-Index: AQHYt+eu+T+va+RoAU6I/0n49fq4Va2+YISA
Date:   Wed, 24 Aug 2022 18:34:37 +0000
Message-ID: <040398BB-0812-470A-BDE1-4DC361A0B433@fb.com>
References: <FEC5B8F6-0165-4CE7-A1F4-F7123D37B858@fb.com>
In-Reply-To: <FEC5B8F6-0165-4CE7-A1F4-F7123D37B858@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 473539f0-b573-460f-9f79-08da85ff4cc7
x-ms-traffictypediagnostic: PH0PR15MB5104:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bwGbtUyAekaU61aTxVH7aIJf/wcFEchgcIOI9GRvk/XsC2pbwof6b5QWAb6igBYrTfhn/ZvVLIUHqckzfkoh1Lxjxhpm8yv2njQUQwl1gM6Dzmo9yEe1P3QAVmBiFSmogvSGyd0FrxcTL4dl/ZVCGK/duLNiNEUMkhEpPsFSoZRudGWAQhb3JDkvFCc5m1K3gl9nQwAPhARkO4qX2keUbdudzCMaKnDROFYk6hFYMm+QVw1DmjVrbLOHg4HY+Wy7pV6uNIAzPXgpAtr/FRdbqPMse6vuiW0ehyus1sPRW+UPbKJCR10ycZLaERloBBboK3J7Qzn/D3T2+C2Vf4RnEJlquRNmZa/zr6dvG6K0T8qy5P1cJ76EAKnB5Yix05kxUSbgqguHKQrkcQRvIEN8a6UhHlGtp3J43+zocUw1CPglscqFrjKHM0D1cAJdZalQQxQwq7HI6fGH4YCKKNXkoOavaM7bhfaIglUXX/LiL38G6dqf3zRs3Pn85p50BpRE0vCm2rydTUjrhzsyVoNh3FfyCBWGnOgOx1L3SAceXRq4wuR4dSko4dBXl9LUDW4iTEIo5FKJ4LZQw/ImdyVO6rxk6wQeEoY+XTsc6Ys9RYvaFkB5iKxiVVC0qcPYphC+90SvMR5O6TDsnG0nlfoTDECHRCowUHhAHfFF/RlsZ2TCGGJ6MfW7wGmRlSPpJzSWG7z79XzP7EwobN9/a4Jg6GidDA4bunZn3ZtMMYy3NQL8VC/gZ2E5z86g28O+pD08mOAwPeNWJ2o5HWJcSrv4V8MbINiFM97Lw4Ke4VqotLKp2fhHqaqqSJbjKv3Nno/tpuf3a02IUqw6r75uir/beA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(6506007)(6512007)(38070700005)(53546011)(2906002)(41300700001)(86362001)(83380400001)(316002)(5660300002)(8936002)(186003)(38100700002)(66556008)(76116006)(66946007)(66446008)(91956017)(66476007)(64756008)(4326008)(8676002)(122000001)(2616005)(36756003)(110136005)(478600001)(966005)(54906003)(6486002)(33656002)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7+uN/n+iBP43wBxDH934hZ0x2eSnz3LxUieXxy1E2RyeVpBOFNjkegHFjlep?=
 =?us-ascii?Q?lGZrllatafqXN3iecIrMvoTdXZj+mkZ4M2PXIQu5VQmk18N63vUOtYWgAO2g?=
 =?us-ascii?Q?chcRQA1Y+oiosNtzOZ1tGdCBYsvnIH8oGSxVuoaG2VgQpKUKop76hZ4pbSS9?=
 =?us-ascii?Q?cc+xcph6C+o98OB+objhgn6vC32knd5A2smAB6YHPjVdQY1rMMXdhQdQulGm?=
 =?us-ascii?Q?40TUgFCZ9oJof9OOWoZcm6gpTYVmsvVlbRgEVGt4NIdexnW2d6Qw+Uu23KWM?=
 =?us-ascii?Q?hJSWqqO8c4YLdU3eeAYOS2URdXMuqQsaedbAeRwEyXIoGOUHEE5fJiKgWGn1?=
 =?us-ascii?Q?Q3ihu04weidDqCh6URs82E5gDvzuEwQmZQRbIbBWYKEROuw3sJC5sXKK8y4F?=
 =?us-ascii?Q?k00i8/bes00S6wdlcggHyMAHT5KzWh9quGktq/KvcBUhe3AYD8BvAUos6J/7?=
 =?us-ascii?Q?fdKwbaoddJOACHoJoe8Rxh7itr1DAJ0jTGpz5XTuPjouzsddHDmZPq5yHm6r?=
 =?us-ascii?Q?/PBqt9NCISsesdRQak6U1dyWpKv6JFquQ/LbBoSqz5iIDlPxfUsnVldcK8R6?=
 =?us-ascii?Q?5fi+UpuoR8QeLxf1bQ/mD2yB87TOTMT2RGWOlUBQxbprN4RIETfJQFsEZkVD?=
 =?us-ascii?Q?aqETSVeuKu8bb1LFI2De06/BfqOFjrEPlaJZ+oS2HZDLSgZj9yrpochesoF3?=
 =?us-ascii?Q?a44wNnZRnUz1wYQheSnnzSQt3PbiLGafxdnO2YC9T0nTcFcABMKGzjew4DVF?=
 =?us-ascii?Q?aq1wrU94wBFZWcDjReekqGE7rlXtr+NVHoZoOFxGBTP3twZuCW3yYOeTCG4v?=
 =?us-ascii?Q?dOIwS68tiZHWzoCykh+vvQC+6RG/1XLAHWGXE6una/6yJY0Enia008SJXiHY?=
 =?us-ascii?Q?LpoKFnnBgHhQ/5upw/vQ8Ja4aaiNiVBAUK9ya4PhEz9OFVguejUMcxnNonE+?=
 =?us-ascii?Q?oa9+MljbTh7zAf98yae2AmF3qIWiGKehqFsq93pYAxmwuI3XLbaDbyUS6Zno?=
 =?us-ascii?Q?GbIM6gN6Dqh8bje/b7Igq/T6ESnbnmkfu+758msXmymdAJWm6PljwVcepQJw?=
 =?us-ascii?Q?3K0jMqc896QkkQlSVaXAfZQS+eZE+PmFIerU6if/XYXT0So7PKn2mCO4+G/0?=
 =?us-ascii?Q?/ZO0I2mNeqWbdIkOLw/1i1WCpRH6VoMMLSJfsJyGodH0u2boL1kY1bzc7ysB?=
 =?us-ascii?Q?ZPN/EKFxoiuRmwy5N4AZuhSxiDYZTycLehbXQWxXaNSR1DrA/0vmP5KBebJk?=
 =?us-ascii?Q?VTrHgi+S7zieHJ3z5rZ+DvxIoolrh7MWqX4s0rzOH2xvJG0BUGpn0mCeLE0s?=
 =?us-ascii?Q?xk+QryQDy70bPharOIx4K+h59+xfcPW6FpZLFJCQR82fgfx7JwBaUsKtJc7r?=
 =?us-ascii?Q?Si74Ap8wEcFlRTjS04gOHiMZbaVnBRgHqhzVqj2QZcICtRfC/x982Ymb/qUU?=
 =?us-ascii?Q?uhw6deHFHJ19yU4WzMLSQ1tJR3s7Huf2cBpiC+25qaUD77z8oO9wI/zj7FuW?=
 =?us-ascii?Q?HYIlKm2MS3gew9Pix7JydthSi1n+BuaShpUbTvfWbxXIq2Z1WQX0pCeey6sD?=
 =?us-ascii?Q?E8jcUpVXpV6XdkBe+SdpWtGqy0MBohL0sCR2K1lUlG7jifI7dis0k8CyCRUa?=
 =?us-ascii?Q?DtGwhfFZCcBgacfGamwt4l8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AEFE7849980F0B42965F4E4F81900ED3@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 473539f0-b573-460f-9f79-08da85ff4cc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 18:34:37.7183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dxe5ptUSHJwA/uFLO3BJhpRI93oTuM3vKOcnBwCNi9Db26DZFkmY2HBNo/TyQ7apdwbhFfvQbANRiXCfmhRMrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5104
X-Proofpoint-GUID: FbbxQUKxKB6qlNrd3CLg8dGG0dpzzQcK
X-Proofpoint-ORIG-GUID: FbbxQUKxKB6qlNrd3CLg8dGG0dpzzQcK
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_11,2022-08-22_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Aug 24, 2022, at 11:31 AM, Song Liu <songliubraving@fb.com> wrote:
> 
> Hi Jens, 
> 
> Please consider pulling the following changes for md-fixes on top of your 
> block-6.0 branch. The changes are:
> 
> 1. Fix for clustered raid, by Guoqing Jiang. 
> 2. req_op fix, by Bart Van Assche. 
> 3. Fix race condition in raid recreate, by David Sloan. 
> 
> Thanks,
> Song
> 
> 
> The following changes since commit c490a0b5a4f36da3918181a8acdc6991d967c5f3:
> 
>  loop: Check for overflow while configuring loop (2022-08-24 06:52:52 -0600)
> 
> are available in the Git repository at:
> 
>  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

Forgot to update the link, which should be:

https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

Thanks,
Song

> 
> for you to fetch changes up to 0dd84b319352bb8ba64752d4e45396d8b13e6018:
> 
>  md: call __md_stop_writes in md_stop (2022-08-24 11:19:59 -0700)
> 
> ----------------------------------------------------------------
> Bart Van Assche (1):
>      md/raid10: Fix the data type of an r10_sync_page_io() argument
> 
> David Sloan (1):
>      md: Flush workqueue md_rdev_misc_wq in md_alloc()
> 
> Guoqing Jiang (2):
>      Revert "md-raid: destroy the bitmap after destroying the thread"
>      md: call __md_stop_writes in md_stop
> 
> drivers/md/md.c     |  4 +++-
> drivers/md/raid10.c | 13 ++++++-------
> 2 files changed, 9 insertions(+), 8 deletions(-)


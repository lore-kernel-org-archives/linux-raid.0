Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51CEC6FA8B
	for <linux-raid@archiver.kernel.org>; Thu, 22 Sep 2022 07:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiIVHHQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Sep 2022 03:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiIVHHN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Sep 2022 03:07:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B2AB7755
        for <linux-raid@vger.kernel.org>; Thu, 22 Sep 2022 00:07:10 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M29Y4H002849
        for <linux-raid@vger.kernel.org>; Thu, 22 Sep 2022 00:07:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=JWHJJCnWcNNDmyv2Nne2ogfbejbNK+Jl6jjhtwcXAh8=;
 b=flIWne0QPD2P0wL68nUx2LCqCvMauC4KESZUCSm8ASLJFtv5TNhaIwDqVGSaqWU5HigF
 zUsR12y9szA7DRw0cz+cPTsYtSHel6Xh+/GmwYsca+3MGAT3hx+WyIs72vBcN/yxHnbY
 /btFvhj7ksLvFDtJGEgsqE9HYy0oN9f6z9g= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jrenw94qh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 22 Sep 2022 00:07:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7zM2i8burF3ApP9vm3D4Y5NLgwPwhOa5xD5XYvCYMsveB+JZEUIumh1tuOK2WIVKlxCYCzg5cIkcbSNqgV2kUNi608jaMIgRzAhHctFhgqB5PLZfV3Iw7/MshwdMlAPPLbe+CVU5+xD8YIl2v5ESZoNWoaDbdNV64BY9vXVw4eU+yjd11lOSr/+aA0+0popKcpyz4/A1ddkwSR1tY+DNVnBEr1292sr0k/hfF9KLdMP5wTyletP09/JsagXtW8e1cQQZU5JhDdyhGcfUtelt68OTl3ltoQ0a4R1v1PRXOQmmdiQEdfhIAtI1ePhVxhGbPm3P/iTK6tM6E3EIY1Onw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWHJJCnWcNNDmyv2Nne2ogfbejbNK+Jl6jjhtwcXAh8=;
 b=ASkNLAaG2zitOlpDfZVLBJMCXthM71zIhzq++OM40UO4+uD1WtkrDXj8xib3RKUpDNiYj0DdN2G4KL50dWyzRzWAzL/SLFJg2Y5ojAim/8gKY5zZXokd9deoxEjNyylP+YU1wjIWEoKE+AqsO6k4DfLytbCp+fJCSfuMJj/kscU6FUCawbZ+U74pfTb/RMSROHMKanT+JQDmTtwvEeKmbDLPEhdCTSMTLSTlhYSOP549lwibDazvTnTwwkrBL5xOWR75JDHIpFCiIrTAIyDCunUXE9VnS+S6wYBHuH0Etgt6DK5BKWZ1UQFJNLcSUK+9ahzU+YHCPgBb+RjMTY4g3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB3974.namprd15.prod.outlook.com (2603:10b6:5:2b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 07:07:06 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d70d:8cce:bb1:e537]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d70d:8cce:bb1:e537%7]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 07:07:06 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Logan Gunthorpe <logang@deltatee.com>,
        David Sloan <david.sloan@eideticom.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        XU pengfei <xupengfei@nfschina.com>,
        Zhou nan <zhounan@nfschina.com>
Subject: [GIT PULL v2] md-next 20220922
Thread-Topic: [GIT PULL v2] md-next 20220922
Thread-Index: AQHYzlHsRap51SLhuEqTol2+ZDTwjw==
Date:   Thu, 22 Sep 2022 07:07:06 +0000
Message-ID: <68A2557F-ED5B-4644-AE9D-97F3F9881BA1@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DM6PR15MB3974:EE_
x-ms-office365-filtering-correlation-id: 6097c4cf-0aab-4d14-fcc3-08da9c690eee
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mfIRR7vTQh8a/IwWu1/7vON0fqVVG2lwBAmuQ0y1jvyR5xj9j5YTIEuD6YNeUatZv2AjvZ88UU1QVzo1vtoVAgexNzqxIjFbSseat2yzsbb5/k0LtAmV0wm9XTmIn8tmMh9wbR6AGNb32HpMW9Tx0WJ+se/vT6DToaxrKFVDLGohjC4SZPwAayskO782+hsFa/ZmC3Dr3hkrCMbhR4NVP8q8t2ZteBAOKyet2WS2sozUGYfRCBcag+i6aJ6nH2EddXCGZgQF6nBjLLEpEFgDXl1fObCHPFneSV2ger12aOc3LS3SPuhppt+hrwAJIg6dRUFUDoFPSaFpTxYUnAtiCGsQbVZVVdeRofd48YNf3S527LN1L/MfpVreyPCpkwK6ivJKPjmo9j+xPzsszzN42dWKPls3LQ7EYfvW/+e8SVDuzmJaTf/wW6yVPMnnlQThw9pEfydnwYDD7dpM7Z92qYXFJs58adWqIKUJaZda2ihehQmyL1YHEQnZ4O/CV1Q5VwCBRCNM6F0NvePgb8g3mMWDoDFvVQG/lYeasmqzFT7bFiHXjVi0aG5ZziehqIa5aCNhQIQHY6T1JbCxedO5cK/QFudNXJSNX9TYzd6d6EEKK/ySL9ktjaACBakHs8whoJixVA6VjY1KFbY7JMP8ouObz7+z3cDrbK2UMo7nVQtCYkk2Mq9OJ9fFamnT43sl8Rq05hvnT99UseOktNnEqk8cKkWyJyCD/nsA82dGKayiiLJTKLfGSSineGLBpgxK7qoBwctj/VtPywSDtQNxGmDR4/IJXcRI+5cTdBdGxRI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199015)(2616005)(6486002)(83380400001)(71200400001)(66476007)(110136005)(41300700001)(6512007)(91956017)(76116006)(4326008)(2906002)(86362001)(5660300002)(36756003)(316002)(54906003)(122000001)(6506007)(33656002)(478600001)(186003)(8936002)(66446008)(38070700005)(66556008)(64756008)(66946007)(38100700002)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CZH52JNuySmwV7uzgLwMG5X3a70eShSW+x2bCTa/Q0RSlQGraDLklDQ23bBE?=
 =?us-ascii?Q?nm8oLx5bDhf0JKIlkw6JxmggCVrFh+BjjH1nRTSPgN8UUTnOt5SInLAzDNDP?=
 =?us-ascii?Q?MX+Jb8qkENB5NfjuhAUP03PSTZTYzE36POrZCFQLDNnRsr5GFP6p/vDD4Lua?=
 =?us-ascii?Q?CtySV369oEJSBSweJ5h2kii+mqiAEhQ5GJMuuyavT3DKNVFrCmbOQmiJMZRW?=
 =?us-ascii?Q?A9Pu1cfUwvsJg2CVZrJyGOQBEH8wY+8NJ7H60wwdKsi2uwfQrwIEai20crHw?=
 =?us-ascii?Q?jUXiQxXJUOO6skWf/XZrn06Zq810cLxQhiIHMnQpm/O5OfgQaj7GfLSLSwrZ?=
 =?us-ascii?Q?H6A5LNxzEArvhBxCfvj+OzMp6T4krUsv/QLWVWALWrqEg+VbeLN3p1gEYwj/?=
 =?us-ascii?Q?03ui4pe3ylPFHhPPtpKeskBtG8h+x+Ue+ivMtMEon4hMUYW89IGtRXo0v2g5?=
 =?us-ascii?Q?Q7QSAh0OkDiQk9XLXoVDBStOHp2MIALEXk6hiylOj2jjUNAbISnU7gnkxPWx?=
 =?us-ascii?Q?YqQtsNMQjND2ejzS5KV/VEIqTIHifuGeNJ3uk/0sOb42wA/Wiq7R+3zEYGuu?=
 =?us-ascii?Q?oO4Rgj71UUC6TyHD9e4t8ZVdJ6nws15hFm7V3c4xmHgiqcM2fQy/Eo2JIE9b?=
 =?us-ascii?Q?llFthCqf385DCf2zpz0Q1Ll1jOiCPjpcGstm/sWxNv+AQ6u/Brb0J0Y3AMoH?=
 =?us-ascii?Q?kOCirqk6T7wvUxm4Vsvacm6v881blPk4Bt1ISJJkks3O0HKq1zRodbl5rudK?=
 =?us-ascii?Q?pUbHTgFwuqOsVTNljU8YTLMZbkesFcxnEE7ofsriexrqMQLtLkKKjMIj1Por?=
 =?us-ascii?Q?N/kSNNGE2AbqHhuMT+BSeReN91GtmsnQ0KqYaMuhmRkIbGVmysvZY7tbANpU?=
 =?us-ascii?Q?f2ESPtOLOSxt4yqybFGoh1MJR9c5HTBWu2P/T0a+sK1x4wbjgX6ITfI0CiXR?=
 =?us-ascii?Q?mvAChfZgCIN5hzgNwq3QZk4U0uv36x051OjTSu9blcmLFmK1WJqEuYjUK2O0?=
 =?us-ascii?Q?ShBM8DQ5t2/6Chqc/jaybf4S49AubHYy3VHgzW5bUiQBSYQEzBT7JQHfax9k?=
 =?us-ascii?Q?N8XNcYGnDO9Q6j8FVkH4IDSIgA89MWATLbzMmIHLliC6mrEgyb4WbYZtqxmI?=
 =?us-ascii?Q?jBIi3DhTJzqPG6Acu93TYCG8VM2qNddoZH+Nbm/NrGBCBzrKBUV8y13nw+Ux?=
 =?us-ascii?Q?SMy9jzdmW51uUIBl6QRJW4qgBtCXKkkooToeI01OiikbzU5QKdSC+TfHkJFL?=
 =?us-ascii?Q?jWXxl2DX+0a4u/6vH5Cr8B+G9Fq0VVb0oQ1Sh/0sc5zPJlZy8U5YXPrJ9Cjb?=
 =?us-ascii?Q?K/u1+fMbUvpDP5A9k5muZpPr6toCCvBygKpSKvu00+eBeEVXdMSh6hea6Q9D?=
 =?us-ascii?Q?s3HmaV/kA00ZxsVmUAwhDhmdjA7+ojLmgTVTjfcG9Cgd7jeTwlXjG+gVT/LH?=
 =?us-ascii?Q?j5h21vdq7b8/NkH6pTlzAph/m2yBy0COopVFEgIAvYPqs0PP9/r4ZqynYaWU?=
 =?us-ascii?Q?wCjQlGXqVZnMs69leljZNHel57gHnqG/636p8vJwqWRf1R2aRUwTQqf4fY6W?=
 =?us-ascii?Q?f5UznKOzQSkNi5bswBvhrkFSoPvMTcSKvoQYjTXGgVmlYA71H987lQoFSAIG?=
 =?us-ascii?Q?QRbMygcGMNncO2UugWJWECc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6F67E98D98268A45A8E6B8656468AE02@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6097c4cf-0aab-4d14-fcc3-08da9c690eee
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 07:07:06.2072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QVfGDSs0m+Z+BDnjVFwoxq1K5tLwdiphFl1HaI8gKoMLDxGDy5Lb01O6zLW8DpIG4oKvVWmhUUsUs+IcMJWt6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3974
X-Proofpoint-GUID: jgHH2gU7vw8DsxFDhBcAG088_OuV2nhG
X-Proofpoint-ORIG-GUID: jgHH2gU7vw8DsxFDhBcAG088_OuV2nhG
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_04,2022-09-20_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

Please consider pulling the following changes for md-next on top of your
for-6.1/block branch (for-6.1/drivers branch doesn't exist yet). 

The major changes are:

1. Various raid5 fix and clean up, by Logan Gunthorpe and David Sloan.
2. Raid10 performance optimization, by Yu Kuai. 

Thanks,
Song


The following changes since commit 9713a67067897a9e372c52124f72f8e00b2e6031:

  block/blk-rq-qos: delete useless enmu RQ_QOS_IOPRIO (2022-09-21 19:50:53 -0600)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 65b94b527dfcb700b84d043c5bdf2924663724e7:

  md: Fix spelling mistake in comments of r5l_log (2022-09-22 00:05:06 -0700)

----------------------------------------------------------------
David Sloan (1):
      md/raid5: Remove unnecessary bio_put() in raid5_read_one_chunk()

Guoqing Jiang (1):
      md/raid10: fix compile warning

Logan Gunthorpe (7):
      md/raid5: Refactor raid5_get_active_stripe()
      md/raid5: Drop extern on function declarations in raid5.h
      md/raid5: Cleanup prototype of raid5_get_active_stripe()
      md/raid5: Don't read ->active_stripes if it's not needed
      md/raid5: Ensure stripe_fill happens on non-read IO with journal
      md: Remove extra mddev_get() in md_seq_start()
      md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d

Saurabh Sengar (1):
      md: Replace snprintf with scnprintf

Song Liu (1):
      Merge branch 'md-next-raid10-optimize' into md-next

XU pengfei (1):
      md/raid5: Fix spelling mistakes in comments

Yu Kuai (5):
      md/raid10: factor out code from wait_barrier() to stop_waiting_barrier()
      md/raid10: don't modify 'nr_waitng' in wait_barrier() for the case nowait
      md/raid10: prevent unnecessary calls to wake_up() in fast path
      md/raid10: fix improper BUG_ON() in raise_barrier()
      md/raid10: convert resync_lock to use seqlock

Zhou nan (1):
      md: Fix spelling mistake in comments of r5l_log

 drivers/md/md.c          |   1 -
 drivers/md/raid0.c       |   2 +-
 drivers/md/raid10.c      | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------
 drivers/md/raid10.h      |   2 +-
 drivers/md/raid5-cache.c |  11 ++++++-----
 drivers/md/raid5.c       | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------
 drivers/md/raid5.h       |  32 ++++++++++++++++++++------------
 7 files changed, 204 insertions(+), 142 deletions(-)


Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F226C4332F
	for <linux-raid@archiver.kernel.org>; Fri,  2 Dec 2022 19:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbiLBT1h (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Dec 2022 14:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiLBT1f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Dec 2022 14:27:35 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338C8FF7
        for <linux-raid@vger.kernel.org>; Fri,  2 Dec 2022 11:27:33 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2B2HlDei009481
        for <linux-raid@vger.kernel.org>; Fri, 2 Dec 2022 11:27:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=LE9XlLRkPRL4NN6vjwecDcIn5jorVwiLjkWQ1+7JIIs=;
 b=IrzKBh9GMbEAmGGAozpAPVyfk+wEHBczEfGb3mvu8kj+OOcjvhxImbOCOWQmcl8s40zH
 WK7uvydIWqTKsZzSmxLE2lJdhYTy9EcxXeSbkhlzTbhfzH8HlJU68n/Hn/+2Xn9uWLYq
 KJr+v3l8uI78dUrLEpdpHB2LFBfFdIaOqyQAuVRRBgIaAgxZ7nWlWsg9sjHYCmLstZY+
 Nwpb8dL5fsxDAiHnAPzhWlUT7lFsrZVOkR0RsqFRTG3MMLrwEx1S51HYrxq2t8iVfGln
 nWhxp2xk6rEOCmkD5OifI1GA1wren0NJ0rqOCwZozNvZqmYYmOnp5IApZxRiMBPZVhJR cw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by m0089730.ppops.net (PPS) with ESMTPS id 3m6w6xn0sn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 02 Dec 2022 11:27:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIVeMbLo2I/UE23QgKIIkwpBcg49uYZOvrQTlF26sSblkKafESWOeOLvuG7sCAYvMSw2d4gDNf0wbXo5ulYFefkr2f/L0/3B0ymygELteG0nmUYWu6dC6wi+N85770r3aT8NPFYhTqobOPZGzH9YsrmW14MufT3xK/SV8UcTdR8CdrXibl+gIwtb9h7jFTgeAhZm/Mlwmv5p9zFuIJ0ufuzwVQUYV518UhVh9RPQXaKWfi88uiSn3unP7mEXBtoW/Hs/0bI2Pe0NroH34I76Mlucv0WkinNi3U/5q3aRQMUUsQuVwSqO1PGnwJkq3Ml0HJ+U/Uu8lJQVYFbTvca5Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LE9XlLRkPRL4NN6vjwecDcIn5jorVwiLjkWQ1+7JIIs=;
 b=aTa3RsIhAUElamDmiNWsMFpbziO/Df/uysh0sRkhounlJl1TOQNCfgTUlnVgLdF4f5jxI1GTCkTQ7Mo3PO8UPEn+rOJaZsJRz1b4XYynyfkrbDBh2sF8g5QY3xHNMei17D3yYwPf9PF+vTWtPMShVAdsSgulM6b0VMDHAJo1BPiP/pGQcHNQtsz6VGP33/yH4YAgBQGsMCDTA9O3GeIs0nAm4gWCitmCDTULSWlkbvSacDFbPWjVeTXVni7NBnk9Th6flwUQ3uT5SGTMO8vJ6B4+EazjzlrvfHrAKcW5nYaO0P7+4eSeAwCGnkIYOxgbtI3pvp5GDn9nAwNtOyZJww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA0PR15MB3790.namprd15.prod.outlook.com (2603:10b6:806:86::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 19:27:31 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3c4d:ca9e:8db4:f7b0]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3c4d:ca9e:8db4:f7b0%4]) with mapi id 15.20.5857.024; Fri, 2 Dec 2022
 19:27:31 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>
Subject: [GIT PULL] md-next 20221202
Thread-Topic: [GIT PULL] md-next 20221202
Thread-Index: AQHZBoQeaNmGtLXvJEagNYbV66m9jw==
Date:   Fri, 2 Dec 2022 19:27:30 +0000
Message-ID: <050A7AA8-4E70-47A6-A6E1-0E9E78D57604@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA0PR15MB3790:EE_
x-ms-office365-filtering-correlation-id: b4367677-e202-4470-de57-08dad49b4180
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IreVapyljfuIvzGVNj3f4XqIFCO0rpVBa3LTxYFIJ+eiTQk3Ngk5vYySTMKfXSXhsVcXC4LaMdHsoT6bHRe3HkykpKca5WQurmHXPqVX+RZzq7cO9/qfN3xbLCR20npfigc1YOQnDhfa8gTjWcoHEw6fZ+AT9l0SKDRS6a9HUknoSo1AwTQmwUaWA/dBapbDnxgfu6KtihUT8fRoM5lEcARKUpwo7ky1Bs7IrpPtplwLNveHhojAHZYFCSiehQ4u5fUWaHMCDno9UO7chG9fVMYJxMY3raONZpSRLLrrIaQq0Jyq8A+TQfpcqqkPIBc2fnUWd7RmqsJ9oqtfSXu4reuziF4pdVKqZBRtFG+HOcUgf4AS15FQjygxc8FNsaWhdWfuv4AjIE8aOk8Bmgb3ifp+f9c4lw91FQ84Xd67Kljea7kebqnt8jXBvu4FPYHDfB5C8bLAGqp6WtqIPfrdLSfV+9YP/PSbCzYDkLixlGhMpUmf1jO6YdOOeihRZx4AgrN0XyUJfHFYb44JobXgfHkkRSw+/Gfw9OOg/tY6okn6lwMYW4nH7t1Z8/+HTbLxYu9A0vlO65k9X7qPTqzG9BmXIfg7xSOR3Hx4+0oJ0KGWx5Cki6tzK99RieX8nw5Nr1zzIBoDSsNLYvUuA/bALGpPkaYPPYfWeZgGghqzWZ9NyW0QxBhVZRQPFD5CgQlMg2Dg0mCxy3lI7Nyj+ZmVUALHFFhqolQApA9QpHMawf0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199015)(38070700005)(36756003)(33656002)(86362001)(6486002)(966005)(71200400001)(478600001)(186003)(6506007)(4326008)(6512007)(4744005)(8676002)(316002)(8936002)(66476007)(110136005)(41300700001)(76116006)(5660300002)(66446008)(66946007)(66556008)(64756008)(91956017)(2906002)(38100700002)(122000001)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CPro/Ykw9Y1S1CKh8BhpBycS7TfVl2TUz188uxRA8RvOxkczEaFDrAc2FiNk?=
 =?us-ascii?Q?YMRSFC3cV/vMiqN6PcMQCP1WVKfldAWr8GK5/4CKe/031IW3Zkkg0JbDcHKD?=
 =?us-ascii?Q?6NL8BRj6BBY/fpOKzzvTfdIX5negfb3s1VtD/dIfsPaPcMzHPM6KDX0LWoPW?=
 =?us-ascii?Q?vp5VzC5qHwYn2306By9udKxdfPi0tEPNQ0h1hOKDOV6joPAV3TWKcrbjTi0x?=
 =?us-ascii?Q?wNvDzWbYZ2EGx8B91f81nMPu0uIvm/ggsaXMDD7PfH/jY5NiyREf+enY0ewX?=
 =?us-ascii?Q?btZuFrhcFZGjQl89ybMYu1dfS0dm9I6o9FCDXAOMDmCBpkL13jCNtypwoHuu?=
 =?us-ascii?Q?Fd3/AKznhzJYmYe27Kq/eE/nhAlUzu83HiywcUtVwl088OQJJA3mqIxU5fei?=
 =?us-ascii?Q?KLcYGC+Cw+fJ3Wb9UBMcpinxeiZBC56U29TAH9Ltm1QdjnnWGV8W/a1SPWdU?=
 =?us-ascii?Q?nWmpWpNO+wvkVPyfWKkEkF8McuKrU/PkY3DRy1WQ8NZD04q4Pb68FC983k4M?=
 =?us-ascii?Q?HadQEKJZcxgKd07L9HZPPn8anaTWQmbFcMQS/GWfihRtk7rJEZxL+2p1DY7s?=
 =?us-ascii?Q?1smXl2Bg+jn+/az28N9lkpHWIPOzU4Cubw+H2M4cPs8j8oO23qLO84TDxqKN?=
 =?us-ascii?Q?PCzRDn/kV+av7nnDHb9O5Z+r8eGg4v+aUzmIjOHZ72zx0c03kcsGgZJ/GCac?=
 =?us-ascii?Q?UCUZugQLcPI/fRXsXEAnhgMz7L5w8k2sNE2d3HS/Yjb/F+6EdKiHfcpw14Ep?=
 =?us-ascii?Q?PBt3HaNytLQBHWgpe62yhjhaVNBLo2Jew9kCtA/uVN3fDCyvFYXpWbcwaBdo?=
 =?us-ascii?Q?/xzWyMeVhvTXm0eMGnwGhTF0QPzWZE439LHkDlgg8Z2LU3m9lWFhvDD5cMUB?=
 =?us-ascii?Q?SEDj4QHRD81u/vChodcFc7ddSeA7DFNDc7JfIw5RitA7rQW0CnO521QdhuTZ?=
 =?us-ascii?Q?sSPtYWtMG4xsHOhkzw84U0Fcd/cnLLvbaXYqm4Ay8G3Ve9jIhZigIFfWxqRF?=
 =?us-ascii?Q?r2vSWPvnZGJUOgMizJVdkmyEm2GrL5ray51n2gJe/Z/FXuasNYnxpcvVNXCR?=
 =?us-ascii?Q?NdfyhbR5knYQayPEBWtBHt4y8gBklJzLOXQf4YuVtkXRviMo21IUV/puYVW9?=
 =?us-ascii?Q?SF0n6q2sAcYcNm5vEwMI8MDCVnpvcfZuufGxGSl7lXy0cjcHK4daZgjAJta9?=
 =?us-ascii?Q?3H4gUhdyHIe7lfpp/Wk83BLiSQfXFj4BQFgldr+LaKmEfBkLAjaOmpp6WguG?=
 =?us-ascii?Q?w7d2gBtAR0EOWjij1c9M0PG1i1rucmJ5E04ujkwM3x+pCsVHSj7/XFULVQib?=
 =?us-ascii?Q?mzaPJwfrUc9Lk5KBRWhcRo0XLJyityDIDw0EeRcC4T8H1FZd2HQ+eDen81wm?=
 =?us-ascii?Q?2s/ZQQyUFa4dkdhHlRTjLRM1JVn+ZKMQTrKcWJYAHiuz7qZi9PgDy6UJqzy/?=
 =?us-ascii?Q?HKmLoa0o7yu7AN8rutCndMBzC+n74NE62lzMfa02jPzPB7xhyaURmQXRqZmG?=
 =?us-ascii?Q?1aLZNIDyqEIxXkeM03lPRjBTPneQvqbrVNwLenLqX4kL0Hlblo/3F3Xrl3LF?=
 =?us-ascii?Q?oc6AYDxie1ZLpK/RqZasi/FFkiWVmmOBRiKcwuTKqnxmR6Y2SDTtuCgpalW2?=
 =?us-ascii?Q?WAfYZJr2ELHDnm0j3WAe23g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F925E0ACD0D769468245432A1DA89943@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4367677-e202-4470-de57-08dad49b4180
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 19:27:30.9861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ki2ciakTFVWGoEsCgFKyM2+E8b12Ad/SgmCVWcEOGj/HObNL/RtS4sCPEkfwr7d5VNxgJijSq+HPiEUARBQ8SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3790
X-Proofpoint-ORIG-GUID: U8ZqfDKyNKFoDsIFrZ_C0w1pvIeQgRCQ
X-Proofpoint-GUID: U8ZqfDKyNKFoDsIFrZ_C0w1pvIeQgRCQ
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_12,2022-12-01_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.2/block branch. 

This contains code cleanup by Christoph. 

Thanks,
Song


The following changes since commit 1d6df9d352bb2a3c2ddb32851dfcafb417c47762:

  blk-cgroup: Fix some kernel-doc comments (2022-12-01 18:22:12 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to b5c1acf012a7a73e3d0c5c3605ececcca6797267:

  md: fold unbind_rdev_from_array into md_kick_rdev_from_array (2022-12-02 11:21:01 -0800)

----------------------------------------------------------------
Christoph Hellwig (3):
      md: remove lock_bdev / unlock_bdev
      md: mark md_kick_rdev_from_array static
      md: fold unbind_rdev_from_array into md_kick_rdev_from_array

 drivers/md/md.c | 97 ++++++++++++++++++++++++++++++++++++-------------------------------------------------------------
 drivers/md/md.h |  1 -
 2 files changed, 36 insertions(+), 62 deletions(-)

Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E651C00144
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jul 2022 22:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiGZW1f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jul 2022 18:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiGZW1d (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Jul 2022 18:27:33 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4128020F60
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 15:27:33 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QKZwEQ006602
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 15:27:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=4ZQvhvSPRBLqBpptjlv8aL2I0g1JhTZSrrMbw57SrRM=;
 b=e6J9eedIusEM14DlB42hpfDttn3W0r5THmW6VDpCrAPs+2QYK34zcudie6GF80H/7CB6
 szFM7jFcaJranR4bMgNfj3lPD4VIAByUL4tZjc1dL3PsIbxtpzKUe8dJ6YPHymNkoQTl
 FKyiRNA2iTe+E3axhKH6k23oolaP5MFZD14= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjjnsjx15-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 15:27:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqAVz9Uf2lcpvJgniLOVj+9zthk0t3nQtG/Q54K83GxlTjwptufSFnobWl2XX+B1c6kxus9Eq9KeDbn2IqpjM6I5WRwup32kP5g5U1IWxVHdO0aqxxJiq+7HoWD7wvsFx+upMDJe79MdN2H+P1lFwaYZni0xAd8GVQm7rXjmKf4lp4K9dBWEYjRNn9xRJVWGH0XJykF0a9eRB9RA/myU56Nx8Qgra+zNMKnvUlKw9IDW04/0+EKi/DRxtkUXtGZtBiZFPT9bHds+RtY9Nvq8W9ZfMsOEMbUn6T+jPNk+vXpD4lOoTV1DNOglXKIHLL0kaLDGX5PfZnI8im4Hp39C/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZQvhvSPRBLqBpptjlv8aL2I0g1JhTZSrrMbw57SrRM=;
 b=cqGemPCY9Bct2A5/sPILzfvodDx7iani0NZEZetbXctRsCYYWYSnqOxAEBHaXDlxENdVlt1jYIPrwxlKha8piPuOKu9/TiPgQ3WIA0Jny2X1kFBRXJQzvfLAIEFW5gtNnZzCc2kUb6mQ9GAHH4ClH3ci3KlTmqHBU+xgpct/FK5qPKw3wYjF5OFzFr1xZ4whEugSsB7MwHsHzZfKuHgqY8hJrQh0GLFjheZFY97ldki7hLcdZdBw+IFQn7QTn2JHTKQ06Sw/7Ri8pLkI+T9D7my/VVc6qdQbeRb7JqpHu8bE4ZVH1tmlzHwJ63FFN4kDyrVJbRH41Z603L94RkZM7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB5285.namprd15.prod.outlook.com (2603:10b6:510:14e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Tue, 26 Jul
 2022 22:27:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 22:27:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [GIT PULL] md-next 20220726
Thread-Topic: [GIT PULL] md-next 20220726
Thread-Index: AQHYoT7k6DiOMkQtyEeLBX0qN1/M8g==
Date:   Tue, 26 Jul 2022 22:27:30 +0000
Message-ID: <035EEBB9-EAF5-4D48-9836-70E1FDEE8F13@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b4b06cc-ce42-4db4-7ebe-08da6f56075f
x-ms-traffictypediagnostic: PH0PR15MB5285:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1U1oEtdNVg1Or18AlliPzOo5xpNGuj+u39kD8pxzqCuvxFeWuLtmuGzNbXXrPYPPuR7cNu60CBJPp7NhGF84dx9eVhPbPrQ5/Jphe/LXacEryA6TsKUX7OrpWxU9aviA6ARmU5X9I+pVyE0asz1iSTHrKfJA/frEpdri6MslESIOJLrV+iaaKvJgBFV0q4FNDAIevxZ/KdWUyGfkGXEJljzv5V3ezaVGBN08r5F7vafttAAXvsAaNNFPcIynFoNnoQmlWmh2eX7wlpjPxcA4ucIrtr87sDq2Ga1OwkL0dUKg3SncUhr39PWzyPNCwUtKzo95m1CMhgB06JZvAfOTnbiboaAe7MjATjNpsvGMijZmc2f0J17x44eXE3mmtwVxZFcrwEuAp8OybWOwETZAP5CYOwdMRqZJOc7479Rg/9CaNvc8HqI5alLfL23//9tZM2ByHfMmqHfz11YEv5PK0UB3262TKpXKpVV6uqDeLx2BExaxagDaIUTbQXjUVxNAiU/m0H3+/2i9iKwj+2qZmdz58Wm8GVa2+kTqJnKqXyD9Lf11tvSzH/y7h8l/B2EvqG/t2nDbnajwbJCt9y0nChHPp6AkaBNuVTCsMkLiv781mOaym0baQ2Lp8eWT+4jiF7Pby2W9pgerQWEP8/UXInqpHG3fa5ZInXYLfb4TOG8JDqKCNEBKRzXDLCAbLczbwDRZ/XCoFvS3IkNnYWdnT6v4TNzQbPdFqdvPacNTTyUbMPl1bI4suukX+MnbLtMJoV0lwH1fOzKuwZUCmvB5ygR175io2ZeNdX3wKKv5Ew1TG/60Aa0BoL0tf+y/4+FflxJQ7qhYPUcNDuE6R9FnCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(83380400001)(316002)(186003)(38100700002)(66476007)(478600001)(5660300002)(6506007)(66946007)(122000001)(38070700005)(2616005)(110136005)(6486002)(54906003)(86362001)(64756008)(76116006)(71200400001)(6512007)(8676002)(91956017)(66446008)(41300700001)(8936002)(2906002)(33656002)(36756003)(4326008)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j4QwK2ZWC5ebkvkV0zFT5Vk22JEZQFA97hSJ37hwA1cAOhuyjZwHUU1luKJC?=
 =?us-ascii?Q?1v+lryYqnfPQxs7ideSrNc1dBpHtZXqF5qIeuya4opl0y6jVB3wZn4nUwiaD?=
 =?us-ascii?Q?1aeqgQg5uDevqA7M4SdowHsi51bM9oUTGWbA9ERywfMnkqJuk1Jbzmy4fEFS?=
 =?us-ascii?Q?4jSYUfd8OLEWN8w0wxOs8zTTVOVnf06Lwwx6aEIDxM9h8VxN6V0pQICp9q3+?=
 =?us-ascii?Q?DCPbLVYY+Op3KkNRhDL7xzBClfLh2Orb5dXLrV23E0UHgp5USEL6xksJN5Ac?=
 =?us-ascii?Q?V7cLA7I5T8fLZJGhGS+QkE6DFgUwlTNcwoyPBh8yEY8kU+kCDVGJkJ1aCzZ4?=
 =?us-ascii?Q?PqYvPMmkdnsjga+OCQRptB5IAYBGjiXN8fZC6z/5KrJyQoHu9nhT0X0DjU+p?=
 =?us-ascii?Q?NtRTrDUXMZzXDYoQBSGh2Jx9mfcrh+CYsoA8/30Nbc9dqEdDFnN9rK95X7H9?=
 =?us-ascii?Q?jUWL+suUF2pKLA4o5iP/AdLw1ko5liV/TlZ/hThCwX51/cLMvAgQuuKHyNZ2?=
 =?us-ascii?Q?FarnUFDJShq00weJLY/1Q0/fUF4hIQTWX/evZAVBIC2XW6m1OElCml7vjwEQ?=
 =?us-ascii?Q?Fs/yASgmqeq31cu31/252PKPUnugR0iG1ASnj1A8NahwBPP8ZwLMIPMVV153?=
 =?us-ascii?Q?ltH8DN7hfVu/YOSejVeeWqjRhJ9DWsRdJFVTWgG8d5HGouvcApxQHQxDYMHA?=
 =?us-ascii?Q?kk41w+0GIud7Bcd7XRdWn21DH+zD+rD+eyEafWKQYogReNy+yqpdCtpm3fbT?=
 =?us-ascii?Q?kCCuCz8Ivi12mEGHqtjglISqBjiFrtZEDafrEhVFfOT6cI6r01mh4cVM3xNN?=
 =?us-ascii?Q?Defg2hKbUCWgX9CEgbSVTRmb2Kp6DkbEj4fkf1IVQv2k4RJfZSnyvMlp1WWM?=
 =?us-ascii?Q?3nV0LazLbUcjFNLY7YxmS838CbhJF/W654Fmvvf95no+jzUiQD3I6wHvhtJh?=
 =?us-ascii?Q?xqpFtUYYFdcpn8bUP2SCWyo544yIoHKBnWcURxo7g51PiXAE1sxbiAnI9PKr?=
 =?us-ascii?Q?e4iEV4amQP+Hf6JE9ycQ4ij3KR72tBNXoRlGirXAJ/5NCOpaVQgCtSjDAJ+x?=
 =?us-ascii?Q?/3bKeocWM8XdIjW0as3KwmH+f/pePF6GtVJHCf10jFRzIX+Sg3EfU5g3h0nL?=
 =?us-ascii?Q?XaF2QX2K6XV/cXnHY1wPveZmfQWIpA1idd93W15rlMmGxl1n4OgDk7yzVX8F?=
 =?us-ascii?Q?e47wa0eebyq+ze8sywvJ+uvoLGJ05Fj5qY7DTMj824Dz4zanAVfVlVzXb5Tf?=
 =?us-ascii?Q?sM2vduRt8Vz4S/OerZR0mWNOwrDXtQNVrTN+7TMGkHZha/3VOxEKP4rSNh3h?=
 =?us-ascii?Q?FYAoK2WeqwuIYPk6nIyU7gSHfPvw8eGbwhlU8Stxz9d5c/RQEMeB+67aDqlx?=
 =?us-ascii?Q?r9ROhnQEqDNRPT/yOPYnytPYaWDKJm7anGT7jiVclhZugpwldto9+LIEfTQo?=
 =?us-ascii?Q?jdN5g3xxzf0yKU1vP+axiU3/YF0cT7UKgCgMryCmMDgITpxDgQj2k9LukTbl?=
 =?us-ascii?Q?uLP4aL/B/RXav2zb2Pj9GFHzBCCIWgY7Lh/GBhntxIeFx132aXLHaatRg4ol?=
 =?us-ascii?Q?ivLtvXAICk8LE9LhK8pE8ySjl4V8QuN9oAwUiNg1J85z1J9Y/Kh9lvJq0i0g?=
 =?us-ascii?Q?d5rrBieG5NBBj+4q4COeWDg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C069F4B0548B344A0B72A350E39BADA@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4b06cc-ce42-4db4-7ebe-08da6f56075f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 22:27:30.7290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AZcwzqowH2m3ffgCyFHIpXOMlk1n+HFmKrcUTUxFk6mRNmiBdnoYafKxSS0XUd5pBPmLKYBUMeqSvX32z8NpTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5285
X-Proofpoint-ORIG-GUID: 3-j5qgwWiCb2jaDfaIwGPLHK7p3hdaVo
X-Proofpoint-GUID: 3-j5qgwWiCb2jaDfaIwGPLHK7p3hdaVo
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

Please consider the following changes for md-next on top of your 
for-5.20/drivers-post branch. The major change is

1. Refactoring md_alloc(), by Chrstioph. 

Thanks,
Song

The following changes since commit 2dc9e74e37124f1b43ea60157e5990fd490c6e8f:

  remove the sx8 block driver (2022-07-25 17:25:18 -0600)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 7a6f9e9cf1befa0a1578501966d3c9b0cae46727:

  md-raid10: fix KASAN warning (2022-07-26 10:04:45 -0700)

----------------------------------------------------------------
Christoph Hellwig (2):
      md: open code md_probe in autorun_devices
      md: return the allocated devices from md_alloc

Mikulas Patocka (2):
      md-raid: destroy the bitmap after destroying the thread
      md-raid10: fix KASAN warning

Yang Li (1):
      md: remove unneeded semicolon

 drivers/md/md-autodetect.c | 22 ++++++----------------
 drivers/md/md.c            | 58 ++++++++++++++++++++++++----------------------------------
 drivers/md/md.h            |  3 ++-
 drivers/md/raid10.c        |  5 ++++-
 4 files changed, 36 insertions(+), 52 deletions(-)

Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8121C00144
	for <linux-raid@archiver.kernel.org>; Mon,  1 Aug 2022 17:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbiHARP5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbiHARPl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Aug 2022 13:15:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349803C160
        for <linux-raid@vger.kernel.org>; Mon,  1 Aug 2022 10:15:36 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 271FCGBX024271
        for <linux-raid@vger.kernel.org>; Mon, 1 Aug 2022 10:15:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=uYMl45snIfgoBy2qCyA1bjnirt/0o804afPq1D+ZHC0=;
 b=kV0Dd/k9nCcbpZleCRxOkB17ftbwqRXQSWYl9ae9biv+myE0woWb8Z2wcvDqS0y4NQ8r
 BRlXFo7YBBEuCZcnqBiYkAJQDQ0O8giVfwppu3/1EmVEk3Sj6bTWrALGYeD5rM2EThk4
 t8tFhPCJhnN8qLv2JokAPDXHYVQW29B5iOU= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hn0auwemd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Mon, 01 Aug 2022 10:15:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCixJt60Ymr6igkb9btuFVHrEW8KZhhsak4/exKUqqcvU0q/yGYFFLlRn2EzjMzxjC5uwxE/HyYN3xh3xnaVPv0EhlrpI5AzIEGMr7zfJmFwGpn5mxZpFIG9aIQf3z6CRSzRjHf6wiHPD9vn093tgFKGchizLjq2F/vgTt1Hq2yfr+DtPaynsbhcohAYwoxpPlO6PdhLtc08GOPoe/HgibbHUXolk97n7E0lvKn8mg6/JDXt0HP6kPfRYSq3lY2X1X/xrbknnukCebi4sDvK11jA2a7erGZKEr3ZlfIrp6hXe89kk9Lj4zgFcc2JvDBJlarLDRRK+0KF3hX/8Mj4Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uYMl45snIfgoBy2qCyA1bjnirt/0o804afPq1D+ZHC0=;
 b=AzrX4FBDeHFkyGpVErLb4XVswehTIdbSdBCotT4XVaaLNswVKevZWIKrVPjNsUcDtPNys91DTI1MyBIEr9xCmXOKoFVBavdnE+7Am4xSfdyoFozxqWkTTJGXvP1v7RKdWuNuOtP4n0OgGTk8K8lmYov0K9Ge9D2ZFo2y5jIaCOiN6P1HunAQ5uAuXpUmn9CbOl9f10p/MbzOlxIxCKRTCzBvvHbKPS92o1Xv2JeLWlQAbE20aHkm/cJCIcjs6+mQyga6IqVTzk44Ux/hRWLKYf6+KYH/IVDeXSKDkx+zIU22Wcy4Pb3PyUcKXicK7TKW53zz12aHDvwlxwbge9rKpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CY4PR15MB1190.namprd15.prod.outlook.com (2603:10b6:903:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 17:15:33 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 17:15:33 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wentao_Liang <Wentao_Liang_g@163.com>
Subject: [GIT PULL] md-next 20220801 
Thread-Topic: [GIT PULL] md-next 20220801 
Thread-Index: AQHYpcpPJDqjy3/+NEWYqi4eULA5mA==
Date:   Mon, 1 Aug 2022 17:15:33 +0000
Message-ID: <3F8544E8-484A-4E67-9052-90C07F1C387D@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e350edc1-4e42-471a-3fb2-08da73e17189
x-ms-traffictypediagnostic: CY4PR15MB1190:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZtM8FvhCtHTc3ne8yt7TCj1bMqeDKjBWCAgGds6CGMvz2c2vhv+HFtagMdFCSL3CD/u/JjHUTJmmjw5IKaiGAk7EZiS4MEO51jcTmKTjDmvvR7jWWJpGfLnNRfkqrm1sHJUavnw5PqzT02j8wykP5cGHh8FuRIyglORvwoRMYMGN0R3ZT6xAOVbWXwEQ+dQjdyyeaZiSaHTSOv4ukKC1vRI7AcTfPddfvDWx6cKtsGcSP1ohcGKi212cCkw4gOhLE8tO3PcCA9LoNqJS+vChrjN2y8Q7mJ7hgsuiBM2ZsJX0fuz98EtKQLkhQF8ImBsRcJ/H8lvN2UhqXyH3LyqHWqGOgdtzG8bG+oz0/hvb6SG3RgfGu27EAphkkdgHOrhlWK7BomoDUYJY2qud6onWAxzmVuO8jM0m9pn6Dqa4FLaUmS8a6iKpqMv3YHXUoGXa4zgp3AZ8PU3nkhqAEWcYmacyr3YjBkSwhTEUKXMN+ywav6g5915kVc3uTGu6hnL8jpQnOxra0MDepXg3Wq4FAJSLO0wmepHL1A5LyQBI2YN4gt0CUKCiD99rgBWlWoIJhLNuIbbZGiiRkr29XMI3miM7n4R3Y7K2u58HUt0ArykZxplc0QsEvX6VXT5u+5pdvDyEutk1wcd+nrfNcictRJKTOAbqEqGb2WBeeJFj2QNwNIUYNamoCEr6+zK+m9hVvSYNGLDE6qBC/awtWo7q2Yh2n3UsxA83HGsONRXBpROGXI3eJkU43wkqlokV15jQvHNNn1MH6xL96r3igWuL7YOcjP3CIOMuA2FdtjnnoFYFi//ElZ1cnr0J+DGxqInFpxVSJBAX6tdrWPkoMeGbz4d9xLEvXHsNWXhV1/5CPcDqjrGJhDnYVAjXlfJOLByEB54aeN62jO1V7PoxPxCQ9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(5660300002)(8936002)(33656002)(8676002)(66446008)(64756008)(4326008)(478600001)(966005)(2906002)(66556008)(66476007)(6486002)(6512007)(4743002)(6506007)(86362001)(122000001)(38100700002)(186003)(41300700001)(2616005)(38070700005)(83380400001)(66946007)(110136005)(54906003)(36756003)(91956017)(316002)(71200400001)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yGqLdjeOVBKiomGOYFzGFaCGcdwuF4KCGD8PnAe1mra4h1M9HoR/xloS2AlW?=
 =?us-ascii?Q?VTzloKQ89VlQOcciHPchgIk7HCsZ3sP+PVT8G29FA/4FsZB7AijKQR9P0OIS?=
 =?us-ascii?Q?a+ZFlVmvxzhIhq1OeTQus9tKc7ShQtREn42uepcdO8I6A+sEy5Ppsyy6YC4N?=
 =?us-ascii?Q?FIudVtcOjDcfsKSxVQmODhqfuEUzn3iaiSPmAHUhOtaFRSJ8cov38Ek2tgPc?=
 =?us-ascii?Q?fSnb9U907q415DScAAHXf54pdWqURin3g7a1VofyniEJw42pj8TtmesX0iDH?=
 =?us-ascii?Q?zYyPjam1E8Z4P5BG1Tz8z8NaB6MVk+hbXNY9oyAqGyrxNN72UjTpfO9vOpww?=
 =?us-ascii?Q?iMhFumHC/oEirhMfnAo3uHOYK+kTD8VdO0uswu52NHPGH4+etISK221cxCIm?=
 =?us-ascii?Q?Td54zLiI6Tk6NI/afd28wco+ehWU0Cyk8RmqRlyUrfmixZpPbV/Tf+y019e8?=
 =?us-ascii?Q?h5s0+BpYMrEYK/Eo8+2spexKs+0dlgq5XUunN2VP8XGh6HuC0pLjC6hnmk4U?=
 =?us-ascii?Q?0WGDNY+0rE5QtURiib3d8kHFrpkHZgA+b7i6lgLzY0BRrQaYlnBP/10NjxoO?=
 =?us-ascii?Q?Uy8w0IcUTuUg+6hVedwPdln9mTv9HDGUGJV8gE7IInxRfBIWNhuYPT/BBW9M?=
 =?us-ascii?Q?lK2fV8EoeKBT7s8iwOZ5LiGAxlLRCKrWs23iA8+pXHURj34WJXXlehKfxCrX?=
 =?us-ascii?Q?jLFs75ujyfoBQa2HvjwDS5NXBFMtTa2KFmMAZ7xOqefSKwkRhbRjzZrfz0+U?=
 =?us-ascii?Q?QlxTKenYsn7vccbp3ggem2cSiTex0O9trfmHTFMYjbZFZfkDEXcNAGyT8lep?=
 =?us-ascii?Q?MXFNuSn+n7+ztAAN1pNU6fb5TJk7W1eRo65K2K6zkXMJYsHdy0lnARKeVmsD?=
 =?us-ascii?Q?R5KB6esmtUMLyeIIOrjTRre05LD0njA/N5t37TwOhCUe0jFGgraILY3BK3eG?=
 =?us-ascii?Q?8mhzUfu0pT1lrHGbMqjjJsDFyiKBt18W4D17zZLCqYwrt2d1dP8Ib+dWaLa1?=
 =?us-ascii?Q?he7Am730sF+P3CVmoUQ8IBgtpgKvdCiQD8Fi9WB3QddZtD2kNlLxo8QOWAtz?=
 =?us-ascii?Q?DrHCXv/V3CBQtLJ7lBfXE8O2nKcK9HA56/HdWXFWwqwaLcmBwU8X5meRp0VN?=
 =?us-ascii?Q?nrLUiHkt1UndfgxjgQpU9UXLMiQdpIMCc+zgONsmuaIwyVyTYmxNqCQZB7Av?=
 =?us-ascii?Q?Bt5gC9S1LPDXNCpiX+M1b8YxfHhKdaeKCzZdTvmok3gpWOxj9duMUikHudhI?=
 =?us-ascii?Q?mV83zuUc82Tl8Qi2F3+6172aHyxHeEumOKHU7lMXQutjsou3njsl/ye6TsAB?=
 =?us-ascii?Q?CvIWfcST5hnJPJ9+fjbHJFUnmKLw6ucE5BI0HxAvN4hDZ91MSEtgBjWUwfgX?=
 =?us-ascii?Q?FRHf5hp+dEsnOuP4MTj1YGsqq+Q/QgzKl/X6BlSRfHP44b26CQqh9wfXvckq?=
 =?us-ascii?Q?pPfWEtJUC7C4ibwmIIhH8aPOr4LdXSkW4eamj/s04qcDiIIxbKViHl+vjGUm?=
 =?us-ascii?Q?t1ZKIFy2MfkP9gwbaa2ZYhHhg/yXZYI9FDHiegCjnUjEnVRidulRvaEQbTqu?=
 =?us-ascii?Q?sAdEcxeapmxJUtfoqKkJaC39egKQDodBZm0kI8x7LbdEDD+ETgMrwRWrH/EQ?=
 =?us-ascii?Q?Wb+N5dX3l7ZfzD8gTbGhwFw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0F22C6560DABBA40BFE52D67CA594D2A@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e350edc1-4e42-471a-3fb2-08da73e17189
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 17:15:33.5377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Azq1QfM1OIGa7HMSdOJzgRUlVcX/61aTwIRE5RFXzbbEQMoDtZw5tmq7JTSxROJgWoqC6o+27+/uz3XBD4k+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1190
X-Proofpoint-GUID: V6qUTjBbFtFRr7J1b8PjjiV57wxeG5dl
X-Proofpoint-ORIG-GUID: V6qUTjBbFtFRr7J1b8PjjiV57wxeG5dl
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_07,2022-08-01_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-5.20/drivers-post branch. The major change is:

1. Fix potential deadlock with raid5_quiesce and and raid5_get_active_stripe, 
   by Logan Gunthorpe. 

This pull request was delayed because of some pending discussion [1]. Since
the discussion is more about code readability, I suggest we ship the fix now, 
and address the readability concern later. 

Thanks,
Song


[1] https://lore.kernel.org/linux-raid/20220727210600.120221-1-logang@deltatee.com/T/#u





The following changes since commit c9ca8dcc66a99d1123f0fdc2dc161436b93d194b:

  block: pass struct queue_limits to the bio splitting helpers (2022-07-27 10:27:58 -0600)

are available in the Git repository at:

   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to ae0a80935d6a65764b0db00c8b03d3807b4110a6:

  drivers:md:fix a potential use-after-free bug (2022-07-27 22:51:58 -0700)

----------------------------------------------------------------
Logan Gunthorpe (5):
      md/raid5: Refactor raid5_get_active_stripe()
      md/raid5: Make is_inactive_blocked() helper
      md/raid5: Drop unnecessary call to r5c_check_stripe_cache_usage()
      md/raid5: Move stripe_request_ctx up
      md/raid5: Ensure batch_last is released before sleeping for quiesce

Wentao_Liang (1):
      drivers:md:fix a potential use-after-free bug

 drivers/md/raid5.c | 164 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------
 drivers/md/raid5.h |   2 +-
 2 files changed, 102 insertions(+), 64 deletions(-)

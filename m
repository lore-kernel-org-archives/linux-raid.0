Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B00AC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 21:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbiGRVtL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 17:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbiGRVtJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 17:49:09 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E3B101CC
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 14:49:08 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IH5FCC005219
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 14:49:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=3/AEM+9AqEejIOCq5SZcYbt8vE/LJYxFpK/XmTP127Y=;
 b=O2ljIHM0uScQuL3MRx/Qq2iA/ibf4ICToNUMnGe+YssFB5tD69cT14b/y+qDEPLf41ie
 XkgJ0GXAyUq4celTSoLQOYNwa+O6ekFE+JC0bgTUJ71q+u359xtF469fpprbJDaZeT6x
 5SxEA0r3J6OMCMan6OGzj9FVIFCkDDVMa58= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hdbkust4u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 14:49:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQ/fyjzNCNGdN14X5mJ+gMbHpZ9RP5fe1eEYFa7kIIpgH5p6n7eSM1i70873IdoJ5QG612lA5RprzFHKtRx08gQD9840Eno+XLuWGb82cE5XeZeALNIxae7j7ZQuJm0wCJakn4RiopgRuCQZRhRtDsW/5J24J74EIWDZsokytW/c7MZtUNupvjYfbobBugOEJr8NIz9YD3sWEJfVcOnHCHDT50rHD0f9tO9NEOgSLaHINDPIRuWjb1P6te8HGPJ+GWJl7NVyIkLLMJ2lWoU4Rv/ZcYpQo5Ss1+k/1hSo2pEo57SWNsenvPUPp1fZ3tQw1xfNIeqxWKR5Xy26iCdFzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/AEM+9AqEejIOCq5SZcYbt8vE/LJYxFpK/XmTP127Y=;
 b=gJ/KWGP7t/PlHcb8c8/euNws0WlH83DVa+cbUwmnSjItyCJZjKWOUN6/purz1d90Iw084QIKAiL6bkhruu5UqChxSbhJj9k6hU6TzWWNr/ibfhVSxFLXChLOQOoGYaesRR6W55Uve/N3UbEksSU1bQdZjUirmBYX9egfmAIfcoE2Zi2NzEKdLY7Y7LzxXM2x3ktYCKM1knwsIlkvyPXlaRHQoHtnbsFpUnlVlX0XXZ3Q80lOJrneJgmQz/hYTx3DnrM6rfPD82YXZ3sChs2Nudomk56W8q3jjk6nO22Ulp5hc9rDyrGqVS8QsFpJjMjAGcbT85BOSqTZEkISyp4nHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW3PR15MB3819.namprd15.prod.outlook.com (2603:10b6:303:43::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 21:49:04 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 21:49:04 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Logan Gunthorpe <logang@deltatee.com>,
        "liuyun01@kylinos.cn" <liuyun01@kylinos.cn>
Subject: [GIT PULL] md-next 20220718
Thread-Topic: [GIT PULL] md-next 20220718
Thread-Index: AQHYmvAzUbHaxzdBYkGlrk0ax5ljUA==
Date:   Mon, 18 Jul 2022 21:49:04 +0000
Message-ID: <4122CEAB-991E-4A4D-90FD-C48325935876@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f7e2565-62ea-4837-0461-08da69075581
x-ms-traffictypediagnostic: MW3PR15MB3819:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: slJh/YHXflIuB02TE75slx71oI1p/gMFMAvrUWSj6z7kOkgmXWMvr9Pf0pj02b+MKL40zmFhqne2DYjwJiy94iqL2lE/CTwLVVGR/sBH3l+TwGmevuOj0Ws8/JFMu4c6Ma9CsSS3UNSLHLsP5NwjSHWbej/SYZUBJyv9O3BA5Y4EzMtFrWeSPW5xq+vrRaSQH7AMdtqcHSGVYhXS6yzGbjJHT1+BxRsirqI5ZjunWwHHFuXyEX603ul4gUbsUBWTDWVbJ9JtPmP1w5tm+cjDu7x9CsqMrxDu8TGacyZKxTqWttGNFPPBI+nOoE4Itx3opQncSSRrSCobPZPWVofYs1nfT340slOtPiWPTbhzOleWM6+MV0d8iGgjIoA4YkLCliqueVZe1sx1N/jHqcOnXG+YDQEQ8s+kTqHIyE2RQZQxdGZa6RjNmVBeexjqrMJSDb+HcBEeTtM0PKx/cg2eZ+WVzocxoG05wRRHeOnAsf4YKYS7EvGolMT9SWAA3+Q+oR/S6MznDORbGRnugmczk1wmpx4jqVTfjSAd6hgb/7womA7Zk8/U3wJCLVgPmhGVYMXIR9v1dDotMg6xJlpDMClr4Nt6wZeFnqOZJ1l/mjqB8WwDat6vPRmDiXau30QR9SRJJRfJgLSBX8istKwWTADn/aoxAlVJTuznuoayVldukc73AZey7H5b6H22QXqppNcZw3rMmq6zUyrWp8MchXM4DTUvA657I28qfCOQjHZ/5h54pFT5X8mQLLZGUb37FT3OAx4mJpyiRPTSjaTKBifr/I+o4WmlUS5yKhxb6qfHuH/vejwezPQ447FGPbERPYACzFbQEPzhc3L9nN6L6yswJhNHT7BL85MiAfX/3QV/+a65QiDTONWqPIQutQaD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(5660300002)(76116006)(66946007)(64756008)(66446008)(66556008)(8936002)(66476007)(4326008)(8676002)(2906002)(38100700002)(122000001)(33656002)(86362001)(36756003)(38070700005)(71200400001)(966005)(6486002)(478600001)(91956017)(110136005)(54906003)(316002)(186003)(6506007)(2616005)(41300700001)(83380400001)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EPcAGEGrAudVdHsPzIZmSiVimfKeJHAY7eDyNOCaNvfHtNV/1FKKPPavbprm?=
 =?us-ascii?Q?IiRy0F5ba7bRPw85Fer6LCLc6RvHPrlfn0NfxaCOXCQm4/KyTL2rdQ/MV00n?=
 =?us-ascii?Q?hLdssaZid1hZSvgjInZicLueG4oOBJc1bDt3JwovrDe9QSTwXy+LbXq6b5Aq?=
 =?us-ascii?Q?GcfRLvwRbwBTOMos1vYQz4GM1fT292iPa5FzLrhko2HMb4tBtUOvYUusdMTH?=
 =?us-ascii?Q?X+z2wgnOZrqLLdN+Jgpwg9jCP3FWB1R6+zGF+9xOjc9Vkh84sPXH8N9r5QJ7?=
 =?us-ascii?Q?mH9fI8pAFR/OHLAMIURi5fnSf6J4ySkd4K4YJyFU7tb3B7m8G8GxCcAwAzU8?=
 =?us-ascii?Q?6Do40PPWKcmER/yGRehq0oTXLvdNrQJzxMs46PJgCOdVeCgrkdN6SDLcuBQS?=
 =?us-ascii?Q?AvWbIrC124z41TTUxDc00exetHfUZhqBv9SbsuObXrR+AOxxBjGweQ75jGHI?=
 =?us-ascii?Q?hy/metX+fVzabiNl7/SvyGq5xSAwdL7uTZHi1WNza/0mvcqvt1XcAfGkbWAn?=
 =?us-ascii?Q?s2Rcj19jJztt6KykzXdwmkHFTPtBrekg9ZwnAZqPyESEakD7XPJMQgDy0tgB?=
 =?us-ascii?Q?kwQQsvu0dsOQw3/9ZIGfzNXGzHxeaodZzEeEH4P9o92FgxD5sVF/KsQBZWD0?=
 =?us-ascii?Q?Xt8lzfwEVJf40lGkAYoaSoJZ11cqWHTzZvoMQvQmpIm8oXh+vc1Be5EyaLSU?=
 =?us-ascii?Q?YOm16yIfxq9XwN8YRdSOu2pNQoBcCAVoQ+wNkEzuv9lZZb5oB/i4T3/+Q8Ny?=
 =?us-ascii?Q?F+fBYJ17zF+fllYX2pu4rbHqW+dbmrAjmiDnMSE+N4kgNR+eF+eBpywsMvLt?=
 =?us-ascii?Q?8Mh58usYXIIXOTYqfhdPGGze6FMF9YJvJpIS+kPkf8D52bqQSoxZL/pNylki?=
 =?us-ascii?Q?R0QkpI2Efsz1NjPVeY8s28uLdYJRJ2+WD3ngmVFZiNw2WcaFJVkiIRi7/BMS?=
 =?us-ascii?Q?Dw46k4G22wPnEtDtLLA9Oz3miLYF8+lVsqf0echAKzU6BiBEdKwSc7E9br9z?=
 =?us-ascii?Q?MUpRD3FYQna4Wg4SPOu548AjWH9Az9t+GJU2pdSP/5bQydXmNkS/XrxIs5qp?=
 =?us-ascii?Q?+Z5IfnmorKhaBekyGflh02xif7S6iIie6pkQDDya5z6lTfr6S4/gKravaUGX?=
 =?us-ascii?Q?6IGGYHXXHhUROkZg6L+ZIlOwoJV5y+lm4P7GB0wnz4j/B/5+Zb3Aw77/4N4m?=
 =?us-ascii?Q?D587adJhubVeSmZRBmLFEuAJ1LNUR42IXr1uaKduxleFu9vJ5DddjYc2j+yA?=
 =?us-ascii?Q?xAeXOJbZhtjm0DQH1mryK5aLtalhbIgH6idJ99aTiLROfZuGz6bveCUhpcey?=
 =?us-ascii?Q?i22bTF9W36gsOyBnTyrsTMEvPwDQjaX0wQEpIaaTicNvwJC0cOOO8VkDbHMC?=
 =?us-ascii?Q?JbcmzijwwhNTeJF000ioQsieWrqAPJ2pLy6C7SOB/2ixHUJdpPuwI1JM2W/H?=
 =?us-ascii?Q?HzZF3bxinperm/+7nzHh3svAkm/NSmV9QcC7P/i1qFO8LxudaV8byon49ULe?=
 =?us-ascii?Q?M+DlyrBd0GphIVrwmunU5E9X7INRCJyC7LyiBmXXGtI1TeyzqtFCA+GI3cwW?=
 =?us-ascii?Q?AwC02/GRj2PBdty6jhLXw9cXh+Bfj3WomLn3XMAlceAsaSG1PI4SUz9mKGqP?=
 =?us-ascii?Q?92BXh8VRcWSTH1e9fRb1GbA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <772A1D0184296C4FB313AC70C91D0512@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7e2565-62ea-4837-0461-08da69075581
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 21:49:04.6084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MkUSwosN30hrMWEd+mdPyJ+aknpgDfuqPUCfg0qYT/XUnI0p4H0bT45VExb8FJzmQoQM5f9vA4sanp6BYZL70A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3819
X-Proofpoint-GUID: veG3BHw1d8w8Yru3tQ42Sp0VmBIlV04Q
X-Proofpoint-ORIG-GUID: veG3BHw1d8w8Yru3tQ42Sp0VmBIlV04Q
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes on top of your for-5.20/drivers
branch. The major changes are:
  1. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
  2. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 

Thanks,
Song


The following changes since commit 8c740c6bf12dec03b6f35b19fe6c183929d0b88a:

  null_blk: fix ida error handling in null_add_dev() (2022-07-15 09:04:38 -0600)

are available in the Git repository at:

   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to f8584a43b407dc0b7277e722a4b7fbca9f4bee44:

  raid5: fix duplicate checks for rdev->saved_raid_disk (2022-07-18 14:33:58 -0700)

----------------------------------------------------------------
Jackie Liu (1):
      raid5: fix duplicate checks for rdev->saved_raid_disk

Logan Gunthorpe (2):
      md/raid5: Fix sectors_to_do bitmap overflow in raid5_make_request()
      md/raid5: Convert prepare_to_wait() to wait_woken() api

 drivers/md/raid5.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

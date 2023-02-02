Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF87C05027
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 22:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjBBW1Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbjBBW1U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 17:27:20 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F5373763
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 14:27:14 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312Ka9h2009800
        for <linux-raid@vger.kernel.org>; Thu, 2 Feb 2023 14:27:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=QdM5t51Tpfd8bKC8t1F25cSVhY2oyfuec4v5gi+Q+bM=;
 b=UleZUzVUVtsoZ42X4HymqZ+kyxvXw/vup0jhASH9UTz06HWy+M28B/Xv14LMcSlCSzIa
 +pJOVMkm+1kuyi2T9SsqInnkqIz6mBKeEHBwfENnDf+WBFQqzxujwUyZotOIERssRO9g
 oDrgKxpCUmzVi7+Pm8BnYsOzOMCID8SmRpyaSQjjKIo0IxQfH/nnP/M1tX4SwZAn3pUv
 zMUpN+I0EmVH/P+eBtJEb3jrgpcPN7961V7r8yN1WPZulObZLCaJX3QoQn4i7S/zmS3H
 HQxXTXND1FCzGVAl7r8o3o5nC46ZvttZWzRHZfIA15VXmJmSsMDAaPeKTjaKKb7sa/4J 6Q== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nghcr27jk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 02 Feb 2023 14:27:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpSXk6JODkmJd9WDnM2HwFXiNusbvylt8wu1qUMOR1d6Wjbuu8UmBzWvlp85AQA9Id+19i2wVeOCuLcA6DYxpKS8ajjbrdGncswVHzg1umtrKeMq4r5uyUeogw7idIkBzqaMWCHJR0gOI2805npPXXplutY3lxIrkPlSnIuPF4r23g+gPdTcsy85LhTSBqGz/OAUJoSus0AU5jP/7BbTxPgSisb3U2OcACVEyZ0LC7eQGkQAAFlX3o8QIAMJFGYOXuYTWL8+cN/0rUws1SBwOfJ/M1oeJudZpWdMMlTfv/XwZvVhCQbUDo/4lG55uxuRxDnBj+WqwNlwmTN7P9Ax0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QdM5t51Tpfd8bKC8t1F25cSVhY2oyfuec4v5gi+Q+bM=;
 b=BwTZzi3dtHE0oKL9wi0aSytQPZ1qOC7HF3KzfN/huBl37dUIa1Pqg4/Ag9nG8wOErKuWnh6XHEFFWLFY36xwg+MstijVl3I/9wNkolMcRP1wBsIMALIxss6EPXZcs6qmtvASV3Ope+hXrV1ci477wZDCvPBtwpDupz5GdVAs7eCO0/XmL+DOA+lJ15IdQsAHa0KYDwTgzTzqnlMo8raGSZyjXufvsnCqCZ3oQX6jjm2VpOLoQxQxqVBd1qLTCKTN0TgEzNcSgE6CNEzNX1MBIcX2XLbf7n2G8gU1gDrCXlnfOocWaAp19PcwnBoKyOyBspEjtmVKAM3I+aU8Mhk4dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DS7PR15MB5375.namprd15.prod.outlook.com (2603:10b6:8:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 22:27:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7b61:8691:5b41:ecf8]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7b61:8691:5b41:ecf8%4]) with mapi id 15.20.6064.028; Thu, 2 Feb 2023
 22:27:11 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xiao Ni <xni@redhat.com>, Hou Tao <houtao@huaweicloud.com>
Subject: [GIT PULL] md-next 20230202
Thread-Topic: [GIT PULL] md-next 20230202
Thread-Index: AQHZN1V+VjYgvQ3gPEGBNXWrm6eNBw==
Date:   Thu, 2 Feb 2023 22:27:11 +0000
Message-ID: <9CFC5FE2-783D-4904-B416-FBD74A3B07D9@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.300.101.1.3)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DS7PR15MB5375:EE_
x-ms-office365-filtering-correlation-id: f38e9079-649c-46db-7e8e-08db056ca0bf
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XztYWoKzuBSZpa2aJ57Rpr0ewW1CluFqUiLhSAKL0v1rGQLwUDoA8LzBa39vifVGMoj3au3zdGTSCBO4zfmwkbZ1R+g0BBh3qhhgrxW9lUgvb5VuIiE7u2wCukd1dfeCSB4zPF2MaCfQh0k5iEP2qr0WWaMnmYPmO9Iyvqtwz9P6RXT+VpFBWp7Wa6EmC3xUdqFXGRdJqniQqR2iAWurGftUxg529doRj8qVbEYVD1U6PS0YVh2fN7FRtnFFjgEHeMpKm3VYI5c2Xon5Pn3pbM6Oti1gp19mfIjtrudPXY4jN29ySVHC7x3McDTkyNSsC96yHJgEQL2EB4I509TKXQKDnHvyhDE/MWkqSSJHLWsWvII8WnmshNDU4RsAjhGqJgbsHMp8dlwKDgJBrncTjJGcspYSJe0WZbBbt33rD29IlFFpfrI4AlrIZsprsErdAAqt/gZLZW5DHbVU3y7uUF0sszjEAN5ZwY8UPqEPLYzQw+WGFegIDiUmjeVTRXoI65RhSRpgttjIvW3vbRoCdRsc9n/Ma/k7MlsHcunvOcSEghWXxY4W6PI6CByMQqBTrCks7J5PvV6g+2M5I5y/x//XBb71UgSdAuCfDiKPUiNJtXlWAsyi4shjY2FuK33qlWPDXgp8/9NCokgUun0psybCV8ffLOoz4WmioHU4hqgKk0g7THfykX82cINmU+I9FygXSI3l1Wzx+RILp08yQI/k2RtjBPCdGf7qoHvj86s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199018)(36756003)(76116006)(478600001)(66556008)(6506007)(38100700002)(91956017)(66946007)(66476007)(64756008)(4326008)(83380400001)(8676002)(66446008)(110136005)(54906003)(316002)(122000001)(33656002)(186003)(71200400001)(6512007)(5660300002)(6486002)(9686003)(966005)(86362001)(38070700005)(41300700001)(8936002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bfKy9/nG0ZxGPkkDuUQxMN3/rl7FTajgfUhOIe4Q+xOpqgjUeP9kgzk1BXST?=
 =?us-ascii?Q?KbRvuMfTim8+LXdFcrAgu+h0rn2b8D3kbFP5dPj5/DfKrHuVyjeLbPjcsHTe?=
 =?us-ascii?Q?6RgITUDNhD8ULr2iiSoiYLf/OEdml6JjgOftm7Uzk3q3gezcIWnYOSFHRyZs?=
 =?us-ascii?Q?nLKUfMWnjKkBYe6LmSJtDZsCof7dySRa5H8LhPnXI6LNqV0T8TuofChgWAZq?=
 =?us-ascii?Q?FFY6ctcSaQ1ImFyvvb5OViKzLDvgrzsA1S188Gho8L1X9676oJNSbGV4cwGI?=
 =?us-ascii?Q?zfmskceLPZxeiYu4gllT85WeYGrCaCj3m4OsX/s1Vm4yWaCKeYc1iccMli7p?=
 =?us-ascii?Q?/+mol7yAoXT3s7f0UYXkJt5e+gX4ed7kxbCyl8B2O8vWxP4lYs/neovGaknQ?=
 =?us-ascii?Q?i2CLitmdszO/LbM0NKObgKEu2RWEbDBev+0qs3QYDY5cvoMBHYAsdZtaJLno?=
 =?us-ascii?Q?w9j6m8FrGfOVugyf2QvbhO0zpfivxt6HeCzNx+/LJmFuyvhVQb0liob/zfJF?=
 =?us-ascii?Q?9QRdHrXwn0BKzlljGpFlDY/2KAtThs0M2HivATxFcUHcsrKnA718iS0cG+5x?=
 =?us-ascii?Q?Oabq2IAfsEV0QXlD3kg4jfx/KuXEICthdyBB3YH8avOREj+Xn3BPkRiV7YKA?=
 =?us-ascii?Q?qj/jh1lUBk21KAh/AQ+rf0KeDv3BZ7DFfdEO6Tm869sA0Hx91q9fXkvQYIL6?=
 =?us-ascii?Q?USYUixVb4eibO1/xispcTD63GqkBLveRq0Xaab6k7XpQ0sQWvDYodMN+bAKh?=
 =?us-ascii?Q?3i6qZN8kWB3vCDEiwRlbKRbexAuAVAX4+Vd16gtZtfdb3mAcrISlAFQylxUn?=
 =?us-ascii?Q?/D97elBJF086KViA9UGMpqPruLiKpZh9n1RSwjrXyKYmixTsSz9iGYwnNFPm?=
 =?us-ascii?Q?/Km+KBT4xqhv49oIbzLVZ8nmXwDPk/W49PNsxIG/SpoU9aI3SnOBgl0LTaIX?=
 =?us-ascii?Q?ztpql8iyFa5OyashehgmmhKSWsXDKz4+uBMFv2paBk+fV2kbj2v2Re1lc5Ik?=
 =?us-ascii?Q?P+c/M+eEFLBJVaQorZLMWO0IWvgZXnbSR+GKP61kZLQu+LMEeWWF8UC1x2+U?=
 =?us-ascii?Q?4rR8ny++PryFB1NkZFUbtIU5fG+JYl/AIoJkc4qX2hXPyClBh54pb9s8nVIj?=
 =?us-ascii?Q?7V9f8ndvodikdYrwGG39h/d5QpVbdTTOWJFiCmqB2eESjRoSZ//y0vwdKzup?=
 =?us-ascii?Q?xuQ/7AchNko6FGe7m6Q6T6wposxdqdZXEUAMwJyCOnkCmC8jKi88eYB09w8c?=
 =?us-ascii?Q?aevEbaavjMA8aa6luOS8QIMZUlyDOTI/7zot4zvVKr6u5bVRLex7ZbC+d/zC?=
 =?us-ascii?Q?2cbF5CTyI0sI60DrcwVnu2F4BEW8ptSZZ1xn+xnGcv+W8BY4/J5BExtI8+zq?=
 =?us-ascii?Q?fN5wTNlkoGiTzkSRTyn2AFIuWT+Fzrx/e5EHB1mwuf5I7zCm07/P865ZHjyd?=
 =?us-ascii?Q?o7qD3wYBX8AE6VncytaSqUBKPcRofAIOfl5PTZ+kvQP0cVHrq16gjbKYlV1F?=
 =?us-ascii?Q?DNiJk+JaBB1C7ONeFuVPMfLnX6TmzwGKsMuBOiv6o7orCw1SIWhbD9YMovnA?=
 =?us-ascii?Q?XXnD1gjKw1D+jEGLSfo+IMTbkSsdUyjvvAz6T6zhvXmlJ1fe49dYcFXvxTQx?=
 =?us-ascii?Q?I2Xtez4O3hvaTsg8LbNrCMW8M5k+n7A1VOf710ZFS834?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F2EFF87A0F1ECA4082762AB2874647F6@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f38e9079-649c-46db-7e8e-08db056ca0bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 22:27:11.4099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NarPGJAczivAoKsnStVU7gSLMsrkvkpNgFK1Mqk5MTqZpJYmQj0C3FQ24swYrXlUGEHmuNLw9ZLjGi1/Bd0JhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR15MB5375
X-Proofpoint-ORIG-GUID: GbYtaK7vLwr0QC5riQv_N_poIdHG9Ute
X-Proofpoint-GUID: GbYtaK7vLwr0QC5riQv_N_poIdHG9Ute
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_14,2023-02-02_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.3/block branch. The major changes are:

Non-urgent fixes:
  md: don't update recovery_cp when curr_resync is ACTIVE
  md: Free writes_pending in md_stop

Performance optimization:
  md: Change active_io to percpu

Thanks,
Song


The following changes since commit e152a05fa054170c05f1d5e04e93e2e75ea11405:

  loop: Improve the hw_queue_depth kernel module parameter implementation (2023-02-01 08:16:11 -0700)

are available in the Git repository at:

   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to ed821cf84e7b969fb5b63598c89d3428a30d8d31:

  md: use MD_RESYNC_* whenever possible (2023-02-01 09:41:53 -0800)

----------------------------------------------------------------
Hou Tao (2):
      md: don't update recovery_cp when curr_resync is ACTIVE
      md: use MD_RESYNC_* whenever possible

Xiao Ni (3):
      md: Factor out is_md_suspended helper
      md: Change active_io to percpu
      md: Free writes_pending in md_stop

 drivers/md/md.c | 59 ++++++++++++++++++++++++++++++++++++-----------------------
 drivers/md/md.h |  2 +-
 2 files changed, 37 insertions(+), 24 deletions(-)


Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CF0C6379F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Jan 2023 23:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjAMXN4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Jan 2023 18:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbjAMXNg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Jan 2023 18:13:36 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51D861313
        for <linux-raid@vger.kernel.org>; Fri, 13 Jan 2023 15:13:33 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DMN0MN029141
        for <linux-raid@vger.kernel.org>; Fri, 13 Jan 2023 15:13:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=SffbAGmhHEvmGmYLkdldTREUY8n6/SctLPyxM70T+nE=;
 b=JegBAO0SCPqk5iNUvCSNW9Iwo+PdenNU003DMsH6NYup7FvwU9W8coX0rZBMVzl5Aqrt
 /vohKQDz/vcXsJPW+fEBOXPAsM53ECW/1r0nv6EhjsLTjjkZaeYdDJ63XFJm0oD8TGxJ
 vnvfMxeWTKLQ76jGLoiW23Qd6d3B6TExAXlUozJUIGomsd4qqRlQkmoddYpDQGAwwStj
 on9ULkYJeL5KmwfVUGaGorrKwfcOXeatuR7QnHCd0r06QroGojH2UlYNuWNu1RIXLaq2
 3mzH7819VBy3wjjlkEPMrxWHZmfJU36YnQyZiGCRHTesOPZisAJJgE+seQL7ne7/JX4p 7g== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n3946tsr1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 13 Jan 2023 15:13:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XThLgoJvqzXz9eVzxHIdjoGzrJ18CrNUSkGng7bdOA0x6sEJml30fyuyZwm7KsNwcWePANkCCdB/HHEq00SLrmJdjX77tLbbpKO5bmpekMbfotDs7F6PWNt0uI/oOMJb0FP0mhN9Mz5saitcPQKIknq+ZiGZT+815gICVnxPfUlI1hxWHPHKcjL6gmx+OtFDEXklk04/Ki9Kib7UJjxkKaxD/DvwpPRP/5VRQp26xugbtjkRWGMWa0QptBDeYhhTdtHKedrTp9Wq4YYtGhCtqPWEZswZVftnsguOFfhcw4cvBsVOLvhgAfNtip2XH+XxztJwDju5gbPK8SNDinfVdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SffbAGmhHEvmGmYLkdldTREUY8n6/SctLPyxM70T+nE=;
 b=oRz7s6XjO+H5/CamwFvy+vBLVMiTNCyWhvKq3Zm9RZ1CPMKMMvh/5mU2SBBSrVNf1YNPcKJNkxCCQ2LIr7iMM4INQQ8UNezOfIwoERvlrN24HBzDxMDIDCN1jPnw4rW16i57hlNvmAeGVPU/IopNJyyAGo5fnGmcr3Ux+454xRYmCdBGlePjcKyA8ze92qFOPbMW5BmU7dyXvnOB7keWE/nAJ6LOLv3P6LUDnRvTIVFk1okLbnE1bHrw9TBXWaXHuZfcUeUWyuOfuw9kVmFVeNIdzC+2tCRHdeuZexMwThU3U8KdO+joBGSWyxQwsJn67wkG1xN9WZQ1SvzsxSRdsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5162.namprd15.prod.outlook.com (2603:10b6:806:235::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 23:13:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1cf4:3db3:53b5:cd99]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1cf4:3db3:53b5:cd99%7]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 23:13:30 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Adrian Huang <ahuang12@lenovo.com>, Christoph Hellwig <hch@lst.de>
Subject: [GIT PULL] md-fixes 20230113
Thread-Topic: [GIT PULL] md-fixes 20230113
Thread-Index: AQHZJ6SmIpVa7w0Rh0SROFbqvi56AA==
Date:   Fri, 13 Jan 2023 23:13:30 +0000
Message-ID: <316DF255-F73A-41FF-AA1C-758669C0C466@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.300.101.1.3)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB5162:EE_
x-ms-office365-filtering-correlation-id: d22a69db-05a7-496a-e238-08daf5bbc8f3
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nhOTyt6m40r5xLi148CXkJE7hpXW/fhoetPxpcqsxahuVOret2pq/Mq9U0pfdrAGS2LVQxDb0ilByg+APG69bUKRTpdM0WWV6wd8pOlz6O9ca7YbEBH8rrHkMDkYJ9IiGxlQPxoPhX5kdA96kDsPizDWG2fNZ0d6f6lxLi/sNh/unVO2VwkJ+b+l5MQ9pU9TSehp7m29IfE6eJtm6mbmJ02D4HXYZ1ui1E5mFxI4idUSyX91CbDsI8blLw3Ma9Il7DsinG8JE7zynaN2WvrzIJay1mkCzFyP/gFq/qY5BZXYRJhZqnJXSKF2REoLLhhThR8G/fNi5z/Z2HC9tT5YVY5RKhTSn+tg0EdVw9qc8pU6VxKQYHAfh4ntAlVdXqy5wLUxYAnLGys/ckPJDyZxpqBGT97+9qIB7ux9FNzybwUbwAvW8gW8yrD4mlxvV7+GjFWr8+rPyGYs+Jp6grC+y0mgUOR9ACqca3PV6mIpksM5yeBamp+3jB3i0PDxaP8DReSWjEGx7FQNIOsVuw0nWHMkc/9vRvawJg0f9NmSTwoy7BmImcAc8lvocSggLq8lo5CbIRO3gcTClmEEHDaw7eqBkPEOo0TIkmZi7ygZFEVxdiP+TBkiJUgjp4UjgmwQbDCibiKmhm6O+Rj9q57WG/sW+ikykGsy+ZTmam+Sg6FTGnvPHpBSktPn2j0RjMjhBGSkBLvIiHrg3xzYZ+SwHE3mZEIMERNfyMFHv1KQRCA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199015)(4326008)(41300700001)(38070700005)(6486002)(33656002)(966005)(38100700002)(478600001)(71200400001)(110136005)(54906003)(316002)(66946007)(86362001)(9686003)(186003)(64756008)(76116006)(8676002)(66446008)(6506007)(5660300002)(2906002)(83380400001)(91956017)(66556008)(66476007)(6512007)(36756003)(8936002)(4744005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LOTx9c9C4unHjlO0wiQRr/NHZJYcjsYpKOiOJFTTCvzlngQCpwEVVrLIgXo2?=
 =?us-ascii?Q?5F8mvWuwMyPxL0i0CIQYteJKcaqsLSXP5+SxW6+uNByHJOwnse6RemvzSKnl?=
 =?us-ascii?Q?F44PWm2LO0sRVaSF+x+IY8pwR9FBnnJjMNgEJ+tjWhrRKHJlQxTilzWHuCDe?=
 =?us-ascii?Q?Sn1nYGKEkGES36WI3EZv7p3whsSlAXY79d956GmupSUe5lIgYUm/CDBUjcL9?=
 =?us-ascii?Q?vToc5R+AA+wKiY0FRCdG0upRjOIsOoHUZoqbRFTeInrFgj4g2VG/46dOWsln?=
 =?us-ascii?Q?/urTf6bqWcPrxPoyii4jTvbGTFPaIEvwANvSDw4rK91fLkA4+fzK3BZtFbIj?=
 =?us-ascii?Q?IBqsxHnvGMSqjk+TSCcv7VuKVya5PtiqY2NDbez1RGfOu982fFASAZSKfCFI?=
 =?us-ascii?Q?Mf82abcVd7DetHImHlIgKH6kN78rTazLIKx+2AuD8yL+cpVNRuxjA7osxTtG?=
 =?us-ascii?Q?iEJf5xg3mfl2gTNoAKnrjkC2iIk5J1vg2Ew9sqFEEY+WlYVScgUU2iKam5ZT?=
 =?us-ascii?Q?0iDaWf+lnnyaleLaU/rO06yanTVtB8oNxATg2YUMA01d/mRLOXfJ4MpjMr4r?=
 =?us-ascii?Q?assM3hCiOs9d5NTfW3gjMQNC9rNPp2fZUpUZ081T8AqsRzTWOHFyLjuM7iDR?=
 =?us-ascii?Q?glgkpwfeAIo+WEy26/pJzzF+LuyY+KvZISqKU3PtYSGnQOGxFYBKWTWfPccx?=
 =?us-ascii?Q?kCImyJlfI1718i2RVINnspxtFMW5f9Z289nMd79Ucg3hGZ51BBo1bo/8Qimp?=
 =?us-ascii?Q?BUjQG3hj4rq1/82sGVu35Uy471ORNaZ2kdKNEEToGUXliwo5wY2nJviQcZ0M?=
 =?us-ascii?Q?Me5p/3ICa8C8zr4kfVfAVY8VtjvyrKnFH8+HzoSVoZpGPj5pVpO38ZDlhmwn?=
 =?us-ascii?Q?XG1rQ891wVFeL9vNP9gYi5OMS1m/4LTe78o1Iq031Nhs5RttAPg0dztETPPU?=
 =?us-ascii?Q?ojR+C2+DRgQr2F7bcRJXhky8w1jGTXpPYkx3Ru6Gf/Uda9Nf0IIsmCVSM13F?=
 =?us-ascii?Q?7pvZgHnqLjxJhJUCkiMF1bUyMbwHuorWYrwXVsW7fujHlIiTUBkXRMaeVDa5?=
 =?us-ascii?Q?SnNt20KNz9Dp4Y9GMz/TRQRpFngOL1g8KkifdE7szSCUDj5/z5zTIogr43/1?=
 =?us-ascii?Q?1di3Zf/n+wfr8uD0JvsD9LqV6yRsIr32u1CPSd6mvkoAl4auplpuGZn/MxnE?=
 =?us-ascii?Q?QbZTPbmmC4n0XsL4/Q573BUAyh0utTBu3cYEMThInkyAvPMT4t56cz/ateQ0?=
 =?us-ascii?Q?9/CAjqvs/pvVWY7jWR+iJ6Y1MoyR+TQwMyQDrrsCgc13911BG+O4mZL77zzK?=
 =?us-ascii?Q?7HUW4M+9RtP2gCQqAjeNeLQscsZY0++NB/dMtbjRLLZOLCmg2BQHiPWQOKvM?=
 =?us-ascii?Q?m8xQhN1D/p6DNWajMwBrfN0wmIXE7k3/OqGXBo/XhaMLzqsgKFjc6d15a68o?=
 =?us-ascii?Q?m1pDB5AcbuVxREwHFOzcHV0tP5TEcl9mDJrk3lstW8iAjBcd9QaD0cOVU6BN?=
 =?us-ascii?Q?66VT5wLTIEbGj783mruS6gU7O+0zCNSbsDMNElerYe53JS6AMfNG0drOROzt?=
 =?us-ascii?Q?4Jh5nQetvRjsMLV9yBfthCOObcuHaddY/ePVLWQM8zgeP9q0PPfNdZwKKxHU?=
 =?us-ascii?Q?uOIzgp6YuTz+WqyhDy/fEUc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <046B7808E03AF14FAA7710C67B967432@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d22a69db-05a7-496a-e238-08daf5bbc8f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 23:13:30.4837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vk99deampC66h4XVbCxCwtH08T4CtuSXE23pERJ7Wdh4LX67eMEQzDVrngv6nHd8QQdq127A3XvVpLMB6KqKBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5162
X-Proofpoint-GUID: tJdksi5xvSWUwODoKIjySNQwF2Sr117H
X-Proofpoint-ORIG-GUID: tJdksi5xvSWUwODoKIjySNQwF2Sr117H
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_10,2023-01-13_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following change for md-fixes on top of your
block-6.2 branch. It fixes an issue introduced by recent code refactor. 

Thanks,
Song


The following changes since commit 3d25b1e8369273d76f5f2634f164236ba9e40d32:

  Merge tag 'nvme-6.2-2023-01-12' of git://git.infradead.org/nvme into block-6.2 (2023-01-12 10:36:35 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to b0907cadabcae6f1248f37a32a6e777f9ff6d4aa:

  md: fix incorrect declaration about claim_rdev in md_import_device (2023-01-12 10:42:16 -0800)

----------------------------------------------------------------
Adrian Huang (1):
      md: fix incorrect declaration about claim_rdev in md_import_device

 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

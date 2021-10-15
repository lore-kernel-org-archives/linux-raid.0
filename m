Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA40AC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 00:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD5DB600CC
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 00:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhJOAam (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Oct 2021 20:30:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229983AbhJOAaj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 14 Oct 2021 20:30:39 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19F0MPhJ019347
        for <linux-raid@vger.kernel.org>; Thu, 14 Oct 2021 17:28:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=n0+eff0ra5pfjk4dibJdEx4V9dErFdZ2PmeqJpTRKBk=;
 b=YOqJDPwI7IcRgfusV9eD79u/ftU5mh/Fc6Wu5nLS9ZEMgI+wDMyl6r9zvfCxRjklkXKv
 b+nJaYfKYFgr0jl1DO+JIGIaCIga4H7NZ+GdBCD2jAsK8vXPs3VCsgCEx1Otj45QLt6/
 N11fa5ygBVO7GotzRT7mgfXNoC/gFHwJ+Gw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bpy1e81ma-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 14 Oct 2021 17:28:33 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 14 Oct 2021 17:28:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M224LNTg3PU8QhFtMaJ8tqinXw8N6u1/F1C1Qj+Asqc++GwgGHP9anGHXO5WP/pmR/gGnNQQ+FPcK6clJHuLbzIkMw9vg08fRKgH0CB3MBy9bMySvuakt2luM1thpaqYXXNFCmuHvEt+NeS9Hjc4ywtJdZ0y0FjohjD8h+b3J6tUVrciHKiZSI/nwYW5hloo2ZHg4h1qOC8XI8EQywCMgSinmx9MLPN6xqKHnv3RFr+/J0J4nrufKk14/ZCxBw1t0nx3EPJ51E3ayKf8/9jCTp2QGyWE/bqGq56oSCA/oo6omGvqeeNJe1+a2DRiG/YeVvs5LuSucRDvvyY3FSUxeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0+eff0ra5pfjk4dibJdEx4V9dErFdZ2PmeqJpTRKBk=;
 b=b4SpQbxOHcvsDS/4BRHBGJolF0fBMym/aJd8UcA2HkDw8jCRYMYSpvBDMMvVvYE6P5pHqEgPn+hyVmgzjqyamfnN13R2ARTh1ChwLuHysbRbY5QSSAzxbqm4Rm9R4fG/1rDqFJlqLefUMgYvmPHpoJml0L7kQUtUM43YN/MY2fLL74dCZJTo5R8vnXDofzDfzeWIno3uapX1l6BEwC7KX+3OkfM9NeLUn2QRSHwUwIDP8Qtchj33fsSf/d56npjixKd0hAz17e+AjXqQaZ5XT7GL7B6bFnWMNxHUcV4NjHCrBBwVZhZ9b0o8I6cGKMooq6CMWCpESoQkuhqJHzB9iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 00:28:31 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4608.016; Fri, 15 Oct 2021
 00:28:31 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, Guoqing Jiang <jgq516@gmail.com>,
        "Luis Chamberlain" <mcgrof@kernel.org>, Xiao Ni <xni@redhat.com>,
        Li Feng <fengli@smartx.com>
Subject: [GIT PULL] md-next 20211014
Thread-Topic: [GIT PULL] md-next 20211014
Thread-Index: AQHXwVuUtWxdVga8yECVtx6YHO5+gg==
Date:   Fri, 15 Oct 2021 00:28:31 +0000
Message-ID: <7A48D169-FBD9-4F13-8E4C-022DCFAE3D8B@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40429043-ff23-4b9b-e445-08d98f72b765
x-ms-traffictypediagnostic: SA1PR15MB5109:
x-microsoft-antispam-prvs: <SA1PR15MB5109DA3DD422D7C6401D63ECB3B99@SA1PR15MB5109.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xearQH1gbJlYlRHHcUiWxIA/xEj3vBq1zQiO+1IRgKDF57szTVFDoCo9prDI8cBs/A/Hl2A3hJiV61sT9Pw6vjIoyNSRbsrLqUBxngc3a5E0dKIBr37eC0T+7ye1rVsd/rD8UksO2h8hFBZV6kd+SZ2rK5jrEMlx3gRWKZ14GO0Op/xBhq4Z3tbE8KtcMoU70DF61XIdP8D3eViWtQbKcxE05nJIxO7D/iVJP1IRENCZSOBAF5yjEfCzUoELRtOa5yycPDmK2FohiY4ZsG+sbOmgXjNgapd5cbVHI2YmfAdczC1TJVxEaa5oGi0KDoAB4zOqUqE1Uh5CylrTDacpstjDDKPi4BpSRqV6oJLDJziJSprFZ54lMRpHlyRFJt8qO7ARRZjcP/FruPzGOU1CbAvd4XekqB1Nb+eo0YvkxFXl0wZXFdjxTy+GlsRCmNtHhAWTnKv3Xag3wuH5L6S8SCy9TEtk0426mFHIcobz4YMl/W073701fmclFOsCyoILL/MV9tnev7lsYgo3mDjw3Jgm4FNL8p9TAmWEAww+rLQJfTJWHz8tQu6vibDx1o4gCxg2A4r8H/SOzIS5PTOqpwVxrTUeLRWX7VFPrYtoINV4IOp5QXUN0ccEDLzOfTaxktnXUaatdRKrhaFs7pIMAwZ05cUG9dHjNoyqE73teMu9cFVdPJndG8wXWRbTlkEBpJxjLqI86fhwVkIzICoMgR4UW41pp/x1BcNS9MteQoG5sicOO6WaoKnn73b3JXM42oy1Y1uehRp9isymZmTEQhGwJCNh692Klo7zF3cjuwVuSy/kfZrkWe5tZ3glU3/V2GazpSBvOxmLhneyTj4ZNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(64756008)(71200400001)(91956017)(66556008)(66476007)(66446008)(66946007)(316002)(966005)(76116006)(186003)(8676002)(4001150100001)(122000001)(83380400001)(36756003)(5660300002)(54906003)(110136005)(38100700002)(6506007)(33656002)(2616005)(6512007)(86362001)(2906002)(508600001)(4326008)(6486002)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Dh0pSAFWGPgGqHi0M4nRXlHAT4lYC66aP3itO2a5LUsUTh2sbWD5zahVWNYt?=
 =?us-ascii?Q?LaWL8YCdb0weHMrSWCHP3dlOA+WuuEyAFv1D+zTI222bCkJcWV5gclvJOpGM?=
 =?us-ascii?Q?SrHbWDb9ia+ykWH495IVjmJpIatddrJsRZq2y/7XiJF0GfEUtf2oowRAZyva?=
 =?us-ascii?Q?D6DmBmhdhpqUOBlhIJC17G3uGNcPVV2QI9vo6nAMSTePbK648CbXr4OHATZh?=
 =?us-ascii?Q?+lCJtOZ5K5wsRp4mtjIXMX/OnSPaQeuVsW1AGkJgrwdgYY0ace5EEwtSbSeN?=
 =?us-ascii?Q?weTCivcKrlSwJheHc9i8DvKqCws3zVRX/U80b5ljfTOFiuTZiOnTLY21DzFC?=
 =?us-ascii?Q?a0Ed73wt9unULEhoJNnYtXc9JMdI1hFsE6XR1vD04xouHUr2bpi7dn5O3FOX?=
 =?us-ascii?Q?o6N5CI7b377l2tWpFYcqcmrSsPanjiRRYRs8MryF5Hm9I4fl+HHD4KSCDR5X?=
 =?us-ascii?Q?VFWSaIvyYLUmDmB+EL0ZkqQCrYOeFUdQXiQRTYUy6xpW5wQ7nTqqhO+4bwft?=
 =?us-ascii?Q?j0HAcf79tUi1tvUk/Vg6DCBFgG6OzSu6uG23ZKmZuFV3mIgWxPBD9oQ1kddb?=
 =?us-ascii?Q?of3OVAiKhhq+99Nt0vqdYBhPoUQPTfN6b2h4FhQxx0732cJuV76HtWXzqbEf?=
 =?us-ascii?Q?UpRe4y4HZA7NO+KShgaznPtOqj5XV3Ua3w9P5DutQCYFnf6kGrcHFJotWPoc?=
 =?us-ascii?Q?A/0T2WUpjrbcgbcKLrxPuGIAYdQNOFYcNfCQdOhKwk8aOg/11AxpwNB5SeWE?=
 =?us-ascii?Q?lSZi0SeupeFyW0TRrcDnKJVz06rzIioGRYqSXX1X/78MWW4dTByMCx0HuwG9?=
 =?us-ascii?Q?bX702NEw3Re2rohuApFZsaxa0VbVqaeNf5incW+nr/EEOjvxzKsvNuwBKRC8?=
 =?us-ascii?Q?pHtHBvYsCNnh7nXbG4vjjmBwK99hH2Mq9QyZIvx4Ec5ENQdVLwBpxe9DzCP/?=
 =?us-ascii?Q?kWFrx1YOiHFRqQFEZ2q2HTDqv76S3wgwbD4QfJoyfz3gCPWjYeeqe5hOWcDm?=
 =?us-ascii?Q?F5LXD4COyB/X57JjnMgvKd35lfGll6XDO6W/XrId27RkHpJj1zBnXLkAaQYW?=
 =?us-ascii?Q?WjIb0aeQsnyTUeCOXQ5C9yUjbYkKbiKjkS8Mb71T7gHZYiuIfTLNqeB8gioC?=
 =?us-ascii?Q?25Ux2m7vs8v6mifdaWKbqR0mSz3eVpR+SkHvq8fAvtanzVSkPcpOdBKwa1/K?=
 =?us-ascii?Q?7WCRk1Gi9PWHXf+RteQ6VphRFHavAhBmegoV1Fm/VdcfPZyBLEq3UBPlXJTf?=
 =?us-ascii?Q?qfWl7TjaxAOv+OzN7Metsh31YnbjquMbvp8cxuAlx4Wky33PI3zltUUb3i/n?=
 =?us-ascii?Q?5Bx9Ea932FqN/ThRdiqcZcD9YIONvsZgeZumXf//WqdzZGfuhQtrEhM+wig+?=
 =?us-ascii?Q?ZZYYabU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <52693B6122716444AB15F96FF502EBC7@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40429043-ff23-4b9b-e445-08d98f72b765
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 00:28:31.4676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Frgplkw/ssIJKJ7cG3wkU4wdAcbnTs5zk+rQ/uKIrANjCxcAuVcim5TouX6MPtb3JDJVP6riQhRycsn0HcVePQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5109
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 6o_gKiAHDTCMk8oO4DUcEqCdvgDU9dI4
X-Proofpoint-ORIG-GUID: 6o_gKiAHDTCMk8oO4DUcEqCdvgDU9dI4
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_12,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110150000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-5.16/drivers branch. The major changes are:

1. add_disk() error handling, by Luis Chamberlain;
2. locking/unwind improvement in md_alloc, by Christoph Hellwig;
3. update superblock after changing rdev flags, by Xiao Ni;
4. various clean-ups and small fixes, by Guoqing Jiang.

Thanks,
Song



The following changes since commit 9ea55973b4cef1913c1756560a5de5ba7571a003:

  nvme: don't memset() the normal read/write command (2021-10-13 10:57:04 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 199b1b9e816fb4eb14161cdcbcd0c7a948660bc5:

  md: update superblock after changing rdev flags in state_store (2021-10-14 17:11:59 -0700)

----------------------------------------------------------------
Christoph Hellwig (3):
      md: add the bitmap group to the default groups for the md kobject
      md: extend disks_mutex coverage
      md: properly unwind when failing to add the kobject in md_alloc

Guoqing Jiang (4):
      md/raid1: only allocate write behind bio for WriteMostly device
      md/raid1: use rdev in raid1_write_request directly
      md/raid5: call roundup_pow_of_two in raid5_run
      md: remove unused argument from md_new_event

Luis Chamberlain (1):
      md: add error handling support for add_disk()

Xiao Ni (1):
      md: update superblock after changing rdev flags in state_store

 drivers/md/md.c     | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------
 drivers/md/md.h     |  2 +-
 drivers/md/raid1.c  | 13 ++++++-------
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  7 ++-----
 5 files changed, 64 insertions(+), 52 deletions(-)

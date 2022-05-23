Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52EBC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 23 May 2022 18:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240846AbiEWSex (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 May 2022 14:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241448AbiEWSed (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 May 2022 14:34:33 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7221D6CF61
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 11:12:29 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NB4vlF031276
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 11:11:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=5Crv3sSrRipJO3s5lHGooVEsg/t4/lb5vqOKO9B2jeU=;
 b=GhrbAjefKuZZ0zmVsyX2Xs8j3Sk0l2ViyAeaiRlLXGydxD8s3Rxvq1R/wB9YlCVCUwnV
 c1s263G8rnvhK1PfEIXSGvgHx9UIYfVoYcYGQGZ6skbAIDgRQc4W18YaXE2SgMkPiUiD
 VDnJTNddD49/6bePWXlj+nX3qwnpcxBORBc= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g6v4k31xs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 11:11:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Io080LIR1X2+ITQe5W/QZg0yejWYtiM/bc1fjmhzDca8XBlYqzmjp0ayleNpiww7n70f4d+eWCh67uDTmQYq07/zcDz53yKKNH79Ec8Pv/MbeyFYlcYLrOGwxgg3JkqYpv7gE03E7O7zaDiG75nQKFfVNgRMGyCeymrvzVd3xhZOgSECu7jpM5GjopQZsBFUqvgpH/Dc2buwl1UA6UTOjhwwWpWZ/+d+51eS7bkWoODezsoUDmLb8S7uE71nvsgZXEKc0DM41HvUJmvSH4PmF7GA6ikUETFwvCVxN1XrfSseaLHi+/RVYrLME9ryJhXYQFs07z7iNAVdf0hNM7fx+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Crv3sSrRipJO3s5lHGooVEsg/t4/lb5vqOKO9B2jeU=;
 b=TynPBw+LpXQkzUqGXODFdiHOT4if0zCbwiodEDgPjBfGQ/u83wjShdlvSjqH0ItovzNvpPwV5gjBBoslwsmPkirYyT47P+iKzcJoC2JCml6jPn7tQiLmXDjt4LXAT9XylBCt6EgSO5xfWGOSpGOcmZDzdc7wm3AKFB2oh0wz1izHOZ93bspKheoMzxiYlBQjhC44YjQfBVldcp8gsutrDG9OVuErjnuOyXeFfetIdpkxz/M+yHulvmMAC/tMFm4iD4jwefdO8knEKutWh8QtVh1UWzf16bzI4iVCuO/La2Ub3AfpPkJxNDqRWa5+JcpepmtVJl423g+/J7TaKVXdBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH7PR15MB5275.namprd15.prod.outlook.com (2603:10b6:510:13d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Mon, 23 May
 2022 18:11:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 18:11:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Guoqing Jiang <jgq516@gmail.com>, Xiao Ni <xni@redhat.com>
Subject: [GIT PULL] md-next 20220523
Thread-Topic: [GIT PULL] md-next 20220523
Thread-Index: AQHYbtCG3SE5Ar+Fk0i83hkZJDXq1g==
Date:   Mon, 23 May 2022 18:11:30 +0000
Message-ID: <1711B04D-64AF-4398-8852-57AF79260EE3@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 179f56a2-de23-4312-9e25-08da3ce7a947
x-ms-traffictypediagnostic: PH7PR15MB5275:EE_
x-microsoft-antispam-prvs: <PH7PR15MB527586619B9D3B1CED516A6BB3D49@PH7PR15MB5275.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fWQbtKxok2xtT47Yai7CzM0B2zzSaKnL3Optm2yFqqGzm0EObJG8bvkvtIMx/z/Epv9Y4foQYJxbQ12It3mjMAqahsXboAZYmzpCaG2uwMDD3myl098iRMFg//NA3r3ywN11QN2wo82YMzn8su6MWoDSftY/+pGYeBCpbLi7DfDi3woOtMpM1KHXLXjsRDPbLXQRukQNtRCh4NHurGnADkFu9F0H6DiL0SUtfa9+Mz5pp059a0psSGQpZKbJr5Vp+CBdTaiUdVbuGYZxCiEY90KUCUUhijewxvKxkR3zpnyaGOPLmB3UWkRrUd9e5huwFIXGOgBOVrWy+Gdq0TSjrK13PSnUwOB/FScgHiTsznDkSmVV91o0atkvPU5cjzRIrW6WJbIbzB1FSHmgwjscM1wLdPxXq4F3ra1uDi9aW7WCpvVAdcRwhf2zqh1TY28Xub4ZYk6Usu8t6ZKjTCeQ6RMAbBhBHNr23jCb+rPBLpjv/0YJipamm92Ngrg9DPLC8Mo7lYb/QlNgZ2Bkl1fgmMLWUeoJroSFXnZPznm1LfuKpNfQBIj6HvELvwgg5ENOGLLTWkMLE7Lwle/mgyN44aONgcnwCCa1gMQVqPOhcmNZ3j/WCP2Up451xC+Bxf22aX614nPf4SD9lyGT7HLM4PAdAq1k7G9V0t81XH50T9h/Tsb1CUkTblFHxx5wbfBnWdqqOY3MGfMaCU9zZTX3Cl0oTtL3/gVwXHrZlNWnB27aIVwwFxqaaDKywYW+rkv60WN1PgM5CgNPx8o3mdwkLZc0YbcyLOHff67CwGSlK1as7JgNjgwmvhqd/NqgqT4t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(2906002)(38100700002)(966005)(66946007)(76116006)(6506007)(6486002)(71200400001)(91956017)(316002)(5660300002)(186003)(36756003)(8936002)(508600001)(6512007)(8676002)(64756008)(66446008)(2616005)(66556008)(66476007)(38070700005)(83380400001)(86362001)(4326008)(33656002)(6916009)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fja9AJ5jkxtPm5bpvNOJ26mKwIbXGEoY+2erltlH6322gI3igEOpI7lI6uxd?=
 =?us-ascii?Q?TDqOeVsf1yNIGHHfMYG4W7FEy12ULK5vqXYvPAANRu9dxbnULb9wFNZpivMs?=
 =?us-ascii?Q?cQ4/kkvJboAHaq+bypYi+PtnKgWD6tfPeyewp9ep4wun5lubCQFmKUshRn/2?=
 =?us-ascii?Q?u6BDHTC/CIihOwcGGl8PuljwoWOLyABlAZvOAwxXOydqT4u/TGVdnL0DoGFW?=
 =?us-ascii?Q?CxVif+KIoRyi5eNLu9Yxy7a9zvBaQQaM7xG3xFFHx9XBb0SWbx0mzViMO4TC?=
 =?us-ascii?Q?am1xD+plFNNvDLeqaSbgd6GvHE/hJfZhxArM8P++hOGJt+H0NaV3XaHemBYr?=
 =?us-ascii?Q?eB5wgLyu5hjCuBImwbaGNMeqqF3Km80FYDhzuFoEES9E3KDq4HkFfd5QwD0o?=
 =?us-ascii?Q?st/ZflXBZEzs/NmdbRfv9bDtq1k6/P/3tE0mVwdAIQRGXcsa/7RsqUrmfxY+?=
 =?us-ascii?Q?4JsQSZuLJHpvwEmL1ubj4UtjFBTeGlkpLQ7AubSTGFKC3shWcBnQe9HMV4f2?=
 =?us-ascii?Q?vpJ+8IEuuv0u5DhYroFdnkFQDJmpRLUq6onu3h1vXTCeaakxxVlJt9EqIvB5?=
 =?us-ascii?Q?8h38QyAuEPxdOb4xXZZXKpklnt8QCLoJNN6bgHxYFxMbqgFEgtGrFaIImypV?=
 =?us-ascii?Q?8GGdg2Ho8Q2QGY+MMFXGHDYzhpkZGBYBeOWp2RKsXTDTnGndUzNoYzz9m72Z?=
 =?us-ascii?Q?FidM1561RMBykXvm7dX5wt5s4C3DKH0WPoMal9efTRyAqdFfNSAQbM+y6bGS?=
 =?us-ascii?Q?Mc/oPHBsvF3QRUI5dIjTv/m25koxye7W/BKCj9tNvYK5WbKMh+zCcpvhwQ+u?=
 =?us-ascii?Q?Xv0not7vNUweZ/M/IMhb31mRCbavak9x3Vu5/sL9E8AgA7XHeulE7p0ixEbv?=
 =?us-ascii?Q?1PJcr8JX3Il+BWRZ7PztZ4WMEC6TePb/qwNRvWZHuigoyaBfJpDS6z+r0t+p?=
 =?us-ascii?Q?DL7Qb87O0zXPM9Fxg0/992SRbFvBLqmwjA83EVDY0djaRuoe3x761w1KQMeg?=
 =?us-ascii?Q?fDKGPpIMoUnONsAVgrpW+/ahT0zp53iewDnhfQunbDPpL9V2xRXzPOcEH1fg?=
 =?us-ascii?Q?2+e2ve5waOikrj3pAF71ICnrYNEUAoXPoHaFyyH//K5CXkkf2Lv7VU3X6PH2?=
 =?us-ascii?Q?D8kwlUCLIDqkwZMXaAQ8+0dnkIF+ogZueLMzhvHD7eJ5Xp7V1H4CKC56lq8Y?=
 =?us-ascii?Q?MT99RxqqIGgbp/Ck5uNDlsa8k6/o/4nu6/0DhYPmnEK8AyhxSOa3iTQXsFaL?=
 =?us-ascii?Q?YatwVGddL6lNlhLbPdxiCQjkESO9eWFCgEXxBUA6e6BqrK7e1n0z1Y1i1gWq?=
 =?us-ascii?Q?uF3f7473rbgroAPmGkdFPXoQLZld4plpwJ68m4kAMhNLM7QkwbumA3b1+qCI?=
 =?us-ascii?Q?LbK43C/Uz78Q9go17e2Q887Z4Njn8uaWEVa/Q8eT3LN7lwhqtZ7EOhB88rCI?=
 =?us-ascii?Q?5888SSmrassGzqKhwMl0KMSfg9jxN1qSjYuGFeuvIyrBI/M30f4IUf1Jxo5r?=
 =?us-ascii?Q?LJ7bIx7iPomorV4PUsaranCcLHCsaDxZi8O9FXhxEliOSk6nes+/jSF3ROEO?=
 =?us-ascii?Q?LjekR60yvr9qddQFfHd63HRAmER91NolUbKvhU2tt62yb7Qj06s6QZHPYkbV?=
 =?us-ascii?Q?a8+UPVs9usm07+L3ERZKS4QBjEqknY8iuXYizoTFwFXsW/4XXXRtK2zwrKew?=
 =?us-ascii?Q?aTzi7+BM1saGHvWHHr/r7yCHSy8OH+cRZ4HnhXQQgQTgqhPjVXuQX0Mjpq9K?=
 =?us-ascii?Q?iOHPXVpTPQijQzXFtK1WZomOw4NQ4WmnJqfwRIX2g/FZC7kyvLuo?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4CFE965D43C72A4EB839177DF8B1D3FE@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 179f56a2-de23-4312-9e25-08da3ce7a947
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 18:11:30.0876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ht4FwNVMYCwR5tjVCFCy4y3qTsHueyVp1RWtZmRQYBGQS1pfoxLaWpeIoAdj/l9P+qjJWzdUK07lp6BgvtOCXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5275
X-Proofpoint-ORIG-GUID: A13JajdU_4pbNHk35ptbHAMRUsKryniC
X-Proofpoint-GUID: A13JajdU_4pbNHk35ptbHAMRUsKryniC
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_07,2022-05-23_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your 
for-5.19/drivers branch. The major changes are:

  - Remove uses of bdevname, by Christoph Hellwig;
  - Bug fixes by Guoqing Jiang, and Xiao Ni. 

Thanks,
Song


The following changes since commit 537b9f2bf60f4bbd8ab89cea16aaab70f0c1560d:

  mtip32xx: fix typo in comment (2022-05-21 06:32:27 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 42b805af102471f53e3c7867b8c2b502ea4eef7e:

  md: fix double free of io_acct_set bioset (2022-05-22 23:07:22 -0700)

----------------------------------------------------------------
Christoph Hellwig (1):
      md: remove most calls to bdevname

Guoqing Jiang (2):
      md: don't unregister sync_thread with reconfig_mutex held
      md: protect md_unregister_thread from reentrancy

Xiao Ni (2):
      md: Don't set mddev private to NULL in raid0 pers->free
      md: fix double free of io_acct_set bioset

 drivers/md/dm-raid.c      |   2 +-
 drivers/md/md-linear.c    |   5 ++---
 drivers/md/md-multipath.c |  15 ++++++---------
 drivers/md/md.c           | 185 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------------------------------
 drivers/md/md.h           |   2 +-
 drivers/md/raid0.c        |  29 ++++++++++++----------------
 drivers/md/raid1.c        |  24 ++++++++++-------------
 drivers/md/raid10.c       |  54 ++++++++++++++++++++++------------------------------
 drivers/md/raid5-cache.c  |   5 ++---
 drivers/md/raid5-ppl.c    |  27 ++++++++++++--------------
 drivers/md/raid5.c        |  37 ++++++++++++++++--------------------
 11 files changed, 168 insertions(+), 217 deletions(-)

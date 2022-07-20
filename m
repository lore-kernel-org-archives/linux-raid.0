Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474C9C43334
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 06:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239200AbiGTGI0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 02:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237966AbiGTGIY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 02:08:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3263868727
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 23:08:24 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26JJwG40008432
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 23:08:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=kYGPOQ/y3ZXw8de1ULEmto3jRnyLO9FAsjXZcw56amE=;
 b=FMThSUkm7Z9Xw+ftltSlG85/6PcIX4FbgEwFauR6MI9S0eYoMR6UMhmoUcVEzE6SsP7T
 lwV0RloJzZduCGAm+I40AhJKHXtxHhxzL7tmBvp93re2NbwoKA2cJzvYqDUWzSPZPSly
 ESrAfsIMomWmLnXzLndKAm+MUD1g0bM2mQI= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by m0001303.ppops.net (PPS) with ESMTPS id 3he383am3n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 23:08:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EV6HSa9o0dF1eKBBBBaHv3yW0i+wPdo3DwSWobPfs41r9JMJIWTc76kiFWoYuYqxUEAGVgYgC463nIqX6hbSfAQTVtnwIA5BjBSfi4SYOs64niEz3srmAJCwtQCH/29XFzkS99pPFG9o3J3kJh3AmsSaQ2AY+27f4G9wTCbjlCFSpkOw1TYQcY8dcVfl41H+jec7CgXKG29P1aNss2KcdgvtihfQcBW0/tqiaboLmOabzjgNdeq6HxSsGGGgF2R8coNp5R0Z5V/05luYtQhf7ZzfVhUmmw4/KZZxUYeklmAsFciLqVdBXcHvC7cnQNzLMCAvTVbvYnEGCtb4iRdTUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kYGPOQ/y3ZXw8de1ULEmto3jRnyLO9FAsjXZcw56amE=;
 b=BeFCgqD7ZjVM+g5ln7ZtajJAtx+bzLZAFccSiRUG0PvAsG11XwhDSfjUL7YkKCWiKokmnVhPYhxjx9poIppq6IA1byMN7OI75MKyt/vMn7jSj7quO4gpsjQR6I7oyxNYRHeOU+oqoEZX4FHzJqsayr/KWuMSBGzSJMKrdWz/ufVOOHXA/qfI3ePUT41/P9JzkjfIeYe0sIeiw2uuFWHQMeHDpxrE0hX9zIudeBpdpbm9tw9qHnQ3Sw7Xeupp5B8bKdpz7NRAvnuRM5UsGufhQAspae1nyDtOYANSPik8WGYvxAqMEFV7El9RQrWCOu/URSCfaetort1TuplZtT3AZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN6PR15MB1714.namprd15.prod.outlook.com (2603:10b6:405:52::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.24; Wed, 20 Jul
 2022 06:08:20 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 06:08:20 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jackie Liu <liuyun01@kylinos.cn>
Subject: Re: [GIT PULL] md-next 20220719
Thread-Topic: [GIT PULL] md-next 20220719
Thread-Index: AQHYm59itXAinBFwR027LgYV2rHJOa2GCCmAgAAHHwCAAIQpAIAAMCkAgAADUQA=
Date:   Wed, 20 Jul 2022 06:08:20 +0000
Message-ID: <83ABEE55-79BB-4FD5-A2D2-CA40F579E7EA@fb.com>
References: <5553FDCD-7628-4A40-A228-8E1BEF6FFFA1@fb.com>
 <57876115-7e41-f11e-3cca-738235cd68db@kernel.dk>
 <7C4DD0FE-6C05-4BF4-9A20-8C6A012B6658@fb.com>
 <c8cad78b-08cf-43e4-6610-6978fe0ce201@kernel.dk>
 <D5C50E0C-3301-428D-9FF8-642EA1568445@fb.com>
In-Reply-To: <D5C50E0C-3301-428D-9FF8-642EA1568445@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d0fc03c-356a-4270-4dbb-08da6a163ec2
x-ms-traffictypediagnostic: BN6PR15MB1714:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nm5Lt+h86qeWjnEHQHvzcN91l8Hb0imArW8gfnrEqAtXmOrpjo/pF0mej9WZboG3aYI6zqZPe3dprMHIwL+Ze5TsG+q72NO/hvuTdSf6ENkYIaow98rfttsJdq0bPN5WipQxaf1Ur8AtvzSdEM896ini/ybSARQnQihl6GV8Cm0gDfhwLX2rszryjtG12grDof7zdN6Hk0NT1m4jab8uyqkffjXUAszypUl1F+2jH9Hg0mBDikgIaKHj5Lf4Y2qiSa3UYcl8colUZ1/RJvXxluc9x8Fr+pN2AUJD6/lYDR75fOa0FA3w8P9iyFpVb7/aoHwKe/I90x+RFtv9RsOunqm30mGXw3NJq5M4z8W5jw0nKRmcsh/w8jVUbpbICrYU3N7pjXHNQfXTvKDolHnaPZ1GYOgaDmo9Y7NnWV/cYeVNbeuUnxpJ9evPOJAEflU5FBZbS9EuqROBYEVTptSWGIy+nMHv4v2UHI8DBmy2chAs+6St2jwv/p0c4JPqHI1lyui2dSPWe2ty8r3fW0wVNoR08h+0eSy41EmSWJ/AQZQCgxPJOOORJ7Zat6MSa+CWGPNkaANSchyzKKNHdKtvk+LLU2c9/0xY7yDfIawOH6n0vSiR4UPh4f5C0GKhgcl42eLLTwLdzzPOnblWcTnWHqzswfWmSmvVanB8NLiGOD6dhO/hV6vHWT2hnSR8Swbn0HaXqBJIw7BbXAR5bHAUaCKxZZRwz43g1RUhFtAsc+pf9LrvI/K4E6ez47t+ysRVkpUuC0xqr/yMysyS+7+tArZH+0hRbGgH78Ayt3ltAA9U/7NpDA8eiYQsyK46IfhRM8HcgBVJoMbWD3EE54ZPFwvPrQ+snh9uO4B5srGFY2Opb0lYk/Mw3/q9KYmqKsni
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(2616005)(8936002)(76116006)(66556008)(66476007)(66446008)(6512007)(5660300002)(4326008)(8676002)(64756008)(66946007)(36756003)(33656002)(122000001)(2906002)(91956017)(38100700002)(38070700005)(71200400001)(6486002)(966005)(83380400001)(41300700001)(54906003)(478600001)(186003)(316002)(6506007)(53546011)(6916009)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JNIzFijb84AGnUa2T6nZUBKXjzI43B0k6+4QVFt06zjyrHqfui4FZozsDVpx?=
 =?us-ascii?Q?o5OPCooExaGcMyvRZMZCGm5xmFYX9gkbr8BEm/ZB7TejDPrlSpwJkGMVo1Kp?=
 =?us-ascii?Q?dYJEJ3AkTFkqqsfWtgtQmRtZsondT3FBm0KdZ9cjk7E2fqQOxhxmq6q1EGwY?=
 =?us-ascii?Q?A/VSBOV4qfxQXk0P2geXL4NMO1d3id3DzCWysVsLTOy58QdoHauUfHB/3wYC?=
 =?us-ascii?Q?vb+YbpI+tF/98SdMVteePFyriA5a7isK3ElpF8TtkLXpoYOsRoZ6TyNXQYir?=
 =?us-ascii?Q?23rPOfgrd4kpoJzAt/SVJU8iGLA9k91BHMmen5Qhiz1x/r7ykjuzYu691dX1?=
 =?us-ascii?Q?Vu71fC1aA1jebnXKQfNoV/SFYb45epg7BclzQDPDv8icNIQjsKaKhqg1g9kS?=
 =?us-ascii?Q?OfOBEvNp11BqsRxyXOEVAnlQdSZ+Oa7W+2GPs5uVa46bnSLgvVEEtKWab/5c?=
 =?us-ascii?Q?FOEQM2TQLe/vOY0nNZg7n4ro2OBcz1QSQNnikHVH//rjCHYjqvf97ETcUqU0?=
 =?us-ascii?Q?tPmakU7adSCcvXGuuCs7QIPvJLjcqXgvQA9UEyADsEKpqwPo7YEv/B/Letag?=
 =?us-ascii?Q?ly8k0ZfEufGhwPddMx5apfnWHoe46SV3W9rSKDIjVRkkTYxggbg1N82SkG6S?=
 =?us-ascii?Q?U+7y7qqZXrByEvjp7c3cKsFMBUJgkRuMYL3Au3W44SeZ0xHt4yxF7gnBV0+N?=
 =?us-ascii?Q?bXOE+csN1o722V8ckfPaiBhjIdhr1ek+8UQgfTQOIzXPhRQbQI9zLjrWm0JY?=
 =?us-ascii?Q?iHVgX+S8olhi2lemz70PgKf3JFUn5x2LchTBkap5iE+t9/NoJlUv2GZVboT+?=
 =?us-ascii?Q?nj0/TkEXSoRNGvL30TrQ/xgAa63YLgW2whb3JSiWQlGwhu+hW5yCPdpMu1DM?=
 =?us-ascii?Q?Vg/wMyPPitcXykW9rYbN8lycnzNlT9DcGh8MwExujvD3dq51X10R2tbBfrsF?=
 =?us-ascii?Q?wmkKEJjSlypEaHSdAUart76Usg85As/B1tmQNMTGipR0+yZ/Z3AX0fjvEvLq?=
 =?us-ascii?Q?fXuwb8IMwopYLq48x7ZfVWQJ6Atvcv6HKUpVOoTeXVWDJaX/WPLS8Sy/voUF?=
 =?us-ascii?Q?Y11pcTC6/95O82ws/wDcF0vrhVsDKgZAdKzLBihMuIa3wZRu4oqB2kthXEBa?=
 =?us-ascii?Q?qOi7+hEccNAVscrkX+vo87aDNLRMwmkSYHqPxoRkPR9yYQRFxzgkV/gabcpg?=
 =?us-ascii?Q?ALopY4NqiwiwLGaDx9cXvtB9PU5Hyd7XDwIq4fD422IzgIFFqAac5nvbNzzX?=
 =?us-ascii?Q?w0/zDjtH8ST3hHHENbnz9++eK7VFsPacOi9AKXtVd4DYu7Porz0wL1yTpr9Q?=
 =?us-ascii?Q?+/flGgsxFxczkeiaF4qvGbYjDh8N70c880t+Gs/ebIhqLTeRVne5NJc6v3+a?=
 =?us-ascii?Q?g2wOzi1HG9GfRpFgGKbuWeYFRZ4pO+znskE13m7FQJBR9GftPUuk4t3pldPu?=
 =?us-ascii?Q?bqR8P7vtTHNQrwA1vhS98efGcZbcwzZB+SgiiMYVrv0wSnkez7Bb+Px+uON2?=
 =?us-ascii?Q?3ehkyL7nydxgxDV0z6qgfiKoLEZUMbDlZ/NFnJjUYVRVZb+x4W7mddFf7XTM?=
 =?us-ascii?Q?7Yu6wH1JiX8Hlg4MdDbBe50TYbCyzF9ubztZIODZXBssPDbLNZnrMG/R+YsK?=
 =?us-ascii?Q?GJmM89j+c2IwGeRgNMuTK/M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B3F6C6F3E87BB41990E56CD46C54243@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d0fc03c-356a-4270-4dbb-08da6a163ec2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 06:08:20.0165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Avq+YwzQ2FWEdseGRVCchioXihbg+J1ltmj8T36v/eei5y9U9ehVfuJg3mU1AOyd6CLrJsWGoV1DZoo5l5C+Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1714
X-Proofpoint-GUID: 26XAEj6NGcsQP0VeCjhILuW7Oug7JdI8
X-Proofpoint-ORIG-GUID: 26XAEj6NGcsQP0VeCjhILuW7Oug7JdI8
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_02,2022-07-19_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


> On Jul 19, 2022, at 10:56 PM, Song Liu <songliubraving@fb.com> wrote:

[...]

> Thanks Jens! (assuming the branch is named for-5.20/drivers-post). 
> 
> Please consider the following pull request. The major changes are: 
> 
> 1. Fix md disk_name lifetime problems, by Christoph Hellwig;
> 2. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
> 3. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 

One more last minute change (added Logan's Reviewed-by to two commits).

Thanks,
Song

 

The following changes since commit bd1ebc67722962962b0d568c26f62bfa7bfe786f:

  Merge branch 'for-5.20/drivers' into for-5.20/drivers-post (2022-07-19 21:03:38 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 211a3702d5aecd9f20823ebe7dcea5b915fae08f:

  raid5: fix duplicate checks for rdev->saved_raid_disk (2022-07-19 23:03:35 -0700)

----------------------------------------------------------------
Christoph Hellwig (10):
      md: fix mddev->kobj lifetime
      md: fix error handling in md_alloc
      md: implement ->free_disk
      md: rename md_free to md_kobj_release
      md: factor out the rdev overlaps check from rdev_size_store
      md: stop using for_each_mddev in md_do_sync
      md: stop using for_each_mddev in md_notify_reboot
      md: stop using for_each_mddev in md_exit
      md: only delete entries from all_mddevs when the disk is freed
      md: simplify md_open

Jackie Liu (1):
      raid5: fix duplicate checks for rdev->saved_raid_disk

Logan Gunthorpe (2):
      md/raid5: Fix sectors_to_do bitmap overflow in raid5_make_request()
      md/raid5: Convert prepare_to_wait() to wait_woken() api

 drivers/md/md.c    | 310 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------------------------
 drivers/md/md.h    |   2 ++
 drivers/md/raid5.c |  35 ++++++++++++------------
 3 files changed, 183 insertions(+), 164 deletions(-)


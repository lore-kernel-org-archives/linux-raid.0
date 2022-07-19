Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C39FC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 18:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbiGSSgi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiGSSgi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 14:36:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEFA4A831
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:36:37 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26JI4wnF006894
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:36:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=LgTykm+ryav0sOXvyQWqIw67U2Lg9PqxMpbmbXr8Js0=;
 b=TUQ3b1lerkcM2p5SYD+djnJ8M2z9uwXUrfPHTBJT1YM/WYhL3YMSpSlBttFXr3hdEVF/
 SyvLWAy25dYcN+rPmHa67QOkfS7r01PUWDhQpypITNqo4DIpV02nnDViMkIpdRwXC5KY
 5kbjqq1+ExmUfdAbF03bWSQ/emHnRJ8AlgA= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hdv8f2s0a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:36:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKc8/cwuhzflat+NJUhe4sRO9zsODv0eFd3l9Xsl2ftjIs9dRYZ8rFCPLxW/TS55oTT8Sey3313pgSYVqOCT8Matq2AkejMxyKbVJQgMGnKZXblzqbv8pbOY5hVhEi3Fu8yiJ4GoAb/2XhCVh+8oHOGw0M4UfJnWaCDKG/ValD1iAHdlr5g/IHanRWmpiGOIQyjOiGOoA859Jnu05lnaWiredzXDXDEu0SWNbcN5HGeUKjMyxRAMDX/HZKvvFTIqujyGg72Iv09PJYaPSCkRhkPfi2ClSE4plNRwfFk1KvC9nxs0HA9IkC+x+vaxXVgLIJuXpp2pMh/kx8R/DwLJyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LgTykm+ryav0sOXvyQWqIw67U2Lg9PqxMpbmbXr8Js0=;
 b=Z2vWj0zEx7vaF+nEdmupXNGalT+NaTAxUSTd9ItWoWyZe5TJaPfblwgMOyDMw2KZ6fRQjyXx6nfUmCsUpKCPNLe3bytzxvZST9qGbchPzAhxvuhD5qAAnpkiPGyK05MRVQF3ZP1qR1lcKGcJw4iD4SVpUNy+YeR8wdGJsYQlZHGsBx/H/PUrPuvZAP+zTK2yCKTjEQXw4fg9Z9f301DyD04fYCeMS0L7fM7Jx4j/04Sb9AzhqwSbAG3P8HQeOleY+k43L0mVB55DIT5zU7H1JQLcWc37oFZBhll0NOajMGgOKiDKrAshuK+ccicgfVSQF0Auvm9Ul895BmoKK7r3yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW2PR1501MB2138.namprd15.prod.outlook.com (2603:10b6:302:d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 18:36:32 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 18:36:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Dan Carpenter <dan.carpenter@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>
Subject: [GIT PULL] md-fixes 20220719
Thread-Topic: [GIT PULL] md-fixes 20220719
Thread-Index: AQHYm553C8CbaDpG8UaPl9pzStuDRw==
Date:   Tue, 19 Jul 2022 18:36:32 +0000
Message-ID: <4B55D811-BD3F-4D15-8176-816B5828309C@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d737c01-0c9c-4bf5-d6be-08da69b59a7a
x-ms-traffictypediagnostic: MW2PR1501MB2138:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1J9igFpxiNEhixgFLsirBXxm8xpykBBc165+8hF8i87OZ1wgboQV6q0QsdiRS1wDWLEIHbiQxzQPe2Al0sLv/FpqJpaQJbkkkf3VhF3ZHhC5Ha9fybjWzHTG2S/FrBv5XLo1jc9XjfYrF7cccVAgP4ZRtmGLBdEQrgGT4qnNoXU3fPIPr0xA0NTee2EElvsyM9fyLySWHuXdcSNPlkmTdP3Uc9ski2/lOK1+qjjPG4wmmUKsM9DgK22NXabJxtu1T3LxhZP7zlzulTeJSFDTg+LGdN46v5SM5zY1uMpWmVlxV3HKJRKeZhssx55OsEakwQivOgPYYa0G3wditxezm3YPyhFFqg8EeBHF1k7n5IgJi+qsvkjDCspaxu8xrkzHDELnjEmW8xkOxd1S1lNBht3tfxA5MBAMeJQT0MpaobyJw/YE/DNWQV1Q15MMJn4kUAvOIe5mONkdtNcdfw1nItyzUFgbw9iG8278bXJZduhFlNzdlQQ5uMf5HclAgwoHysLM+2xY/DplX+EGR/wIGwIxE0GCuWow2acsHfYP9qtU9VKrtmtjly3ZxS3gEkSzovOZ5Kd1+xKLYVLLQe4fCKN9zvyatdWEiULiBjQdxRND13SaWZ/B5JmqS4iebm0GXRoB+nx9ZoJbHWk2HfAycsKQxjmj1cvqGH1NB4cyIg94jBwdwSYxcR5fCKkX6eYWQgqzLEVGkyB5Sbx2+lljAJR41G5wAPpwh3AL523c+KRm5ZHqNkLMefzgDFEq3myJWeuOw6+krLwUKKWVhz3ZKMYFUjPPacYEL0VgFCDDfaM73O4TV3vVaMdt8qqoDllsPb6i5bkm5UzC+DX7gosyHrr5O5t9rkCF9PgzpTPOhuDUBht3TUQcAotEnWqp5eLQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(64756008)(91956017)(4744005)(66476007)(8676002)(66946007)(38100700002)(5660300002)(76116006)(4326008)(186003)(8936002)(478600001)(66446008)(66556008)(83380400001)(86362001)(54906003)(2616005)(33656002)(966005)(6486002)(6506007)(110136005)(6512007)(316002)(122000001)(38070700005)(36756003)(41300700001)(71200400001)(2906002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GXBLra8M+sok6TThyXDh5CE+hCkplr+ulA4DAHU0MFKdxoAHeKssvuGghR8w?=
 =?us-ascii?Q?RndoYcpckZvzuWHtOxjXC9oTgWn0CbUNiOVZwwtLE/Oojoxkgj47SPt12UY/?=
 =?us-ascii?Q?fDXBqVn07KyVyWOMN+CnYeHJfJ/uvRAO5K2VUWvlYqnpvKQtKcgr7oronzzI?=
 =?us-ascii?Q?ZdzR9TIQBOK7tJGCkMr4HUcs3CmNw0DqwuhD1C4eukWiq91hR/CxZypr7C8X?=
 =?us-ascii?Q?cQsOnJ/1xo+u9pX+ytaKsD7G2fJoEVjVnv2NkOtKqVAfWUBHCUEwbFsBIieS?=
 =?us-ascii?Q?lclE+NLMrgYDbo14Af4213lGqtTwYZHFwy/u0YMrygMdfWHDQ8Cs8j0Rjy6q?=
 =?us-ascii?Q?kGlNzOAFFkaozLVnnxPgD4j22UNb+00iWQiN+yfWwQCliXZVtuRZINmQDThg?=
 =?us-ascii?Q?Dht4Jomej4R9ozk3aegnd1qyyarjqmWa+p/VcqZhDTz2j+WfLdTtEQr8htD+?=
 =?us-ascii?Q?oPS4nzOIE4h+HG2JJJwB9puBJcGDSGboOWcRSjkxU5BvBrnCHDjT82EXxHEh?=
 =?us-ascii?Q?gGZlYeG9ELwfLwc4Gr8a0VDPsAR53ZwdjIWeSSATyGVWtv9u6X9FQTbwIQtq?=
 =?us-ascii?Q?GSTlDc9qoPbVOdpMshDZC8Ly4LkPizNkRh1jfYs/rtPdA87R8pXfNVjtdvMI?=
 =?us-ascii?Q?R7gyud8O3EZnBbOJGNRmCSN5Q+oUjQh5zCnuQ0Yt1U7zBG96kOETRk7t5Yug?=
 =?us-ascii?Q?Ps+VVkWxmapum2zRbRXwFb7RStzpppF4pye+Q8sVvfcubtWd7g8pWzXS769q?=
 =?us-ascii?Q?Ot6N1f6c/oIGm642AkXA/fUSSu0AWThDKfvipu6AVZpvXvXHNN+6zuVmRLP+?=
 =?us-ascii?Q?KamMDQ6GnQv5BquAE9yTa4s54ATx6NgL2SJtrAr3gAj5ovqAXz3zC0Wb6VCH?=
 =?us-ascii?Q?z0/Ve0xd82ydDbzhUmE8FFOuMrSxaFMyeEmqHnV/RjTR5I3dOV2E2YAiw3/2?=
 =?us-ascii?Q?cnyJrGgossr3N1uvM4msDFqDv+4rt0unR8qtFtbgf04dh/R4XM8mp2TrRojZ?=
 =?us-ascii?Q?yKbLaxa4uKsS2/TJoqPMuusnUBIh89xsXQDxkmCkgRBLpjeI9Rc8bEdCCrI3?=
 =?us-ascii?Q?p0e0Xl5yGjBlqaMmCxH17KIjPPig/phVjLww1CL2IuIHnd36JJXPgICMuHif?=
 =?us-ascii?Q?KidU3vbAyJy/xOPbOTFHpylrcX+l6Jw8eYdGMvthov9D5WB2OZC7L6/Nq/9m?=
 =?us-ascii?Q?+mQqKAwnzTHf3bj3o5lv2Zxc3b4+RweMDNWgwRvaPOLTQ4hjbK0XdI0t2rjP?=
 =?us-ascii?Q?w0TEmCrDMPugbCbqJauMuPEY4kDbasnIuSVCRanfFE8IJ0KVOxbTl5FVYjXr?=
 =?us-ascii?Q?agjf6jgn3dIU7S7vBb6/enJ16fGizU+qwjbnRrkEbkgBnHohEaxECaWEdSyN?=
 =?us-ascii?Q?D17AqN1cIUDVbWm9TOSs/+PCVfK9GPZxFqICEF25Tnb+s6faaXoRamD/Sghu?=
 =?us-ascii?Q?9sqVmdXKOSEoCGpmWzcjQMDiLZBH3+lDe9tMbZbCDOm3oMhp359b+qOBGKDX?=
 =?us-ascii?Q?r/Uvpbcvt9e4CMcgNBe6NQ4KgiBMiEW+MNqlr/ICkrlDMw2YnjzelELX2B/y?=
 =?us-ascii?Q?Pv3XVNJB2m6OaY8eSmvWeUqGxZXUePIdaF05Rp3afsKtduchIGz1K5nwPJAj?=
 =?us-ascii?Q?eOOaeefdO/XXPsq/Pi2lfsM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8298185D01DB024F967DDCEB9F549CBC@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d737c01-0c9c-4bf5-d6be-08da69b59a7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 18:36:32.7928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5kQiTYcZKaO+UUIwjJLJgZFi5pL8AvCqqG5oAKLQmhw6SKo3+gsBLOgBQE/7liyJGN/G5muZk0rpyW2SpDCUrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2138
X-Proofpoint-GUID: KaPi7iuA6yXX_0pmIn2SYThgQUKg6EmL
X-Proofpoint-ORIG-GUID: KaPi7iuA6yXX_0pmIn2SYThgQUKg6EmL
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_06,2022-07-19_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following fix on top of your block-5.19 branch. 

Thanks,
Song


The following changes since commit 957a2b345cbcf41b4b25d471229f0e35262f066c:

  block: fix missing blkcg_bio_issue_init (2022-07-14 10:54:49 -0600)

are available in the Git repository at:

   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 5f7ef4875f99538b741527963ffe09e869b49826:

  md/raid5: missing error code in setup_conf() (2022-07-19 10:58:33 -0700)

----------------------------------------------------------------
Dan Carpenter (1):
      md/raid5: missing error code in setup_conf()

 drivers/md/raid5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

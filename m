Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA2AC63777
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 18:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F4E2074A
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 18:17:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="ZH+Svv4i";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="lVk2PVCz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388033AbgK3SQs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 13:16:48 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16724 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388030AbgK3SQs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 13:16:48 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUI9Vn6030975;
        Mon, 30 Nov 2020 10:15:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aDhiYHkKUXNW8N1gqdKA6xp6ht//+SGB7DEVpIsWR7I=;
 b=ZH+Svv4inDnwImgWSFSGT8B58THKInM1MPpA2flKZmmv+lYYWnIputGRpbhQB6bW6+NB
 4wUnLLZdnDhUWVBgn7/+xNF4jTFwOaswIrZzDmwlaQ/67d3v2FF6bLRHFYb57icjGblO
 iZm9NDc7tUTHoZxt6l1bFSIzOUir6yLHbm4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 354c7qdkr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Nov 2020 10:15:57 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 10:15:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elk4lCO1ieVNibI7xWAJ4EZ7xhm+SdKz2x3RfbcKeMiCdfoBpvxjDbIp+DE3DZa7lsdMURiMPuXuxeergLKgrMAjjsvmDUuhsQBhm49bMhoUofaWabktZitNecLnM7WVny3NAQ174Od/+x5JOoAyKoUJCW8Z9ljsKH8jTRN4l68v9oXbkuYAWuxlrAZOYDE/nP2G70Zm/q+lS04ZHT/EWNeYOcYyDXOL1ztraYWxuOTqInTNecRDByT9mBSTj6unHqzMvOI3Qbxg/DmgEIBVLweiYwkq08hu6ZZmzslfUkYSwyGb4PxUX+DghlLWC5MeE2P3QAsVag+T1wTnu/aQUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZ6U+f4ANTb2+ABNnGZ9xNl5SuDkvVaPiicc69fU2PE=;
 b=jf33hD6WjzniSEt0TTlofkz0kdj7lKkPC1HNeFv7nLUak5Rny4pmbKb1usoi0VtabErc15v6qokAeCStWgk8/HbDBFPYMIg7z7lUw8qub/YgLAV+i1EkzXXvWLXPLWvmh/dz4WKH+QZOON6EUO/s203VuLGSFjfZE+OVBGwlJChJcrPJKbmEnO+1/AtJ3IVpbvEaAv3c/BgmG9NrACM8bfVD/egg2v/Dks3OzoYc3hRpAkQAvG7rHb7nWN5Zdiba1zkKgv1XPuSYjk4cEek4kr16C7d374tnLfxm6J0WDEt5YSc099+m/o22FcuAbiaf5hVThkBBKUopE3oDWcwxZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZ6U+f4ANTb2+ABNnGZ9xNl5SuDkvVaPiicc69fU2PE=;
 b=lVk2PVCz7v53cwSzKg8Zi874beupD1dSfgekHsKhaztVrllRk++rKajqULeg38TVW2O2eqWj3fMTFtxrX7HBpPAJYKBq2csEDspye510Fp/UoRDELEMxwAkCIZf1vPFlb584hXwkE22QPOHUS0Jn8tdDqZmu0dT7nyKPeVJFOgs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2583.namprd15.prod.outlook.com (2603:10b6:a03:156::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 18:15:56 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3611.022; Mon, 30 Nov 2020
 18:15:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Zhao Heming <heming.zhao@suse.com>,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>,
        Kevin Vigor <kvigor@gmail.com>,
        "Dae R. Jeong" <dae.r.jeong@kaist.ac.kr>
Subject: [GIT PULL] md-next 20201130
Thread-Topic: [GIT PULL] md-next 20201130
Thread-Index: AQHWx0TYyu9IuxpRPkicdWuoUaFNHQ==
Date:   Mon, 30 Nov 2020 18:15:56 +0000
Message-ID: <84FD2F29-B2F8-4026-A93D-5E28F28A3B4B@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:438f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23a73cd2-bdd1-447c-aab2-08d8955bfb29
x-ms-traffictypediagnostic: BYAPR15MB2583:
x-microsoft-antispam-prvs: <BYAPR15MB2583BF1D5DF27B3BAE06CC49B3F50@BYAPR15MB2583.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6bLRr28VdnN1DbzOvdFrz4NJl0LUV1DWjZNaTY3R1YfYtu1VkKnB7fjzNJdaPaEHyfIEJtaBNW+upd2suQURH1CYNISMv9l9acoK+Onnm6OZoApKvwMBmUxFJQu+hh+s8y2aB8C9iwpV4h8pDePZc/rx/sXGA9zLOGlNud4zO35am0sXyFefzVsBnyEThV32bhtY2EkN01CSeWAJBDJTRA29xfrfgRkBKI1aldNx2UBY5wJXnEBkP7UWs+CJ4bYP3a5CejKBqkyI/z54799UIshOJ/mIPARAGHusgzCrGP+nXPU/OE/RXtwc3gTl5KZNfF4B4Xk8GOi8YvTPTP3U183CWDSKGMUKNLX1iGd3MTBKEruy9q427RSnmOLt/3F7krft16f8FEkBikQ0w70DXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(39860400002)(396003)(136003)(6506007)(66946007)(6512007)(966005)(110136005)(2906002)(66476007)(186003)(83380400001)(316002)(36756003)(2616005)(54906003)(86362001)(71200400001)(4326008)(478600001)(6486002)(8676002)(5660300002)(66446008)(91956017)(66556008)(76116006)(8936002)(33656002)(64756008)(4001150100001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Ex0d69VuudOEkvXtQn/RlKceFxzdi1G+kGe2geuzHYyLq0KJIsDoElFkJDbc?=
 =?us-ascii?Q?dVavH+B3rP/q8vv9TZ3e0LsgMpBxgGuT0f97wGVyxZR6X+TJDnkHerSLj2OZ?=
 =?us-ascii?Q?pjvWHoWuaHHSLhTFdlHngoUMNctwtj52962OWv7Rzb0pMMONFGhJJ5oSsyrq?=
 =?us-ascii?Q?JAOh7ZJcwmPN3E6aifXe+mMdOVxCRcPZnsbKCeCVcj5KlX+JIYGUYaLZSFXL?=
 =?us-ascii?Q?gr6jZb8ElASaUR/7ioI0wqplSdXR3en4l6wDrG+KmrSCG8mcJ0Hnu2iISY2x?=
 =?us-ascii?Q?e74EqXNnx/DA4GTGhxhVjojdiiVoOmbnOrV6If3RFBAPY/QTzF0hanBidXIn?=
 =?us-ascii?Q?pheM49xqKNje9IKQK/3ciSCcxQLYowpI+9kkNKnGphJRGpPQfdKD6pKuRwXU?=
 =?us-ascii?Q?EwimXtYgwiLQF7c+doePPKlyhZLKEw8Bi9qzwVJvLUjeofSyPxJh1I0bY1MU?=
 =?us-ascii?Q?JtPDPHaVkXCp2cTvjbfKvaNCkYzmPw2q6xz+2PVxdeJ+A3zO8IdsQIQx/J9c?=
 =?us-ascii?Q?N0jb/4zNT3O/eytDU8/wHdbf5DewiLIAHaTSXWdwP8AVYe7P0nTc6zKJbr7S?=
 =?us-ascii?Q?2gAA7YjqbHsQ/clEeqpvEkxlmRAK0I+QH8Ky2mO0iNxeBRKA+xrCaIkJ0FBC?=
 =?us-ascii?Q?lZxir3bK9kIdr1rDgBk0RYLxRjENo/5cH7rGJ7xQFsU46cSRz35mMPE56jmv?=
 =?us-ascii?Q?PL34nowXAdVpLfkouo0BfXPuVqc80Ddt61AwxS+tJwR6IpolpjjD457LGTII?=
 =?us-ascii?Q?t6HyCOTd+L37daw86E+JFSxfuUmh90U2TgpFKRE7EMtHO0kALGKgmqj1HTQ7?=
 =?us-ascii?Q?h19kHsU4C1EmcDP05eqLOz2g+yiUOzBJwUUvXMnvtuURnaOz43z3AosHVQam?=
 =?us-ascii?Q?85zNVMxc3bzXrpJ1/wovEF3iK7+xhZjIvniVhKNfj7M0B97R/qZOPJ6cdYrd?=
 =?us-ascii?Q?bRIk8tUVgblorj/SIxian6hPJbQHNGt/Kr32hFhHZYLVxiM9qDGrLGLl22zE?=
 =?us-ascii?Q?7x1guCxr38aKJ/oGdYgQKvIF+g=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D1C19806D5284040B40D13DE69B7F850@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a73cd2-bdd1-447c-aab2-08d8955bfb29
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 18:15:56.0769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5jCnA+yYlsLCqgJgiXuw7aR0vu2acBh0UkLn8MLqVhsLfs7Ey4fQVeEmGCP/DHKaq6YcARJ+3H6E8vZrnZBhcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_06:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 clxscore=1011 lowpriorityscore=0
 spamscore=0 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011300119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following changes for md-next on top of your=20
for-5.11/drivers branch.=20

Summary:=20
  1. Fix race condition in md_ioctl(), by Dae R. Jeong;
  2. Initialize read_slot properly for raid10, by Kevin Vigor;
  3. Code cleanup, by Pankaj Gupta;
  4. md-cluster resync/reshape fix, by Zhao Heming.=20

Thanks,
Song


The following changes since commit 4d063e646b4bfe8e74c0b4b78bf11c3a7b5d962a:

  s390/dasd: Process FCES path event notification (2020-11-16 08:14:38 -070=
0)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to bca5b0658020be90b6b504ca514fd80110204f71:

  md/cluster: fix deadlock when node is doing resync job (2020-11-30 10:12:=
35 -0800)

----------------------------------------------------------------
Dae R. Jeong (1):
      md: fix a warning caused by a race between concurrent md_ioctl()s

Kevin Vigor (1):
      md/raid10: initialize r10_bio->read_slot before use.

Pankaj Gupta (3):
      md: improve variable names in md_flush_request()
      md: add comments in md_flush_request()
      md: use current request time as base for ktime comparisons

Zhao Heming (2):
      md/cluster: block reshape with remote resync job
      md/cluster: fix deadlock when node is doing resync job

 drivers/md/md-cluster.c | 67 ++++++++++++++++++++++++++++++++++++++-------=
----------------------
 drivers/md/md.c         | 33 +++++++++++++++++++++++----------
 drivers/md/md.h         |  6 +++---
 drivers/md/raid10.c     |  3 ++-
 4 files changed, 66 insertions(+), 43 deletions(-)=

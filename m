Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45467C4361B
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 10:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1EC322240
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 10:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438702AbgLLKSs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Dec 2020 05:18:48 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19578 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438696AbgLLKSs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 12 Dec 2020 05:18:48 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BC99YjD011221;
        Sat, 12 Dec 2020 01:13:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=7tZ+j17kw9E9PJXfK5FEfD6VUD+r37r8Sro13YeZjN0=;
 b=KBEEZLp+D4IhgXOsWNy7zFJwkKvf4EmCnLc1Qkz/cR2Uzlr7RjSiiMvCUeDbCm/PzXlS
 /wB1V2Och/3ENE1MwpjXRLrL27DpH3dI2Hq8oygLAvedc/v0m+bpLhGh4XhmXz1jymh6
 2VZv/XvAfz5ROxjSDMcb8RvVqZpDr11dEr0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35csa5g9g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 12 Dec 2020 01:13:06 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 12 Dec 2020 01:12:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gaeMsVIdgnQF90PVrQkHcYerK2LO0QfiXxGkkRqbUMK4ADvzomSUCG5rwZTQz/FW/2bm2Uhu8eShGXUsXXtjK4TvRBCJzv3dsW1qx7eDIm4hi+cKra2xUBCStXJDS5xa5LcvQaMjF9rVc28YBZ48KeNjCdZgyFZKjJvUp6K9d0nhNmrNJDxN4EBLPqAA1qHexktW+6mAxNBudEgxYFY/GQDaCDCfvjGfmc8szjTXD15oaA/vrVzvCSrDeQloqcM6FP0hcQcu3r9YKO/hPcqd0jBMbnnsAKyw5GezJecpwW4Yk/NYSasbaqjGejfb/tPQIj52P0m0WCdwWga/wnEb9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtvtgwAsT9WCL+jOPLmw4xqCnF/E3jA50LBjRA7gQw4=;
 b=Exs2eKONOfk8ZzO5vuq5qAkQO7ntH1mSpuLV0UJtO0NK3QduplhEpz0wg7j69rqVbnUbpFWXPb2HoINeWfHXSizcypBZIFok5q4h79jxSkMmC4tbu4DHeHKn7WrXFbH5SvyR2qcnAbQQ+g+QfN0x+Rq+mTlxdj4pc1U9/+JtoFK3E3z+YgocOVcDPyz1zQ/9loNi9TSg3q8ezWd9CRkcHg45MpRh0Z7GvoPpVs7BJ4tB7gvPpl8w1iLaVZYeJIu2nlWU1Mv0hFRGfDlwCcQ5fvtBhwkca3E7vP7otgmqeV8ymV3UNZqbOoEywgzE1n0NQqmt7o1IpZVCbCIGpSZ4tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtvtgwAsT9WCL+jOPLmw4xqCnF/E3jA50LBjRA7gQw4=;
 b=QBP/RU810dlMS6iGhOQxmnZTMbHkKtMM1yGbnMRU8GxB4cNJy2vthEY2Fd8k/tm7OWXmDY2u6JfEFBrCNzSeJeG+BALF9DNzObpmEa1muN6ClvSmztIqFQOz3oxpMntCEwP8PmdWcue7i96rVF+1WywRGh666A4wG9GTq0LlJEY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2725.namprd15.prod.outlook.com (2603:10b6:a03:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Sat, 12 Dec
 2020 09:12:56 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.018; Sat, 12 Dec 2020
 09:12:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Mike Snitzer <snitzer@redhat.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: [GIT PULL v3] md-fixes 20201212
Thread-Topic: [GIT PULL v3] md-fixes 20201212
Thread-Index: AQHW0Gb6fv6Nq5LSg0WKqXCyeDFaNQ==
Date:   Sat, 12 Dec 2020 09:12:55 +0000
Message-ID: <D6749568-4ED2-49A7-B0D3-F0969B934BF6@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:e346]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3793f117-d334-49f6-fa8c-08d89e7e1cc1
x-ms-traffictypediagnostic: BYAPR15MB2725:
x-microsoft-antispam-prvs: <BYAPR15MB2725D2D5627EC2CCA4B736C3B3C90@BYAPR15MB2725.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: miXwKZHmDEF31JaUNxhTKw15HwjsqfdcoTOPGnUtyisyGSBsdBf6M7OqTgq9/KyfHuC6kNOQdQud/foQ8DjOC5dN2MHWtaE3EtBDwb2tZeklafyKsSfSm2/47vifDGlIVcA+jxbV+mCxstD78sKBUU6OtFcX8zee+G7F2ftgOkjd4zd1Hzi0v+EukXFB7zoVbAUmvIPLIgCXAc7mIz17rTvtry/3BLKrRyr8pbbJPt8rrqs0x35RLIOYVtTcoIkQ5F8i0Q0x6mWWRIF/3nNGmkVx2oZRyO4/Wm7Jhm6GnD3tMltdjcLs5SNYYMSiGR9/y8Uqfsmrcl7ZkTqltbj3yFAGOE43JTKc8ZF2m/DhFMkjse6StRA9Nk1GVdZIUKmxAGB++bTQZ7URo26bSzYHPrSMjB2dlTdXsQH5m2jJbI+YHr1EUbbOilnG60FdqFS+BtTYwQpvnJq6zkVaPGGSGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(4326008)(71200400001)(8936002)(83380400001)(33656002)(8676002)(6506007)(36756003)(86362001)(54906003)(4001150100001)(508600001)(64756008)(6512007)(66556008)(66446008)(966005)(2906002)(66476007)(6486002)(110136005)(76116006)(2616005)(5660300002)(66946007)(186003)(91956017)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xv+KL8huV89mXh8SI3VLBqbMcj3QHkvxpfKFp4TMcyx11oasHGqT+3JNw/l6?=
 =?us-ascii?Q?lK1qR0em2Z8SoiBjzdNCdCdRjg5bLfY8pydjroDU+uv9+FdtSBtHsrZkD13F?=
 =?us-ascii?Q?9kgEbyoJ7uJFPG6gXxKi/aZQk2i/9mTR8AVFvh+zY4GiA0+CWxD5MgaOiZwS?=
 =?us-ascii?Q?5jN9vcU2GjWFE1JGaIg+7KkBVuEIrwE5BroJuYYk4C4z4PfWvEh5FWHKCJSi?=
 =?us-ascii?Q?Ym+TjIRy0DffhgiNifdVix8wTlMr8dxt9f+QkfSu/Sh/L1cvJIehQOQgB3YY?=
 =?us-ascii?Q?6JOhgI64/DLscOkCuUTK21yXrtQCOZ/VGCmwIAyQ4obZbdJ3bByZ/P7PVMh/?=
 =?us-ascii?Q?hGav56PjGwStNZJvd3BKARmE64y3d/TcUoXujIm260CRbQVe4PN9qG0gJv+c?=
 =?us-ascii?Q?4iotxc7jam/IRAbrO/UMeNckXj6HgMFxiHq38KyLvmHq6rOFr2BevcoOJJIT?=
 =?us-ascii?Q?RiqeMMkBtXLsiLQXEWjkbxcA+8FAoi0qqbS5hUSL7cbxh7OIdklHaNHHOZCk?=
 =?us-ascii?Q?2MKxnKJI1+AIcI0yUn+Lkwl919ptxHLztik850wunjXSUmjx8sSXAZLZjbGM?=
 =?us-ascii?Q?d59xEU9o70XA8p2vP5EjsPNkcbANXY5HnE0g5G9Tv/Sv9Abdq1DR9a0OS/6D?=
 =?us-ascii?Q?Q79na8oHLLoqCzD1/1JTShTU6p1jf6r9cOzyCRN+wk/z3mZmQl/MKXuMpYnQ?=
 =?us-ascii?Q?mRnZkC3qXYK2OYzVysHWx0lGulrBzdqej9pOY5PIZGSZDcyw5mpFeKaJAYvs?=
 =?us-ascii?Q?pBMmht47csNr45DpiW7A7Fd+Fp4BLpHeMrjQ1Mhsspro5Uxz5MqZclJ/Crx8?=
 =?us-ascii?Q?FyVk7sAvIYpcIq/1tB0ovWOpa/fff3muJ/xQ5aBmdFyJtIpwP1KQhJrdYytX?=
 =?us-ascii?Q?b3IqmNFwQXCmhE393fSC4HfphzFzfkByIRTVE3qwf52cZdkGbHvniLx2C1O/?=
 =?us-ascii?Q?PSTTfYZstFfYUpUj4ZKiW5nfT6VDGgV9uenQKD/x+pUiacn4LS6AJgX/SG48?=
 =?us-ascii?Q?3XjJSIyYa4QoiLyV/SLnq4BgczMHJ1SMl6S7Fa3booNEBA8=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BA43570B37E504468CCA572C379B5B4F@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3793f117-d334-49f6-fa8c-08d89e7e1cc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2020 09:12:55.7248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fwF0EYsqQpX0Di3pu4snmPnzO5FJtCqoVfcNnJQq5foLL66IYXuQ3ag9RI6ruAKRFv2kEPnIybhA9Ao6PhlOMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-12_02:2020-12-11,2020-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012120070
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following changes on top of tag
block-5.10-2020-12-05. This is to fix raid10 data corruption [1] in 5.10-rc=
7.=20

Tests run on this change:=20

1. md raid10: tested discard on raid10 device works properly (zero mismatch=
_cnt).
2. dm raid10: tested discard_granularity and discard_max_bytes was set prop=
erly.=20

Thanks,
Song


[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/


The following changes since commit 7e7986f9d3ba69a7375a41080a1f8c8012cb0923:

  block: use gcd() to fix chunk_sectors limit stacking (2020-12-01 11:02:55=
 -0700)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fix=
es

for you to fetch changes up to 0d5c7b890229f8a9bb4b588b34ffe70c62691143:

  Revert "md: add md_submit_discard_bio() for submitting discard bio" (2020=
-12-12 00:51:41 -0800)

----------------------------------------------------------------
Song Liu (7):
      Revert "dm raid: remove unnecessary discard limits for raid10"
      Revert "dm raid: fix discard limits for raid1 and raid10"
      Revert "md/raid10: improve discard request for far layout"
      Revert "md/raid10: improve raid10 discard request"
      Revert "md/raid10: pull codes that wait for blocked dev into one func=
tion"
      Revert "md/raid10: extend r10bio devs to raid disks"
      Revert "md: add md_submit_discard_bio() for submitting discard bio"

 drivers/md/dm-raid.c |   9 +++++
 drivers/md/md.c      |  20 ----------
 drivers/md/md.h      |   2 -
 drivers/md/raid0.c   |  14 ++++++-
 drivers/md/raid10.c  | 423 +++++++++++++++++++++++++++++------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
------------
 drivers/md/raid10.h  |   1 -
 6 files changed, 78 insertions(+), 391 deletions(-)=

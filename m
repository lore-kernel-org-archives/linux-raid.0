Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AC0C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 14 Nov 2022 18:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236720AbiKNSWm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Nov 2022 13:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbiKNSWk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Nov 2022 13:22:40 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C35140A4
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 10:22:40 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.5) with ESMTP id 2AEH5IwD010740
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 10:22:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=AbRcgCUcmu1mJHXGQMC2/VQ7+N9Bs/hnJ8oju3SRo20=;
 b=UFDED0pTGXZWBs1eL/ygJHRPWaiiqDFnpEfJfqPlpiyhooXFSpxvpU9ohbOchhsaJdmD
 nqrnhpx3blTvVcec1rhweFsLT97A0RpDw3NLhtR2tSBLSH305Vn2BLhtBTWBJ7uBrcSe
 KsTWY0hb/Fyo0So6+X1f91pkKOM3O3nVOpeJLOnJObHROzJrfcvAmqJi26VWgf/UhbBJ
 UQJDhZ+QAzSowrvffj0zqXDuWBicvanJJxmGYJMPaGXQsXLe3fYKnhqA8pGOQeXw43Jj
 XZiQyPuhuNe18bGmWZfmEeIiKaHqnanWqZ00u3fORGsd5gfjQ0cvTun39DdxKhnEv0su sQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kurqv9gn5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 10:22:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4UsLUgoVsXO6Fds7d9hOcHh/iXVvLpJNT327BFeV3w7NBraAcBHAgXQRFv890a9uoeYG37pZWfqBy2Md2rlT8gaBloGkk/nvi/fpblnj4mfk3TXMjb82tRKtRbrdxaJWOT9i0OuvpkVbfWM1LieK7yQuL/OQzvumPxc1QvfumSJuH6f8qr8owJ62Y2jtHApwgap2ZDIX8o/DKVnHyMFIigppfU5+7wJ5v40Qo/jOvLnSOwTsqPiJ9Ac98UZ0aDDGmuDuXW1DCShvqqic0stt/G0LVVVFjmNBZCYOejOsZbTz7sgcIwoP5Fo0xngVw+IB2dHohXELblNTq7X4U0LLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbRcgCUcmu1mJHXGQMC2/VQ7+N9Bs/hnJ8oju3SRo20=;
 b=PtwT7rP2fezAAo16B/L79qVUbgNwUVeGaoD5RFP79TJLhWZZA5UgSeDFtP4+YgTU6ScN0YQ9FdZKsoTFGJGhflKxiIyk+bNuNQ4Y3Kg474nlr7KcE9YtHhE4lVdSWS+ZQUde7dj1VDIg3JAugD/MKa9cJeKuha1E1Z7zu/Htar71VW0j2LAFyIfakqwu9NKQHcuNMKndacgnuqWmHBizLl+DnPL3tm0ehooUwrRU7YKkVce4NrhD9fhnAOwFvXGecuUmyozUXzcx+afeW21/9jc975SMdCzO+ajx2uCGMEPXvv83uhMbL7ypcBM2aJHVO3R81YKC2h09Hs47v5pgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR1501MB2085.namprd15.prod.outlook.com (2603:10b6:4:a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 14 Nov
 2022 18:22:37 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3c4d:ca9e:8db4:f7b0]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3c4d:ca9e:8db4:f7b0%3]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 18:22:37 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jiang Li <jiang.li@ugreen.com>, Xiao Ni <xni@redhat.com>,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>, Ye Bin <yebin10@huawei.com>,
        Giulio Benetti <giulio.benetti@benettiengineering.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Li Zhong <floridsleeves@gmail.com>
Subject: [GIT PULL] md-next 20221114
Thread-Topic: [GIT PULL] md-next 20221114
Thread-Index: AQHY+FYSOb+zeaFMc0e4Y6c41g/taA==
Date:   Mon, 14 Nov 2022 18:22:37 +0000
Message-ID: <09491954-333F-400F-A277-A37BE9DC9F45@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DM5PR1501MB2085:EE_
x-ms-office365-filtering-correlation-id: 175cdafe-bbdd-48ae-8ea2-08dac66d3527
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YFLGa5xE2JdYFljv1XK0x+jXZRu/RmJ4fN/iZz2TgAzwoF8zEaNtx/3aZRz9UnyeZW+DRN+ltUywNFM7MIVf3TzfSHBiRXXiXtdw7a9wtGwy0+MBuVACsnAyQqAg28Da/mqaftIm3qefhhG3hhDhKJSKHiVHu9CvxqUCx8BO9GemfiF6/BdiwQl74bdGQoZUaMm7eJcTCKfduXXxOUTu4O1Fxy2+J4P6Iy4Z/6ZzgD5WPK2KNu68PhxW0dWbczNbl9AHlhI2kzqWBfeMWO/1BN2Z5yJDoWCciD89FWfp1Z26jt1dsZvBASD4dn1F7gACrmU6vBPP53J9fvWYGNJg2sOpGzhat+Sb27D3Ruj8W0u+qRSC+mynAtDaNOh0huPuldJh1nx61e/tA8fy87dIDh9OeIDYLFzogtkh2ovFMBILjw7JOnO688mX8OUwCiEWTe/FZn1SuxUjcebdIIlr0E9T4J7k4+4fglig0cLuszNRQ89UHadl+2gFUhYArNsOvwlFctp3RrcrRpM6gzFq7mHar1lSUYxGk/aQxSazU8rbRcZL8tcprDirVUkFphMbltEWUhxBOcCmJCcUaKb6oMLNYAOcZZ2xfcvVpVn8YJGYf6kXHDRH3fkfSwNdZzn1lRzBeunXfRW3KbQYYXSGBeXN6FgG/WbIU2E+Kxgx1lLKLyHxq9RRgylpHgno146drNkwWZXq/1OTEbst2bJdLS1MIMm2fnbR8MbsfX42MXrCgZilhG3CPnRj05KXpJUlLnAJ8LLgaVs2NTVy0mlC4dCJnPrRXwBiY4Wyg+HW0FI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(9686003)(36756003)(6512007)(6506007)(186003)(8676002)(110136005)(38100700002)(76116006)(122000001)(4001150100001)(316002)(66476007)(66556008)(33656002)(91956017)(41300700001)(54906003)(38070700005)(66446008)(66946007)(64756008)(4326008)(478600001)(7416002)(86362001)(8936002)(966005)(6486002)(2906002)(5660300002)(71200400001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AiWOOpg3MzjHtjPuDnXv7MoJmMU/2i0fg8aamVNTl0jkaYXWqTAbqNbDGTeC?=
 =?us-ascii?Q?O+X9Opc7/eesLa7TVrq6HdKeYO7wRjb09ZDlhFXESh4R6uP2HAvboxFxBUaW?=
 =?us-ascii?Q?YKzczMmlpC6f1Y2BN6brbkC65rVY+CkpKGGAGSe3H7LTcYmKO0mesqpQPwH9?=
 =?us-ascii?Q?xuwmchhe+VPLwyoLJhu9xsvewWUeqH3Nu1vHYqAdzw1h0sUycDqjG3JBOPHf?=
 =?us-ascii?Q?Dk/LCw7u3TAJnonFnUpbntCiIuG8Q5l+A++rILsEGWUZpA2XkiL/26b6FNPQ?=
 =?us-ascii?Q?nY9z+Nx2SBvm3IqJMiwFZh9Wou/0HZPjv2WUmUfmXTGOpKsEQpw6pIEZQGj8?=
 =?us-ascii?Q?ijL1OZwuUvCOkFqrE/Kb2e0Q4FlZ/4GIY6y5sNciSODAgHYnFh8hxEvEsMcH?=
 =?us-ascii?Q?6Tt737HZ/NX6KTC7IaxBADBNWH8alCj7loMV7AZYvrESj94idtdBClTDYSrh?=
 =?us-ascii?Q?WgVWb1f+zeGhJhEZGFz19a3woUIAuJcinP8ZRWjOjPDD1LjAnAnTs/nVvmj0?=
 =?us-ascii?Q?nwwrnML9UK0L5SidjFNs00N9tqra/i4DmkHnR3UbDXfB9ALAGsuRdnCV1BIy?=
 =?us-ascii?Q?Jv8ZT4YwKr2lTm0XxyFTuyOlXbt7b97qf2Stlb/761TPVipresu5cCuduRzc?=
 =?us-ascii?Q?ZOeThbDxYjcFzmyx+oqyiubpyN06QTLXothpHfscdoxOTzwUxuevBM4J0Ae9?=
 =?us-ascii?Q?UfqePPbSDmTne6zSDyXrE+rJDQ6a0PLTJKwmMs3GQ50LnVFDqlWvFPP936rm?=
 =?us-ascii?Q?mqmjpEt1HxvS9IkwiJWmevtkFiO2lEnwZgyI9HLe0pS/QBNF3tpoQ7ai0CkK?=
 =?us-ascii?Q?xoDQnrlE2UvDKMx8ii6QIMfDCOxuqAjBaswF9uHmIQSG+B8ytchfqtQyDtNh?=
 =?us-ascii?Q?aH/VB30i49yuC47Q+tBvpmS1hflFOWbqchLryx42hnHfTaOOZFowaJZgwhRx?=
 =?us-ascii?Q?29TrXswoT44lpIAUiSkigz8YSxsAoiQDVCeYsy61wDNLsD4hOCRPM9HcboLs?=
 =?us-ascii?Q?Ya7hRneaagNDJQl8fmsHOmRmjIbt0JcHr7dvm5qCwhKP3kwOM0ufi3b2Hp6R?=
 =?us-ascii?Q?zYJHg78FWDfcn061uYVkj3A9jIbXVZGF//1KzVrjyOaWt/ejoHFBIf4drKB1?=
 =?us-ascii?Q?SUpc5ensiDnA2kWh+yZ/slNdtUkAS9bIFX7yf5emgBpFVhR3QzpYzZEOu8/L?=
 =?us-ascii?Q?PTJ0edfqJRRRwbTQ5TkMmLLplpucGuoRe6syZ2WK4/uQxw0nUgCQkmjlYk3y?=
 =?us-ascii?Q?jIWtI9pHHfnzYK+9mHIzs2EMiPI6Q8CUS6axGvK35vxL+2dU/4pIWpbKGzbN?=
 =?us-ascii?Q?5vTdvM27PTghG9ly1e9gYaMnzKyQv07spZmJEWaGoW7AAQRPj5tmYYNOoZ4G?=
 =?us-ascii?Q?pX0BKtVHVAzkTMuOj0guB0y1uhpb9hUm764nIt9g0IhLdcbJcqD+04xDMJPu?=
 =?us-ascii?Q?kXyGuzWdj16BLgZAf9x4UW+6pLUEvdmkj9oVtk1ouiU7JVegzjhxFVzQtq+s?=
 =?us-ascii?Q?Lc7sZNxTL/nXcb5/3dVFLOUGt04ChpL0xLRGDbsvlZ/nGpPsTiqJCE80g+pM?=
 =?us-ascii?Q?iBcb4YXynMMO9wt2BfIsZOhgiYB71c87LEBexIQ4G/WOtkNPa3E+kz4fNUge?=
 =?us-ascii?Q?7KGWM1yFBVfE6L1BKdC6M0o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3533DB12A8495242AF57F1020EE0B64E@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 175cdafe-bbdd-48ae-8ea2-08dac66d3527
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 18:22:37.1397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: havg6VyyTSaCuFLwaCHTGVUtueRSYqdBy8Ni3JSZmHnK2k1LCF6QFpcp6uPl2V2G2nXkOYkMfSdqNo5/OEVmTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2085
X-Proofpoint-ORIG-GUID: Cy9YYYxBBo3hLZen8slPIqS3YVekHhi4
X-Proofpoint-GUID: Cy9YYYxBBo3hLZen8slPIqS3YVekHhi4
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_13,2022-11-11_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your 
for-6.2/block branch. 

These changes are fixes for corner cases and code refactoring. 

Thanks,
Song 



The following changes since commit 4f8126bb2308066b877859e4b5923ffb54143630:

  sbitmap: Use single per-bitmap counting to wake up queued tags (2022-11-11 08:38:29 -0700)

are available in the Git repository at:

   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to b611ad14006e5be2170d9e8e611bf49dff288911:

  md/raid1: stop mdx_raid1 thread when raid1 array run failed (2022-11-14 10:15:35 -0800)

----------------------------------------------------------------
Christoph Hellwig (1):
      md/raid5: use bdev_write_cache instead of open coding it

Florian-Ewald Mueller (1):
      md/bitmap: Fix bitmap chunk size overflow issues

Giulio Benetti (1):
      lib/raid6: drop RAID6_USE_EMPTY_ZERO_PAGE

Jiang Li (1):
      md/raid1: stop mdx_raid1 thread when raid1 array run failed

Li Zhong (1):
      drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()

Mikulas Patocka (1):
      md: fix a crash in mempool_free

Uros Bizjak (1):
      raid5-cache: use try_cmpxchg in r5l_wake_reclaim

Xiao Ni (1):
      md/raid0, raid10: Don't set discard sectors for request queue

Ye Bin (2):
      md: factor out __md_set_array_info()
      md: introduce md_ro_state

 drivers/md/md-bitmap.c   |  47 +++++++++++++++++++--------------
 drivers/md/md.c          | 226 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------
 drivers/md/raid0.c       |   1 -
 drivers/md/raid1.c       |   1 +
 drivers/md/raid10.c      |   2 --
 drivers/md/raid5-cache.c |  10 +++----
 drivers/md/raid5-ppl.c   |   5 +---
 include/linux/raid/pq.h  |   8 ------
 lib/raid6/algos.c        |   2 --
 9 files changed, 156 insertions(+), 146 deletions(-)


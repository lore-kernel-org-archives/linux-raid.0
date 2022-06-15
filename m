Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B6EC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 15 Jun 2022 17:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357676AbiFORsU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Jun 2022 13:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349899AbiFORsS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Jun 2022 13:48:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1658E46CB0
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 10:48:18 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FHGSx6016718
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 10:48:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=g5jevHXScTQhk9RuIBlQYmSVbP/zw9FxmN7oA8K5Fs8=;
 b=p1mwbwJZ//HigiptO9JBY87F90wsnIdlTT96MNtyN6slWRQ60lN5w2kLtZD57PUK3KW1
 7dx8T36RfTJbsY+rs/TGysjKH5G8j3S5qsPmjiFuwcJ/4TJF8stSzmr8iYawkACOnOBV
 Vrsrb78qYhoAbeg5AUc5QLgaymAwrmROxno= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gpuwy8us7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 10:48:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFnxre/AbFtVx8bwTt03N2kmUyy3LBvsnc2inAXC6sZwEAcLnDpALjZPQVfYEd6lByQ/1j1IkrLgkt39k2OZ/WxU1bAxD2jz14EYJx/GuNEjAvx2kY5yfks6BMEhYk0r+DEPszk8oQX3aoUXmwHCYIJ6SBDWHX7VOs8+/PwoJd6wSpsPmv7c5e/rvTJpwZspHCd3XcllGR31JBaP/GS82UBpykF7i99dMMQMUBIgopEweXwloDB4LyNKAlk3Riq4VPfO9c8zfrjGOGNTStlYXiTbYseZZ20k1YS1ktO0BAi1V4Wntw0qLiXtSbNa+yeXbqoTI403fh45DUyYlwAbNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5jevHXScTQhk9RuIBlQYmSVbP/zw9FxmN7oA8K5Fs8=;
 b=StGLZyTPobLTQMFtLR/b0qLUWLt91euQ+Y+PudDPPvI8DL0UC/Gc+AtPkNtVv+G2OkZ4+EQztUEl8J3N1WPDBwQKQRcK9y7Ehtrjvmx+zpJYNAGuLvTkLNyu1f6gbEbrXT9mu04SpjOAh1G8NyAnOfMSjOTt8IsciPHGw3gQinKaU2r8K8nufNxZooLYtTUeeXgvcurCuILtrv1W82iTPmNmh8FbYoTNn+8Xk5kQnfYsPgU+ToRDOxq+q9+G+/dyC/Y3+w5QBPmX/pfiVSFrvHp/YSPXUWuaY3n+Qtgv+rDQypTUWFuyuGBFM9mhnCWfeMr48wiIDan0rD2gKisvIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CO6PR15MB4180.namprd15.prod.outlook.com (2603:10b6:5:34a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 15 Jun
 2022 17:48:12 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::b9ad:f353:17ee:7be3]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::b9ad:f353:17ee:7be3%6]) with mapi id 15.20.5332.023; Wed, 15 Jun 2022
 17:48:12 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Guoqing Jiang <jgq516@gmail.com>,
        Logan Gunthorpe <logang@deltatee.com>
Subject: [GIT PULL] md-fixes 20220615
Thread-Topic: [GIT PULL] md-fixes 20220615
Thread-Index: AQHYgOAV+QxPoC2VoEOkP5LdSg38pw==
Date:   Wed, 15 Jun 2022 17:48:12 +0000
Message-ID: <91D222B9-E849-4518-86FA-5D7D3A3DA773@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 838567ff-76ba-4bf8-c0c3-08da4ef7378b
x-ms-traffictypediagnostic: CO6PR15MB4180:EE_
x-microsoft-antispam-prvs: <CO6PR15MB4180EBDBC79FEA3E43372E6EB3AD9@CO6PR15MB4180.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z5MsJS1DBTTeE6lFDUuMUCgU1Ez1mwbRS12TUdgGzNsGmmBwhxwv06y4wPdl28+fEUdM1Pidi42NGsbKLoSW6/L8eXmgR4su7lIvPbEBBJlRMj+LOh5a8LJmUlLcxUCbuctA43q8J6JDk7kIj327rDxhWU8KGh5bvr4LmHa4XBF1bwKbDONP4MkLLLEy8hsIhKk7oPtz1ITRFta8Ix+VNoAQafwMmHgpBHaym752x7okEnhB9/eX4MNn8cv38xOG2RN7lMjpshhiBhHSoqpp8nwga/yOOb6H8yAR6hN7UolJwIEBasncpBHcUE/PccFGeS+9A1YckX/f2J9VlcYdWlew7nddqHKmqFYuoGs1/UsttlGPyubfv09Oj3I7DAOK2ia6Vjo7zlqYFNin//IRga8K4wTo9px0ytpOjT3tJ29N5LBbKuB5CemXsVg1yLjjMJFLFzl1kDyiMAgo1+4eRycTm82tjLAEGmtnJ9B1s5tb41hOE1njh96QTh6XKvxDWpeeFeZuqohiMxzszYTBupKdWR596My/lF9dVm7ETy7oDoJqoydjrRheAv06Kj2lhyS92rIz2UtqGw6/jSYEdFFW2VB/xrCPPtmt0eJoaLDb2iIWxxGsqni9OkUFPkiRMH+TGk1kowZhQQyKRXJDbD9XZd8k101D0dBh3EepPa6YFs5xjNFzMsC2vWgS1PFMxu2ZBcds9ppr5DSFyeAWhtWdMyKwPf1fCdeaOlLhnH5Mx+4Xbe2NscoNtQ6jzFedaGilm8vaNa9SVUZxN+e7s54N4Q2R+lmbGe9KgErDNe7DVTyGPyV2C5FhzElu6jPt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(186003)(38100700002)(4326008)(86362001)(2616005)(76116006)(66476007)(66946007)(6506007)(64756008)(66556008)(66446008)(36756003)(38070700005)(316002)(110136005)(54906003)(8676002)(71200400001)(91956017)(8936002)(5660300002)(508600001)(6486002)(966005)(33656002)(6512007)(122000001)(83380400001)(4744005)(2906002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Gdy59sVvOyTeTrY/LG9xGU6s7WTDA2GAefU1JMN/S8VvH5hQxXGPcwEP4GfV?=
 =?us-ascii?Q?qrI4B96gN3fq66qtzQ3bvhGlNj7rXkM6lLBPC8qEpbqbxPFhZyFNSxxBVjoX?=
 =?us-ascii?Q?szxmKDievwcxiwiuHZIcj1XnJOrOtT+x+rtGSV8PJc+W9LGQalJ8lds1VMcn?=
 =?us-ascii?Q?bB+1PDyaa+hcDgUq8JhR9onp645kqory6r8A2tWyW+g1SDyQA+AqBLO1Cd/U?=
 =?us-ascii?Q?RChTJ8F+3lOyMsYvTfif36tGvsjJHYdadDZteU4JCjy3+wGrz5zoboS5Mdu7?=
 =?us-ascii?Q?/OMLrbQh/ZSpNht/8ACenzaNyNiZxX8gDL3pGLi2nBrdV3b+VFmB7RhW69L5?=
 =?us-ascii?Q?9911WBbpP4jX13zHKH2bT129Rcte9nvsxOElCLfUBKVnAhzm3h7e+ArN7mtv?=
 =?us-ascii?Q?l8bBtiVdwu0rtcRPnEJ6kvG09EEI8MHfWa9OMcd1dhf8TPOYe8IYckWQZCtZ?=
 =?us-ascii?Q?50WjrJmCRmbPV6qsgZwEKShoIy1wMD+jKVJ13SbfOZcRUoqchXVtZ75ZiL8I?=
 =?us-ascii?Q?GahVE8bIN1YYV3ELNWvOZNsURY0BqWc6mJtHZ9gfIjRiCqAkVKP3jSi35wIL?=
 =?us-ascii?Q?lIu0zWf6h8m04bf4g9nXchH5vGxkkKU6CKxcJFh9KIgYZJzAoTrdtCrDx5L9?=
 =?us-ascii?Q?pBQAlKTIRcrtwG3KS0TEIuPY2XvHgYXJqVBwpNDkoCnHApEW9NZpP9m4BWcV?=
 =?us-ascii?Q?tU2kb2ybfQ2W/VI8TuIxjUwN5dEOCKiyU9spv+baO554G4oWLHp7LnIfiPab?=
 =?us-ascii?Q?vbEN7nxOdvPJ4iLF/44id8HCU72dBp6YzpJnX8MMYrsqzaDL1KLD1uBIyaFs?=
 =?us-ascii?Q?O6W51W1Y72zgl8lYoh0/aqcmvTK4ucEQD8e2SNFpgy3cTX+E3Qrodp6JGQEj?=
 =?us-ascii?Q?4sfQoXt0gHVpuIG1B+kKVH2oiVwYjubOrlT3XH+hTJ8pFFEDGa3sKliEjSwi?=
 =?us-ascii?Q?7s2R/KhEOH5LXFRNKq1oTSr2UPsjqUYN9dSm51JzHYsAgf8TwuDfiJoLSyiv?=
 =?us-ascii?Q?gKgEvDapWLdSHRJOFLGUDSZSvzgVmyX51VmQBu4zRKwv4hwn91TVxHtCTQnV?=
 =?us-ascii?Q?NSXuqbKgxpHFI5dfCBvUmSOKaHHwK8A1OxvE9Ilt7nxPUUmu/+kZbrCehLwR?=
 =?us-ascii?Q?DMbz4wQfe58YL/lbZmOXStpmuPZVYv6+7cJErpNu4xYHIHLrbm2KmsIpEJLG?=
 =?us-ascii?Q?XKiDlbXjtiWBJn2/w/wyxDeVwT9kDZ8gO19mT6/gt66HIgl+6q3dxrkrqe8L?=
 =?us-ascii?Q?YqopnPAG7kltacBAmfZ5T79kBp1ISyXs2jyubSVA9rw6Nw2ifkQ+JYrBxS1L?=
 =?us-ascii?Q?xJV2IQ3oJnbw6aAhv3er7qq7VjsLM/H82hMhf53tb9ss3ZSzXWKIB6N0C11A?=
 =?us-ascii?Q?n5ZsYEdnVaphzFtt0DBQSh3q8XTX6qJ3ryTkMMGoWa3p0FTNrIy3w9YN38OR?=
 =?us-ascii?Q?+NRUK/LEaXJu9dFwuvei3wigYRpAkBGs/Gfz2a3xVl2nRe0bsuROa49DAPYd?=
 =?us-ascii?Q?BM5DwYQ5WUTm+Igi/KUFZArSKx5dZ2Y03sIvbEGtF4OrslrG8jLmhZJdGvSq?=
 =?us-ascii?Q?AS57d+bcfMBEkb7v/AZlHWdfgw35msgtf+vZd6hnbhfIpTykjcBxIsl4tENZ?=
 =?us-ascii?Q?enA6Qn2CMoUPRF71Qyp/8n8sk4C2FkO4jeUYiWmuGWUpaqU+4yI90jlOJHFb?=
 =?us-ascii?Q?2vDli4ijGthqP9hc4sCVZ4jLFCfDdVYFUlVTEQDT08kwIgaQe6cqP4/9duKe?=
 =?us-ascii?Q?1hvpJVyRhVKYytzpTThpfK8SWRdLrXwltiqy3GVfpPgaf2TGDgWt?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E5681FBEB755F349A8043D681EDF0406@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838567ff-76ba-4bf8-c0c3-08da4ef7378b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 17:48:12.1515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X90LDJdX4zYRGKPPpZmIeVOBLoqOGfo/DfcmqLLl3zQbHfLR7E6xX6EqoHgVbAHfDfaPfh4GGc6DwaGJHFAxPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4180
X-Proofpoint-ORIG-GUID: odb7tslWMiZ2xOnt94mCDrHKV9WktrTh
X-Proofpoint-GUID: odb7tslWMiZ2xOnt94mCDrHKV9WktrTh
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_14,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following fixes on top of your block-5.19 branch.

Thanks,
Song


The following changes since commit 2396e958c816960d445ecbbadd064abc929402d3:

  Merge tag 'nvme-5.19-2022-06-15' of git://git.infradead.org/nvme into block-5.19 (2022-06-15 09:39:05 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to f34fdcd4a0e7a0b92340ad7e48e7bcff9393fab5:

  md/raid5-ppl: Fix argument order in bio_alloc_bioset() (2022-06-15 10:32:48 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      Revert "md: don't unregister sync_thread with reconfig_mutex held"

Logan Gunthorpe (1):
      md/raid5-ppl: Fix argument order in bio_alloc_bioset()

 drivers/md/dm-raid.c   |  2 +-
 drivers/md/md.c        | 14 +++++---------
 drivers/md/md.h        |  2 +-
 drivers/md/raid5-ppl.c |  4 ++--
 4 files changed, 9 insertions(+), 13 deletions(-)

Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B20AC04A94
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 10:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbjHNKqB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 06:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbjHNKpv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 06:45:51 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC2712D
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 03:45:50 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37E8F90E012607
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 03:45:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=W3uSyAe/MF6sD+o4CcMiCLow79qy9sDyF+NC4OXQo1g=;
 b=ImjDD8t0AqKt/MbwEChhEOqyMdv27iz2D9TGRtgeSfXHW8XmcwORQmiPp/UBJa6wzjUr
 bjXPcqDcWeAQzC0gOyhRD9LSh3aX5db6B0Byro2KKr29GwWFMiCsUnDoGHAWsBgmeiU8
 JJe1pmlls7Dy9DKZJo9NsQqrCS286FRPVe278K0zZbV5en4ptGopmvktBFAHVW3ppacz
 umY60SzIdXKg1s5YxMv2MVGykQGNi53hC4TvfI0UPM3Rk9owfnJ5sdy05czwS8WjxLCy
 gn1hm1Cx1PtVU5ygCv3sn9sT9PnW7g1HyDUg+BQHnDi7RZC28RKYaY+YHijhHLjBSsif Qw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3se7wx5tu6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 03:45:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FypG1l0wNsxiNATqZihYnvHMcyqXlZD9/jrhDlGqztirMqIIffSvLmScMFBGxa+kDLkNUZ3QTdsa882cDcXmg6QHCTrc6YiR/ZqomGjl8QsuD3VI1DIdgOTEeTNmsgID5SCXV1cMCyD8b85gygm6Ilf5TcPTMuBqYTbCjBnqwyRa8ALxBYPMJ4KmexQXKg6yUPDA7chHudOjI2y6KydAEvTDX63zKqEZDzwE8L8tDI3Gtlt3vGuLGQ3SFtBYCFcbOx8QDtvp1++y/lwLxLJIjk4q+dd0mmnTXb3QN2jiyr17NIx7omsxgilKv272HT0Qp8WIJpmUNnH+5MvAMiK75w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3uSyAe/MF6sD+o4CcMiCLow79qy9sDyF+NC4OXQo1g=;
 b=jjiRYOrk7jCAJPHxJlkOTONQkL8WbDtqOqLrYJTIiHBYZAm3Z2TYBijXvsY7ndHgRUn/xqT5WVoYv+OQFSXuHy+mWc+mojNshWw4oFgMpxSqP+dRVjs2MCokzR5VXdKfDXJCjY8L594Y28HCZsUbAAztlXIDcIbD3k4HDcObZo2kQZYeRUC5GyuGRNntnmYlAFHKYObafODVbU3DF5tmoaNIU5D/nQf4mt2k1nDOi2JovGGRNZoDka1Gb5Ud6ipUIF5b3E1A4izRDTTHxMhLiAlu9UA5cmJs5M6iiyz22PVqkXZC4SF2YNWDMR1U9kLrJ51YIbOdHEIlRQcHu/C32g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB6376.namprd15.prod.outlook.com (2603:10b6:806:3a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Mon, 14 Aug
 2023 10:45:46 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::57f2:86c6:1115:ad7d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::57f2:86c6:1115:ad7d%6]) with mapi id 15.20.6678.022; Mon, 14 Aug 2023
 10:45:46 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Yu Kuai <yukuai3@huawei.com>, WANG Xuerui <git@xen0n.name>,
        Li Lingfeng <lilingfeng3@huawei.com>,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [GIT PULL] md-next 2023-08-14
Thread-Topic: [GIT PULL] md-next 2023-08-14
Thread-Index: AQHZzpx7dbV0tDERZU6bCz6zS8PLXQ==
Date:   Mon, 14 Aug 2023 10:45:46 +0000
Message-ID: <C2AF38F3-4BFF-4AD7-B575-C94A8C86A3EE@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB6376:EE_
x-ms-office365-filtering-correlation-id: a437e36b-3992-4248-48bd-08db9cb39de4
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fCeXoGTudAOslEmyVlf3u9Vph+AqQ0K0paRe6KaW8ayaxam9aDy1ryD8HkGumxhvBnzotWo+gaql0r7sfy4+21juvAwG2zASEjbQTvFPUIuajkS2UC39RUDoi7E0xEv6xbBWWiLxQfX5Ac9TiXs1zQYxJEYQBTlTB7qSz6cGGOTE+02UXBFWHX0JWydXcFbtUXwZ1HIT20fiAref6xfuSKcjgdocJSPyFPcZ2F+N+032QN0P+VFLNBRhCN3AzOzwEfrM6/lglKVK/CW9GLCYzhUjdvx50bwXOrkkhOc06Kp9/FHY44Ydagqt69YsB1kJXOF2PPdqRYDzmHIYMGMA+/vVQ/sSnDOPEgH3Z3aMwxt7BqTTuRZH/KfoD2PZAlSa4bn3TBXmr4b0vI7QPlfird5mfUJTtjkfEfD0cWesL5wgIA9VJ7KvDynzucaRLxI2FnDCWJ4hIM9/YqEYenb5I8zGk+rQxqEGSWKjG2NBalDrN26v+5tsUz1Kx5rxcoMEPrD+HRQBcShNkCS++pb1zr2b2LzIxB7n7yjbGYaGl0amTg2kIrxKpPCKL7uUzjaRSSL/3ohUWtmt+VkMAzkV+W5ENLhfRN7TOjisiPVQlno=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199021)(1800799006)(186006)(38100700002)(54906003)(110136005)(6486002)(71200400001)(478600001)(122000001)(38070700005)(5660300002)(2906002)(36756003)(33656002)(86362001)(4326008)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(91956017)(41300700001)(8936002)(8676002)(316002)(6506007)(26005)(83380400001)(9686003)(6512007)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4PYnEzPcpaaKSeHuVufpmOTS5YP0yemQmH0yC1AkOL86zwYwVEcnq0gaq/U+?=
 =?us-ascii?Q?ZbNDYXdoyvE6lKWzN6wVO/w5IKv2AyTFln0LT4ZyZ7P/QMF6CckxVcFHCsns?=
 =?us-ascii?Q?+rnkl2tTddcD1/expxeXhrzEU4X15K+ej5mmw8EMJ6VUxfhsWmNUIdlME6Hj?=
 =?us-ascii?Q?s/F9IwJD7b43yU8k773XsWYyb5Z/DKT/T8dVFz60OiwQ1yiR0liURI51wlr3?=
 =?us-ascii?Q?9Q1QlKiotBD/SN9Tq5J6eGNzm+47jm3jZIxwDL1qcq/kDofE3bL6MpcGYVH6?=
 =?us-ascii?Q?a2k9PkNJ6IHcFnfi9yFJftDk3nFNwazGPv2wQQfWC57xgKSYLQ2VLbY3Yfhm?=
 =?us-ascii?Q?0g1LQGQQ3+c99xrHUJBvlrugjZBcP5G1Je8db0OlEKg2P9YUtG2Nwsv5huy2?=
 =?us-ascii?Q?PobIFRbgIbJi77J/f215TctgD2eYWBawObkH+NreIII6r/ozN8fDfBljqZlk?=
 =?us-ascii?Q?/Y7lf7uUv7JxLmgLuyCa3EOEKm9AsRMytNIuIOWMIVxO+OHc3IrQ8SEHsClF?=
 =?us-ascii?Q?mlYkc4/s/G7tVLswPcrWkTeuK+iYw51yrmF5g46oXjRBOkBVSr1UDpDPejS8?=
 =?us-ascii?Q?xgUI2qO1LWqcOHqjbJ+Mb5oa2gnGSqvaYOOLzmrAIVG/1dqbJ6gUe89lEjmt?=
 =?us-ascii?Q?vCD1igbQH8skJc2CbcuGkzLjelAMp4bZi6yx52+wEix3b9tV4nzVw+uluvZI?=
 =?us-ascii?Q?VJBdqEGKY2etmTRNmWmoUfh+/NkjR8psY7u2Z+njY8x9npVmK+FeBsRAXPW6?=
 =?us-ascii?Q?2AHyIZ4zQHuT7hxHBBwZG7srGwi+d/1FjAe6agMCt6Bcbqq6gbIWhzkSDfKs?=
 =?us-ascii?Q?CYxIYpQTFwRJJ8OXdtuNXsExax/o23dvyuML+mY70j160mo7UUk5j+Ukywrm?=
 =?us-ascii?Q?RZTrwS97GQLMQzwt8xeL8b+iGZrBvjrWoUfMwQ6GVOUUp1VLAPDCqvp7pWGk?=
 =?us-ascii?Q?iJpoMSa8nq7qYccHXDTadnQXvNkbVHxGg/7J3Crd2COtRWztu6jixnseT3NJ?=
 =?us-ascii?Q?JqF2d3UZqcOcqRovAo4I9BTo15FVgmnu8FbLPi4EHVNuRurSxhc5WIzzoNU0?=
 =?us-ascii?Q?F8FMlMmnUENHor8AMHwPlo7weFBc07nDuV9lIOvSEvDeNAJq2Z+RKIIyjMGe?=
 =?us-ascii?Q?ICIndz9/Ndp6q+T6bVv7iV5DgPGXDocZJUyf3xH3QOs4+n9o5LQ8R6pHBHQ5?=
 =?us-ascii?Q?bBD0fulWo9aOF4Z15MgaRIFaL2MltQafwW9BwjUULdVfM37aQ5zwAagbaxXP?=
 =?us-ascii?Q?i1WsA34pjL/CNBNXZD/vjXhRBN1vG4pJiyfPu9RZKVY9TsqjZAU/G+UBFIXe?=
 =?us-ascii?Q?NreaOfnpyltBNjjy6WJyXjrnR4h4hmznLa03yD2ziSUJKM/Yi7bktFrR6mcL?=
 =?us-ascii?Q?48c+KE2c+sy12ZS4GsrLP47dv/dk/bGI8Li111eCdYs+ajCJW6Fa/kkuDBXe?=
 =?us-ascii?Q?ybAatefbjzfVed5Z+xvmJ/qy5hRXy6ov5etpKtjAp7NeXVwkKmStqYPyKM/o?=
 =?us-ascii?Q?kIH2BawbSCHgAYKExtg7vya+vtgMF/FWQPG4cHVwBBWaZRMM9dB377cOO1Ew?=
 =?us-ascii?Q?BbfldzPC0MF6ZScNcENzKnGpTxAiJQ+7gj9jhqDKEIIuMDQBAHf/5cGeG3x4?=
 =?us-ascii?Q?Zg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E9E33A864CD134EB83CD461EC0F7EEA@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a437e36b-3992-4248-48bd-08db9cb39de4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2023 10:45:46.4761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9gYt09gaUZfDlFWBPfW1j7DPHBXFgV0iI6o/sPG2RgWdj507QX0WLZWp6RYh5JXxiihuo3xGGxmcFo+b5iP8NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB6376
X-Proofpoint-GUID: k9NGXhsrKjVGK6f1clJ_evpNsz1XKTRs
X-Proofpoint-ORIG-GUID: k9NGXhsrKjVGK6f1clJ_evpNsz1XKTRs
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-14_06,2023-08-10_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.6/block branch. The major changes are:

1. raid6test build fixes, by WANG Xuerui;
2. Various non-urgent fixes. 

Thanks,
Song
 


The following changes since commit e24721e441a7c640e4e7b2b63c23c06d9a750880:

  ublk: fix 'warn: variable dereferenced before check 'req'' from Smatch (2023-08-11 08:13:23 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20230814

for you to fetch changes up to 733fd910ffa5cdc26776c98cc4612b0ce3e2bbfd:

  md/raid5-cache: fix null-ptr-deref for r5l_flush_stripe_to_raid() (2023-08-13 11:03:26 -0700)

----------------------------------------------------------------
Li Lingfeng (1):
      md: Hold mddev->reconfig_mutex when trying to get mddev->sync_thread

WANG Xuerui (5):
      raid6: remove the <linux/export.h> include from recov.c
      raid6: guard the tables.c include of <linux/export.h> with __KERNEL__
      raid6: test: cosmetic cleanups for the test Makefile
      raid6: test: make sure all intermediate and artifact files are .gitignored
      raid6: test: only check for Altivec if building on powerpc hosts

Yu Kuai (3):
      md/raid5-cache: fix a deadlock in r5l_exit_log()
      md/raid10: fix a 'conf->barrier' leakage in raid10_takeover()
      md/raid5-cache: fix null-ptr-deref for r5l_flush_stripe_to_raid()

Zhang Shurong (1):
      md: raid1: fix potential OOB in raid1_remove_disk()

 drivers/md/md-cluster.c   |  8 ++++----
 drivers/md/md.c           |  9 +++++----
 drivers/md/md.h           |  2 +-
 drivers/md/raid1.c        |  8 ++++++--
 drivers/md/raid10.c       |  3 +--
 drivers/md/raid5-cache.c  | 14 ++++++++------
 drivers/md/raid5.c        |  2 +-
 lib/raid6/mktables.c      |  2 ++
 lib/raid6/recov.c         |  1 -
 lib/raid6/test/.gitignore |  3 +++
 lib/raid6/test/Makefile   | 50 ++++++++++++++++++++++++++------------------------
 11 files changed, 57 insertions(+), 45 deletions(-)
 create mode 100644 lib/raid6/test/.gitignore


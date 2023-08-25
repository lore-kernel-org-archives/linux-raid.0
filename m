Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F47EE49A0
	for <linux-raid@archiver.kernel.org>; Fri, 25 Aug 2023 21:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjHYVRr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Aug 2023 17:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjHYVRg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Aug 2023 17:17:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E6CE7A
        for <linux-raid@vger.kernel.org>; Fri, 25 Aug 2023 14:17:34 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37PKKU8F031360
        for <linux-raid@vger.kernel.org>; Fri, 25 Aug 2023 14:17:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=NoyMv7ADe/SYhOsDWDxbGRAJmjr0p65Rg+Z/K9TrSCA=;
 b=nZ4DkY5xrVd3WS/Ie59B66V/D4rYQWQMJSMWDwWe460UYkqkMkEwa/hUaF88w7gMv+Kl
 2W5CLqWZQUZ1W324doarp6gmHyvs0M85dND2NICa23TfTJzFzu+mEW35W9PNOalXlTzP
 8pmam2qg2qNjwW/g5Fd6aFQxuVbu0HG7Es4cXUgmnJBbdysVh1n9NAw8AYbO0H4nzApE
 e6hJL915IKkd3LdJocaHS46YU2+AQYG99i12IEVY2TtMrO0EAb85JLpqBEBEYAREY3tw
 tnRLNMAcWjw575S7VPxBhBuOb6z9Pa1s4rX4KQOX+FrZR7AKo/ozxDb3voCOuNf0Hcw4 +g== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3spb695urs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 25 Aug 2023 14:17:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhSGLJbB3muYxw+AL0rXj0Ki+E+gENXjb1+5nIPw6gFw2BN1L+4h6DTPnfJ+OJOCoG1k5sEh5vbOhpZEDtdzABfj4kRLU8O5LOtKn/1eEYrwAq8Ix3dlfXz1JRhAEfglb3nEpYzsBoVOw15txNJ2AVbcfetJzdEjWsq+d4/8RzFdrC/6GYZa1Mirbc6cjogvsT4KURoMqe1Rl79t6SvLCB4YdjHKX10Cmg1Qe383PfOZaZITtUJBm06nJvev0AiSjDNGarN1T2OQFYYNoUiFDwn5gRUe60NmgJe2A2ck7Gcz/kXdFEypmqLFIKfna9iYAyGXIsTkrz/hiMBzLZqVmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoyMv7ADe/SYhOsDWDxbGRAJmjr0p65Rg+Z/K9TrSCA=;
 b=ORFstRp2661aKc2bcMjkCimA2lUeB08A2M+XElTDSfCFU3UqWW97ag9mo5EEZeFIMzvfIhfs7F4llPR5VH2uGjm/oxvXozi8dhz67id0ZYpKG+r8Wo+GyZJtR6v2wv+mRjPcHzPOBx9rlefnG+z8OMaQ/3HeBt+DOPpPjfphJOwTrgOYWZ5un3M7NwxtNBk4HI7YoU6xT1FRTJwbZxxuhPEbl9LMvFtcRqE66xra+2ddKnV3tmfXK0SDXhgiWIySVPbVGCoJVNTaqWy1VOpSXai9MpQLVfTFK4MR+Lx1J52ecnYQkHJ8OXFGd7lYXQ6fg2yaPpWcHux1M5IVhlv52Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4578.namprd15.prod.outlook.com (2603:10b6:806:19a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 21:17:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::57f2:86c6:1115:ad7d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::57f2:86c6:1115:ad7d%6]) with mapi id 15.20.6699.032; Fri, 25 Aug 2023
 21:17:29 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Yu Kuai <yukuai3@huawei.com>
Subject: [GIT PULL] md-next 20230825
Thread-Topic: [GIT PULL] md-next 20230825
Thread-Index: AQHZ15mOuU6G83yfzUaqWayDGt2qfA==
Date:   Fri, 25 Aug 2023 21:17:29 +0000
Message-ID: <C27623E2-7C14-4656-BF7C-B79F02325604@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB4578:EE_
x-ms-office365-filtering-correlation-id: 8ffdbd5c-117e-4ed0-f1fc-08dba5b0b0a3
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ttu2JFLdwNpfi3TDXpxkzg62SJa59xjlLsF5gk1NI59fcOx4hFh+ZS5wJLoqJ65FpYVwT+StPaEWo+QtJ44ece4USX8tEm4+muyqIUkD5usQ+MHXuqPh7sqkuAadVE/SA3npAKIISGJjhr6q394p1NwggEBmgsnxeexlOVoiX7BKnCwrGzkqnsEAZtjrSgUqAJ29NkO3J0OBq5rKUNGoQ9vlH6IdO9Ex9Rj3i95RBJVlB4MTJmnRxcLfTiADAd35/t1tQpNdhAE8/tvcGgT5J+u6ERVtleuuJb5tHPMxmmL71j17xh2DEAiN2ydkvUiBgN1UhLx/I7l4ztJOYzjxQQlnMBhuCo/1E9NWm3GrBZi5Xr+OM1cWA9OicjnBZDBqjE2JXUymOCq40SQySSgtsO8JhJiwzzAYYYYepTsrUiyqWj/e2JIE7DmhFwblEv/dT/GqetIsamdduc/KPKsFtWwR7Pa+q9VpBFuBSnbAwhMjPswFnJZHPdFiWp4PZv9mNsZ79nfHmn3GzdIE1YD/WVs+fV17eB7UvdQB5mw8BlrdJB6sDnNKKBFYPZqg7I0Z+ezqPfSQxkWjmiTkFTM0Y6uGhDs6+TR3DxJELReHqjc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199024)(186009)(1800799009)(66946007)(6512007)(9686003)(83380400001)(66556008)(41300700001)(66446008)(66476007)(76116006)(2906002)(5660300002)(8676002)(4326008)(8936002)(110136005)(91956017)(478600001)(6486002)(6506007)(71200400001)(966005)(316002)(64756008)(33656002)(86362001)(122000001)(38070700005)(38100700002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ns9FrAY8GNwWlPKmIxZ4vaWtJFqupRGOizIsCx8AQTJBCgtiuCULMhPW3RPG?=
 =?us-ascii?Q?UE3LxowWJrJ4FDptZCEA9+yjQQLelH9JbaxEuyBZVZ2i7N9VCb8BcKJG88aD?=
 =?us-ascii?Q?Y252quLohXGn0DdX1I8DeEQUUI9OnLvYxKAaOC5NLPrKadEPiYNnIZSo9B1o?=
 =?us-ascii?Q?67vzQ4KjRhRdcekC6EmYuD/JlyJEXO3NHZtXqY7O5Qcat6duj07FRshq+Vie?=
 =?us-ascii?Q?23x2DaBog8PjNVC6ZWtopAEuuv9Ed3uni7jrA3gpBNJR30kPtaHs31Y1M9b8?=
 =?us-ascii?Q?bXAjBu1GQTZlevkYYX7GMPToZEaKUlPAb3xXjqjuOSZUvFe/kGS6jwlmOBjD?=
 =?us-ascii?Q?oFX/xeg/MeXpx8mYHcvfHBuohBlEJlRSNpW5pGxN4p7I9UHVrFI0mEXgUPbr?=
 =?us-ascii?Q?2FAP7uoAL722oZvbcuvdFrYAqRAduvbC1tBQiRJPjhdCQMecRD4IBrOeuKwc?=
 =?us-ascii?Q?wu4koC5X2xGrTLh7ZkpI165beq/pDCPmBsH3UsgIg/7My8TFGATUAHqsmX4E?=
 =?us-ascii?Q?ZX+Yv7N79o6pn3a3IoN2ktqLLWDhD2PJGGMyZJSmhXRnYac855BOJLFVr6b0?=
 =?us-ascii?Q?a3cCBqLOA2c/F3E8PkW9qroqsoxzHzcBIGYesGAx7TS7AQ1oW5nyYydd8X9/?=
 =?us-ascii?Q?4QDoCBvZ0wfdHF3L7T1veODMCMycgl9jQdT84eghXStvB3s2WSU2m6LiEVUN?=
 =?us-ascii?Q?58E58ZR5OxU1KTx0B2Qb/PI39yrjOQjSE8iX5DCIxxR4Plq/MtyTv3BTART6?=
 =?us-ascii?Q?CGu3BymYdW2ynPLK1oQ0HHu+ZOt9oPo1fgq8mAx17rWftFyIdSFNprw339rC?=
 =?us-ascii?Q?wJ6iPwZ2Hp2/uFEfY1kks+xN1Z9CfoBgZbQkWhONfrIOjqWEtvD/68Zjc865?=
 =?us-ascii?Q?P89XZtJVApb7b2kpLJR79ZTHbC8MB4xSi59M53EdzBw+ewgfYIlaGzRY8prn?=
 =?us-ascii?Q?SkoYUlbWiQdxW3wNLNjT/LYClp6z5BRxDyVDb6wjoBR/4J+qieov5EfM4mCl?=
 =?us-ascii?Q?N5p3weVTS3svn3z806O/YaUiVkmDmy9CDAmCCcgnx0BQXkf/E1OkhSMsLhdc?=
 =?us-ascii?Q?EsVsEmgt94EA1JY/w4X16ELM44ugdDVmwLBLuj8pTmji87kfhFQTlWvcThZB?=
 =?us-ascii?Q?OvA5hYihIPr5GrS/vaQ0dehQZm2FL0HB9nm0VSlG40OnHZr//Jp6aSrsi5bE?=
 =?us-ascii?Q?CNKB2cZiYXK2Ne6LFdUKtCqTn/qYumDQykYCUutVOgIgeoN25toQ6RR/Hp21?=
 =?us-ascii?Q?ur/8cv23UjS/yusI7eBVhelpJg0q0w760xU98Y97+kSo5fsopYibbnpuZ0Ir?=
 =?us-ascii?Q?ITmFeF6buNUW+RrWaUWS84FEkvuYc3Cdo48L/ZKqtaLI/7ChixIVNwEjnrbg?=
 =?us-ascii?Q?iCJcJ6bFf8fI8RBYCUvpRUH2nFHg8gve54h/3N7UDKNdi3yzb55gJ8qPYtC3?=
 =?us-ascii?Q?OhiuRxcs12RJbGsBYxZKq0QkSfP7Ph5Gjp6SgyQFi26/eNv8giLXX+qTlvKy?=
 =?us-ascii?Q?1FYLtSyxNFhw+xQtFyggIrvVwthzqEojJ+EkM26+DhNaX8U1jwNF+KYXAzU+?=
 =?us-ascii?Q?YLd89H/IJqAgm7SuInlCgq3P8+GxNtJqc7evK4n90JR3yfAL4jEi+KsZ+XFh?=
 =?us-ascii?Q?LpJoeZSfKeyW3h1HKeoT8sw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1CE2F8BBE7CEAE4A84A90DA5DF12145C@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ffdbd5c-117e-4ed0-f1fc-08dba5b0b0a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 21:17:29.9013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jqdIDl7hZLRZroO60dplYcQ+GdNjne97k8mRDhbxHYATBbfZKbMmQZnkGoV0zsWpZn9HxuL2zne1Fq/tVCgyxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4578
X-Proofpoint-GUID: n9hoC-y7t0PTm041kK2llZHSqV-bS39_
X-Proofpoint-ORIG-GUID: n9hoC-y7t0PTm041kK2llZHSqV-bS39_
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_19,2023-08-25_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.6/block branch. The changes fix 2 issues related to export_rdev(). 

These two issues are new in 6.5. However, neither of them is urgent: the 
first issue takes many iterations to repro; the second issue only triggers 
in a unusual workflow. Since we are already at v6.5-rc7, I am sending them 
to for-6.6/block branch. Please let me know if this is not the right
approach. I can redo the PR. 

Thanks,
Song


The following changes since commit 146afeb235ccec10c17ad8ea26327c0c79dbd968:

  block: use strscpy() to instead of strncpy() (2023-08-22 18:07:50 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20230825

for you to fetch changes up to 8da8ad42ba65c65f2a213366fd8a759404c2cc58:

  md: fix warning for holder mismatch from export_rdev() (2023-08-24 23:10:32 -0700)

----------------------------------------------------------------
Yu Kuai (2):
      md: don't dereference mddev after export_rdev()
      md: fix warning for holder mismatch from export_rdev()

 drivers/md/md.c | 21 +++++++++++++++------
 drivers/md/md.h |  3 +++
 2 files changed, 18 insertions(+), 6 deletions(-)


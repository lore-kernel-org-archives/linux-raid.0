Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FF7C197A0
	for <linux-raid@archiver.kernel.org>; Mon, 20 Nov 2023 16:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjKTQet (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Nov 2023 11:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjKTQes (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Nov 2023 11:34:48 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECF3A7
        for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 08:34:44 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AKFvuId009656
        for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 08:34:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=toC966P26t9IqF6EOtf56tur3w5FCDGMYvR4hQhX8ds=;
 b=CrH1Kla7YIcyVMYLLG9unBulCF973S8UkgcS4OlzOK6HEx67gqe4FFrVHs5blyVnAyuy
 FDN0uzoI7ZmC4s4Z7TB1rXAnkizLNyo3N2o5MWw5aMoX9uNmjtpSovz4+mUgBwVYhmnN
 8wqyaOlOfQEDfS0vwx9wzKJ+Sm8smF0fQPhfwxvazAEmzr4bPlYe2TPaKgAHG+7L5e/p
 IotIWMfBMrmlh8NIEKPudc3LSroRwGWFDSJFBi1TgujrzRIMfPvZ5oT47bZw6lb95Xsz
 1l6eXEGIVJBJeCgggrybWUvZwb514b2z57r9yt3MwC86uDwspEauwvD0/D8SMJUEEs/t lw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ugajcrb5y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 08:34:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXcbJz/FVFxtimpYTSd1rxe50YMIHta9vz2XMRe7LEqtx+x3IbUU/6NSamQKBUekr8tuN6uSfeLOlWqH0B3N9PSbUfhgUY07OZVzrpOL9mDXB769gQ3ElakU5JDWDHlDaizymUgNAq3rh7RChcjO6C+Y46MiOkVA/4XqtztmP8NBY7VkMhB/eXdFgPnV9JwXA2V/WxM3sGUiFVh9d5TbmHb35Lr3eVmHzogrfWVmI6lzUnhttp1+XB4BOFPIoJhmXcTAXO+oSKW9v8qw3bi3XVtwUhFjSpr3q4M+A0fJagxWSp8v9ZkJmZC3OV7B3y5gEa3z0g7fRGg/WOErY+y0iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toC966P26t9IqF6EOtf56tur3w5FCDGMYvR4hQhX8ds=;
 b=mVTuOhBhBjZGLUdz++vqjWHa+eft9+G5tlcmrNBS5LdAkLi583NvZXvMIJFHxb+VOwCXYp0iN0UmgVYUaz77jbpsb5Dgr7302qA28LvG4Ep8j9sBAKEFJl35Yis4WSBz24Vwc5mpY0pIAasogoJpXp4o4oWDASE63l7qejk44bfYAT+vaC27YsD6tntiH4w9MN927d1K3hpT85tV0wtF4r4mzTVhJ3ND1vMFh/DhSKQCkp7J8aW6h++G0MLAnngJBBtm+mqd00MoZLaYxchN1ysZ/OZpwE7RM6N160gSznWg9X3x9eSxx6qMklkBr0VExYBaoC5KBobk3cOTDhiofw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BLAPR15MB4036.namprd15.prod.outlook.com (2603:10b6:208:270::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.16; Mon, 20 Nov
 2023 16:34:39 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d%7]) with mapi id 15.20.7025.015; Mon, 20 Nov 2023
 16:34:39 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [GIT PULL] md-fixes 20231120
Thread-Topic: [GIT PULL] md-fixes 20231120
Thread-Index: AQHaG891AM2PRXqpakaxlS6NCk+32g==
Date:   Mon, 20 Nov 2023 16:34:39 +0000
Message-ID: <763FACE7-AF11-4A42-AA5D-5AC8AF1FCE75@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BLAPR15MB4036:EE_
x-ms-office365-filtering-correlation-id: eaae8d46-251e-4d6b-c7d4-08dbe9e6979f
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D4jYFCh2oHOb28FLS5yxVWywRjpWvsTpQn8wI3V/KKYGqVDz5ARlUm1EHTHA6BbTTae76DuI6RfC3Ifv/+xOpxZgkcEYxcJpM8iGKTwUorqfrLgiPt4uSAHqJcTBefHCLDB7vdCxJYNj50TmwKEbxoogJoQkwdsvwNt3ZfjEUuMINcsV1dWh+DRI0jr65h1zLckTdPuoXVMVkCi9NT9JHgo5QjFKumt7WbfNT3asUzsgCtQ1XELw3mSDoOkigB65IhfE1Y76Zj3iwanj6LH7EtrQlvcHLn1s2DvmTqcQ3LHwsjaNkQA/GHVfvq2hDWkjXQMo/eOzVY6BN/xHpxZ8ZsKL+fuTRAQX0ODk4K/w0kNX4QOBNYzu1NLWungfat3tfNFnpyebYUrS+g+2VZJRyJqe8gD7jNcXAxBMtLzdTfsjMyEhotgL5TKYZ8FkQHde42mvd7SmdSKMecPUIKNae+FwzPXPKVBzzS4eP70q8U0Yjuuk8KsioWalQ6mA3Aw8sbzmTfNxS2aqcK+yESrXgDiE4SGS33D7hMwedskDDdiisCTsWMZQ4wEmvmJ/OTaKqraqQ7DFD29zQhDstl+eIhTKNfiYnVBlSMx3ygvE28I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(396003)(366004)(376002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(66946007)(66476007)(66446008)(66556008)(64756008)(110136005)(91956017)(316002)(76116006)(6506007)(36756003)(9686003)(6512007)(71200400001)(38070700009)(6486002)(966005)(478600001)(38100700002)(122000001)(83380400001)(33656002)(86362001)(2906002)(4001150100001)(4744005)(5660300002)(4326008)(8936002)(41300700001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fn+Mb1+NFDs40PownZpZg9uqJ/uOTyEiB/Sq+ev3P1g4nmOJtbSN/g0HPip+?=
 =?us-ascii?Q?8QpfXhAxxo4Qq3l7qeIEGm/u97di3YJZZwW12DbJlOVYGJsDl9ihWWLMyPZb?=
 =?us-ascii?Q?ITH46d6h4ngIt6PqqSn69218fzcYen9XswSPcs4fWwoLQE9V5sIGJrQ0c8dc?=
 =?us-ascii?Q?9JI5ppZpB1hKfBPV6mfgj6abnmcfGcsFL9HfSE9oLRw703qRjj+ghAdOMDiz?=
 =?us-ascii?Q?+NRCw4SMUE8hVna45mraLrXD6PzZt05LUuQMumUBKyJhcoqpaIM7z23vZ6wH?=
 =?us-ascii?Q?M4lTc8dLXuvzkOb7nbPUj8MUIakEIZSRWwSGid3HWRF/Q2Vlw3nrXQfGx+fW?=
 =?us-ascii?Q?N/Nh2I22Nd7CPoNnFVcSTnjlX5/S9/j36X7HvZSYh1IXmTF4UxCrBJmPt2fx?=
 =?us-ascii?Q?165BQeVq1jpwIRCiA7whK5+Azp29fvyZGpmfcYVI4cZ+X3Lk62sZ0g7hCqJx?=
 =?us-ascii?Q?sR+NuIlwB013Yug+U8BhOucbgr6wXzGKgTCbn6gayspRt3NPLD7EL7MpYIzF?=
 =?us-ascii?Q?xrIWBgY4gcv3tbttA7cGz4rELm0P90Co+7SShkP+mYq7/QoyIyK27nvBqXDm?=
 =?us-ascii?Q?Lc/fgSAgkvZ/azvN85CO9ARyGoxZinUZhZspZPJHdjY+Dor2tv2IhdASvBmG?=
 =?us-ascii?Q?gPwpaue3R0jJb8gcuVyii1JiCGqlvoDST4T0iqeNSKpTJzwaB/AsoN29pRCr?=
 =?us-ascii?Q?z1afN9GYp+wqGmdrpmDnKIYulQYo5XNx6RXtiFyZT5uICpfAqOsJcHbV+cxc?=
 =?us-ascii?Q?2FRWMqO02K9Va8LZ9RQ+qIMUhVawl0xIuLGSmERIPtJwTpvKDcZ5IqX62XZ7?=
 =?us-ascii?Q?qorLNmU+pPbcLj+M/ngHpwJLZRyMf70zrdjWCVxX4J4Hyc17Tw7X8edpaxCe?=
 =?us-ascii?Q?C2THv1e6pu+CuF5ED896Cx9L54fsHu2F7U1TPHPeXpZLCpGXSIUcgYMV295w?=
 =?us-ascii?Q?NgYIYN/UK1Cv0b5pGhIr8LxLVoVFfDUMXNNne4a+5kvwmSd5rUPFg3g16NE/?=
 =?us-ascii?Q?3TuzA7xcbu+jdRmf9x2e7ljTWKL6PACa/URoiZ19Lu9ttNiDOMekTx6e5JVb?=
 =?us-ascii?Q?3Rcej5nq5DSXqVCxuZnuSH0UDp1GqRpTtQV+dPf2ICF76zrfbJeQb56hkerj?=
 =?us-ascii?Q?3ozTZSi4Uao/JxvFftbEyBzRUXhS7Ucxt3giOLGq7uVmf/LtfTqdUPq8uG2f?=
 =?us-ascii?Q?+OBQwB7RYWlZ/SlO/aBOgllk6R4LFiWSJmHz/gf3WhaEvU0wCmAf2062TmlN?=
 =?us-ascii?Q?WBcIwrfAHEcM8fIeRC891YBQ5iSSsGbHlYg1a7+tQ4o/8XLynpF4XnYMbHE3?=
 =?us-ascii?Q?oBEOZHYs/R313X1lIGjKZcBzLxwIp1wwXAjxe2SXftio9aC7RLBM4x/Hx2MC?=
 =?us-ascii?Q?WlHYm0vIxP2prRBHxmydZsWQaL2LOwEKuuFTfGKZGyU6y9psZC+N/SOWoPt4?=
 =?us-ascii?Q?xX70pdv8jEHOH70nyIgQNYlQlI36qQLkohs40TWE6cd/LEhdKDLTsSnnO2yy?=
 =?us-ascii?Q?sbu34GB0WOBoKWPCtd3MQvxJFmFXUwVhUTpI9kbM8kqMH307rATxr5QyoJ5A?=
 =?us-ascii?Q?NbUnqQamcApDti8FTtQj+qColcvcx6q3AMW0LSyrc7ah6AcGgTeQMJY7vFTY?=
 =?us-ascii?Q?B6P9Qt9gtB4ocaSrlVZxfaA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <702B49C30CF36F4393B6EA717B9A592E@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaae8d46-251e-4d6b-c7d4-08dbe9e6979f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2023 16:34:39.8212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KmtAvM1XCNpVbXf5zm5q6GinmSlN/NUgQVWiGltsZWduRn++POYIzaxqzC+dqJxk6mT1491OXuzlb9lag+9ifQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB4036
X-Proofpoint-ORIG-GUID: nxpb3WXLtcAST50ferl-Y8VtzjyxIMMX
X-Proofpoint-GUID: nxpb3WXLtcAST50ferl-Y8VtzjyxIMMX
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-20_16,2023-11-20_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following change for md-fixes on top of your 
block-6.7 branch. It fixes the regression reported in [1]. 

Thanks,
Song

[1] https://lore.kernel.org/regressions/5727380.DvuYhMxLoT@bvd0/


The following changes since commit e63a57303599b17290cd8bc48e6f20b24289a8bc:

  blk-cgroup: bypass blkcg_deactivate_policy after destroying (2023-11-17 10:48:58 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-fixes-20231120

for you to fetch changes up to 45b478951b2ba5aea70b2850c49c1aa83aedd0d2:

  md: fix bi_status reporting in md_end_clone_io (2023-11-19 20:51:25 -0800)

----------------------------------------------------------------
Song Liu (1):
      md: fix bi_status reporting in md_end_clone_io

 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

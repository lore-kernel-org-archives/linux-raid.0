Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C068EEAA5F
	for <linux-raid@archiver.kernel.org>; Thu, 14 Sep 2023 18:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbjINSNm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbjINSNl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Sep 2023 14:13:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195491FF9
        for <linux-raid@vger.kernel.org>; Thu, 14 Sep 2023 11:13:37 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38EH6ggs003129
        for <linux-raid@vger.kernel.org>; Thu, 14 Sep 2023 11:13:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=0AsSX9ltFuntGN2xC6Nn5OnkcP6C/z9RFPh246XY494=;
 b=ezvyNwq2388YBoFjM3TzjjNp27559s6O8JldTOo5rdVXLi3mL3l97xiQVmsIcgY6CTMw
 8FqMtEVdH3NAn3L9jXq6DLyy9sWCHpRcAGYZp2jgzKOdHWw94JHH+CkLZcf/mWpHEa63
 gUkdm0+2UCduTEEQCcW77jEvx4qL3h+sYNdqAfj1YfdZeKKDM/TBfzZvZB25KADvboxE
 ZaGpK6Nl/Qc1bU+SkEv3DP7Cm0ZXVVGZ3rQ4F91CEzBCaaZY38TRirj6ADtU4nbNROJw
 1t8/mdQh6ZB/ncTAbmLoaCXndMaN2xQ+MSoL0Tm7TaWFVrURccqmF0vu3uLjgd7275fI RQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3t3363m0gf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 14 Sep 2023 11:13:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmEDXnfYroM739yGAmQp0JJD6e9ikBNByMzqH3kMxtGUWOt/DC0mRmG/GfrKDvbHf+4a4UCLyITZEx4t5H+JtbM0tMnSQQju5v47nWc9yZ26vZ5PVVbNCwI9GUcgsvgXKSHZ/q+pkG5wGnrRsVPdoCVkHfS5fYMyJ/rW7uEsCPaTphXSPcVItN6a0ynPyWkix5HsU4xbDY9cq5TOLIlRL0WFrfnTatqm/RXR5LkcXmTK/Q6mFcDk0xxGQ6+M1YuWLhlqi/3xndF1b/1fZkXnYBJ2MB5LfE04NqjbQj4lPJm9Fez1IxmYQasofFzOmfWXr+EjSA4nTLzqguPIcf754Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0AsSX9ltFuntGN2xC6Nn5OnkcP6C/z9RFPh246XY494=;
 b=hgqpFIR+xM3Eacridy674wKiqZCZNtY8xpqtSz0PY5LAa37fzOD2n3dyyTyBdsZKRulGDAuo4oFzaqrtcB/20OHnTRhGJjSdyLq5v8BFrwBXPrr0VYRDiYkiZWEhcCLSq4p9q0Umoa+cqfJjNR3y5/dGiO8uREzE280UG1H8rq1n5FLQZ5i1RQWN0q6EASWqTOKTKAcv/VNib7xn+VQBN2KKf3y627Ry2q7myfLKdW3FytK6+bqIeqR815QTUZQ13T7UeZigsZIiTUIaKAEVcvijZUbeEahF5LmqX81Bhk7+48+u/dO7ONeqgLN+prwW5iDylbQ2msf/UrOjg1YlQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4846.namprd15.prod.outlook.com (2603:10b6:510:ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Thu, 14 Sep
 2023 18:13:12 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::57f2:86c6:1115:ad7d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::57f2:86c6:1115:ad7d%6]) with mapi id 15.20.6792.020; Thu, 14 Sep 2023
 18:13:12 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Nigel Croxon <ncroxon@redhat.com>, Yu Kuai <yukuai3@huawei.com>
Subject: [GIT PULL] md-fixes 20230914
Thread-Topic: [GIT PULL] md-fixes 20230914
Thread-Index: AQHZ5zcfsflXpHZTn0C4FKH7EKY8wg==
Date:   Thu, 14 Sep 2023 18:13:12 +0000
Message-ID: <2294B0D1-4352-4BA4-A070-2625847A1547@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB4846:EE_
x-ms-office365-filtering-correlation-id: 0d3776f5-795d-4e43-f4ed-08dbb54e4218
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h26ZOXAHCX/hgOkAzmn2RnQ1gvMhLBJev9TyOI0uwO9JGE4n6yzL4F0xBwmoeNIqk5jsxKnAXfMmdE5Zu/4uTgSGz1GpDSoGONNQvC17EiCm1HsSk+ihf7OHEcjZssI4fiTkSf28ug8gw0CuER4EpxqWZUn3djFRPLTjU9wzpvZCSONbVrc5hmCJ005T5MMsSknqNtBCKFfkigiWhFHkogDsbtEIykUYtAAUsZ9mFIJjSY57IwAp19xaPCQKGdq66xrJ6cVvwuwMEQltteEq984KZZbJE6/+s5U215A7YJmttmogcTmeJYeE/EDZzmLrTUYb8YVoAPu24fh3IBdM6qCKo2JnwuDgiASTYN9rz7EFS2CYxNW5GaDa/Cy1pTRzS99IbvVejzVF6I6qqxEtuTOedCqdKKlHAx8OzE+EyDj5Qq65qU1DFhCqPQem7d3cxz+sgbIfLQDg1drU3knAr38TvE7vt3PeEXED1S/079SMMP7RmS84wcWW9x2iwWgyX+xOp0IxIOdJ00Q/vpIOSoUeP6ykjO7lFW8Ww+upcZjgpq4tbejNnemt31xF9kk/9omK8yXmpaVXPHDnpnduSp2QRmlwuwuYYAMqHcnHQPo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(396003)(136003)(376002)(186009)(451199024)(1800799009)(86362001)(33656002)(5660300002)(8676002)(4326008)(8936002)(2906002)(36756003)(122000001)(71200400001)(6512007)(6486002)(6506007)(9686003)(38070700005)(38100700002)(478600001)(966005)(83380400001)(66946007)(54906003)(66556008)(66446008)(64756008)(316002)(66476007)(76116006)(91956017)(110136005)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CBwUC134+Csd3vNBXoiWVtXKErxoGTM+ebRghnhpgnrNIBzPqinWxe4+UEhD?=
 =?us-ascii?Q?jipLcDVzkL6AILu5b+TpnA7mxSn5Qvt1Q8EmZ6epe3kI4JNNB2bzx1bL8/Q7?=
 =?us-ascii?Q?2tba9SssoaeIV/+4drreWRxys9QSOsLuAvSsMdPkzQt9hSvAj8FXWuLnDMMh?=
 =?us-ascii?Q?2QHhf5q60yzfPVI5Cc3SYg5dpKXVv25RPRqH6s/0xvEIsMKQxpdVSVE8LSba?=
 =?us-ascii?Q?5AsuUOfnDXZxKlznMoMmrgnC+5MsZoWQdUJaXz/+ROjChrnk4nzT/Na7tLZP?=
 =?us-ascii?Q?J238376GUVvv9bdolUEmwD3i99p2Rq5Ea99Xuo9Tn1901ZPe+7MiJgsoVf9s?=
 =?us-ascii?Q?DapVGjr5tob9B7Oz7h0q6/fWOSmwxARCWvWmRCyE7UI/DduxxdYnxKuTR3CT?=
 =?us-ascii?Q?CHHmf4xw3r2AK8dfZ9Ba4+GvXwX092KLwmqRCLAPcFsE6WlL3cH8/J6KmrZ0?=
 =?us-ascii?Q?9mYPi2+bfmKVdXSnULLsWvCHSWMKAY2r4VdgXbgjIVOTLP+GA3RN8xiHrdcp?=
 =?us-ascii?Q?tCz6oj+h8lQmmCeNoSeWywQPPlx8MYOqHoseJab4dv+4qEl5Xl5xoZrB6Yt2?=
 =?us-ascii?Q?Jk1l9J3wpMmcyhct1MLLijxhy3ZaIZHs6w3xFM8PpeuOYpgcfvecSuO7+tgV?=
 =?us-ascii?Q?8jvTTzzMqsZfnIy7Dji7qzJCd0F+4pWrCIlpaBbwGn5ptyZD0eOH1S3p/zGg?=
 =?us-ascii?Q?VrljQsnTBEicQe+4+MWy6VwVuZYh7AksdJo2RP1IuIodG1A3bbgGdW7hvGo9?=
 =?us-ascii?Q?8C4BApNYEwGqghqTyiYzLWX0C10EFSbFDMY9dtGHmlB3FiAtnhHGUkOpsDD4?=
 =?us-ascii?Q?jzCA0c/rWp648TqukiysuzJNiMIePweBDITW0BX0XBL6cTpLGnIhegGORIry?=
 =?us-ascii?Q?SRNhrWMUQqJgyGd8YY0rdmX8JDlznaP4tVP7LvkQfuN4SuoM1SuuhCfon9uC?=
 =?us-ascii?Q?yPxwUvs4Mt4UUwBbLxRGmeNVebr634O139yxwbrBhmyJmB7F9Ho574NAcqyA?=
 =?us-ascii?Q?V+d7VgdZDN8DbK0gie7ZYKSqGUW31+8F2+Hd7GaBd7c2Mpn5acNaUsZBZzRw?=
 =?us-ascii?Q?3Sc4MtzmQg+ci+ejJrD4vwjNCwzVLrdLAD6XpSHm+D7F03+0rtdVSdBjawXF?=
 =?us-ascii?Q?uiaAHdXBnwEYe0JjXg55IvgVnyfA+J2k2C7Dne30Qel5ZwaobHOLhSLlwU8r?=
 =?us-ascii?Q?7T2m6mbXY3O0AsU0z85O10EvpC3zVj+x6uShSWcK569hzJFqmlCA9EUbilmO?=
 =?us-ascii?Q?h9kInZx5JXS0U/Uqe6JK1Jz8twGRaKPhUij0BUkuvhEYfhWMUngg5tGN2jfD?=
 =?us-ascii?Q?3vWAbXnRvHORP/3Q7Ib+NLzQVmaQIy6mRvSYDj4DKMklxgjgktMn5axz/9cl?=
 =?us-ascii?Q?NjgxsgTxTk+caSn2SCihIhydWQSwsS3El8/GlLQpXJnhDLOJ1F7aR/lt2ihc?=
 =?us-ascii?Q?wBNltvPMvZXU2DhiBmURfiMG842j0+KXaBV79O1qRqrSyRsQ4bdJjoLetyVy?=
 =?us-ascii?Q?yoCbgDChJj7gXMxOUYZ3ixyU1iX4fwVts0DBpxHHldEzNgxf6/KWHbAkomqN?=
 =?us-ascii?Q?9/gPjNjVtRVuktLJciVzoWVj8hBIwWYvNx7GjsCfcpe4msOvzjRxKsBE3FH2?=
 =?us-ascii?Q?/Asq3B/sW9gfCRZzsIF4UPs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B91C313AC4448545A8DA6EB4E10FEA33@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3776f5-795d-4e43-f4ed-08dbb54e4218
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2023 18:13:12.3976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cLiKRXQUOgr2G2dbT74l4WYz4yLL9yvWMo9kf5QeGniKoxzLj6VfUlEpThUt3JiCpdQdq6JNzO2lRdZ9w6jTfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4846
X-Proofpoint-ORIG-GUID: _9s3blCiY1xOw2evFubIaKJ68s6ga2U-
X-Proofpoint-GUID: _9s3blCiY1xOw2evFubIaKJ68s6ga2U-
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-14_09,2023-09-14_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi Jens, 

Please consider pulling the following changes for md-fixes on top of your
block-6.6 branch. These commits fix a bugzilla report [1] and some recent
issues in 6.5 and 6.6. 

Thanks,
Song

[1] https://bugzilla.kernel.org/show_bug.cgi?id=217798



The following changes since commit 4b9c2edaf7282d60e069551b4b28abc2932cd3e3:

  drbd: swap bvec_set_page len and offset (2023-09-06 07:33:03 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-fixes-20230914

for you to fetch changes up to c8870379a21fbd9ad14ca36204ccfbe9d25def43:

  md: Put the right device in md_seq_next (2023-09-14 10:13:11 -0700)

----------------------------------------------------------------
Mariusz Tkaczyk (1):
      md: Put the right device in md_seq_next

Nigel Croxon (1):
      md/raid1: fix error: ISO C90 forbids mixed declarations

Yu Kuai (2):
      md: don't dereference mddev after export_rdev()
      md: fix warning for holder mismatch from export_rdev()

 drivers/md/md.c    | 23 ++++++++++++++++-------
 drivers/md/md.h    |  3 +++
 drivers/md/raid1.c |  3 +--
 3 files changed, 20 insertions(+), 9 deletions(-)

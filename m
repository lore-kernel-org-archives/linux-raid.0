Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CDBE7AD77
	for <linux-raid@archiver.kernel.org>; Tue,  3 Oct 2023 17:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbjJCRfl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjJCRfk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Oct 2023 13:35:40 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5333DA6
        for <linux-raid@vger.kernel.org>; Tue,  3 Oct 2023 10:35:37 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393Exs2c006280
        for <linux-raid@vger.kernel.org>; Tue, 3 Oct 2023 10:35:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=Jwru/+3DikoK+AQe0ogMfu6JGIm4RyIvWYmsMIiH2yA=;
 b=KSTfp504r/q1Co9So4/oJF7XZovqCcfbntXCy8AJ+WrTuFZa3RsyY7Uxe1le4e75kPzg
 /xEHo4DDRpAFLR+RhJpZIz8y3+fEOmVHWCKoX1j6NoJqTvR2zsa88vs8X6Y6QDFzE5fR
 N7x2Pm3ud371FLx/xl/t+QT77C8/cX7JGUpu5RaNoO05+9/1pTEE9Y1MFMIYGAiWFktM
 nDaqUYA8c2bWVp4VqBPYnGhm4eDPX37/ct+NQ1Bf0PYEIivojDZ7QRSadI+4dutV6Ret
 HtJ5EnpMzVL1biJ+Hr1FO/wKWU3S88EOcOmEQUzT7yTeekg5xO3oR2oDruXVh6GaWssN Ig== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3tgn70a3nt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 03 Oct 2023 10:35:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbxRBcmrVbrzmFwx2VhtIJj8I/tA2c1VKCl8mYAbQo/WnLs6VcN9aqjulj4awqbQK7lSxnvx266Uc0Bwp9iWKG7W//Z+2SM7rJprk4n/a2RFs+LQk1+Wgs28wK5YpdbXEIacwSuf2q+j05jS4frNBaYFA2IcUex+HR1gdjcIXIGqtCIpBKLkfp9Gz65IcnzT+yxcbKNbG5ifAYcijdzk4ugLyg2xETiBdIo4dADJGIMpznXP5qv1d7EIBbPK1Lj+0x97oXy7U7pap85tJW9uhsAvRL6ls7rkN3Btxp1V8SBqDf+vMX1BfGzUewWkDawrl2mRPJ51im+Mg/scE91myQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jwru/+3DikoK+AQe0ogMfu6JGIm4RyIvWYmsMIiH2yA=;
 b=OsbiAW/exoPrAOhZKpiAyWF9iK4cJEg08oMt8Whk2zOZVBXZLpfTHeqLf6K3lRIVHBRf3mQAWsqMuAzS1Sw9M+aBiP6CtpJLNZBnHt/W9rmQ0ieIoZOzouHhi5JPXgrx4CIvaKQbnGvFNfMW4VC3B1ICTkYS0ETgJE/kOqKN9yFDvqWb54qPQ6bzTdztnkWOOyXduvuqc+3FWPxBLTznEWIF99frtvxORunHbki5hQBLs8SxdHyTqVt8lehoWSgJEwQ8WmMv/Haiw99cVmdPaFSSCxk+Yxgh+GnuTIIrhOmgnnqI0q8EZXUJpKtY8xYky3sH4L2egmRgL1r+3ERvTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4432.namprd15.prod.outlook.com (2603:10b6:510:84::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.26; Tue, 3 Oct
 2023 17:35:34 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e0e7:7606:7fef:f9de]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e0e7:7606:7fef:f9de%5]) with mapi id 15.20.6838.033; Tue, 3 Oct 2023
 17:35:34 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     David Jeffery <djeffery@redhat.com>,
        John Pittman <jpittman@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>
Subject: [GIT PULL] md-fixes 20231003
Thread-Topic: [GIT PULL] md-fixes 20231003
Thread-Index: AQHZ9iADCZRVCVKMXU+dV5UWHvlSPg==
Date:   Tue, 3 Oct 2023 17:35:34 +0000
Message-ID: <FC0B0CA1-11A6-4CA8-B0DD-27F884CCBC95@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB4432:EE_
x-ms-office365-filtering-correlation-id: e44977bd-ca3e-4975-66a8-08dbc4372609
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +5EeJgmjGVocMEJEkZ+slMFkOYTn2xGsmL9sL12kojo3sUsz6l19iqnGI99AuTYkTSnmxjbPdq5tbfyxZ/obLHgWvsjdH99t7YCoaf/l39jyw/7yr/sDE5h0NL+9787sElDgOnSscb0vEeEuvPDG4Yp1Uq0mKXUrFZjjFYgI/4WG3hHW+vLTQDjUR/5lWMlEzvzJcp2qFn+yYo1f6+sdgTkOZZ0hU72jdpitgIMl67inBpCxE5S5s2w3C00Ryr5DnUkg7+v+AH8bxjfMK8fSL9dLxVUFIZkJKLQp3wKZv1g38pZLYzIuWplgbHzY932SNKdS2JTDGqWZqhbxrPOjRu6MxsVxjcfA+8p2/axKUk+dY4XCSRvijwhonSxSiGXqHtJ0QmujgkAf5AWVN3jgZpQxwPPb+4Jfz1Asxf/UBnWgnThYA8IADaT9hD69Emw/2SaU44PH4DXXINT2ufbJZs1EnEby4PBMEx+YvRko81qLy4i8HAjj36Hf2IIkslU/Km37PCCpRz6oFYf25afUmuJfnWIW2xBnA0XYHojgmvMAVe6SQMH7qTBAP3w8BITXlEBok5OnHJWH+ErIm13331aJrjIMcAFahBwPG2QNITU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(396003)(376002)(136003)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(966005)(6486002)(33656002)(86362001)(36756003)(6512007)(9686003)(71200400001)(38070700005)(38100700002)(6506007)(478600001)(122000001)(110136005)(91956017)(66476007)(66446008)(64756008)(54906003)(316002)(66556008)(66946007)(76116006)(41300700001)(8936002)(4326008)(8676002)(5660300002)(83380400001)(4744005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vHXmfm/aanXEOZ2kOphp9FcYDpmytE5D13dF0AO655Iqfpc7AbzY4kpKT85L?=
 =?us-ascii?Q?wyPyjs8WzSWJvFIIpFmKouSPnnN1Yy0CFE+D1ZN0uR6Gif0Nv4UGChyyNycb?=
 =?us-ascii?Q?pOMYIeb4fFVt+JgJz/6AJUerg6Sbu4IJp9+6UkHbytdr3GJmzF1uZ4JbyDoA?=
 =?us-ascii?Q?W0eGIQdikoy03VqbONKi3MabnfqXXJla7trgXSJpNHjyIIPD1OX2+uglkgE1?=
 =?us-ascii?Q?yO1jlL4/xnnLKmXnlPqck6D5DEzRhNnKNhCAVk7q/KLoMOmtzkL0hk4uV9xv?=
 =?us-ascii?Q?4MaVazihXEXOI9VqJc3cIQMAuhU+gakeZlFU9DV+YZydj72nzF5rtkClGivt?=
 =?us-ascii?Q?jE6mrQ6H67WgvnnxVFohDEpu0swa4/7nZWZA3jWYAHFDO6WF1nzDZ6mPUdY3?=
 =?us-ascii?Q?t6kSXzp2/WfkWtaGm6HSLJjQ87iQKuIngqQIjKn6wgoJ8qwJWPEzcnBNwD1e?=
 =?us-ascii?Q?eLLo88ockamygJpfvTm51p5PO+mig1LdOrGFyFQokC8bowrxXgqAW1szqjGu?=
 =?us-ascii?Q?gsQParHZPbvulaSUYfR9F6JTdfpEh6ava6Duhx4bKHPyJHS0fUz3iCUjzbve?=
 =?us-ascii?Q?oq/uhlAq9lV4tpVfQBmteyCR8dsDFJekRRKcJTXCSN7wJ/9DnE6i7h8SuRlN?=
 =?us-ascii?Q?wQUxlZmkMSMMTQjDwo3dpGAK3lMcVh7PKdkvGFj5MvVlbuEhT5OHB4YOF3my?=
 =?us-ascii?Q?4MyIRs2jSGMbIl8cPvChkcRxx71/D0/Yd8cvkIDrOPTVVwsVO71uPf+Zs04F?=
 =?us-ascii?Q?8Ep0Mh/qga6ZSL2Bd0nBrhcn9qSwi/fX2yTHu/HXcAwuYsRG7kR1zHJyqG7j?=
 =?us-ascii?Q?mIXVaZKLsPvTum8mZXQ/wjsZLohLqoWEnNZr3o4dzb2h7uzwg+0rjyOpvsfQ?=
 =?us-ascii?Q?GpIRXmhpIz3SKqCbi4CL3AwuDFIloE256y9Mvy7FCyoyljPqqfTmFINXw7nh?=
 =?us-ascii?Q?tCh5oYwDZi+P7gtDjxe3oxnBz8iXxVacD1V1RHNpEgJeFRClkwYt92yH3nV1?=
 =?us-ascii?Q?7UhHUn4dTHSXd8kivwTamtWimdP2T0CKNiM/5IXjXOsLrt3ul/LHLv04ZTDh?=
 =?us-ascii?Q?nedpahA0UWsR0LOYBa4S9g4C6ppVcXxytTxmmAV7ehC2KPEUqT7AVYSQ8wUj?=
 =?us-ascii?Q?tU3A0mRdFBpT/gF6g5d1lMXp3QwZu0GYFM1bR611tTQ2adsq/s35n9WcxR0E?=
 =?us-ascii?Q?3JrhmGKFPRcY/VblDEWLWAzolqIbrkgn13pCxq9p/3igyLXz36G8/yU5IZ3k?=
 =?us-ascii?Q?74Erk/HP3uuMBQhN+5EcanM7yGQ00AxFXsf6VvWv+MdGHwLIgS9c80KLyGg/?=
 =?us-ascii?Q?sm0pz5xtBwISeXkYL2OpJxA+KT+SHWeCoVJWeL1QwTZOl3IflxZvfkFHAfiv?=
 =?us-ascii?Q?un3G7Tz8fzB96Dn+dma98o/YSJA8rIbENlAcjE/eeVy9xN3IP9wSj47NDiwg?=
 =?us-ascii?Q?jbRR46F3A5FVvGX+LVQBws5lM/WmKGpheOgvBmIkH+kp22n3Fo3iV02vx7LM?=
 =?us-ascii?Q?rKhG7OfnSSZ/8COAeG4bwB2xyAdZsmx1zckzAOidqzbtItZ4kMWA25Dh+tI7?=
 =?us-ascii?Q?E4zdUl2lVL090KE0YAPJcTgCiU7P4r8QDkMdXdTPEQ7cqFIgKPt/6uam6FPY?=
 =?us-ascii?Q?TzD0IoXeD5+NFOzyzhEt6oY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <282395163F5DF14B9CCF4EC7ADC988C4@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e44977bd-ca3e-4975-66a8-08dbc4372609
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2023 17:35:34.3085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PMqdmqFL9Jb9/Al7YCpYvZ8mZMSchx8KeL4T/Kn1VBGpohcD8s2WMyKuqEe5Cgks4wDJ9942gYrxKL27vv0hKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4432
X-Proofpoint-ORIG-GUID: S_w7V71vnonRpOmlblaa4kMO8DEVT3XJ
X-Proofpoint-GUID: S_w7V71vnonRpOmlblaa4kMO8DEVT3XJ
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_15,2023-10-02_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following commit for md-fixes on top of your
block-6.6 branch. This change fixes an issue reported by Redhat. 

Thanks,
Song



The following changes since commit a578a25339aca38e23bb5af6e3fc6c2c51f0215c:

  block: fix kernel-doc for disk_force_media_change() (2023-09-26 00:43:34 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-fixes-20231003

for you to fetch changes up to 2fd7b0f6d5ad655b1d947d3acdd82f687c31465e:

  md/raid5: release batch_last before waiting for another stripe_head (2023-10-03 08:53:09 -0700)

----------------------------------------------------------------
David Jeffery (1):
      md/raid5: release batch_last before waiting for another stripe_head

 drivers/md/raid5.c | 7 +++++++
 1 file changed, 7 insertions(+)

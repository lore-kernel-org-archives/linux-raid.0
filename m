Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDB6C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 23:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5512261A1D
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 23:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhCXXr2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:47:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50560 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232357AbhCXXq4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Mar 2021 19:46:56 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12ONjEFd029474;
        Wed, 24 Mar 2021 16:46:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=m4p2HfwBjpio8oDLOs2wo18OGx2kFgM/Fjmoi2SwRoo=;
 b=SUwiR5tn/ds/qUN5bOypW3bJJGKurT7Xb60VZ6Qm+Wa6BeDnha2mTVcwrtnKkdcTDzb1
 W2EZfmji8HgieHPRU2IQ+4FLO8X1BbUMhR/bhbmtXD3BJsY5GTxnvasaWprpMzvvlO56
 xvVRANNoLm5FhWPh1sUuTSoXo8jGqw4YSBo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 37fjdm9rds-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Mar 2021 16:46:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 16:46:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G99161B2gomDtrul6ZSf5GeL+bxPEpAYUtPxit4/TKk00gBdMxTR+QpmQ4wmjutTS21jtxrgDycZXMbJn8V+DwZawHMF71LUugsG/5TEJ1a/xSNKxx6g9NKCHFOn8WleDuU5Fo1thH458YR8JpVHYLgHX01915nM9pyORXuk+SYDccBLoHsLUa7y46Ma24CmdLS2bAFUt14i0w53/URG37clLrFDuNxtJpELtspR+jxMTfT9V4VPyStP5NaIHhpjQt7idpCdo3BTxUikAVaIddfp81pW/9PQtvR/4yZML0aqYfwJdSFbe/2a0kpbKWKTfNU3Ahw7j5OrPIXOJySE3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkMVLBl4YvZPxFXZsTARk2qaKliG2SxKMCwIXEYzOcQ=;
 b=OSj5SPxPF9yRT9VtKzQtww/Fpllbif0f0bnmLthBAxkgUwUx4nlD2olun/KQEx4Vq5OX5D5YpX8QDD7M8y4F3Qnd9fWdu+mvEYEe787RupIcc6XfggrC+e9W5EF9V2Xty/Jf5GGKuYrsFkFcUliiyi8v/CzYpRXpmiZ3CakLraXyarguFAYBlYRIB7rChPM4wmzz8dNnoFsMpTk1gLLX+Ch/TvUCztbbQxD7MrbrLRThyCXad7E/4wXc+IXC5OcunmrespEUEI9eYMb/IC8J6ywh6JHbEUfQvt+APG2anZE24FI2EnQF4gGN2ykp90waHLAYHKsHWJ9N+Cjtp42aYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4664.namprd15.prod.outlook.com (2603:10b6:a03:37d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 23:46:48 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.036; Wed, 24 Mar 2021
 23:46:48 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xiao Ni <xni@redhat.com>, Jan Glauber <jglauber@digitalocean.com>
Subject: [GITPULL] md-next 20210324
Thread-Topic: [GITPULL] md-next 20210324
Thread-Index: AQHXIQf0k2MVgfVx2UaZ0Wt6ynx8aA==
Date:   Wed, 24 Mar 2021 23:46:48 +0000
Message-ID: <145EAE56-F35D-4475-BCB9-C67F5A95FE18@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:efc5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 663aa16d-f528-434f-5d1f-08d8ef1f174c
x-ms-traffictypediagnostic: SJ0PR15MB4664:
x-microsoft-antispam-prvs: <SJ0PR15MB46642D7107FEBE8DEAC311D5B3639@SJ0PR15MB4664.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xzwg+UkLSfyCfPlLeq/wThQvtZr5aRr5D33kbtxTqqMmtnOsH+IYEHOmmMlVOu51eeSlS7jEpdblgHtmWLPZ3+9C4Y82YEdD42XqWpmW6L8GI/ehlukCAM1q2h/dbz+jnHKxn40i3S2dEaIcR6D2+/ZoTDqyNcBhIYx9MduH63FMpuX2yBYl54cMJU9b3mwIUyhc0NnC3t7m+wHJArQargUIzfLaTbYMKkJsN3H9n5sfUk3TM6cNfjy1l2xqjperGIDCvIi0Vmm0z2e2jeOgXemWu25tNWgfefU37Is0C5aqDFbZ0jpunQ4rQFqGvcSBSP5ncIe0tIvheZ5tjcUWLw9AuMCFcaS6xN7IS374jkiMh6/ZRLYuNp6x3FtTuma6k2PFr2gP/juLl/+6JnbdvJcqsYhQQ/4zKc/dVSuWuGRY1Bh7JaiGZB74/o1/AEDkpxIJqqp2mreb9FeHYAoXZK2ktEIoWKHbRSehNM3F/fPtL/8SjT1KYz4aKK0S8RGJ7QKkL92NeDeLixeXIR6JYQByqDgC/Pupkn+EYeDYuRgQW3DlvcBwVi2VannA1+CNwVC4jYpYk3BLbVTY3Nntpi5WEVldcsqgK5xexbu35WQqkWFwIQeArkMPdT/NIipDRUEpyrmTSBaaTi9Fz/StpuWL2f9dniVGwRmqSTzbRNjv31mblVDbL4Dv2sahA9+mjO0zVRkG8/PT7Gro52K1P4glRkbzV5xj3GmlZytBUnGs+t19v+pcvWdZft2fUBP+J4nTd6PqJ0o3sAo/EEshRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(136003)(346002)(186003)(316002)(54906003)(38100700001)(478600001)(33656002)(110136005)(966005)(6506007)(2906002)(83380400001)(6486002)(86362001)(66556008)(8676002)(64756008)(66476007)(76116006)(8936002)(4326008)(36756003)(5660300002)(2616005)(66446008)(66946007)(91956017)(71200400001)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?c8bKFDkvRO5gN+PYAQDxIeJY7iBcfNsd0lkm6CK9GIrHdLihhnutVM2xa97b?=
 =?us-ascii?Q?Bxduv0Twb6KliB57pdirL4LvI80736WybAmFGgxSrconsH+OLkgTDKr6R1qn?=
 =?us-ascii?Q?Mxqak5z+RTw8UTKqEi/6saWks9FqhPFsWAk/rsISKvSRAdDj5BS7m04Vc2fA?=
 =?us-ascii?Q?Dq7+voPDwVNJQ/pz4te4RTUFOIrqyTqijsFFu6U6bCIhrTnk/6rvWoW5sxBv?=
 =?us-ascii?Q?PYn1h6Xgz8Z4Yy25RyKEqjoi14RKLLuHGVCdcEE60/aZupWhCuAbo2UfyqE+?=
 =?us-ascii?Q?OA39Bz+jHxjOhqXLtaAk1/briJGjnky4+u5t6fmdwjx/r8u1Dh0P6kcXzHkY?=
 =?us-ascii?Q?WX/EqUy66bT7lDV+GaX78or1KNM2TN9I5ZN+xv+VE8R3obZJ6mHtX+NU5uEj?=
 =?us-ascii?Q?FnbxyJivviY5oYRZ4XsIP/rmm6ckdXU2ZhLZIqngWGCGi5dufggBoQGNHhS6?=
 =?us-ascii?Q?8XTo36eOoEM87LJJOMiZWH9JfyWomPZPd4y1T1FAEcCgU7RettSBpb4CX/by?=
 =?us-ascii?Q?SWZnYbeSYtQUj4uFzEdXddCB4JpaAolDH9bD+X5PdXdh9UV/iNXIJs/gQ7ut?=
 =?us-ascii?Q?nebK/IFoZkwSMHH17+GGJI3y8cGT9Homqh+6cWP86w8eMgdp/+OZijNT07e2?=
 =?us-ascii?Q?W8D2mPKKZdvBsOyMRbr2KQVIVwSFZWK8sqNGoV/iaRnbHCIUgYygQGm3V4RV?=
 =?us-ascii?Q?eK7il0Er0bgCoVxClubLPl0Mf8qrHEPQoNAu9/u6pIGQy70LdiTpnkaQ3MxQ?=
 =?us-ascii?Q?Iqh30KOeMp9pUNAbY/zQH2yYLJLpmOEyOnrVoT7wrLGjuu+SnHbDVxjxNRES?=
 =?us-ascii?Q?4wwC0H4oaxwTuuUStcSWUNGYJiZccJs3ocU/4wNHwesnjZCVVVWmkwlXt1ph?=
 =?us-ascii?Q?SN8LPKP4OQwwGZPSTAw+c1Xi7aYejECPT5xkLFJA34vlnhAUSdaq74+gE2dE?=
 =?us-ascii?Q?jAi5EaWDZS9gGaPXkT3W9gpv6rHBOm8VjE5dvCpIxo15bpTsOnFuQtdI8PCm?=
 =?us-ascii?Q?vWNFX6bz/nT3RNIlMANtvjd18AgkFsqTnRys1I6fjMTvXEOmLjNBqf3S8Ls6?=
 =?us-ascii?Q?sOsDsWPuF/sDryP/AiL2LLWEOwqe4MRefaS4QVqZT3xqXJxUXxCfo+p1GM5j?=
 =?us-ascii?Q?y/phG9sckwR6t/aWx4cUSuk4HubgYD1rUmv30QynuFWMWnWjtFNBPflK4lN7?=
 =?us-ascii?Q?pOyOeMId1eHMLBJmvMtXMYEqb3+3ADfYMoI7cBHb1DQkKxOnLzCX0wac5Jaw?=
 =?us-ascii?Q?kx+5TrcW0qbXYH9l3jXptNXc1HHnE+36YeRFgHj9NOFecgmOlmn8398+6pZz?=
 =?us-ascii?Q?26i+IZY4tMNbdxeLnxE2aMNjIsLRCKSLRPg496wOXPMlV3p5eGTxejk2Devz?=
 =?us-ascii?Q?hMUAhTo=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ED03624999640547821D02FB7854E7EF@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663aa16d-f528-434f-5d1f-08d8ef1f174c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 23:46:48.4831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3aZHwkowM7Bdj2NyzU/QcmzmvgTGfYbK6CiUqQzmTd7nRdpp1DPzgjIKkJlTtwyKFF89NYhcUjsryeOEO85MuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4664
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_13:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 mlxscore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103240173
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following changes for md-next on top of your=20
for-5.13/drivers branch.=20

The major changes are:

  1. Performance improvement for raid10 discard requests, from Xiao Ni.=20
  2. Fix missing information of /proc/mdstat, from Jan Glauber.

Thanks,
Song


The following changes since commit 14d97622448acbea0348be62f62e25d9a361e16b:

  drivers/block: remove the umem driver (2021-03-24 06:57:40 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 7abfabaf5f805f5171d133ce6af9b65ab766e76a:

  md: Fix missing unused status line of /proc/mdstat (2021-03-24 16:29:07 -=
0700)

----------------------------------------------------------------
Jan Glauber (1):
      md: Fix missing unused status line of /proc/mdstat

Xiao Ni (5):
      md: add md_submit_discard_bio() for submitting discard bio
      md/raid10: extend r10bio devs to raid disks
      md/raid10: pull the code that wait for blocked dev into one function
      md/raid10: improve raid10 discard request
      md/raid10: improve discard request for far layout

 drivers/md/md.c     |  26 ++++++++++-
 drivers/md/md.h     |   2 +
 drivers/md/raid0.c  |  14 +-----
 drivers/md/raid10.c | 434 ++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++------------------------
 drivers/md/raid10.h |   1 +
 5 files changed, 407 insertions(+), 70 deletions(-)=

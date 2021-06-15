Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45882C48BE5
	for <linux-raid@archiver.kernel.org>; Tue, 15 Jun 2021 19:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D4AC61166
	for <linux-raid@archiver.kernel.org>; Tue, 15 Jun 2021 19:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFOTqM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Jun 2021 15:46:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37154 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229749AbhFOTqL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 15 Jun 2021 15:46:11 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15FJe7SQ014592;
        Tue, 15 Jun 2021 12:43:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=+41y/Yn0/TF2x3FswkCPR7OoL3o40twfwq/ljg256Io=;
 b=gGa354XEErV6axtyfsHdO4nEYBtt12+HOgchNzxskPyQLOJhqLVIdCuiPpL1wP8GyPQE
 vS5xZRVR8IdW38gBn0MSBXjfYh/YuXwWAoAE/HwF6CmZ5Kl0UmZwDbbqh+JX1GX86miF
 1hcL6+/IAzdYt3WBZsHj76RvsTg6EeHxZZ4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 396x3ht2dc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Jun 2021 12:43:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 12:43:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hr4MnQTU538FQwLkfWTJBwlk50rxdQKZTQB+jaAaBX5maYbInBvQEoVZ3uXRLrJdu4KLjRIzHz/Zif+MonUJQYqn6oyNRGbBo3WhbhfYGhdlbeHFilsx81RfvQmByTLTfzloqtfNNvsS7T3W3yNpeYUdlM8X2elHa/6sVmbUm1WWyx669sFw+GBcuG0J8dvS4Ovuaxb0iDImj/poFarAY0YuU9MEAl4B36o5Iw63xCHIEOK3LJ5cDQLvNRQ7W/lGyStH7TQfwhzWWraNpuMVNRNr6/7oKazp8jD54r6Uqq6G7qzJa3Hs78CXD8LlsLUdAjEqXvwWb9l7m7NTT6AtEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcEODhf/9ct5V4Hzv2giONBXS2st4n+hCVre0j99KTQ=;
 b=JtDByqVqS9rR1rW98DkzvPkmbJCq+XyPPfbWytETAXwHc6/qE4Q3fo/+q53Q7VxRDTQny2S1wP0pZ/CuchCfM54RfPQX9BO2SUh7GU1f+l+Qx8IT/z+RRWSlU9i35i5M2lr9i/eBLD/yKWD2OWxdiIyhx3JrHFRKWJojbIn+XNfi+5NHtlxUOt4ml9bx+c/i80N7yvli5EdFEysXtZ6ybawZDehw36IF8XyYrVEC36z1m4p/slQFc86WWsF1HDzW3Skq8ph+D+4MUXrHBGgvPmedaiPyMVS3E99vhR4GqBGyvkb77kU19O+9NXJTORjeSyr9nzsQMBkJdLR6SdjRFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4744.namprd15.prod.outlook.com (2603:10b6:a03:37d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 15 Jun
 2021 19:43:43 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4173.038; Tue, 15 Jun 2021
 19:43:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Guoqing Jiang <jgq516@gmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        "Gal Ofri" <gal.ofri@storing.io>
Subject: [GIT PULL] md-next 20210615
Thread-Topic: [GIT PULL] md-next 20210615
Thread-Index: AQHXYh6/9JoRjTkSe0edJVFSrXtEXQ==
Date:   Tue, 15 Jun 2021 19:43:43 +0000
Message-ID: <88538F4F-01D2-4491-82D2-CD242F98AFC3@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.100.0.2.22)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1973535-5e12-4ed3-fa46-08d93035e214
x-ms-traffictypediagnostic: SJ0PR15MB4744:
x-microsoft-antispam-prvs: <SJ0PR15MB4744F22809FB2085B3D9A9CFB3309@SJ0PR15MB4744.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 506f+oVfQDW/hjoGivqEE9aHNq8azxKfC8IUvKw6S3pLFyV+gQhiVyeXARU87a2izVrT7ioStpfcX4KNAdlwDD2RHXlmpSqxzIVrPXaH6lXtDveeYHWRMrq4Uewc7FbzSAAOoHR0VLVauP1LCIIbm+KR18rRwanFSpKlCIgfgGhAp8tRs8kcqBO/hmRh8hnEklCVSnq+bOpt9gOJtHxVMvJW1Z63BrJKQZbufn4PvsOWlCNyMfLQRx13SWvH0/DECGHyzwFC5KVdYV+9wEtlA15PEjHw/piAB4AhiCL41OIEWjam70+Fpk7S3QS808VPEPDoQuzr/giX7BE2erfDQh9TnTdP9Y80UupvAM1W70Qif24NbNsn5e0Rh6BXZ3S4zW5urMte5Vppj88AnZq94iqwy58kiK5Mr9d2nYIP4nyy9I29CoaXY9wg8ERtKpoW9CROWT7mXd2VToVOec3q+MKmnAdgFIyYU9BN8rjJ0EM3TXYRp5YC8wqYfp5hFzSc1FDwdABMgex0NkoICyN2gP5uaR+3t/vhoTZFz/ertPpnebguYRu9E/a2Z4VCtyckcNRxl9qiIQMAQuORoJm5k7FTDBCnIe4adI6DfqbZ0UuW04zSMlDsTkki6czMIVUrEdZLrewSt7bc2u0YCOma+5/ugDtBu48E6Dm5UxjUpJjSDzY178r3uqOUiJjn0Bgdaa2fSO/hTWrH33EXxEMadBMspL5++fAlF0xx9gXaeFnwvLoPXyyCvngPKTFKnqcZU39eYhPmCWpsvseAIQjABg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39850400004)(366004)(376002)(396003)(8936002)(6506007)(2616005)(6486002)(86362001)(4326008)(186003)(8676002)(6512007)(36756003)(76116006)(71200400001)(110136005)(5660300002)(2906002)(66446008)(38100700002)(83380400001)(66556008)(122000001)(64756008)(66476007)(966005)(478600001)(54906003)(66946007)(316002)(33656002)(91956017)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c9lyAYDIdGVRtHwDKOho8SBEsvWXNG+PecM56O7xtwwvAd+UIqicj4+j2XvD?=
 =?us-ascii?Q?YzbRJDx7NZAG6Isz1i6tzAMcrAzIgrtXJT7Uk7SHaNQX1s7iqsuKHOMWYUhe?=
 =?us-ascii?Q?3LaKBMmwL/s3qZFzprB/9en6J5XZZUYOuL9QfJB29BBO3pXkken2Ogw2+Gil?=
 =?us-ascii?Q?9VJ7623dl1ApTECH5dIEhYVquJ9rYBUfBEe50B8JDe4R+Z9Cc8LU6+1eri+A?=
 =?us-ascii?Q?cTh3ZXtIsrV1Al9DkluDCm9SblH1eux/aA5NkG1e2lxMuBui2ZwNrHpPUZi3?=
 =?us-ascii?Q?FxSGtocg3ERUUKQaSLBuUcgb1lSQrQ8Vx/Qn6FSL8ppL5W1H2fJuNDn6KAoi?=
 =?us-ascii?Q?l2P4nKESti2eKsIOeeQSIzVo39FlscrKnrZgW1UTMeb+ZvY5Gpyll6FDxvk2?=
 =?us-ascii?Q?tPz9omHW8Ioxf3wAS50Bpn2YswaUnPKRIoxy/sAPc18HI8ggIIROihA+0SDe?=
 =?us-ascii?Q?0xf7ljkHDcbjaiee8vA2LUHgvR1EJiSfHpSfNk6YS3otFCYB6bPcthpHJZrW?=
 =?us-ascii?Q?23ezqJPMZuRmA+3rJAm4wrYFd82V7skXYebI+hkn2LHv2MiDAI7nXBN+tBqt?=
 =?us-ascii?Q?Cs7goKW/WMdKi+sXu13afjWwnhftmUdi7xW8bDiyP9qBEfophshFdLwKUWL3?=
 =?us-ascii?Q?VCwnIx+Fu85H00sea0SFQy3PnFvzZxrMOa/iK1Aa0UlAvWqViL9OEnFWlXoX?=
 =?us-ascii?Q?cKqFmYqJknnekbiZfaZrZcAFHuqHNdVG5tr1evz7YrF7zUx8UVkNpP9/ElG7?=
 =?us-ascii?Q?R3H/DIMSepv0KhNCTQnWb01OThB8yN4pVKM1DcmurW8Tc/4cktNNUxiVu2Nj?=
 =?us-ascii?Q?19zj72OQMSrF7awS8qZo6/s4wWBk2Tdu4Rhhonv4SB9uSG5BJqHFXf62fn4C?=
 =?us-ascii?Q?DtWcnWvOR80eHiGS7qcCYkCGba8x36W1PaJs+Hlh91LjzmjVL70vLSjbR0Qi?=
 =?us-ascii?Q?tO/zEs8/xS2wpm4HZBEFicC7G9iAvImVJBGN7xhvrkPw1kdJjC3QiRcNayA0?=
 =?us-ascii?Q?yQDClLjehQgRIAuE5MTzR7qpwWR4llVO4RdeKY/z6yz8p3q18kwa7vfxeaSl?=
 =?us-ascii?Q?YcZpsoZia0rQNYgakWW5QTrv/6lPr9bmt2eY14gnGGVMJKRa6R3YWvVsOL5Z?=
 =?us-ascii?Q?1ZPOPro1Q2toik5QPLJpuNSZBecOJIe7OSOlF/UIqOxixG80yEc8/Ttefm8y?=
 =?us-ascii?Q?nkSo/PajFBfcBwXexE2x/1l4KODwG52ODlhi4ONkfGBm0aw/MQQom2XrB8kl?=
 =?us-ascii?Q?bCzSsHCpekdRSJ5fZ05ag08HO0RTzY6oG4zs2DajaFHv0jFyIQy+cgbCJb86?=
 =?us-ascii?Q?98OX4QxkFQmjUw9Y4Prf8FpCvwFskNgz4il7er55Blv+AqzKsiK4I6HADzr2?=
 =?us-ascii?Q?w/g6POE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9A199ACCB1E77D45832F30C9C7A8AD02@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1973535-5e12-4ed3-fa46-08d93035e214
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 19:43:43.2142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a/cZm+SSRqGBcM6Oqz69rpJY2t5r89rQb2vWCWYZgBGewAVFEK1ukP+h79QJ1B87ijnVhqtLi0ts4UkcNvkopw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4744
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 2TODmHj1byoNiG5rNCr80K55O6mJqG1U
X-Proofpoint-ORIG-GUID: 2TODmHj1byoNiG5rNCr80K55O6mJqG1U
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_07:2021-06-15,2021-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 adultscore=0 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106150123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following changes for md-next on top of your=20
for-5.14/drivers branch. The major changes are:

  1) iostats rewrite by Guoqing Jiang;
  2) raid5 lock contention optimization by Gal Ofri.

Thanks,
Song


The following changes since commit d07f3b081ee632268786601f55e1334d1f68b997:

  mark pstore-blk as broken (2021-06-14 08:26:03 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 97ae27252f4962d0fcc38ee1d9f913d817a2024e:

  md/raid5: avoid device_lock in read_one_chunk() (2021-06-14 22:32:07 -070=
0)

----------------------------------------------------------------
Gal Ofri (1):
      md/raid5: avoid device_lock in read_one_chunk()

Guoqing Jiang (10):
      md: revert io stats accounting
      md: add io accounting for raid0 and raid5
      md/raid5: move checking badblock before clone bio in raid5_read_one_c=
hunk
      md/raid5: avoid redundant bio clone in raid5_read_one_chunk
      md/raid1: rename print_msg with r1bio_existed
      md/raid1: enable io accounting
      md/raid10: enable io accounting
      md: mark some personalities as deprecated
      md: check level before create and exit io_acct_set
      md: add comments in md_integrity_register

Rikard Falkeborn (1):
      md: Constify attribute_group structs

 drivers/md/Kconfig        |   6 +++---
 drivers/md/md-bitmap.c    |   2 +-
 drivers/md/md-faulty.c    |   2 +-
 drivers/md/md-linear.c    |   2 +-
 drivers/md/md-multipath.c |   2 +-
 drivers/md/md.c           | 116 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++---------------------------------------------------
 drivers/md/md.h           |  13 ++++++++++---
 drivers/md/raid0.c        |   3 +++
 drivers/md/raid1.c        |  15 +++++++++++----
 drivers/md/raid1.h        |   1 +
 drivers/md/raid10.c       |   6 ++++++
 drivers/md/raid10.h       |   1 +
 drivers/md/raid5.c        |  63 ++++++++++++++++++++++++++++++++++++++++++=
+++------------------
 13 files changed, 149 insertions(+), 83 deletions(-)=

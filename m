Return-Path: <SRS0=HtB1=DB=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F107C4346E
	for <linux-raid@archiver.kernel.org>; Thu, 24 Sep 2020 23:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 335E120936
	for <linux-raid@archiver.kernel.org>; Thu, 24 Sep 2020 23:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="JWh/4Q+2";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="VLpI7q9J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgIXXza (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Sep 2020 19:55:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13998 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726700AbgIXXza (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 24 Sep 2020 19:55:30 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08ONtA88031228;
        Thu, 24 Sep 2020 16:55:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DDZOMiA/fFwn5iB1fqeBaU6t/BelxTOvjadbzYpXVSw=;
 b=JWh/4Q+2kGOH4fhheTuIU7O7nwUQcbmbrsRH0UJkVU0NkfqX9sPPQusnGr2i1VuzxZdx
 THszQjBO++gbjcwo8NPHzV/OfgaA9ZcPLbCfePY/YK+7cEDCKbRshhi41kCsXmASLqR3
 HuvjJQ1LrVsMS63XWueyOQHmoHAhHd6bqoU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp4mrj5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 24 Sep 2020 16:55:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 16:54:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UphFqKJPe0sJ0tSX63EzqsNdPplBWsFl5z0CMAoNcVnJLfErmBKqixmN6lHBLuQ3MQ/9XID3C9qOm6DLgmxUpCHQBsmtvk12QksGsHyAwjcg4inmM5YPa+jCy5evAuWzZWnKY49J3gB1btOZkDT2WpG3QXtO1DYFhKqMVgsJU2ccVlSzS2V7FT3a8MZ5qpxucuGn0VoBGdYVexxjXlE9tMZ3xIPcXQ4/3wvK+pnJkLKBVbvy3jj38I+7rd4CuLGvmp8QVn3CDFBMXTPZmtryP1paHEPGqD2eXsQag+4hKh3NFdd1/KmIMMrWNu2cCExov4U50qkpI/T9g2kAiE9dxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDZOMiA/fFwn5iB1fqeBaU6t/BelxTOvjadbzYpXVSw=;
 b=hB83yWS67W4zKDEpG07Eo+Om807hyOyBU893roRiv0fCN8FtqJ/8P5aPC5nGX4awX5ZoCfYneJQgJRmfznTq0SNbaduzj3XTUvzM7qGtuLlHCFytCulmvWTDOFwaBHLDVfh/252dn9tr/SN14SJAd0Z3rPaXBaTW2xquP5cIh2mA7JfaqOE3DOkdTOrIWoBAvUTq0eqoRbyYSepRlDV235t3M+YopOX1amrwVZ7YpThCoGdM52cpQx5CscAzGnl4U+EdT84jl7u4//wRDI+SiwkKOCWrO+UprXQAV1bVZXynF84+ex2PvEnsmVHV9EpsAECp7zp/oLUC0G9gceFKyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDZOMiA/fFwn5iB1fqeBaU6t/BelxTOvjadbzYpXVSw=;
 b=VLpI7q9JOla6YEdud+JI8bdJinEdU+pEouZfH5uFyJVnzWCa2f/4bsMpuX9yOrSVzsjkiw+tPlLsCavGi1gYnZHKICqvyIEZgURKL5v3wUEMtlxFhvRgjJGVTLiYJmD6SUzw31CAmbIvex+dV19J0R26sX5tVGTh+6tQD9cM4Xc=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3570.namprd15.prod.outlook.com (2603:10b6:a03:1f9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.20; Thu, 24 Sep
 2020 23:54:58 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Thu, 24 Sep 2020
 23:54:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xianting Tian <tian.xianting@h3c.com>, Xiao Ni <xni@redhat.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [GIT PULL] md-next 20200924
Thread-Topic: [GIT PULL] md-next 20200924
Thread-Index: AQHWks4crUTVgPR5/0Gfs1dgknd3nw==
Date:   Thu, 24 Sep 2020 23:54:58 +0000
Message-ID: <AB173AED-FC49-4098-BFF4-CF94438CFA94@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e9f948c-47a7-4bf7-eb44-08d860e53ea3
x-ms-traffictypediagnostic: BY5PR15MB3570:
x-microsoft-antispam-prvs: <BY5PR15MB3570A6F7452390B5C5399BA7B3390@BY5PR15MB3570.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:628;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rikAP9e4W9FoGDGKAWTwAUkPWbJZ5cez7YzmnWf4Mp0sgv88DOfhgA9rmmF2XKEwqG9hKGkPGbp0hmO80m0QIVNS0V+XQcsYKKtWaNITItLQI90Qf/Mm9rL+r2Jy1oPjGNRE8d2l/ooVEIWz7Hd3xCj4ZC+SMSSpupn+z0Bn6oNUZMo+GSOfnq1NOnFGwHEDw3Gzcnxzu2oHSD2l1xg6+4qPyDpQeNTmSBgHY5SOYKA26DU6S5v3KrlLoldIMy3mMJpGFDSaj2cIi053LMPh9Mx82tfRSpUm4/xtyxsnZLdwcNbo0cDCPaz2dvI+8Jnd+Bi20Mtpdj3OZ+fVzhZxmLb6rtGxkxPbJm20ZO1BcN247W7hJgCHFHfXQs+Ly4LGgs9m+cyW6naY55I6e5bYOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(136003)(396003)(376002)(2616005)(5660300002)(966005)(4326008)(86362001)(71200400001)(8936002)(478600001)(8676002)(36756003)(66556008)(64756008)(2906002)(6486002)(83380400001)(316002)(110136005)(76116006)(66446008)(6506007)(54906003)(66476007)(186003)(91956017)(66946007)(33656002)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UFLYZWeIKynEHRDq81aVrITZjou0m8IJeJDkHqd9zfUcEsZ8iGOLxtMYJvyquHVsl81S0FppYezCWA23GzyyIuDVQNL/pPu75G0J2lB5nRY3eqmhYwnaS05qRq/7kjPJPzKMEbxiCWKdRewOufkT/uE+tm/3KJl43zwg89WEYKNt1yyuztsovDDn6dbx5ABN5lAqWFf54+5j21iL4RceYE8LHRjB5vEY5Frfpog5+YvAr4vWt+P7MesCGGZ9iQNt7XrkFPnIrbjAqEGMmdgLGlX0gD/HYaNoaGfNL7xoG5FUEDQmYl61xUHX1LxlZ62STPs7r5LX08ma/jkJ/5UrUwoWJsKlMejE5oPc1LGiuwShqDUkSZAm/xHBbnCHTp+XBsvVJuTBfnAb27ELG/g/C1wsofN97l0HxVDLR2ImARXFFvVWrLr5ykpDq5ps5xl9kkLucfWbQS1akWmGCCnDULlDFfitWlRsdL7+yPLi3XNw63EMWpACdf6p3VMyfeJqezwQsjXWnkfii8+UKQNgjelrbybLSrOPyWKyKzaQaeNPfV5Fnnte2Z8bnTJMsWvhNMzJzN9z/987/B8rWhRlzkNrDzthzA1OsD+UgxdGC5BKsIwJZGaeRugIIeW1Dwd9/aWf/LED+upZeCLOHdt+JxlgPATJpNeQ1OkBV4EQWHnLF6IXi425yzkrVUUHgh6H
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22949A47185F3648B00F587324B9F7C1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9f948c-47a7-4bf7-eb44-08d860e53ea3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 23:54:58.5723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f8rfyATzRt69cDP+kM7x4w/XVIYcZNgxCFK1st7oJCOF1zrcNyRErCESfeUF/q7laN2R7bv+W0QMkxqPaQzlbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3570
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240173
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

Please consider pulling the following changes on top of your for-5.10/drive=
rs
branch.=20

Thanks,
Song


The following changes since commit 0905053bdb5b7ba77ad0c2e5cfc4787c1db3d4f1=
:

  null_blk: Support shared tag bitmap (2020-09-24 13:44:44 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to d3ee2d8415a6256c1c41e1be36e80e640c3e6359:

  md/raid10: improve discard request for far layout (2020-09-24 16:44:45 -0=
700)

----------------------------------------------------------------
Xianting Tian (1):
      md: only calculate blocksize once and use i_blocksize()

Xiao Ni (5):
      md: add md_submit_discard_bio() for submitting discard bio
      md/raid10: extend r10bio devs to raid disks
      md/raid10: pull codes that wait for blocked dev into one function
      md/raid10: improve raid10 discard request
      md/raid10: improve discard request for far layout

Yufen Yu (9):
      md/raid5: add a new member of offset into r5dev
      md/raid5: make async_copy_data() to support different page offset
      md/raid5: add new xor function to support different page offset
      md/raid5: convert to new xor compution interface
      md/raid6: let syndrome computor support different page offset
      md/raid6: let async recovery function support different page offset
      md/raid5: let multiple devices of stripe_head share page
      md/raid5: resize stripe_head when reshape array
      md/raid5: reallocate page array after setting new stripe_size

Zhen Lei (1):
      md: Simplify code with existing definition RESYNC_SECTORS in raid10.c

 crypto/async_tx/async_pq.c          |  72 ++++++++++++++++++++++----------=
-
 crypto/async_tx/async_raid6_recov.c | 163 ++++++++++++++++++++++++++++++++=
+++++++++++++++++++++--------------------
 crypto/async_tx/async_xor.c         | 120 ++++++++++++++++++++++++++++++++=
++++++++++++++--------
 crypto/async_tx/raid6test.c         |  24 +++++++----
 drivers/md/md-bitmap.c              |   7 ++--
 drivers/md/md.c                     |  20 +++++++++
 drivers/md/md.h                     |   2 +
 drivers/md/raid0.c                  |  14 +------
 drivers/md/raid10.c                 | 431 ++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------=
------------
 drivers/md/raid10.h                 |   1 +
 drivers/md/raid5.c                  | 274 ++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--=
----------------
 drivers/md/raid5.h                  |  29 ++++++++++++-
 include/linux/async_tx.h            |  23 ++++++++---
 13 files changed, 967 insertions(+), 213 deletions(-)=

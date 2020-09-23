Return-Path: <SRS0=yBIz=DA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152B8C4363D
	for <linux-raid@archiver.kernel.org>; Wed, 23 Sep 2020 22:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B68523119
	for <linux-raid@archiver.kernel.org>; Wed, 23 Sep 2020 22:57:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="ibwm+4AT";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="KZOWe4hG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIWW5K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Sep 2020 18:57:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27912 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726537AbgIWW5K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 23 Sep 2020 18:57:10 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NMt0W7015985;
        Wed, 23 Sep 2020 15:56:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HpFh8UMh2HXAnhZSBn6sUzngsuQByqWfi/O2S+G37Wo=;
 b=ibwm+4ATWApEM5YtH0vDzwyFD/tk6DNdRkJlO72i5bLrj399V6PF6Odew5zcuJ3psBcT
 lV09M3vjhXBAfQqw/EL23IQvw2YFpBG21txE00s3Hf7yaadBdV7qIRO3gkjD5aTx837s
 KkNCycHApmJ3JMm4w1PFRSeqUqoFBl1moco= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp4eguj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Sep 2020 15:56:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 15:56:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/T8e5m+/wM+GoNf/aAwqeUr404LLCkdHtopWK6Cib5/LsxwaJMqIEWrD8gdlwXNcebPZ3IRsh0IL2UhQMtuOLtHp2C/h8RDm3NtL3tzcGZMaNF4your9ER9Kkn6xkpsxcjsGaC4nY0LsSWE2fcwpYaW++5B7eHEwVZlRvftqsKO5/EE0ImTwTZFbEe+X5aVOc08jA/CFKlew+NmfSKgaOx6Pd//ywDadqtFIHKEG9cwD82+PoaB00MkjjpUAVi8GnGzyk3tviEOjSn3t1WaSbjyxmWEhChQNisiJUn5YHPd4mfgmaid4o5Z4MVt3+owPeVSfGtQYQoNdTbXyHnDNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpFh8UMh2HXAnhZSBn6sUzngsuQByqWfi/O2S+G37Wo=;
 b=KPUE5RKxMr3m53ryG3XgmJJQq6EOvrauEY7JUjsPWXip0LStC84QFm1hYKkqi9D7Do0tX7L2Qh8MGC8TW8IE2VD+o0vskBfwJ3+ksNV8wAz5Gu5xsIMAyHMMVwVHZWeRej/YtrfLsj7E2EaE5KuSSqcTVX+FkH03fjRRfG7gYgIDpqSgDqdWg5fG+huzkRrddkfrmCcYVm4szjGetke0480r57L9VYD2vUj15uJqp3pURzdMfhjbHch25m0GcnByf1FkEccA+1HAq+wAyMZQEgLvHhf5u4JQxsrQHnKF/EkRCiUq1m3Lb7ps0rvIzWcf+4e0aXr43lQG81mjXKKTwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpFh8UMh2HXAnhZSBn6sUzngsuQByqWfi/O2S+G37Wo=;
 b=KZOWe4hGFFeZnxQlwx2RNkw2BcKQwDch1aSbtnavK3OWDm5aYRkknyBqvkQx8o1ILwojGExzitDQoj/6guJ+vzrPibiU5UjW4qFJf/qpW+5mvA/e+geCI7U4P+rgEPFcSGz9wDkXxyp4yRXgk+95iJRXbZ3EQGgwcL55WeFWsZY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3570.namprd15.prod.outlook.com (2603:10b6:a03:1f9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.20; Wed, 23 Sep
 2020 22:56:49 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 22:56:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xiao Ni <xni@redhat.com>, Zhen Lei <thunder.leizhen@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Xianting Tian <tian.xianting@h3c.com>
Subject: [GIT PULL] md-next 20200923
Thread-Topic: [GIT PULL] md-next 20200923
Thread-Index: AQHWkfzSMuvEXTiNXUqxFS34qHV7Fg==
Date:   Wed, 23 Sep 2020 22:56:49 +0000
Message-ID: <8960F87F-602B-40B0-863F-E3DE75ACCD45@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60f453e6-e2fc-4018-21c1-08d86013f496
x-ms-traffictypediagnostic: BY5PR15MB3570:
x-microsoft-antispam-prvs: <BY5PR15MB3570CD81A9472FF47DA8913AB3380@BY5PR15MB3570.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:473;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8j33jGoGqXPHX4fUBqxxmiSFNoVNU7+2h7mwFWrSJSh3vbjdVte6HlRH6iV6zakjoeVeAbcwcie3kQxy3GLud9XNTffzp5PuxlI2Ir/W8wl2NLvVCEdSXNVKdo5NsGN6L/UIoE5WwDON88yk0v+AJQodCbZSv5shmnGp/4xZSS/RiFqaRloLSpm1y30iGmXaGBHOhtYr61j6Y/SADfzJ6U0o/2yOTVzkRuKlz/c7A3f9ixzLQbdrnyXdFtF1VaxSZUztY6szW6eicYfbudjOqQgubLd0UamzxdITteSsNnaELpIQQDqtpZzAeo+PnNPFtLyvqnhhe7w7xsN+BtKMeDvKCctuGvpTZBZCHxet8NTGxVZjdjpjh9+NXdFD29ljcehSEqAPgov3GWF1aIn8Uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(366004)(39860400002)(110136005)(316002)(36756003)(2616005)(2906002)(6512007)(6486002)(83380400001)(33656002)(66446008)(54906003)(66476007)(66556008)(64756008)(186003)(66946007)(6506007)(91956017)(76116006)(966005)(86362001)(71200400001)(4326008)(5660300002)(8936002)(478600001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JSaREjk2gFSsibXfpgv3pAC7XmCF8E7wJiEFhhsq586wwAVyiyuH248Tdcnnrx3oZI937/xF9DcZMHoFcG0cULPoABPolv/M373JVz/p9KjYEEzAanZD7Vxw/B1hxO8rD5DfESr3c0SE4lfu3OvnBvUG1Yq3h+HKyWDcRS0JlsjdTSXGmGx7HPSKADZ0F0xb1R3L09as3QiwYTdo1jLYLKLTT9d0cD2OdnXEBaF/NpbEsXPGQ6pzIFljMn1wiZVrQJX+gueL7u5XNJBn53sLZX6E1ZGb/PtCRhbjTqXpIQ7ITtRKO+9gIeTOHywlziun496G6qmGjWOkIOGkdiuLQJ788+mNdqaUxUWVX9r0LmETZLV2H/TN1wWxUtxmNp3fziPWPa66RWJvc8XOmlbpo6rY3kkyB0Buvc6K4pz7eSVzBFMDDQmTcNbf4YDwQuojaOXhXDROPElsg2VS6UavlWCvnSTWbebQgEfZGig5cSngfPK0f9vj5DGBg0qtI5zZLiHp55vgX5/dBwH/hbDFWxon0BLHhPp3vASfBdsvrpUUJu+IpEXIhz3PhXuBK2fGFEtbsAmC5WE7A6rVdXhO4dEATmjSH/EWjFYxjtlBH8RTSJwYVxV7CNyUXQJ6hEX9G13dA/BU6xtkWk5VMM/qgXph6X15P22wYPBowbeufUj4DU3/J3xbj3swwueeHCO7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A7D7974294802B4292AB6486AC8F75B9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f453e6-e2fc-4018-21c1-08d86013f496
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 22:56:49.5301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8kX+x+ZMNte1oieJxx1G2PuHdjgC0lUlGKhrlwZ7XLRlfW4RPqPCLed24l9nGqdS+JvM8w30qYNexuwEciBJlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3570
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_19:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 impostorscore=0 clxscore=1011 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi Jens,=20

Please consider pulling the following changes for md-next on top of your=20
for-5.10/block branch.=20

Thanks,
Song


The following changes since commit 1fb1a2ad75e33e646d33e42b9ed17d879d472859=
:

  block: mark blkdev_get static (2020-09-23 10:43:19 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 10988d55ae96b673332127da4bc3adf5ceb8b370:

  md/raid10: Change the return type of raid10_handle_discard to int (2020-0=
9-23 15:42:40 -0700)

----------------------------------------------------------------
Xianting Tian (1):
      md: only calculate blocksize once and use i_blocksize()

Xiao Ni (6):
      md: add md_submit_discard_bio() for submitting discard bio
      md/raid10: extend r10bio devs to raid disks
      md/raid10: pull codes that wait for blocked dev into one function
      md/raid10: improve raid10 discard request
      md/raid10: improve discard request for far layout
      md/raid10: Change the return type of raid10_handle_discard to int

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

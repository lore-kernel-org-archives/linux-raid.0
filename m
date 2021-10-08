Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A40DC433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 23:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA15860230
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 23:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243835AbhJHX7X (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 19:59:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32106 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243798AbhJHX7X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 19:59:23 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198KAA7q022208
        for <linux-raid@vger.kernel.org>; Fri, 8 Oct 2021 16:57:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=vqm1nrwM+h26Tb6P96PoiGRgMv6ygwa0kr3bRr6E0pk=;
 b=RkUeQK8ebA56LaEzFVYnSVBvjvq+j5livzN7MYiRhsRfHo2rX6fI95puAXq6nyCGjFeT
 EPRgocvHut0nAitgO3lhnBdYE/0AydohipVWwbkFajH/s6tX6RZWUX99f0KMK95DFnIJ
 DBGtcKpPgFQd497AaFiaUdUjRS+a4ce1ttQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bjvs9s83m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 08 Oct 2021 16:57:26 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 8 Oct 2021 16:57:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bllkKp98YOgZp45xu+mzSg8kqtgDgHYz/iYaPZlmsRUREGR+7xe5Y33fe4u0XQpmrxhdEJZcD1sO4L+bxa9opcrR0DaBAiMfenI1HcXghTlenA3Rueh6rNsdCzXLHAtIfH0UuRU2Xs6wnK+fhgKHqPPj2+SqKLyr6yTmJsj9K6MUUwjdZTm7vG/FrpxXaOKKiJGN/wofmPahK+fuaX2GtYfyNBYq+F+i/sBNa6zxUREtWl6GpMa5bnUzVYKI51O6P+88PtpTwvvGbolYySk+GRzNLKLXEfL2ieDHKBH+/EwhAggnXTQEaSvqWyjiS5gNhuO4MpBzq26BR6dmK9NPow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqm1nrwM+h26Tb6P96PoiGRgMv6ygwa0kr3bRr6E0pk=;
 b=MQoTOvebgdXqa4yUv3D/qPiIfSpi4FApDSGwStTXRldt+sgC+o1gOEo9CeJTG+hU0sApZlozmitt8L3fC9sCo5QkMGGyV5ul/Ejn/OzlzSioqCH8L2C5hX2aMC3vYvX0Cc53azy+R+rRqmQwPMDBeTtx79t0VR7nlMd69gn4zTCZUv4ActeYM92uKWZmIa/dJQXzZ09rp1HVoYM0XOYUyVRRBmLA+lwB9DqZEy31h9RsUZC3cibgwTUvYsUYmm3uSox0G4ciCPhDWg/bo15EBTWfqm3pA97bC78nGwwqS+2GsjMdGNRZ4I/g3t2OJJtrRFSoA+entPx0wu73PSE2xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5186.namprd15.prod.outlook.com (2603:10b6:806:236::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Fri, 8 Oct
 2021 23:57:25 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 23:57:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, Guoqing Jiang <jgq516@gmail.com>,
        "Luis Chamberlain" <mcgrof@kernel.org>, Li Feng <fengli@smartx.com>
Subject: [GIT PULL] md-next 20211008
Thread-Topic: [GIT PULL] md-next 20211008
Thread-Index: AQHXvKA9Mue82ixcG0elsjN+rWqjFQ==
Date:   Fri, 8 Oct 2021 23:57:24 +0000
Message-ID: <3ACD8384-A1C0-47B1-BF6E-CFB9600370D1@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8bf44bc-326a-4028-f6c8-08d98ab7605d
x-ms-traffictypediagnostic: SA1PR15MB5186:
x-microsoft-antispam-prvs: <SA1PR15MB518660264D912B32D625A7E6B3B29@SA1PR15MB5186.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rcHUwhDD199n/IkBXnZ1tQBVe4+1oJOXc3R+OfKMGB17J2rbaAR6RjEPMKCFKxO8Hph1n+MJqZUuKxvbgTcsUd/fXB0qmKWQKhvjTYjIRp/PZ62n75GU95aCvM1mT+pUCrQCUkrboUJhdVpDx9yQ0zOnVZSbzRDjVvHZ0y5qjoLY5hRiuJ0VXzK1ys0MoCs0F1PH/9Dopx7emwSY0tHeRw9+UHNg2N3PakEa9d2KcskHV0T0ip65psoa3F5Ad1MdaCeEyfkd3aZ7JuCKLo2usSvyMUaTu5p1Fq5ubYpwAkQzRlUoH3Nn+SDSXLPedS1MEeeuABrbCBIfCNUz+hzTGgIVXGqjPgbvHWMc18KfwlbzvtE1Z86cuapcL+b9r6j43KQhkwGe4s380jkRxoMmhzWEIWsK9Flu5rpgIPeDaS24lVte0Ft+qg+9RwR67lnloSu9ky207wCclY2L2Ilk7XFFI/OwUPkiOXyUGVu9uAFvsT7ovM1pJAtI0xxlTMP+qEnPcjB2cHI+yJ4w0XJxCisHT+nCE2yypFUb4mRwHxVP/h5xpK9h3mgDDoH5rfS8Hjq3QJZxDUADkYYrJQppE9eWzPG7zid2LW+Tzc8TXbjdBWVTZ4Kj7ZBxL6L2cGCX04Sr5nT4fGKEf6b2YnvN9u91v/b70Vwwi6c0Kq0kvyUc22u/sKqEEr89KmIio/OlfHg9lHoIQLEnc8MoIhG5BT1TbrnAESfukF1ZTm35WPzfXt9uYXQeKCDr0AbLWSEQLo8E064B1yaRklrj//QWzkswVCcbwEvhJgBi/6rbE7We48w0OWjUgOUIckGep2i7onghNKYUYKlVOyJZ3oP35w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(91956017)(38070700005)(83380400001)(76116006)(966005)(8676002)(122000001)(38100700002)(316002)(110136005)(54906003)(66946007)(5660300002)(8936002)(66556008)(64756008)(66446008)(71200400001)(508600001)(66476007)(2906002)(6486002)(33656002)(6512007)(86362001)(36756003)(4326008)(186003)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uR86667HcIGPdgTGTnWpWAKZmkr7KUZwL4Clf/TdEBUeEnRp3CtGJNqLYGOy?=
 =?us-ascii?Q?q9c5X82dy4hfyh64zyVPpHx3pAngrbNHG7mXyp2Kuom8QanX8bkJYYcDUbAD?=
 =?us-ascii?Q?TbfEziClK8eX9q/cATxYjZKNDf+gqDKySqg1g+Lom2ahDv29qMYfy1JUjmsy?=
 =?us-ascii?Q?ID7cktD/BQPHILtd/23QBURTM5+dEzXfggLKUNNWXzzzy2RiuEgLuJ2hEDhg?=
 =?us-ascii?Q?uhBkcCsnew19ldEWnVVIwT0B7Jn6uFe3D53AWMEmKvKwB3oEkiLYLhfNiXGw?=
 =?us-ascii?Q?PqwAbrKpiYyhmZ04hUW0IifqhAdi72r3mo2qCukheR9VL22mH+eRds2O1um2?=
 =?us-ascii?Q?JUMWTHZvZNcy1xJzEuXyP3wBg+C0zi8cEQ+ITV22Rh5Ja34rMWnLyXWJyd7C?=
 =?us-ascii?Q?L6fOpN02syOJpF0olJt2BVo93IOmzqdqDGDL4uwK+OfIZaO7IX5AVvT1bHGY?=
 =?us-ascii?Q?363Ujj2XqDHwKzMDrPdzctx3Xn180Cu/wqaWYh8hHlLrmn3Eoh1M1gFBNH2W?=
 =?us-ascii?Q?3k0vfCO7JTTs34hCx6ldqMRwA0ei/Bn6lGNKHmeLKtuUiKIHI/DeMDTqJZyD?=
 =?us-ascii?Q?URtFsXH3S61zsMicdBQ0Bg766gO7I5bt7zw2d+zScsKN09MHWuSDYdXIDCR0?=
 =?us-ascii?Q?7ntWyU949eKkkM1ox7UsKUSpDRndA6jOY+It5S3PhBLBqXVBTyUDLJkv8Stw?=
 =?us-ascii?Q?sMGv8ZHz/DoWhk/E4ZRbv5hW0JWYwhkB8v3lygN9QlmVAA+DyF3YcajASy7M?=
 =?us-ascii?Q?7i0C0j9lmJ50iAMDOkcJqjfZyeCZq0lzxfixk5BSE4InrAJktbugTji4VwgT?=
 =?us-ascii?Q?9WQd9wyGLRObjMu2KPZVSwMo0aigCLW+eglFLWEnEuGmxI0DuYKkWA4G3+7x?=
 =?us-ascii?Q?Sb0o1DV85Dl/3HMmtpWYCK+A3XVIflo8D8Gv8ZHKjZiUEKVQreiFUUMD8dri?=
 =?us-ascii?Q?MAZ5JvCChkrqc+K6N3E2VFfrAKKQsqa+cPgRy87JinnN3772wwvGDYMnC4p+?=
 =?us-ascii?Q?yw59PlOfYeU98beYyAgGQuhrsUMxgSKQpysJq7fRvza+ZE4ybYzC6bYCINp8?=
 =?us-ascii?Q?r+cUgZfKrrrVwG+Tb0yZwnQ5xjeUis3XnE4sqy8i07bN/jIGwAu/yKKQVa6r?=
 =?us-ascii?Q?XUuvcKR1bcdmvR20M6/HrUHEIW0QEYO+pXQ9yif3htyvgBKHAHaIsdrvw30J?=
 =?us-ascii?Q?+iJbrX9jmMf7ibSKOoTzl6gb3qaYjRQvlKD+XxPXbvOiVfx7gJ+F5pzxVKO8?=
 =?us-ascii?Q?qaXwaLH1wjkNby8SSUwpL2pP0IulO0iFElVa9niTIfhPKqw/joROOPVTK9Xa?=
 =?us-ascii?Q?vR/u+GxV4LzU+CGPT9QfiA89lOmoyIMWUInqm/snmKeyT+hz7iv2ifjJSvb4?=
 =?us-ascii?Q?YYwsKNc=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <004D3A63663E1040BC501B551A0C2B51@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8bf44bc-326a-4028-f6c8-08d98ab7605d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 23:57:24.8441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1X08mtd5Fzzqey5p9cKp3wI4sRI/P5iVNl08FqF+VXJ9UOyUEISnvHXRK1RbBvorPP86VDCIzRilv4v3WlanLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5186
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: KMj8MEU9e26avTD5fXIBRSc-gogKYYqC
X-Proofpoint-ORIG-GUID: KMj8MEU9e26avTD5fXIBRSc-gogKYYqC
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_08,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 clxscore=1011 priorityscore=1501 mlxscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-5.16/drivers branch. The major changes are:

 1. add_disk() error handling, by Luis Chamberlain;
 2. locking/unwind improvement in md_alloc, by Christoph Hellwig;
 3. fail_fast sysfs entry, by Li Feng;
 4. various clean-ups and small fixes, by Guoqing Jiang.

Thanks,
Song


The following changes since commit 7ab3cc9cb7cb1583faa3de1406b9efa3328123df:

  brd: reduce the brd_devices_mutex scope (2021-10-02 07:28:36 -0600)

are available in the Git repository at:

   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 2bb33192d6a707aa20f43ea865892b448dd298c1:

  md: add sysfs entry for fail_fast flag in RAID1/RAID10 (2021-10-08 16:31:50 -0700)

----------------------------------------------------------------
Christoph Hellwig (3):
      md: add the bitmap group to the default groups for the md kobject
      md: extend disks_mutex coverage
      md: properly unwind when failing to add the kobject in md_alloc

Guoqing Jiang (4):
      md/raid1: only allocate write behind bio for WriteMostly device
      md/raid1: use rdev in raid1_write_request directly
      md/raid5: call roundup_pow_of_two in raid5_run
      md: remove unused argument from md_new_event

Li Feng (1):
      md: add sysfs entry for fail_fast flag in RAID1/RAID10

Luis Chamberlain (1):
      md: add error handling support for add_disk()

 drivers/md/md.c     | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------
 drivers/md/md.h     |   2 +-
 drivers/md/raid1.c  |  13 ++++++-------
 drivers/md/raid10.c |   2 +-
 drivers/md/raid5.c  |   7 ++-----
 5 files changed, 84 insertions(+), 51 deletions(-)

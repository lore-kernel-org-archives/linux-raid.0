Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9430C4361B
	for <linux-raid@archiver.kernel.org>; Wed,  9 Dec 2020 22:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC0423D20
	for <linux-raid@archiver.kernel.org>; Wed,  9 Dec 2020 22:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388446AbgLIWKC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Dec 2020 17:10:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41372 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388403AbgLIWKC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Dec 2020 17:10:02 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9Lwq36007201;
        Wed, 9 Dec 2020 14:09:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sWat5vmhJF6t6sRbTZef9uMqfUBNHYZSnE1sOTU3Fz4=;
 b=N2LJ5DlBkQ1dKIIsYWlbdeYTiFZCFww8VUuPYcBzDTbzkJRzz+e4LSqNouC5x/zTcVjR
 qI7OxN/12G/wKhk8jO0BDMtMVFIsoHFmdu7V0hni4V4SCRtXfuIVHKDE7wkalx5/PRig
 FUS+Ox0tlQHBnuGW4Dncjw4QS518wAFTpY4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35ak7a7wvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Dec 2020 14:09:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 14:09:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GoVJzziaUyEg11ySRf+jlFgUKskb6Q6mmuRXp8tQwDFCFAg9tyC6z4Mv51BasfOv1S9Xbo1U16QT4GsEQKQFh5HhhQ5MGYpioMwhfqgG3F2WCl7e8VcR0lMynldg6yxndgSvI3b8o8zov/U/LQmhMT1TbB36KTX7Wa3ls1Nr6fFLELcys23nL+sEKjcB3/jsKRx4XLuA94H19UKUWRT+Zmqpvws0nJ2FmCt7tAUtjUKZqAsaGiwwMTcANDvJXV3HzNumT7OhWWFkVVgOUtu68/IC6quIKBaUeT/EbqPqmHi7dYE7B1IQQsmPLtufHFFvz18gqWaKr9bUXgRKF7wA3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKQNILjjBnUDYWgQ6HyMjPvpn8sDBt0LjuEXnKY/9xU=;
 b=lhIb7htrsn1MNSDS4U3xcOahJokv2IlqnpEnhSL93BlPTqcYud4vOViKgQ+h75jUznbrVs8ak1PHdgDDQhROBi0gtMf0NagfHpKyUqyxyb0XkvcQpJ8Ahk8x1umaUKZ0AUyQ1EA8lKciqN/Rlg306UYbLScZQhDt1cssiC0IoF+n8+kS/X6DPBTnUf6YH4xA9bjhGVLNx27xkuiTS9YLA1ILurGx08kAV17Nka03pYZzN/OHH6VnV7lTD0R0nL+VYf6w7QfukHQxSi16NcD032ofmWquQqv1pkfRcyeNeCjrXU3UybJIVnVkdbNRhf8kWFNagBgfGa2zNlypDTq+SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKQNILjjBnUDYWgQ6HyMjPvpn8sDBt0LjuEXnKY/9xU=;
 b=EUTj+MveTAUgeh9QQbzmdVaPyjHDaeQyJwKlOnOqnvMweq7gqEbxoT88Z4gH2C9BiwBHWoy2FE+HeJ3UTk5NC2oZWM+ZxsjpDvgu7IJprtvDhB60otDlCrX4UT07P9iWn/JWogX6+CJtMXuzuFLBV/Z6qVmx7TuvAfkEyiYLOxU=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2262.namprd15.prod.outlook.com (2603:10b6:a02:8c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Wed, 9 Dec
 2020 22:09:15 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.012; Wed, 9 Dec 2020
 22:09:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xiao Ni <xni@redhat.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [GIT PULL] md-fixes 20201208
Thread-Topic: [GIT PULL] md-fixes 20201208
Thread-Index: AQHWznfuwTuyj/ktHkW5mEzn7LyCGw==
Date:   Wed, 9 Dec 2020 22:09:14 +0000
Message-ID: <1D36E148-BF3D-41D0-8361-746FCD524C5A@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:d023]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f36b3f2-5b63-4440-9a6a-08d89c8f10dc
x-ms-traffictypediagnostic: BYAPR15MB2262:
x-microsoft-antispam-prvs: <BYAPR15MB226262163A2E2E9735C5EE0FB3CC0@BYAPR15MB2262.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p5mzxbh2XL8N8Ibb5eoaFWWMZhqc+OIYJMPR72IE3QgbMPUnxSapX/lP5a45VS1geeO5KPOT9c050MdKTn5fdoWNjIqa04ayNCs9uw4w22XaU7svWSOAWOKcolsGKQFY4Zeiuzd62eR9sZCxvwiM1TSulEBGoh0jO/cp3LxujcIVHDuAmemN/eQ7KH60sPq5eAWwdrWtbMlxmjQSUzUFvkNAVvYmzPH7pR5Pyc25II01ON9UNm6d3nM3wUx2W3JZKphFJ8+zRaSaBQ9tK1bMim1NfFndVOlq2uzcq44hXcWUopW3hmIEArSfg23MhmR05kQzA+tI/QhJV8EGiJ14SreJYedLpmGb6v94KnLYA/O0eIKGP7H7d6N9xpNtQIHFjycKBOAV4zvvkOC2AGaomeGPF3Ig9KtPWx5Yig1gxL8j4EGExMWB2CJANeCjB+zJKimkMt2UnAF1L+KKTo8WTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(33656002)(66946007)(66476007)(66556008)(110136005)(2906002)(71200400001)(6512007)(2616005)(4326008)(6506007)(36756003)(66446008)(76116006)(64756008)(8676002)(186003)(6486002)(966005)(83380400001)(508600001)(5660300002)(8936002)(86362001)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ErMvHP3sJf3qnFSPjKz3OWEJsQGoxUtGhJgFxgv/E9iqULBn/sBHtha3kxGK?=
 =?us-ascii?Q?D392+Ko2r+ru3Donatm1F1Re/qjHLpKEF0QoPXGrlgyOC115ZWggwvaeWEXP?=
 =?us-ascii?Q?dCYDnkCmnC3k5/gqIF53C3KpcwmvdLfZ0T7I0U0hQiMBMKwMGfNF3rpHdGAC?=
 =?us-ascii?Q?7YL1OV323A4Lc640sVfpyu8D7wPu4wWt+V3GigqImA/7P7BrmfbvmmBgpY1k?=
 =?us-ascii?Q?Opvfx3NhjKeNx0UiwYcV7Is32gkbFPxcWzts9hAWfYwO+kRdGrfvRKFLuj4N?=
 =?us-ascii?Q?VG4hXtCPhxwnzr0+3af4XItLRqZvjwf7GF9BmWSoBw0Gahr/22Ce9c/8eFsJ?=
 =?us-ascii?Q?rIXFjHAr6e1Q+5+hFqhPi3WAzGiBaocsBjFwEMvTfrLNSoeQ2gaa0TtrkZyz?=
 =?us-ascii?Q?HJLaVB9FZtgBS9qFkwSuGt7kADYLESB/k6m8UXwCugAwwMYLGJOAcWxmSURu?=
 =?us-ascii?Q?0utYG1d+ynjH4U5q5j8XrXGvs1HOwHjsBj880wadyiaDyqZBPNpxqGjz6wvL?=
 =?us-ascii?Q?FdnaZOwDbLGvPyF15VJwyzC4udtrnbCaCdz1aMmC+ypudvRFShcHXFOkkFf5?=
 =?us-ascii?Q?edH1RxdFs7eh9fo8o6VOn41KbrvOUq2nxRbpCHtC43x3Y0tnp+TQswJfLyH1?=
 =?us-ascii?Q?SD3JE8ESajeNiQ68bN+2DDFs2bwCNDuXno+lSGSI3GJ2jN2dmCyCEi9SbhmA?=
 =?us-ascii?Q?kt0LtqNxHoMygXXd+LfPESjF0AQ8l7jdwwHJdxJfDC8ViDI3Gbd0DYi3Lczs?=
 =?us-ascii?Q?hOspEtmqUr/uuGJQtf401RZUul70y+Tt3bge6rbBHh+j1QiBofZBL9/jhHDJ?=
 =?us-ascii?Q?WcN/V6b+A4+vQXiD3eBzFbWF/KxihAy1+/NtMygrnUi0wdJNhWaaCydM4vtW?=
 =?us-ascii?Q?VJ1r2H/m07kfx3IfHBPYdNjl3N5Oaaq/3FocBqcLVTNtNWTayePfb3GtbmfI?=
 =?us-ascii?Q?Fk4CDLq2+D4+sP3AZfrRjUe7kVBjbtYLKz3b8GiyOahDQedVOskpnSqzABhf?=
 =?us-ascii?Q?rmk7TF2uKEjrpQIjDX7yKpTUcxuqREI/1nKkMKlNhOxGqIg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4477037366421740B1A35F8C8DF40FB1@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f36b3f2-5b63-4440-9a6a-08d89c8f10dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 22:09:14.8865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +SuhxAWhbQAJs6u3bEyWhyiNqaLc0NOHgnQUPefts8zc04fuPLVHrQQ5vUNvjSq4htAy6R8lYHlJXDEGZD8w6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2262
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_18:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012090151
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following changes on top of your master branch.=
=20
This is to fix raid10 data corruption [1] in 5.10-rc7.=20

Thanks,
Song

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/


The following changes since commit cd796ed3345030aa1bb332fe5c793b3dddaf56e7:

  Merge tag 'trace-v5.10-rc7' of git://git.kernel.org/pub/scm/linux/kernel/=
git/rostedt/linux-trace (2020-12-07 11:20:26 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to d7e34d25b3044e227187783a6d5987d0b0325565:

  Revert "md: add md_submit_discard_bio() for submitting discard bio" (2020=
-12-09 11:44:42 -0800)

----------------------------------------------------------------
Song Liu (5):
      Revert "md/raid10: improve discard request for far layout"
      Revert "md/raid10: improve raid10 discard request"
      Revert "md/raid10: pull codes that wait for blocked dev into one func=
tion"
      Revert "md/raid10: extend r10bio devs to raid disks"
      Revert "md: add md_submit_discard_bio() for submitting discard bio"

 drivers/md/md.c     |  20 ----------
 drivers/md/md.h     |   2 -
 drivers/md/raid0.c  |  14 ++++++-
 drivers/md/raid10.c | 423 +++++++++++++++++++++++++++++-------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
------------
 drivers/md/raid10.h |   1 -
 5 files changed, 69 insertions(+), 391 deletions(-)=

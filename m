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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10135C48BDF
	for <linux-raid@archiver.kernel.org>; Fri, 11 Jun 2021 02:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E276660FF4
	for <linux-raid@archiver.kernel.org>; Fri, 11 Jun 2021 02:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhFKCzJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Jun 2021 22:55:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38732 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230377AbhFKCzI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 10 Jun 2021 22:55:08 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B2oDqD006061;
        Thu, 10 Jun 2021 19:53:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fdpMQOWUo65t2KcQbMxjMZ5QFJYkv4/DYDIefWn1wHs=;
 b=dSGqtFAZV6V0RLfetd5IykXlIJe7zvxV5dwaVB7B/mkPfabzfM0Oe0VQdCdA1w12i42v
 B1eQlddRbYsY/QOqW/Wt3OXwTq+StwD4qhjwUIDWrLRLEHlcgZJxrafiAQ/EDULY7aiw
 aOEta9TFj76lzVwaAfIjp2lvOP9QopWarAk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 393sf9a1m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Jun 2021 19:53:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 19:53:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZgywUZIdCNkq2ANMgWfYdqWTu0Bjk/FoYKuxkteC0HQj8WoVeCq1kmydMPGYZJP0HgT2dGjOTQsTdsVxpqDNgUjkXJDyi7d+udIPvrlTeDQSRBKqNBQJgemqznG8Ti+eTjJcIjvUHEK87f/wn5Yf4AqKiY4WS7yt8oi3pDU6VXo0avl4JsnCGIwZN6W7RLuQfmCr9esIvvlwrhj4hZzWVcI8FRCMwRWCKcD/ziBsEorW7X6/MnKxjyJ78GmVTNB7RQOA+tuJkAYjTSlHnBBLWFwHWOYKoAcOsfU6GJG7kKW5yfunCSLhDVi0VGDDJL0O8ZiStdEOBlKA3vpbUXamw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o42KajHlyRbim3ThTQtLfhym8Fd0ROaZFzPYWmCOugE=;
 b=lM1u6vOngqk6BZXjggtbv/HpvW1rbHEOFIyNqCOPxGjZkuBO7134Ih4n3qkHiFTUOI+xUWOv5WNLz/NGF9QX1dVSawyou3i57D6lIuAs4rog6BvMDG74bu/HyvXZje5kl2qeatJlfVwS/PEUNmIHGmLtTL6VxFhpcy7BU/msmXM2EYHCyl4cQO3aJi+z7QTgt1OLQ+S5z0shUcZtWn1h1yfFVXCKwSDcncoE67FkLkAHOirGhvxLBKKPLLq7GoH4K8cN8S9eG2b/1oU/CRgXazPq95mQ5QYO4hlt4+R08aLFCj2bx0O+4sO4W1XfFUBr06p+/t6N8bris8lk5+k16w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3206.namprd15.prod.outlook.com (2603:10b6:a03:10d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 02:53:02 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4173.037; Fri, 11 Jun 2021
 02:53:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
Subject: Re: [GIT PULL] md-fixes 20210610
Thread-Topic: [GIT PULL] md-fixes 20210610
Thread-Index: AQHXXj/AIu13vyJT00CddsqIubmHJasN1H0AgABIzIA=
Date:   Fri, 11 Jun 2021 02:53:02 +0000
Message-ID: <1EDCDE82-77DE-48C3-96ED-139591C5687E@fb.com>
References: <7105FB78-55FF-41EC-A84E-6113512598B8@fb.com>
 <05d5f3cc-3dd8-6054-d939-7e32d9de53ad@kernel.dk>
In-Reply-To: <05d5f3cc-3dd8-6054-d939-7e32d9de53ad@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.100.0.2.22)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:a097]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c7392b1-d0c0-4b71-d7dd-08d92c8407b0
x-ms-traffictypediagnostic: BYAPR15MB3206:
x-microsoft-antispam-prvs: <BYAPR15MB3206B8658EBDD81D30577866B3349@BYAPR15MB3206.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U/Mocu4ekDkVRAwsAa4fqyJ/Abm5ajtLwU7iPtSFCfIPRsExefIrRziBMLllaJiXROHk98VZjpaTO7WKyvAZFtvyApULbv2oUBx+z6whC993SXNDvW+oWDVMayP4inf+nnHE6Nsw8bSxCFMKYmHHau1WrSFM/nDaXHNbwqI+VkHWRMs5pMmGcVCyww3kekEdeHp0EsyPbo7n9kw/+HWE1XFaeJWItNzOAnlxLzhCfrnWe34sOBB+0UPZENeIsO+7sBWIyUbm7hFel7cDc6jKiqqK3HzDOEyPy7ugxYxte5cE8W71zQqbCyAdRhhG2ySY6f8+uDc0NZhuKHesxOYEjYRsJxERs+9GKjsoFsoy/H5O0VJbyazBE1UJnBFrnPMInps+pURUwJlFpjjb8giZG4Hn5c2IG8Xt6t4Y0S/lUWAk9jOi5B6Q5S9Cl0y4NJo0e8XUj07+PKwrJv25BmxcLP9GMcKmZ3g/aHgAW+Ad13CNotKtB8bv5aHJo7cIbK9l+S9KVc5lCgu7Fa7SDM7xIoaT57NMEs5GDEhBYW4F2zTMaAw4EQcQqDo4kNImInMNTLB00tMUDm9Xu7MVgxBMJ3UDyAGH7Q4WClVZKwpZAgXvEZwCNJcbKezPtNu6jN3Z3Ona2fy22H0ONTPyHsMzxY8kpc01IrNx9Lou7gwYKZk6UHkk/Z/+2mTDKjtpOxQLAFF+LWFb/VJA0FTjyIywi4zKUua+c9jJK/jZjvTpj+Jdw3i5YNnXKFuAaBi/rDoaqnkL/+S1BVT/sJdDn8VX3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(6512007)(71200400001)(66476007)(966005)(2616005)(33656002)(83380400001)(122000001)(66946007)(6916009)(6486002)(5660300002)(8676002)(316002)(36756003)(91956017)(2906002)(86362001)(66446008)(76116006)(4326008)(8936002)(6506007)(478600001)(38100700002)(64756008)(66556008)(54906003)(186003)(53546011)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BXBO9gnKTVgTbvZFggtJdsn+kxJOeYzy7gEVJgHMm//5bocTcoZrh5/Tz6Yo?=
 =?us-ascii?Q?U4CZr8HNDOOZPWrPWB3Zr0i2ge0oIDs70lywx0QooRlH1uBYr0EztSHmU4N6?=
 =?us-ascii?Q?PUUWLScSE7TKE6ONUppC0e6oSmRzykleu3Bl5K/h2KJDNofkRqM9Bc1sW6dZ?=
 =?us-ascii?Q?sXVcIVC6iYekyNbFzyGqTOveVkK+zSa62cYjPEkANECMtxklwphdtN0XBflS?=
 =?us-ascii?Q?+Fy8yNw7wybUG6HbWv7MtH3XwpDuSOTRNCWX11yEhXe2hJfZpgqCmg/PRZhs?=
 =?us-ascii?Q?oz2j/XhS6JfuU6Bfb8QPIDDMWLgJ5b2QDAcNRd8kA4f0DrcYVgXdPrqBM9lT?=
 =?us-ascii?Q?FuUYU8FoydgAt2B1ql3edRM/AEPvhbSimu46dqVkEEnRkrkcdjtexMB+UVpS?=
 =?us-ascii?Q?HeOWCIZSYrr5ILTv29m1q2aMU4su1q87Y42Edeip9dIm7LuVgOgAu8UCo4KP?=
 =?us-ascii?Q?lN9BraBYpD6FNUbQ224dZQGTU5REXZlVr9YgwQkCQ4hU4kNCmQ3x/HWMrYuu?=
 =?us-ascii?Q?nzV+/ZXczQgPQGUJ2UXnuK1bgARb6Ikw9iQwyGncOrR9oIwIFOeJE2upGXg1?=
 =?us-ascii?Q?1S1ZAsUWPKbUyiUDA1F/IRkd2KFvIjSaRM39vhQU4ghF+sqprgOg6wQI2yJk?=
 =?us-ascii?Q?pvEZsDqq/QQLq37NfaUqjgo1C3ZuVWLBHpTuTd6EoXS5MU6fLQ+8Kpu4SVLi?=
 =?us-ascii?Q?dBaY7O1p29+n8McDYGL/aP1Uc8s6aXBQ6jYSigPvO25uB6YFCWktQ6cVIFrM?=
 =?us-ascii?Q?UVw3cMT7Mh82c71n37yF7lRNAYV7ud3I/IrX+MpbyZEmg64wIb0C0hiOZqIy?=
 =?us-ascii?Q?ebWvmjdOVMA05YOysZHqdOSpkwBe/XDFbvFKjWzbvIS7kAiHEAcTEPmoX+Pk?=
 =?us-ascii?Q?fYOEBsMAISEVAkaVGByFMX47Yi0vypU2MIpomVK6h29iR21cY8NqPcweY9LN?=
 =?us-ascii?Q?jH+LEco7NaObepw8cAJZdxLxKkrnx3jgjSJ2xR8O9/HhZSYJ9ZUMMub2yjV+?=
 =?us-ascii?Q?F0w7yVuD/waUnt0FdAUuT56bzF6RKlt7JgMT10AFwq07QhuyXzTKa/ztDvAy?=
 =?us-ascii?Q?e+VFrqwaoGDFiIyv20gzTyp25DKOCAxDofg2Rh7lA9r/Mu4gc2Hk9lBb3db/?=
 =?us-ascii?Q?dZ6QawOA+8cpTyXBsksPWTZgGiZ3rZD1mCvc4ReUMjADutcOtF8JnBgUp1GH?=
 =?us-ascii?Q?BkBtQ3TEfYsaMhpbJyH+IURdoE9hSA1uY9EbLZNZgO45/VE+fRxLB63Wr6dx?=
 =?us-ascii?Q?FPmIA1xVAxTHeyzyTbLJ28GOhl30WhD64nYtFEQuk3BKQJop9LE8pp8mVvaL?=
 =?us-ascii?Q?y1yV9hDVMaBohRqSXy0JXvJaFudAU4IZtjXbfKfmT/zH4JIYEhtFFcyU10ja?=
 =?us-ascii?Q?KdZijJs=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A6A42ECFEE9B8B4F9CEC084559A0B8FA@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7392b1-d0c0-4b71-d7dd-08d92c8407b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 02:53:02.4032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 708LL0FGmErP4oqStGWGdh3cNHwvj5Mk7ZQAStH30nXI13gDJ9iWA1SApV1zT8CuIIE3kqTK54TJpFcZmXc5rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3206
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 0dYb6MUolWX40QbEHZ2q0WOYVz-2GR4B
X-Proofpoint-ORIG-GUID: 0dYb6MUolWX40QbEHZ2q0WOYVz-2GR4B
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_14:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110016
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Jun 10, 2021, at 3:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 6/10/21 3:29 PM, Song Liu wrote:
>> Hi Jens,=20
>>=20
>> Please consider pulling the following fix on top of your block-5.13 bran=
ch.=20
>> This fixes a NULL ptr deref with raid5-ppl.=20
>>=20
>> Thanks,
>> Song
>>=20
>>=20
>> The following changes since commit 41fe8d088e96472f63164e213de44ec77be69=
478:
>>=20
>>  bcache: avoid oversized read request in cache missing code path (2021-0=
6-08 15:06:03 -0600)
>>=20
>> are available in the Git repository at:
>>=20
>>   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
>>=20
>> for you to fetch changes up to 36fa858d50d9490332119cd19ca880ac06584c78:
>>=20
>>  It needs to check offset array is NULL or not in async_xor_offs (2021-0=
6-08 22:49:24 -0700)
>>=20
>> ----------------------------------------------------------------
>> Xiao Ni (1):
>>      It needs to check offset array is NULL or not in async_xor_offs
>=20
> This commit message really needs to get rewritten, that's not a valid
> subject for the commit.
>=20
> Can you fix it up and resend?

I am sorry for this problem. Please consider pulling the updated version
below:

The following changes since commit 41fe8d088e96472f63164e213de44ec77be69478:

  bcache: avoid oversized read request in cache missing code path (2021-06-=
08 15:06:03 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 9be148e408df7d361ec5afd6299b7736ff3928b0:

  async_xor: check src_offs is not NULL before updating it (2021-06-10 19:4=
0:14 -0700)

----------------------------------------------------------------
Xiao Ni (1):
      async_xor: check src_offs is not NULL before updating it

 crypto/async_tx/async_xor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


Thanks,
Song


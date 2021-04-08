Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4DBC433B4
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 07:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B54E60FD9
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 07:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhDHHBY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 03:01:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22354 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhDHHBG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Apr 2021 03:01:06 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 138700w7031175;
        Thu, 8 Apr 2021 00:00:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=keo5RyOguXrbEriVWNkffgXeq4CAN+OXvXNlKt4L/CI=;
 b=UfQcmnXGU4FuyA5JSSrO1+6HXSCFbVzJH81hIe6lVXxDyRArzoUx/vTBlxG2kfVCz1ld
 gYWRK29P1jJ1ibpNFPFEaJyx2/54m5wxYP2F//s1K/2ZSkXSucrjHSGzZojMo0CxlccF
 O64mX0il1q4dVwIAL7DcccwLUCWkH8Q4hMY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37smjwjs5k-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Apr 2021 00:00:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Apr 2021 00:00:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktfljEboI0DkGl0bF/B2vdqCRL5lFYuiT0+4BPCTGgXtI2eDf4kZOjmwZMjRa31l9Itu+u2k1zn6MmmZ6tCZHieW9mc4Yh5GYLGifBzW4DzSK3ZRFJWwZAwGKibDxPFI1zyY0wjDPR0BQ1ahb5CyiUlpe1FGS5p3iFaSQjaNqKRyZ6EmOx7nOmeBxOZhZ/T/AprlKdgvq+0U2bTDsiT4nyXXUhC3YhexOt6n6D9KQitk/NR19IEHorHNx71rKUpAuSYFzglQbv3dY6/YOau7rpZTD85ItHSVsbBAJTJTQvvhEb958Iol7ArVsNLY62h/ISHgv8PYa5uUzj8HsXW0zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KTG/4Esqe8Awl4WozZ7iNV3y/LUETah5Ek8Zjk57/I=;
 b=Jxz3Vu9sUFJWsUasqi0adpTyt05TSrze1n2suw2WqHuICm8ccBTDREDqy8lQniauSxrlsSL8Z9vhs/HY7jdMFTk2UeaeN7itJz0uvpNPVakX3qa03V3EmuLKO6veAkE1nX1bP85U3ekGKzXjZ9cTnCxHQEA8vkiIOgb0YwS07zMLAdrqJbpVcPevXArGSwlgepnjUL7SCI7ibuhWcJvyKFC6sAj2gAbyuHom2Nl7AmD9XbM44CboxlmwLGjHD4lBMfUmeZBgIt5RTZa880+X3evyR4cPILLzeD0f9FJ+WQbj8mCTzzQctj4Bb/gDfZz14F1W+SkIjjQlr0m5VxQgaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2456.namprd15.prod.outlook.com (2603:10b6:a02:82::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Thu, 8 Apr
 2021 07:00:19 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Thu, 8 Apr 2021
 07:00:19 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Zhao Heming <heming.zhao@suse.com>
Subject: [GIT PULL] md-next 20210407
Thread-Topic: [GIT PULL] md-next 20210407
Thread-Index: AQHXLETWy0Y3wZtdA06s5lyY0Ii+Xw==
Date:   Thu, 8 Apr 2021 07:00:19 +0000
Message-ID: <EE2FD049-51D9-4348-9677-BDE75032E9EC@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:57e2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36a3c3d3-ca14-43a9-671c-08d8fa5bf900
x-ms-traffictypediagnostic: BYAPR15MB2456:
x-microsoft-antispam-prvs: <BYAPR15MB24563529919FB69BBD3474E5B3749@BYAPR15MB2456.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H1ufjgDnD/P7DrWvdEJCum6QGCq7V9xRwlWXYJhIKugcljaIpxm2+TYzPHzXR5P/LmXmbz6KKSgzrREBnNqAGgn0xvhCAglfo+4oi7JAZJi1k0vEqN7gAGQfhrxGlCM2tFUtjYOMORbBQ0Vq4bDBemHK3vXIhg1W3FJ+sjm6TR1WpqbU5mk8Q/QzZUvl52W4kIB5NL5BQddIO/hLKvr502bYV5XkpqojbsueCISXAcbUcXLMjGpX91syeLEHdVmTpKWv4m5cMbzLyz7+tF+WPKVJFWq41p5J1zgyOdCoxWSqY3opVr+18q/JaTSwzSANBveLVzEYdQmNOqkJDr9OzBZd4XV0iNNgJdVfKqtUtkgCnsv9mhz4RHWAF6DbIm8+spMAbsqq4MLz4LFJNptdFfP6ws3RNKVYxkmvSwPeUv9ZR0h7ptW15uLNzY0juROZcHbDlHV9Z7cYaWwKn3AtRzSbNgCasewj4cW2tJIqSh1ES3TqTLZ1ifdIsHfYTQ4elDG8C59CVE9aY8Y2UDc9dV2sAscspIDYQf1a1U09mwNTwgYjvLHHbWym5cY8hwfut5i/srFZT69yXplsd3yRugTcEzOrqlbRi6zRb68oKhyive+bFZ0a5zxqvC9I1hEhKUptYN0UVVzJjvhLDKPWF1ZNI8tD3mVPAueiu8bqY4LVN65fskU6TzxYhaxmZxdiNE55zW+IW0kH0mzshIegUsb9/co9C2qQ+YRcf9ONfNW7dR52ioQjjgVURwHUSGzD7w6LMoTwE8SzjJg2o8SIWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(346002)(136003)(366004)(36756003)(6506007)(110136005)(316002)(54906003)(6486002)(38100700001)(86362001)(8676002)(8936002)(6512007)(186003)(478600001)(4326008)(2906002)(966005)(66476007)(66946007)(91956017)(76116006)(4744005)(66556008)(2616005)(71200400001)(83380400001)(64756008)(5660300002)(33656002)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?i9AG13MnlhtpQ/1mJrL2VfpI5VToQpkjnmh5xQ2UarLKFpTu3wNuyE4zidS9?=
 =?us-ascii?Q?cBDVyhWIqGbYLQ5mS155fAJLxh+9DPQYypYEmKI2sPwI6ulhKLlO3uItagBu?=
 =?us-ascii?Q?tnkYIyia6gdPHfbHqX3lj4h1Kq1UMoeGIkzlGQl9RUMJ/OiyefnwG4+fj+Yf?=
 =?us-ascii?Q?gDUQ4DCTyrvD5NzwRkMYG9RVPOfG5TuoPXdF/d/5+BrtJj+HeSsQCiOVJd7L?=
 =?us-ascii?Q?5+5tvjuCJSOzAYfej94caL2/BV4lhskaqAvBoqKrQU9XXAOvCx9kHlkTZPbj?=
 =?us-ascii?Q?eXrUztIIa2tsR3YoNn+WVVYn/3yiXozFJI80sUZ6R41PKFyV5AYmu4v48it0?=
 =?us-ascii?Q?vOXBm5XzZFanqfORmyoqVvtRPuIAT+nFqw0SPL+GcP00j6MIPhdSTt7p9NYt?=
 =?us-ascii?Q?ozCxZLH6wZ7yGCARlIb0TWgPAFXsiB8t2cerd8RZIYk+1Vy4egAThpqrkQuf?=
 =?us-ascii?Q?N7yRmByBMjGoIcNtos6+d/RzTjAeOuxU+V/O6KlNJZqdeuzQRzJA65zbfPeI?=
 =?us-ascii?Q?Z7cs6F/fPmziNOGW/h1FT3TNWcqap+wGffuIwyeEU1p73W2epzZWbCxII2/Y?=
 =?us-ascii?Q?VbnUm00u4r5Jjn03pHH7mf67WjCC+Dnx7jNUfuT37SarAD1y33sCaH1eF/wf?=
 =?us-ascii?Q?gElbZ06G9tGuMP36PVyio3s36+kMtzhTsqZkkTGm0FNVD72kPub8LV8ECC4e?=
 =?us-ascii?Q?uCaNUupxGJD+w5zOxKs+2tzNDrqBFKaMUtv4MLdKZpefHRSufddDG1p8o0uN?=
 =?us-ascii?Q?cpBaPYK8+rlmiJFeItfBNgo+0hv3gx6tZo0SL5GP8FEtFAO2ark1Jq58Innq?=
 =?us-ascii?Q?E9FSJV5Z/XCAdjq/kB9D1PyxykVtwzYgNZnOKjo8hiJCUnQoFNJVDT68Xa84?=
 =?us-ascii?Q?3Gso8NogcyHu3Eny4YytBnUCczVLnlCxofmBjuG0MHiEbVtbBwmXqikyUb+B?=
 =?us-ascii?Q?hxgDdauTpcBiSRLMHaiWs30OjJU/wUwhPHgf+A2Yxikpa/jJfpGzUysbfsrB?=
 =?us-ascii?Q?3bjXAsNurbVbxr+a39fPAsP+bomdn7lrJmWBqkgqmD5OUoiTEkFam4Y+t80i?=
 =?us-ascii?Q?K2wLZ5TAiGfwx+9GxJEafBsh70YqlwYuaBayJV2+LRZLfyFaX7hcVsf9ozak?=
 =?us-ascii?Q?mctSsaLhXDv+4RN2krPIyRr5RzN8HuzgwYsnoEH9fiI+RoIH7sRW5Tq5j+9N?=
 =?us-ascii?Q?P5frbPeOo1XHp9sH/wzraaK9vRCofjptPLkB5VsnOJXgfEuv6AojlaNwcNXC?=
 =?us-ascii?Q?7CWVOZtfSOCQYOKwAOPn9bg3UwUZoeq51A6vDsgEl3LbZcLwa8eW62pDrmws?=
 =?us-ascii?Q?ThwCHOQM4Wpkas4alU0j44BeRRthYT2oCf/6o90zAp3APdx8ZL58Cz8a+Ot4?=
 =?us-ascii?Q?cOxMqjE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2BB676BAEFEAFE4B9CAA1E67A50EE007@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a3c3d3-ca14-43a9-671c-08d8fa5bf900
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 07:00:19.7317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JQiI5wp/gfnlh3dkjpTxvT9WH3/SA+Cz4L3ckNnBbiVNNriMQBtPpf94M7fFAdKrekFF4499FmIP9YXkNIm+qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2456
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _-EUYXz121lP4bQU8JbSdzyTtmp40q7j
X-Proofpoint-ORIG-GUID: _-EUYXz121lP4bQU8JbSdzyTtmp40q7j
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-08_02:2021-04-08,2021-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 clxscore=1011 adultscore=0 malwarescore=0 priorityscore=1501
 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104080046
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following changes on top of your for-5.13/drive=
rs=20
branch. These patches fix a race condition with md_release() and md_open().

Thanks,
Song


The following changes since commit a425711c6c9c85769915acebc216008053bf5db8:

  block: drbd: drbd_nl: Demote half-complete kernel-doc headers (2021-04-06=
 09:21:53 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 65aa97c4d2bfd76677c211b9d03ef05a98c6d68e:

  md: split mddev_find (2021-04-07 22:41:26 -0700)

----------------------------------------------------------------
Christoph Hellwig (2):
      md: factor out a mddev_find_locked helper from mddev_find
      md: split mddev_find

Zhao Heming (1):
      md: md_open returns -EBUSY when entering racing area

 drivers/md/md.c | 59 +++++++++++++++++++++++++++++++++++++++--------------=
------
 1 file changed, 39 insertions(+), 20 deletions(-)=

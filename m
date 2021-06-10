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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECDFC48BE5
	for <linux-raid@archiver.kernel.org>; Thu, 10 Jun 2021 21:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0775461059
	for <linux-raid@archiver.kernel.org>; Thu, 10 Jun 2021 21:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhFJVby (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Jun 2021 17:31:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58532 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230348AbhFJVbw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 10 Jun 2021 17:31:52 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AKlMZG003132;
        Thu, 10 Jun 2021 14:29:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZxBirz7As89lQ1TZQ9Akh4l+3wdeV5GM/PlMf4Xx9Rs=;
 b=Q1IONJtpgGz9kj4Nmhi3lfz1Ar3jOWT9zKPyAF/6zTrHD5kPXm1/YOjGA7smXX3tg7pQ
 /OuPeNIh7bnNDfhdpogyk4xLsg91dBbOWYFrKsYfhPSznFSFOiTFly2kcnLfUHLyW2X8
 fRz1DFo5EvDF13vXgLYS6pR69Y0A6LANxQQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 393sdugn3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Jun 2021 14:29:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 14:29:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMh8vCJdPEntecrMXNu03m9NsVItQFhyB/0QukxDfeiv6xQ5iVuZ+oL7atz0PdpQx2yYClvfDTisZixv7v0LVV5FmDrvMs0/LIZ3UJpiyLvfm+AKitZSSZQ9ufdC0uJ73axOUu3sZ8vVEhkc8SqwXahvUtts/rBWxo+X1HgCJ4U8AN9VvPClWgQDETrx09rEEkwrolNfyethe4SChydn0jSxv2h/iiHUD+qaV4lWiZShtrmNU/GsjFzb5D9tn3/k3Hd7a7OeKO4hbHAyvnH6AUzKy2YtACbZ5KDsP4gzkc8+L3wlxbqIKpEcIrvNZNq5tQTR4sjz6Pab5aA0Lq8XeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8iI4yG1RTvLCgyih2vUEBH9bwEgCpSmL506Bz33eNw=;
 b=ASlzXQAJQlUL9JSPoOwbHxvoQrBuuTVFW/67MlO1Axk276N06NMaa5ZmF/aTMe4K1m6QJcG6s4xOrExZRfkAHy9eZVam4MhnjlDObYRAg0I583MzEthfcbO9JB05A6PF7beTKniYZ/od1WZqZuYjvE9ysa+B0/Ad134pb8z7LDWv6pybkxf3Funi80bPLtpv82NR4jr1OtR61c9hDhzKRv4MC+YsRJ3BIBi2aTtYwjzpsx5lwWWbgFcKNTMsZbwvKVbc59lgnK7YUIvMQeolmunE89XSWKs3rtY8asmThFKxZIkfgmpXV44fdHNGER193uRXZqUtJGvNfj3UQYop0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4487.namprd15.prod.outlook.com (2603:10b6:a03:374::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 10 Jun
 2021 21:29:53 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4173.037; Thu, 10 Jun 2021
 21:29:53 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xiao Ni <xni@redhat.com>
Subject: [GIT PULL] md-fixes 20210610
Thread-Topic: [GIT PULL] md-fixes 20210610
Thread-Index: AQHXXj/AY/bl9zsTW0SOPtPexQ5llw==
Date:   Thu, 10 Jun 2021 21:29:52 +0000
Message-ID: <7105FB78-55FF-41EC-A84E-6113512598B8@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.100.0.2.22)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:a097]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 339240fc-6b08-4501-917b-08d92c56e2a6
x-ms-traffictypediagnostic: SJ0PR15MB4487:
x-microsoft-antispam-prvs: <SJ0PR15MB44876B6E4AD1C42432FC86BEB3359@SJ0PR15MB4487.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o9x/vsxj7X3hzcy2S63l41qYF3hROK0GixQQvoYwd9bIJbf3SQMRmVeXhiPu8HAPzlXoH8YFWiRIBOp2+BRStQrEVvCPZw2kxzNbBa886hoKhid+bt8GHOFKqTStJa9qk58OTScUKCMLtj4TMKP8W3VKkGXh+0sT234I4QspI8bjg0mB2wxAZPmmkMH5y+MZvmYtwSFR1AlLce+5qzqZSDx9bEZ2xaxf1TG8bTdjGMzWjMH3nqxsq3u0mxQ9Y/Zp7PFm0IyhLTf0Zhb7d0sZU1NNC51lqhXvmMuSnKtw9AZCSL35VlJKXQkvVKQ8VYQI8yaQxcjKFdvggvz4OagLbrYQhMdBd+QMBm7ZxA1k/HCTV4SK1fDahfb+LbeqIodD9KfAGgUPxoeI/yFUCY/ogxW4HomHq0yhdswu5y/xyrf95JzpKt0jouef7tOZZjwxi4kaNg2O8naeOpj8fRcNNnsFd4HSApgHOmudYhPO1LjCZqQ4V5WLNLl7VpNKc1y9rY8Eojxq6K3MEs2zGnwSO0cENEiFIFM9DaY7eQAEyoyBZHIzJBS4INohWuYRRSih4YKQ1Uqn8FYebjVRp9zma6vUbGpEJw5coiKdShjqog7abB/PGnqfIIYIF5gJDzmH7rp64q8FaSZtoXZGRpfB5qMtz0vV+1BvwvHHjsbVtItzZZQE9CLrejFaSwNe0wmTnOIF5QNcjB3UHOue04uwMDGTwd9HIZQ0szMDt7AMOJAAR+CYWNFlmEcESBh1ZULnPW0xvm9PYw7zjJbb6ssfeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(36756003)(5660300002)(8936002)(76116006)(83380400001)(186003)(86362001)(110136005)(316002)(6486002)(122000001)(33656002)(38100700002)(478600001)(2616005)(966005)(71200400001)(4744005)(6506007)(66946007)(6512007)(4326008)(8676002)(2906002)(66556008)(66446008)(64756008)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mOFG0gjK8LYlRa1xGgUMt4OqyorhgESH6MO6Rwmvgv6TxWSJbLfXCag3enc5?=
 =?us-ascii?Q?6uftgcoe0iROwl55rwNdGvPJ/++KvTuIGpkNtpXr5YTraqhxRRGad4XyBorx?=
 =?us-ascii?Q?7cTlYL3jXrChw1aFBywc39zQ+Y/zzLnGNq/qPg+yVfOZ+hzxr8VJlhNdnrfW?=
 =?us-ascii?Q?FjYQUJyKKWViOEOku/q/0wc3ofTOvHTcXVabv5Q1TxuuTvLxZgjiM5rR2Tin?=
 =?us-ascii?Q?uo5u4JuTpLrPFZZCfUGeUW8YSKSkL91jhJ1uBqx8gCSvd/QFvpHqDsotVvdO?=
 =?us-ascii?Q?VTT7vAnFCqxyFpy8DuK24mbSp2H+Q+hiXB3UXKz1/PtZG4QHX6q8+pvQTQJX?=
 =?us-ascii?Q?2FShNbh1BCtcj/sC+9pn4AnT84mi7DWD/cr7whRreegSvqR+eMLihOUgK/Sp?=
 =?us-ascii?Q?JUNCxGZlp1Un03P/xrrxDbaKvghvYGsbvQwkdXkfJyYy2BubdhOeddCWDsss?=
 =?us-ascii?Q?fu8BtT1rZ7rR0g5SzAPadzjg6omm96W1notcsaPjQqILjcz3HJu1sdzrZqj9?=
 =?us-ascii?Q?eM232VztyONkLXFuD5v9qGodt+Z10remq9kDnA0Y11wD38sNIfC2Wqd0pNBQ?=
 =?us-ascii?Q?ZmWwriom1fLGiKyqxd1RrVfGUv9/V+tMTdyvpUVuOkjM5QRikF7iu9s8ddSr?=
 =?us-ascii?Q?k4uDT0abXjDbBoB/9gMQbR+lpoDeRg7yT4++uN6ZdNjQhe26HZn2KSmomFks?=
 =?us-ascii?Q?2DrNnskzAxglBmTCjVg4lXJbAF9yPl4FEWDdLKwIR1VArvrmCz/Dl9cFHgcb?=
 =?us-ascii?Q?/KXa9r0V8DLMraBtU7RZk7VOxSuk+81exKuZP9nRWyPNR5xP8jVNHthrbAJ0?=
 =?us-ascii?Q?uOG24EkGwp69ri1BqgEh9KGmhPImL/omMbqEptrcSW7aoYoz0p4xzEKxytFb?=
 =?us-ascii?Q?M6LNQEbxpuKJclizeMskLuvgp7YRJzx715nwFXwuk9SUFNjTGHWC4mhPcjYK?=
 =?us-ascii?Q?bAm/KCQnqS5QL9dxJhFLuGwnu+SawQU+7C8US2uu0CREKCIXWx0kUlLs2n94?=
 =?us-ascii?Q?NZ/yBVE+3ZKKBlHayewSExMM/kruFA1IYxJ5AIRIsYpBfHxzCUcLrcv0eBNX?=
 =?us-ascii?Q?AjbIIyF2reHCwDaLveRt9LrS+1F7EHM8Dur4cvWL1wX/nVQPeqDJV6RaqHYe?=
 =?us-ascii?Q?CfKXjegS1QoZU/DysCiAtrvAnH4TlyFAM/L3O01Ynh+HQiTabye2u5gUfOUC?=
 =?us-ascii?Q?+5/kc9R7uMJQI4eDiq6LRx2KGbpGb3DrtCylUgc6FcfHk9lQ3vZp2+Y4iJKb?=
 =?us-ascii?Q?78xfU299rCYeY40N1OltxMrrT7zAllaLG/MK2qOccPeCFrDZXfGz69sSdn/Y?=
 =?us-ascii?Q?j/U4/ypAUzdKtPdd2Tw7VhcZQ5u3R86ugDzOY3RfcxM8sYmi9FwBHVicD2P7?=
 =?us-ascii?Q?mvD0RY0=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7DD231BC09DA8C44838268FFE2907A70@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 339240fc-6b08-4501-917b-08d92c56e2a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2021 21:29:53.0073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vpIGnROHcatRNocLqfIGfjspPeA8vNmAS18wbtUWaBKjMPkpOTRylcDd0r6HMXq76iarCE3Zy6mjCgjzDyzC0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4487
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: LQhCBXsSnelzAuEsD0qPw5L_cz1XjInF
X-Proofpoint-ORIG-GUID: LQhCBXsSnelzAuEsD0qPw5L_cz1XjInF
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_13:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 clxscore=1011 malwarescore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following fix on top of your block-5.13 branch.=
=20
This fixes a NULL ptr deref with raid5-ppl.=20

Thanks,
Song


The following changes since commit 41fe8d088e96472f63164e213de44ec77be69478:

  bcache: avoid oversized read request in cache missing code path (2021-06-=
08 15:06:03 -0600)

are available in the Git repository at:

   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 36fa858d50d9490332119cd19ca880ac06584c78:

  It needs to check offset array is NULL or not in async_xor_offs (2021-06-=
08 22:49:24 -0700)

----------------------------------------------------------------
Xiao Ni (1):
      It needs to check offset array is NULL or not in async_xor_offs

 crypto/async_tx/async_xor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)=

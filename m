Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C76C432BE
	for <linux-raid@archiver.kernel.org>; Fri, 27 Aug 2021 22:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 677E860E0B
	for <linux-raid@archiver.kernel.org>; Fri, 27 Aug 2021 22:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhH0WQC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 27 Aug 2021 18:16:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63550 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231906AbhH0WQC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 27 Aug 2021 18:16:02 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RM9nBi016964
        for <linux-raid@vger.kernel.org>; Fri, 27 Aug 2021 15:15:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=G+BOGMsjSqDacoFD9DFJ1ReU9SGjY+a+B5i0sHlLqfc=;
 b=Sgf2/t17IXpG8pMB0lgnpUecqEjHZpNYnIiwm5LOyun9aHCDvuVvDK9lfRpzAKpkVSMb
 NIgqYM98kYv1cILz6eao6Qh2J0862GBTcsMmiZifSxqcVNGQk8rnyJJGE27LQZ2uqdou
 uJU/1vBuikwtDjmIegyLF9aamVASvuNR0+o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3apkn9f8m2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 27 Aug 2021 15:15:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 15:15:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUD3InBMG4Nn/QysYgpL1S6NGoHdDNPcl5VN3uPz0YlaUlEoUQH2eOZ/zcix5H1uZn5Ak/pd/oZVA7l/loM/fFm4Q+cvv78WfLrTNuvbdH5V8JTCzIA/pcZWmpT1VumYK5XRf6M1tu6ArdqvSRaQXd19bv1TXAL2g1dvHyKlPdSExckl300f+v5OQSNxrYgENW3zucaQyIIad4YJ9xIGOM8t6c+YwXFOkMVxjnSVPAgTH08YVeLbHLMj0QDpKp7s94oSov54Ge6TZQ88oMzMmw7KrUlyt4OLbQFtCy76PJ0QSJybPAQ5dl+N3YwoAHemUZd7ofe2BfZ5MPBsFgJQtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+BOGMsjSqDacoFD9DFJ1ReU9SGjY+a+B5i0sHlLqfc=;
 b=E1ZzgFAixYUH7OWrICcUvUJ8MUKo+fhKmTbnbJfRGeEa1F6P4svKOnckqj/iFy9YIqUCcIewEe8HjawovDdnRYDyRmmhUSPCN+MmHovuO4hn7qQRdrAixahbtJDu1gd37Xa+KpF/j/rdrFUEFt3WRKrw/DjI/Nob4jb+t6n7vgF9JLdjoLSrdSczhC7ojcdCiRmP6Sm/YpMhsnM5kb1T2PiMqTDEoSGs4jKn95wnh+syIcbhTeJIGfuCSkhfg/xLx/BpAeN6nnrDfp/6+rMoqoiE5oiY5x0o1q/SjWBpg2n7P5da/1o9rCbi/7vVhM3pc/0Fpm60XIoLssMhZBm3AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5096.namprd15.prod.outlook.com (2603:10b6:806:1df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Fri, 27 Aug
 2021 22:15:09 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610%4]) with mapi id 15.20.4436.025; Fri, 27 Aug 2021
 22:15:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Guoqing Jiang <jgq516@gmail.com>, Xiao Ni <xni@redhat.com>
Subject: [GIT PULL] md-next 20210827
Thread-Topic: [GIT PULL] md-next 20210827
Thread-Index: AQHXm5D/L/5xymUH6UiTYR87XJmdOA==
Date:   Fri, 27 Aug 2021 22:15:09 +0000
Message-ID: <41051BCC-9AE4-43E9-9AF7-8E3C6D9FCE18@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fe5d5c8-7b2b-42dc-5ac7-08d969a821c9
x-ms-traffictypediagnostic: SA1PR15MB5096:
x-microsoft-antispam-prvs: <SA1PR15MB5096E7E7B641996E01D4425CB3C89@SA1PR15MB5096.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:639;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KMNIOaahzX1xYtGncumLSQ6t1kAYD+GKly9BTO1dHQ1dOGT25/yy4paLW0n7rQUMp96axWEcqZki1KP5RGJghdfiaP/B56Lmebg+abywKazTr3wndRY8H2UCDDI4MoLQeeC53UwTBug+feXZ1iDqhG+yubkwd0rqVMaz2oVrV6VG088epG6QmQgwyXqDglvjiWU+RXC8hLYi6JaCNy12zLudYKEdF8IGWatZ9YY8OlB1yOQTUi2IQxs2Zvx7OBYG/O5eaPkKZaJ4jdRqgtLd25NZLTM13cRKVQKDYLlE/m0sExYikXhMVvf86XP5iB5jV53OOO3XvUp6HsZJDtg+rWwfScUpacWgZ5AMdXtFJGC+vZhpSly37EmewjG+e3YFJW3PiVe2c7EfDgN6v1JXWLo2/bmzpXX8IbaQCMUdwyN/nLHqZt4RNpK2blluojNLHA7WwsMtBduw1N1xROYirs9QbooZ+6nkIwnNyOpVD1NVUVfwuXZoXbm3PkI2XgvJ8wpuJz1Jl04NczYBRm250VVg/zPU+c+yWv/TWCHFc+jawks2nXTUuF5qRstB0rAlX8Wog7l9CATeW0JXFmnY/1igvEkjgamPJf31jKtO1qZ/W2IZ0S7533QKWCNI3fAQ7UHn9VN9uGJh837AENyKTnaT75mTc0mveF4i6+xbmgY3LkQZ3DaJEETKf5QZCL2VYZgIl8djSyXBcjAa34uAkLb7EVMxgsRFKiito1Jb6duidDiXnGZ3RiNaddHKtXrt4UR0RhXufXlj1p5Q/3SNi+RIcko9CXIZfj5L3I7t+xu+SFOUGLc9jeHkn0HHOYxN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(966005)(83380400001)(86362001)(186003)(4326008)(33656002)(6506007)(36756003)(6486002)(316002)(6512007)(38100700002)(5660300002)(38070700005)(71200400001)(76116006)(66946007)(4744005)(8936002)(66556008)(478600001)(8676002)(66476007)(2906002)(64756008)(66446008)(54906003)(110136005)(91956017)(2616005)(122000001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IkXsZOVachFs1hKBF46Si7jA0GUx3ykj//p+1fk2CGD9N2feX0eqkNnL+2VH?=
 =?us-ascii?Q?7HnhQzZa0YPIoJCK1osLJRpWnEEgW2VGMhVGnPtXPzX+ZoQMquI9P41Xaq2f?=
 =?us-ascii?Q?clPB/jLObUswwVNOPv/0J73fYRL2QnjfevMQAYAyvDcXh6gi7kKtk6arkbqX?=
 =?us-ascii?Q?QWn5o3VPqdkXAFNomqa1fWHPNRbIHiOCtMbvt4F+ss4qmUqxq0kzBnk0/FBd?=
 =?us-ascii?Q?LeUyTYTlU8U7Xogp1icCDmfB2InOo5F1qn5qPFCbstCfUGVor3V9koxeQYlf?=
 =?us-ascii?Q?WOSOw2aiDtsNyZ4jgX9yi8Uw0SPY5sfn0h/Yz7V/pyYquEq5btpytajt7htL?=
 =?us-ascii?Q?6AoomhzFb1+n4apL/RMNRhh8NdnmPka9Jv6CRNFQMKwtQZSEXlEB3jUqXmF3?=
 =?us-ascii?Q?Sd/Fs/+KGLcgLp4YUMf6axqO2y0uAI8/EfndC5tcO3aSKR8WkvFP9ot7H1wx?=
 =?us-ascii?Q?5X7h5UFNmYfE94cU9S8u1WVKycsAAIAfGWjnexLd+VjqeOkmzXCY24wjWypJ?=
 =?us-ascii?Q?MMPVLR8GsjVGv4/VpuhXsfUifwDVrPHYKVVkXdIhx1eSVZMdlqC9/Ii3ow5U?=
 =?us-ascii?Q?PJRX9IP3fPQ/1OA7mPG6xQ1B3c2Wy6rGfw9WHdBKsrfygG0L0j3ObQLPbURv?=
 =?us-ascii?Q?gZn7RfqldQlDyZhaVLSY2QX5OIdcCaISMkwWe3H49vAo00263X6PmInW301E?=
 =?us-ascii?Q?q49jmU/hV+rXBMKMpkTXbMP8BXDQ8A7O3dKX0K5E7veMf/1LMp0ZUanS6kJq?=
 =?us-ascii?Q?BdeqX2541NguzNLekBfYxEcCBV6e+Hlb7VlkQZoXD1XuCsqHi9+DAp83xbeY?=
 =?us-ascii?Q?sgaHcHuSxwPr3nxkwH1Bhdl1zAoGXUnSX1vjvH/qDCkszn5rufEbt/+5LO0t?=
 =?us-ascii?Q?5l76Uvy/41kdrSRcR4ZcrRL6VQTsgb7VJT/dUmjBb2XHqoePkzkjNgUpyTrZ?=
 =?us-ascii?Q?+nBvS+A1eH0Z/+snogrVX2671st5U0bbbno2oRLfn2QQjxryMrvBpy7MIMxK?=
 =?us-ascii?Q?HuqdjSy2hSA1f0twphqL+Z8vlOvCCl7NfeMw4CZy1+K7tqUodDZoi//y/uze?=
 =?us-ascii?Q?okHwJDAfJMuQ3Miq2b4w4y8ApXPRdHt+vYOcDIJvPBO938jWc0rSoSovpPua?=
 =?us-ascii?Q?AAqozQ9jsr005eQPoVQnHEHCudLqpp2uZKbtp9cmgGg66o+HGdn6Vb2/rmsJ?=
 =?us-ascii?Q?1as/Zoy9afFA0D+SDyNCAStE01NtvC6k1KbAppynI0+U6zkdKthCq/CEZSo2?=
 =?us-ascii?Q?Yy5H0XJucmF+i4qHOBJxuPBaQWZ1pZOYzt/zHJYKOGQbjRJhFYSqYKkX+x7z?=
 =?us-ascii?Q?jaiQU5KjJoOc4ku6LhpoF8oSegYtpb4gOBv3pW5IgOdREcdg7UEJkPRJkNAI?=
 =?us-ascii?Q?xV2fpsU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F260C5369D5A4438F5CFC0855346CA7@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe5d5c8-7b2b-42dc-5ac7-08d969a821c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 22:15:09.0513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kfn7Dd/mgiykxrEztAylTcikURsSMivkc9HIh6r3S5utyD6ZsG5AeMrFCh4vWLOh9oppqdf+gk7/sAXYDjBFyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5096
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: tkE7QtsyXG-55gerOZdQTj_a4U5mAliF
X-Proofpoint-GUID: tkE7QtsyXG-55gerOZdQTj_a4U5mAliF
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_07:2021-08-27,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 mlxlogscore=744 mlxscore=0 malwarescore=0 adultscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes on top of your for-5.15/drivers
branch. These are two fixes for raid1 and raid10 respectively. 

Thanks,
Song


The following changes since commit 7ee656c3ac3d047b4cf1269f83ac9d6c0bba916b:

  nbd: remove nbd->destroy_complete (2021-08-25 14:20:32 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 6607cd319b6b91bff94e90f798a61c031650b514:

  raid1: ensure write behind bio has less than BIO_MAX_VECS sectors (2021-08-27 15:12:14 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      raid1: ensure write behind bio has less than BIO_MAX_VECS sectors

Xiao Ni (1):
      md/raid10: Remove unnecessary rcu_dereference in raid10_handle_discard

 drivers/md/raid1.c  | 19 +++++++++++++++++++
 drivers/md/raid10.c | 14 ++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

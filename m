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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E4FC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 05:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AED923C44
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 05:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732581AbgLJE74 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Dec 2020 23:59:56 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53896 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729737AbgLJE74 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Dec 2020 23:59:56 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BA4wX7l006768;
        Wed, 9 Dec 2020 20:59:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=eHeiOSL6/J/9+JFLKCNn5e3iEa8ZUXA+FWK3HoT73pg=;
 b=iQE/KR4WeXcP/Vg9IXYaXt+wzsYsxAQQT7Lodklv3dwGxwV6hO3aAFyBLnjin24Kj+Wp
 uLj010fB1jOZAOcD/FrE4swCjpzlzju7iSQE8Js+qoR2l5+rEb43Jvm3p3XHJwtbvsD+
 snoASlp5SaW12L9xjGFmytH3wuTOso1HrTo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 35ac7qnejw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Dec 2020 20:59:11 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 20:59:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBzUjIiN3hRzOzJcLGaa9GobxPMmZ4Wd3ldBMkBPIJr+dsoaaHDaayeLLI4vTRKZV+kLui6IQ4vzHlDwtVV8pCDpzrRy2hOptb4vI+nawrie29K6eRkYOZ0uT4Wkh7ssnrm0XXM5NI7adImEWwQmN+LFDg608t0DlpxqMefByEc4HoTOb1k8lGOy4eKrmg7pXcfMwPzODd3vCTt3mnhyuZg/sMjnz+sSVQPzWH19yiDE62kSuKqMThAEEemyQlN7XuabI3dtyoJXtwjMalJVtFQbwtUBnI0sDqAvXBeenYOohG9U+8SL8aGgbh2hxW7rwC2/xVrYSSB2MXWCw3BfgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elmPqpE/9v5d6yumZVrjeaHT4kymlPVxG3k7ykt5MZo=;
 b=LXXhOwIZQCuGQysObC2pQOz+JVv2DacLDFfnNYu3/v17NBmvbvXdMMbTdmxJNqcRZQzPjiBSTHsJhSpqUbZOQoV3WoJAMLHfaIpynv/Xp7zmw3F1/2tM+oiOzcumCfZ8mBPjft/iR0D9vzr4CGMdVHkWRaRacreOQVg0pS6dbM11BRvWgAkshZgipG76tPGzXM+0sGF74OC6SnW3cELhACZvSFh4ySyjYriy1fIyF3TDr6zkQGDYgQYqG9CpwKtIxe9u8Mqf7b7EBcV7UEQhaHtEFPfFxhr2F/QyY678Os8CqB7DT4dWKsaXXnEZMZmmPnsrw6IbOESeFEK7gKIN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elmPqpE/9v5d6yumZVrjeaHT4kymlPVxG3k7ykt5MZo=;
 b=VHF6ro/ERP5IKSDtpBZiHBCvzC5vZnR+DwykmTbJQGR69e8m3/z3nrZrpZgNrqaSYFTR/dB9/gsCKSmt7oWScj2G9mMD+17bGZphUz0gVzHkFi2iFtshl0v5MqNkuh1hW2byeKg6nPqn2x5BTd8yeu/3g4wknRqW5PvUahMAHYw=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2951.namprd15.prod.outlook.com (2603:10b6:a03:f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 04:59:07 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.012; Thu, 10 Dec 2020
 04:59:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xiao Ni <xni@redhat.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [GIT PULL v2] md-fixes 20201209
Thread-Topic: [GIT PULL v2] md-fixes 20201209
Thread-Index: AQHWzrEwRGXY9GI4VUK5ijQcGOAQ0w==
Date:   Thu, 10 Dec 2020 04:59:07 +0000
Message-ID: <0C161FAC-8A21-4EAF-B3B4-A7BF04089213@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:d023]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06036727-d40c-45a4-b74b-08d89cc85360
x-ms-traffictypediagnostic: BYAPR15MB2951:
x-microsoft-antispam-prvs: <BYAPR15MB2951D1E0F30BCF8D5AF12A8AB3CB0@BYAPR15MB2951.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PX2czoHS1NgBANeRQz3FMBWBJVZj49VQLbQDVvwFm2PzYbNJcjJOFbABFF9ifsYw1BnxoqC/YVp++/5pxruMWeirvV9QJJ/LheqboxP+wMi8jIqg/9fL7e/voHprJxUr7R3cpoyMxb/TF3jPGmPkzKW71vgrXdlz2ZnluEqEDdYDvrEJC7oSHT0X8868v2JpV8Q1jvKKdewpfL043tUHZQc9IsSa02PuEGdeLxCo8n/mEenVDJndGDrEHZ/d1CS0OFxMa/FxiV+T2vVv4kA1JkKfS0SXBEZq3wZTXle9T3nvJ/zcoNgA6FUg6hZQL5EtBn1apJAuI5o53WvvDZAW4TsFlhFzE3NoYuxB14lspFbbBu15J5KCPhKOUaAU6LhhSX739svT6qXvdyi8D75I6Txe3zh7AlSUWtmV6+TkhcSZvwRcJA2Xay4/HF/LLSiv/fkKsuRLejY1RyeFiure8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(346002)(66446008)(83380400001)(86362001)(6486002)(76116006)(6512007)(110136005)(6506007)(54906003)(8936002)(66476007)(71200400001)(966005)(2616005)(64756008)(186003)(8676002)(66556008)(66946007)(36756003)(33656002)(4326008)(2906002)(5660300002)(508600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?T+dw26tSv299cb9/JfyZ8oOZ4HBkg84zpAJJGANNAnxQeKPRS/H1q7kaH2f5?=
 =?us-ascii?Q?Y9Q4PUDzYame+WF7vuLJmEXWNGTtxXwWIIwrJ8vnez/OOpbwoHXvRAdtuTJL?=
 =?us-ascii?Q?GadsigQZXwUG9FOxV4Y5ihMtutPBoon6F225K0y4rIFJpMWCtETJw9qGr918?=
 =?us-ascii?Q?rO3cUJVRft0OXAZCi3Fn/w5M/rv2Bx2wC7m5qt3dt489PrxsupD64JSTY7Em?=
 =?us-ascii?Q?CTsngxcln578mQCOLMndfTUlbVJgdEkLyhqMdOZcR/u8B3lV+Bq8dVtTtCP+?=
 =?us-ascii?Q?L7jGqNWJlJKrfVHuUglLjwQElHKYGxrhVcwRt8KvkgGxhr5Pnmu+mRJSXgya?=
 =?us-ascii?Q?D6i6/aVtV0IR1E3NRyyq7qsSCXC46YuKVmZrxQ2ErBXh6G+AwFtURLn6wxI1?=
 =?us-ascii?Q?c9YvHR0ekyMKsMFcemE6jsEFB5SvmBsB72Qd7X+NZATH/3buX67DPBSFJg/X?=
 =?us-ascii?Q?QjTHl2JDUDkIAfW/9nQHpHymlEuVu4UEIK3PEgOzm2MTJ+TXgReA1Lisoaml?=
 =?us-ascii?Q?0pVdxRjPC4Q2lRdI5EV5SZWEV9vLelpcTfkcg+JNZv8gu/1GAnat2yEcPe0u?=
 =?us-ascii?Q?jjV1Ok7gm4O5AWfW/9ahIvmKApeOzjmGYB00CJp3lOOsRcHQPZXGac8Ii2fV?=
 =?us-ascii?Q?bT/rPZPseDcTRLE+FRr3n+roDFjivrSVe54+kAcwxJTgST+69fYRC5GBVonA?=
 =?us-ascii?Q?CdUPXuHSORTj/tRQ0CfygDjGKll77HeOMOGdwhbTUJiIoN9UMW3f+XxjvzIj?=
 =?us-ascii?Q?GonLpJyW0sHJklKJDJcu5dUOg+KVKrzzCq7c23QpS78ctTZ2uiEa5ORdIOqz?=
 =?us-ascii?Q?+Vq+jivvfK269G3jcpWgKdKOYXF093mAHr2IackZjYDWIsMI/8oJphzDzE2I?=
 =?us-ascii?Q?ZWW/AekUqofeqYNSpUKyBW4DfaS22/HhXNKZuZOBLfU4m4/32qjoBh/IL6RC?=
 =?us-ascii?Q?fmYd3q7Ztk1b2oIq7NrVvA63Vq8OqeAON1ZNjJhRkQ3onGax+UGn+2E1KGxw?=
 =?us-ascii?Q?rbQOf1QbgzSB9t2wzEpmRCe2A+m0PhAjQl331bdscm325Gs=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D0DE3662BA69C84F84AE151DFAFBFBB3@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06036727-d40c-45a4-b74b-08d89cc85360
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2020 04:59:07.8944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aoXJpViDZwh7irYfrDNZ1yFiTV8byzP8FFFGLgdXOpktMt7oUP6K43XMbyEZeQ/Qim+e72jS8h6jmZmjlgi/WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2951
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_01:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012100033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following changes on top of your block-5.10=20
branch. This is to fix raid10 data corruption [1] in 5.10-rc7.=20

Thanks,
Song

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/


The following changes since commit 7e7986f9d3ba69a7375a41080a1f8c8012cb0923:

  block: use gcd() to fix chunk_sectors limit stacking (2020-12-01 11:02:55=
 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 57a0f3a81ef21fe51d6223aa78a1a890098d4ada:

  Revert "md: add md_submit_discard_bio() for submitting discard bio" (2020=
-12-09 20:46:01 -0800)

----------------------------------------------------------------
Song Liu (6):
      Revert "dm raid: remove unnecessary discard limits for raid10"
      Revert "md/raid10: improve discard request for far layout"
      Revert "md/raid10: improve raid10 discard request"
      Revert "md/raid10: pull codes that wait for blocked dev into one func=
tion"
      Revert "md/raid10: extend r10bio devs to raid disks"
      Revert "md: add md_submit_discard_bio() for submitting discard bio"

 drivers/md/dm-raid.c |  11 ++++++
 drivers/md/md.c      |  20 ----------
 drivers/md/md.h      |   2 -
 drivers/md/raid0.c   |  14 ++++++-
 drivers/md/raid10.c  | 423 +++++++++++++++++++++++++++++------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
------------
 drivers/md/raid10.h  |   1 -
 6 files changed, 80 insertions(+), 391 deletions(-)=

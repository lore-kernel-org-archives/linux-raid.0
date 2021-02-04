Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671A0C433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 06:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0254764E4D
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 06:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhBDG5r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 01:57:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41452 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231872AbhBDG5m (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 01:57:42 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1146nNRB014663;
        Wed, 3 Feb 2021 22:56:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=LG97oh28pa2hSyMQG//OS4Ho8eGQQzKlP/y6/WBPTN4=;
 b=RaE536wB86aXa5bGLo0D6lqwOYrCKqHt399IP75Fbv7J8rPACN07L0peZaxhvRruroDb
 KQox6nsnFePNIiMFnGw7z/YzCeXbAx95xl6A9wcdET9d1KUTJi1LdJ3Mq8/QYZFrOVKr
 1qHN3bN0efOBb+4mtKPgLq/RsPefVb33O9s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36fh1uqv8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Feb 2021 22:56:58 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Feb 2021 22:56:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz0fd4+Gp9bJfuo/dq/KABolLr5NRYd/zekRPPiL8pOHrMH0tsiAIT1G3VCzlXZX7SUBsSmBsgUgiOS1Hhr3+i+IYoYwwoIcFNzSHKGBCyUzklxFXtddD9g61OUb5lGgGTLt+3LZjP7CjlglL2kaNGdhgYNqPbMZuOXO68hui9DxS+KjkXs14bmM+/Thks/QDNfHX0xTqUnPXGkSQ6SXPLimZIDXUAWWEE/yQlIic94Nv2CsE9pus0cFr9iYaNDgK349laAwPEj+jt0zpGa2Z5Cwy6IcVWdR7JYM34OyopVFTfcqDvzxBA3+0k2kWZSgssv/3qHp0W617eA5p5AtYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siEkvC0WBicY33MCFHtIWBDVAHM3cVilEBSfmnnttgU=;
 b=m04MD1MV95iNfEc7Uz/f00FW//uEUw2LxEzUHgzkhYs0eQtYmUaZ06DmIMPL1YofdMBV1+ziDO7zVV4JJ62zU50ZEazA9kuabZmL4lwI/y6iEirTWEH1sE+eTtNWW8zXlBKCbbRDThb2aNWv67oLeEC6K/ZjF/bLFUCrsR+tM0JMLQPzu9W6Etem75cHoJpsBT/Ga7jjZDZINlrgNZaz0e+Nlp7EKloLgojkm0FOPy674kJF5fWHi7/zvL+euO6Q0013FLv9R66llgItqqlMiXivh1rvYuhBQznFg/VhQddNWnFbQTSqBADBpRyeqEupkIyoo0YsLBiGS1t6cpuLAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siEkvC0WBicY33MCFHtIWBDVAHM3cVilEBSfmnnttgU=;
 b=gW3qAqvd9w3Od/EJMofeSLiuxZQ9UKZJwck5+nXoQUYD6cpgHMyNNseMWnQAlh/Ss8e+5Qqu82GydYKgcy1ARQvxE7mO6gHB7ObRQNVgUCFAvifhO6f1MAq5XYmzpjyQAF3W9JsZx6nWc03vKENjn7g8YB4W0kL7dWjY2DcjcPc=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Thu, 4 Feb
 2021 06:55:54 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Thu, 4 Feb 2021
 06:55:54 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [GIT PULL] md-next 20210203
Thread-Topic: [GIT PULL] md-next 20210203
Thread-Index: AQHW+sLI141TaXt0yku7lYchBUU78A==
Date:   Thu, 4 Feb 2021 06:55:54 +0000
Message-ID: <E3580228-B816-42CC-9E36-B72FF6347452@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:aa49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de3fc342-b9ce-4af4-2815-08d8c8d9eaf5
x-ms-traffictypediagnostic: BYAPR15MB3046:
x-microsoft-antispam-prvs: <BYAPR15MB3046BB50CB9D15DBD4A180BAB3B39@BYAPR15MB3046.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YBSPus7I1G1VazoMNBZbKpCC/VmaR7RfpbWop/A8B0OfG7TXdCYgiHXLj4LdYOcnnZNDCHqFl5LAyMXwCtLm4UdJokYhrt0qkaz7AZ2omJxnSRlIGZ64E4s5AcTHIoum/g9NITCmKfN0FpyxyIxz+MfERF8IJjzD9W1xQNPufqiLU8v/B/yMSqq/x+FBbwrC8uIIwKpgE2/n9o9Ne8WPWEz36SOyyfCmd7e5YvjiAPyzTKQ3HkPSqqe9xdrDmRnTjRUx/12JrtM04+nZM27zixlBPn87n5GEXeRavQiwVzMgTA//hQ8bqc/6i4mxV4Q/0K8DFdZ3YrmskfQ9jI1tTZfzhOwGLt28r62mJXfu6v5gxwBsDiBAYjJU43V7gJXixN9I7LPuhosvtCqjnYl9/S+lpkPtUPotHikCjkzp/oEAi1NfYFGMaHWKd/JQcMxA6J4ue2a0KBAfIfReIig/jleR+KMvxyX/eXuXanQztcmTS9lxXiENxn6TuUXC7zrEW9nISq+HfMeyZ3YrTHDb02ghcARdlXLrmXasV4FArkCL591/ZoUNId9x7TKW5WabLugIdWCyks2XwRZpk0t/lqAt+TMRfB3DAHD3++x759G/3Z6uzb6mDZU978t+0VfFjX288GbcKndjxv85gylU2oe1eOXU5qIY/xensEWb4m8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(346002)(376002)(8676002)(6916009)(66946007)(71200400001)(2616005)(316002)(966005)(478600001)(4744005)(4326008)(76116006)(6506007)(2906002)(83380400001)(5660300002)(8936002)(66556008)(86362001)(54906003)(36756003)(6512007)(186003)(33656002)(6486002)(91956017)(64756008)(66476007)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?RKcMDIiFmG+hAueR3WYB/DtRBOYHz8qSoowVgQPak+MV15FsgPTUVX75gBoc?=
 =?us-ascii?Q?YPQQfx/djsoU0zfPw6i3vyyPuQ4kbTBjL7Q2NxoExSuUKgCTZmDbA1XxhYHf?=
 =?us-ascii?Q?4LLuE2rVex/9QSvJVwO4lYs/t3e8aoCAr4yJdSCseFb34CUFvlisNPUekdRr?=
 =?us-ascii?Q?OR8jB2CsLD2SBKMeKWUjqcwaeN0BdLd/sJYUgpOqq9/Cjy1jsetTBdZqmc3V?=
 =?us-ascii?Q?1y/Up4ads4dQM8K0RhR1TKicntoRkjc3eZL6XARB5lLEA37xl0dmsHtVcWxl?=
 =?us-ascii?Q?ObK/46mWM1/KTe7V+uSox62WgB1esu7NQTixwu3yemg4lJ7uIdzEcAZNQ+4o?=
 =?us-ascii?Q?vJ+NYnn+SUBX2XgG8bwP3nyo/BCE7V4sVgaZ+tWN9LMWzwomhzcuDg/V7LIT?=
 =?us-ascii?Q?t5iIFhaB/rmz7xVyEjKjOo3VSlhS3RZUKMkfZ84Za670h4RqCMvsBD/vwMmT?=
 =?us-ascii?Q?xVEcUpYRh/4w5HrJzGnRDTFU6DUiUFt7ycF+j7iep8VHPYG/42Eosngp5sUu?=
 =?us-ascii?Q?IRXUivZ7KicO5N7wMAiqxaMLHUi7gfZrIaH+J85mmSK/S5Ix0KTwHKX456I8?=
 =?us-ascii?Q?q1d2XiTtHEDsQmtffvrHPchFFuM7BYtYr30+XMcC9NRuXvaVqpJo/GJNB2u6?=
 =?us-ascii?Q?6ygYEkXocAdyc/q4Intdu8bEUz1QXscsmGNAtPgY0Xju24uZrJvbd5U7Voto?=
 =?us-ascii?Q?p1zopy0uLKkkcZ+L/DbVuKLHuFo0UmmGTAOYrVeDGVX2SVrV+TNAlaUzCXX4?=
 =?us-ascii?Q?NjKMhiSRJku9g2M41YUC+TZd8qRGyU4rWWu4Ix8cnX8Xa86XG0Gy0ZiLI5Xi?=
 =?us-ascii?Q?NI3eCiQx/ZIQD1PU37wUXZI2oSUbu4AVWdk8x8nYxv0Sa0kBESUkF2A6PD57?=
 =?us-ascii?Q?ZRuYTdLtE3o1gwPAp2fycBof215US9F5AgWdF1pMmGJjIBhq1yVF6aHep8uh?=
 =?us-ascii?Q?NnRUKp8YJXBw9DXHojz8snTQ6vF5X1FC7CJJbfE2jNMs0kqb5hqi1o5AxJfj?=
 =?us-ascii?Q?APibpvaY8kknsEkxVP3p9gjQ2jamv0dBKkrQXKUC1+8SffgTHvP70P1jlL5Q?=
 =?us-ascii?Q?/qr8EHPNfCC43JiHs3amEe+CuVlpFE0xAZItfqRS/P/K+P9tBa1tCSVMmsfh?=
 =?us-ascii?Q?YNs2WDAlYy7swPgGyECwRvhoNevEZan3lXs11zKS0vMFk2XtrKUerpSlZaS5?=
 =?us-ascii?Q?WoyO+qHAVRDfRjAmcHZJt3kIVR8XffbrP0x7JQDISygQZyCHh2Va3yh1I1oc?=
 =?us-ascii?Q?ISvbeR43p5EGWQzD2wmv1LV0ItqPRFjectZCt7qiZULqjMglokxsdSLo+Aos?=
 =?us-ascii?Q?u+23E5udkdRLrx3M4I22SPDX7izY6jgKj8YVIRp9Yjfgx7drrK++wlsQ+oCw?=
 =?us-ascii?Q?24JvY8Y=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <644F599A8CF692479C2349F9BF12D164@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de3fc342-b9ce-4af4-2815-08d8c8d9eaf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 06:55:54.5790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RdPlhV+NDl1ylwgv8hj3wO5KUat7zedxFDqqODYuBMu1BbfvVCi6MrOAMC6ZcdoA0YOq/QSmjeS6fRNNkHq0sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_03:2021-02-03,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102040040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following change for md-next on top of your=20
for-5.12/drivers branch.=20

Thanks,
Song


The following changes since commit 0d7389718c32ad6bb8bee7895c91e2418b6b26aa:

  Merge tag 'nvme-5.21-2020-02-02' of git://git.infradead.org/nvme into for=
-5.12/drivers (2021-02-02 07:11:47 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to c5eec74f252dfba25269cd68f9a3407aedefd330:

  md/raid5: cast chunk_sectors to sector_t value (2021-02-03 22:48:16 -0800)

----------------------------------------------------------------
Guoqing Jiang (1):
      md/raid5: cast chunk_sectors to sector_t value

 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)=

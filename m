Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01496C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 16:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C09C623122
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 16:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403929AbhATQb5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:31:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404053AbhATQa2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 20 Jan 2021 11:30:28 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10KGTE5u015386;
        Wed, 20 Jan 2021 08:29:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3cIEeInYfU0KUR9lTq9ZHTfT1oUK9yAqpc89uKoF70I=;
 b=mIs/euApdrHlFy0W3ThVlKUyoeVdp9MXZJo/18H4ca3iiYL20cYXVBG6bhW23tFglsUI
 zLuhef8c6gzM7AdG/i4BtfFoJCJhWkFRGjv5HZAESbzBdszvgY6lHQd5ALmox/eiFGGj
 ABoA9cC9pFne4IUnv4ssACdHPIhWm/BmljY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3668qhmcbw-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 20 Jan 2021 08:29:44 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 20 Jan 2021 08:29:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hizS+unYPCTaFv/x3nQbJGO8gR8RttORHHomjBsYtXGiY027RIcFaENHB2YLpvPLl/YbsGuf3HIPIihbmGp70+fUalO6vulUnhSmGCKBoM+YHdd/OtWnp5Y4ilvTNQwxHPwnAuXGu9Yjnk+Ho0t1XkNPAxEoFbCiSh80wbfoCPy8JRiqMolvWXMDO8WKCD+bNA9BWnXc+jGuMjYCYZKDxTsMV3RUA4cDkSAHuSi19HxpeHEybObfEKrfZDObK2YZLdMlD6OjeHcccpai9JbKPL89f83ZZ6QT4DHXtRRwon6aOpzYYdUHqZ8CgPDF1JpT0eB5eQeNCf7Cl0RJvqaYaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aT7IpD2ZIx/29DKf1/eYY/e6n0H7G/vFpvitWydlHJY=;
 b=hspBmuRy4aXQAGZhvqP3zNZsIGrsgc22IJE7qjG3yrOUXbEnE8DVXN8OtpFJ93eDBdDPztMqktw6NS86GDGZWgBw3dxFxh+RxxBefhxXJQK6BrYnLoapknxf/H3cOtZ1/awkRk6AXE0r/tEjEqrB8lSDQk57xexUa+BgjmFpYQZlusU1D/2m7JLIK999m/LhXvOQl45w8yo6DQrFDRexbn7KtTo3mwwlQZ0wtFy8Lt1hLN6B/haOhOxgW0vC/ylmIYtiW21q3yxQzv3z0gwBYCPUx78C0SFKnZ+mjgcFQuuoN5xryzUOhAcPlCfUfSfKfuZ/uwoBreRUuNlNARSfpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aT7IpD2ZIx/29DKf1/eYY/e6n0H7G/vFpvitWydlHJY=;
 b=hgbI8Ai0jx+5EkYqhRBAnm/hMx9rUDuX9hrYH79p2//4r1B+zJhhLmej7HqYVhydfl6f4Cr7Ku5oSfd0N6Sh1iClQRfYABWwkVclsXUQkrh6j6QiBdQMtljg7RUHjro8p0zP5VhUJ9hd1DxYNIcPDj5i47xC5OKxhokW5xi3hps=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3415.namprd15.prod.outlook.com (2603:10b6:a03:112::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.14; Wed, 20 Jan
 2021 16:29:37 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 16:29:37 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
Subject: Re: [GIT PULL] md-fixes 20210119
Thread-Topic: [GIT PULL] md-fixes 20210119
Thread-Index: AQHW7v3SOp01z7POsEy2/TW0GuItFKowrFsAgAACR4CAAAZEAA==
Date:   Wed, 20 Jan 2021 16:29:37 +0000
Message-ID: <D76D387E-E353-4049-994A-2A3B4E99A1EC@fb.com>
References: <745AFA65-3D87-4D24-9B16-D1DE59CB3AC6@fb.com>
 <1b5ab25e-7ab0-ef51-ca3d-b2e25d916533@kernel.dk>
 <B68A8E6B-D79F-4AAA-AB7A-E52F6213B343@fb.com>
In-Reply-To: <B68A8E6B-D79F-4AAA-AB7A-E52F6213B343@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:ad14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41ec8b59-1eed-4eea-f515-08d8bd60948b
x-ms-traffictypediagnostic: BYAPR15MB3415:
x-microsoft-antispam-prvs: <BYAPR15MB3415AAA7BD7D5E46F97BC005B3A20@BYAPR15MB3415.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d/yIuFogvqHww3jnB2d0Vaq3TMtR0DI8MMpvQafJ3iWgLryOa0eDeBy8RXLPpIDVAT++tf3tnSHD2dLQjobVs5eqrPGY51Vrs6tBo7orhS2IX+moU55LHXVj7QCeHDC4/dDKhQaFTegdevIW7vrrwZ6B1H5VmOkuUDcEg5aPpi8fDT0KVulZ/ppIxABlA/kDL5dK8z+2vPiYATs2hzoVDtS3M7e9uG+rRON3+SbUAuaz8ncTjwR0m2TrOoAPiwr6j79LFjBZlBmmMiquvTTVqE1YyaJ+u+jd2JlBgCPh8q65fbCDRxF6rn4xQipimzwOYI6uhNuapMslZYpnindKn/WcmuEmmvJIDHraxcZWm60KGsTx49WhBV9qSzOBv2YcvZWIzS988ZF+GsFFLE72NS19PULw4MUHhG66yQdOov8SjtAO14Bx1cT+xflp+awdXdY+/dXrYM3ZPDGOvaVDIXmaxRBYchsfCe2VKLUcfs5WZYIWOqaaDg55esK9J0ZCgTS6iWPMr4T1z/Ff7fJYDxfQ+NrWEqGO6/w9QGlnQxweENB3VYtY3ai/5AGn2UZXg+bfEaZYCQ2oXdCk9peuvDTHTCgOQtN0Kprzbc4UnUWsidzXMR1WDmvcJSfxZg4s5xNindc8HCEYyW+Uw3sEyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(396003)(39860400002)(33656002)(36756003)(6486002)(71200400001)(6916009)(8676002)(8936002)(2616005)(66446008)(66946007)(478600001)(91956017)(76116006)(54906003)(86362001)(186003)(966005)(83380400001)(6512007)(53546011)(6506007)(316002)(4326008)(2906002)(66476007)(66556008)(64756008)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uPyM71HcicwnnbyMsQUmlSJrLoKlvzQyFyeJQUVaTYmPIICd0mhdnSOj/V+k?=
 =?us-ascii?Q?D5jI46M0LLOZvkxC5kHS//yaCQdZG5e6s9rBbgD5h7bICUaIqjAjrqo1haDK?=
 =?us-ascii?Q?ol83FNdM4ByfniReHY9xJmankx85i1fRbMoBHJZ3FRcqSVTfbdcLbn4F7C1m?=
 =?us-ascii?Q?YR6pnHarzuvepJJk0zvfp2b6vHJSF+2ONYTn3Nhb+UXGijNIiR6BCANI9thB?=
 =?us-ascii?Q?z7MOGRsw15maxDPatz1eXTcht1/yWtiuhguRc2zwg/jDzAJ3lFzWhaH2R0nJ?=
 =?us-ascii?Q?ItOpWT+8lWaajPYkMaRqYCEVrOAYFEaF7XpVglEaapWn+oWQ1s9hUSx5IDNu?=
 =?us-ascii?Q?tre87MAymektFm/68F0E+WczhwjVo6qcaRloOj8R0C/UB/gHPQO+w3tUDRdE?=
 =?us-ascii?Q?RSo/473iCoxu9nw6z3hvJ5MJd1C+RQrasxgY96vxqoWXsQk4etcq/sktLgfE?=
 =?us-ascii?Q?veSChQG1eqaIy53Fs/xdNRLDaBpup8h1zcNsHnuMAVAmE5Kg2hUm9pbb4uMg?=
 =?us-ascii?Q?bUcp13lddetEo7cB49fQYSdf8nHN7pJAWWRBEhC/K7QBAJ67QmtIUkAJjO72?=
 =?us-ascii?Q?GLlZ39PJRVQNrm5DYe39aes58pLLqRLdACvR/LeY4GJfKfwWyIs2xPdx4xte?=
 =?us-ascii?Q?LrMQzAhGjsWfU06oBPJyE54y3gqnBg4Sl6Wyl6wayTQ0Wl7iN+Ehs43BO/Q/?=
 =?us-ascii?Q?GQVT9Owlu0aVrTgRc1mjy32Dyb8j+1B4NssZ0vVRN7e2FOCpupjcr7pX7SNi?=
 =?us-ascii?Q?Iu/k73cKFF8d1Oe+VTMGdboHbqula55uRzNKY4tnXcluyXk45FJpKMzlWk2A?=
 =?us-ascii?Q?72IE6BA613wdXA+BX3KpdO2V2Kr+Guo0Lm+e3DXUBs/vL8uGx+jYzicgpm5q?=
 =?us-ascii?Q?Dga2HTemYoxnm1tvMmC2ltFjh34G1EAhGHhZPJ4Tf4k09B7L4MFZ3RUuO5q9?=
 =?us-ascii?Q?nR3X6DhjHGEsj4IIsTflmai+BZ6BHieNvZzmP392nm2cD2y3YENkloEP3pMQ?=
 =?us-ascii?Q?YiZ86+XWu7d1KM/JjWfnNuJp3Hfgusqgpb5dSNymhwM5CS3e3Luy2MJqfHCx?=
 =?us-ascii?Q?3hFh3q5NJyaBHmvmXuL3D8k/Y5r+gZZ4+KCl66dqrbA0q/k2lUw=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E45DCC7D939BE4388165090D9C18BA5@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ec8b59-1eed-4eea-f515-08d8bd60948b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 16:29:37.7936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j6+2dRUkXH1tmjkA/WhSOeKhu3c4Mb+4cyVEc+xnRZjB+NFJEhFlJLzTNrCKCAqFzhmQw9+9++PpdvbTivMKtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3415
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_10:2021-01-20,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 adultscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

> On Jan 20, 2021, at 8:07 AM, Song Liu <songliubraving@fb.com> wrote:
>=20
>=20
>=20
>> On Jan 20, 2021, at 7:59 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>=20
>> On 1/20/21 12:28 AM, Song Liu wrote:
>>> Hi Jens,=20
>>>=20
>>> Please pull the following changes for md-fixes on top of your for-5.11/=
drivers=20
>>> branch.=20
>>=20
>> Don't submit current release patches against the old branch for the merge
>> window, you need to be using block-5.11 at this point...
>=20
> Sorry for the confusion... Will rebase and resubmit.=20

Please consider pulling the following changes for md-fixes on top of your b=
lock-5.11
branch.=20

Thanks,
Song


The following changes since commit b4f664252f51e119e9403ef84b6e9ff36d119510:

  Merge tag 'nvme-5.11-2021-01-14' of git://git.infradead.org/nvme into blo=
ck-5.11 (2021-01-14 15:17:33 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to dc5d17a3c39b06aef866afca19245a9cfb533a79:

  md: Set prev_flush_start and flush_bio in an atomic way (2021-01-20 08:18=
:10 -0800)

----------------------------------------------------------------
Xiao Ni (1):
      md: Set prev_flush_start and flush_bio in an atomic way

 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)=

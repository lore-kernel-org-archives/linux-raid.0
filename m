Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D98C433E9
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 16:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E84A0233F6
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 16:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733043AbhATQI3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:08:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40190 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729676AbhATQH6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 20 Jan 2021 11:07:58 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10KG5Gkx004057;
        Wed, 20 Jan 2021 08:07:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mXO1zuJFBVIo+Z6QNp++p3MVWK7dFipSYdIX9ZuVx3w=;
 b=HeiiGfkDtbUTya3h27UTMUV9X7RL7oPLx3uUE0NWvEvtimqN2krfLzPVIN/bQ+OZ7gEA
 KrwZHHJsNkwQI7Ae2UjgZ8fmYFRWE63Kpx9q6OihaPp3waQQ/OQC0Jiv8qedg58IoblK
 uyogFIIwpgLaJDmVno0lHCqGHj5YnyNqOzk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3668nvm6jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 20 Jan 2021 08:07:15 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 20 Jan 2021 08:07:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Peh8Y5imisDQm3gAaHVf6heMxbuzbS6mxj42ZlF1HrYz06aUoBtFcb9YM/XG1HIXNJQ/zLzwGYFzcdw/KNiaer2NMNUNnFIXSKoeA+Azrt/lWCmXYEZwiFMfu/liXMv1iYGW5R1TChzwCHIVXTjkumDK5n+6FBgxQyhNFANJdBpITlo8mWOTh7Rim6f4MNJC4MLRRIEb9SHAZ5SW7DffUJXes8f5+xm2uiEJGyQi339CtsVorV1pOYineHmexNsSRAN5uN853J3TqFU7x8lPoyMVmxjcueUHJoN4KoG+ehuEUoAkAsYykgBwqDABz23CmGc7INiB5YCkkZ7fEKMptQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXO1zuJFBVIo+Z6QNp++p3MVWK7dFipSYdIX9ZuVx3w=;
 b=AqBN6Op0aOcLwNZfuF3pmyVr1ccopLe/nzva6JoS3S8TwNFt/CCVpaqYBMUPohRe55GtMHZAeQejLaEzMfdAcIYVF0ophhROwWk4oV2LYcHZ1EHMGMC1vwfjrrXsJHXqYHYA8bes3j1MO4BXWoJw1seLPQztHCORmivXoclZNAjh6hz2eEthiHs8DxyXUWLIpPy5Swc3Ef9JSrhlA1wY5gFvsxdw+FOVRcHa2vlPTkCMGHCSyJ6l21TTbT2FXobFs6SzL0mTyiGCDU0hjatnsYZRKMRtsTX1p9vV2C+tjd3qrgaKmTEnp+nXyovHFPTaZUxkHg71dhYlvTdKWVP9og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXO1zuJFBVIo+Z6QNp++p3MVWK7dFipSYdIX9ZuVx3w=;
 b=hhnNU/qDPbloT6aI18RrMNI86VfgQ5zUo9cEfb/KSAqfVSq9cSSEa7Vo4yyGqPNDXITNT1WMWK0iOJsMvVmGUd/IdZmP71/Qkl+1/KEehGB4/qmeZ5Ki+U+6qZ6cH+VPyJTXvj8FNX/JgTJwVBoYWnN7GDZD2CJlis1wCkASkFE=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2405.namprd15.prod.outlook.com (2603:10b6:a02:87::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Wed, 20 Jan
 2021 16:07:13 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 16:07:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
Subject: Re: [GIT PULL] md-fixes 20210119
Thread-Topic: [GIT PULL] md-fixes 20210119
Thread-Index: AQHW7v3SOp01z7POsEy2/TW0GuItFKowrFsAgAACR4A=
Date:   Wed, 20 Jan 2021 16:07:13 +0000
Message-ID: <B68A8E6B-D79F-4AAA-AB7A-E52F6213B343@fb.com>
References: <745AFA65-3D87-4D24-9B16-D1DE59CB3AC6@fb.com>
 <1b5ab25e-7ab0-ef51-ca3d-b2e25d916533@kernel.dk>
In-Reply-To: <1b5ab25e-7ab0-ef51-ca3d-b2e25d916533@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:ad14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f1599f3-f302-4574-b42e-08d8bd5d72f9
x-ms-traffictypediagnostic: BYAPR15MB2405:
x-microsoft-antispam-prvs: <BYAPR15MB24054A866F2607739F98510AB3A20@BYAPR15MB2405.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x/7xGSx+roKCRwoU7gvzAE/famqmp5G8Y4UI8dp3N1ZTMSuxfl7naht8Ow2HscrX+IWiyixR+mBWxCuFL5wMeHq1jGawyVNlbW1isF3jpEbPk8206fw4iAy9P+VMbi74HE3solDu5lhhq7W/KV0IrPirbOaknU9w7Wk4TPjfs96jv4Q6gBGM//FqavL2PCM0QmXZv/rpziG9FdOoFEu9N/B0wKFPE0b0jThV3NqomVxV0EF33hLFq1fCKVMhaSj/VETnpMPW3DEGVsIJGIHNIZoxbXWpiMgdyFSDyWoVz0cOSYVp6zj8kqyCtT/+eNKF5DkPaNcDXBcrnwg82jezAFiFR/sd7B0RRz5E0zrrWpHjKv4RlgTL4E44gEhyBGIdab2cHrZBHZ4EnTnp62/3QPvngG6yx944QcrCNFDtHCPop663fcv/fgTDFUeZrBUV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(64756008)(6486002)(66446008)(2906002)(71200400001)(66476007)(478600001)(8676002)(91956017)(54906003)(186003)(53546011)(66556008)(4326008)(66946007)(76116006)(33656002)(36756003)(6506007)(86362001)(6916009)(83380400001)(4744005)(5660300002)(6512007)(316002)(2616005)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?RSQzR88THC0LWcIRqzY06hn7R7Nxv5O/pvBYaK4P43aUa/Ye3V8nP0PBffYs?=
 =?us-ascii?Q?9IO2LzFZOVEzl4Bnc+elqsoPSAC/fs0yc2pcFok1dxRhkQiE6JhsTUWTctVe?=
 =?us-ascii?Q?T/IU44t00RyqlL1OA+Pe3MYnkiOJAh+Z1GjY28Pr03nHpao3VqeUSsFKJbz6?=
 =?us-ascii?Q?v2LFbM/v/ij+wR4a9O3MaylWYcQPVUfroCcrn83u+IGl7jDLDqy+Rce2f9q9?=
 =?us-ascii?Q?uUxPGXeol/VtXUqSdArivtM2kahJNgPDfvL7zv0+t+/1KcMjmHRaDMxRUFJK?=
 =?us-ascii?Q?XaJ76Mn1ZxnkAMPlvK/Ga38QRzQN7cUMQRCK6IyvGUpR0wU8yrsps/ZNPzEg?=
 =?us-ascii?Q?vNnZ96DJHnww1YoMGU+QScu48XX/xnInwhV/UIQnUa4ra7HMczAiq1VGGpyQ?=
 =?us-ascii?Q?gTvvYHCFFty9nPdggytiYJSq4UQ3r051IXTra6huox2F6oQsNZFThBkfniLf?=
 =?us-ascii?Q?0YR81ESXDULqenFo1cJf6G5RLuvgJy4CFq8WcjMLsvdLQOOLVT6isSodYnEo?=
 =?us-ascii?Q?BI+8HBtT89X490X13cHu0SxMnsXAs73uAdZQlugm7G3rSqH7lbaPCgzT6+1W?=
 =?us-ascii?Q?QrcotSjgV0+G1dh9SCdAn3DZWuN5rp/JWIql2ZKVu+7M1AX17G2ghHzOq5C5?=
 =?us-ascii?Q?B+v0YruZp4Iyiq4Azwj4eJzDqgPkj3oEcu5bA2RnzcC6Jc2KxsQDGmzcZInA?=
 =?us-ascii?Q?Il2jHeMTj9Is6BgHkw0Cv2nJDh8sSl6bCQK+808KH9/oOK+HY/VafRRcKOqg?=
 =?us-ascii?Q?R9KCAxBY2+dcQzX2Tba824xqyeOQn8d8ZYDLwdpxIUwAzx2XtdtZtKoEGEkD?=
 =?us-ascii?Q?uyqIIDOaJjmbCKz1s0dPFMAg0NAhr8J4FW6vauarPQ77ZT+KnT0dt1mIBn6+?=
 =?us-ascii?Q?iNT5CIFKEEkykyDZcmdrtItDIgQa/VRA9whxva9H/jAbX7aMPWWnPLMwNgNz?=
 =?us-ascii?Q?nzCT8xz24hjcFgHEOkqDnSsCD84JyGuh5lPvVcjY+GZHdxS2a1Cnizf5v+JO?=
 =?us-ascii?Q?eW+ElvQ5+wiwyZNYCH6zi+dtY/l2TvA67o6cAaj2lHvesjwLkVPPq+roOwDb?=
 =?us-ascii?Q?PUMDlzZJEThXyw/qlVE0rgTILypkaR/l1mxxn7mL5ss6FAPr1Rw=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B636F6F48FC06B498DB65F90C81DF4FD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f1599f3-f302-4574-b42e-08d8bd5d72f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 16:07:13.0391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vfOXwOA35SKgcdv+QDS9GLlbuaBITnTeEXp5JMLjUGlEusSBcepvJ0zcgO6XKHsMcmGjOAhLOE78dABlzQgvKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2405
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_06:2021-01-20,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=943 mlxscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Jan 20, 2021, at 7:59 AM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 1/20/21 12:28 AM, Song Liu wrote:
>> Hi Jens,=20
>>=20
>> Please pull the following changes for md-fixes on top of your for-5.11/d=
rivers=20
>> branch.=20
>=20
> Don't submit current release patches against the old branch for the merge
> window, you need to be using block-5.11 at this point...

Sorry for the confusion... Will rebase and resubmit.=20

Thanks,
Song


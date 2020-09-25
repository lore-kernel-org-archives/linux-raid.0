Return-Path: <SRS0=Fkpm=DC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303EEC4363D
	for <linux-raid@archiver.kernel.org>; Fri, 25 Sep 2020 15:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE6521741
	for <linux-raid@archiver.kernel.org>; Fri, 25 Sep 2020 15:44:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="Nw5lD3++";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="Ro3HQmNR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgIYPod (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Sep 2020 11:44:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727749AbgIYPod (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 25 Sep 2020 11:44:33 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PFc8CC031492;
        Fri, 25 Sep 2020 08:44:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/7ynO77hIbIvyQYJAq1l4UDqjl66pEK/NsIxJdrxuNM=;
 b=Nw5lD3++/l7qXxvtEjCcpsjtw1mfWxh6EHr1/x+H7Xt9PjjKPbxYSdVM10oPeSgUHvw6
 pjhuyYJJAF6g8/r4azgzkKq0GRuRLMXKhA9XX9mdwVYYietrU4D2yDB9CX7SHsIHV+Q4
 d9zMC3UtyYkhfMTlAl83nNQkwLwpQGsDLQg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp68bee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Sep 2020 08:44:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 08:44:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdPOz0WYotRZn7TkquZtgp19q4XYArf0V8QFeTKZ01lcRQFVF509x0XfNV+yeFyfEShtu/lc0cPWLKRy+gpbBIQf5ybptrSWA4P3TF1aSeyB2wLK1GbGLE21K77+m8ix5IdtpdHOV1Z16fY4WHziRmkI9l0yacklAEDNjVIU+g+ARR7MOHHsYd++vSbdEofISTVM3eqRqRH4rVbIIuoW9wgul7r9nRm30lEal6EPIH1F3eNoTA1fh2VWwLR4N2aMLeBkyLK+pHNQFix7/cOZfeVXmShEZmnS7O7YoS+5hu+t66KeKDCSkiVND3Cv8g0lD5C5heLcRAaTz4mEMKjiFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7ynO77hIbIvyQYJAq1l4UDqjl66pEK/NsIxJdrxuNM=;
 b=Y2teww7bAvxxhwIFzb42UCDYvfTXiTdRR+iquU1zw3CkrMDUzbCPo8UEwU098k7zE0o3umWDvvzYNqlQcFHZ2/0rK6FeC7nWNzy617q/7+oW5Vy08n+pLaPo1qe9VHsoMnqifBpwUboECL6+qkrMNdX+Peh6hC7LkhTA1QZy9zkRRMWxvDkSVFehEkGpAe5noizPBN6OKWB/BjWysHg8YrpNaqSp07PRE+UJuGhfUxIv1w2zzJPSP65cAL8UTYGNXy5M4WFix2b+auMtXD8BUTVJPyX77ShOmJCGhJ3mI2AbchENaAD1ICKJOFZY/iFGBbnP6rvigX3da1pLVxexIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7ynO77hIbIvyQYJAq1l4UDqjl66pEK/NsIxJdrxuNM=;
 b=Ro3HQmNRd34SBdZB+mBCSh+pUNFU8lFDTa89ceL7+6Aq8s94jih/I8+n6ReEgDH9kM2pk/C16FeI3k9OQVTERcozYEZJ0fVDjN0M2OalxtuqrNBP6d2gMHA5g5agx+ybiBLptDj90L0mEbquLihL6+oONv018EyEj8Qh/RNQvLM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3666.namprd15.prod.outlook.com (2603:10b6:a03:1fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Fri, 25 Sep
 2020 15:44:08 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 15:44:08 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Xianting Tian <tian.xianting@h3c.com>,
        Xiao Ni <xni@redhat.com>, Yufen Yu <yuyufen@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: Re: [GIT PULL] md-next 20200924
Thread-Topic: [GIT PULL] md-next 20200924
Thread-Index: AQHWks4c9XeNzZKlqkGKhDnNwEqYQ6l5X96AgAAf7YA=
Date:   Fri, 25 Sep 2020 15:44:08 +0000
Message-ID: <4467163C-2562-43AF-918E-D53A42F18124@fb.com>
References: <AB173AED-FC49-4098-BFF4-CF94438CFA94@fb.com>
 <b3772d42-2cb7-39bf-f380-2f10850c3af2@kernel.dk>
In-Reply-To: <b3772d42-2cb7-39bf-f380-2f10850c3af2@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1431abfe-fa16-490b-9eac-08d86169d74f
x-ms-traffictypediagnostic: BY5PR15MB3666:
x-microsoft-antispam-prvs: <BY5PR15MB3666B98053E3429BFB1EB83BB3360@BY5PR15MB3666.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zw7oBnw04ahE9rcZHjqgoI9qSdhU542DMyXkPQdB4LVdDhQ5vh4OgGPPfoUvUaaG09rqD0cbQ7U7OZbdR6ljDA0NQHp11Ok4TKgjC8W9ten0sB72g+JY561naxIiOMGWRw+zdHOZwjoUz46V4fKIbpEeYdfxspM1DVtD9nwZZl6Ob/55WLb151vYcMmBHGq4fqQy1FgChEPmIk0n0Tf89YNFfby4ybZ88uHcybho6m1cPCRcQCE80ycxK0tn8Ph9ujvj3ODrXIaO6NwpMecfpEYXFNwmlHttgg9Bd+pJXJKoeT+5CXYYRhKRXrlXqb7fLLvlYe5zZLIOROAXHWllBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(346002)(136003)(366004)(91956017)(66946007)(4744005)(186003)(478600001)(76116006)(6916009)(36756003)(8936002)(33656002)(8676002)(6486002)(86362001)(54906003)(6506007)(6512007)(2906002)(316002)(5660300002)(66446008)(64756008)(66556008)(66476007)(2616005)(83380400001)(71200400001)(53546011)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PAEoN5N9gQXZHohMwF8NZ1IKt4tKcIfWjR2/oOIfQnSXQ58xg25meZAqjQkp2R6vehpTr6fbRRhgqqGZzOb169v00wF+8R3ZOdNTjV3ujtCm9YxtJNblSAqcm4kV4vii4zdvh59mPTroWtPnCIh82QqUFVrLFAEZ6xuRBIzPFi8DFI5GU++U5Ldeq22ITZEpGhsGg7WvgkdtlT/oOQGvIfBaSPeAkUPaYr/2EVnh6/DY/zribqbbhhiLokdsP6o5ImIFzGOT4nSG+MC5mqQOm4v+5OQ5gdGcLEaMlu1yuhwgWykG0pwYd5lys5X24ipEzQDkGe97p0AbI01/wo8NN+4JyBHBYwzbxt+aUrozr7hlQcHzYQwpIa8mTTPSz2Tp97G3khfkPU285sTD3h4nT6O2OSgkFqKnjKe+jELyHC9wQ4wliC8Wu+tArhTj+Wk27bU/tZyQzWDsfq9objB1u23LfPBL9p1I8OYdT79iI2bG/a8I0zemUVI/7lXUYML7zuRBujX2P6IfD0vaebxDPT3TNkUBLztI1i84qEvEnSz1KSQQCVpkjI/uIRZyHKjPCXIbGKHWY4p01J0CK6u1ybiR5lCPZCPFoqeUmvs0DUYxTSYHHJ5Qm7VtXodH6CP/6lvvF909zbmj48mOdzVGTFafuAV/mqZLGVq1TRylWf7BcGmMS7s5gLTxmQgEv18M
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4B71753D75EE0C4C85CC7DC544283756@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1431abfe-fa16-490b-9eac-08d86169d74f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 15:44:08.2895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wR4ZPOTZLTK6IBoNmqPUWZTNa7jC/iGbSGrv70HR0E7KgeGthABWYXunJTsnNEH0mdCUcOI76X02cfwlB3tJIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3666
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_14:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Sep 25, 2020, at 6:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 9/24/20 5:54 PM, Song Liu wrote:
>> Hi Jens,
>>=20
>> Please consider pulling the following changes on top of your for-5.10/dr=
ivers
>> branch.=20
>=20
> Pulled, thanks.
>=20
> In the future, can you please include a summary of changes in your pull
> request?

That's really good suggestion! I will include summary for future pull
requests.=20

Thanks,
Song


Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18B8C433E0
	for <linux-raid@archiver.kernel.org>; Mon,  1 Feb 2021 22:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980D664E2A
	for <linux-raid@archiver.kernel.org>; Mon,  1 Feb 2021 22:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhBAWBc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Feb 2021 17:01:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39738 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229483AbhBAWB0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Feb 2021 17:01:26 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 111Li6qh016673;
        Mon, 1 Feb 2021 14:00:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9gp9xhkiuwdwEXlBUAhGlQEphPz3Vn5sJCaAoLW1uao=;
 b=mXLVDZmFv9CTVCEaAemr12/CF5ykpjpI4/AzwqUnUvmY/j7E3dgcl1/axy7QDMbOmpLV
 W4Q7+Q6sX6yQe1T4+H4trRpZ3GyDtwyyq5dLPCFaKC2LtV5PLguqNp6kv8Ymiu/psPJD
 7Lr9Z94O18AsV3AB1YMSGOyhovvmQdLF3T8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 36d3u6j5wb-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Feb 2021 14:00:43 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Feb 2021 14:00:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpNKjWD42N+vNyDZx0zmMni0olakxpGmDHoXtnrY/2lXirVAYGhvYb6G31r8VClTet84y77LMbEZsH3lxALNNgiay383FZIOp49cuWOJlozbKooNc79Wruo76x69DoVL7QJU/9y7Xz4pNsv6uV7H6A+W/T4YAl/GHzpdTbSDM2DsgaZC1tz9i6QiSZ2sytZafYn9ad6SlTb2LqxeifOMOv6jmEssrViSt9F6fRTwLNSd837VU8DylIVmyUOJ77xbefy+oawA+PP0pKSSMT44fkuSV8cn6fpDBw/vaq99wbk6IAejCFQU/BC/3iY0CYXkaxBf2zUG9Uqs/cvnzpeHTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gp9xhkiuwdwEXlBUAhGlQEphPz3Vn5sJCaAoLW1uao=;
 b=aBFvH4EdhgUUvQBV2mNDkdAJufgM4kt5VOyKwLnGkRlS88ZJBnTdWWW64NkrGutm+pVl0IZ0Yv2/tY1F7rfHhKFh5g5BXNgEx6tbWVMhC07mb66bigBn5/eRH/MaK9eUFNFL/PlxmazF/X67AlUQ4PMfbxmmWDGrjiYmFxYCKnvKhR9abPEX3XoTr8kdDa3rFFXbLrqa4CcgIm8OyE3qiNJYXfrBNT3Z+j2bmI9LiosEGo6lMcaLpNcUCNcXV6WnIa4cXLJMj6fT7nuT/bJl1Jzjq/Ic034XuxfeVoxv6FdLAp1jDtHoDyyqjJlBB25WfsZLmrcNM1kYDJtZGGugMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gp9xhkiuwdwEXlBUAhGlQEphPz3Vn5sJCaAoLW1uao=;
 b=btbnKgofiNuIWz2PQIbGfMqoBGS8MyczqZ1cpA4SL6upLqAfvgSZlfSN5ITuDCfvjt69xK9fZbv7zhq3C43bxowPgZtSqR44ScKxRtbkO5XL9gJcB07DbsuS4/fuZLZSi3c1CHXQ9h/2VyX3ES+iTh+zHxFAt1Y+anYeQxDhe8g=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2325.namprd15.prod.outlook.com (2603:10b6:a02:85::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 22:00:41 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Mon, 1 Feb 2021
 22:00:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Vishal Verma <vverma@digitalocean.com>
CC:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Regarding Raid-6 array
Thread-Topic: Regarding Raid-6 array
Thread-Index: AQHW9TMOSnFeEN2pJEm526QCtpFqkKpD4PUA
Date:   Mon, 1 Feb 2021 22:00:41 +0000
Message-ID: <EE769930-E732-453A-A3A7-CBB0F6967F2B@fb.com>
References: <CAPgOLid8qb3igOttaZx1dSwPRpvHDaFbiqn+mFAaYZDaepijag@mail.gmail.com>
In-Reply-To: <CAPgOLid8qb3igOttaZx1dSwPRpvHDaFbiqn+mFAaYZDaepijag@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: digitalocean.com; dkim=none (message not signed)
 header.d=none;digitalocean.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:a96a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef3c7fc6-0b04-4e40-b0f4-08d8c6fcd10b
x-ms-traffictypediagnostic: BYAPR15MB2325:
x-microsoft-antispam-prvs: <BYAPR15MB232511862155810675EA8448B3B69@BYAPR15MB2325.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Me/KSyHe+nEduNY1OawSzZsGEzx8kQxtXCEAx23SQZsSSobpMLZHyj1ycvnaomm4f240U9iZ00++hmrdNJezTdpyepgKuKqWEqnSkqaf6dUwwyFcm5AReox7eWu8SbMPwb9EBcE4/LnL5RUs7Gx9Mx2h1awobpAJndco+A4lYIdyuwuQ0KP7TANcVDTS9K6y8D+8IoXlAW43SBD09SY/fI5YJycj56jRha4BCl6YGZIFb+CByarqyFHnS0JwZHYD5lb+wSZgJwnNloUD7ByuiHkxUfVtkObYB03eno9d5PcQA9z5Xi2a4HW1nMVA21iQ9ZZK0v6E4OO3f2snAmjYkY243GR1GxIYI743Rw/0LHArKJVBxCIFlBXn7rCgZN4bqW1JygT0LJi5OU5ggn1qxXxrxZtG4G2rVQkk4MKZ3W1a45QL5YYdg7Eq2uJOaQBcX0diaUGgJOcAxj1DKiu2nPxUZHjiVUZjc8dgwd6fPOxnruwm6RgML76t1GoRzRfVsN2vvKOXHC2Z8fy5nnLCkOrRw1R5+ReT8yxzUjOrZyOj9INyVyPElFSrZX+thabJy2VJEpjdgMowFWUQGyZFxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(346002)(366004)(136003)(66946007)(53546011)(6512007)(6506007)(86362001)(6916009)(33656002)(2906002)(478600001)(83380400001)(186003)(66476007)(4326008)(76116006)(64756008)(91956017)(5660300002)(2616005)(66446008)(66556008)(8676002)(71200400001)(316002)(36756003)(6486002)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zTgkaM5BwGODdv4cNG+bA7GmBYGAk+3zgiJd/j5X/3OJkAYog1XcjVCxE2UN?=
 =?us-ascii?Q?q3j/ZYdJhHGNbIhEx411OerlSrzoZWWl0nxKjDx5jT3u6ppBTg7sQ1gzXwDu?=
 =?us-ascii?Q?GCzdL69urnJ/IhyTGaXm6xxCLW2Eo34NIUSNAJ8OSRPBjU9Kjlx03xK5idU/?=
 =?us-ascii?Q?hjS75RjTE0hiAFlgL6JtlxakBmut/Z5psEh1TOePEUZi0ZU5MnJwfNSfQxzU?=
 =?us-ascii?Q?1afQSEogBWdxLmPwQQlz9qGZG6eGXYT9DnkSvvuvGNew8exyet56RQm2HADB?=
 =?us-ascii?Q?8Toy3Nk2MDTem8AtCRADlTTiZrUsEUEdIQiOXESuiF0XeYknFtlnVV8d0HUf?=
 =?us-ascii?Q?0X9/eiMhVx0vWfLeevlD6JgFNUkKhMHqPGguL7AxOLnoV7PyB2U9lgmY4DcS?=
 =?us-ascii?Q?cyCY48iziI+Et87X7sSQzHmwUwYTwLFSRfGsmoLA3uy7Wgx3ndM5Fvy9tS1p?=
 =?us-ascii?Q?FVUEfIBS/oMVDISxj0AWnClHVBO8bPJzxGKwFegL0StxHHXo0XLOZ4a5GELV?=
 =?us-ascii?Q?j5p0lQ46cI6ecLmYzr4Ce/M+l0zAXOKB08JUDPbqlFu0wLCWae9Tik952tvk?=
 =?us-ascii?Q?0FzmZ5rGwQlPoK5uvSMJYWJpuZMTn0O7h4dDBnSBrpuy/5mHD+eqtt+loGqm?=
 =?us-ascii?Q?rchUMFAt6IIyDaQMb9/pWlCiIY4xG9l/cuH2SCX4f7MDVF0tWhITz0X6bZ5w?=
 =?us-ascii?Q?RvqQ6tk01natzYPl+FzkRj8CyTPd41CLoUgFhmbYU2PKeyh+ixahm6+oezs5?=
 =?us-ascii?Q?XUkNIKDFNfCcopYxKMwHfF20PDr++LKsGdeLnVoKHybaPwdz0gDoYBR+saSI?=
 =?us-ascii?Q?cH3kNQxSukuluSBv0rx0zNsq3Tbdkbok73UcY9edp1poq+x1eP3K4LEE8TSA?=
 =?us-ascii?Q?gz8S+8UDm1dXJjy0ncYoUTTYhDrrYq47GkX9IW49xwk33c+9K5K2w24DU4Y0?=
 =?us-ascii?Q?no1O4wV4UXrOUV/NYgNZyfw277ZVOPyi5e7pu6f6HgQmzXxnuly+995/Eh/5?=
 =?us-ascii?Q?CFNUU6Zj6sxvxxM99ZoNpnng1BZ6l5lW1vzG+a756hJdbgqk1+FrJ8MNieyJ?=
 =?us-ascii?Q?uPvSeoH7xC3NRqci9me8smOYF9J87sXhT/0dIxiNAJantnwtCPY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CCA19BCB8E0FEF4E8FDE216280BC4CB3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef3c7fc6-0b04-4e40-b0f4-08d8c6fcd10b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 22:00:41.2708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mb9yGwv5MR4OJeaxdxTYt9BtZ+eQd6DEfUqqQdhNyUaVW7Al/rpplUgoZZYjcOGo6KRtyo9+Khw4sUtek+1CXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2325
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_11:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=735 spamscore=0
 clxscore=1011 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


CC the list

Hi Vishal,

> On Jan 27, 2021, at 9:04 PM, Vishal Verma <vverma@digitalocean.com> wrote=
:
>=20
> Hello Song,
>=20
> This is Vishal Verma, Performance Engineer at DigitalOcean.=20
>=20
> I was recently playing with our 6x nvme drive based RAID stack assessing =
its performance against a RAID-10 array.
> I understand with RAID-10 there is no striping or parity work so its writ=
e performance looks really nice.
>=20
> But, I was not sure about the RAID-6 piece, specifically the RMW piece.=20
> I was running FIO 128K 100% sequential workload to the raid6 drive array =
with O_DIRECT and noticed how drives performed:
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.18    0.00    2.36    0.00    0.00   97.46
>=20
> Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrq=
m  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme1n1        546.00 8330.00  69768.00 994900.00 16896.00 240311.00  96.=
87  96.65    0.38    0.56   0.00   127.78   119.44   0.10  84.60
> nvme0n1        513.00 8333.50  65544.00 982314.00 15873.00 237245.00  96.=
87  96.61    0.35    0.32   0.00   127.77   117.88   0.10  86.80
> nvme4n1        480.00 8795.50  61440.00 1045290.00 14880.00 252535.00  96=
.88  96.63    0.35    0.28   0.00   128.00   118.84   0.09  87.00
> nvme3n1        513.00 8425.50  65664.00 1012554.00 15903.00 244868.50  96=
.88  96.67    0.37    0.70   0.01   128.00   120.18   0.09  84.20
> nvme5n1        497.00 8618.00  63496.00 1011158.00 15377.00 244201.50  96=
.87  96.59    0.36    0.64   0.00   127.76   117.33   0.10  88.20
> nvme2n1        529.00 8306.50  67712.00 998920.00 16399.00 241243.50  96.=
88  96.67    0.39    0.37   0.00   128.00   120.26   0.09  83.60
>=20
>=20
> I was surprised to see the amount of reads the drives were doing even tho=
ugh it was a full 100% write test.
> I understand for every write IO RAID-6 md array has to first read P,Q rea=
d the data and then calculate new P and Q and write the data.
>=20
> However, do we expect the drives to read that much i.e ~65MB/s (6%) worth=
 of reads for every 1GB/s (100%) of writes?

6% of read for sequential write is not surprising. In the worst case,=20
for 4kB write from upper layer, RAID-6 does introduce 2x reads and 3x=20
writes: read P, readQ, write data, write P, write Q. The raid layer
will optimize full stripe writes to avoid reads, but it is common for=20
upper layer to do non-full-stripe writes.=20

Thanks,
Song

[...]=

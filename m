Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4769DC4361B
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 17:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D66AF22AAC
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 17:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388876AbgLLRF3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Dec 2020 12:05:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45720 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726209AbgLLRF3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 12 Dec 2020 12:05:29 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BCH0P5k004419;
        Sat, 12 Dec 2020 09:04:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DDKNXXFTnTIcbt+kRpygYtuxYhfTmeeMEjHoIV5Yyrs=;
 b=ofvz6JgJoxsS/n/IlH75h+qxzdZtQULrICs82ezXQacWu/0gp0pFDIfmGcT4Jc7jv+Gt
 tmMONd2yoHM/idMaAeM+wdecTtd9lleUWLQOIQSTkobuiNZWNTqdP73NGYY4NANHyXVd
 BAsNjnNgah2tn0tJLMFwsSp11Ucf3E4skvI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35cvfw1385-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 12 Dec 2020 09:04:43 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 12 Dec 2020 09:04:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cdi1zO30mdnmsdYDC62r1xPjivU1Zrh753UVph5166UQCXM9TszpxNWFRn9i6T+INgWlPRSvEkuPfAhNndalz7BQw35NYh4ZZjiIPbsU85inmHb7rBIGuibeBRSRcydav9D/q/SgBlCBZHWByi2TkjHPcB0ixlNNN22RwJMkBPM90/fKW7JYnOiXEveGGh4ev4RdigX8uc/ZCCDQbvcpzgZubWryTvNXzD4YlgsJA2S2A6Dsn43hfBCwL2HsSfV/3msuhnbkHgfOjgowZ26Jt6meWTv9foaWgcKISoPqAWVuz31HAVVoxufmxjdBGHrxLBFXXcs0juo0cvOV8IefOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDKNXXFTnTIcbt+kRpygYtuxYhfTmeeMEjHoIV5Yyrs=;
 b=FqX1X6EqBr7+l8rCOKJtzjHA4kmL7s6rmHWZgqyKitod17vkCjKwBn2FcJmkkOmM09wC3iwRqcOOvuOLPEzgxGQjEMNjVCIkJbS0np4FptGhf0csHcQLKe+wEehtEptDwTmevCtLd8J4TzrdFgqmU8eaKAxJwB44aAGirKtTxI1wt6X19vWJWtGtVx/OZ0RAb2v2Cj7qMhFJmqjSjRHrvYLXo0hsHGlno+1oeFoEaTcObxpKpBOJTfjLK1Qt2icmbyNg2nXyJf25w14WsCvZMRFHjSHQeu0NlOmSvVOWECwHYUvMIB744Rw+4L2QdJAyoLUl6RDC7HN7GU5fKqfjgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDKNXXFTnTIcbt+kRpygYtuxYhfTmeeMEjHoIV5Yyrs=;
 b=IBcTvhuFCwea+7OimrS1RKpUiEZDr5zGzHEkYc9uL33s3jeF1JlQU6mpz8A5NvmHiULe9kjRJ55jCPKtepYSMuBYxbaGFwJa443Rw7ePD7itkge4akxgDyLohW//czbhuj4/NXQKw/wIobBGK+v8k8zwwmTrs5YLvPYxr5LpGnA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2455.namprd15.prod.outlook.com (2603:10b6:a02:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Sat, 12 Dec
 2020 17:04:28 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.018; Sat, 12 Dec 2020
 17:04:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Mike Snitzer <snitzer@redhat.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Xiao Ni <xni@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [PATCH] md: change mddev 'chunk_sectors' from int to unsigned
Thread-Topic: [PATCH] md: change mddev 'chunk_sectors' from int to unsigned
Thread-Index: AQHW0KeiIw2KhQOkrEGtati8GGezYanzsGEA
Date:   Sat, 12 Dec 2020 17:04:28 +0000
Message-ID: <1A230145-26A2-4D0B-A81F-0B0873EAB251@fb.com>
References: <D6749568-4ED2-49A7-B0D3-F0969B934BF6@fb.com>
 <20201212144229.GB21863@redhat.com>
 <2799b859-c451-c3f6-7753-fe08e35f4a7c@kernel.dk>
 <20201212165537.GA53870@lobo>
In-Reply-To: <20201212165537.GA53870@lobo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:e346]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cf37407-8cd7-4cae-6163-08d89ebffc76
x-ms-traffictypediagnostic: BYAPR15MB2455:
x-microsoft-antispam-prvs: <BYAPR15MB24554A54F998D8AF5DB5EFF9B3C90@BYAPR15MB2455.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SDMYYy4KjrTUKlzcosZasxHRj4bciiyELFbuNe2IbBNoGocrGYLumx8x1R/Um8AF8FL8bPsTI4x8Z2U4YXyBnuP0t4bMIiaMn1q3fITbmdbI1Ncmg7TnCf/xeFiW/H87KCZIunUz11VSKytUoQxa07dc179BTg7936MtuXuELTUv0qGgjxK9jHHWthZjh2hPzc6PtngXH72EtiB9ASXAnBQb+vdSJ/n7Rc59m3Pz/rbkRhPw797oeyuj70bKC0/uzpr9Mke/H1EaPzL2ZVSHkq2DN3przEaSKGQt0QWGao2iscEYAGnl0DAvkgNhL/6Y/5heZAvFRcYRCLHXr7XDzaIoyh4botwK6S27Ei4ZAygcVpgcL3MTvpe41nNzhFHk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(6916009)(71200400001)(2906002)(6512007)(8676002)(6486002)(4326008)(66946007)(91956017)(36756003)(66446008)(64756008)(54906003)(66476007)(66556008)(76116006)(33656002)(53546011)(8936002)(2616005)(5660300002)(186003)(508600001)(6506007)(86362001)(83380400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WGtFQUJYRUlDRkwyZVYvdnkrQ3JoNjNvUXN5K3p6NzVOR3l2U3luVzRJNzU3?=
 =?utf-8?B?bmMzR2wvdERsZDAwdkVheSt2anZ4N3o0QUVWMFJ5Q05CSGh6YmlBazhwSVBp?=
 =?utf-8?B?eWJhRkM2d1FVZGhHNVJlYmtJME8xamQ4cTFkRnFNcS90ZFFRaDFOdVVoTUlC?=
 =?utf-8?B?TC92d2hZSTY1Z0FzNldrYlovOCs0UGJqdVZydHdCZmNzejNZNXNwTHlEYUc3?=
 =?utf-8?B?THg3ZFNJWEVZVlZYbytFR0ZmRlorTDgvK0dFemlOWCtlSUVwRHpFY3Jneklk?=
 =?utf-8?B?NVJBaE9ldTV4UkthSkZBMWJSZ3ZxbmVCYXNabjAySWVDVWk0Q3E3SjkvRE51?=
 =?utf-8?B?Uk9zcnQvK0FudjlOVEJOdkFVZTR5cUZWd2h1TlBFUmc1WVJ4a2dDbUsxWlRL?=
 =?utf-8?B?YlA5d2dRTU5RYU1TQURxa3ZwL1dObnc4Rm02THZ0VGxmSnJoQWxOV1hPTDNw?=
 =?utf-8?B?NFNSRWs3V2xKRkFaOGVxdjBNcU41SXZxY0FQQS94UTFtWExYeVhITmVuaDRa?=
 =?utf-8?B?RUJON21GSGlQS21icDk5V0NnTWZ0dDBTYWxxcldTaEdMWUwzcVVRVXNIc2xm?=
 =?utf-8?B?M2MvbEZtQWQ2SjRrcVlMd3kwQkY0NzYyeEtaa2RiY2I0TDZxUE1OamFtbXVY?=
 =?utf-8?B?SUF2RWJUNE9NQUgrenlMVTd0eTVuTHRzUFlINU9EU1BVczREMUxmZ1Y0aFRp?=
 =?utf-8?B?K2RMZVFGVFYrM1dGN2UzdFFpTDUyMDduUVZ5ZXJQN0FlRHE0WmhOSkVMN2RV?=
 =?utf-8?B?c2ZkWjlYTTBuclUwS1ppRVR5eVVFbmkva3h0RHVodWFaOU5hUk55R2RidnpP?=
 =?utf-8?B?d1BBbFBJb0FmL1lVcFlrU3Vsc2lnSVRqclFJS25XZ1lKLytTQkJpcmp3eGU1?=
 =?utf-8?B?R3lpZFkzQlNTTFRYQUcwdVRMcFVjcHIrS2MyK3Q5dld2Tm5aTjNDb1hjMlNH?=
 =?utf-8?B?eGZHRXZvMFRDNjBPSHZ1cXdrT3RKZHFOa0ZhN3haNjM4cUIvZzc2MGxTcEZj?=
 =?utf-8?B?WnU5T2FnNnQrVk5JR2JSaFdkZ3Q2TngwNzRqU1Y3cW5JNlQwSnF0MjZ2WVRv?=
 =?utf-8?B?TlVIVnh5ZlM3SEVGRTloVVZZa2dXRUpRazQ0cEpSTmw4T0xWVUU4anR4cUxT?=
 =?utf-8?B?T2QybDhJTExZZzBCZHNkdHd3WC85MXhERkRVR1dOVnFYV3pWakZ6UmcwVGZY?=
 =?utf-8?B?bkFhcVNYUTBsRXBod2EybFZLUy81QldFVnFQZ0pJaVVWdjI0YUlNREFYamJz?=
 =?utf-8?B?VkxyOWpNcXRuV1F3QS90SzRzYlk2Q1haRXpiekg4SXRrZFRqWWluRE1RQnBo?=
 =?utf-8?B?OXRIRHd0cFQxQnB4eEZnNytEdStScUxHUWtBMG85d1M5UGhPOUxyVHIxS1FE?=
 =?utf-8?Q?lDkLJR/iXGm5OTL4U6HdK9sMsOd2L1X0=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <844C10DC6C764944B9613788F2D46046@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf37407-8cd7-4cae-6163-08d89ebffc76
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2020 17:04:28.3424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wByF42GS25RGk9P4krguRTUNWwjpC9IXFecXnbiaEn2FycBKqqqTDePbaJVymic8BS//zKcsVNygSueehzZJPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-12_05:2020-12-11,2020-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 clxscore=1011
 impostorscore=0 priorityscore=1501 malwarescore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012120133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

DQoNCj4gT24gRGVjIDEyLCAyMDIwLCBhdCA4OjU1IEFNLCBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJA
cmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiBDb21taXQgZTI3ODJmNTYwYzI5ICgiUmV2ZXJ0ICJk
bSByYWlkOiByZW1vdmUgdW5uZWNlc3NhcnkgZGlzY2FyZA0KPiBsaW1pdHMgZm9yIHJhaWQxMCIi
KSBleHBvc2VkIGNvbXBpbGVyIHdhcm5pbmdzIGludHJvZHVjZWQgYnkgY29tbWl0DQo+IGUwOTEw
YzhlNGY4NyAoImRtIHJhaWQ6IGZpeCBkaXNjYXJkIGxpbWl0cyBmb3IgcmFpZDEgYW5kIHJhaWQx
MCIpOg0KPiANCj4gSW4gZmlsZSBpbmNsdWRlZCBmcm9tIC4vaW5jbHVkZS9saW51eC9rZXJuZWwu
aDoxNCwNCj4gICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2FzbS1nZW5lcmljL2J1Zy5o
OjIwLA0KPiAgICAgICAgICAgICAgICAgZnJvbSAuL2FyY2gveDg2L2luY2x1ZGUvYXNtL2J1Zy5o
OjkzLA0KPiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvYnVnLmg6NSwNCj4g
ICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L21tZGVidWcuaDo1LA0KPiAgICAg
ICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvZ2ZwLmg6NSwNCj4gICAgICAgICAgICAg
ICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L3NsYWIuaDoxNSwNCj4gICAgICAgICAgICAgICAgIGZy
b20gZHJpdmVycy9tZC9kbS1yYWlkLmM6ODoNCj4gZHJpdmVycy9tZC9kbS1yYWlkLmM6IEluIGZ1
bmN0aW9uIOKAmHJhaWRfaW9faGludHPigJk6DQo+IC4vaW5jbHVkZS9saW51eC9taW5tYXguaDox
ODoyODogd2FybmluZzogY29tcGFyaXNvbiBvZiBkaXN0aW5jdCBwb2ludGVyIHR5cGVzIGxhY2tz
IGEgY2FzdA0KPiAgKCEhKHNpemVvZigodHlwZW9mKHgpICopMSA9PSAodHlwZW9mKHkpICopMSkp
KQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICBefg0KPiAuL2luY2x1ZGUvbGludXgvbWlu
bWF4Lmg6MzI6NDogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmF9fdHlwZWNoZWNr4oCZ
DQo+ICAgKF9fdHlwZWNoZWNrKHgsIHkpICYmIF9fbm9fc2lkZV9lZmZlY3RzKHgsIHkpKQ0KPiAg
ICBefn5+fn5+fn5+fg0KPiAuL2luY2x1ZGUvbGludXgvbWlubWF4Lmg6NDI6MjQ6IG5vdGU6IGlu
IGV4cGFuc2lvbiBvZiBtYWNybyDigJhfX3NhZmVfY21w4oCZDQo+ICBfX2J1aWx0aW5fY2hvb3Nl
X2V4cHIoX19zYWZlX2NtcCh4LCB5KSwgXA0KPiAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+
fn5+fn4NCj4gLi9pbmNsdWRlL2xpbnV4L21pbm1heC5oOjUxOjE5OiBub3RlOiBpbiBleHBhbnNp
b24gb2YgbWFjcm8g4oCYX19jYXJlZnVsX2NtcOKAmQ0KPiAjZGVmaW5lIG1pbih4LCB5KSBfX2Nh
cmVmdWxfY21wKHgsIHksIDwpDQo+ICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn4NCj4g
Li9pbmNsdWRlL2xpbnV4L21pbm1heC5oOjg0OjM5OiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFj
cm8g4oCYbWlu4oCZDQo+ICBfX3ggPT0gMCA/IF9feSA6ICgoX195ID09IDApID8gX194IDogbWlu
KF9feCwgX195KSk7IH0pDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Xn5+DQo+IGRyaXZlcnMvbWQvZG0tcmFpZC5jOjM3Mzk6MzM6IG5vdGU6IGluIGV4cGFuc2lvbiBv
ZiBtYWNybyDigJhtaW5fbm90X3plcm/igJkNCj4gICBsaW1pdHMtPm1heF9kaXNjYXJkX3NlY3Rv
cnMgPSBtaW5fbm90X3plcm8ocnMtPm1kLmNodW5rX3NlY3RvcnMsDQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+DQo+IA0KPiBGaXggdGhpcyBieSBjaGFuZ2lu
ZyB0aGUgY2h1bmtfc2VjdG9ycyBtZW1iZXIgb2YgJ3N0cnVjdCBtZGRldicgZnJvbQ0KPiBpbnQg
dG8gJ3Vuc2lnbmVkIGludCcgdG8gbWF0Y2ggdGhlIHR5cGUgdXNlZCBmb3IgdGhlICdjaHVua19z
ZWN0b3JzJw0KPiBtZW1iZXIgb2YgJ3N0cnVjdCBxdWV1ZV9saW1pdHMnLiAgVmFyaW91cyBNRCBj
b2RlIHN0aWxsIHVzZXMgJ2ludCcgYnV0DQo+IG5vbmUgb2YgaXQgYXBwZWFycyB0byBldmVyIG1h
a2UgdXNlIG9mIHNpZ25lZCBpbnQ7IGFuZCBzdG9yaW5nDQo+IHBvc2l0aXZlIHNpZ25lZCBpbnQg
aW4gdW5zaWduZWQgaXMgcGVyZmVjdGx5IHNhZmUuDQoNClRoYW5rcyBmb3IgdGhlIHF1aWNrIGZp
eCBhbmQgdGhvcm91Z2ggYW5hbHlzaXMuIEkgYWxzbyBjaGVja2VkIE1EIGNvZGUgDQphbmQgZGlk
bid0IHNlZSBhbnkgdXNlIG9mIG5lZ2F0aXZlIGNodW5rX3NlY3RvcnMsIHNvIHRoaXMgY2hhbmdl
IGlzIHNhZmUuDQpJIHdpbGwgY29udmVydCB0aGUgcmVzdCB1c2Ugb2Ygc2lnbmVkIGNodW5rX3Nl
Y3RvcnMgaW4gNS4xMS4gDQoNCj4gDQo+IFJlcG9ydGVkLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJy
YXZpbmdAZmIuY29tPg0KPiBGaXhlczogZTI3ODJmNTYwYzI5ICgiUmV2ZXJ0ICJkbSByYWlkOiBy
ZW1vdmUgdW5uZWNlc3NhcnkgZGlzY2FyZCBsaW1pdHMgZm9yIHJhaWQxMCIiKQ0KPiBGaXhlczog
ZTA5MTBjOGU0Zjg3ICgiZG0gcmFpZDogZml4IGRpc2NhcmQgbGltaXRzIGZvciByYWlkMSBhbmQg
cmFpZDEwIikNCj4gQ2M6IHN0YWJsZUB2Z2VyLGtlcm5lbC5vcmcgIyBlMDkxMGM4ZTRmODcgd2Fz
IG1hcmtlZCBmb3Igc3RhYmxlQA0KPiBTaWduZWQtb2ZmLWJ5OiBNaWtlIFNuaXR6ZXIgPHNuaXR6
ZXJAcmVkaGF0LmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+
DQoNCj4gLS0tDQo+IGRyaXZlcnMvbWQvbWQuaCB8IDQgKystLQ0KPiAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbWQvbWQuaCBiL2RyaXZlcnMvbWQvbWQuaA0KPiBpbmRleCAyMTc1YTVhYzRmN2MuLmJiNjQ1
YmMzYmE2ZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tZC9tZC5oDQo+ICsrKyBiL2RyaXZlcnMv
bWQvbWQuaA0KPiBAQCAtMzExLDcgKzMxMSw3IEBAIHN0cnVjdCBtZGRldiB7DQo+IAlpbnQJCQkJ
ZXh0ZXJuYWw7CS8qIG1ldGFkYXRhIGlzDQo+IAkJCQkJCQkgKiBtYW5hZ2VkIGV4dGVybmFsbHkg
Ki8NCj4gCWNoYXIJCQkJbWV0YWRhdGFfdHlwZVsxN107IC8qIGV4dGVybmFsbHkgc2V0Ki8NCj4g
LQlpbnQJCQkJY2h1bmtfc2VjdG9yczsNCj4gKwl1bnNpZ25lZCBpbnQJCQljaHVua19zZWN0b3Jz
Ow0KPiAJdGltZTY0X3QJCQljdGltZSwgdXRpbWU7DQo+IAlpbnQJCQkJbGV2ZWwsIGxheW91dDsN
Cj4gCWNoYXIJCQkJY2xldmVsWzE2XTsNCj4gQEAgLTMzOSw3ICszMzksNyBAQCBzdHJ1Y3QgbWRk
ZXYgew0KPiAJICovDQo+IAlzZWN0b3JfdAkJCXJlc2hhcGVfcG9zaXRpb247DQo+IAlpbnQJCQkJ
ZGVsdGFfZGlza3MsIG5ld19sZXZlbCwgbmV3X2xheW91dDsNCj4gLQlpbnQJCQkJbmV3X2NodW5r
X3NlY3RvcnM7DQo+ICsJdW5zaWduZWQgaW50CQkJbmV3X2NodW5rX3NlY3RvcnM7DQo+IAlpbnQJ
CQkJcmVzaGFwZV9iYWNrd2FyZHM7DQo+IA0KPiAJc3RydWN0IG1kX3RocmVhZAkJKnRocmVhZDsJ
LyogbWFuYWdlbWVudCB0aHJlYWQgKi8NCj4gLS0gDQo+IDIuMTUuMA0KPiANCg0K

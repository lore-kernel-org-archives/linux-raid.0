Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAE0C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 26 Oct 2021 16:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75CBB60F02
	for <linux-raid@archiver.kernel.org>; Tue, 26 Oct 2021 16:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbhJZQis (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Oct 2021 12:38:48 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:57473
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237484AbhJZQio (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 26 Oct 2021 12:38:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+KxbcSATY8HTBPVM14qiyRE4ButlLzKQPmUtCFxnRoNlalv6+o7JFLeVNMlQn5XdNwqzTmQfxNAotNl6oBB6MiQxmrZe+iDhSC2tNeU4aD6SqUtdJrGYlFehJHStmhblD7e0A6YZfk84KRr+Ltlm4c9+6K5A64cLV63otaHMivc/DOpHbkPcXpFgZ5PtqirocrBaB08xikYk5SEC40Z3gOqist7iFcWVwh1tXvVeQ5UHlz19OjGfnLnjmlKvJy2ijC+wmZef7pEHbTB81K0dYclbL/yHJInej5no8/Gnu7+0tpdc4S/5PTb0kTjuHOc8DKT5eib+Y8/z1poE8wW7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmTjl9pXFlO/HDo1HfwUurZFCsd4VJhsOPge+UvX8GM=;
 b=ZV1GvmdhdvXVgXEQlBCljPgRQcgMfStpbEssFcNaZE8Qlz+jFhdDSVJ15hl4sWlBASSqZap0qMBAaYRRG5HplWd41ahe2BJYFYHhsF033nytwrUFj8x2Sl8bALO2hNeBqWq/+bg3SK44ADrzEzIsryf18djdqIzFqiB/PhldF6KHD+wRv5aqDheGj56ExXeT2zAdrScINekK4OpvRYW7RuF2PsCfaOiTzVUvn6sulCbN6nd5Keh2I7nvDQktespi8dOzEQKGlZ9FRVjQrxPIXqkLvbgSCaGph6vLn6eIy56kYK6a4Lu+TD/bCccu2wOJqwk792So8iIJS6lx0k+meg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmTjl9pXFlO/HDo1HfwUurZFCsd4VJhsOPge+UvX8GM=;
 b=r3AagjbSlAHyCk0/MM+ahUapaNbgQ+tHsrRXPLZcmldu7wKWEwGhrUjcqEPNCPV39XsCOmtzxMdtQ/UpXzl1HbG0Qn9g5l4ecsNClKueUAaD5rL1QFSWbl7facsp8qD32vAKmtDDKrv1PivEKNyY+i33bT44w6UYqzJrgdP3CWw=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by BY5PR05MB7124.namprd05.prod.outlook.com (2603:10b6:a03:1ca::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12; Tue, 26 Oct
 2021 16:36:17 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::fd9a:e92c:5d9e:9f6d]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::fd9a:e92c:5d9e:9f6d%9]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 16:36:17 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
CC:     "song@kernel.org" <song@kernel.org>,
        "valentin.schneider@arm.com" <valentin.schneider@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bristot@redhat.com" <bristot@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpumask and md/raid5: Fix implicit type conversion
Thread-Topic: [PATCH] cpumask and md/raid5: Fix implicit type conversion
Thread-Index: AQHXykuWrLjwqo3gsUO0zCXdteIdHKvlepkA
Date:   Tue, 26 Oct 2021 16:36:17 +0000
Message-ID: <625AA6E4-9661-4280-8991-BB931661EF2C@vmware.com>
References: <1635240383-2568329-1-git-send-email-jiasheng@iscas.ac.cn>
In-Reply-To: <1635240383-2568329-1-git-send-email-jiasheng@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: iscas.ac.cn; dkim=none (message not signed)
 header.d=none;iscas.ac.cn; dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eefdb947-4169-40aa-2598-08d9989ebbef
x-ms-traffictypediagnostic: BY5PR05MB7124:
x-microsoft-antispam-prvs: <BY5PR05MB7124B0E58C94A5C0494697D3D0849@BY5PR05MB7124.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XWEqw8Q15de3NbxjfPXiz+31ANj3NScae+1jkwfcBGlElegmm6BG1OQzcI7E1/JxdrvBlxR1NTCDSZb4BMeLzu34U6TPrJlafp8pEekj847xSg8NZ4RvxdviFWRqL4fuZekoHQ7sHUMb0LElC5kriphRdiUsDXX7H0/QX4mDxxFd9X5qlomlTnVrmgM0ILcwtellbOBj9UXFthDAFVXuLUbDovvmtJZDytrzPkk+trWt4ZecX3VZ/M4WDVYwoKnRgIUXtwrjcuOlNMMNSQuXgYSaTg16Qeimr5DOFaZSKfa/2Ys8e3TxO1xNfNn4xBNW/1W/mhPakTH/y0vllzcePokEXHv6vIxyv0MtTdAQVanZHxZv5Z84axscUd9eUZbEtBJ8RCLp4rYpQiJ/KZQZITZJcN7c5tn1NavvHeuME8TY8oWFH+2J2Fsz0y4saIai85PNGHaTWedzZjsR3N19zPr81zQySpae6Il2XIMMqPexp91cwQ5FyrXPzVlglT7QqdWNj4mfj4Sl27kiC8ELSsLYuu3T+yPFjFGwILCQn9WNtcXR6EY7kFETN6nZxeKPbYUuqj2UDVcXMFlLcSgGsBMYWlSrpi1arMicHSMfJ+YT8N1wVuPWxSP8fZJLLtbMpKKRmqwOrI3pUlcgdoPd3xSCUp0fsYBHswuZpDB1Tn31V6YRrHeihUtpf6sDcNmxgBQVTqgTQtEiLQ+lIJiq7tO+rlKtnQKzQSTa/zTOEBE85hMVRYx1DAy91tg0YY9T9lIpYx25pd4Q+plKZaH+Ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(122000001)(5660300002)(53546011)(508600001)(316002)(86362001)(4326008)(6506007)(71200400001)(33656002)(8936002)(186003)(36756003)(2906002)(66946007)(66446008)(64756008)(66556008)(38070700005)(6916009)(6486002)(26005)(66476007)(6512007)(8676002)(2616005)(76116006)(54906003)(45980500001)(357404004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2dIdkcwYVlTZU1pSW40ZUxhbU9Md21yam9MUGYvZ3VFUldkYW9SRjBEWWJh?=
 =?utf-8?B?N3ErYnBYODUwdGxCZXMrazBqZGhPRDlYdmwxRXh4a0NnMG9ENyt0bll5bEtu?=
 =?utf-8?B?NExYMmNwcGlIOVJtRE93b2hUZmZJM3dSSGY0amwvZ3UvUG5zcW9SczdDVGRi?=
 =?utf-8?B?VUQ1T3NoVXdSNGVPS05QcU5hRXRXcFk0dUFEZ3dkMmlIRnJlU2FUV2svaEQv?=
 =?utf-8?B?OW51VllnWEdqUDQvRm85eElFMlJKZjRLdjNEdnhnMkxqbXdHSW1qTEVmTi9t?=
 =?utf-8?B?VU00NURaMWpnam1UbDZtWktabDFLZEtMaGg1ZVB4OGxUQ3dYUU5BSEtaQXpP?=
 =?utf-8?B?cGhDM2RsSkM2R2pobnQ5akZ1WVB1NjNoVVdYNWpaajdPWG5JdjNrUHNhakRu?=
 =?utf-8?B?Y2ZvOWdQTWtBYzk4TGgyWjA2V0ZoZmtoYU5EbmdlZy9HR08rVWI4L3pzYTFr?=
 =?utf-8?B?SStkMjJCQkw3enFxOWVGS3FEQnN5aEZWK0ZyTHkrdncrZjZTMmVyaExHQjNC?=
 =?utf-8?B?WmgxbjdQQ3JYTEdoR2FwQ1FLYVJDN1V5RHBvaVlGd2t0bStKWldORHp2MitP?=
 =?utf-8?B?a2FuRlVaNnJaWWl0cGxocVB3Ulc1RXVCSmdhZU5hRnB5MFFwYTRUY2kydG53?=
 =?utf-8?B?S2hRT2dHMTJEZ2p5RkZ2MTBIMWVLYUFDRU8vc0VTVnYydjdwSE1aNjZwNnBE?=
 =?utf-8?B?NDFBd3lzVzdEN00wOUNSaFpXQWQwbkJwbmR6bDFGdXNzd0ExTC94aU9hWGVp?=
 =?utf-8?B?U2FqY1FmY2Z5RDQxV2l3elBVUmZsMy8vRkxSd2g4UnNYOU1oYmpGYmU4UjFC?=
 =?utf-8?B?YjBSMmpGS1ZyQ0wvQ2VuRUVrRlU3R0xQTGRMUTZpLzczOHpsRnNIcWk2Y2lH?=
 =?utf-8?B?OE9KOElQRkJtU2Z3ZnBEYjg4LzRYOUpxVXNzeE5YbFgxakg0NjFOdHh1QjdX?=
 =?utf-8?B?UDFMZTlWSjVhb3lZT3RVVzZhSjlJUGRkOUVqdWFhOTRNaE9YYzd6VDZOQWp0?=
 =?utf-8?B?R0tmTlk2RHV2cGVoSk5tYXJjdkQxVE85NXpyLzdwQTZDaUpvTHFIblFTRkdh?=
 =?utf-8?B?VDZrc0NITE8zZlpHNkU2ZHY2bnRqZEh3RnRvMlJPNHNpdzdTRGlqTkxzc1lD?=
 =?utf-8?B?c0l1MXBDRFM0NDFmcVBFL2xFR29KSS8zeDY3TnFUNzlxaW5ZbGpXSnFNZ2ta?=
 =?utf-8?B?Q29RZVAzbVZvRVRvaEhDSXIwZFJ4blpOUXpvREhXRXZBUlZVc0dVcTFsQURo?=
 =?utf-8?B?WFE1ZmVqN1g0U0VmeVRJVEYxSFNDWEhKVkhYSW9nNkRHbkd3Mnk4dmtqUVJa?=
 =?utf-8?B?YmM0Qk1LK2srckxTa3NiODErUm8yNis0RWU3anI0d3RVdDk0YnhJWnp5Qjcz?=
 =?utf-8?B?YkRRNlNIcnhEMkxwcGpxWHVUdklrOXJhM0xNQVdpSWRtZ2xmMUQ4NFZrWGds?=
 =?utf-8?B?eEhDSFFnSG1DOUZPUy9GOUh6cEc0dnpyZ05FSjRXa1pFWXJTRjFIU0JPdENi?=
 =?utf-8?B?eDkzSndFT2owVm1Pajh0QnFHVjZJSksrVTk1NnNOTGxIY1VELzBIb2dmQ3ZO?=
 =?utf-8?B?elZqbnlWTTBVbFZkaUd6TkQ1bURBWThtaDgyc0FJWHY4ZkJXUWM1NFQyUWt3?=
 =?utf-8?B?OVlTQ25GeXI0YXA3c1B2aFF1dnJuNkZLZlFlSlA3WUFxRlVKdkd4RCtXdW9T?=
 =?utf-8?B?d2MweWt4MHl4L0Jmc2MvS0dORWUvRmtwVG1WVklHUGEySFFveFp3TVJtVW9a?=
 =?utf-8?B?d2w1VDVVYXpRNW5zTEZhaDhZOFV1TGp1TGxEcGFaTDlOT09mT2NNOUE3RUUy?=
 =?utf-8?B?emNETG1iYksyN0xYcnBSdWVReVhrK25ZSFUxQWRmVW85ZWc5T0NURnJTZFFM?=
 =?utf-8?B?TXRkN09vMS91aTF3clFSME9ycUpLOXVOU0VvTDJIUVJvazloR0JSQnptUEw5?=
 =?utf-8?B?UnZ6aXBhSFJiK1hMR1M4L282VGhCWWpHQUpETzBNM0Y1cEZ4QXc3d0JlVVky?=
 =?utf-8?B?bHB6algybGpHcVlJMStjWTBVUmN0dVNva1JVclQyUHl1aHB6cHJIVDk3UGVI?=
 =?utf-8?B?S2pqMHh2d3k5ZEZzWU5qNk1TUXVaU1BwV2VRbGk2M2lXcktXMCs3Ti9yRXdk?=
 =?utf-8?B?UzlpWFFOOTNORVNVL1ZTVkVvV2JheG9MUW94ejBTK2hUUkhmWjZpVUFEVDNj?=
 =?utf-8?Q?1EO1w+0v9iGBjPBjmBSBWEQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CC7500CF31FBC438997135476B7D546@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eefdb947-4169-40aa-2598-08d9989ebbef
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 16:36:17.3239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dr90DjX5MY3YWd41fKoXoX4jIr5seGAwpqyqQpbkiGfXtzsLBGmxBLLFMZvv2ytp9vjFtu8WKb4UZPzrVfYKug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR05MB7124
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

DQoNCj4gT24gT2N0IDI2LCAyMDIxLCBhdCAyOjI2IEFNLCBKaWFzaGVuZyBKaWFuZyA8amlhc2hl
bmdAaXNjYXMuYWMuY24+IHdyb3RlOg0KPiANCj4gVGhlIGRlc2NyaXB0aW9uIG9mIHRoZSBtYWNy
byBpbiBgaW5jbHVkZS9saW51eC9jcHVtYXNrLmhgIHNheXMgdGhlDQo+IHZhcmlhYmxlICdjcHUn
IGNhbiBiZSB1bnNpZ25lZCBpbnQuDQo+IEhvd2V2ZXIgaW4gdGhlIGZvcl9lYWNoX2NwdSgpLCBm
b3JfZWFjaF9jcHVfd3JhcCgpIGFuZA0KPiBmb3JfZWFjaF9jcHVfYW5kKCksIGl0cyB2YWx1ZSBp
cyBhc3NpZ25lZCB0byAtMS4NCj4gVGhhdCBkb2Vzbid0IG1ha2Ugc2Vuc2UuIE1vcmVvdmVyIGlu
IHRoZSBjcHVtYXNrX25leHQoKSwNCj4gY3B1bWFza19uZXh0X3plcm8oKSwgY3B1bWFza19uZXh0
X3dyYXAoKSBhbmQgY3B1bWFza19uZXh0X2FuZCgpLA0KPiAnY3B1JyB3aWxsIGJlIGltcGxpY2l0
bHkgdHlwZSBjb252ZXJzZWQgdG8gaW50IGlmIHRoZSB0eXBlIGlzDQo+IHVuc2lnbmVkIGludC4N
Cj4gSXQgaXMgdW5pdmVyc2FsbHkgYWNjZXB0ZWQgdGhhdCB0aGUgaW1wbGljaXQgdHlwZSBjb252
ZXJzaW9uIGlzDQo+IHRlcnJpYmxlLg0KPiBBbHNvLCBoYXZpbmcgdGhlIGdvb2QgcHJvZ3JhbW1p
bmcgY3VzdG9tIHdpbGwgc2V0IGFuIGV4YW1wbGUgZm9yDQo+IG90aGVycy4NCj4gVGh1cywgaXQg
bWlnaHQgYmUgYmV0dGVyIHRvIGZpeCB0aGUgbWFjcm8gZGVzY3JpcHRpb24gb2YgJ2NwdScgdGhh
dA0KPiByZW1vdmUgdGhlICcob3B0aW9uYWxseSB1bnNpZ25lZCknIGFuZCBjaGFuZ2UgdGhlIGRl
ZmluaXRpb24gb2YgJ2NwdScNCj4gaW4gYGRyaXZlcnMvbWQvcmFpZDUuY2AgZnJvbSB1bnNpZ25l
ZCBsb25nIHRvIGxvbmcuDQoNCkltcGxpY2l0IGNhc3RzIGFyZSBkYW5nZXJvdXMgaW4gY2VydGFp
biBjYXNlcy4gSSBhbSBub3Qgc3VyZSB0aGUNCmNhc2UgeW91IGFkZHJlc3NlZCBpcyBzdWNoLg0K
DQpTb21ldGltZXMgdGhlIGdlbmVyYXRlZCBjb2RlIGlzIG1vcmUgZWZmaWNpZW50IHdoZW4gY2Fz
dGluZyBpcw0KYXZvaWRlZCwgZXNwZWNpYWxseSB3aGVuIGJvdGggdGhlIHNpemUgYW5kIHNpZ24g
YXJlIGNoYW5nZWQuDQoNCkhvd2V2ZXIsIGluIHByYWN0aWNlLCB0aGUgcGVyZm9ybWFuY2UgaW1w
YWN0IGlzIG5lZ2xpZ2VudC4NCg0KSWYgeW91IHdhbnQgdG8gYWRkcmVzcyB0aGlzIGlzc3VlLCBp
dCB3b3VsZCBiZSBiZXN0LCBJIHRoaW5rLA0KdG8gYWRkIHNvbWUgYXNzZXJ0aW9uIGFuZCBhY3R1
YWxseSBkZWFsIHdpdGggYWxsIHRoZSBleGlzdGluZw0KaXNzdWVzIChlLmcuLCBzZWUgYmVsb3cp
LiBBbnlob3csIHVubGVzcyB5b3UgZmluZCBhIHJlYWwNCmZ1bmN0aW9uYWwgYnVnLCBJIHdvdWxk
IGRyb3AgdGhlIOKAnGZpeGVz4oCdIHRhZy4NCg0KVG8gZmluZCBhZGRpdGlvbmFsIGlzc3Vlcywg
eW91IGNhbiB0cnkgdG8gdXNlIHNvbWV0aGluZyBsaWtlOg0KDQpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9jcHVtYXNrLmggYi9pbmNsdWRlL2xpbnV4L2NwdW1hc2suaA0KaW5kZXggNWQ0ZDA3
YTllMWVkLi5jZGE4OWU2ZTYwMWUgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L2NwdW1hc2su
aA0KKysrIGIvaW5jbHVkZS9saW51eC9jcHVtYXNrLmgNCkBAIC0yMzAsNiArMjMwLDEyIEBAIGlu
dCBjcHVtYXNrX2FueV9hbmRfZGlzdHJpYnV0ZShjb25zdCBzdHJ1Y3QgY3B1bWFzayAqc3JjMXAs
DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3Qgc3RydWN0IGNwdW1hc2sgKnNy
YzJwKTsNCiBpbnQgY3B1bWFza19hbnlfZGlzdHJpYnV0ZShjb25zdCBzdHJ1Y3QgY3B1bWFzayAq
c3JjcCk7DQogDQorI2luY2x1ZGUgPGxpbnV4L2J1aWxkX2J1Zy5oPg0KKw0KK3N0YXRpYyBfX2Fs
d2F5c19pbmxpbmUgdm9pZCBidWlsZF9idWdfb24oYm9vbCBjKSB7DQorICAgICAgIEJVSUxEX0JV
R19PTihjKTsNCit9DQorDQogLyoqDQogICogZm9yX2VhY2hfY3B1IC0gaXRlcmF0ZSBvdmVyIGV2
ZXJ5IGNwdSBpbiBhIG1hc2sNCiAgKiBAY3B1OiB0aGUgKG9wdGlvbmFsbHkgdW5zaWduZWQpIGlu
dGVnZXIgaXRlcmF0b3INCkBAIC0yMzcsMTAgKzI0MywxMCBAQCBpbnQgY3B1bWFza19hbnlfZGlz
dHJpYnV0ZShjb25zdCBzdHJ1Y3QgY3B1bWFzayAqc3JjcCk7DQogICoNCiAgKiBBZnRlciB0aGUg
bG9vcCwgY3B1IGlzID49IG5yX2NwdV9pZHMuDQogICovDQotI2RlZmluZSBmb3JfZWFjaF9jcHUo
Y3B1LCBtYXNrKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KLSAgICAgICBmb3Ig
KChjcHUpID0gLTE7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQotICAgICAgICAg
ICAgICAgKGNwdSkgPSBjcHVtYXNrX25leHQoKGNwdSksIChtYXNrKSksICAgIFwNCi0gICAgICAg
ICAgICAgICAoY3B1KSA8IG5yX2NwdV9pZHM7KQ0KKyNkZWZpbmUgZm9yX2VhY2hfY3B1KGNwdSwg
bWFzaykgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KKyAgICAgICBm
b3IgKChjcHUpID0gLTEsIGJ1aWxkX2J1Z19vbighX19zYW1lX3R5cGUoKGNwdSksIGludCkgJiYg
IV9fc2FtZV90eXBlKChjcHUpLCB1bnNpZ25lZCBpbnQpOyAgICBcDQorICAgICAgICAgICAgICAg
KGNwdSkgPSBjcHVtYXNrX25leHQoKGNwdSksIChtYXNrKSksICAgICAgICAgICAgXA0KKyAgICAg
ICAgICAgICAgIChjcHUpIDwgbnJfY3B1X2lkczsgKQ0KIA0KIC8qKg0KICAqIGZvcl9lYWNoX2Nw
dV9ub3QgLSBpdGVyYXRlIG92ZXIgZXZlcnkgY3B1IGluIGEgY29tcGxlbWVudGVkIG1hc2sNCg0K

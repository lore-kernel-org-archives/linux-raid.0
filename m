Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6722C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 07:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E4D161BFE
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 07:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhKQIAl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 03:00:41 -0500
Received: from mail-psaapc01on2113.outbound.protection.outlook.com ([40.107.255.113]:15488
        "EHLO APC01-PSA-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231967AbhKQIAl (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Nov 2021 03:00:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4WS783m2ctcf6Zq+OBzYkQlT7MLLeAUuaLc1/nVyUPIq4jzi4n1qoDsc3H6vFvBVgAtij0nnJYAwp+FvIenziU65xCkBwWggm7CZl199RC+8kaKUS+ezUFhJSkEPjYj4Qs209TukFdUuQSbWVELJmYchDPb0ryRB7DzAPYA83dp9PlXweXjYlC8rXZQBK3Pjb9xxRwsN0L/ZsJquf98as3p9EVp5KXXnpck43k7JtOHkXxT3sFWo4YLkpuLeM54zgkQawWx6wT8xZ7F0inxZry/pHWwX3wS1qaLunGMCWUEwkHGgnbDtBxrOkl2WGj4gfGaKZmfDRNBngRSnI/XtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SV9mUTxyfV3UDOJ4FiBEIYohgbZuKxf65bdqdEGuWkI=;
 b=DptneZZ1cWz8s7/y3m5KYvO0yx/i34HXTUWfLWRADJNl5vvS43BCTbq2iVH9Sm5Lgp9dMlPmuAY07VXCh3sPWbRGlVjyb/IjWi7ciyAHQ57z7/ypq3KZJsVbG/PpFVjHOuqBHm1B1IivA2S8/qBsgE9M53x+Vt83pT9PzZ8llFPaTktJafTAusZAkpJB9Inx/Jqfu7tptNBBLx0x99EQP/7ZWK1xtw2WtQYFcpfcLQhLo5s1aAGxwLkhISVXfgyIZGBUqQl33ccinVPTWvw+EWPt+Rywg7j2emN0xm4zmboi3UPw2MUW7VqMlgkRlUg9y/o5gjeiy59Nqu9xJC1bug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SV9mUTxyfV3UDOJ4FiBEIYohgbZuKxf65bdqdEGuWkI=;
 b=QUtOBENy5Wm4QbhsihXGJtFSVvhGNzoze0PbD0uHOC5E+ojEq+Cawvjwa1w90QLkvV2e8C0W1Qgvgig8jEFGvq01kDP/OmN+rsteT4K2cJh2LY2atqFkLkPIRUDt9QRFZ9oW0K62yFZty/jBnDCBmT119BmWgfpNuPNznPee+lY=
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by PS1PR0601MB2028.apcprd06.prod.outlook.com (2603:1096:803:e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 07:57:40 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385%5]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 07:57:40 +0000
From:   =?utf-8?B?6LW15Yab5aWO?= <bernard@vivo.com>
To:     Song Liu <song@kernel.org>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIGRyaXZlcnMvbWQ6IGZpeCBwb3RlbnRpYWwgbWVt?=
 =?utf-8?Q?leak?=
Thread-Topic: [PATCH] drivers/md: fix potential memleak
Thread-Index: AQHX2c92HKX27PINZEuysuOs92/27awHT6CAgAALuKA=
Date:   Wed, 17 Nov 2021 07:57:39 +0000
Message-ID: <PSAPR06MB40216A2C236343B2300EFC48DF9A9@PSAPR06MB4021.apcprd06.prod.outlook.com>
References: <20211115031817.4193-1-bernard@vivo.com>
 <AE6ABwAlE-AV3TdOtnvxCKoI.9.1637132794891.Hmail.bernard@vivo.com.@PENBUGhzdVc2dWk9d0JyVG9Za3FFT3BMeUxZaGpITW95MG1MMFVNY1hucTBPYktMTGhvQUBtYWlsLmdtYWlsLmNvbT4=>
In-Reply-To: <AE6ABwAlE-AV3TdOtnvxCKoI.9.1637132794891.Hmail.bernard@vivo.com.@PENBUGhzdVc2dWk9d0JyVG9Za3FFT3BMeUxZaGpITW95MG1MMFVNY1hucTBPYktMTGhvQUBtYWlsLmdtYWlsLmNvbT4=>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9e8800a-3c89-4c8f-0322-08d9a99fed9c
x-ms-traffictypediagnostic: PS1PR0601MB2028:
x-microsoft-antispam-prvs: <PS1PR0601MB2028608B47B0E1E5CF8C384CDF9A9@PS1PR0601MB2028.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L5SxuWlIxhC4jP7bw8EE46uUNaxBB6lDqbioRoEQjlm5g8RJ/+z1pUb/JipmbcL2bHjJO/aCkJajrmzj+wL3HRoO/w9Hf1opGPkKbDGXmX4GcuN85TX/gQKfJE+orZbvCViZgGwtPX3gVzCXaxMwWJHuJnY7BJRDXXF4eKWqTdChNlOZxNs2dBfdTryyRmHTvFxHgdBOt+D2DssEqIJ8+gfmiqLgl5RT68qaEapdiehYVZRE+U/hjB8+xEK641jliQ3GKYV6qwP7zk7oKpJzLC2EtRcIGkanQXLdH9RXXmyUgm8995F4TuH4sBbI9R1r3CaK9YzslrXC0N41BsTgClHMoYIsEJbmXBEA9EMSNjiKzOpFnqxzZFAGmH8uo97FIGXeKNTHpMLR+YOocQloCKsVfMQ8RslWIwY/EuXgLRMd+z2PLcnUZZgdkpND7mImFAd9/rdwLwdtLU4Y14GPcP0guhTCJJDxM8yOesPEEJznF6F8i/U1qim3vPjA+vQ+b2PvEqsIGSfhHPeQrbYQXtUXBxXLyRwTv97t7mhSQxtQfgbSG+XNZwerRA92Vx0t99uIeq7W4XfmvF27XyLzjSxdfy5J5GxjpnQSSafpvruRjCdyoPqxXKMbZeSrvOlveKUqxMcilVXbTiGhuM+92H2zAAM3qrViCZdf4RZ5sCqk/5FIoh9ypSyOpCTE2P5aUVGkwMjwdNo5ueS/rL7Q9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(6916009)(76116006)(33656002)(2906002)(508600001)(122000001)(6506007)(53546011)(66946007)(4326008)(186003)(8936002)(38070700005)(316002)(66446008)(66476007)(54906003)(26005)(64756008)(85182001)(224303003)(71200400001)(52536014)(7696005)(9686003)(86362001)(38100700002)(5660300002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0RWTXRpdHFQTzZxMFNYNlZCL0h0eTh6c2hOV0tHU2RUM2E5MWxyUkpIa09H?=
 =?utf-8?B?TlM3UkJTYXhNQ1lzV0xWU1piTnZwZTNYYkJ0Q1ZFMEFYYmFyM0tQeGhWMU1k?=
 =?utf-8?B?SUl6Mk95UjUxdDVsSzNvdWhpekMwQnlsb044dXZuaFE2TnNsbGRlRXdYRUdv?=
 =?utf-8?B?LzdhQSsyYnBKTmxwQnc0VFNhS2t6UTFLR1BLZUgxRlJlWXJta3YxNXFFOW9u?=
 =?utf-8?B?bUZoai9wNzYxVmVQbDlUL2hsQW44eW9GTXovczdoUWkyUU11N0s0ckZLL21z?=
 =?utf-8?B?d215L08yazNqcFowY0ZmQ3dRcUdWYlJHMDBndTlFT0hQMlFybHFDRENUY3Jw?=
 =?utf-8?B?akxrNFJrRU9KVlFrekl2N2tuNWFUcW1yY3Y3SGZGMGtlakxuMjlnK0NtK0Vn?=
 =?utf-8?B?cEI2RDBScEdJekxPOU0wNnVvTEcrakEwU2lkVFlaRHZHc2NYeHMxUi82YWlV?=
 =?utf-8?B?Sml6OVJyQWhUTEFWL3N4NVhOVEZDdjMySWJaTDUwREZGU1Y0TlNzSTVKTlpz?=
 =?utf-8?B?K0hSdCtjNnJUOGhtYWJWaHBuWEUwa3dKblpWOHZQSzZjYzdsVEc4OHk4cDIr?=
 =?utf-8?B?bUl0ZC8xRkxVVVhmUlkyUTBtdDd2QkQ0a0J6NDhMZ1ZpM01xekpOQ1A5SVY2?=
 =?utf-8?B?Q2ZWZzRBUHdFL25qSjlCNmdkeVdiWmxkdHlkYmlscHlWY29Zenc0a2tlazlJ?=
 =?utf-8?B?Z2pqMGpYVlhRTys5Q1dZTFRyOUxwVlBlT3R0QmNvMU5SbXNkMWZpZCtwYzlW?=
 =?utf-8?B?S0NEOFRkT3MyYU5oa05PRHdnc3pzQWYvOW1XUGpFVG5IeUsxZ092RjE0cy9h?=
 =?utf-8?B?Z1JlY2Z4Tk83MEI1MVFVVTZyalEvQk4xNVZPWmJDREdsbVV4S0hRQjZDZ2Qv?=
 =?utf-8?B?dGRBdWx3UUNWTHhxMmxObURyMWtKU1g3SXA2VnF3Ky9zQ2RiZ2VpcCt1NlJ4?=
 =?utf-8?B?dFJuOWwwWlM1T1NrT1JZU2JsYUJWNUZyMHYrNHFxL3h5Vzd3aEdialVNYmdp?=
 =?utf-8?B?SCtPOXAwZVZCZlZlL1Z4MFdYRWJyaW9QWlI3cGpkVUxObElWVXgyeGJyNmJ1?=
 =?utf-8?B?K09FcTNvRVR3LytXdW1tRS9OZnZ6L2VLLzZFV0YzTlZzTEVQUEIwa2FwSUk5?=
 =?utf-8?B?ZFRabEVtNnJtaFB2WlZ5a1hmcU5kVm9YUzRtY09YT1RZMVBPWU1Ka3Vvd2NB?=
 =?utf-8?B?U1FLUzJKbVkxeG5uQnVQUFY5RldMYjJnT21CNExtQVdrOS9pb0MrcEt5RFB3?=
 =?utf-8?B?ejhsMExxQTFvSWNLTnlzMkQ5dXZpdkx1NDRSZHEvL2hUbGx4dzJuNUdsRzFz?=
 =?utf-8?B?Rm81VHVkbnJwRzNBQlFHZHZxUkdLYTZ4NW5vUUFqd3B2TFdmQlMySUkvbWI2?=
 =?utf-8?B?Zm41bHJrSDNacXU0VWNraHltcDc1NVZkVThZOGFJSHBtMzlvbW0vSHV3ZDhI?=
 =?utf-8?B?S2ZTWjR2eDlnK1dVS3RJZHZIenFqTmI5Zzh1WXZ3U0tuL0w0Y0Q0eXpJMmNF?=
 =?utf-8?B?NE1VQ0QrckY3VEZ5TEZSQU8rMjJwR2FKMkpMRDB2T29sWG9Jb2VjVVo2eFBx?=
 =?utf-8?B?bThHaWVGN09BNmRsM1BORkxkc1BBaURCSTc3NEh5NXp5UkcxK3Q1dmsybjc5?=
 =?utf-8?B?S3h6TEJNckl6NEVCNnpwN3IrS09ERHp6MGJqVm1RbzJvaVBUNnlwOWw4bUFK?=
 =?utf-8?B?aDNhRkdRVDNxdTFINmpqcmJMbWg1RjRUSDRXZEtLTFVpSzhuZzN6dHlCUEto?=
 =?utf-8?B?VWJjS0Roc1VBQ0REeGE3dVdvRDJmcktlU1BMbTFDY0d3RWxsa00rWWlKcEdr?=
 =?utf-8?B?aDd0SStnakxHTWtjN0c4OWk4V1phODlwbm10QlF4YWgwZmhvb2lUaEpHZHpa?=
 =?utf-8?B?YVN4VFFrVlJqdE9EbkxNTnJaMFhOUGl3OGFpSFJwUFUvVnZjMXdzS0RoZGFL?=
 =?utf-8?B?YjVhSUVWOFVFZDU1bitQNmdrN2ZpdHV0bnh3Y3dTN1hWZWYvZHpFOGhHMHd3?=
 =?utf-8?B?NWljTjI5amJuVUlFOXdkOWZ3NXBWclRqbFJia1p6TTJWWEJkRXhEZzBUeHlj?=
 =?utf-8?B?ZC9VVjdIOVFxQnhrMjVDMU8zT0laaElocmZLMytIampVNGU5QjR5WEJ5MW50?=
 =?utf-8?B?RlNRdlFzZS9lcnRXZXRlSjdRWjRVeHpqWVU5Szk5aldVTzVZZmhab0xrZlBi?=
 =?utf-8?B?VFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e8800a-3c89-4c8f-0322-08d9a99fed9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 07:57:39.8585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fH9ZMD0nXVKGrXSkEMtXHXGxX2DidACLTtlz1bnXMCudCKvK5N4gWxCgiUer3GOpW4bS1sUdxnn+kqdL+oi4Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PR0601MB2028
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

DQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogYmVybmFyZEB2aXZvLmNvbSA8
YmVybmFyZEB2aXZvLmNvbT4g5Luj6KGoIFNvbmcgTGl1DQrlj5HpgIHml7bpl7Q6IDIwMjHlubQx
MeaciDE35pelIDE1OjA2DQrmlLbku7bkuro6IOi1teWGm+WljiA8YmVybmFyZEB2aXZvLmNvbT4N
CuaKhOmAgTogbGludXgtcmFpZCA8bGludXgtcmFpZEB2Z2VyLmtlcm5lbC5vcmc+OyBvcGVuIGxp
c3QgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+DQrkuLvpopg6IFJlOiBbUEFUQ0hdIGRy
aXZlcnMvbWQ6IGZpeCBwb3RlbnRpYWwgbWVtbGVhaw0KDQpPbiBTdW4sIE5vdiAxNCwgMjAyMSBh
dCA3OjE4IFBNIEJlcm5hcmQgWmhhbyA8YmVybmFyZEB2aXZvLmNvbT4gd3JvdGU6DQo+DQo+IElu
IGZ1bmN0aW9uIGdldF9iaXRtYXBfZnJvbV9zbG90LCB3aGVuIG1kX2JpdG1hcF9jcmVhdGUgZmFp
bGVkLCANCj4gbWRfYml0bWFwX2Rlc3Ryb3kgbXVzdCBiZSBjYWxsZWQgdG8gZG8gY2xlYW4gdXAu
DQoNCj5Db3VsZCB5b3UgcGxlYXNlIGV4cGxhaW4gd2hpY2ggdmFyaWFibGUocykgbmVlZCBjbGVh
biB1cD8NCg0KSGkgU29uZzoNClRoZSBmb2xsb3cgaXMgdGhlIGZ1bmN0aW9uIG1kX2JpdG1hcF9j
cmVhdGVgcyBhbm5vdGF0aW9uIDoNCi8qDQogKiBpbml0aWFsaXplIHRoZSBiaXRtYXAgc3RydWN0
dXJlDQogKiBpZiB0aGlzIHJldHVybnMgYW4gZXJyb3IsIGJpdG1hcF9kZXN0cm95IG11c3QgYmUg
Y2FsbGVkIHRvIGRvIGNsZWFuIHVwDQogKiBvbmNlIG1kZGV2LT5iaXRtYXAgaXMgc2V0DQogKi8N
CnN0cnVjdCBiaXRtYXAgKm1kX2JpdG1hcF9jcmVhdGUoc3RydWN0IG1kZGV2ICptZGRldiwgaW50
IHNsb3QpDQoNCkl0IGlzIG1lbnRpb25lZCB0aGF0IGJpdG1hcF9kZXN0cm95IG5lZWRzIHRvIGJl
IGNhbGxlZCB0byBkbyBjbGVhbiB1cC4NCk90aGVyIGZ1bmN0aW9ucyB3aGljaCBjYWxsZWQgbWRf
Yml0bWFwX2NyZWF0ZSBpbiB0aGUgc2FtZSBmaWxlIGFsc28gY2FsbGVkIG1kX2JpdG1hcF9jcmVh
dGUgdG8gY2xlYW4gdXAoaW4gdGhlIGVycm9yIGJyYW5jaCksIGJ1dCB0aGlzIG9uZSBkaWRuYHQu
DQpJIGFtIG5vdCBzdXJlIGlmIHRoZXJlIGlzIHNvbWUgZ2FwPw0KVGhhbmtzIQ0KQlIvL0Jlcm5h
cmQNCg0KPlRoYW5rcywNCj5Tb25nDQoNCj4NCj4gU2lnbmVkLW9mZi1ieTogQmVybmFyZCBaaGFv
IDxiZXJuYXJkQHZpdm8uY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbWQvbWQtYml0bWFwLmMgfCAx
ICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPg0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tZC9tZC1iaXRtYXAuYyBiL2RyaXZlcnMvbWQvbWQtYml0bWFwLmMgaW5kZXggDQo+
IGJmZDYwMjZkNzgwOS4uYTIyN2JkMGI5MzAxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL21kL21k
LWJpdG1hcC5jDQo+ICsrKyBiL2RyaXZlcnMvbWQvbWQtYml0bWFwLmMNCj4gQEAgLTE5NjEsNiAr
MTk2MSw3IEBAIHN0cnVjdCBiaXRtYXAgKmdldF9iaXRtYXBfZnJvbV9zbG90KHN0cnVjdCBtZGRl
diAqbWRkZXYsIGludCBzbG90KQ0KPiAgICAgICAgIGJpdG1hcCA9IG1kX2JpdG1hcF9jcmVhdGUo
bWRkZXYsIHNsb3QpOw0KPiAgICAgICAgIGlmIChJU19FUlIoYml0bWFwKSkgew0KPiAgICAgICAg
ICAgICAgICAgcnYgPSBQVFJfRVJSKGJpdG1hcCk7DQo+ICsgICAgICAgICAgICAgICBtZF9iaXRt
YXBfZGVzdHJveShtZGRldikNCj4gICAgICAgICAgICAgICAgIHJldHVybiBFUlJfUFRSKHJ2KTsN
Cj4gICAgICAgICB9DQo+DQo+IC0tDQo+IDIuMzMuMQ0KPg0K

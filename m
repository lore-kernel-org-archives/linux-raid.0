Return-Path: <SRS0=g69Z=EM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83A7C388F2
	for <linux-raid@archiver.kernel.org>; Fri,  6 Nov 2020 18:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 530CD2078B
	for <linux-raid@archiver.kernel.org>; Fri,  6 Nov 2020 18:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purdue0.onmicrosoft.com header.i=@purdue0.onmicrosoft.com header.b="F+NkGRxB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgKFS7A (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 Nov 2020 13:59:00 -0500
Received: from mail-dm6nam12on2101.outbound.protection.outlook.com ([40.107.243.101]:35130
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726075AbgKFS67 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 6 Nov 2020 13:58:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9PiqkKiba0dGJkKIf1eQiMotRbwuA4m9M1D9NKhDfxfNmlw2PS1cOk+EMVM14v/G8p4anjl1/dpxcBmMtE76mGVOrNqtpp8qu1y1Jy/5Njcp1jF1J9yAvJjocgad8femjo3zyMK0OpwXRlA0rNUKQHruQ5O55aybQ4SV1Oz4PZnxH7SA9L3sVOJgrW9NnF6s/fAQXCX9O2yIZ2ofiLAoM140QT1KU4FXA8SzqSwRWddANTiJg+fh9gS1VtKaijHl5xlR/BuMdh3J1yD5JEGov0c7iQorlXmcxFotEiLsaFWprfYIkyug7qVemAQ+BIFahT0QcFqTk4iMv9hoWxXkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnrhhXW+tUGEAlTqWiOqj5cxxQXWYjtE5GA8XSOH3RI=;
 b=eis61uzTy9jFwTcRXMvhxgW0lyfEDLWbZDYSeweuqZtu0C/obPECdokb9tBBvghWWpl+wfMl3szjGxLZoOHCunL4XxMKRZYS+aJ6kKKg1ty5SgxvCGnoyw7S60s93jyElnSa1JK5/UNom+ZmsKACSXsql4Ax04Skuzz8m2M+5HJXfwXEWTwMdTj7cGZSiYmrA7o+L061X+c1vWFnSgR/geYYXJPomC1hMgjqMFTPkQqFQKcCfjUZKcnXR5uuKr06rypD6/81a7sOnyJMwbbE0EB67luVrUfmInp15CY2+qJyntpZOYap0n9XyLGj3hhTIBlc7IPwXNbmo1lW0IHWsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnrhhXW+tUGEAlTqWiOqj5cxxQXWYjtE5GA8XSOH3RI=;
 b=F+NkGRxBCCZSFmG2A8l3j+VmU2tfF+tpMLetgZQLfEVcCD6+i6lsAQCt2V+hqELF0dObRhkVJnsYOtn3mUfbA3sknRscmQZh+ZP40ojZvduhPdINr6Mj9oTkCexCvAm0BIidB0GfK4sVZ7Yx9E0sit8IKG7Ex7ud1HgK820ReJ0=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB2053.namprd22.prod.outlook.com (2603:10b6:610:87::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 6 Nov
 2020 18:58:57 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::1922:c660:f2f4:50fa]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::1922:c660:f2f4:50fa%7]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 18:58:57 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     "song@kernel.org" <song@kernel.org>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: PROBLEM: a concurrency bug in drivers/md/md.c
Thread-Topic: PROBLEM: a concurrency bug in drivers/md/md.c
Thread-Index: AQHWtG7hg/BDHo5cg0OpLmKMRl4rQQ==
Date:   Fri, 6 Nov 2020 18:58:57 +0000
Message-ID: <CF84A11A-D1E2-4B7D-825A-C54E2C82B28F@purdue.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 140f6a5b-7dcc-4e10-45d1-08d8828603d7
x-ms-traffictypediagnostic: CH2PR22MB2053:
x-microsoft-antispam-prvs: <CH2PR22MB20531C078F527CA3546DABBBDFED0@CH2PR22MB2053.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:348;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P2LpqhEV3+G9xEki1iyviJUgZTJa9UrV3NBf3NhjnXD1zOHLKs9q4SIDvjemsdXdLZqtGMQ2gBJRiWU/fOMRtGL3Uuwb3CcwAdzl0GThFwdphQ5Qs1eXWzlBZyTyuDfgrRz8AU/rondJqVut6RqYriUdtuRWY21BKthK2aOddckEBE1Z95QJjwEDjQ+MrpqD64gjETYjY8q/ucnx7xADG/g2TWPMcaQfPc4UllvoQQMMbHE93XUrIdlsWNcbS46d3fzkI0/Lf/peBFYcwRcYuHnnk6dfSU/S1RBsNlG6yqAoG7s+XrHIj7hzvn+MTwhw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(39860400002)(366004)(4326008)(86362001)(66476007)(66446008)(64756008)(26005)(33656002)(75432002)(91956017)(76116006)(6512007)(8936002)(186003)(6916009)(5660300002)(71200400001)(8676002)(45080400002)(316002)(83380400001)(6506007)(2616005)(2906002)(6486002)(786003)(478600001)(36756003)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: dIHg1n29HAMsrXTtCOQzXcb8NYtfNMByCdTtk0t80vKHPgEV/iLb0vfFRs3Tj5cWLfnTscfx8pNov86zxP32Kg/wfzXtAPRK1BEqIauHNNQmTUM1XNgnyvH2HD6HtYxZQaJMNmfOW9a4x5T/CagmY/YyYMG5eZLLt2ied0Pnyo+4ADSwHlsXYsNyCISFQkz2Lk5md3HVBPbZc1aDjv4mrPvWaVC25Lgod88tqNLFdMMd4VNDukF9vFtZqDqi7J63K1vxzCVa+CIwuBXj4z+pKl2Ysm4Hth0iVYcx7DxjCtXBHftxlMnWEjHhNIb1yGDuzVL2zIF9AaPjUZDP+eIrELLuJve6wpaqwfDnDXAWsOO98ye/hW3G/d86F8VxvoDHIUVUkTWqhfEA487ZWAO5uSy9E4fErUeGLOR9PAYzgr9M/TzaMNq5VcllmJTZ/Q8FvsD1QuLW/eIfbiOWv2B0nOTQE4ZdOJwb+VB3hYXVgnkbaSBLA/96QrCrbqumaHy8rmyb+gpqDkOtnrw4xSO2dJu7j7AOJih+v7I78u5++hswx4lOhyEnhW00oyAzqAj4DhIiZLMICrZ8c16aXIRpB2rQjhEtqFoPGOFIM0grm1kxNG0z18ZwJmsN4xLIxwbuRG4Rsg9heJW+86kHUf3/uQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCEFA53E4C1BCB499D8FCF5D2B70DAFB@namprd22.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 140f6a5b-7dcc-4e10-45d1-08d8828603d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2020 18:58:57.3259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NOtQtU2WIN0V8kGF3atzK3QvI3zn9UiCEXDq/bx1ZBcIJEmnjLzzn0fC6nHDZniCCdc9bioksf6O9gLtx6lDIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB2053
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

DQpIaSwNCg0KV2UgZm91bmQgYSBjb25jdXJyZW5jeSBidWcgaW4gbGludXggNS4zLjExIHRoYXQg
d2Ugd2VyZSBhYmxlIHRvIHJlcHJvZHVjZSBpbiB4ODYgdW5kZXIgc3BlY2lmaWMgaW50ZXJsZWF2
aW5ncy4gVGhpcyBidWcgY2F1c2VzIGEgd2FybmluZyBtZXNzYWdlIOKAnFdBUk5JTkc6IGxpbnV4
LTUuMy4xMS9kcml2ZXJzL21kL21kLmM6NzI3OSBtZF9pb2N0bCsweDljZC8weDFiMDLigJ0uDQoN
ClRoaXMgYnVnIGlzIHRyaWdnZXJlZCB3aGVuIHR3byBrZXJuZWwgdGhyZWFkcyBydW4gdGhlIG1k
X2lvY3RsKCkgZnVuY3Rpb24gb24gdGhlIHNhbWUgcmVzb3VyY2UgaW50ZXJsZWF2ZSB3aXRoIGVh
Y2ggb3RoZXIuIFRoZSBjb2RlIHNldHMgdGhlIG1kZGV2LT5mbGFncyB0byBpbmRpY2F0ZSB0aGF0
IHRoZSByZXNvdXJjZSBpcyBiZWluZyBtb2RpZmllZCBhbmQgcmVzZXRzIGl0IGFmdGVyIHRoZSBt
b2RpZmljYXRpb24uIEhvd2V2ZXIsIHRoZSBjdXJyZW50IGNvZGUgYWxsb3dzIGFub3RoZXIgdGhy
ZWFkIHRvIGV4ZWN1dGUgYWZ0ZXIgdGhlIG1kZGV2LT5mbGFncyBpcyBzZXQgYnV0IGJlZm9yZSBp
dCBpcyByZXNldCwgcmVzdWx0aW5nIGluIHRoZSB3YXJuaW5nIG1lc3NhZ2UuDQoNCi0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KS2VybmVsIGNvbnNvbGUgb3V0cHV0
DQpbICAxNDAuNTI0MzMxXSBXQVJOSU5HOiBDUFU6IDEgUElEOiAxODE1IGF0IC90bXAvdG1wLkI3
emI3b2QyekUtNS4zLjExL2V4dHJhY3QvbGludXgtNS4zLjExL2RyaXZlcnMvbWQvbWQuYzo3Mjc5
IG1kX2lvY3RsKzB4OWNkLzB4MWIwMg0KWyAgMTQ1LjQzODc0OV0gTW9kdWxlcyBsaW5rZWQgaW46
DQpbICAxNDcuNjkxMTMwXSBDUFU6IDEgUElEOiAxODE1IENvbW06IHNraS1leGVjdXRvciBOb3Qg
dGFpbnRlZCA1LjMuMTEgIzENClsgIDE1MC4zMzM4MzldIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJv
Y2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMDcNClsgIDE1My43MTI4ODddIEVJUDogbWRfaW9jdGwr
MHg5Y2QvMHgxYjAyDQpbICAxNTcuNDY0MzY4XSBDb2RlOiBmZiBmZiBmZiBlOCAwZiBlZCA5MSBm
ZiBjNiA0NSA4NCAwMSBlOSAxMCBmZiBmZiBmZiA4ZCA4MyA3NCAwMSAwMCAwMCBlOCA3NSAzMyAy
NCAwMCBjNiA0NSA4NCAwMCBiZSBmMCBmZiBmZiBmZiBlOSAzZSBmNyBmZiBmZiA8MGY+IDBiIGVi
IGJmIGIwIDAwIGViIDAyIGIwIDAxIDg0IGMwIDBmIDg0IDJjIGY3IGZmIGZmIDg5IDdjIDI0IDBj
DQpbICAxNjguODEzNzgxXSBFQVg6IDAwMDAwMDAyIEVCWDogZjNkZjQ4MDAgRUNYOiBmM2RmNDk3
YyBFRFg6IDAwMDAwMDAyDQpbICAxNzEuODkwNjE1XSBFU0k6IDAwMDAwMDAwIEVESTogMDAwMDA5
MzIgRUJQOiBlNTI3YmUyYyBFU1A6IGU1MjdiZDk4DQpbICAxNzUuNDY1NzI4XSBEUzogMDA3YiBF
UzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OCBFRkxBR1M6IDAwMDAwMjAyDQpbICAx
NzkuMzk0NDM5XSBDUjA6IDgwMDUwMDMzIENSMjogMDg1NzI1NjggQ1IzOiAyNTI0MjAwMCBDUjQ6
IDAwMDAwNjkwDQpbICAxODMuMTQwNTg4XSBEUjA6IDAwMDAwMDAwIERSMTogMDAwMDAwMDAgRFIy
OiAwMDAwMDAwMCBEUjM6IDAwMDAwMDAwDQpbICAxODYuNTc4OTc2XSBEUjY6IDAwMDAwMDAwIERS
NzogMDAwMDAwMDANCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
DQpUZXN0IGlucHV0DQoNClRoZSBidWcgaXMgdHJpZ2dlcmVkIHdoZW4gdGhlIHNhbWUga2VybmVs
IHRlc3QgcHJvZ3JhbSBpcyBleGVjdXRlZCBjb25jdXJyZW50bHkgYnkgdHdvIGRpZmZlcmVudCB0
aHJlYWRzLiBJbiBwYXJ0aWN1bGFyLCBpdCBpcyB0cmlnZ2VyZWQgd2hlbiB0aGUgc3lzdGVtIGNh
bGwgbWRfaW9jdGwoKSBpbnRlcmxlYXZlcyB3aXRoIGl0c2VsZi4NCg0KVGhlIHRlc3QgcHJvZ3Jh
bSBpcyBpbiBTeXprYWxsZXLigJlzIGZvcm1hdCBhcyBmb2xsb3dzOg0KcjAgPSBvcGVuYXQkbWQo
MHhmZmZmZmZmZmZmZmZmZjljLCAmKDB4N2YwMDAwMDAwMDAwKT0nL2Rldi9tZDBceDAwJywgMHgw
LCAweDApDQppb2N0bCRCTEtUUkFDRVRFQVJET1dOKHIwLCAweDkzMiwgMHgwKQ0KDQoNCg0KLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpJbnRlcmxlYXZpbmcNCg0K
T3VyIGFuYWx5c2lzIHJldmVhbGVkIHRoYXQgdGhlIGZvbGxvd2luZyBpbnRlcmxlYXZpbmcgY2Fu
IHRyaWdnZXIgdGhpcyBidWc6DQoNClRocmVhZCAxCQkJCQkJCQkJCQlUaHJlYWQgMg0KCQkJCQkJ
CQkJCQkJbWRfb3BlbigpDQoJCQkJCQkJCQkJCQktaWYgKHRlc3RfYml0KE1EX0NMT1NJTkcsICZt
ZGRldi0+ZmxhZ3MpKSB7DQoJCQkJCQkJCQkJCQkJbXV0ZXhfdW5sb2NrKCZtZGRldi0+b3Blbl9t
dXRleCk7DQoJCQkJCQkJCQkJCQkJZXJyID0gLUVOT0RFVjsNCgkJCQkJCQkJCQkJCQlnb3RvIG91
dDsNCgkJCQkJCQkJCQkJCQl9DQoJCQkJCQkJCQkJCQkoY29uZGl0aW9uIGlzIGZhbHNlKQ0KCQkJ
CQkJCQkJCQkJLeKApg0KCQkJCQkJCQkJCQkJLW11dGV4X3VubG9jaygmbWRkZXYtPm9wZW5fbXV0
ZXgpOw0KCQkJCQkJCQkJCQkJLeKApg0KCQkJCQkJCQkJCQkJLXJldHVybiBlcnI7DQoJCQkJCQkJ
CQkJCQkobWRfb3BlbiBmaW5pc2hlcyBjb3JyZWN0bHkpDQptZF9vcGVuKCkNCi1pZiAodGVzdF9i
aXQoTURfQ0xPU0lORywgJm1kZGV2LT5mbGFncykpIHsNCgltdXRleF91bmxvY2soJm1kZGV2LT5v
cGVuX211dGV4KTsNCgllcnIgPSAtRU5PREVWOw0KCWdvdG8gb3V0Ow0KfQ0KKGNvbmRpdGlvbiBp
cyBmYWxzZSkNCi0uLi4NCi1yZXR1cm4gZXJyOw0KKG1kX29wZW4gZmluaXNoZXMgY29ycmVjdGx5
KQ0KDQptZF9pb2N0bCgpDQooZHJpdmVycy9tZC9tZC5jOjcyNzkpDQotV0FSTl9PTl9PTkNFKHRl
c3RfYml0KE1EX0NMT1NJTkcsICZtZGRldi0+ZmxhZ3MpKTsNCi1zZXRfYml0KE1EX0NMT1NJTkcs
ICZtZGRldi0+ZmxhZ3MpOw0KLS4uLg0KLW11dGV4X3VubG9jaygmbWRkZXYtPm9wZW5fbXV0ZXgp
Ow0KCQkJCQkJCQkJCQkJbWRfaW9jdGwoKQ0KCQkJCQkJCQkJCQkJKGRyaXZlcnMvbWQvbWQuYzo3
Mjc5KQ0KCQkJCQkJCQkJCQkJLVdBUk5fT05fT05DRSh0ZXN0X2JpdChNRF9DTE9TSU5HLCAmbWRk
ZXYtPmZsYWdzKSk7DQoJCQkJCQkJCQkJCQkod2FybmluZyBtZXNzYWdlIHNob3dzKQ0KKGRyaXZl
cnMvbWQvbWQuYzo3MzQ3KQ0KLWNhc2UgU1RPUF9BUlJBWToNCiAgICAgICBlcnIgPSBkb19tZF9z
dG9wKG1kZGV2LCAwLCBiZGV2KTsNCiAgICAgICBnb3RvIHVubG9jazsNCihtZGRldi0+ZmxhZ3Mg
d2lsbCBiZSBjbGVhcmVkIGluc2lkZSBkb19tZF9zdG9wKCkpDQoNCg0KVGhhbmtzLA0KU2lzaHVh
aQ0KDQo=

Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A1CC2BA4C
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 12:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbiAZMGQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Jan 2022 07:06:16 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:27904 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241060AbiAZMGP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 26 Jan 2022 07:06:15 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-68-SGSsYXn4MZ-w7ghbs9S6ew-1; Wed, 26 Jan 2022 12:06:12 +0000
X-MC-Unique: SGSsYXn4MZ-w7ghbs9S6ew-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Wed, 26 Jan 2022 12:06:09 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Wed, 26 Jan 2022 12:06:09 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paul Menzel' <pmenzel@molgen.mpg.de>, Song Liu <song@kernel.org>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Matt Brown <matthew.brown.dev@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 1/3] lib/raid6/test/Makefile: Use `$(pound)` instead of
 `\#` for Make 4.3
Thread-Topic: [PATCH 1/3] lib/raid6/test/Makefile: Use `$(pound)` instead of
 `\#` for Make 4.3
Thread-Index: AQHYEqnO/EgEqhFx3k6DzicFruc4Lax1NEHA
Date:   Wed, 26 Jan 2022 12:06:09 +0000
Message-ID: <0214ae2639174812948a631ac4e142c8@AcuMS.aculab.com>
References: <20220126114144.370517-1-pmenzel@molgen.mpg.de>
In-Reply-To: <20220126114144.370517-1-pmenzel@molgen.mpg.de>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

RnJvbTogUGF1bCBNZW56ZWwNCj4gU2VudDogMjYgSmFudWFyeSAyMDIyIDExOjQyDQo+IA0KLi4N
Cj4gK3BvdW5kIDo9IFwjDQoNClBsZWFzZSB1c2UgJ2hhc2gnIG5vdCAncG91bmQnLg0KT25seSBh
bWVyaWNhbiBncmVlbmdyb2NlcnMgdXNlIHRoYXQgaG9ycmlkIG5hbWUuDQoNCkEgJ3BvdW5kJyBp
cyAnwqMnLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K


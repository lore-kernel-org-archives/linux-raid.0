Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83C1C4338F
	for <linux-raid@archiver.kernel.org>; Thu, 29 Jul 2021 18:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A323260E94
	for <linux-raid@archiver.kernel.org>; Thu, 29 Jul 2021 18:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhG2SMX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:12:23 -0400
Received: from UPDC19PA24.eemsg.mail.mil ([214.24.27.199]:45531 "EHLO
        UPDC19PA24.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhG2SMT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Jul 2021 14:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1627582336; x=1659118336;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fvGfivfoOlG1Ebl+64lsFlHwGzW8koZCC9EykLck23k=;
  b=QQi6wH0ijdPtKUxUMhH3huYx9lVAnU6Hzj1wuhkEKf5A9+jZFQ8LaQmO
   x+rjmts7jSVxw3bblWI/MSpOrmcjWEpnOBlU7LilW23K+if/5vY6mAYQq
   ZSdHMbTg8122ZX14VU3xbK+NpviDSLJkmxu9LqvBTYGaL6yJdc22GAIWB
   5k63C96Vp4Fsfxz3093d3abJfpFd6SlMfA65ynmF/91HUwjfO3DqsMzpW
   xTx1ie9GKfiCHJShG9V5UHXk/p5cRKNj4uiXuEuTyBRuDCho3Vw3RXU7H
   HDn/u0TlQz3Ob0uLmYFYpfi86nrX5yzzqgUYPtQJRfEsEbRowi8KHsxAI
   A==;
X-EEMSG-check-017: 247041537|UPDC19PA24_ESA_OUT06.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.84,279,1620691200"; 
   d="scan'208";a="247041537"
Received: from edge-mech02.mail.mil ([214.21.130.231])
  by UPDC19PA24.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 29 Jul 2021 18:12:12 +0000
Received: from UMECHPAOV.easf.csd.disa.mil (214.21.130.165) by
 edge-mech02.mail.mil (214.21.130.231) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Thu, 29 Jul 2021 18:12:11 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.8.97]) by
 umechpaov.easf.csd.disa.mil ([214.21.130.165]) with mapi id 14.03.0513.000;
 Thu, 29 Jul 2021 18:12:11 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     'Wols Lists' <antlists@youngman.org.uk>,
        'Matt Wallis' <mattw@madmonks.org>
CC:     "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Subject: RE: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS -
 AMD ROME what am I missing?????
Thread-Topic: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS -
 AMD ROME what am I missing?????
Thread-Index: AQHXhBQyCYnzeb6zhEaJ8KArZSwefqtaJzaAgAAZ+VA=
Date:   Thu, 29 Jul 2021 18:12:10 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A2385841519@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
 <07195088-7E4B-4586-BB45-04890265BD62@madmonks.org>
 <5EAED86C53DED2479E3E145969315A23858411D1@UMECHPA7B.easf.csd.disa.mil>
 <21187A73-4000-4017-B016-15C03D19B799@madmonks.org>
 <6102D8B9.2080502@youngman.org.uk>
In-Reply-To: <6102D8B9.2080502@youngman.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.44.12]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

SGksDQpBY3R1YWxseSwgdGhlIFJBSUQ1L1JBSUQ2IG1kcmFpZCBpbXBsZW1lbnRhdGlvbnMgY2Fu
J3Qgc3VwcG9ydCB0aGUgSU9QUyBvciB0aGUgcXVldWUgZGVwdGhzIHJlcXVpcmVkIGZvciBhIGJh
c2ljIHNpbmdsZSBtZHJhaWQgcmFpZDUvcmFpZDYgTFVOLiAgICBUaGUgcGFydGl0aW9ucyBhcmUg
anVzdCB0byBjcmVhdGUgbW9yZSBtZHJhaWQgc3RyaXBlcyBvdXQgb2YgcGFydGl0aW9ucyB0byBh
bGxvdyBmb3IgbW9yZSB0aHJlYWRzPyBUbyBkbyB0aGUgUkFJRCBwYXJpdHkgd29yayBhbmQgdG8g
YmUgYWJsZSB0byBpc3N1ZSBtb3JlIEkvT3MgdG8gdGhlIGVudGlyZXR5IG9mIHRoZSBOVk1lIFNT
RHMgdXNpbmcgbWRyYWlkLiAgIFVsdGltYXRlbHksIEkgbmVlZCBvbmUgdm9sdW1lIHBlciBOVU1B
IGRvbWFpbiBjb21wcmlzZWQgb2YgUkFJRGVkIE5WTUUgU1NEcy4gICBXZSdyZSBqdXN0IGV4cGxv
cmluZyBjcmVhdGl2ZSB3b3JrYXJvdW5kcyB0byB0aGUgTlZNZSBtZHJhaWQgSU9QUyBpc3N1ZXMg
dG8gZ2V0IHRoZSBtb3N0IElPUFMgb3V0IG9mIGEgY29sbGVjdGlvbiBvZiBTU0RzLiAgICBJIHN0
aWxsIGhhdmUgdG8gcHV0IGFuIHhmcyBmaWxlIHN5c3RlbSBwZXIgdm9sdW1lIGZvciBzb21ldGhp
bmcgdXNlZnVsIHRvIG9jY3VyLg0KVGhhbmtzLA0KSmltDQoNCg0KDQotLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KRnJvbTogV29scyBMaXN0cyA8YW50bGlzdHNAeW91bmdtYW4ub3JnLnVrPiAN
ClNlbnQ6IFRodXJzZGF5LCBKdWx5IDI5LCAyMDIxIDEyOjM1IFBNDQpUbzogTWF0dCBXYWxsaXMg
PG1hdHR3QG1hZG1vbmtzLm9yZz47IEZpbmxheXNvbiwgSmFtZXMgTSBDSVYgKFVTQSkgPGphbWVz
Lm0uZmlubGF5c29uNC5jaXZAbWFpbC5taWw+DQpDYzogbGludXgtcmFpZEB2Z2VyLmtlcm5lbC5v
cmcNClN1YmplY3Q6IFJlOiBbTm9uLURvRCBTb3VyY2VdIENhbid0IGdldCBSQUlENS9SQUlENiBO
Vk1lIHJhbmRvbXJlYWQgSU9QUyAtIEFNRCBST01FIHdoYXQgYW0gSSBtaXNzaW5nPz8/Pz8NCg0K
T24gMjkvMDcvMjEgMDE6NTQsIE1hdHQgV2FsbGlzIHdyb3RlOg0KPiBIaSBKaW0sDQo+IA0KPiBU
b3RhbGx5IGdldCB0aGUgRnJhbmtlbnN0ZWlu4oCZcyBtb25zdGVyIGFzcGVjdCwgSSB0cnkgbm90
IHRvIGJ1aWxkIHRob3NlIHdoZXJlIEkgY2FuLCBidXQgYXQgdGhlIG1vbWVudCBJIGRvbuKAmXQg
dGhpbmsgdGhlcmXigJlzIG11Y2ggdGhhdCBjYW4gYmUgZG9uZSBhYm91dCBpdC4NCj4gTm90IHN1
cmUgaWYgTFZNIGlzIGJldHRlciB0aGFuIE1EUkFJRCAwLCBpdCBqdXN0IGdpdmVzIHlvdSBtb3Jl
IGNvbnRyb2wgb3ZlciB0aGUgdm9sdW1lcyB0aGF0IGNhbiBiZSBjcmVhdGVkLCBpbnN0ZWFkIG9m
IGhhdmluZyBpdCBhbGwgaW4gb25lIGJpZyBjaHVuay4gSWYgeW91IGp1c3QgbmVlZCBvbmUgYmln
IGNodW5rLCB0aGVuIE1EUkFJRCAwIGlzIHByb2JhYmx5IGZpbmUuDQo+IA0Kc3RpY2tpbmcgcmFp
ZCAwIG9uIHRvcCBvZiByYWlkIDYgc291bmRzIGFuIGV4dHJlbWVseSB3ZWlyZCB0aGluZyB0byBk
by4NCg0KV2hhdCBJIGd1ZXNzIHlvdSBtaWdodCBiZSB3YW50aW5nIHRvIGRvIGluc3RlYWQgaXMg
d3JpdGUgYSBwYXJ0aXRpb24gdGFibGUgdG8gdGhlIHJhaWQtNj8gVGhhdCdzIHBlcmZlY3RseSBu
b3JtYWwgaWYsIGltaG8sIGEgYml0IHVudXN1YWw/DQoNCkFuZCBMVk0gd291bGQgYmUgTVVDSCBi
ZXR0ZXIgdGhhbiByYWlkLTAsIEknbSBzdXJlLCBiZWNhdXNlIGl0IGFkZHJlc3NlcyB0aGlzIHZl
cnkgaXNzdWUgYnkgZGVzaWduLCByYXRoZXIgdGhhbiBieSBhY2NpZGVudC4NCg0KPiBJIHRoaW5r
IGlmIHlvdSBjYW4gY3JlYXRlIGEgY291cGxlIG9mIHNjcmlwdHMgdGhhdCBhbGxvd3MgdGhlIGFk
bWluIHRvIGZhaWwgYSBkcml2ZSBvdXQgb2YgYWxsIHRoZSBhcnJheXMgdGhhdCBpdOKAmXMgaW4g
YXQgb25jZSwgdGhlbiBpdCdzIG5vdCB0aGF0IG11Y2ggd29yc2UgdGhhbiBtYW5hZ2luZyBhbiBN
RFJBSUQgaXMgbm9ybWFsbHkuIA0KDQpJcyB0aGF0IHdpc2U/IEtJU1MuDQo+IA0KPiBNYXR0Lg0K
PiANCj4+IE9uIDI4IEp1bCAyMDIxLCBhdCAyMDo0MywgRmlubGF5c29uLCBKYW1lcyBNIENJViAo
VVNBKSA8amFtZXMubS5maW5sYXlzb240LmNpdkBtYWlsLm1pbD4gd3JvdGU6DQo+Pg0KPj4gTWF0
dCwNCj4+IEkgaGF2ZSBwdXQgYXMgbWFueSBhcyAzMiBwYXJ0aXRpb25zIG9uIGEgZHJpdmUgKGJh
c2VkIHVwb24gZ3JlYXQgYWR2aWNlIGZyb20gdGhpcyBsaXN0KSBhbmQgZG9uZSBSQUlENiBvdmVy
IHRoZW0sIGJ1dCBJIHdhcyBjb25jZXJuZWQgYWJvdXQgb3VyIHN1c3RhaW5hYmlsaXR5IGxvbmcg
dGVybS4gICAgIEFzIGEgcmVzZWFyY2hlciwgSSBjYW4gZG8gdGhlc2UgY29vbCBzY2llbmNlIGV4
cGVyaW1lbnRzLCBidXQgSSBzdGlsbCBoYXZlIHRvIGhhbmQgZGVzaWducyAgdG8gc3VzdGFpbm1l
bnQgZm9sa3MuICBJIHdhcyBhbHNvIHJ1bm5pbmcgaW50byBhbiBpc3N1ZSBvZiBkb2luZyBhIG1k
cmFpZCBSQUlEMCBvbiB0b3Agb2YgdGhlIFJBSUQ2J3Mgc28gSSBjb3VsZCB0b3NzIG9uZSAgeGZz
IGZpbGUgc3lzdGVtIG9uIHRvcCBlYWNoIG9mIHRoZSBudW1hIG5vZGUncyBkcml2ZXMgYW5kIHRo
ZSBsYXN0IFJBSUQwIHN0cmlwZSBvZiBhbGwgb2YgdGhlIFJBSUQ2J3MgY291bGRuJ3QgZ2VuZXJh
dGUgdGhlIHF1ZXVlIGRlcHRoIG5lZWRlZC4gICAgV2UgZXZlbiByZWNvbXBpbGVkIHRoZSBrZXJu
ZWwgdG8gY2hhbmdlIHRoZSBtZHJhaWQgbnJfcmVxdWVzdCBtYXggZnJvbSAxMjggdG8gMTAyMy4g
IA0KPj4NCj4+IEkgd2lsbCBoYXZlIHRvIHRyeSB0aGUgTFZNIGV4cGVyaW1lbnQuICBJJ20gYW4g
TFZNICBuZW9waHl0ZSwgc28gaXQgbWlnaHQgdGFrZSBtZSB0aGUgcmVzdCBvZiB0b2RheS90b21v
cnJvdyB0byBnZXQgbmV3IHJlc3VsdHMgYXMgSSB0ZW5kIHRvIGxldCBtZHJhaWQgZG8gYWxsIG9m
IGl0cyB2b2x1bWUgYnVpbGRzIHdpdGhvdXQgZm9yY2luZywgc28gdGhhdCB3aWxsIHRha2UgYSBi
aXQgb2YgdGltZSBhbHNvLiAgT25jZSBtaWdodCBiZSBhYmxlIHRvIGFyZ3VlIHRoYXQgY29uZmln
dXJhdGlvbiBpc24ndCB0b28gbXVjaCBvZiBhICJGcmFua2Vuc3RlaW4ncyBtb25zdGVyIiBmb3Ig
bWUgdG8gaGFuZCBpdCBvZmYuDQo+Pg0KRG8uIElmIGl0IHNvbHZlcyB3aGF0IHlvdSB3YW50LCB0
aGVuIGl0J3Mgd29ydGggaXQuIEknbSBtb3ZpbmcgbXkgc3R1ZmYgb3ZlciB0byBMVk0uDQoNClRv
IHRocm93IHNvbWV0aGluZyBlbHNlIGludG8gdGhlIG1peCwgeW91J3ZlIGdvbmUgZm9yIHJhaWQg
Niwgd2hpY2ggZW5hYmxlcyB5b3UgdG8gbG9zZSB0d28gZHJpdmVzLCBvciBjb3JydXB0IG9uZSBk
cml2ZS4gRG8geW91IG5lZWQgdGhlIHR3by1kcml2ZSByZWR1bmRhbmN5PyBUaGUgY2FsY3VsYXRp
b25zIGFyZSBhIGxvdCBtb3JlIGV4cGVuc2l2ZSB0aGFuDQpyYWlkLTUgaWYgeW91J3JlIHdvcnJp
ZWQgb3ZlciB3cml0ZSBzcGVlZC4gSSBkb24ndCBrbm93IHRoZSBpbXBhY3Qgb2YgaXQgYnV0IEkn
bSBwbGF5aW5nIHdpdGggZG0taW50ZWdyaXR5IHdoaWNoIHByb3ZpZGVzIHNvbWUgcHJvdGVjdGlv
biBhZ2FpbnN0IGNvcnJ1cHRpb24uDQoNCj4+IFRoYW5rcywNCj4+IEppbQ0KPj4NCkNoZWVycywN
CldvbA0KDQo=

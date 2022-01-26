Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0150BC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 22:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbiAZWBe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Jan 2022 17:01:34 -0500
Received: from UCOL19PA35.eemsg.mail.mil ([214.24.24.195]:31104 "EHLO
        UCOL19PA35.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiAZWBd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 Jan 2022 17:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1643234493; x=1674770493;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=7eu0TqbnNxgJEu0D8pe9LVCaiVL5iDb2Gbw9bpQikeQ=;
  b=UNodprrjIXN7VUpDWva9eYqySVoSWQ8z9kXIq0VZ89q3c9cLEWEapI7D
   QDl4F73XERXIOU/KRvxJZamP+CynMrM+QRqazmODGHfrsCgmPOjW2l1lL
   E4f0gGEdM5uTUpLSW0Quaf6mTpPnLAeLeIHgOUehjR+bFBpSnZtmPKEu8
   Ef8db5J1HsiB57ckKExeyFJgGnaOXIalAj4cZEo89W7Ov/GTkJbq8oysA
   fvwslN23/kKHSwiJOLeYaO0scucIjFFVydOSoFzmo0a25RnzR5pZXfrov
   p8wjJiS3YL5iTdbfOgMoK9+rdY0BgYWkfGODrWq/3SweGyMm1dl/FZ/8e
   A==;
X-EEMSG-check-017: 320242001|UCOL19PA35_ESA_OUT02.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.88,319,1635206400"; 
   d="scan'208";a="320242001"
IronPort-Data: A9a23:2MBhL6MGYv8IlLPvrR1LlcFynXyQoLVcMsEvi/4bfWQNrUpz3jMBx
 mQeW2CPOqmLamDwLt93aY2//RkA7cWHy9I2TwZtpSBmQkwRpJueD7x1DKtR0wB+jCHnZBg6h
 ykmQoCbaphyEhcwnz/1WlTbhSEUOZqgG/ysWIYoBggrHVU+EH5710o48wIEqtYAbeaRUlvlV
 eza/pW31G+Ng1aYA0pMg06xgEoHUMfa4Vv0imcDicVj5zcyoZW14KU3fsldJ1OgKmVd83XTq
 +zrlNlV9UuBl/sh50/Mr1r1TqEKaua60Qmmh3ZZVu2njxNC/nZ01686MLwZaEM/ZzehxYktj
 o8U88XrEUFzZP2kdOc1CnG0Fwl8NKhL4/nCZ3a+t8ia3lbBdSeqyPRwJEQ/PIle/+dzaY1L3
 adCcGpRNEjb3opax5r+EIGAnP8LKMjtIZNaoHhhwRnHAvs8B5POWaPH4ZlfxjhYrsJDE/iYZ
 c0ZbyFoajzJbhpJMVASEI8ineGnwHL4dlVlRPi9zUYsy2XfwwE01bXmMIKPPNmDRMETm0ecz
 l8qNl/RWnkyXOFzAxLcmp5wrocjRR/GZb8=
IronPort-HdrOrdr: A9a23:uMHpbaBDXHr7fm7lHem755DYdb4zR+YMi2TDtnoBKiC9F/by/f
 xG885rtyMc9wxhPU3I9ersBEDiexPhHPxOj7X5VI3KNDUO3lHFEGgI1+rfKlPbdBEW/9QtsZ
 tdTw==
Received: from edge-mech02.mail.mil ([214.21.130.228])
  by UCOL19PA35.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 26 Jan 2022 22:01:29 +0000
Received: from UMECHPAOQ.easf.csd.disa.mil (214.21.130.160) by
 edge-mech02.mail.mil (214.21.130.228) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Wed, 26 Jan 2022 22:00:52 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.8.67]) by
 umechpaoq.easf.csd.disa.mil ([214.21.130.160]) with mapi id 14.03.0513.000;
 Wed, 26 Jan 2022 22:00:51 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     'Jeff Johnson' <jeff.johnson@aeoncomputing.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: RE: [URL Verdict: Neutral]Re: [Non-DoD Source] Re: Showing my
 ignorance - kernel workers
Thread-Topic: [URL Verdict: Neutral]Re: [Non-DoD Source] Re: Showing my
 ignorance - kernel workers
Thread-Index: AdgS5P61xTa9Pr/xShuP8xB3beZ1egADr/OAAAAzkmAAAIxbgAACNhWw
Date:   Wed, 26 Jan 2022 22:00:50 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A2389282A6D@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A23892829E5@UMECHPA7B.easf.csd.disa.mil>
 <fade7009-48d6-356a-dc65-a66fac2d216b@sotapeli.fi>
 <5EAED86C53DED2479E3E145969315A2389282A56@UMECHPA7B.easf.csd.disa.mil>
 <CAFCYAse8BCsTnPRSi_ivX7K8R29cKmmk-=0ZnMromWj74X-5yw@mail.gmail.com>
In-Reply-To: <CAFCYAse8BCsTnPRSi_ivX7K8R29cKmmk-=0ZnMromWj74X-5yw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.44.13]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

SSB3aWxsIHZlcmlmeSwgYnV0IEknbSBwcmV0dHkgc3VyZSB0aGV5IGFyZSBzdGlsbCBzaXR0aW5n
IHdpdGggdGhlIHNhbWUgYmlvcyAtIEkgZGlkIGFuIGhwZSBpbG8gZ2V0IG9mIHRoZSBvbmUgYmlv
cyBhbmQgcHVzaGVkIGl0IHRvIHRoZSBvdGhlciBvbmNlIEkgc2F3IGdvb2QgaW5kaXZpZHVhbCBT
U0QgcGVyZm9ybWFuY2Ugd2l0aCBGSU8uICAgSSdtIGFsd2F5cyBmZWFyZnVsIGdvaW5nIG91dCB0
byB0aGVzZSBsaXN0cyBiZWNhdXNlIHRoZXJlIGlzIG11Y2ggbW9yZSB0aGF0IEkgZG9uJ3Qga25v
dyB0aGFuIEkgZG8sIGJ1dCBhdCBsZWFzdCBteSBwcm9ibGVtcyBhcmUgZGlmZmVyZW50IHRoYW4g
IkknbSBydW5uaW5nIGFsbCBvZiB0aGVzZSBkZXNrdG9wIGRyaXZlcyBvbiBhIHN5c3RlbSB3aXRo
IG5vbi1FQ0MgbWVtb3J5IGFuZCBJIGp1c3QgbG9zdCBhbGwgb2YgbXkgbW92aWVzLCBjYW4geW91
IGhlbHAgbWUgOikiDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBKZWZmIEpv
aG5zb24gPGplZmYuam9obnNvbkBhZW9uY29tcHV0aW5nLmNvbT4gDQpTZW50OiBXZWRuZXNkYXks
IEphbnVhcnkgMjYsIDIwMjIgMzo1MyBQTQ0KVG86IGxpbnV4LXJhaWRAdmdlci5rZXJuZWwub3Jn
DQpDYzogRmlubGF5c29uLCBKYW1lcyBNIENJViAoVVNBKSA8amFtZXMubS5maW5sYXlzb240LmNp
dkBtYWlsLm1pbD4NClN1YmplY3Q6IFtVUkwgVmVyZGljdDogTmV1dHJhbF1SZTogW05vbi1Eb0Qg
U291cmNlXSBSZTogU2hvd2luZyBteSBpZ25vcmFuY2UgLSBrZXJuZWwgd29ya2Vycw0KDQpBbGwg
YWN0aXZlIGxpbmtzIGNvbnRhaW5lZCBpbiB0aGlzIGVtYWlsIHdlcmUgZGlzYWJsZWQuICBQbGVh
c2UgdmVyaWZ5IHRoZSBpZGVudGl0eSBvZiB0aGUgc2VuZGVyLCBhbmQgY29uZmlybSB0aGUgYXV0
aGVudGljaXR5IG9mIGFsbCBsaW5rcyBjb250YWluZWQgd2l0aGluIHRoZSBtZXNzYWdlIHByaW9y
IHRvIGNvcHlpbmcgYW5kIHBhc3RpbmcgdGhlIGFkZHJlc3MgdG8gYSBXZWIgYnJvd3Nlci4gIA0K
DQoNCg0KDQotLS0tDQoNCkl0IG1pZ2h0IGJlIHdvcnRod2hpbGUgdG8gY2hlY2sgdGhlIEJJT1Mg
c2V0dGluZ3Mgb24gdGhlIHR3byBSb21lIHNlcnZlcnMgdG8gbWFrZSBzdXJlIHRoZSBzZXR0aW5n
cyBtYXRjaCwgcGF5aW5nIHBhcnRpY3VsYXIgYXR0ZW50aW9uIHRvIE5VTUEgYW5kIGlvYXBpYyBz
ZXR0aW5ncy4NCg0KQmFja2dyb3VuZDogQ2F1dGlvbi1odHRwczovL2RldmVsb3Blci5hbWQuY29t
L3dwLWNvbnRlbnQvcmVzb3VyY2VzLzU2NzQ1XzAuODAucGRmDQoNCi0tSmVmZg0KDQpPbiBXZWQs
IEphbiAyNiwgMjAyMiBhdCAxMjo0MCBQTSBGaW5sYXlzb24sIEphbWVzIE0gQ0lWIChVU0EpIDxq
YW1lcy5tLmZpbmxheXNvbjQuY2l2QG1haWwubWlsPiB3cm90ZToNCj4NCj4gQm90aCBkdWFsIHNv
Y2tldCBBTUQgUm9tZXMuICAgSWRlbnRpY2FsIGluIGV2ZXJ5IHdheS4gICBOVU1BcyBwZXIgc29j
a2V0IHNldCB0byAxIGluIHRoZSBCSU9TLiAgIEknbSB1c2luZyB0aGUgZXhhY3Qgc2FtZSAxMCBk
cml2ZXMgb24gZWFjaCBzeXN0ZW0gYW5kIHRoZXkgYXJlIFBDSWUgR2VuNCBIUEUgT0VNIG9mIFNB
TVNVTkcuLi4uDQo+DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEphbmkg
UGFydGFuZW4gPGppaXBlZUBzb3RhcGVsaS5maT4NCj4gU2VudDogV2VkbmVzZGF5LCBKYW51YXJ5
IDI2LCAyMDIyIDM6MzIgUE0NCj4gVG86IEZpbmxheXNvbiwgSmFtZXMgTSBDSVYgKFVTQSkgPGph
bWVzLm0uZmlubGF5c29uNC5jaXZAbWFpbC5taWw+OyANCj4gbGludXgtcmFpZEB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogW05vbi1Eb0QgU291cmNlXSBSZTogU2hvd2luZyBteSBpZ25vcmFu
Y2UgLSBrZXJuZWwgd29ya2Vycw0KPg0KPiBIZWxsbywgYXJlIGJvdGggc3lzdGVtcyBpZGVudGlj
YWwgd2hhdCBjb21lcyB0byBoYXJkd2FyZT8gTWFpbmx5IG1vYm8uDQo+DQo+IElmIG5vIGFuZCB0
aGV5IGFyZSBkdWFsIHNvY2tldCBzeXN0ZW1zLCB0aGVuIGl0IG1heSBiZSB0aGF0IG9uZSBvZiB0
aGUgc3lzdGVtcyBpcyBkZXNpZ25lZCB0byByb3V0ZSBhbGwgUENJLWUgdmlhIG9uZSBzb2NrZXQg
c28gdGhhdCBhbGwgZHJpdmUgc2xvdHMgY2FuIGJlIHVzZWQganVzdCAxIHNvY2tlZCBwb3B1bGF0
ZWQuIEFuZCBhbm90aGVyIGlzIGRlc2lnbmVkIHNvIHRhaHQgb25seSBoYWxmIG9mIHRoZSBkcml2
ZSBzbG90cyB3b3JrcyB3aGVuIG9ubHkgMSBzb2NrZXQgaXMgcG9wdWxhdGVkLg0KPiBBdCBsZWFz
dCBJIGhhdmUgcmVhZCBzb21ldGhpbmcgbGlrZSB0aGlzIHByZXZpb3VzbHkgZnJvbSB0aGlzIGxp
c3QuDQo+DQo+IC8vIEppaVBlZQ0KPg0KPg0KPiBGaW5sYXlzb24sIEphbWVzIE0gQ0lWIChVU0Ep
IGtpcmpvaXR0aSAyNi8wMS8yMDIyIGtsbyAyMi4xNzoNCj4gPiBJIGFwb2xvZ2l6ZSBpbiBhZHZh
bmNlIGlmIHlvdSBjYW4gcG9pbnQgbWUgdG8gc29tZXRoaW5nIEkgY2FuIHJlYWQgYWJvdXQgbWRy
YWlkIGJlc2lkZXMgdGhlIHNvdXJjZSBjb2RlLiAgSSdtIGJleW9uZCB0aGUgYm91bmRzIG9mIG15
IHVuZGVyc3RhbmRpbmcgb2YgTGludXguICAgQmFja2dyb3VuZCwgSSBkbyBhIGJ1bmNoIG9mIE5V
TUEgYXdhcmUgY29tcHV0aW5nLiAgIEkgaGF2ZSB0d28gc3lzdGVtcyBjb25maWd1cmVkIGlkZW50
aWNhbGx5IHdpdGggYSBOVU1BIG5vZGUgMCBmb2N1c2VkIFJBSUQ1IExVTiBjb250YWluaW5nIE5V
TUEgbm9kZSAwIG52bWUgZHJpdmVzICBhbmQgYSBOVU1BIG5vZGUgMSBmb2N1c2VkIFJBSUQ1IExV
TiBpZGVudGljYWxseSBjb25maWd1cmVkLiAgOSsxIG52bWUsIDEyOEtCIHN0cmlwZSwgeGZzIHNp
dHRpbmcgb24gdG9wLCA2NEtCIE9fRElSRUNUIHJlYWRzIGZyb20gdGhlIGFwcGxpY2F0aW9uLg0K
Pg0KDQoNCi0tDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCkplZmYgSm9obnNvbg0K
Q28tRm91bmRlcg0KQWVvbiBDb21wdXRpbmcNCg0KamVmZi5qb2huc29uQGFlb25jb21wdXRpbmcu
Y29tDQpDYXV0aW9uLXd3dy5hZW9uY29tcHV0aW5nLmNvbQ0KdDogODU4LTQxMi0zODEwIHgxMDAx
ICAgZjogODU4LTQxMi0zODQ1DQptOiA2MTktMjA0LTkwNjENCg0KNDE3MCBNb3JlbmEgQm91bGV2
YXJkLCBTdWl0ZSBDIC0gU2FuIERpZWdvLCBDQSA5MjExNw0KDQpIaWdoLVBlcmZvcm1hbmNlIENv
bXB1dGluZyAvIEx1c3RyZSBGaWxlc3lzdGVtcyAvIFNjYWxlLW91dCBTdG9yYWdlDQo=

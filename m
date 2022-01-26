Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7A6C5DF62
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 20:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiAZUkL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Jan 2022 15:40:11 -0500
Received: from USAT19PA20.eemsg.mail.mil ([214.24.22.194]:40949 "EHLO
        USAT19PA20.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiAZUkK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 Jan 2022 15:40:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1643229610; x=1674765610;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=yn1dgnCTjoedP2OTbINQcWGaujPxj55v6DDUOMSSDAE=;
  b=V5FT3HKJzFB83SofYYoWPLmLijuQ0F1wAS0V/hqz9MvMFpgrWqhrwlLu
   acC6bbTTZBFq+zaGvgvWwkwSeq8NuwKB/VGrAxRHZ1lu8bYnCKQblku7G
   CfxLf1d+JAByJ8XcKKctEAPdGxd6GvSqPLcLjxd94VQvfgJWeFvfIZ/Yk
   MUBFG38ke7cLYo6C5yeyDGSlwTIJ8laGWvz5fGOb1BZXLYhPP5g+zMh+T
   ygcAQXDUmTf9LCMcBA6ZnNcuGyxba3H9I5tgh5JleLi8CsbcbqyOUFEai
   55By1lQx2uPToEjFDPnHwx+nUNH/JESPmqiRxT1wZiUXrAMSsmZ5yQQt3
   g==;
X-EEMSG-check-017: 295128380|USAT19PA20_ESA_OUT01.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.88,319,1635206400"; 
   d="scan'208";a="295128380"
IronPort-Data: A9a23:Y4zgfa2TEqitafJ/vfbD5TZzkn2cJEfYwER7XKvMYLTBsI5bpzEPy
 GYWCGzVO/qIMDT9fY8nboy/90wH7cXdztAwG1dpqSg9HnlHl5HIVI+TRqvS04J+DSFhoGZPt
 Zh2huHodZtyFjmAzvuUGuCJQUNUjclkfZKhTr6UUsxNbVU8En150Eg9w7VRbrNA2bBVPSvc4
 bsenOWCYDdJ6xYsWo4lw/rrRCFH5ZweixtB1rAKXs2niXeF/5Uj4DLzEonqR5fwatE88udX3
 I8vxpnhlo/S109F5t9IDt/GnkM2rr76ZWBii1JbV6evxx1PrSxqiOA+PfsYL0JWj11lnfgrk
 YkL78X2EFxxePeWyYzxUDEBe816Fa9P/bLcZ335v82Vy0TXaHzqn7NlDV8eOIQZ/qByAGUmG
 fkwcmFQN0rT3LLuqF68Yqw27ig5F+HvPYUCqjR6xDDVJegpTIqFQKjQ49JcmjAqiahmH/fff
 8cUQSFocB3YbhlOfFkWYK/SNs/AamLXfjFXpReQqKE3uzKVyQVw1P7oMd69RzBDfu0N9m7wm
 44M1z+lav3GHLRzEQa4z08=
IronPort-HdrOrdr: A9a23:DzYEsK0c9nPuYs9knv//fgqjBLskLtp133Aq2lEZdPUzSL3+qy
 nOpoV+6faQslwssR4b+exoVJPwIk80lqQFhLX5Q43CYOCOggLBR+wPguXfKlbbakvDH4BmpM
 VdmmxFeaTNMWQ=
Received: from edge-mech02.mail.mil ([214.21.130.229])
  by USAT19PA20.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 26 Jan 2022 20:40:00 +0000
Received: from UMECHPAOV.easf.csd.disa.mil (214.21.130.165) by
 edge-mech02.mail.mil (214.21.130.229) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Wed, 26 Jan 2022 20:39:21 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.8.67]) by
 umechpaov.easf.csd.disa.mil ([214.21.130.165]) with mapi id 14.03.0513.000;
 Wed, 26 Jan 2022 20:39:20 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     'Jani Partanen' <jiipee@sotapeli.fi>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: RE: [Non-DoD Source] Re: Showing my ignorance - kernel workers
Thread-Topic: [Non-DoD Source] Re: Showing my ignorance - kernel workers
Thread-Index: AdgS5P61xTa9Pr/xShuP8xB3beZ1egADr/OAAAAzkmA=
Date:   Wed, 26 Jan 2022 20:39:20 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A2389282A56@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A23892829E5@UMECHPA7B.easf.csd.disa.mil>
 <fade7009-48d6-356a-dc65-a66fac2d216b@sotapeli.fi>
In-Reply-To: <fade7009-48d6-356a-dc65-a66fac2d216b@sotapeli.fi>
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

Qm90aCBkdWFsIHNvY2tldCBBTUQgUm9tZXMuICAgSWRlbnRpY2FsIGluIGV2ZXJ5IHdheS4gICBO
VU1BcyBwZXIgc29ja2V0IHNldCB0byAxIGluIHRoZSBCSU9TLiAgIEknbSB1c2luZyB0aGUgZXhh
Y3Qgc2FtZSAxMCBkcml2ZXMgb24gZWFjaCBzeXN0ZW0gYW5kIHRoZXkgYXJlIFBDSWUgR2VuNCBI
UEUgT0VNIG9mIFNBTVNVTkcuLi4uDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9t
OiBKYW5pIFBhcnRhbmVuIDxqaWlwZWVAc290YXBlbGkuZmk+IA0KU2VudDogV2VkbmVzZGF5LCBK
YW51YXJ5IDI2LCAyMDIyIDM6MzIgUE0NClRvOiBGaW5sYXlzb24sIEphbWVzIE0gQ0lWIChVU0Ep
IDxqYW1lcy5tLmZpbmxheXNvbjQuY2l2QG1haWwubWlsPjsgbGludXgtcmFpZEB2Z2VyLmtlcm5l
bC5vcmcNClN1YmplY3Q6IFtOb24tRG9EIFNvdXJjZV0gUmU6IFNob3dpbmcgbXkgaWdub3JhbmNl
IC0ga2VybmVsIHdvcmtlcnMNCg0KSGVsbG8sIGFyZSBib3RoIHN5c3RlbXMgaWRlbnRpY2FsIHdo
YXQgY29tZXMgdG8gaGFyZHdhcmU/IE1haW5seSBtb2JvLg0KDQpJZiBubyBhbmQgdGhleSBhcmUg
ZHVhbCBzb2NrZXQgc3lzdGVtcywgdGhlbiBpdCBtYXkgYmUgdGhhdCBvbmUgb2YgdGhlIHN5c3Rl
bXMgaXMgZGVzaWduZWQgdG8gcm91dGUgYWxsIFBDSS1lIHZpYSBvbmUgc29ja2V0IHNvIHRoYXQg
YWxsIGRyaXZlIHNsb3RzIGNhbiBiZSB1c2VkIGp1c3QgMSBzb2NrZWQgcG9wdWxhdGVkLiBBbmQg
YW5vdGhlciBpcyBkZXNpZ25lZCBzbyB0YWh0IG9ubHkgaGFsZiBvZiB0aGUgZHJpdmUgc2xvdHMg
d29ya3Mgd2hlbiBvbmx5IDEgc29ja2V0IGlzIHBvcHVsYXRlZC4NCkF0IGxlYXN0IEkgaGF2ZSBy
ZWFkIHNvbWV0aGluZyBsaWtlIHRoaXMgcHJldmlvdXNseSBmcm9tIHRoaXMgbGlzdC4NCg0KLy8g
SmlpUGVlDQoNCg0KRmlubGF5c29uLCBKYW1lcyBNIENJViAoVVNBKSBraXJqb2l0dGkgMjYvMDEv
MjAyMiBrbG8gMjIuMTc6DQo+IEkgYXBvbG9naXplIGluIGFkdmFuY2UgaWYgeW91IGNhbiBwb2lu
dCBtZSB0byBzb21ldGhpbmcgSSBjYW4gcmVhZCBhYm91dCBtZHJhaWQgYmVzaWRlcyB0aGUgc291
cmNlIGNvZGUuICBJJ20gYmV5b25kIHRoZSBib3VuZHMgb2YgbXkgdW5kZXJzdGFuZGluZyBvZiBM
aW51eC4gICBCYWNrZ3JvdW5kLCBJIGRvIGEgYnVuY2ggb2YgTlVNQSBhd2FyZSBjb21wdXRpbmcu
ICAgSSBoYXZlIHR3byBzeXN0ZW1zIGNvbmZpZ3VyZWQgaWRlbnRpY2FsbHkgd2l0aCBhIE5VTUEg
bm9kZSAwIGZvY3VzZWQgUkFJRDUgTFVOIGNvbnRhaW5pbmcgTlVNQSBub2RlIDAgbnZtZSBkcml2
ZXMgIGFuZCBhIE5VTUEgbm9kZSAxIGZvY3VzZWQgUkFJRDUgTFVOIGlkZW50aWNhbGx5IGNvbmZp
Z3VyZWQuICA5KzEgbnZtZSwgMTI4S0Igc3RyaXBlLCB4ZnMgc2l0dGluZyBvbiB0b3AsIDY0S0Ig
T19ESVJFQ1QgcmVhZHMgZnJvbSB0aGUgYXBwbGljYXRpb24uDQoNCg==

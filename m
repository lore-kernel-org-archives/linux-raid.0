Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B58C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 28 Jul 2021 10:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DDFB60C51
	for <linux-raid@archiver.kernel.org>; Wed, 28 Jul 2021 10:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhG1KvE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Jul 2021 06:51:04 -0400
Received: from UCOL19PA39.eemsg.mail.mil ([214.24.24.199]:30551 "EHLO
        UCOL19PA39.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhG1KvC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Jul 2021 06:51:02 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2021 06:51:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1627469461; x=1659005461;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XxQITIETTRb/xH5avhgeVTfIPzsvFXZkcRYbF6jMv5M=;
  b=PtGcvGBMjiIhmdyGbo8HJyK8DZrpLBTh5OPtjsexQV8kEjWj+hT2XExd
   MebHLoryitBS+jEHfH5CyVAloynALMQ/huOV/q3Il1SZ0Ts2um/aJXdDN
   4EuG0tw6rJ+WTbSYNyxPFrYXNHMauHT60a1gJ0GQOto61mHuMgOVr5uE7
   NnfonxRNdI1jqRX1NE62LBlFu72Agza+HyWkxXqyRncuixicduvsHTfU+
   nd3Av7Vzf+e/6ZNZzQsIeBi3ZplABCu/6r+QwDlg3gkVw42j4C1xj0ADJ
   hQG/vuaBl3xC81cZNO/YxdnR+kjUleioaWFD+30vi5Ewh4oD+aX/+bAFN
   g==;
X-EEMSG-check-017: 263514444|UCOL19PA39_ESA_OUT06.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.84,276,1620691200"; 
   d="scan'208";a="263514444"
IronPort-HdrOrdr: A9a23:8MJbLqC0C/u+nDXlHenP55DYdb4zR+YMi2TDsHoQdfU1SK2lfq
 +V98jzuSWftN9zYh8dcLK7VJVoKEm0naKdirN/AV7NZmTbhFc=
Received: from edge-mech02.mail.mil ([214.21.130.231])
  by UCOL19PA39.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 28 Jul 2021 10:43:36 +0000
Received: from UMECHPAOZ.easf.csd.disa.mil (214.21.130.169) by
 edge-mech02.mail.mil (214.21.130.231) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Wed, 28 Jul 2021 10:43:36 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.8.97]) by
 umechpaoz.easf.csd.disa.mil ([214.21.130.169]) with mapi id 14.03.0513.000;
 Wed, 28 Jul 2021 10:43:35 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     'Matt Wallis' <mattw@madmonks.org>
CC:     "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>,
        "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Subject: RE: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread IOPS
 - AMD ROME what am I missing?????
Thread-Topic: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread
 IOPS - AMD ROME what am I missing?????
Thread-Index: AQHXg5u9vFEi0nE86k+G7csVB/SvMatYMJ9w
Date:   Wed, 28 Jul 2021 10:43:34 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A23858411D1@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
 <07195088-7E4B-4586-BB45-04890265BD62@madmonks.org>
In-Reply-To: <07195088-7E4B-4586-BB45-04890265BD62@madmonks.org>
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

TWF0dCwNCkkgaGF2ZSBwdXQgYXMgbWFueSBhcyAzMiBwYXJ0aXRpb25zIG9uIGEgZHJpdmUgKGJh
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
IA0KDQpJIHdpbGwgaGF2ZSB0byB0cnkgdGhlIExWTSBleHBlcmltZW50LiAgSSdtIGFuIExWTSAg
bmVvcGh5dGUsIHNvIGl0IG1pZ2h0IHRha2UgbWUgdGhlIHJlc3Qgb2YgdG9kYXkvdG9tb3Jyb3cg
dG8gZ2V0IG5ldyByZXN1bHRzIGFzIEkgdGVuZCB0byBsZXQgbWRyYWlkIGRvIGFsbCBvZiBpdHMg
dm9sdW1lIGJ1aWxkcyB3aXRob3V0IGZvcmNpbmcsIHNvIHRoYXQgd2lsbCB0YWtlIGEgYml0IG9m
IHRpbWUgYWxzby4gIE9uY2UgbWlnaHQgYmUgYWJsZSB0byBhcmd1ZSB0aGF0IGNvbmZpZ3VyYXRp
b24gaXNuJ3QgdG9vIG11Y2ggb2YgYSAiRnJhbmtlbnN0ZWluJ3MgbW9uc3RlciIgZm9yIG1lIHRv
IGhhbmQgaXQgb2ZmLg0KDQpUaGFua3MsDQpKaW0NCg0KDQoNCg0KLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCkZyb206IE1hdHQgV2FsbGlzIDxtYXR0d0BtYWRtb25rcy5vcmc+IA0KU2VudDog
V2VkbmVzZGF5LCBKdWx5IDI4LCAyMDIxIDY6MzIgQU0NClRvOiBGaW5sYXlzb24sIEphbWVzIE0g
Q0lWIChVU0EpIDxqYW1lcy5tLmZpbmxheXNvbjQuY2l2QG1haWwubWlsPg0KQ2M6IGxpbnV4LXJh
aWRAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBbTm9uLURvRCBTb3VyY2VdIFJlOiBDYW4ndCBn
ZXQgUkFJRDUvUkFJRDYgTlZNZSByYW5kb21yZWFkIElPUFMgLSBBTUQgUk9NRSB3aGF0IGFtIEkg
bWlzc2luZz8/Pz8/DQoNCkhpIEppbSwNCg0KPiBPbiAyOCBKdWwgMjAyMSwgYXQgMDY6MzIsIEZp
bmxheXNvbiwgSmFtZXMgTSBDSVYgKFVTQSkgPGphbWVzLm0uZmlubGF5c29uNC5jaXZAbWFpbC5t
aWw+IHdyb3RlOg0KPiANCj4gU29ycnksIHRoaXMgd2lsbCBiZSBhIGxvbmcgZW1haWwgd2l0aCBl
dmVyeXRoaW5nIEkgZmluZCB0byBiZSByZWxldmFudCwgYnV0IEkgY2FuIGdldCBvdmVyIDExMEdC
L3Mgb2YgNGtCIHJhbmRvbSByZWFkcyBmcm9tIGluZGl2aWR1YWwgTlZNZSBTU0RzLCBidXQgSSdt
IGF0IGEgbG9zcyB3aHkgbWRyYWlkIGNhbiBvbmx5IGRvIGEgdmVyeSBzbWFsbCAgZnJhY3Rpb24g
b2YgaXQuICAgSSdtIGF0IG15ICJvcmdhbml6YXRpb25hbCB3b3JsZCByZWNvcmQiIGZvciBzdXN0
YWluZWQgSU9QUywgYnV0IEkgbmVlZCBwcm90ZWN0ZWQgSU9QUyB0byBkbyBzb21ldGhpbmcgdXNl
ZnVsLiAgICAgVGhpcyBpcyBldmVyeXRoaW5nIEkgZG8gdG8gYSBzZXJ2ZXIgdG8gbWFrZSB0aGUg
SS9PIGNyYW5rLi4uLi5NeSByb2xlIGlzIHRoYXQgb2YgYSBsYWIgcmVzZWFyY2hlci9yZXNpZGVu
dCBleHBlcnQvY29uc3VsdGFudC4gICBJJ20ganVzdCBzdHVtcGVkIHdoeSBJIGNhbid0IGRvIGJl
dHRlci4gICBJZiB0aGVyZSBpcyBhIGZpbmUgbWFudWFsIHRoYXQgc29tZWJvZHkgY2FuIHBvaW50
IG1lIHRvLCBJJ20gaGFwcHkgdG8gcmVhZCBpdOKApg0KDQpJIGFtIHByb2JhYmx5IGdvaW5nIHRv
IGdldCBjb3JyZWN0ZWQgb24gc29tZSBpZiBub3QgYWxsIG9mIHRoaXMsIGJ1dCBmcm9tIHdoYXQg
SSB1bmRlcnN0YW5kLCBhbmQgZnJvbSBteSBvd24gbGl0dGxlIGV4cGVyaW1lbnRzIG9uIGEgc2lt
aWxhciBJbnRlbCBiYXNlZCBzeXN0ZW3igKYgMS4gTlZNZSBpcyBzdHVwaWQgZmFzdCwgeW91IG5l
ZWQgYSBnb29kIGNodW5rIG9mIENQVSBwZXJmb3JtYW5jZSB0byBtYXggaXQgb3V0Lg0KMi4gTW9z
dCBibG9jayBJTyBpbiB0aGUga2VybmVsIGlzIGxpbWl0ZWQgaW4gdGVybXMgb2YgdGhyZWFkaW5n
LCBpdCBtYXkgZXZlbiBiZSBlc3NlbnRpYWxseSBzaW5nbGUgdGhyZWFkZWQuIChUaGlzIGlzIHdo
ZXJlIEkgd2lsbCBnZXQgY29ycmVjdGVkKSAzLiBBRkFJQ1QsIHRoaXMgaW5jbHVkZXMgbWRyYWlk
LCB0aGVyZeKAmXMgYSBzaW5nbGUgdGhyZWFkIHBlciBSQUlEIGRldmljZSBoYW5kbGluZyBhbGwg
dGhlIFJBSUQgY2FsY3VsYXRpb25zLiAobWRYX3JhaWQ2KQ0KDQpXaGF0IEkgZGlkIHRvIGdldCBJ
T1BzIHVwIGluIGEgc3lzdGVtIHdpdGggMjQgTlZNZSwgc3BsaXQgdXAgaW50byAxMiBwZXIgTlVN
QSBkb21haW4uDQoxLiBDcmVhdGUgOCBwYXJ0aXRpb25zIG9uIGVhY2ggZHJpdmUgKHRoaXMgbWF5
IGJlIG92ZXJraWxsLCBJIGp1c3Qgc3RhcnRlZCBoZXJlIGZvciBzb21lIHJlYXNvbikgMi4gQ3Jl
YXRlIDggUkFJRDYgYXJyYXlzIHdpdGggMSBwYXJ0aXRpb24gcGVyIGRyaXZlLg0KMy4gVXNlIExW
TSB0byBjcmVhdGUgYSBzaW5nbGUgc3RyaXBlZCBsb2dpY2FsIHZvbHVtZSBvdmVyIGFsbCA4IFJB
SUQgdm9sdW1lcy4gUkFJRCAwKzYgYXMgaXQgd2VyZS4NCg0KWW91IG5vdyBoYXZlIGFuIExWTSB0
aHJlYWQgdGhhdCBpcyBiYXNpY2FsbHkgZG9pbmcgbm90aGluZyBtb3JlIHRoYW4gY2h1bmtpbmcg
dGhlIGRhdGEgYXMgaXQgY29tZXMgaW4sIHRoZW4sIHNlbmRpbmcgdGhlIGNodW5rcyB0byA4IHNl
cGFyYXRlIFJBSUQgZGV2aWNlcywgZWFjaCB3aXRoIHRoZWlyIG93biB0aHJlYWRzLCBidWZmZXJz
LCBxdWV1ZXMgZXRjLCBhbGwgb2Ygd2hpY2ggY2FuIGJlIHNwcmVhZCBvdmVyIG1vcmUgY29yZXMu
DQoNCkkgc2F3IGEgc2lnbmlmaWNhbnQgKGZvciBtZSwgc2lnbmlmaWNhbnQgaXMgPjIwJSkgaW5j
cmVhc2UgaW4gSU9QcyBkb2luZyB0aGlzLiANCg0KWW91IHN0aWxsIGhhdmUgUkFJRDYgcHJvdGVj
dGlvbiwgYnV0IHlvdSBtaWdodCB3YW50IHRvIHdyaXRlIGEgY291cGxlIG9mIHNjcmlwdHMgdG8g
aGVscCB5b3UgbWFuYWdlIHRoZSBhcnJheXMsIGJlY2F1c2UgYSBzaW5nbGUgZmFpbGVkIGRyaXZl
IG5vdyBuZWVkcyB0byBiZSByZW1vdmVkIGZyb20gOCBSQUlEIHZvbHVtZXMuIA0KDQpUaGVyZeKA
mXMgbm90IGEgbG90IG9mIGNhcGFjaXR5IGxvc3QgZG9pbmcgdGhpcywgcHJldHR5IHN1cmUgSSBs
b3N0IGxlc3MgdGhhbiAxMDBNQiB0byB0aGUgcGFydGl0aW9ucyBhbmQgdGhlIFJBSUQgb3Zlcmhl
YWQuDQoNCllvdSB3b3VsZCBuZXZlciBjb25zaWRlciB0aGlzIG9uIHNwaW5uaW5nIGRpc2sgb2Yg
Y291cnNlLCB3YXkgdG8gc2xvdyBhbmQgeW914oCZcmUganVzdCBnb2luZyB0byBtYWtlIGl0IHNs
b3dlciwgTlZNZSBhcyB5b3Ugbm90aWNlZCBoYXMgdGhlIElPUHMgdG8gc3BhcmUsIHNvIEnigJlt
IHByZXR0eSBzdXJlIGl04oCZcyBqdXN0IHRoYXQgd2XigJlyZSBub3QgYWJsZSB0byBnZXQgdGhl
IGRhdGEgdG8gaXQgZmFzdCBlbm91Z2guDQoNCk1hdHQNCg==

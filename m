Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E9CE7D0C0
	for <linux-raid@archiver.kernel.org>; Fri, 22 Sep 2023 02:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjIVCgX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Sep 2023 22:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjIVCgW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Sep 2023 22:36:22 -0400
Received: from twmgb.supermicro.com.tw (211-75-19-8.hinet-ip.hinet.net [211.75.19.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AAD192
        for <linux-raid@vger.kernel.org>; Thu, 21 Sep 2023 19:36:12 -0700 (PDT)
Received: from pps.filterd (twmgb.supermicro.com.tw [127.0.0.1])
        by twmgb.supermicro.com.tw (8.17.1.19/8.17.1.19) with ESMTP id 38M1VXLO021129;
        Fri, 22 Sep 2023 10:36:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=supermicro.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=dkim;
 bh=jXpkXp4tYPnSpFoUZABODFhx3MkxT6/ehNg+nlw7Vew=;
 b=ygBreLsOFOuHMPxM2Ovbc/TpzFSFkgQbPty8QiCzHWCHQ4CIxFAetx9MnTgmDWEwXzIi
 mscwGsHs9rqriovUNdzoOhoe8U4szhVaGku2pk5Xh1OCuqec3RXBe3pTl4SgPBtPCciA
 JV4X0Fd3B2ZGNSJG4W2uzGSlWSLX5BhrJZDaPx3YWIIOnblC0MgksmHnsEY+iHz77SIA
 GPpn32zLqzHUrlPoDHr8d8bRP9CBO12SDui6ZCUoqhbbZQXveIxOWPy0+kl41F8DSNAG
 fJ5ikL0DVovMGCwoi/8iOsybBLbfUbG1iOEQEitjf2gfYqRkVdc2oMbFvJFE0SNKtXPh sQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=supermicro.com.tw; h=from : to : cc
 : subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=dkim;
 bh=jXpkXp4tYPnSpFoUZABODFhx3MkxT6/ehNg+nlw7Vew=;
 b=TNh3U4EkZi6gKbFe+wBdvot9gcsmu3OKDeorfaGDVdpaL2UraRpvcGcFQ7OSpy7jAvjs
 FbQy9q+62bHirqXjSmbSCP+kW4AHIlo4LzFwkgP5q1YjPZBY9wV95Wf8QoD01pPshMYG
 EVzhvb//pgGWq3vpaOQPP9WfYpGj7/cTtt4uMr+HnZsn1CKIBxoydx0oUHtIOsJKYZHe
 2ISeqzffTPPhHw6VfbmbgDbMkf7zRQPM0XfinpKdQyZRF7XpZZBkrqx4DCkAKWvQChyn
 FhW4EW3F3HesLyrCO4ippGmRjWGWgnK/QGF59pg8GCHe9pJo0KXwlgdG4iYvt0t/IcXo lA== 
Received: from tw-ex2013-mbx1.supermicro.com (TW-EX2013-MBX1.supermicro.com [10.128.8.63])
        by twmgb.supermicro.com.tw (PPS) with ESMTPS id 3t8ttbrm35-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 Sep 2023 10:36:02 +0800
Received: from TW-EX2013-MBX1.supermicro.com (10.128.8.63) by
 TW-EX2013-MBX1.supermicro.com (10.128.8.63) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 22 Sep 2023 10:35:58 +0800
Received: from TW-EX2013-MBX1.supermicro.com ([fe80::8c8f:732c:cad9:8f60]) by
 TW-EX2013-MBX1.supermicro.com ([fe80::8c8f:732c:cad9:8f60%12]) with mapi id
 15.00.1497.044; Fri, 22 Sep 2023 10:35:58 +0800
From:   Stan Liao <StanL@supermicro.com>
To:     Xiao Ni <xni@redhat.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: RE: bblog overlap internal bitmap?
Thread-Topic: bblog overlap internal bitmap?
Thread-Index: AdnsOgH6BuJ0WC2oRcuxKQcs7w0lnQADYB8AACwAN9A=
Date:   Fri, 22 Sep 2023 02:35:57 +0000
Message-ID: <1d1fafd557ef4e82a27a3192ffd5dfda@TW-EX2013-MBX1.supermicro.com>
References: <9b21efef0bc1457c89250761b2b6cf2c@TW-EX2013-MBX1.supermicro.com>
 <CALTww29MWS9GY+kc+0nTJywBZVk=aNnzujbNXkPHAjKoO5ZJDw@mail.gmail.com>
In-Reply-To: <CALTww29MWS9GY+kc+0nTJywBZVk=aNnzujbNXkPHAjKoO5ZJDw@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.181.92.67]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

WGlhbyBOaSB3cm90ZToNCj4gT24gVGh1LCBTZXAgMjEsIDIwMjMgYXQgMTE6MjLigK9BTSBTdGFu
IExpYW8gPFN0YW5MQHN1cGVybWljcm8uY29tPiB3cm90ZToNCj4gPg0KPiA+IEhpLA0KPiA+IEEg
bWQtcmFpZCAobGV2ZWwgMSkgaXMgY3JlYXRlZCB3aXRoIDUgbnZtZSBkcml2ZXMgYW5kIHRoZSBt
ZXRhZGF0YSB2ZXJzaW9uDQo+IGlzIHNwZWNpZmllZCBhcyAxLjIuIFRoZSBmb2xsb3dpbmcgY29t
bWFuZCBpcyB1c2VkLg0KPiA+IHN1ZG8gbWRhZG0gLS1jcmVhdGUgL2Rldi9tZDAgLS1sZXZlbD0x
IC0tcmFpZC1kZXZpY2VzPTUNCj4gPiAvZGV2L252bWV7MSwyLDMsNH1uMSAvZGV2L252bWU0bjIg
LS1tZXRhZGF0YT0xLjIgVGhlIGNhcGFjaXRpZXMgb2YNCj4gbnZtZXsxLDIsMyw0fW4xIGFuZCBu
dm1lNG4yIGFyZSAzLjJUQiwgMS45MlRCLCAzLjJUQiwgNTEyR0IsIGFuZCA1MTJHQi4NCj4gPiBP
UzogMjAuMDQuMS1VYnVudHUNCj4gPiBtZGFkbSB2ZXJzaW9uOiB2NC4xIC0gMjAxOC0xMC0wMQ0K
PiA+IEFmdGVyIGNyZWF0aW9uLCB3ZSBmb3VuZCB0aGF0IHRoZSBzaXplIG9mIHRoZSBiaXRtYXBf
c3VwZXJfdCBhbmQgaW50ZXJuYWwNCj4gYml0bWFwIGlzIDE2S0IgKHRoaXMgaXMgY29uY2x1ZGVk
IGJ5IG9ic2VydmluZyBGRiB2YWx1ZSBpcyBmaWxsZWQgZnJvbSBhcm91bmQNCj4gYnl0ZSBvZmZz
ZXQgMHgxMDAgb2YgTEJBIDB4MTAgdG8gYnl0ZSBvZmZzZXQgMHgxRkYgb2YgTEJBIDB4MUYpLCBi
dXQgdGhlDQo+IG1kcF9zdXBlcmJsb2NrXzEuYmJsb2dfb2Zmc2V0IHZhbHVlIGlzIDB4MTAuIEFz
IGEgcmVzdWx0LCB0aGUNCj4gbWRwX3N1cGVyYmxvY2tfMSBvY2N1cGllcyBMQkEgMHgwOCB+IDB4
MEY7IGJpdG1hcF9zdXBlcl90IGFuZCBpbnRlcm5hbA0KPiBiaXRtYXAgb2NjdXB5IExCQSAweDEw
IH4gMHgyMDsgYmJsb2cgb2NjdXBpZXMgTEJBIDB4MTggfiAweDIwLg0KPiA+IElmIGJibG9nIGFu
ZCBiaXRtYXAgZG8gb3ZlcmxhcCwgSSB3b3VsZCBsaWtlIHRvIGtub3cgdGhlIHNpemUgdmFsdWUg
dXNlZCB0bw0KPiBjYWxjdWxhdGUgYml0bWFwIHNpemUgYW5kIGJibG9nX29mZnNldC4gVGhlIHNp
emUgdmFsdWUgdXNlZCB0byBjYWxjdWxhdGUNCj4gYml0bWFwIHNpemUgYW5kIGJibG9nX29mZnNl
dCBpcyBtZHBfc3VwZXJibG9ja18xLnNpemUgb3INCj4gbWRwX3N1cGVyYmxvY2tfMS5kYXRhX3Np
emU/IFRoYW5rcyBhIGxvdC4NCj4gPg0KPiANCj4gSGkNCj4gDQo+IEZvciBzdXBlcjEuMiB0aGUg
bGF5b3V0IHNob3VsZCBiZToNCj4gfCAgICA0S0IgICAgfCAgICA0S0IgICAgfCAgICBiaXRtYXAg
c3BhY2UgICAgfCAgICBoZWFkIHJvb20gICAgfA0KPiBkYXRhIHwNCj4gDQo+IFRoZSBmaXJzdCA0
S0IgaXMgZW1wdHkgZnJvbSB0aGUgYmVnaW5uaW5nIG9mIHRoZSBkaXNrLiBUaGUgc2Vjb25kIDRL
QiBpcyBmb3INCj4gbWQgc3VwZXJibG9jay4gVGhlbiBpcyBiaXRtYXAgc3VlcmJsb2NrLiBTbyBp
ZiB5b3Ugd2FudCB0byBzZWUgdGhlIGNvbnRlbnQNCj4gb2YgYml0bWFwX3N1cGVyX3QsIHRoZSBv
ZmZzZXQgc2hvdWxkIGJlIDB4MjAwMD8NCj4gDQo+IFJlZ2FyZHMNCj4gWGlhbw0KDQpSaWdodC4g
VGhlIGJpdG1hcF9zdXBlcl90IGlzIGF0IG9mZnNldCAweDIwMDAgKGFic29sdXRlIExCQSBhZGRy
ZXNzIDB4MTApLg0KQW5kIG1kYWRtIHdyaXRlIGJpdG1hcF9zdXBlcl90IGFuZCBiaXRtYXAgZnJv
bSBMQkEgMHgxMCB0byBMQkEgMHgxRi4NCkluY2x1ZGluZyBiYmxvZywgc3VwZXIxLjIgbGF5b3V0
IHdvdWxkIGJlOg0KfCAgNEtCICB8ICA0S0IgIHwgIGJpdG1hcCBzcGFjZSAgfCAgYmJsb2cgIHwg
IGhlYWQgcm9vbSAgfCBkYXRhIHwNCldlIG9ic2VydmUgdGhlIGJibG9nX29mZnNldCB2YWx1ZSwg
d2hpY2ggcmVzaWRlcyBpbiBtZHBfc3VwZXJibG9ja18xLCBpcyAweDEwLg0KU28gd2UgdGhpbmsg
dGhlcmUgaXMgYW4gb3ZlcmxhcCBiZXR3ZWVuIGJpdG1hcCBhbmQgYmJsb2cuDQoNCg==

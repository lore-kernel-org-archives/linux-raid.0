Return-Path: <SRS0=kNf2=D3=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5173FC433E7
	for <linux-raid@archiver.kernel.org>; Tue, 20 Oct 2020 09:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB242223C
	for <linux-raid@archiver.kernel.org>; Tue, 20 Oct 2020 09:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=intel.onmicrosoft.com header.i=@intel.onmicrosoft.com header.b="xF5XlJel"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404443AbgJTJuV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Oct 2020 05:50:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:3053 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404441AbgJTJuU (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 20 Oct 2020 05:50:20 -0400
IronPort-SDR: 1HBsQeC+CnpqPaaj5u8kGVoFfCSEsHOzCkV/tJOebMg/TnIHittIpE+rpYjOGmFGD5a03MpCwd
 U5hiIxbHyMyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="167302071"
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="scan'208";a="167302071"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 02:50:20 -0700
IronPort-SDR: +sHgfg0FtBm22jUq1KM14/QDCxleT4/kxlWvlI3yCBdaN1s8GyIHUHvUXsG7QQKpxUSYGm+FVM
 tlDCIC7tJ4Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="scan'208";a="532994094"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga005.jf.intel.com with ESMTP; 20 Oct 2020 02:50:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 02:50:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 02:50:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Oct 2020 02:50:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 20 Oct 2020 02:50:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBlBrPPNdK62a5ZGI8vSAbHK3t51iklicWiJUsCZpZTUyWdv8MdVa+JaimE2IpueLUgYaiF+8oq2bDEybA5wNr95LPp/4k5sfT1ufWQ5tEHp8kcGIMZ+CRxLLNQ28jIk0XYDlNz+KKJJ8aqFEE0MNDDzRXAZhSu6dEj+fn2bTLFiaoNDUkdmKRCttn08ygd+ZgCcU3ETBVlLuDhoyH/QxIHLQz+yXBcXUOfLZ3XfHOqeG6Ui9iaqK8UsR8VIx7oV3PJFcSp/ENYpZ3AXT7URpjpHZW+EHBnyjfMgSPHZmyRp1Y1p5/N4iLzOqbjCjnVh+jGT/bsyVkDqGE+UGw7hvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNdgPIN0I3fSyJjlUGqGZL3a5x5dTRCbDzwPEPAYH50=;
 b=fpNyOGs4pVex6i9/nRf9D2uJ3kmOUx8C+4d0rH9+s9Hwj/sCQKt63aIIlAoJjshy/pieJNb6Mz2BRCiFU8Fm5pzqh+2n2NH0O89wE0ErUh8n2X5z01/4i/3bDOL/+r0iX8d32DsGgld+iTmLt8dhjpA3AmQtt0A7zA6KSM1vDDYqQwIqw9ErLmL9LqVU/0hyUeMQ3dx7kIOTdH5agMsU93XBRrlVD3Gw/rWpZx530xaiGbbPXTDuupWYbXKgXPH+J9bpy1dB6EfZsXoNY2OvJ6fy5ZT5440IMXUYTNtXozHvuv+LNh1sVnikgKUc/tpT3rWB07FZ7Mw+xcp5lcvaSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNdgPIN0I3fSyJjlUGqGZL3a5x5dTRCbDzwPEPAYH50=;
 b=xF5XlJel3jMdo6VGaIP9rt+oGi1V7HW7Jk7gWR5BAsJs9JM5iY8nYzu/p+QOqLgB9eH3zRhmAu2ULYblT4Atjk/PURYGHeXCeY81iLKCdsVPCcb9TZgs+I7EU91NbOIzzR3oBsip2Wxu4gS0RX0Xk5i/6sdVVos3a9inYgj+XzY=
Received: from SA0PR11MB4542.namprd11.prod.outlook.com (2603:10b6:806:9f::20)
 by SN6PR11MB3520.namprd11.prod.outlook.com (2603:10b6:805:cf::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Tue, 20 Oct
 2020 09:50:18 +0000
Received: from SA0PR11MB4542.namprd11.prod.outlook.com
 ([fe80::d863:c0a3:91e2:3974]) by SA0PR11MB4542.namprd11.prod.outlook.com
 ([fe80::d863:c0a3:91e2:3974%6]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 09:50:17 +0000
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>,
        Lidong Zhong <lidong.zhong@suse.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: RE: [PATCH v2] Detail: show correct raid level when the array is
 inactive
Thread-Topic: [PATCH v2] Detail: show correct raid level when the array is
 inactive
Thread-Index: AQHWikI0wfBEyBc6k0GFfCSa+w6AsamXZm8AgAkPC4A=
Date:   Tue, 20 Oct 2020 09:50:17 +0000
Message-ID: <SA0PR11MB454240AADCFC09D4771325E3FF1F0@SA0PR11MB4542.namprd11.prod.outlook.com>
References: <20200914025218.7197-1-lidong.zhong@suse.com>
 <48f8cd25-d872-e306-a544-e31c59d91c9b@trained-monkey.org>
In-Reply-To: <48f8cd25-d872-e306-a544-e31c59d91c9b@trained-monkey.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [89.64.90.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6dc412a1-6987-44a3-2801-08d874dd8d42
x-ms-traffictypediagnostic: SN6PR11MB3520:
x-microsoft-antispam-prvs: <SN6PR11MB3520A3B09AF94839D9D5ED24FF1F0@SN6PR11MB3520.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cC+GQiCL0A120A6ZUN8SCy98Foc4ouA0Vwe5fGub47XPEaiiUpjiGSSFcX8VBQJRxSxot81PnrxliAF+FmWFvbe5n+M/q5D9qVzIVbFkHcEismEW1FGhuRekMWuqtVYpVJFRojznNHaj7Esdm9Nk98c0FEybQluSGzFUi+1RsLXZVLcgHWKDG7LNjswQe2l68CAvyjpHRsR0B8oddhWTbRFvMrM7CqYmFPNPYWdb8MHQJ3vDY7UGZbPKu2Bh99yiQuAwEV/CrJz7so540QXtYOyM4lLPcuO8xnAM19VyFcn7WsDygzziin3WxYEPtHHukq+dVXoV8EcWMOLqOBQ3EA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR11MB4542.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(6506007)(66446008)(4326008)(83380400001)(64756008)(76116006)(66556008)(53546011)(478600001)(66476007)(26005)(66946007)(86362001)(316002)(8676002)(9686003)(8936002)(5660300002)(33656002)(7696005)(55016002)(2906002)(110136005)(186003)(71200400001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +eJf3Vbu55JaZLNtsa5UCYJ5WOUqkjd641tjjh78nzilz+exorG2AC+vxFxGBuHGq1XomwcouyNnNHmhOxEM2Tn18LT/Mifuw69CSvuqLOaCBvYOhxb/g2orJ7zyQLmaYjM7ZhyGbhLR82MgYzIZvjwEgw4mEjZ6E6JB0BLAvh8E7cK4TwVZiC4MyOtUGH/0JJVW7T5fC1+ER3xRqqVzFa/smG19zNJ4hl2hQ11Xf7CpIN0fT3flDsRFWS4tLueT4q+AT2g5M91ShXVQEACfzBOzAVn+E5SHQP+sQ4MuLMtgZRtEhfEv+/ef9LwSJSFKjcPWfspeGi0GKaraMpPONCSttrGiewAOsxWg7xdS/MaT3PLAXpAh0pjBPEbyoFwM89iDWZiQ71hN+W31jdc2/0vXVLje+hbD/M8Q2mz9RfsOls89IE9/GWliL5Vksy3jVoYXmJxuxuvZi0G9KUExhJ1avkJoZiAmfZmjuNT1vVcv8cdQxjhQvOMq5l6Or1PxYFAs56U00vHyKaou5CxEqo5uVSpbUb1O1HDHFzu42ryT9TRwDjUtXrh3poiUDXiDOdlbFDRLi2d9kkwxNtN/oG2YlllVZn/1Bj03ZZkd3jRdGvtSd/vw8iAgTLzzI7N/HObhRebsqDlYMSJGo4JoHQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR11MB4542.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc412a1-6987-44a3-2801-08d874dd8d42
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 09:50:17.7859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0WpyJOPhRNdiaqquRUX8krfrUQPo5NiGSZyf7JnD+f/GfVRm2wztWLw2qnXUoDnsLlfBgaVnGESLQSOQ7MH3pSL+kwinwe8LI7GFUlAg77I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3520
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

SGVsbG8gTGlkb25nLA0KV2UgYXJlIG9ic2VydmluZyBzZXFmYXVsdCBkdXJpbmcgSU1TTSByYWlk
IGNyZWF0aW9uIGNhdXNlZCBieSB5b3VyIHBhdGNoLg0KDQpDb3JlIHdhcyBnZW5lcmF0ZWQgYnkg
YC9zYmluL21kYWRtIC0tZGV0YWlsIC0tZXhwb3J0IC9kZXYvbWQxMjcnLg0KUHJvZ3JhbSB0ZXJt
aW5hdGVkIHdpdGggc2lnbmFsIFNJR1NFR1YsIFNlZ21lbnRhdGlvbiBmYXVsdC4NCiMwICAweDAw
MDAwMDAwMDA0MjUxNmUgaW4gRGV0YWlsIChkZXY9MHg3ZmZkYmQ2ZDFlZmMgIi9kZXYvbWQxMjci
LCBjPTB4N2ZmZGJkNmQwNzEwKSBhdCBEZXRhaWwuYzoyMjgNCjIyOCAgICAgICAgICAgICAgICAg
ICAgIHN0ciA9IG1hcF9udW0ocGVycywgaW5mby0+YXJyYXkubGV2ZWwpOw0KDQpUaGUgaXNzdWUg
b2NjdXJzIGR1cmluZyBjb250YWluZXIgb3Igdm9sdW1lIGNyZWF0aW9uIGFuZCBjYW5ub3QgYmUg
cmVwcm9kdWNlZCBtYW51YWxseS4NCkluIG15IG9waW5pb24gdWRldiBpcyByYWNpbmcgd2l0aCBj
cmVhdGUgcHJvY2Vzcy4gT2JzZXJ2ZWQgb24gUkhFTCA4LjIgd2l0aCB1cHN0cmVhbSBtZGFkbS4N
CkNvdWxkIHlvdSBsb29rPw0KDQpJZiB5b3UgYXJlIGxhY2sgb2YgSU1TTSBoYXJkd2FyZSBwbGVh
c2UgdXNlIElNU01fTk9fUExBVEZPUk0gZW52aXJvbm1lbnQgdmFyaWFibGUuDQoNClRoYW5rcywN
Ck1hcml1c3oNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEplcyBTb3JlbnNl
biA8amVzQHRyYWluZWQtbW9ua2V5Lm9yZz4gDQpTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIgMTQs
IDIwMjAgNToyMCBQTQ0KVG86IExpZG9uZyBaaG9uZyA8bGlkb25nLnpob25nQHN1c2UuY29tPg0K
Q2M6IGxpbnV4LXJhaWRAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW1BBVENIIHYyXSBE
ZXRhaWw6IHNob3cgY29ycmVjdCByYWlkIGxldmVsIHdoZW4gdGhlIGFycmF5IGlzIGluYWN0aXZl
DQoNCk9uIDkvMTMvMjAgMTA6NTIgUE0sIExpZG9uZyBaaG9uZyB3cm90ZToNCj4gU29tZXRpbWVz
IHRoZSByYWlkIGxldmVsIGluIHRoZSBvdXRwdXQgb2YgYG1kYWRtIC1EIC9kZXYvbWRYYCBpcyAN
Cj4gbWlzbGVhZGluZyB3aGVuIHRoZSBhcnJheSBpcyBpbiBpbmFjdGl2ZSBzdGF0ZS4gSGVyZSBp
cyBhIHRlc3RjYXNlIGZvciANCj4gaW50cm9kdWN0aW9uLg0KPiAxXCBjcmVhdGluZyBhIHJhaWQx
IGRldmljZSB3aXRoIHR3byBkaXNrcy4gU3BlY2lmeSBhIGRpZmZlcmVudCANCj4gaG9zdG5hbWUg
cmF0aGVyIHRoYW4gdGhlIHJlYWwgb25lIGZvciBsYXRlciB2ZXJmaWNhdGlvbi4NCj4gDQo+IG5v
ZGUxOn4gIyBtZGFkbSAtLWNyZWF0ZSAvZGV2L21kMCAtLWhvbWVob3N0IFRFU1RBUlJBWSAtbyAt
bCAxIC1uIDIgDQo+IC9kZXYvc2RiIC9kZXYvc2RjIDJcIHJlbW92ZSBvbmUgb2YgdGhlIGRldmlj
ZXMgYW5kIHJlYm9vdCAzXCBzaG93IHRoZSANCj4gZGV0YWlsIG9mIHJhaWQxIGRldmljZQ0KPiAN
Cj4gbm9kZTE6fiAjIG1kYWRtIC1EIC9kZXYvbWQxMjcNCj4gL2Rldi9tZDEyNzoNCj4gICAgICAg
ICBWZXJzaW9uIDogMS4yDQo+ICAgICAgUmFpZCBMZXZlbCA6IHJhaWQwDQo+ICAgVG90YWwgRGV2
aWNlcyA6IDENCj4gICAgIFBlcnNpc3RlbmNlIDogU3VwZXJibG9jayBpcyBwZXJzaXN0ZW50DQo+
ICAgICAgICAgICBTdGF0ZSA6IGluYWN0aXZlDQo+IFdvcmtpbmcgRGV2aWNlcyA6IDENCj4gDQo+
IFlvdSBjYW4gc2VlIHRoYXQgdGhlICJSYWlkIExldmVsIiBpbiAvZGV2L21kMTI3IGlzIHJhaWQw
IG5vdy4NCj4gQWZ0ZXIgc3RlcCAyXCBpcyBkb25lLCB0aGUgZGVncmFkZWQgcmFpZDEgZGV2aWNl
IGlzIHJlY29nbml6ZWQgYXMgYSANCj4gImZvcmVpZ24iIGFycmF5IGluIDY0LW1kLXJhaWQtYXNz
ZW1ibHkucnVsZXMuIEFuZCB0aHVzIHRoZSB0aW1lciB0byANCj4gYWN0aXZhdGUgdGhlIHJhaWQx
IGRldmljZSBpcyBub3QgdHJpZ2dlcmVkLiBUaGUgYXJyYXkgbGV2ZWwgcmV0dXJuZWQgDQo+IGZy
b20gR0VUX0FSUkFZX0lORk8gaW9jdGwgaXMgMC4gQW5kIHRoZSBzdHJpbmcgc2hvd24gZm9yICJS
YWlkIExldmVsIiANCj4gaXMgc3RyID0gbWFwX251bShwZXJzLCBhcnJheS5sZXZlbCk7IEFuZCB0
aGUgZGVmaW5pdGlvbiBvZiBwZXJzIGlzIA0KPiBtYXBwaW5nX3QgcGVyc1tdID0geyB7ICJsaW5l
YXIiLCBMRVZFTF9MSU5FQVJ9LCB7ICJyYWlkMCIsIDB9LCB7ICIwIiwgDQo+IDB9IC4uLg0KPiBT
byB0aGUgbWlzbGVhZGluZyAicmFpZDAiIGlzIHNob3duIGluIHRoaXMgdGVzdGNhc2UuDQo+IA0K
PiBDaGFuZ2Vsb2c6DQo+IHYxOiBkb24ndCBzaG93ICJSYWlkIExldmVsIiB3aGVuIGFycmF5IGlz
IGluYWN0aXZlDQo+IFNpZ25lZC1vZmYtYnk6IExpZG9uZyBaaG9uZyA8bGlkb25nLnpob25nQHN1
c2UuY29tPg0KPg0KDQpBcHBsaWVkIQ0KDQpUaGFua3MsDQpKZXMNCg0K

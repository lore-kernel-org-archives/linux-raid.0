Return-Path: <SRS0=kNf2=D3=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0B4C43457
	for <linux-raid@archiver.kernel.org>; Tue, 20 Oct 2020 12:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC0C22253
	for <linux-raid@archiver.kernel.org>; Tue, 20 Oct 2020 12:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=intel.onmicrosoft.com header.i=@intel.onmicrosoft.com header.b="AEw5L6BY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406094AbgJTMci (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Oct 2020 08:32:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:22217 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404551AbgJTMch (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 20 Oct 2020 08:32:37 -0400
IronPort-SDR: A5pRKnhgqzpqT8QfPjJIsSpPsIl+vPh55XLBALSRWw3JF2zMCr6cApUL2Ytyg8HgtCp1zprsju
 YASYAbAXveMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="147056290"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="147056290"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 05:32:37 -0700
IronPort-SDR: whV+bDPigacCRnRxkqdXH0R+MU4t8+xVBXatytrk9pXDf8Bn+3TiR5U4alb2tjiZHM8s14T1uP
 OZSQ/zUDDOIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="522363627"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 20 Oct 2020 05:32:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 05:32:36 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 05:32:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Oct 2020 05:32:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 20 Oct 2020 05:32:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Li3k6T7fSkIN9g5dGgE1yN+0GQOBAZb03stnGqeqzH7M+H7CK91nN686rabihn5vWBpob2jECfnizlI98l+IcHivPQDrZgNAKrBO/Trbq8BA0EZ92sl9ugjapRqWvAt1gHNdgZi5rSrfpdebzkNezJLhBmeUzOcyxk5GipiwFBzJzKMQ8hLbw5r/jHOvMvSdOVZSlGV9Hsv6b7ORWAMedhZR8RBD7c7oFSI7QELDc9VZISqo/9/wkm55gyYc2AkaztGfoQUe/D7CD2ndBZhIpTRCXNc3W6Mi37Gd4SuFkkxVg+XERlPDptewnULvLSB7EPBzYys70DEt5yANECU+xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIZln8lcYvGF9mphFl+NakQ30kqHIA11kfaDabH7kck=;
 b=Gv2wvGmowHGEADphsrPkgqU0Ts2Cs51CNUismn9EE0Y8a/h2ZzuhgjuBHzBl3Wt3FerNsuF0nF94NHyx9htFjLW7QWvML6jFJSPTvX7wEYnv7UkZSNo1TlznX3cn2KmqnDUWNfWunFK9S9+h1Fjp/lzWTwV8b0Fs6/y5Lol2zcIOWZKYd9kmYBanvaHFLz8M3sFd7r3T5bCL1irwhzwb7s3tsbkQpmRkg9P3Oegbi07vgpikW2F7N2hJiVx587SqtjQ25uaRd9nLcZ8gGp6Zj/GvpC/9JRRfr5uqUlqI3Qe6AiACOgJxulzBKPaLOY69BPKk8V4weCsz57lOjNNevA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIZln8lcYvGF9mphFl+NakQ30kqHIA11kfaDabH7kck=;
 b=AEw5L6BYylPseOIrozg6VCuXmRktDf6LJnGZEwhaMqs2UHTHRUP17SAgkQ/IKc010rZvSEnUIDTt3wd/RW9dJ1eo+xieIzkuS41f9Ltd7y6PIQNWm8QAAaw6s1Kupc61HwwFXME8gcyq+FzvLIdfNNOBED/fjnKmKu6yxzo/Bp8=
Received: from SA0PR11MB4542.namprd11.prod.outlook.com (2603:10b6:806:9f::20)
 by SN6PR11MB2752.namprd11.prod.outlook.com (2603:10b6:805:59::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Tue, 20 Oct
 2020 12:32:33 +0000
Received: from SA0PR11MB4542.namprd11.prod.outlook.com
 ([fe80::d863:c0a3:91e2:3974]) by SA0PR11MB4542.namprd11.prod.outlook.com
 ([fe80::d863:c0a3:91e2:3974%6]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 12:32:33 +0000
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Lidong Zhong <lidong.zhong@suse.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: RE: [PATCH v2] Detail: show correct raid level when the array is
 inactive
Thread-Topic: [PATCH v2] Detail: show correct raid level when the array is
 inactive
Thread-Index: AQHWikI0wfBEyBc6k0GFfCSa+w6AsamXZm8AgAkPC4CAAC1sAA==
Date:   Tue, 20 Oct 2020 12:32:33 +0000
Message-ID: <SA0PR11MB45428397B07F6DF50E6F0CBFFF1F0@SA0PR11MB4542.namprd11.prod.outlook.com>
References: <20200914025218.7197-1-lidong.zhong@suse.com>
 <48f8cd25-d872-e306-a544-e31c59d91c9b@trained-monkey.org>
 <SA0PR11MB454240AADCFC09D4771325E3FF1F0@SA0PR11MB4542.namprd11.prod.outlook.com>
In-Reply-To: <SA0PR11MB454240AADCFC09D4771325E3FF1F0@SA0PR11MB4542.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [89.64.90.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b76772d-d36f-405c-7e44-08d874f43834
x-ms-traffictypediagnostic: SN6PR11MB2752:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2752B0840791E8177E99696DFF1F0@SN6PR11MB2752.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1M0NSmse7kvKN5TQZhh0F0CIUk3A5MutC3bBkbyxqgCnhuVn6JABAXIgpYikxanmvFwbyhw/v4tU5hGirKmhaUSs8O43xMuOR4otQcjPwkOGB7++0//jKdtONXlJTyXTstK3YTFvGXE4v08TE4vWvlTeva/3d8mYeSZcTpWC5IKws7eCUtnHrrd613CKj9eNAr+sGMKz6XOmtq5Mh/qDc3ZbOM+4aTAeWxGfkrLgNULrzOo3xI5thXmyl1rfBrfF02Q/8qshUAq9yoCJC/kJXroXsLHGYnZlbf+XAD4GKFEbGnVsndVU/tQtGYau6LEht9Dr25WTq2dq1aE8aC+8yw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR11MB4542.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(5660300002)(8936002)(7696005)(6506007)(53546011)(8676002)(71200400001)(83380400001)(316002)(110136005)(2940100002)(66556008)(76116006)(66946007)(52536014)(64756008)(66446008)(26005)(66476007)(478600001)(9686003)(33656002)(2906002)(55016002)(186003)(86362001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: XdpFMr8CJGzL9W9a7Cvm5lUSeXTsWIJfUntMmoW5PlD4GbDIlGEajEBTLPrjk+R1a/ro1X+1tnn+5FTHRkN2G4VEAF8UVMZZFr14a3L0qYZpNhgpigdlYFVWWwt2EZ3WJPeefsLPhM7NXTxk6TX0QtkMbpdDh8nBk13Byg6S1jsrmT7CjWNj4vCKgQ8KJXCTivsWcxYs9bOt1ITaKewUa3gTL6Jvv64KeJ7yOxIa4njhbxsOElMRZYzYPqP5PnmM0ZqbM7YPoEy1Bl4Tl8smmAZf8aO/SliaSoJAv/iPS9+bHElIcmJQ1GxiecBBP9rlTIc25G91K1StSAZKiR7psQjZJaVMOQabzOnA6Bi2fK7mxp9R2KwE50nGNAL4cOVtJ+UQvY/wx6QLpK6aImFvZ4bmP4UquDemoUGkfmx+pI/gjVwt3S4tpmSAg+L2ELM9IdJbQIAivKgZo6oAKaUcfJk1TH9APf7BqXDLD1Okre9WfJ0EFP3hr3XeP5XeIB9AV4pGSOPEJ785naHIk1+fctLHVYTCXuPriZmi/c16gYec3uhTmxYySVhDXesSdIyCb7MUCEoFlDVfSVr952VTz5rlEoFQxFQcbRoOUEzJKVxTynpLjPbPiMCb6Nxx7QwL/VTFYRMTNZj1Vlmc7FzdYg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR11MB4542.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b76772d-d36f-405c-7e44-08d874f43834
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 12:32:33.5268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s0y585AEfuqLSq60zCYSw18h4Qo5dNClv+RGunRKnnc7GXq0vfLXA2bc53HSdzsAlH8Jo85lK0xWzfHfDs/P2enVOJ5MeLH1iQbbZRHJxqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2752
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

SGVsbG8sDQpvbmUgY2xhcmlmaWNhdGlvbjoNCklzc3VlIGNhbiBiZSByZXByb2R1Y2VkLCBqdXN0
IGNyZWF0ZSBjb250YWluZXIgYW5kIG9ic2VydmUgc3lzdGVtIGpvdXJuYWwuDQpJIG1lYW4gdGhh
dCB0aGUgc2VxZmF1bHQgY2Fubm90IGJlIHJlcHJvZHVjZWQgZGlyZWN0bHksIGl0IGNvbWVzIGlu
IGJhY2tncm91bmQsDQpkdXJpbmcgY3JlYXRpb24uDQoNClNvcnJ5IGZvciBiZWluZyBpbmFjY3Vy
YXRlLg0KDQpNYXJpdXN6DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBUa2Fj
enlrLCBNYXJpdXN6IDxtYXJpdXN6LnRrYWN6eWtAaW50ZWwuY29tPiANClNlbnQ6IFR1ZXNkYXks
IE9jdG9iZXIgMjAsIDIwMjAgMTE6NTAgQU0NClRvOiBKZXMgU29yZW5zZW4gPGplc0B0cmFpbmVk
LW1vbmtleS5vcmc+OyBMaWRvbmcgWmhvbmcgPGxpZG9uZy56aG9uZ0BzdXNlLmNvbT4NCkNjOiBs
aW51eC1yYWlkQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUkU6IFtQQVRDSCB2Ml0gRGV0YWls
OiBzaG93IGNvcnJlY3QgcmFpZCBsZXZlbCB3aGVuIHRoZSBhcnJheSBpcyBpbmFjdGl2ZQ0KDQpI
ZWxsbyBMaWRvbmcsDQpXZSBhcmUgb2JzZXJ2aW5nIHNlcWZhdWx0IGR1cmluZyBJTVNNIHJhaWQg
Y3JlYXRpb24gY2F1c2VkIGJ5IHlvdXIgcGF0Y2guDQoNCkNvcmUgd2FzIGdlbmVyYXRlZCBieSBg
L3NiaW4vbWRhZG0gLS1kZXRhaWwgLS1leHBvcnQgL2Rldi9tZDEyNycuDQpQcm9ncmFtIHRlcm1p
bmF0ZWQgd2l0aCBzaWduYWwgU0lHU0VHViwgU2VnbWVudGF0aW9uIGZhdWx0Lg0KIzAgIDB4MDAw
MDAwMDAwMDQyNTE2ZSBpbiBEZXRhaWwgKGRldj0weDdmZmRiZDZkMWVmYyAiL2Rldi9tZDEyNyIs
IGM9MHg3ZmZkYmQ2ZDA3MTApIGF0IERldGFpbC5jOjIyOA0KMjI4ICAgICAgICAgICAgICAgICAg
ICAgc3RyID0gbWFwX251bShwZXJzLCBpbmZvLT5hcnJheS5sZXZlbCk7DQoNClRoZSBpc3N1ZSBv
Y2N1cnMgZHVyaW5nIGNvbnRhaW5lciBvciB2b2x1bWUgY3JlYXRpb24gYW5kIGNhbm5vdCBiZSBy
ZXByb2R1Y2VkIG1hbnVhbGx5Lg0KSW4gbXkgb3BpbmlvbiB1ZGV2IGlzIHJhY2luZyB3aXRoIGNy
ZWF0ZSBwcm9jZXNzLiBPYnNlcnZlZCBvbiBSSEVMIDguMiB3aXRoIHVwc3RyZWFtIG1kYWRtLg0K
Q291bGQgeW91IGxvb2s/DQoNCklmIHlvdSBhcmUgbGFjayBvZiBJTVNNIGhhcmR3YXJlIHBsZWFz
ZSB1c2UgSU1TTV9OT19QTEFURk9STSBlbnZpcm9ubWVudCB2YXJpYWJsZS4NCg0KVGhhbmtzLA0K
TWFyaXVzeg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSmVzIFNvcmVuc2Vu
IDxqZXNAdHJhaW5lZC1tb25rZXkub3JnPg0KU2VudDogV2VkbmVzZGF5LCBPY3RvYmVyIDE0LCAy
MDIwIDU6MjAgUE0NClRvOiBMaWRvbmcgWmhvbmcgPGxpZG9uZy56aG9uZ0BzdXNlLmNvbT4NCkNj
OiBsaW51eC1yYWlkQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFtQQVRDSCB2Ml0gRGV0
YWlsOiBzaG93IGNvcnJlY3QgcmFpZCBsZXZlbCB3aGVuIHRoZSBhcnJheSBpcyBpbmFjdGl2ZQ0K
DQpPbiA5LzEzLzIwIDEwOjUyIFBNLCBMaWRvbmcgWmhvbmcgd3JvdGU6DQo+IFNvbWV0aW1lcyB0
aGUgcmFpZCBsZXZlbCBpbiB0aGUgb3V0cHV0IG9mIGBtZGFkbSAtRCAvZGV2L21kWGAgaXMgDQo+
IG1pc2xlYWRpbmcgd2hlbiB0aGUgYXJyYXkgaXMgaW4gaW5hY3RpdmUgc3RhdGUuIEhlcmUgaXMg
YSB0ZXN0Y2FzZSBmb3IgDQo+IGludHJvZHVjdGlvbi4NCj4gMVwgY3JlYXRpbmcgYSByYWlkMSBk
ZXZpY2Ugd2l0aCB0d28gZGlza3MuIFNwZWNpZnkgYSBkaWZmZXJlbnQgDQo+IGhvc3RuYW1lIHJh
dGhlciB0aGFuIHRoZSByZWFsIG9uZSBmb3IgbGF0ZXIgdmVyZmljYXRpb24uDQo+IA0KPiBub2Rl
MTp+ICMgbWRhZG0gLS1jcmVhdGUgL2Rldi9tZDAgLS1ob21laG9zdCBURVNUQVJSQVkgLW8gLWwg
MSAtbiAyIA0KPiAvZGV2L3NkYiAvZGV2L3NkYyAyXCByZW1vdmUgb25lIG9mIHRoZSBkZXZpY2Vz
IGFuZCByZWJvb3QgM1wgc2hvdyB0aGUgDQo+IGRldGFpbCBvZiByYWlkMSBkZXZpY2UNCj4gDQo+
IG5vZGUxOn4gIyBtZGFkbSAtRCAvZGV2L21kMTI3DQo+IC9kZXYvbWQxMjc6DQo+ICAgICAgICAg
VmVyc2lvbiA6IDEuMg0KPiAgICAgIFJhaWQgTGV2ZWwgOiByYWlkMA0KPiAgIFRvdGFsIERldmlj
ZXMgOiAxDQo+ICAgICBQZXJzaXN0ZW5jZSA6IFN1cGVyYmxvY2sgaXMgcGVyc2lzdGVudA0KPiAg
ICAgICAgICAgU3RhdGUgOiBpbmFjdGl2ZQ0KPiBXb3JraW5nIERldmljZXMgOiAxDQo+IA0KPiBZ
b3UgY2FuIHNlZSB0aGF0IHRoZSAiUmFpZCBMZXZlbCIgaW4gL2Rldi9tZDEyNyBpcyByYWlkMCBu
b3cuDQo+IEFmdGVyIHN0ZXAgMlwgaXMgZG9uZSwgdGhlIGRlZ3JhZGVkIHJhaWQxIGRldmljZSBp
cyByZWNvZ25pemVkIGFzIGEgDQo+ICJmb3JlaWduIiBhcnJheSBpbiA2NC1tZC1yYWlkLWFzc2Vt
Ymx5LnJ1bGVzLiBBbmQgdGh1cyB0aGUgdGltZXIgdG8gDQo+IGFjdGl2YXRlIHRoZSByYWlkMSBk
ZXZpY2UgaXMgbm90IHRyaWdnZXJlZC4gVGhlIGFycmF5IGxldmVsIHJldHVybmVkIA0KPiBmcm9t
IEdFVF9BUlJBWV9JTkZPIGlvY3RsIGlzIDAuIEFuZCB0aGUgc3RyaW5nIHNob3duIGZvciAiUmFp
ZCBMZXZlbCINCj4gaXMgc3RyID0gbWFwX251bShwZXJzLCBhcnJheS5sZXZlbCk7IEFuZCB0aGUg
ZGVmaW5pdGlvbiBvZiBwZXJzIGlzIA0KPiBtYXBwaW5nX3QgcGVyc1tdID0geyB7ICJsaW5lYXIi
LCBMRVZFTF9MSU5FQVJ9LCB7ICJyYWlkMCIsIDB9LCB7ICIwIiwgDQo+IDB9IC4uLg0KPiBTbyB0
aGUgbWlzbGVhZGluZyAicmFpZDAiIGlzIHNob3duIGluIHRoaXMgdGVzdGNhc2UuDQo+IA0KPiBD
aGFuZ2Vsb2c6DQo+IHYxOiBkb24ndCBzaG93ICJSYWlkIExldmVsIiB3aGVuIGFycmF5IGlzIGlu
YWN0aXZlDQo+IFNpZ25lZC1vZmYtYnk6IExpZG9uZyBaaG9uZyA8bGlkb25nLnpob25nQHN1c2Uu
Y29tPg0KPg0KDQpBcHBsaWVkIQ0KDQpUaGFua3MsDQpKZXMNCg0K

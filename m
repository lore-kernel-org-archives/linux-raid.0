Return-Path: <SRS0=Kwls=DG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165CBC4727C
	for <linux-raid@archiver.kernel.org>; Tue, 29 Sep 2020 14:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7EAE20739
	for <linux-raid@archiver.kernel.org>; Tue, 29 Sep 2020 14:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=intel.onmicrosoft.com header.i=@intel.onmicrosoft.com header.b="UifJfvNs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbgI2Oey (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Sep 2020 10:34:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:46897 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729299AbgI2Oey (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 29 Sep 2020 10:34:54 -0400
IronPort-SDR: VX6h7qwfCiNFlR9CpNmtJPGe0WKDVu05DSvfi83pCFm8bkwfs9iJiAeyGqm9RAYtUSSOps1quu
 mE2FkfAJnK0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="180358931"
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="180358931"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 07:34:29 -0700
IronPort-SDR: /U3+mxX2vzSGuidG8UL/dGER+Tqx8ZLTNXsTDgpiEzcbN/Vd2IJWwsuew/S40Q/eNhko8PT/Ij
 gPzskQ2C1IaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,318,1596524400"; 
   d="scan'208";a="307782765"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 29 Sep 2020 07:34:29 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 29 Sep 2020 07:34:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 29 Sep 2020 07:34:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 29 Sep 2020 07:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdZEqVqFuau5LmSo4MU9tx1U1CN7a4O6y/UYIzn15FALRqKyDs8vWAzSuSOCDZIa7tZtSgQktJrFIFVoZ4yI2GhkvOyClGJ/r89K8m8xlkKmdE+WUaskb8qzIdTAPmkBdosXNZxpuFZ6GZ7K5fdUZd59jyWDjB6SaLINxz5uLkvrwse+IAhdZKYKoOdTetAAw/i+tmI/cE/7xrqBGhUCXIaZ6KGqcqZm49eZz7v/an0OP8fD5+9NNN7spj+FH6P/Mo/v/uvGlwfnIM3YRLkNDtdFrQEfCEOkCdkA1Sabu1pr9sNNcS9p4oRDagb80ZcralNYmqhc81LbV3Gpce70YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NK8CHAzFhUHirioW8QMN6Tu9XIiMa7PO2kupBF2BzQw=;
 b=aMAe2AqKMFeGi7F+MT2LoWVeoUW4cp0eIJm8cunT7cN+kWgD5hbjRqgMC1bv7Tqa/P3K6aWXVYhdKnSTkCxmHRnnTT5zoDzC94UxKmd9jwuk8RnNxUXKHuy1K5jtojdCQRKydV/g4HuyBmm2pca6y0OdHN/NKUIhAcsFcjrdJe+R8oMYxy16eDQxWc3luD13/MawhzC2gnxU6OG9cJN1HEd+XPEGEx7Xcc2Yjpn5KpTG6xZ/mdpgmV66MfIqvpQf/xY1hlXBPb+ga+U8LY1NFX4DFLReYspcknV/Md6HmnMzsJxDBhkvSk6MrNrBq8yaaFMky6342zLM/31yf1EPmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NK8CHAzFhUHirioW8QMN6Tu9XIiMa7PO2kupBF2BzQw=;
 b=UifJfvNsdSIpUzN1Tpk4FhRwNdD0/4SOIu2Tcp/nHr03Mj8R7rvplGTVd5KosgUsRo6n7xaLY0yeJuARZ5ZFFOmEuFjFkqZunXmy0OBlTozk/VBrMYlHZupg7pxJmsYfHwDTFeWoSi9HrbuhhvixaPUwVISg2wuZEcfTxr194kA=
Received: from SA0PR11MB4542.namprd11.prod.outlook.com (2603:10b6:806:9f::20)
 by SN6PR11MB2799.namprd11.prod.outlook.com (2603:10b6:805:64::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 14:34:26 +0000
Received: from SA0PR11MB4542.namprd11.prod.outlook.com
 ([fe80::98d7:7b2a:6e98:3cdf]) by SA0PR11MB4542.namprd11.prod.outlook.com
 ([fe80::98d7:7b2a:6e98:3cdf%9]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 14:34:26 +0000
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>
To:     "jes@trained-monkey.org" <jes@trained-monkey.org>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: RE: [PATCH 0/4] mdmonitor improvements
Thread-Topic: [PATCH 0/4] mdmonitor improvements
Thread-Index: AQHWhoPDrcGM0tp4IESZC+DnHxGLcal/zQRw
Date:   Tue, 29 Sep 2020 14:34:26 +0000
Message-ID: <SA0PR11MB454223C46AAB3F629BEEC22CFF320@SA0PR11MB4542.namprd11.prod.outlook.com>
References: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
In-Reply-To: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
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
x-originating-ip: [89.64.90.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 457de42f-01d7-47df-299d-08d86484c42b
x-ms-traffictypediagnostic: SN6PR11MB2799:
x-microsoft-antispam-prvs: <SN6PR11MB27991737DD61A2EC03A3E9D1FF320@SN6PR11MB2799.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jDOdPVoda1LyOfU148todVvw9ZiHGISEBlvmga1Re+lpVs2tnldrnYqow1Yw+u7CoKPsYRXhi+CpNU5d+FcBrNWjhX++rDBTRu69rHD4AfoHeXn7GQ8mAdaym+/DXwrT15nJIkHQwOYvuovVmmXgNFYzStVw5BYGtKI4GHjA3SMG0WRxdJnjsceruVy6IZkxIcrPeNsiDPXUeDM2eBFLNKzsbAhgIHs/p7AueVhfFVH6xde31486mwBjuOzKMYpIXBzSfDvjohwgleG9z4GxgNw+CqlArUbFukXYH/NPjdSrpdodRdfmtrqDxgRtM7++Hic0akhXguULR3M2eyjfxbH5hxrIKA+dOkfV2F5QiypWyRWNNZkwIa55oA6FHSuz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR11MB4542.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(52536014)(6916009)(478600001)(7696005)(6506007)(83380400001)(33656002)(53546011)(4326008)(9686003)(316002)(86362001)(186003)(26005)(55016002)(66946007)(66446008)(64756008)(66556008)(66476007)(76116006)(8936002)(8676002)(2906002)(71200400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1O9hCMyeV+ygpOqZArSSqm+U5Z8YyJEGhYFlmMq1SeQbVbxu2eXXLth6zvnGjtvWcgK/nmOyoQUozxsYi9FzRk/OBTEqBjUGTTwHcTwiHthu++7qUfJm7NAJE3GX8G6ndKF6EZpP/J20lLAfSmT4T8z79eUa4Fvjcbxg4I02HovgoWhewbKECb1dkR6dIR7GHjEr6gbbq4RG2HCYjJgMlA/mFYwVslaxiAkvX05DjVJOwj9tS8FZAAqcK7z6Lu+E7euo7Sz8CdBIt4mnivgvAv/HUyCtn+5k2mJcCDzBmJsMI8YDYZeEFYFbHJDx0bWBEYwPv2wQWAzSig3jiHioK09e4a+PbvTz3Dalp+II5uBN6WbCkmzHwBouF5keLyDoMKYD1WB5VkCFMu7HpuMqF3Aj23p6PuIb2w3gBGuGl2ami7NDwhp32KoNMvtW7NbrNXTp3uZP6qbH5wAW0fyxcCZPCrYoFojVvVURTMbCNoL96Lch79OfmSV+kx3zVEpL4NtZVRkbKjbVWBbE9tf5UvFNQ7O4mMDlmk7qOmGgYkA9c4w4BJ2bf+NcuGtJDZxoTjLjxwh6R5ZC2NpMF7zvHxi7pNxKrZ5m+0IWDYDRrtOIHexWLvqMBhRSfoHPAFW/VlXJSTp9b4SvhH+clfpxrQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR11MB4542.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 457de42f-01d7-47df-299d-08d86484c42b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 14:34:26.1214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fUB6MeXyCUmFqpwiPbkn5GX3GsGw+etNaAeRPuBGpnwQ4zOyJrCZBaRm55fkVp0MY6pRCWbUQULStDQY+NlZCtQpZeEZxGHQ4Iezl04ftLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2799
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

SGkgSmVzLA0KRG8geW91IHJlY2VpdmUgd2hvbGUgcGF0Y2hzZXQ/DQpJZiBub3QgbGV0IG1lIGtu
b3cuIEkgd2lsbCBzZW5kIGl0IGFnYWluLg0KSSBkb24ndCBrbm93IHdoeSB0d28gcGF0Y2hlcyB3
ZXJlIGxvc3QsIEkgY2Fubm90IGZpbmQgdGhlbSBhbnl3aGVyZSBvbiBsaW51eC1yYWlkLg0KDQpU
aGFua3MsDQpNYXJpdXN6DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBsaW51
eC1yYWlkLW93bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgtcmFpZC1vd25lckB2Z2VyLmtlcm5l
bC5vcmc+IE9uIEJlaGFsZiBPZiBNYXJpdXN6IFRrYWN6eWsNClNlbnQ6IFdlZG5lc2RheSwgU2Vw
dGVtYmVyIDksIDIwMjAgMTA6MzEgQU0NClRvOiBqZXNAdHJhaW5lZC1tb25rZXkub3JnDQpDYzog
bGludXgtcmFpZEB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFtQQVRDSCAwLzRdIG1kbW9uaXRv
ciBpbXByb3ZlbWVudHMNCg0KVGhpcyBwYXRjaHNldCBpcyB0YXJnZXRpbmcgaXNzdWVzIG9ic2Vy
dmVkIGFjcm9zcyBkaXN0cmlidXRpb25zOg0KLSBwb2xsaW5nIG9uIGEgd3JvbmcgcmVzb3VyY2Ug
d2hlbiBtZHN0YXQgaXMgZW1wdHkNCi0gZXZlbnRpbmcgZm9yIGV4dGVybmFsIGNvbnRhaW5lcnMN
Ci0gZGVhbGluZyB3aXRoIHVkZXYgYW5kIG1kYWRtDQotIHF1aWV0IGZhaWwgaWYgb3RoZXIgaW5z
dGFuY2UgaXMgcnVubmluZw0KDQpNZG1vbml0b3IgaXMgc3RhcnRlZCBhdXRvbWl0aWNhbGx5IGlm
IG5lZWRlZCBieSB1ZGV2LiBUaGlzIHBhdGNoc2V0IGludHJvZHVjZXMgbWRtb25pdG9yIHN0b3Bp
bmcgaWYgbm8gcmVkdW5kYW50IGFycmF5IHByZXNlbnRzLg0KDQpCbGF6ZWogS3VjbWFuICgyKToN
CiAgbWRtb25pdG9yOiBzZXQgc21hbGwgZGVsYXkgb25jZQ0KICBDaGVjayBpZiBvdGhlciBNb25p
dG9yIGluc3RhbmNlIHJ1bm5pbmcgYmVmb3JlIGZvcmsuDQoNCk1hcml1c3ogVGthY3p5ayAoMik6
DQogIE1vbml0b3I6IHJlZnJlc2ggbWRzdGF0IGZkIGFmdGVyIHNlbGVjdA0KICBNb25pdG9yOiBz
dG9wIG5vdGlmaW5nIGFib3V0IGNvbnRhaW5lcnMuDQoNCiBNb25pdG9yLmMgfCA4MyArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tDQogbWRhZG0u
aCAgIHwgIDIgKy0NCiBtZHN0YXQuYyAgfCAyMCArKysrKysrKysrKy0tLQ0KIDMgZmlsZXMgY2hh
bmdlZCwgNzcgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25zKC0pDQoNCi0tDQoyLjI1LjANCg0K

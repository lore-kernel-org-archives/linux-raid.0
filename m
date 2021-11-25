Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3560AC4332F
	for <linux-raid@archiver.kernel.org>; Thu, 25 Nov 2021 13:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350067AbhKYNL6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Nov 2021 08:11:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:34407 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351677AbhKYNKt (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 25 Nov 2021 08:10:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="259409589"
X-IronPort-AV: E=Sophos;i="5.87,263,1631602800"; 
   d="scan'208";a="259409589"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 05:04:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,263,1631602800"; 
   d="scan'208";a="510301124"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 25 Nov 2021 05:04:11 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 25 Nov 2021 05:04:11 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 25 Nov 2021 05:04:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 25 Nov 2021 05:04:10 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 25 Nov 2021 05:04:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiQNOZd52jZz6RzuzxQtKVwlo4l0NOPUBPhVelCZXd2HRQzf3EEWbY2KKqJAdpnOqoyD5qvKDtbcUmZAjCBZ2z/9BjrK2Lm08tM0a6FBtNmMub3Jq8xIdGLMGkP+NWfG9rx2r0vfYXwqrZcFopTf6bxDsyipdoy9mrPA++iOVLwPl6zbDruGTjvhSYtgjYa6JE5oV+Xr5VKMgnlIKfaIz2oqGlJA7SjXTw/QMPDn8iyTz17hYj85sm4FZuxrGjxFpyKyH02Mpuhr5eddogBFji3vte5hQn2wr/momDGlS/9VlC9Re12PEvq+0QfTKJD5P+HeF/PpOTlATQGxET9kQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6CAQCNQQExRh2QwE2jhZ63H3f+9wBN848e7YwT7PyHQ=;
 b=gWWOmU8GtLSft4DM2pp5I2UNt6cK+ltOVc8mC6EaIR2Bn7z46jDSsa7jb4DuGhEF0rfovsDbi3CIfNejrpbWN8UT66MuTbXO2LbGmk9El3ZUIoL6zoHJ20RTUQn1w08YcfGd4bOD5CTr30irkyrHrEh+ZLhpvPuJwINsNkxH2gEKF2ajILSi6oakmaA/8h+n+4Uid5m1G2BajAmKOLufKL5261jsB2hv5U8cIOQYwogjzv2lMvjPox5GDBasQOhkYv2b+jBwDo+T6o5D9tGabxJgwMziKuCrwD2dPJOwXzlcdeoixqBPt5C4vssZZU+CyORz7L+8rOfPf0wb50Ys1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CAQCNQQExRh2QwE2jhZ63H3f+9wBN848e7YwT7PyHQ=;
 b=nq8B8AgMqHVEMGHmZy2t+28bhXV9f3tlUOveC+P5y0ep6cBTfaMx+6CuHVrpPxh/Mt1qbZsHDvqDBTpE9SfBdk2GHf1MavZqLuMOqXYHQfrJHSrAsuZUR0kBFfgmOvc8zFNxJJUhHB42JeTII/28nMH+Ga8Sil4zq/3IR1dyYVY=
Received: from BN9PR11MB5339.namprd11.prod.outlook.com (2603:10b6:408:118::22)
 by BN6PR11MB1987.namprd11.prod.outlook.com (2603:10b6:404:4a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Thu, 25 Nov
 2021 13:04:10 +0000
Received: from BN9PR11MB5339.namprd11.prod.outlook.com
 ([fe80::64f5:a8a2:d46e:b1b1]) by BN9PR11MB5339.namprd11.prod.outlook.com
 ([fe80::64f5:a8a2:d46e:b1b1%3]) with mapi id 15.20.4713.025; Thu, 25 Nov 2021
 13:04:09 +0000
From:   "Grzonka, Mateusz" <mateusz.grzonka@intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Subject: RE: [PATCH v2] Incremental: Fix possible memory and resource leaks
Thread-Topic: [PATCH v2] Incremental: Fix possible memory and resource leaks
Thread-Index: AQHX4Sz/kTDmWviX+kKa4oyZn8NCg6wSq5sAgAAzAgCAAURSEA==
Date:   Thu, 25 Nov 2021 13:04:09 +0000
Message-ID: <BN9PR11MB5339A4F4E6C52FF7C4646084E4629@BN9PR11MB5339.namprd11.prod.outlook.com>
References: <20211124115819.7568-1-mateusz.grzonka@intel.com>
 <16c18e54-fb84-7b97-1aa7-f31979b87a9e@trained-monkey.org>
 <16d735b4-3ac9-44d9-af83-9f664c187cf0@linux.intel.com>
 <a0e7a55f-ffab-f74e-c09c-0c13e4f7fb60@trained-monkey.org>
In-Reply-To: <a0e7a55f-ffab-f74e-c09c-0c13e4f7fb60@trained-monkey.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56eb148b-f1eb-40b7-f1a1-08d9b0141222
x-ms-traffictypediagnostic: BN6PR11MB1987:
x-microsoft-antispam-prvs: <BN6PR11MB19876855752C447DC4C19AA9E4629@BN6PR11MB1987.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Z2ibKSphKnJaXJQXDzDfJ+JCuqHNyaKkWDeVTZULtNugoJcpkXvPPolnuCdZmWtZtZB9P17UADTLp3E3rlD/3IgRdA1JgzT92DaTK/HYlEutO2UXFwz/UJaCH6ktcA4hp7Bta8YfYGpjYYAyzXSa0pSmu8wdQ9yBsQ2kL5fIGYWlj1uRJQaianW7iDV5tKDwyT5UwdP86We+D3LViu7iLRMJYPgggx+QhEx5eRJdQQJ+yrv6NwHxqWoQcUbXwWPuawg7TFfxLD0srjCxFtxRDEJqn7XE8xiQB1Sbt8DZu6sSvUSqo3008uxdKDL7h5yhwUSEENSpPJpkmpZvgLODzKdzx3NWCJ34vmoPJbQ7i+DMWCE5G8bh5IMz/7w1u2G2s2uhp/UlTLqaMPfmXifqmMwyMP9E2z1vLmdh1y+b2rJklxGx4B5Jsznmm3+xc/uk8O5SqnU0onoDi827mZCxYqsuESeL1Zv/WvKIPfcp19IFXKSK8hM8/E9l83He9JoDgS8N8Dauuvv+50ZOZ2h8JfxAPCqwyM6Vf2LO8E/s6DQ5DdGWFPjiFIEVOdYsDqzB0hRZ2IvTdwSbwuqlBjf7LspwbHDG1otDjY0QtJ+zJuhNKZX4cnUtaGpYET35g+1PAQ15cvj1CMMqiKqDPgYJYbZrDbB3vhVkT49fN+1eysgsc1BapVpgwLB1L+tpCfYPXSk/XopVx6vvSpnu6cMVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5339.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(4326008)(2906002)(66446008)(66476007)(508600001)(66946007)(66556008)(316002)(38070700005)(83380400001)(82960400001)(64756008)(38100700002)(122000001)(33656002)(26005)(8936002)(86362001)(8676002)(76116006)(52536014)(186003)(71200400001)(6506007)(53546011)(9686003)(110136005)(7696005)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDRZT003c3h0L1JrSWhqaGpRSHlaYUh0SlNNK1NUcEptTnBVV1h5R1FEM0da?=
 =?utf-8?B?b0JRZEhnc0hWd25LQzVQcEZUcDhXZTdVMzRHRk8wZEtTZUlsSXZPUmxXQlJn?=
 =?utf-8?B?SDJnaXM5TjRrRW0waGoybGRxdXVyV2FZU1l6emR4MUJwR3htUVRadFhiUVBm?=
 =?utf-8?B?MzBXRlVlSlFKY05XenBQQ0s5ZkZRTlJ5Vjg4TE9TWTYrTSsvZzVZSGQ5a25w?=
 =?utf-8?B?cUNCQ2pFcUZ4SFpiSSt0M2FJRVJ3eFJzRDJQRVU5anAwR09VdHp1ckFnY3U5?=
 =?utf-8?B?M0FubjdjbmtiZEdxUnVtbmxEY3ozbzNwREFoVlc3amZjd3dlcWxhRUJKZWt1?=
 =?utf-8?B?OTkwVWR6L09jSXdNdVlIWXdwcUxlWlFNMmErdUNQVFdEdU9Ja3JkbDVQRlR0?=
 =?utf-8?B?U1hWYUFQdzczeXdrbmFRUTBnNHV1VXlqWlc3Y3JldGFJYk55YUhuK0dRWGo0?=
 =?utf-8?B?ek9uZDZNV2g0MXl0dGNSdFdhaDVNQ0R3TUZQdHU2eFFsWG9mWjNlY3dTRktu?=
 =?utf-8?B?RGg3dFlLSHgwVjZhUFJlaDZnZkt6eDNTc0ZuR2g5b0hZcE5zYUN0dWdSeTdD?=
 =?utf-8?B?NXFXWUplN3UycFpsb1BqdDg0SUZjQVA2YW5vMytjdzFRUkdUTmJaM1F5K3dH?=
 =?utf-8?B?a2k5U1RHc2NIQ0YxL0hQV1h0QjVFa1RVTWYvbzdyMzBwckxJYmFFU2IvcDJM?=
 =?utf-8?B?ckdOMGorcFp3VVRXZWNXMmlCangrV3k4bzlrR25ZcCtIcmxQMGI4YWZwMk9F?=
 =?utf-8?B?bmQ0N1BMUTZqVjlGbnI4NjBrR21YUEZ5bEl1MDgyS2ZtN2F2d3ZQdVhXRUVl?=
 =?utf-8?B?SlNFOHRuRWZxSGFxcVJGekc0d3YyZ1dqa0VMQkp5ck5jUERxZ29HSW1FdDVB?=
 =?utf-8?B?T25lYTcyNjJEWUc3MVJnVmhSd1NQVWJnbDEzMWhQeGdnSzF5RjJ1OTJuMFBs?=
 =?utf-8?B?Um9ubTZRRk5wbWFMeG9HUEhXcTAvaWVPUkM2ZWRUQ3ZYeHNWVlY1Q0Q1R3Er?=
 =?utf-8?B?Z1NtVTZ3R2kzMlhZMk1icU0yYXlVeWpvTDExT3MwUWlCa3J6QVZRNWNMVTVK?=
 =?utf-8?B?cG1LY2VWRFhQbVNQRkszaGNyamhhOGJMbkhybXE5M25wbWVWL1h5eGYxQllq?=
 =?utf-8?B?TXQ5Q1RnelhRNWdXamxvUzZPU3F4M2hmR3ZPL000d2tHZXpyUG01SVpRdVhv?=
 =?utf-8?B?MTZaMmRwZk9aWFAydWFtTTZoc05SbWdEQk55MkM3ZUNINmE1Sm91dkpyenkv?=
 =?utf-8?B?clFXRkZiY3ZGSDVOaGxLckVTSEpKb1ZiMkxIVndMa25yV3JRY2dPYmo2NDd1?=
 =?utf-8?B?MTljcjloRW5pNUFITTY5Y2wyMStoYWpTazF6TVE2T2RTOGJ0Mk1LbWJYUzUy?=
 =?utf-8?B?ei9ZUStuNWFqYWNnYmsxSVlJcmJjRk94bTV3Mm5SOHI2K3FKMHJYQ1I2MGtP?=
 =?utf-8?B?U3lyUTBMLzB3cjI2Tm9UdmU5VmtQejhObUhPTmdwM1pOeEJJa2F1Q0R3OUpq?=
 =?utf-8?B?dUJDQ0RQSlFuQ1RBSlhHZzNvT20yWUFVSUtJa09iZjZMdHBVQmY4R3JTNDRt?=
 =?utf-8?B?K0RXZFRpRkkweGlQNy9zaG9pV3cveDByWnJlUGdHV2Y4SStBaEM1cHJzb2Rm?=
 =?utf-8?B?MFVBVW04K0tQZHFUVU5XQTBaT1cwYTkvMHhMY1ljV3NhbEFtTkNIMTExTVFT?=
 =?utf-8?B?c2xWUHIrTjF6Ym9Ha2hUVnNCSFhiamhVZWNqT2RpOW9sYlZkZUJuVmRRVVBE?=
 =?utf-8?B?bmhmYUcyeHlEYkNCQXBOb3JvdmFRNFpYbFhncWJMa2JtUFp5VmVSVDlBck5T?=
 =?utf-8?B?cWhTWEJvL3M1bkw2eENXMktqRktydGIxcy9EQ3UyRXFLc2VNUjV6bkNod2xq?=
 =?utf-8?B?RUJxVllSZHo0L0pmYVRaaXFCWE9PYUNBSDhJZFMrR1BpV2M2TENjZ2RGS0RD?=
 =?utf-8?B?bzlWczQ0U0thcDI2NTVseGROUWRUeE5Wc2VraE40QlIxaTVCYU9hL2NlOUxK?=
 =?utf-8?B?NmxLVTN4UlZrdG1BZGIrTmlRbmtXMVJkVjlDTXJjVG1HRWxRaEo3R1Evc0Ry?=
 =?utf-8?B?ZXUzNk94cTlYbUpPellndGpkY2hwTWFNYkhyWXNzelBxbVBFTk1uWHd5b0Qx?=
 =?utf-8?B?YjF1YUNxYzJaYnJsR0dqSzI4V1dteGpxNFMxZk9MaUZWWWIxOTQyM0NoTEdp?=
 =?utf-8?B?UENva2xJZFdnb2NaNk1oU2dldjV4Q0lLSDBYeEphUVFLTjk4TU5iUUlOcVhE?=
 =?utf-8?B?dU8rN1lUU2JocEkxakpVWXVmU3ZnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5339.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56eb148b-f1eb-40b7-f1a1-08d9b0141222
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 13:04:09.8704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUeP6epdtsJtylg6fDi0CwXfxHdwAWoc0M/FbdbYiTzEsPjZyzcS+8fii2aHAeJ2eV/vfmH75WpsikvxkRxM1LZXKCNuECK32ks+1DgTzR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1987
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

T24gMTEvMjQvMjEgNTozMCBQTSwgSmVzIFNvcmVuc2VuIHdyb3RlOg0KPk9uIDExLzI0LzIxIDg6
MjcgQU0sIFRrYWN6eWssIE1hcml1c3ogd3JvdGU6DQo+PiBPbiAyNC4xMS4yMDIxIDEzOjEzLCBK
ZXMgU29yZW5zZW4gd3JvdGU6DQo+Pj4gT24gMTEvMjQvMjEgNjo1OCBBTSwgTWF0ZXVzeiBHcnpv
bmthIHdyb3RlOg0KPj4+PiBtYXAgYWxsb2NhdGVkIHRocm91Z2ggbWFwX2J5X3V1aWQoKSBpcyBu
b3QgZnJlZWQgaWYgbWRmZCBpcyBpbnZhbGlkLg0KPj4+PiBJbiBhZGRpdGlvbiBtZGZkIGlzIG5v
dCBjbG9zZWQsIGFuZCBtZGluZm8gbGlzdCBpcyBub3QgZnJlZWQgdG9vLg0KPj4+Pg0KPj4+PiBT
aWduZWQtb2ZmLWJ5OiBNYXRldXN6IEdyem9ua2EgPG1hdGV1c3ouZ3J6b25rYUBpbnRlbC5jb20+
DQo+Pj4+IC0tLQ0KPj4+PiDCoCBJbmNyZW1lbnRhbC5jIHwgMzIgKysrKysrKysrKysrKysrKysr
KysrKystLS0tLS0tLS0NCj4+Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyks
IDkgZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBJIGFscmVhZHkgYXBwbGllZCB0aGUgcHJldmlvdXMg
dmVyc2lvbi4gQ291bGQgeW91IHBsZWFzZSBzZW5kIGFuIA0KPj4+IHVwZGF0ZWQgdmVyc2lvbiBv
biB0b3Agb2YgY3VycmVudCB0cmVlLg0KPj4+DQo+Pj4gVGhhbmtzLA0KPj4+IEplcw0KPj4+DQo+
PiANCj4+IEhpIEplcywNCj4+IEkgY2Fubm90IHNlZSBwcmV2aW91cyB2ZXJzaW9uIGluIG1kYWRt
IHRyZWUuDQo+PiBDb3VsZCB5b3UgdmVyaWZ5Pw0KPg0KPiBZb3UgbWF5IGhhdmUgYmVlbiB0b28g
cXVpY2sgYW5kIGl0IGhhZG4ndCBwcm9wYWdhdGVkIHlldC4gTWluZCB0cnlpbmcgb25lIG1vcmUg
dGltZT8NCj4NCj4gVGhhbmtzLA0KPiBKZXMNCg0KSGkgSmVzLA0KSSBzcGxpdCBwcmV2aW91cyAi
W1BBVENIXSBJbmNyZW1lbnRhbDogRml4IHBvc3NpYmxlIG1lbW9yeSBhbmQgcmVzb3VyY2UgbGVh
a3MiIGludG8gMyBzZXBhcmF0ZSBwYXRjaGVzIGFzIHN1Z2dlc3RlZC4NClR3byBvZiB0aGVtLCB0
aGF0IHdlcmUgY3JlYXRlZCBhcyBhIHJlc3VsdCBvZiBjdXR0aW5nIHRoaW5ncyBmcm9tICJbUEFU
Q0hdIEluY3JlbWVudGFsOiBGaXggcG9zc2libGUgbWVtb3J5IGFuZCByZXNvdXJjZSBsZWFrcyIs
IHdlcmUgbWVyZ2VkIHllc3RlcmRheS4NCkhvd2V2ZXIgdGhpcyBwYXRjaCAoYXMgd2VsbCBhcyBp
dHMgcHJldmlvdXMgdmVyc2lvbikgd2FzIG5vdC4gDQoNClJlZ2FyZHMsDQpNYXRldXN6DQo=

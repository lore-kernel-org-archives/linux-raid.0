Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFA2C4332F
	for <linux-raid@archiver.kernel.org>; Tue, 29 Nov 2022 18:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiK2SGH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Nov 2022 13:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiK2SFw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Nov 2022 13:05:52 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D9925A
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 10:05:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mi2brlN7nSWUiXtKmpItLudyB3Nog3iWKh2GtTVxSKXrPUuIJ+PIj7AHxDFveNsEY0aE/eWoefOaOAm//mk76AmF6YvlWFMgmq0eLWuVfxRSzww7MDQpsrkKQ+/3dhvxBIt+X4035jCPIOtajo0YlHH9f+d3iv9ejO/QE+3lM5oY0HVxzW6kVy6Dh3b5EkZMga7tiAzSagevc3mCpKCGtPvJRPG8xurhrA5Re97cy6/nBGCDt3oPiUitSebTiXHdoaly2nrxa5Xpsi2GyWRXjxeG+P6MBfifvAGxpa+YXebGtT7qjIX+cXclWikS6clLDCOgUeSGWgqdjvvlx18GRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ngdb3wFvysK7BOqRNIuODrTYk0I3SVK8qvIWQzJlcXM=;
 b=O9Q8oOlDm4hIwdfgKj3YrTAgOJhhmpimEeOFvGgbndUr22tbNXqb+tO1NSye49I13CnhqDbMGZ867RxIEFDvkK80uO497doXJjHLgPbQQ7v2bUJpfH3x55y2byxlq2C7UT6Z3ldLx6KXX5exdD17ZRCXf4wtLJRp6TtRjeMojeDWE5e8U7HhJkLRIFspwbtOn/il/HFvMgrj7PjdDgxJJrTEGR5Q4dsWFft9y2nGYL5UbNTcaIoq+Bwlksq/p2KiSJtbYykg7811lxXuCyeVWmIWD7FgyNr+htotVsd42vO4xZ7yDhChhcQ2Gnz7BXxgfCcyYM/uGAfAfJpMqIyFlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ngdb3wFvysK7BOqRNIuODrTYk0I3SVK8qvIWQzJlcXM=;
 b=PtvbyCNhPP+kGybmWf3SC6CH8EivzNmuM1UqIH8iKPeeyOpFyGoVv5oSIBAgDHDny8sDJ741c666m/yzVhLfXWHnQKLoAWxoFoV19Ftq7f3/uLZaAiGltWr1w1wgvcreFPunvIE932SfCgglhqoZKQhGnMhSuwB+37kgrjt4AZzYQcPU+18zydFobzqoUZJcJXecoF+2wQmDQ+dVMHP0oAoa28PIrXsvSO2hwzUogd+6fAiwGMrWWhmPX4XNejsqZegxZnlk4HkkUCKrNJD946aeRyh/FXH7RezTLLKgBudtVWN/Vnw8hHpbzExpnedzIHW3Vl2Qeu02ZZACAGjfFw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SA1PR12MB6728.namprd12.prod.outlook.com (2603:10b6:806:257::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Tue, 29 Nov
 2022 18:05:49 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::f02:bf13:2f64:43bc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::f02:bf13:2f64:43bc%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 18:05:49 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Logan Gunthorpe <logang@deltatee.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>
CC:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v5 0/7] Write Zeroes option for Creating Arrays
Thread-Topic: [PATCH mdadm v5 0/7] Write Zeroes option for Creating Arrays
Thread-Index: AQHY+hWyjyBbDE1lLk2w1qqzFM9Hca5WRkCA
Date:   Tue, 29 Nov 2022 18:05:49 +0000
Message-ID: <e5ed682b-3a69-7272-a8e5-e7f27ca08f6a@nvidia.com>
References: <20221116234617.79441-1-logang@deltatee.com>
 <20221116234617.79441-3-logang@deltatee.com>
In-Reply-To: <20221116234617.79441-3-logang@deltatee.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SA1PR12MB6728:EE_
x-ms-office365-filtering-correlation-id: c1f0fac4-2ecd-47df-4397-08dad23458da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vqzvTE4iZ9yCjICpQy2aGxaoVtWieCbHbNzqskjvP87+VreZ7Y6u1WVPlBrRxbc1AyfXbY4rYKzz/LEn3k1f1DaPLRGW3llsiswnKFA9Kx2fIs39ZynfOUYcvBZlB+HGVio8sa3l6FGQ29VkoFl/U2BZER0NsEowYptcuT+KlEeivTYB9T1xWTWrC4/ZypO9xzZ1muaaIfzWLP720O/234VIHsBVR3yLQxiZohYvvBjSzPqZviIrE3eW1wyjRpQHH7o9c7R/JZNsnYXB6VLnv1teb8ugfXnwbRKn1i+3aZiEtFrcQM6iMIFdopFRXWBK7DJWvvj1waajdCY4OQr1Bv6Zom5D8EPZ5knDSIXOwN7dCtCCj8WcxVXv94XVyI1gaEBUhytDecwEI+NSfeX99K9hzusO3M1nXHPV52niTDfxzFMqSssLyYTTknUKwiUN77EyklgiQK/VOLNl8MpHg39ywBNe7IXHXVDdcbUckqEu7wdrQCHGEKWtDGnaFsjC/P64XKNFv7nI2S/pak8KHq5yfpOpcHd/ldIlbOSvu6A1WHKKTOytomq8gdKB1PZhweJSqWnm/KZHysJ7FxmHzgYJGusqJEVrFiL8gKakOF0KrlXRTKsI2JXCdjOie+spM3/yabKpdIo/mxSsJGJbzDrV/+J3H8s94PXhugSw7JCE9Ts3J6NOr62xUqUWfDM7SK+ilBeHjbd1mRAOs2qrfIW4N41DHP2zHfXMsHXamvzQroGsDbVEGhBUNbI91bTCjcMTgodxbtIffBEjbpzsBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199015)(83380400001)(2906002)(36756003)(2616005)(41300700001)(31696002)(186003)(7416002)(8936002)(5660300002)(86362001)(38100700002)(122000001)(38070700005)(31686004)(478600001)(54906003)(316002)(53546011)(6506007)(6512007)(110136005)(6486002)(71200400001)(66556008)(8676002)(66476007)(76116006)(91956017)(66446008)(64756008)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFZpcjVQczVuNTJjcysxZ1RjdTJDOUtkZ0d1WU5tUjR2bm8xVFdUTy9HTFE4?=
 =?utf-8?B?Z3dPNzlubVJIc3NORmFLOVp1UHpqMSt5dGVVVnV4RlplYTBaSmxDdVRyb3N0?=
 =?utf-8?B?TUExc2ZZdkRibEV4OVRrejc0UUhqNWNwYjF6UCs2UlVKNVlaTGNzZkhpdnJo?=
 =?utf-8?B?UzBuUnlNZzkxaEM3bkZ6ZnhEdE50cEFLRUM2SGcwMElsZXVIcUdFWXQ0elkw?=
 =?utf-8?B?ZW1KaGVKazJGSnl0VnV3ek9lUERxZXVwdCsvRXJ6V0ZhRlRVRVJ0Q1YwS2c3?=
 =?utf-8?B?RWxFZXhhL0IxMXZoR1ZnV3Q4T0Fib3VsdElGLzVQQVNaQ2twU2hxemNqY2Iy?=
 =?utf-8?B?eUxObG5BeXpnTEtidkhTRHFSdVNFejBuSFlZSTgrV01zN29QMWluRHJiY1kw?=
 =?utf-8?B?T1YwR041TzRVQmYzNklsdGduSjJ0SUhQRnhlVEFwYXo1d3lIYXlVS2pGSHhq?=
 =?utf-8?B?dkpodC85RVZRcVlsZ2dzSHdIWTlJem9YQUJLWklkUGJuL0JkcDlBTnVuYVB6?=
 =?utf-8?B?UGR0bG9xM1huTVM1Vm0wSzR2OU1PR1BiR09QNENuUytYQ0lIUGZqRzhJanJH?=
 =?utf-8?B?cVZGTVpmVUx1UkViNzVnaDFvMkoxandDdk4zTWlDK3JvTFhsT3lqK21KWGk5?=
 =?utf-8?B?RzFTcHBXRmd2RzZneFE2c00wdWlUbjVoSWVEYmwzU2IvL2hOTko5dUdGQ1Ru?=
 =?utf-8?B?bmd2QmMzbE4wbGFnWUFpQnRGRWFGOE0xajdQOWZOODkra1BUckpLdXZLMnZS?=
 =?utf-8?B?cFpVa213Q1NYVmhaQ1hsRFB3eFpUSDJ3blhBMEg5SXp0TmpxVVIwNlVTZkoy?=
 =?utf-8?B?NWhhU093MWlZZmpaRTVBT3dEM2xBdFAwUTZSTUg3V1o3WTlXTkd1cDJ4dC9Z?=
 =?utf-8?B?VlE0RXpsdkU5eDY5dEJ2Wnd2ejkxNUhjaDJJdlA5R0NRcitjRkdaUlB5U0hm?=
 =?utf-8?B?MXZoNE9wUXltSU5SK0lpanlTeHVLT0l0S3ljanVhdVFlVW04TUNvNVVpd3NZ?=
 =?utf-8?B?YVJGMzgvSVJwdGxIVmFKSEVLT1lqVXVRN1E3YkloUUY5Q1lJdlBHVVZOR3Rl?=
 =?utf-8?B?UmFrQ2trMllnT00vKzJpbDMvWlBvYTB1MzAreDljK2JoWTliYmtTVFNEeHpw?=
 =?utf-8?B?S3RwNklmcyt2RkRyeitKemhiNVpwNk0vT0VrQ2xWbDgvK1NVcHc3Yk1iZjRZ?=
 =?utf-8?B?WnZZeVBITkV0OHA0cWpyOExEcVhOcndxdW45RFc5UEN1WU8wTUxGVXFnS0Nn?=
 =?utf-8?B?MjA4d2hSVWgwN3ZTc2Urb1ZwRUNlZTVidGNmRzEvenVscTZxdDRLVTh0bWl6?=
 =?utf-8?B?YWVVS0QyRGM3TGU3NnRsRDdIcSsycmZUb1Axd2dMN0c2OGpXZTlaWFFXeWFU?=
 =?utf-8?B?dkRIYnVHQ2Z3UDFMSVdNbTUvRnpEZFVxK29PZ3FPY2N0di9ZNTUvZ0ZCdFhy?=
 =?utf-8?B?UXNlSXhxSXBhZCtXcCszQWFQdWFFZWF0TUNLb003VHNLd29SV0QrVlRGU3RS?=
 =?utf-8?B?dkRJSGo0VjhsK21ZS3dNa2hVSHc2OEVDeURPZFpXOXgyd0RDWWI4clZZTngw?=
 =?utf-8?B?bEhoVDdQYmh3b2dnUGYvaFRQdW5GYXh0Wi9ZSkFiaC9jdWlsMU05V3RidmJB?=
 =?utf-8?B?TlhTd081VnI1RDdpdTZxbFdYU2N2ekgwbzVURisySC9oS0VuK2JQU0RqRHZI?=
 =?utf-8?B?Mm9YZGFVekJlNDhMTVkyNWk0d0hXNW02T2txTmgxSVdSNi9rV0YxMFB1Nitq?=
 =?utf-8?B?M2NwczAyQXovRjVGTmw5S1BEbnVxRG5ZbkYxZmd1TzZXNG9MeWFqTTZaU0pQ?=
 =?utf-8?B?NUxtV2dwa3dRTWlmRDRDR29RUytqSFBYZzdqOVI5emJBMm1TRWJpUlpEKytN?=
 =?utf-8?B?eU11YTlhQU9OYm9pdUdQR21qRWRSOHMyMzNCbnBpeW9GV2FHdTM5d2UycUpt?=
 =?utf-8?B?Y2ZuMEpxMmlqRDJxL05xTEJjY2Y5NnRvRmRZc2REd05VdEJLRGtnM0dzTi9w?=
 =?utf-8?B?aVpDbmoxVEo0cG5oVDVtWXoyQ3RTcXEvWENqc2FFb3RHYkxZSDlZYzBwbGRZ?=
 =?utf-8?B?RHhSaytaeFkwTU5YOGNlY1M5bUJmbG8xbm9QZDYwNWdxNFFqMmF3a3MvdmNo?=
 =?utf-8?B?TUphTytPK2NKQUlwU0lqdUlkcDlNUVA3RGlxdXlwQWNLMWE2TmRDY0hId3lS?=
 =?utf-8?Q?SMZs5P9yEyPcRfnEb89ByYCUBiHczubFM35HUnt/42Jp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <57E1A1A7590C9048B16400DF4CAE5CEC@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f0fac4-2ecd-47df-4397-08dad23458da
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 18:05:49.6865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NPUCfcB2cEFfOjDNBmjzUa4vB90ZLOOyCPYVkI0XCpKAVF5y2FtSCjxHZMYOR9XUZCtTXVe52GQrNAUkTmAkRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6728
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

T24gMTEvMTYvMjIgMTU6NDYsIExvZ2FuIEd1bnRob3JwZSB3cm90ZToNCj4gSGksDQo+IA0KPiBU
aGlzIGlzIHRoZSBuZXh0IGl0ZXJhdGlvbiBvZiB0aGUgcGF0Y2hzZXQgdG8gYWRkIGEgemVyb2lu
ZyBvcHRpb24NCj4gd2hpY2ggYnlwYXNzZXMgdGhlIGluaXRhbCBzeW5jIGZvciBhcnJheXMuIFRo
aXMgdmVyc2lvbiBvZiB0aGUgcGF0Y2gNCj4gc2V0IGhhbmRsZXMgaW50ZXJydXB0cyBiZXR0ZXIg
Ynkgc3VibWl0dGluZyBzbWFsbGVyIHplcm8gY29tbWFuZHMNCj4gdG8gdGhlIGtlcm5lbCBpbiB0
aGUgemVyb2luZyB0aHJlYWRzIHNvIHRoZXkgY2FuIGJlIGludGVycnVwdGVkDQo+IGFuZCBlbnN1
cmluZyB0aGUgbWFpbiB0aHJlYWQgd2FpdHMgZm9yIHRoZSB6ZXJvaW5nIHRocmVhZHMgdG8NCj4g
ZmluaXNoICh3aXRoIGFuIGFwcHJvcHJpYXRlIG1lc3NhZ2UgcHJpbnRlZCB0byBpbmZvcm0gdGhl
IHVzZXIpLg0KPiANCj4gVGhpcyBwYXRjaCBzZXQgYWRkcyB0aGUgLS13cml0ZS16ZXJvZXMgb3B0
aW9uIHdoaWNoIHdpbGwgaW1wbHkNCj4gLS1hc3N1bWUtY2xlYW4gYW5kIHdyaXRlIHplcm9zIHRv
IHRoZSBkYXRhIHJlZ2lvbiBpbiBlYWNoIGRpc2sgYmVmb3JlDQo+IHN0YXJ0aW5nIHRoZSBhcnJh
eS4gVGhpcyBjYW4gdGFrZSBzb21lIHRpbWUgc28gZWFjaCBkaXNrIGlzIGRvbmUgaW4NCj4gcGFy
YWxsZWwgaW4gaXRzIG93biBmb3JrLiBUbyBtYWtlIHRoZSBmb3JraW5nIGNvZGUgZWFzaWVyIHRv
DQo+IHVuZGVyc3RhbmQgdGhpcyBwYXRjaCBzZXQgYWxzbyBzdGFydHMgd2l0aCBzb21lIGNsZWFu
dXAgb2YgdGhlDQo+IGV4aXN0aW5nIENyZWF0ZSBjb2RlLg0KPiANCj4gV2UgdGVzdGVkIHdyaXRl
LXplcm9lcyByZXF1ZXN0cyBvbiBhIG51bWJlciBvZiBtb2Rlcm4gbnZtZSBkcml2ZXMgb2YNCj4g
dmFyaW91cyBtYW51ZmFjdHVyZXJzIGFuZCBmb3VuZCBtb3N0IGFyZSBub3QgYXMgb3B0aW1pemVk
IGFzIHRoZQ0KPiBkaXNjYXJkIHBhdGguIEEgY291cGxlIGRyaXZlcyB0aGF0IHdlcmUgdGVzdGVk
IGRpZCBub3Qgc3VwcG9ydA0KPiB3cml0ZS16ZXJvZXMgYXQgYWxsIGJ1dCBzdGlsbCBwZXJmb3Jt
ZWQgc2ltaWxhcmx5IHdpdGggdGhlIGtlcm5lbA0KPiBmYWxsaW5nIGJhY2sgdG8gd3JpdGluZyB6
ZXJvIHBhZ2VzLiBUeXBpY2FsbHkgd2Ugc2VlIGl0IHRha2Ugb24gdGhlDQo+IG9yZGVyIG9mIG9u
ZSBtaW51dGUgcGVyIDEwMEdCIG9mIGRhdGEgemVyb2VkLg0KPiANCj4gT25lIHJlYXNvbiB3cml0
ZS16ZXJvZXMgaXMgc2xvd2VyIHRoYW4gZGlzY2FyZCBpcyB0aGF0IHRvZGF5J3MgTlZNZQ0KPiBk
ZXZpY2VzIG9ubHkgYWxsb3cgYWJvdXQgMk1CIHRvIGJlIHplcm9lZCBpbiBvbmUgY29tbWFuZCB3
aGVyZSBhcw0KPiB0aGUgZW50aXJlIGRyaXZlIGNhbiB0eXBpY2FsbHkgYmUgZGlzY2FyZGVkIGlu
IG9uZSBjb21tYW5kLiBQYXJ0bHksDQo+IHRoaXMgaXMgYSBsaW1pdGF0aW9uIG9mIHRoZSBzcGVj
IGFzIHRoZXJlIGFyZSBvbmx5IDE2IGJpdHMgYXZhbGFpYmxlDQo+IGluIHRoZSB3cml0ZS16ZXJv
cyBjb21tYW5kIHNpemUgYnV0IGRyaXZlcyBzdGlsbCBkb24ndCBtYXggdGhpcyBvdXQuDQo+IEhv
cGVmdWxseSwgaW4gdGhlIGZ1dHVyZSB0aGlzIHdpbGwgYWxsIGJlIG9wdGltaXplZCBhIGJpdCBt
b3JlDQo+IGFuZCB0aGlzIHdvcmsgd2lsbCBiZSBhYmxlIHRvIHRha2UgYWR2YW50YWdlIG9mIHRo
YXQuDQo+IA0KPiBMb2dhbg0KPiANCg0KQmFzZWQgb24gdGhlIGRpc2N1c3Npb24gYW5kIGV4cGxh
bmF0aW9uIGZyb20gTWFydGluIHVzaW5nDQp3cml0ZS16ZXJvZXMsIGxvb2tzIGdvb2QuDQoNClJl
dmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0K

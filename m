Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CFEC7EE23
	for <linux-raid@archiver.kernel.org>; Thu,  2 Mar 2023 02:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCBCzV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Mar 2023 21:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCBCzU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Mar 2023 21:55:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1CF4AFE6
        for <linux-raid@vger.kernel.org>; Wed,  1 Mar 2023 18:55:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ig3Cb8M3QLIuL/fHgyxOTCNFbkhRuM+LWuOSumwpULd8vylTUL5XdNAeW0MoCL3zdmAOUzfU4/8hmE/pDg81VAw6Np2FgJE0Wx2WdaM6oo9zoR3P2aTWnd+8WlDycVZfXQPgVGdC04ZoawIlFkVgYGxxvQA6t67Q4sMYAduoPqJi7wCOo1k6I2fTC9qMmy0UvSYj3KvUSLet633+RAuk+Qk0QyR2AvplvKPaY4EEK0y+1bct/zvGyqYGV9C7xYQn64QDEI2JQ+Z6h72vTpy6lldrlZWz2NuvT2oqAmC+SfClENxo7MeaWVfu0uAB6vJ07U80zcUW5Y0CFLTlxid93g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/sINtcvGT96UtmxlohgGpajBF1ZqTEGk9ekg2EwWCU=;
 b=Q8vCRIjCBSoiBFimrgHTyWVNVDx6a8fUj3IQSBl47gbGO3XggnxMncS/8ykj7Rsls2Rsb3oCZVXbHfG3TLMVPxENbjURmhTUs6ErV1zxd1HjcBQgfCCQ+XZaIuPsa2GINR3pOeSxSuBsp/BFJMxNLhtDovcJPL8oiWzy3aLyN3LbFKXAdKwGpWWt2W+uMEjRfucoB9SP7QVCKkD1Iq6jA+qYMJCy08UsDS7GsTsPOZBYM9SknAcuaHkZvV4zmEd6wLP1s21CHTq6JBueYaMYJMHXivBt9iYbivQrE7mpOrqmQMhQgo933c72/jRBR5S1yj++wChb8mxxy4Ri3/VISQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/sINtcvGT96UtmxlohgGpajBF1ZqTEGk9ekg2EwWCU=;
 b=HwW4K7xuRol3DoHCnkQKPYUkptTdaPK0YPguAjnCtkRgXBOok8XS4rBFaeofZY3xdZi1vNluIvVUlzJUZCNiZyOMi79MIl1ejMDSUoojN4AA8rt2YkRI/Xs/YQopcm0g6kSXGtVouEpjZW2cCU1Xmte3m3ONDgjpLflVp4S8g9xlorB3I4JduN6OnD19peRAIlAveJLyMyUhlmVvQk8gQZ9E1YrbwRe/AxwLjkpFZMrYYRO87RBqohgsMsT3D7ZGVNGFJjbfn0LyPWqpJo6I4YfxRvSQh6+Dp7d+Eyh54LCttkU08+C27s/U2QYdvf7Fc7WNSBXlh46sWF6sAXOLWQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7959.namprd12.prod.outlook.com (2603:10b6:510:282::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 02:55:08 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6134.026; Thu, 2 Mar 2023
 02:55:08 +0000
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
Subject: Re: [PATCH mdadm v7 0/7] Write Zeroes option for Creating Arrays
Thread-Topic: [PATCH mdadm v7 0/7] Write Zeroes option for Creating Arrays
Thread-Index: AQHZTH5CkDN5zbYSyUy+onHxdG1FZK7my9EA
Date:   Thu, 2 Mar 2023 02:55:08 +0000
Message-ID: <9e998cf6-cf3f-010e-4423-8a6ee2cca0f2@nvidia.com>
References: <20230301204135.39230-1-logang@deltatee.com>
In-Reply-To: <20230301204135.39230-1-logang@deltatee.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7959:EE_
x-ms-office365-filtering-correlation-id: e11601df-ade0-4dcd-5a38-08db1ac98885
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M4Z0VyQhw5Bm9OYS3g+zo4gvEkqaMPzW6pxPx80wJ/xuieRDpnYQ24+rGbwZnFKBSvFW/Ode+pcVQ1PrP5tECGxlRq3Xa8U0oVuI+uvwdDaOBm2+b5aGfyzw9WYIhE7UZLi6aQ75Sy+MOdry4QTC6qzlKHtC0ERLYlUFWbRPEubxM0SYkp5UtuwZ+gIJpdbROe83MRuw0cpna7/ZJ9FHZzQpYXdWgAx+LXfnTgqg8T2eQt1ms1+gunTN929Naf7T4333HANf5215jKyYUd4wNnTPIfpu8DE6Ra++abeZq443Rzn/yVogWhGDIBtoD+AqQcogiHsYt4nTUmQFYHWmbNq0ubPh+xCjcXS+x4rOdP784MQB+r60VTZgHqe51dfNlnuU9HtDi6OZlxmxg5McQVdYyccUn/+Prt6zr8PH228Ls3/YG6r1MmIZKBq8Rc+bZ1XeIRvcHM/YPzYOF1hhY7r6vYLlzp/BnfvdyoobTkvGaRR2sDCENub0q+a5ygmhxUV1ukG1gMEvRn+PE0/+HpW9N+DIKCkb/c1ZUyitS4NXJtbbATGND8dyDUDIPg5qm9yYGYRwdx6Dz6OONZuTq96zHJ57NX66m9eZmQLj2J+Di+qEZjx7cX2dCnXGiaO0Nw/Y9i4kVkN4LlN1uAIVUteit4FA7e6Gbs1c0Mh9vuE9lVaMuN/+oOdFxhzB58xZ/0IOwelIofvjmgmG4D6HKV1/NKoKv6WzBvPRbWIrnYCaR+kCI7mzP0n3pVQAoXXGFbLk/mC6HHHTFg9DpetX9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(122000001)(31686004)(8936002)(64756008)(66446008)(4326008)(66476007)(6512007)(8676002)(66556008)(38100700002)(41300700001)(53546011)(2616005)(38070700005)(7416002)(186003)(5660300002)(6486002)(110136005)(76116006)(54906003)(91956017)(71200400001)(31696002)(66946007)(6506007)(478600001)(86362001)(36756003)(316002)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2M3WVZuSXZ2bEt0TlFxeElWeXJRMDlDclNiNzRLN0o4RGFVb3hiYzNFOFZT?=
 =?utf-8?B?WTc1aGVEK01FRm5BTCsyVjBBbnpDVkw0S21EdkdBN09YRkhuSDUzcUVranJW?=
 =?utf-8?B?TmdCUHJ1ZEl4ZnJITGlyT2RxcCtnNUVJTG5DVGRBa2s1WHZTaUk3MUtXbGFW?=
 =?utf-8?B?OUJXdXNqYjY0VnhYcVl3NThzMm85NWxPY0pGcnU2bVFta0hvZ1ZCNllYSTZr?=
 =?utf-8?B?OTFDay9YRDZURkpuSGV2VDJzL3JGdnM5OGphU1BpMWkrSHZ6b29DRzdIV0My?=
 =?utf-8?B?WVlLbVl4cnp5OGxzWHhoVjZHbDJJWFQ5TWVmcFZweVF0ZUwwNWloT0JyOUsy?=
 =?utf-8?B?ZnlKT1MwSllwUFFudmtPU3Z1WVFneENuZXZuMy9NVmt1a3RxWkZ3b281bHQ0?=
 =?utf-8?B?MTgxalFXbm1ObnlmMWxLRkd0bk5DSU1jRkdXR2NtVXk0VE80Tnd0WVFyWjZi?=
 =?utf-8?B?N0cwLzNZZGlkeFZFRWp6dTV6a0I4RE5CYkhWVmdGUm1SUUdZcTNEeG9ZV0lx?=
 =?utf-8?B?N01KZjFyOENOeTVtWjB1eEpKNHoxZW03OE10Wk5JMXQvcURFL29kUWkvVTEy?=
 =?utf-8?B?YTRPL3c5ZG9Qd2lVYlFKbExoV2VwRmwxVmJBaVNVMldDbVZvNjI5UUxIeXl4?=
 =?utf-8?B?eVdYZmxra1FQdlJBU2c0WXgwWSs3dmNrTG0wYlRyblkvZnZ2SEJINkhXVkFR?=
 =?utf-8?B?ODkrOVJxWFVxa2NURC9jUjdwYnFGa3dTU2ZQYnVsREdnVFR4YlhiUGZzendU?=
 =?utf-8?B?aVpCZm52bTRlaVZwRi8yQTVsYmMzeVJlZGxJWlpBVzhSWGllVXRlcndRUFBH?=
 =?utf-8?B?MW5UcFRqTkI0bkUyelF2Qlp2dTdiaklmWGl4RWxtMkNqMG54ZDlIa1RGekMw?=
 =?utf-8?B?bGxuSTlIcXJQWUZZSDN6VTJNeXZ2cVh5K0pSWk12UmlBNnErNmNhZU5qM1Fp?=
 =?utf-8?B?VzNzUWRGWk82NElHY2pIWVFHQkxZSWZyK2lZc3FSZ0orUHRCblNJZHNPb0c5?=
 =?utf-8?B?SHk2M3VMdWVPZnhiTU80NmYrWlNpd1NqUW4xUzRHcVFUTmIvdXdubk9idUl2?=
 =?utf-8?B?WDNaMGF3Y3FXckt4UmtYUi9rV1V3QXV2RThBSkJqREtyTDN1UktXY0FTaXph?=
 =?utf-8?B?YjJLR2EzT1ZQRE1ta0pEZlhuUkVmcUpwRXFIUWtVK1hLQWloWmVOc3JqbzBC?=
 =?utf-8?B?OUFMd05JMnJGclBSQnhvemdhaldraGRiM1VjeWpQZHhMQ2FYTGl4MGc0YjNm?=
 =?utf-8?B?NVBzNlR0dmV6bm16M2ZXTnhkU0Y1RE1vM3BOZng0OXF6d25DZ3J3cDFLeVVz?=
 =?utf-8?B?MUt1eUcwVU56aCswNXZjYUlnRjFjS3VpVklqb2R1ZTk4SGtXQ1ZzQXhtOGh3?=
 =?utf-8?B?Ulh0dnVLTzd0RmdzUXF2UldIY0ZYbXE4NENDWjgwd3NtSU9IRUpjZW9UVEcr?=
 =?utf-8?B?QkFhRDI3c1AralRzUzh4czh6SDkyRFBJcGFWMXFxZXJKWFVyNEJTY0lveTY0?=
 =?utf-8?B?ekV0UEt3YnF1TGpvR004NEZpQmN4QjBzVjVkNWsyWjhvT1hKaUJnbmhGeWtS?=
 =?utf-8?B?REMvYUNUYmtSVUdsaEZOTUpOVU9QY2ZwdGU4MDNxM1hGYlRTMllJVWovUmFG?=
 =?utf-8?B?b0IvNEZkMTZ4ejVoV2pWV25HNDZXL3R6VW56b0NxM2ZydHhXRUNKdlo3dFVU?=
 =?utf-8?B?bkU4RkE3MDhubnpmeFZIbmZqSTNHNUVZaFZLSWtQYUtaT0gzY2F1SENLTXlM?=
 =?utf-8?B?TUF1N25XQ051RkRYR3J2eDhJQVBuU2w3ZnllZVczWFlzUGxCTGlxdHB6cGtz?=
 =?utf-8?B?UFNGL2NXMkdaeXAvbmJhcTk0Q0xwUm9UQUl0TkpxVUtLNmxOYXpDVmxRakFJ?=
 =?utf-8?B?aUhmWXNkMm40M2hXU3NDWkMyQ2tDdEV1MkwwSHNJd1h1MlhTaElEaWtBbUxF?=
 =?utf-8?B?L1hSaDc3aDNhK3NYcUpncm5TR0pXa2lGNzNPSDBRQW5nRUllNlhzVitvZGgy?=
 =?utf-8?B?VDBZVmk1L21lNGlUVjIrekRkUWh0bmVSZkJpdzdVMk1oUmVVN3RKajBDREZk?=
 =?utf-8?B?OW1aK1Iyc0J6UHhOZ2NEbnpSeFcyOWUxbFVKZVpndk1neVJ1YWxIMGJubk5y?=
 =?utf-8?B?ZUdEdkI1ZUlPNlhQRVZMcHNKNXY5a3pucXV4dCszWDEwZE1qN0toNE1UdzNT?=
 =?utf-8?Q?Ujw3a1lvgnj2o2LKebzVlmHHi88xWyakUdLUe3f7+oyP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <250B42DC90A6A74EB01D10CA4B37AD0F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e11601df-ade0-4dcd-5a38-08db1ac98885
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 02:55:08.3934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bBG1TywZWzFOIlxIsd+2WeFtc0QgTlvDjMW9OQ7sc41emWYQu4XjF0x7iT4Eg5v2YzuH9W6SR7mdvLpy6rC8pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7959
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

T24gMy8xLzIwMjMgMTI6NDEgUE0sIExvZ2FuIEd1bnRob3JwZSB3cm90ZToNCj4gSGksDQo+IA0K
PiBUaGlzIGlzIHRoZSBuZXh0IGl0ZXJhdGlvbiBvZiB0aGUgcGF0Y2hzZXQgdG8gYWRkIGEgemVy
b2luZyBvcHRpb24NCj4gd2hpY2ggYnlwYXNzZXMgdGhlIGluaXRhbCBzeW5jIGZvciBhcnJheXMu
IFRoaXMgdmVyc2lvbiBvZiB0aGUgcGF0Y2gNCj4gaGFzIHNvbWUgbWlub3IgY2xlYW51cCBhbmQg
Y29sbGVjdGVkIGEgbnVtYmVyIG9mIHJldmlldyBhbmQgYWNrIHRhZ3MuDQo+IA0KPiBUaGlzIHBh
dGNoIHNldCBhZGRzIHRoZSAtLXdyaXRlLXplcm9lcyBvcHRpb24gd2hpY2ggd2lsbCBpbXBseQ0K
PiAtLWFzc3VtZS1jbGVhbiBhbmQgd3JpdGUgemVyb3MgdG8gdGhlIGRhdGEgcmVnaW9uIGluIGVh
Y2ggZGlzayBiZWZvcmUNCj4gc3RhcnRpbmcgdGhlIGFycmF5LiBUaGlzIGNhbiB0YWtlIHNvbWUg
dGltZSBzbyBlYWNoIGRpc2sgaXMgZG9uZSBpbg0KPiBwYXJhbGxlbCBpbiBpdHMgb3duIGZvcmsu
IFRvIG1ha2UgdGhlIGZvcmtpbmcgY29kZSBlYXNpZXIgdG8NCj4gdW5kZXJzdGFuZCB0aGlzIHBh
dGNoIHNldCBhbHNvIHN0YXJ0cyB3aXRoIHNvbWUgY2xlYW51cCBvZiB0aGUNCj4gZXhpc3Rpbmcg
Q3JlYXRlIGNvZGUuDQo+IA0KPiBXZSB0ZXN0ZWQgd3JpdGUtemVyb2VzIHJlcXVlc3RzIG9uIGEg
bnVtYmVyIG9mIG1vZGVybiBudm1lIGRyaXZlcyBvZg0KPiB2YXJpb3VzIG1hbnVmYWN0dXJlcnMg
YW5kIGZvdW5kIG1vc3QgYXJlIG5vdCBhcyBvcHRpbWl6ZWQgYXMgdGhlDQo+IGRpc2NhcmQgcGF0
aC4gQSBjb3VwbGUgZHJpdmVzIHRoYXQgd2VyZSB0ZXN0ZWQgZGlkIG5vdCBzdXBwb3J0DQo+IHdy
aXRlLXplcm9lcyBhdCBhbGwgYnV0IHN0aWxsIHBlcmZvcm1lZCBzaW1pbGFybHkgd2l0aCB0aGUg
a2VybmVsDQo+IGZhbGxpbmcgYmFjayB0byB3cml0aW5nIHplcm8gcGFnZXMuIFR5cGljYWxseSB3
ZSBzZWUgaXQgdGFrZSBvbiB0aGUNCj4gb3JkZXIgb2Ygb25lIG1pbnV0ZSBwZXIgMTAwR0Igb2Yg
ZGF0YSB6ZXJvZWQuDQo+IA0KPiBPbmUgcmVhc29uIHdyaXRlLXplcm9lcyBpcyBzbG93ZXIgdGhh
biBkaXNjYXJkIGlzIHRoYXQgdG9kYXkncyBOVk1lDQo+IGRldmljZXMgb25seSBhbGxvdyBhYm91
dCAyTUIgdG8gYmUgemVyb2VkIGluIG9uZSBjb21tYW5kIHdoZXJlIGFzDQo+IHRoZSBlbnRpcmUg
ZHJpdmUgY2FuIHR5cGljYWxseSBiZSBkaXNjYXJkZWQgaW4gb25lIGNvbW1hbmQuIFBhcnRseSwN
Cj4gdGhpcyBpcyBhIGxpbWl0YXRpb24gb2YgdGhlIHNwZWMgYXMgdGhlcmUgYXJlIG9ubHkgMTYg
Yml0cyBhdmFsYWlibGUNCg0KJ3MvYXZhbGFpYmxlL2F2YWlsYWJsZS9nJw0KDQo+IGluIHRoZSB3
cml0ZS16ZXJvcyBjb21tYW5kIHNpemUgYnV0IGRyaXZlcyBzdGlsbCBkb24ndCBtYXggdGhpcyBv
dXQuDQo+IEhvcGVmdWxseSwgaW4gdGhlIGZ1dHVyZSB0aGlzIHdpbGwgYWxsIGJlIG9wdGltaXpl
ZCBhIGJpdCBtb3JlDQo+IGFuZCB0aGlzIHdvcmsgd2lsbCBiZSBhYmxlIHRvIHRha2UgYWR2YW50
YWdlIG9mIHRoYXQuDQo+IA0KPiBMb2dhbg0KPiANCj4gLS0NCj4gDQo+DQoNCkJhc2VkIG9uIGVh
cmxpZXIgZGlzY3Vzc2lvbiBhbmQgZmVlZGJhY2sgZnJvbSBNYXJ0aW4gdGhpcw0Kd2hvbGUgc2Vy
aWVzIGxvb2tzIGdvb2QgdG8gbWUuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2Fybmkg
PGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=

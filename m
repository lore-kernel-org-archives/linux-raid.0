Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2882C7EE23
	for <linux-raid@archiver.kernel.org>; Thu,  2 Mar 2023 02:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCBCxe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Mar 2023 21:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCBCxd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Mar 2023 21:53:33 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E04330EB5
        for <linux-raid@vger.kernel.org>; Wed,  1 Mar 2023 18:53:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBKFeJYmVjf1U3y57Lf3R3lyhEFUlVOG/6HaYgpuKFp9HQ1Xuk0sCVRt0wvC4E0/XRbjmi0F7areVy/tXcihXGGOgr0UNUyQPHk4e+RixtQt81mNa5MQWdEp94ciJt7z5zlNLpVYfC0LVTvHbNKjhx7IiS27ShWMxbqrPn+lW43Vt9hSazTLRy/zzx8/HCbHtFzKFqY1+LZo1pFsgOnMyghqAcqlKXtHjGDAim/dDZgNUnKv/W9BAgwi7bpBpTH7tgYiu38ZUKVXcJgKJqyuvyZPTsh7Xy538mlc9GAlPzENUXs1poaPDCyI3nyEJMU/9GoAB5VfkRhyGKIiArHdTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pF+obm9ysmP1YiLMJfeZCjHzeB2C5KPEX/w3g2ONm0I=;
 b=TBgR5B+yHg1UX6j68BdFc5u9/wQXqXBuT/xGxwPXQlfgFhhjgeWDbGVK0lejB0Wgw4KmhCKLZqHnk3ExAPc19LsoKtpdUWzLZAlVH93k3KVDIfxo7gu9eUVA73pfSkQpco5gob/gIzxi1J6r+fXNAgOxRo49wm1+U6Lg6ywk5rAsoo7tRyF++hOWwmhC2Q5ca0nROT8CRLFUWVi67dUfwWtg2l2Pfg2kavQezEOssMulV2g+GuorwyCresqXQPbw7UtidR3wKUsNdBMgKQezarYojToUPQtKVc25SUQtUVEoOF++gvDM4FTiyMxLaJYJNgoZbf/Mc6yulevdFIPS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pF+obm9ysmP1YiLMJfeZCjHzeB2C5KPEX/w3g2ONm0I=;
 b=Zhtj0D0qzdUu06n5EmuYEL8UTNnxOeo5jsXnpezSAuOiJkETVqC3csSqrR4qUzMzN74rKigPg8pYtBKd8b71cn4tFqz+vO4oZ3vK7lhwiCCCrkaNhUB0Y5cOUGsoGyqBiU4HWX1Vqwmh8wDc+AFd3ffJkKA3zGwK7JtmHNczphFHJMJTQ5H4ksxB//U1aBhzvh8Rk2yjUzYxQzDW0mTFBhdtnszOolM7ZSAhW8lRkp/oMZS3m+f9Zh5FgaWP+2lNKx7uJKvX0bjnAZrWBmHa7dFp4/ahXANDOkzzf6f8B0cFqrnOUcphqKDoVWO9P7RML1RbexlKoB527kde49xJnQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7959.namprd12.prod.outlook.com (2603:10b6:510:282::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 02:53:29 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6134.026; Thu, 2 Mar 2023
 02:53:29 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Jonmichael Hands <jm@chia.net>,
        Logan Gunthorpe <logang@deltatee.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v7 0/7] Write Zeroes option for Creating Arrays
Thread-Topic: [PATCH mdadm v7 0/7] Write Zeroes option for Creating Arrays
Thread-Index: AQHZTH5CkDN5zbYSyUy+onHxdG1FZK7mpYAAgAAl24A=
Date:   Thu, 2 Mar 2023 02:53:28 +0000
Message-ID: <69b408c3-7357-ad43-e28d-dc25523a3682@nvidia.com>
References: <20230301204135.39230-1-logang@deltatee.com>
 <CABdXBAOAJAPmKC66WNnJSL5N72JZiM=AWBxhu_Yi1ojz3jn_Jg@mail.gmail.com>
In-Reply-To: <CABdXBAOAJAPmKC66WNnJSL5N72JZiM=AWBxhu_Yi1ojz3jn_Jg@mail.gmail.com>
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
x-ms-office365-filtering-correlation-id: 31716355-5eb7-4d4b-fba4-08db1ac94d51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wMs+64C5p5Y0zoaZ3RTK3mOl7BIaqbJAgEdwSC2nD1xrl3J0pF6T8S4pcNzFx7yxfUA7jBWYQAxbcyly/A0b5FIBKkC//Fm4Mrm2DwGlWKczTUAfDv9t+QoBRreZfPV6IEtiIMai2SvthrHpvbBULl91MGQvdkx4UEpI1vP9eIjsaItxAgis/3d2tROFDfS7GRXOaB6D7Vcql3aHgeUzLji4+BN9nld7qrDG9SUNUX7hNPQTpSRfRmxspsHOfPzqAAjyQbXpF+vnL7rIXa6PF75UANxUyElSXQrRIACYLuylGY5SXd3SW7snEZUSOjpC8gO6obDRjwGe72To79NCuHIWrwvVjW0tP0BZNXutX+/JPpCFDkogpe27hGcgfYUsVQa8JPyV1Jk2em8U4LrDaqfh5Dd4uu36HNtBvyBnqEDYEryUggXy+vxaPA4u1KYREnZbIhm91jj4Pu2CwTeNwbMxq30S1ha1Dq/3oO0KuqkoeSrUYFoQDVhgkpOLx8Ssnj8ZK8GkhBslzqKyWLqqbNAE3FWixs3u3J62/RJhXPEQgIjxoRaL4YGJ+ucDBEeBUr7blv4Xmz4Mjnsq9CegEHQRCUOivw+BTPJu7CPv9TtTVpboyayATL73XdwC3QXYb3w8U3jFN1zIUtbeBG8JPXE8riKeDE1xPGAqyJlVUvpwwdnHy6sxGTvYKeNrQ37xeKlmPeNuFmT5VIVS4zWnuxDaiKCHiMHu+rs8jv/2byFp3ABVidGD3z0iJNS/aYsS8hMH60xMMyBfZpRjKdJ23Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(122000001)(31686004)(66899018)(8936002)(64756008)(66446008)(4326008)(66476007)(6512007)(8676002)(66556008)(38100700002)(41300700001)(53546011)(66574015)(2616005)(38070700005)(7416002)(186003)(5660300002)(6486002)(110136005)(76116006)(54906003)(91956017)(71200400001)(31696002)(66946007)(6506007)(478600001)(86362001)(36756003)(316002)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c043L01Od2xYMU5FSjg2bTJ5cEI3cTkwbDNaZHIwa2JtNTFLTVUvVXluN0gz?=
 =?utf-8?B?TWhnL21DZklBSXo3WEVXa3RNUkhJaWtBSjVERTRyTWsweDJDVU5neFVqd0RL?=
 =?utf-8?B?YmFMOWtWUjBqNnhINmJPb0xuKzZIV1lxUXhqTVE1NHRoem9JL3VEVU1TN29Z?=
 =?utf-8?B?a081d2JVeGdyVEw2MGxoSHY4d0c5ei9GbldvV2dGNi90QWY0anpUbWp4UFVU?=
 =?utf-8?B?blBXN3hJQTI4MmwyOGdNUlV0YkRRTFpaMXpaY3BjUU1nVUVpbnlHNDhScVRi?=
 =?utf-8?B?S3JZbDgzVDg4ZDc1Rjh5aU1yUjg0ZXVZZTJiaUorOWd3enYwWTFWa2RrNkRD?=
 =?utf-8?B?RFpzNnZrWk5jY2JUUDhkUEJlcXJXZ0lHNGt4QmJ2NnRFVkZ0dHlid29KYmZL?=
 =?utf-8?B?M0pXMDZGVjcwN2JVem1mV2ZyMlhvanlqZFNHUCtYQitpWEFaQ09QUncwamdw?=
 =?utf-8?B?STVVUjFtUkhPQ0NIRHhyQzZZaUVUK2dWSnAvZjQ3cEhBN1NFekM4dG9nUnYv?=
 =?utf-8?B?WXpVNmUxVnJScmZ3elhCRzBmZ3RIUlJTNGNvTUFiTnFodEMvT3M5aE05L0Jy?=
 =?utf-8?B?TThWQURDQTBvZHVQNVpRVWhIbVFQZTFUSXpublJSb3RNYVJubVpLRW9aVGpH?=
 =?utf-8?B?MUNKd1FKMFQrTE5aWm1RcGk1YWRQbWhlSTQ0VDI0Y3QzTUZEdVIzdG1tQits?=
 =?utf-8?B?ejQwQmJwbjhjTXlSbEFmNHRDM2wrNnRMM0NOYWU1dlhFNnpsYXJ0SEZzNUNl?=
 =?utf-8?B?VjJNcllqSXdwN0Fwc2NsaWNacGlzamhrcG5ZZmFVeTBLbkdCZnFBanJycnRs?=
 =?utf-8?B?d3l2ajBESUVUK29MdzZIRXEzbTFSV2pwUGFCS2lEZmd0d04wVlozZ0wwMTFT?=
 =?utf-8?B?TWQ3RWtZekFzZDJCajBSNTJGU3gwdUJwaDZJSjF0UXllUFhucnFLdklTR1pl?=
 =?utf-8?B?dGJlRkJDT0EvWS9jUFh2NVpHZTNLTDh2OW5LWkxrOUwrSXVSN2ZlZndmSWth?=
 =?utf-8?B?bWluc1c4RnhUOFo4ZGM3OGVYYjJpaVc3dXMrNzNzVFpjdkVBQk5CZExzZGRV?=
 =?utf-8?B?dnFvR0w1bkFMOUFCRXRFelVnZGRSaXFMdVZqKzBYckR0RWpQNmw2cnhzNUJu?=
 =?utf-8?B?TUNSa3p2OWZjZ3QzaW9IZFhsdlRvdE96ZzJUd25YR0txdTJqZit4cXIvV3gr?=
 =?utf-8?B?amNQSitUNTNZdFIwZTd4NlNkWU4vQi9nUVdDUnA2cVRBZjhrVTNaTGFpNFpL?=
 =?utf-8?B?RjR3eEM5NnFHMTNGaHBsRlA0MTREajBPeFR6TFVmRytVNURYVTFIb0dhd2Ri?=
 =?utf-8?B?alZmcnlyN1dPVk5DYWg0ZVNscyt6dkxQc3hmZTVxWjBZc1UxY2dGQ0ZLOWFB?=
 =?utf-8?B?VEl2SWhZRXl6ciszRGtrVGo3SG9zTEhLOXFwT3RjMkFrd2pMVVlibUxBM1lt?=
 =?utf-8?B?VHhSTzZpVWRtaVVOMGlqRE8ycnEvVGY2cmd6Ymg5Mk9MUUpqV1BsTDFBRmY0?=
 =?utf-8?B?aHliTGpua3BBV205OGZlMlgvWmxpa0R2dlhpeVlaUnpEaUxZdTJEL29IZkhC?=
 =?utf-8?B?R3pRYUMxSUQ5NFRJVnpPS29pbVFabnN4VlB4Mk9UNVArOFlBWjBvOXk4OUgr?=
 =?utf-8?B?dHA4SEIxQnIxb0hoYjV6NFA3MllHRDJrK09pcEFpUjNaVVRkK3p3SUlDT2tG?=
 =?utf-8?B?SndpczJaVEJBYnJOa3JSNU1MRys5VkFzemdBQS9SME1pTFppOHUwK3B1WVB1?=
 =?utf-8?B?N0tJMGl5ZG5kK1hUUlVvcVlTMGkvYXBJRWRUNHZVSDk5VlVXbXhMS3pnc3ZY?=
 =?utf-8?B?NGl6MnJUbU9kTkJXWFZqQ0dvR1NGOEQvbGpLZ0RCcmZyNVUvK3J6K0drUG1m?=
 =?utf-8?B?YjM4UHJSUFdGV3JLZGxJSmZBTXQ5VmpEYXZtMlIvMjVZMm5ZWTk2Ynk5dmcv?=
 =?utf-8?B?WFJPQklqMFdycVN3S2swZ1VUWXFDSXNHZUFkRlRxT0tMc1drNDhEbVNNTzlR?=
 =?utf-8?B?aGRaVFhLT21VUnE3VkxYLzkwM2p5Sjh2N2RJM3l1SzVkQ25NNkJaeWRzVHA5?=
 =?utf-8?B?YkFtell3Si9LS2dUUVM0MmFpcFNkWlAwZ2RuNURaLzFEOUtDVk1HTTdmZ2Nm?=
 =?utf-8?B?VENmbVFLK3F3SkYrbWZGS1djOGtoN0Q1OHFVOGJnZGZTZUF4L0RrS2JPVmtK?=
 =?utf-8?Q?V6KSXyoCSa4b4g+m0UUD6yaJIpGqErfWO3KTu4obqKoC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D15C46EDC6010F43A20FA0AEB344DBEB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31716355-5eb7-4d4b-fba4-08db1ac94d51
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 02:53:29.0399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ECBMytIzktfpS+5isoHJcVwtFW0EFBbO+9augzaOsW+zYwfbNNgAKETgdqJdonyIjBajgixGpplIUPRhaSeGgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7959
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

T24gMy8xLzIwMjMgNDozOCBQTSwgSm9ubWljaGFlbCBIYW5kcyB3cm90ZToNCj4gSGkgTG9nYW4s
IE1hcnRpbiwNCj4ganVzdCB0byBiZSBjbGVhciwgdGhlIExpbnV4IGltcGxlbWVudGF0aW9uwqBv
ZiB3cml0ZSB6ZXJvcyBpcyBjb3JyZWN0bHkgDQo+IHRhZ2dpbmcgREVBQyB0byAxIGR1cmluZyB0
aGUgTlZNZSB3cml0ZSB6ZXJvcyBjb21tYW5kPyBUaGlzIHNob3VsZCBiZSANCj4gdmVyeSBmYXN0
IG9uIGRyaXZlcyB0aGF0IHN1cHBvcnQgd3JpdGUgemVyb3Mgd2l0aCBUUklNIChtb3N0IGNvbnRy
b2xsZXJzIA0KPiB3aWxsIGhhdmUgdGhlIHNhbWUgaW50ZXJuYWwgcGF0aCBhcyBhIFRSSU0gdXBk
YXRpbmcgdGhlIEZUTCB0byANCj4gZGVhbGxvY2F0ZSB0aGUgTEJBcykuIFNpemUgb2YgdGhlIGNv
bW1hbmQgcmVhbGx5IHNob3VsZG4ndCBhZmZlY3QgaXQgDQo+IG11Y2gsIGl0IGlzIG11Y2ggbW9y
ZSBjb3JyZWxhdGVkIHdpdGggdGhlIGZpcm13YXJlIGltcGxlbWVudGF0aW9uIG9mIGFib3ZlLg0K
PiBUaGFua3MhDQo+IEpNDQo+IFNjcmVlbnNob3QgMjAyMy0wMy0wMSBhdCA0LjM1LjQzIFBNLnBu
Zw0KDQoNClllcywgaXQgZG9lcyBwbGVhc2Ugc2VlIFsxXS4NCg0KLWNrDQoNCjEuIE5WTWUgREVD
IGJpdCB0YWdnaW5nIGluIE5WTWUgd3JpdGUtemVyb2VzIGNvbW1hbmQgc2V0dXAuDQoNCnN0YXRp
YyBpbmxpbmUgYmxrX3N0YXR1c190IG52bWVfc2V0dXBfd3JpdGVfemVyb2VzKHN0cnVjdCBudm1l
X25zICpucywNCgkJc3RydWN0IHJlcXVlc3QgKnJlcSwgc3RydWN0IG52bWVfY29tbWFuZCAqY21u
ZCkNCnsNCgltZW1zZXQoY21uZCwgMCwgc2l6ZW9mKCpjbW5kKSk7DQoNCglpZiAobnMtPmN0cmwt
PnF1aXJrcyAmIE5WTUVfUVVJUktfREVBTExPQ0FURV9aRVJPRVMpDQoJCXJldHVybiBudm1lX3Nl
dHVwX2Rpc2NhcmQobnMsIHJlcSwgY21uZCk7DQoNCgljbW5kLT53cml0ZV96ZXJvZXMub3Bjb2Rl
ID0gbnZtZV9jbWRfd3JpdGVfemVyb2VzOw0KCWNtbmQtPndyaXRlX3plcm9lcy5uc2lkID0gY3B1
X3RvX2xlMzIobnMtPmhlYWQtPm5zX2lkKTsNCgljbW5kLT53cml0ZV96ZXJvZXMuc2xiYSA9DQoJ
CWNwdV90b19sZTY0KG52bWVfc2VjdF90b19sYmEobnMsIGJsa19ycV9wb3MocmVxKSkpOw0KCWNt
bmQtPndyaXRlX3plcm9lcy5sZW5ndGggPQ0KCQljcHVfdG9fbGUxNigoYmxrX3JxX2J5dGVzKHJl
cSkgPj4gbnMtPmxiYV9zaGlmdCkgLSAxKTsNCg0KCWlmICghKHJlcS0+Y21kX2ZsYWdzICYgUkVR
X05PVU5NQVApICYmIChucy0+ZmVhdHVyZXMgJiBOVk1FX05TX0RFQUMpKQ0KCQkqY21uZC0+d3Jp
dGVfemVyb2VzLmNvbnRyb2wgfD0gY3B1X3RvX2xlMTYoTlZNRV9XWl9ERUFDKTsqDQoNCglpZiAo
bnZtZV9uc19oYXNfcGkobnMpKSB7DQoJCWNtbmQtPndyaXRlX3plcm9lcy5jb250cm9sIHw9IGNw
dV90b19sZTE2KE5WTUVfUldfUFJJTkZPX1BSQUNUKTsNCg0KCQlzd2l0Y2ggKG5zLT5waV90eXBl
KSB7DQoJCWNhc2UgTlZNRV9OU19EUFNfUElfVFlQRTE6DQoJCWNhc2UgTlZNRV9OU19EUFNfUElf
VFlQRTI6DQoJCQludm1lX3NldF9yZWZfdGFnKG5zLCBjbW5kLCByZXEpOw0KCQkJYnJlYWs7DQoJ
CX0NCgl9DQoNCglyZXR1cm4gQkxLX1NUU19PSzsNCn0NCg==

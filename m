Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0ACC7EE24
	for <linux-raid@archiver.kernel.org>; Mon,  5 Jun 2023 07:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjFEH7I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Jun 2023 03:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjFEH6x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Jun 2023 03:58:53 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6536897;
        Mon,  5 Jun 2023 00:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1685951932; x=1717487932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R5XvB4uNZ+OaEZU0+8DM3SPllC+W4rzIl2a5o1fq6cE=;
  b=iTLVXwkW+2sd7hydAMTwwX9Fh4k68q9N+TCsmpEiRRfrvR3lXSK4OjSI
   M49mDJuQvzLQSWyE9ix7lzVHLtiKWgDpJiGijJZTMhI8w4TaFku3nZnl3
   3VAqyV4qLXNwtn0RERISksKRqMeqYqB18gxKq+ajst+yz1Cbtv60AVkRf
   d6i48MXpFEAcrV1DjylH9ZBy04u762TaFgKReKlFBJ/kC+sgA5HM8VQN9
   Nkg06tE/UyFdcR52U2Aqd+4bg/ta1J4oGoMMl/6lCRyrr9RpaPEXmqUlJ
   rxXnNCWj6HRWRyTQndvpR+r4SpOGMeMC2wFdeif8cVK5xRBmpuW7qKHRt
   A==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681142400"; 
   d="scan'208";a="232443457"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2023 15:58:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqjrdXxpBXdy+HVtspLG0jfsIn72Xh4b6qkujZKrXkgE4kX1oLcGLIlDntihArQgkRDAXDCFB9vb8KR5GyKoqSoSVuFmr08zb4GgsYfSZ5OaJMckdQ8eD1Fn80Plz2SUicTg8C+VmhoimTTuXCYpPhjdVOpRU4tGfTR09sHXTBRsfqIiP4B0UPISgnnZqM+FoO4bYQikBpNGl0GyQbFoUluE7/qlh1PACpgPPYCYVNe4b9oaFFziTTPd/Ru5G4qN3p9dgiaTlULjHfqc1ZtT57kWH6mmDcPaqgo1TcIF5ppvWZ4Cp+I1zCdvHHlrWsiDwRPcPdrf3BS/jHBnb++e3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5XvB4uNZ+OaEZU0+8DM3SPllC+W4rzIl2a5o1fq6cE=;
 b=MRTo+Nwyy2XAU9QCzHIi/if723bhwDmGzBfdXfUxi+usnxqZjO30zX0w4WQLsFgsE5p70zn6wxqacX4Y4jAj6iAnIAqPY8jzqELPf9lhF0YncdbNuS0C6MfQQsvy1buP3YDcjs3Df6EFybyOeqzvV+JdX/7UhKgGS0D4w11uX8hnEXVB7mORtlJwaU+RU7XJgcr5xNB1nvfAbGE+osMr3xBBQFytndIxkbxYbWLyyeQdhx4SudXm8W0TkALbWczL9M4V6lSsg2ChAAiAk+BKF2goGeGyNBRRrB8OwRB/I12n+1mKbZx4iMainT/IPk8vFw4tqaxZk8jI+X7Ntsd+4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5XvB4uNZ+OaEZU0+8DM3SPllC+W4rzIl2a5o1fq6cE=;
 b=LgwQ0FFwrJxFTbSNrWiRQzgH0GbbptrIMp83OurRM9XeOe2zRgQsnCEee8z+PoZ1cBKMhOyD3MOakG5ZLwI6bpjVAvmuH+wtEgUAv2IPimL57L6mo+2cu3nhl8H2vYKLEX7dfP95hjvhtkt/EPFzNWItcrk4aYW7Rte06MW670I=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SA2PR04MB7595.namprd04.prod.outlook.com (2603:10b6:806:148::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 07:58:49 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936%5]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 07:58:49 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>,
        "song@kernel.org" <song@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH] raid1: fix incorrect page freeing in
 alloc_behind_master_bio
Thread-Topic: [PATCH] raid1: fix incorrect page freeing in
 alloc_behind_master_bio
Thread-Index: AQHZl35UYOvWzOcFF0uDh3u40bFoqK972CKA
Date:   Mon, 5 Jun 2023 07:58:49 +0000
Message-ID: <9a5f7a9d-1d6a-8ea7-4836-63353427f966@wdc.com>
References: <20230605072114.497609-1-hch@lst.de>
In-Reply-To: <20230605072114.497609-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SA2PR04MB7595:EE_
x-ms-office365-filtering-correlation-id: 7c4f45a6-91ff-45e9-e6b3-08db659ab27c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j5Y5DWTWsszQ+8Tv+uQP0NuE0TxWqmbLPmh9aTbEyF4d73Vsw25ha4wUh75FBEKHe3jw+zoqzxoZI3xvVEoXz/nC7IqX7WJVB/hvEgXQL8UmmkhgnMQQiR9O5Vr/jee3rBfNQctxCUW5PLGmBrgXJjC1Pk1yqz7VmQ44ZH/2+xpCcr5XyWPUVfIxzDAAW2JbAt+JzLwLZtk95zfD6/zNt/D/68T2k1tIgZPGuhVtaBwbAbctRdqzmPj8dF+jcpuN/iZBlCLLmPSo5Xt3AXO6YTiC8DYytYpyyqjJvryySprICU1DrwVRijedDNxwW5JLB1zoyMuYNMAlCQJM+COEU/4B8UyUYVz0EOIdEe0gMtpu3VlaxBV6+IzO2iHlqI0RcTcGF1wuocBYm4iuIgv+ooG8rhMobWX1TpZG6iyXU9gATCyZPr+K9VNMbfxn9jg2qDV6o/2U6cS583FB+4a7SirWahAvvADaydJPfxDTXcFzA4Jb00cromiLjezU/a8B8xDV7NMbPEvT0Q55g84aI9pbeS7iOqWhO6LSYq79JTGN1k0Vys/vmYqrv+kkL5HrviUA3kMEN31a36f9i++igY55j3DsJ0ffhAaTtV9Vt2kL8/+XgmxfvFBqL7uZoAL2s5UJkIoigMwV0L0EA5al+m3yEz5GI3z4hS2xqEliZsnUwlz0PlUH3FQlN8NCzis5viNMQ/8QoTtqGkOpBgotLOzOZh9dBYEQeSLITgNrcII=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199021)(53546011)(6512007)(6506007)(36756003)(83380400001)(122000001)(31696002)(86362001)(38070700005)(82960400001)(38100700002)(186003)(2616005)(41300700001)(54906003)(110136005)(2906002)(4744005)(478600001)(66446008)(76116006)(66946007)(66476007)(91956017)(4326008)(8936002)(8676002)(64756008)(316002)(31686004)(5660300002)(6486002)(71200400001)(66556008)(45980500001)(43740500002)(473944003)(414714003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUY5SU9RVXVMZ01haEJpejZMOGVia1R0SzJzWnJqU1V4NFMvQms2ckJSblJF?=
 =?utf-8?B?bk9qVWJSRXVOQzBBM0V1YklSMUVIY3hkQjZLbEQwUVdUb2ZWaHFtNitkOEMw?=
 =?utf-8?B?STMvUDRKbE85TmZ4RHlZVWFPUWFVME9uNnkrWU1Gd3IwbkttY1dNUDRlbUN0?=
 =?utf-8?B?TktlSjJvZ1h5a3RycDlycHZ0R0pmOTkwdGRYZ1JvWnpZRXQrN2QzdUw0WDlT?=
 =?utf-8?B?U25CMEF1aWtUL0xQLzdCVW8zb1RqdEpnZkxRaVVtT0xOdEVyaDlJNGIwaFlV?=
 =?utf-8?B?TXowSy81UjJTNjBCR1ovbVJuRHRiaUd1R1VPUm9VRUVQcVZOYUFlVzhHQ0tO?=
 =?utf-8?B?c0VtbmUwaDJvcWFpMzZzc1V0T3pNQ1M0eDlzRUhiTVJXc0xSOFdYTDBzTG9B?=
 =?utf-8?B?emFEN05XVmVuWmUrNzNHYjgwdFZ5TGFhS0dacE5CK1JjV3RBbHJKdndzQVNv?=
 =?utf-8?B?STJ0ODZYQXM3WG1nY0VORlVFZEtHdmFEbWNIQzFHNlA1aDNqUnhxTG8wdTBv?=
 =?utf-8?B?emxmOFNoaGljRTFsMXB4WmFvZFQ4YXlMQTlzQktLVE1XUTFJYXl4R1ZacXoy?=
 =?utf-8?B?cUZDOU1iTXZMeGV6WjZaUjhWZEJkYmNBTU5TT2JiSHBOQXhpZ0o3ajZseEFE?=
 =?utf-8?B?ZmtMdDJZTndYdzNSZm5LbHZuSHVvRlF5TmZBUFJDRjhFamF3c3JKbEdqb0Y5?=
 =?utf-8?B?SGV6cm1OUmR0TDA4VTFUckNqOVFkK2o3cHJDN1E2bWU3VlU5dVNSd0REelRF?=
 =?utf-8?B?c3ozbU9vdEhMS0VyYkxzT21ac1Rzb2Nabzlnc0VUeldoWUJWY3QrSWJJM2w5?=
 =?utf-8?B?dndzU1A0TTVjOXphOXRaL2ZueHFvekxEZjM0dy9aNVZ2eC84K1VFeFZnSVg0?=
 =?utf-8?B?dmRuRlE3aitJV3hmUTlSUDN2bzROaGRTbnhLY3RDZ2NVWEFlNCtjT0hDTHFa?=
 =?utf-8?B?QThSTzdjMDk3S0JLL1h5em5HS2hxb2EvTTdpbGRQdmVFbHZadVlSa2c1ZGhW?=
 =?utf-8?B?NFRlVXhtTDk5TEhWZnNZNVdmK2lPU1gxUUhTdlM5QVR6K1ladUxnempyZkYr?=
 =?utf-8?B?MFZuWTFyVDRmUW1pOUxqLzhzUU1nd2JEQWlHeW9LU05RcEZ5L3VENyt4d1VY?=
 =?utf-8?B?SDI3M1FObEhvaUFkMDBoWXJQenRPYkVydVYzVWJscnZJQy9UVlo4a1d5NWVK?=
 =?utf-8?B?MDROVnhOSlBERWNoYWFQd3BuV0ZleiszN1ROR0Q2SURhbUpUY3c3aDI3UEJS?=
 =?utf-8?B?dzdDVHJKK3A0Nmh3bGNGb0wyZEtkenh5K0MzOHljSnlMcEZKLzFrdGhsdWhv?=
 =?utf-8?B?ZEEwM25sYlprUWRpTDFHVDJFaHBmTnVWNnFqTHM5WTFJOUtibzJwMWRPVEtq?=
 =?utf-8?B?THd0dVA2VkF6VDQ2NGRtcnZ0VTYyTy9SUXJqaldnUG5KNjMzQkxlZ0lDTjZT?=
 =?utf-8?B?TENib2g0WkgzbXNHZVE3TC81TnhBVzAyeGFVbnZObi9oWXc1TWhZQkNuTUlm?=
 =?utf-8?B?TGQ5WEpueDZBT3lCTTREYUtHUk9Kc2gvUHhURmx1VTJOQ2ZsS0ZmYS9MQnor?=
 =?utf-8?B?cDNwR3hJVThCcGcvY1hEY09DbHd1YnNXRkRCM3hHSjZMdkFSZlJtYUFjdElR?=
 =?utf-8?B?ZVNmbU1idjBRVHhMcmRNd1RXQlV5cDJ4VnNyZkNYeTN4b2pUNkVLc25wZXFN?=
 =?utf-8?B?Y2xKMVVReVJLeGVVV2lDK0QvbWdnUmhlNSthRjlkS1Nnb3hkMjRWVmJwS2l3?=
 =?utf-8?B?dG42NitHTWEzc2hURG5aSklDWS9aUVBJZ0dld1hBQzRLWlQyMjBMc3o3OWN6?=
 =?utf-8?B?bmNtNWlTQTlTWG9XRVBJakl2T0hXOEdLUElOa2Q4b0lVSkRmMzNjek12VVUz?=
 =?utf-8?B?YjdDeGpBV1JrZ3BDMER1SS8xSVAwZUJwV0FTUXYxbFNTeGdCT3BFeXZaV3JB?=
 =?utf-8?B?TTVNQWdOV1lrc3JKd01sUGhTNVZCMjV6dWtNYVBKNG1LRnFJODlITDFEYXlF?=
 =?utf-8?B?b2RXV2wwWk1lYnBROEtYQytQM1Myamp3Qm1VVVA0aU5lODdlNGp1empXMDFF?=
 =?utf-8?B?U3FzTU9hd0NMaS81Y1JkUHFZdnJnRkE2a3JKWFlEMWt3ZXBZc3VtR2hBajBO?=
 =?utf-8?B?cFpzMVNaOFM3eVlrSitWemk3VVgyQWRoY2d4VnE5YlB2SHByZ3NaMXIybFRh?=
 =?utf-8?B?QWc0WUVjbU1POGtKWjk3S1Y4amFqZncvQlBVOTZaSnFQWFdUYmE0Ui90VERW?=
 =?utf-8?B?Z3QyTXM1VG1zMk0za3N2b3hXWlZBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C07A2EAF98333499DF1C12E25E67346@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Qr5rrV4+IumkmpCAyyWcNOBrW3MaiXtR1r4k0OYpDeqdOFCQmgcqhfhbc8WxnXiQilM+34aYAOwg1RrkieIAkRLMFCJNlqPs+mxK6c7UNvDXKzFadJZ8EZPR7arDdja1gbx1GY835cy8EBCbv7Kngr/kubA6ShFCPeoH4DekgEqHArGn55AdQhHfZnRBNk+dYNsP5wtO859bvp5oEAbSCSUyatkHAgu4wQiXys7iXk/smwjVTCv+3Pf10fpQMZhDzoijoTmSPx5ZvHQgLqlkNgCltJbqs92ZAb6L/qF140bI2h6dtNdHgY0DjaLJdayc9HJ4TXjZfYqHC8qmM0zvcKieByXdWJ/ZfM7UZsUar9StC1IsKW5KSmMLPuohuYJsBVv/yRSgyZsvmRIa+xdv61ddIdlsnzsynf2IT+bRXkzed85NDypyN19jME7XVwJrXKv8jmWwsjBS66hsBZ640aCiX++BxIMF6gBPBouJ2nzVxLj3xEFGtcgpyo69foLND7TiIDIPXOTQgG92a2cUagQTOTxZK4XW/6vGSf0xbZmwon2LDblU2Js9VHDmt96WPnuBQpFgbFNj5AOXw3MErWCFPpm6dyGeOzWQ57wKjZHmRNCPSdRsVjRHeqlo4E4Lqh+H0yjY3aPIFc4t7zWLYre8MFTNQAVYejf+ari+GxO0FDWfJFidL58eXzOAyHrRHNqn7XmJMWEgOzwgXIucaoLgJLK5zO2uHfy2gcUzRj03KutixV28Lvp6QqvUo0CzrIyToLOMY5q7oXdG7pwRL60qunk25ngosKrp0zdLDGzrmbMSnFQX5xg5nkeMLAVRsSmyPlDfxi4McuUygohp3YSvAiHYImE2IsJl13LAS6c=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c4f45a6-91ff-45e9-e6b3-08db659ab27c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 07:58:49.6621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WGCYwU6Ugtg2bR6uzOYNXIvQ9Gn0/YBYbzIfisg2EJMqPVYK2JbDvKDIN15dAefles3amQ30RVDApULeQS0SJrGzBVXaypvgjZscA4/Lk5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7595
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

T24gMDUuMDYuMjMgMDk6MjEsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBmcmVlX3BhZ2Ug
dGFrZXMgdGhlIHZpcnR1YWwgYWRkcmVzcyBvZiB0aGUgbWVtb3J5IHRvIGJlIGZyZWVkLCBhbmQN
Cj4gZG9lcyBzbyBhcyBhbiB1bnNpZ25lZCBsb25nIGp1c3QgdG8gbWFrZSB0aGluZ3MgY29uZnVz
aW5nLiAgVXNlDQo+IHB1dF9wYWdlIGluc3RlYWQsIHdoaWNoIGFjdHVhbGx5IHdvcmtzIG9uIHRo
ZSBwYWdlIHBvaW50ZXIuDQo+IA0KPiBOb3RlIHRoYXQgdGhpcyBpcyBhIHJlYXNvbiB3aHkgdGhp
cyBzaG91bGQgaGF2ZSB1c2VkIF9fYmlvX2FkZF9wYWdlDQo+IGluc3RlYWQgZm9yIHRoaXMgaW1w
b3NzaWJsZSB0byBoaXQgY2FzZS4uDQo+IA0KPiBGaXhlczogMmY5ODQ4MTc4Y2ZhICgibWQ6IHJh
aWQxOiB1c2UgX19iaW9fYWRkX3BhZ2UgZm9yIGFkZGluZyBzaW5nbGUgcGFnZSB0byBiaW8iKQ0K
PiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+
ICBkcml2ZXJzL21kL3JhaWQxLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQx
LmMgYi9kcml2ZXJzL21kL3JhaWQxLmMNCj4gaW5kZXggZmY4OTgzOTQ1NWVjMTEuLjM1NzBkYTYz
OTY5YjU4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL21kL3JhaWQxLmMNCj4gKysrIGIvZHJpdmVy
cy9tZC9yYWlkMS5jDQo+IEBAIC0xMTQ4LDcgKzExNDgsNyBAQCBzdGF0aWMgdm9pZCBhbGxvY19i
ZWhpbmRfbWFzdGVyX2JpbyhzdHJ1Y3QgcjFiaW8gKnIxX2JpbywNCj4gIAkJCWdvdG8gZnJlZV9w
YWdlczsNCj4gIA0KPiAgCQlpZiAoIWJpb19hZGRfcGFnZShiZWhpbmRfYmlvLCBwYWdlLCBsZW4s
IDApKSB7DQo+IC0JCQlmcmVlX3BhZ2UocGFnZSk7DQo+ICsJCQlwdXRfcGFnZShwYWdlKTsNCj4g
IAkJCWdvdG8gZnJlZV9wYWdlczsNCj4gIAkJfQ0KPiAgDQoNClRoYXQgc2hvdWxkIGFscmVhZHkg
YmUgZml4ZWQgaW4gSmVucycgdHJlZS4NCg==

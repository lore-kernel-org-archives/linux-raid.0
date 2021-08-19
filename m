Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F35C4338F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 19:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39AED610A0
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 19:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhHST3x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:29:53 -0400
Received: from mail-edgeka27.fraunhofer.de ([153.96.1.27]:62707 "EHLO
        mail-edgeKA27.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230058AbhHST3w (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 19 Aug 2021 15:29:52 -0400
IronPort-SDR: Y+tWafKSOYtIp7iLiwcNpA9P3rWuoZ/8qL3mSqpjwja2OQ59dmLynEHwPD+GPjECrKaqmT7eJl
 PObVC+RM9fZ15mNpjNMpQumPfEs0ysl9FVhP+Mxco4Hqj3iBllFnDTfWprhR8WPgAilAmPtHQo
 LXK3NbIuc49l03bOGzo5V6nqUllqTnXuw1f1xgUKBEQXh95TW4Cp/IJvgJRHWOUAg0OE8pEBcS
 WtXr5EKqWR0uw6a0MA+h95Tl5fvWu1hqvwCtp52NhKaMX4tbYmKjoUw3yZIMJl8k85TtJMFDn+
 S/4=
IronPort-PHdr: =?us-ascii?q?A9a23=3Ao7SfjRKJCTABEUFZbdmcuZUyDhhOgF28FhYc9?=
 =?us-ascii?q?55ijrVJaKnl9JPnbwTT5vRo2VnOW4iTq/dJkPHfvK2oX2scqY2Av3YPfN0pN?=
 =?us-ascii?q?VcFhMwakhZmDJuDDkv2f+bjcih/GcNFTlIj9Ha+YgBZHc/kbAjUpXu/pTcZB?=
 =?us-ascii?q?hT4M19zIeL4f+yaj8m+2+2ovZPJZAAdjTumbLg0Ig+/sAPRsccbm81uJ/VZ9?=
 =?us-ascii?q?w=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FIAAAjsB5h/xoHYZlaHQEBAQEJARI?=
 =?us-ascii?q?BBQUBQIFFCAELAYFSKSiBV2mESINIA4RZYIgEA4ERmSyBLhSBEQNUCwEBAQE?=
 =?us-ascii?q?BAQEBAQcBAT8CBAEBAwOEXwIXgiABJTQJDgECBAEBARIBAQYBAQEBAQYEAgK?=
 =?us-ascii?q?BIIVoAQyDU4EIAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQE?=
 =?us-ascii?q?BBQKBCD0BAQEBAgESEQQNDAEBNwEPAgEIGAICJgICAjAVEAIEDgUiggNLglY?=
 =?us-ascii?q?DDiACnUcBgToCih96fzKBAYIHAQEGBASFChiBFoEeCQkBgQYqAYJ9hBCFSIE?=
 =?us-ascii?q?fJ4IpgRU2gQWBMzc+hAdUgwCCZIQqUxkHB3QTAYEBKgVVEgE/BhYekUqDAUa?=
 =?us-ascii?q?nH4EYB4IBUFueVSyDZYtjhg+RHoVPgSyPGaAfhH8CBAIEBQIOAQEGgWGCFU0?=
 =?us-ascii?q?kgzhQGQ+OIAwWg1CKXkMwAjYCBgEKAQEDCW6JFQEB?=
X-IPAS-Result: =?us-ascii?q?A2FIAAAjsB5h/xoHYZlaHQEBAQEJARIBBQUBQIFFCAELA?=
 =?us-ascii?q?YFSKSiBV2mESINIA4RZYIgEA4ERmSyBLhSBEQNUCwEBAQEBAQEBAQcBAT8CB?=
 =?us-ascii?q?AEBAwOEXwIXgiABJTQJDgECBAEBARIBAQYBAQEBAQYEAgKBIIVoAQyDU4EIA?=
 =?us-ascii?q?QEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBBQKBCD0BAQEBA?=
 =?us-ascii?q?gESEQQNDAEBNwEPAgEIGAICJgICAjAVEAIEDgUiggNLglYDDiACnUcBgToCi?=
 =?us-ascii?q?h96fzKBAYIHAQEGBASFChiBFoEeCQkBgQYqAYJ9hBCFSIEfJ4IpgRU2gQWBM?=
 =?us-ascii?q?zc+hAdUgwCCZIQqUxkHB3QTAYEBKgVVEgE/BhYekUqDAUanH4EYB4IBUFueV?=
 =?us-ascii?q?SyDZYtjhg+RHoVPgSyPGaAfhH8CBAIEBQIOAQEGgWGCFU0kgzhQGQ+OIAwWg?=
 =?us-ascii?q?1CKXkMwAjYCBgEKAQEDCW6JFQEB?=
X-IronPort-AV: E=Sophos;i="5.84,335,1620684000"; 
   d="scan'208";a="35130528"
Received: from mail-mtas26.fraunhofer.de ([153.97.7.26])
  by mail-edgeKA27.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 21:29:13 +0200
IronPort-SDR: GnK6fbkQOIbqeVKO7ol5NqHROOmekACf6cRPLtQ5VYPB3hYAFjpj8D7/tYRwRZqiz6OT8MLUv2
 LQR42j3li6FynWp5Aw9qleCamktNY3Sr4=
IronPort-PHdr: =?us-ascii?q?A9a23=3AUB3E3BZkpOEHT9merj1yJQT/LTDdhN3EVzX9o?=
 =?us-ascii?q?rI/gq9KN6Gk+I7vekfY4KYlgFzIWNDd7PRJw6rTvrv7UGMNqZCGrDgZcZNKW?=
 =?us-ascii?q?hNE7KdenwEpDMOfT0GuKvnsYn8iFdlGEVpi+Gu2d0NSHZW2a1jbuHbn6zkUF?=
 =?us-ascii?q?132PhZ0IeKgHInUgqHVn+C/8pHeeUNGnj24NLpzNxi96wvLv9QQgYxsJ7x3x?=
 =?us-ascii?q?haaykY=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AzBn3gKom0il73pUIK/Idn7saV5txLNV00z?=
 =?us-ascii?q?EX/kB9WHVpm5Oj+PxGzc526farslsssSkb6K290KnpewK4yXbsibNhfItKLz?=
 =?us-ascii?q?OWxFdAS7sSrbcKogeQVREWk9Qy6U4OSdkGNDSdNykYsS++2njDLz9C+qjFzE?=
 =?us-ascii?q?nLv5an854Fd2gDAMsAjzuRSDzraXGeLDM2WKbRf6Dsgvav0gDQH0j/Gf7LYU?=
 =?us-ascii?q?XtMdKzxeHjpdbDW1orFhQn4A6BgXeD87jhCSWV2R8YTndm3aoi2XKtqX262o?=
 =?us-ascii?q?yT99WAjjPM3W7a6Jpb3PH7zMFYOcCKgs8Jbh3xlweTYph7UbHqhkFxnAjv0i?=
 =?us-ascii?q?dvrDD/mWZnAy1B0QKJQohzm2q05+DU6kdo15Yl8y7CvZKsm72ieNtwMbs/uW?=
 =?us-ascii?q?sQSGqm16NnhqAh7EsD5RPoi3IcZymw7RjV9pzGUQpnmVGzpmdnmekPj2ZHWY?=
 =?us-ascii?q?9bc7NJq5cDlXklWqvoMRiKoLzPKtMeR/00JcwmBW+yfjTcpC1i0dasVnM8El?=
 =?us-ascii?q?OPRVUDoNWc13xTkGpix0UVycQDljNYnahNB6Vs9qDBKOBlhbtORsgZYeZ0A/?=
 =?us-ascii?q?oAW9K+DijITQjXOGyfLFz7HOUMOm7LqZTw/LIpjdvaNaAg3d83gtDMQVlYvW?=
 =?us-ascii?q?k9dwbnDtCPxoRC9lTXTGC0TV3Wu4hjDlhCy8vBrZ/QQGK+oXwV4rmdSsQkc7?=
 =?us-ascii?q?rmsqyISeFr6tfYXB7TJbo=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DFAACTsB5h/z6wYZlaHQEBAQEJARI?=
 =?us-ascii?q?BBQUBQAmBPAgBCwGBUikoB0yBAwEmQ4RHg0gDhFlghWCCJAM4AViIH4I0jlm?=
 =?us-ascii?q?BLhSBEQNUCwEDAQEBAQEHAQEEOgECBAEBhGUCF4IdAiY0CQ4BAgQBAQESAQE?=
 =?us-ascii?q?FAQEBAgEGBIERE4VoAQyGQgEBAQECARIRBA0MAQEUIwEPAgEIGAICJgICAjA?=
 =?us-ascii?q?HDhACBA4FIoIDS4JWAw4gAp1GAYE6Aoofen8ygQGCBwEBBgQEhQoYgRaBHgk?=
 =?us-ascii?q?JAYEGKgGCfYQQhUiBH4JQgRU2gQWBMzc+hAdUgwCCZIQqUxkHB3QTAYEBKgV?=
 =?us-ascii?q?VEgE/BhYekUqDAUanH4EYB4IBUFueVSyDZYtjhg+RHoVPgSyPGaAfhH8CBAI?=
 =?us-ascii?q?EBQIOAQEGgWE7gVlNJIM4UBkPjiAMFoNQil5CATACNgIGAQoBAQMJbAEBiRU?=
 =?us-ascii?q?BAQ?=
X-IronPort-AV: E=Sophos;i="5.84,335,1620684000"; 
   d="scan'208";a="151151304"
Received: from 153-97-176-62.vm.c.fraunhofer.de (HELO mobile.exch.fraunhofer.de) ([153.97.176.62])
  by mail-mtaS26.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 21:29:10 +0200
Received: from XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) by
 XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Thu, 19 Aug 2021 21:29:10 +0200
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (10.225.8.37) by
 XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.12
 via Frontend Transport; Thu, 19 Aug 2021 21:29:10 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FL06SeI4f02a6fiX5USF3dcLXDKCnV/NNQe9Lxm+Z105Kz2lZfL8m6Tn2W1xq+Uo7Tr2pS72eVlQVfHC8yJGOAu7gFptVSXkjll4K5aMgpXxTdZZt7QGhJW1GXyJDS8VKWpNL5n/o/u5HLb4Y2znV4SP0+YUUb18PbhNy94ugTaa/LFDaIpG0bGTkYHDOhacnX8rkXYn38XEsAj7+/sizoDNRkn2eE13f0dQ22JiiyEPo6hLqfCWiGnabUCUCdal6Ashnf5Vi/tDebPJ18uYbckcAAMRka0BDxaEowjObXhsBh/Lw/pkDqWhsVUobyyZqRBL+5HqHnMxKOQuDM2dMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rc9p43Cw1KTOnt3JKMQvoCZ0xpUrnzbMhqceGljAPVg=;
 b=dRb39HYudtOFzeS7jVGH8W2WzgfY38D7eWBWsNsyT4u9h8MvH3Uhyha7G6bPise/ZWkneHLUO8y3jddK1YiW515k01TWXzwGXqq/18zLrK30cN+lU4Z2ROMeq4q7u84bwJHWrSxwMwhh3UXf/ulIwNdYU7Q9p0knyiYsMK47xnIR2tnqBKMf1xvkMY6bf49VusJA447+2IvVLKZ1oMRbfKgH1p6xmPaB5eMlVg7mgcilhvyJQSlFCwSuJzxDEbdvBaiIQSiNkEQmz7tW35CHvTMlEobIaysoHMXi+2gh96LPda8SXCpTNPPRl8K3D5muLs/eNkaim51OkU/PdnSIaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aisec.fraunhofer.de; dmarc=pass action=none
 header.from=aisec.fraunhofer.de; dkim=pass header.d=aisec.fraunhofer.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fraunhofer.onmicrosoft.com; s=selector2-fraunhofer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rc9p43Cw1KTOnt3JKMQvoCZ0xpUrnzbMhqceGljAPVg=;
 b=AecoW/RdfGk8rdq4H9lcIqCepnqNEgn11zYrbwSJnZtnPujsUju2vm2eNZjJKTjGsrCUdBEh9ICWNlQM2dZEG9SSqvFCyfSXFruXnhFZisi3N0XTd7KzaqxqiR6744UruZWntD2pSBGNmLswK4GETYhJ0Z3WB+pIv0PW+rRKiZE=
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:3c2::22)
 by AM5P194MB0193.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:89::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 19:29:03 +0000
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
 ([fe80::4003:49ec:516:cc88]) by AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
 ([fe80::4003:49ec:516:cc88%9]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 19:29:03 +0000
From:   =?utf-8?B?V2Vpw58sIE1pY2hhZWw=?= 
        <michael.weiss@aisec.fraunhofer.de>
To:     "paul@paul-moore.com" <paul@paul-moore.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "casey@schaufler-ca.com" <casey@schaufler-ca.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "song@kernel.org" <song@kernel.org>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [PATCH v2 1/3] dm: introduce audit event module for device mapper
Thread-Topic: [PATCH v2 1/3] dm: introduce audit event module for device
 mapper
Thread-Index: AQHXkTsP+nqUb8DozEWQEIL7nX0Ymat5o8gAgAGasAA=
Date:   Thu, 19 Aug 2021 19:29:03 +0000
Message-ID: <67990d4f1ddc277a4444d329ea3623775616aa31.camel@aisec.fraunhofer.de>
References: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
         <20210814183359.4061-2-michael.weiss@aisec.fraunhofer.de>
         <CAHC9VhRB1iviuOyeqi3L4DC8LNfnkz1HXC3hdqNvqm2sZQYXMQ@mail.gmail.com>
In-Reply-To: <CAHC9VhRB1iviuOyeqi3L4DC8LNfnkz1HXC3hdqNvqm2sZQYXMQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1 
authentication-results: paul-moore.com; dkim=none (message not signed)
 header.d=none;paul-moore.com; dmarc=none action=none
 header.from=aisec.fraunhofer.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58b8ac2f-d917-4717-45a3-08d963479a77
x-ms-traffictypediagnostic: AM5P194MB0193:
x-microsoft-antispam-prvs: <AM5P194MB01932A4A91A4659519F707F6ACC09@AM5P194MB0193.EURP194.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mFHoc7t1Y+aX2j2eBKlWobN7AmvG//rLKyXLqLirsI3fy3f0n3eg6JGszEUQzJ4c3B18aUppEp8PVsMjFhsambrU4LTxYDG3cCxj60INKiJ0w1EfrWnjmlg5iAPkR/rF4HtpgX+9e7DtH1ds36i3kWoaMuLDOMqUWF5evsA4qx4DrKn1qkOHcumnAxM5WnSdk1llMXJ25K9CwR1Lbg8ohXBLWdGweSMvr5/6pbCwIpsXaCS6ElXzNgzXDasOARdPjvFgsYDggtb0H2RZX1idOp6w917gDuCxg32S2gFX6B83nCJnvC5wQzk9/9x456ua1hMi1SibrjFDdqbDblpPcYhQPGdoadvw6tp35OSEByy0T3c8lj4Mqay5lnxnMbmbIDe/m3XlUfSQ7rqC8fw0iulmDVNRKzAvpg1f3XYH6qrPSIQEf/FZfOeaD0wNPPi9GhaekCVqhLfq/KMA3a6In4iMxSizl0cJTvobWGduFiYhe0H3RO0YvLPBELBICB88L3lmCRzb2ADzBcERChSlYfcCuC7WUl6SybMA/wc863C52ihlnN9hIvPKRNw5ZsDBsRg0QjT5BihjmwkgcHNUpCxdsfvpbyQQmefC9FKteAD6IsxqNjDytqiBYk8mgzFn6ifEbegzDXfMISYI0oG3kVI/h0zsMytMjrIdcJj3eBFxEb+Ibj9PeQ5PmQGmUzulMYgF6xGnmkXgGEm75DPSlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P194MB1288.EURP194.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39840400004)(186003)(8676002)(85182001)(6512007)(122000001)(4326008)(316002)(38100700002)(71200400001)(6486002)(7416002)(2906002)(83380400001)(54906003)(66476007)(91956017)(66446008)(76116006)(2616005)(66556008)(8936002)(53546011)(26005)(6506007)(66946007)(38070700005)(86362001)(5660300002)(478600001)(64756008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFV2UkZ2UzFLaGZRL0VDN2lYRysyUzNEQTNDTmcvUjJEYk1rTnVIdEdkWEl3?=
 =?utf-8?B?SG9KOTRROFNkcjZ6RFBzSVBzT203ekNadEtDWGhOUWtwWHgxaDJTZ0x5Mkh6?=
 =?utf-8?B?Qk1hc1BIRmZHL0tiM1l5WEFFTERFRnNmWjdzbzFpUkNEV3liYThzN0xsT2dm?=
 =?utf-8?B?aWcwbXBoMzI0V1ZIVUNJc1FZN0xQSHFKbEpMV3Rwb1A0b2ljcngvZmpxNUxz?=
 =?utf-8?B?TGo4VWJtZVI2WWVISEpMc3J1UjltVWZ2L2k2MlIzZFJ0M1JmemgyRHdaUXAy?=
 =?utf-8?B?SUZvbnBTR1NZckFRKzRxT3N0YUovNGsxUWFIZjNxZ0p0cWJpNlhnTU1WUkJT?=
 =?utf-8?B?RklEOWl3dEt3NU1GS2FxNnBEaWJqYjc0SkFoV1FSNWNpdTVOUnZnMjU2OWxh?=
 =?utf-8?B?SFhydTNsand3aFFaWjhDYWxvUWpNYkphN3FVZGJRS3VTOVVxRlJ1NWhCQUJE?=
 =?utf-8?B?b1ZkNGV2RFR3QjNwaUxDeUMrU2lMZ1V2eXpNUlBXYU9oVW16MEo2V2VhS1RD?=
 =?utf-8?B?YW44U1k4bDFGUW84eVpRSTNnN3ZFV2dpbXoyaG8vN0V0R3k4NUN5UmFTZnJ3?=
 =?utf-8?B?OGdoK2hCcG4rZERJK1pjSzc0T2U5M1FtV1poMXNxS0VQUjZEZ2JJZVJxQkZU?=
 =?utf-8?B?NVVDU3o3STFjenQyN2RIWkNxTk5nVTF4UDYvcmhpd09mUC9Cczl1VHp5SGVN?=
 =?utf-8?B?QWhQVW1ObCt6b0EwdzkxWjlWUUxaaXlUUGNLQVA1T29rQ0RYT0Z3RkR3UkFr?=
 =?utf-8?B?M09uUkhSTmdQNXZMQy9XanREZEtXWG9nUmFKNWJnd3JaWnVTYlhhK2NpdXNN?=
 =?utf-8?B?MU5HVWg0WXUwamNhMFNyeUpFNnZBUllTR3dTdW9NR0JGMDdWZnZUR0ZwZ1dG?=
 =?utf-8?B?Ty9xSUcyZnJQSmpvS1VUOEJka25nTnd4R1NTVWU1K1BuVVh5V3E2OFpFeFhl?=
 =?utf-8?B?OXlGTnpCZUZyend1c1UxMWRFVTh6Unl3bVRPdmhQdEw4b0J4aGZ3bExRUS9n?=
 =?utf-8?B?TEZPSWtxdHF0N1B4NjVhLzBtSVdyS3dkaWljWGdOV21XN00rRm9HZ1M2WjVG?=
 =?utf-8?B?bFh6cm5yZUlWNUxwNWFSOGRUYkpOTHJZTWdZV1laQlBBMHlBalUxdkVma2hS?=
 =?utf-8?B?YlF1Y3VWOEJWdGt5S05zSUtmdFlSUFY1MGQ4VmZqc0RSMEd1Rm5rallFbG5s?=
 =?utf-8?B?cHk4OWF1eGJ4UVJpRSt1T1JMSmxhWTJvRzF1R0owTlNvM0xSUnlCaFFQMEJw?=
 =?utf-8?B?d244eW5zSFdXVDdCR29QVDFLaTdSTHFkMG1ZeGlhbGdFcWZwbCtrYnpFNTNx?=
 =?utf-8?B?bWEyU1J6NWU2NkV2UHVPSlJ5MU9MaVJJVzJwb2o3KzdTV0tNQ3FxOXRZN1JZ?=
 =?utf-8?B?Mm5ERk82WDNUdCtyQWNxR0NkanpvZUlpMnpRaWRKQzJPS0pra3FWcks3T2pU?=
 =?utf-8?B?UnNTbm9zVzdiUjIvc28xdWRFekZJcEdXT0RqRUdLQ25nLzhWL1AwU1FxQWZ3?=
 =?utf-8?B?S0FFc3FSeXZUcGdRMkJaUzh4bXczRWg4U1JaTzIyRlBGK09JVkpaNDB4Rndi?=
 =?utf-8?B?QTBNWlJRdkY5MXMvSGU1M1p2bzNFMUwrb1FvOXFGTjBGVC9ZMXEyd0ZjU0lP?=
 =?utf-8?B?WklRUStJSFN2d3prMXRvNUxLMkpxcGRCVVVnNnFJTUF1cndwU3ROdGJJWkg5?=
 =?utf-8?B?QzlrbTJ3bmIzMnNQS1JJZS9ubUMyeVJnL0JFZkVIeDU0cGtLVGVLdWdoSVJZ?=
 =?utf-8?Q?jBvozODhCJPodVo2v4nuzoRbVDCfRMvHfR4TxUP?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E4EB1CFA03B4E40BB825854767D65AB@EURP194.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b8ac2f-d917-4717-45a3-08d963479a77
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 19:29:03.3657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /+NhJ4mpfvvvjEbA2qPCewMAvvazesiMusm37N8IBeE4GGO8uEev0xpAcAXQ9dR4/0qPMYb8Blx2LoFknhHaD2Yz/9LyWm84Y5f1eeQ2R5SYhOgUN7Bw92UTJEVImmOy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P194MB0193
X-OriginatorOrg: aisec.fraunhofer.de
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

T24gV2VkLCAyMDIxLTA4LTE4IGF0IDE0OjU5IC0wNDAwLCBQYXVsIE1vb3JlIHdyb3RlOg0KPiBP
biBTYXQsIEF1ZyAxNCwgMjAyMSBhdCAyOjM0IFBNIE1pY2hhZWwgV2Vpw58NCj4gPG1pY2hhZWwu
d2Vpc3NAYWlzZWMuZnJhdW5ob2Zlci5kZT4gd3JvdGU6DQo+ID4gVG8gYmUgYWJsZSB0byBzZW5k
IGF1ZGl0aW5nIGV2ZW50cyB0byB1c2VyIHNwYWNlLCB3ZSBpbnRyb2R1Y2UNCj4gPiBhIGdlbmVy
aWMgZG0tYXVkaXQgbW9kdWxlLiBJdCBwcm92aWRlcyBoZWxwZXIgZnVuY3Rpb25zIHRvIGVtaXQN
Cj4gPiBhdWRpdCBldmVudHMgdGhyb3VnaCB0aGUga2VybmVsIGF1ZGl0IHN1YnN5c3RlbS4gV2Ug
Y2xhaW0gdGhlDQo+ID4gQVVESVRfRE0gdHlwZT0xMzM2IG91dCBvZiB0aGUgYXVkaXQgZXZlbnQg
bWVzc2FnZXMgcmFuZ2UgaW4gdGhlDQo+ID4gY29ycmVzcG9uZGluZyB1c2Vyc3BhY2UgYXBpIGlu
ICdpbmNsdWRlL3VhcGkvbGludXgvYXVkaXQuaCcgZm9yDQo+ID4gdGhvc2UgZXZlbnRzLg0KPiA+
IA0KPiA+IEZvbGxvd2luZyBjb21taXRzIHRvIGRldmljZSBtYXBwZXIgdGFyZ2V0cyBhY3R1YWxs
eSB3aWxsIG1ha2UNCj4gPiB1c2Ugb2YgdGhpcyB0byBlbWl0IHRob3NlIGV2ZW50cyBpbiByZWxl
dmFudCBjYXNlcy4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFdlacOfIDxtaWNo
YWVsLndlaXNzQGFpc2VjLmZyYXVuaG9mZXIuZGU+DQo+IA0KPiBIaSBNaWNoYWVsLA0KPiANCj4g
WW91IHdlbnQgaW50byBtb3JlIGRldGFpbCBpbiB5b3VyIHBhdGNoc2V0IGNvdmVyIGxldHRlciwg
ZS5nLiBleGFtcGxlDQo+IGF1ZGl0IHJlY29yZHMsIHdoaWNoIEkgdGhpbmsgd291bGQgYmUgaGVs
cGZ1bCBoZXJlIGluIHRoZSBjb21taXQNCj4gZGVzY3JpcHRpb24gc28gd2UgaGF2ZSBpdCBhcyBw
YXJ0IG9mIHRoZSBnaXQgbG9nLiAgSSBkb24ndCB3YW50IHRvDQo+IGRpc2NvdXJhZ2UgeW91IGZy
b20gd3JpdGluZyBjb3ZlciBsZXR0ZXJzLCBidXQgZG9uJ3QgZm9yZ2V0IHRoYXQgdGhlDQo+IGNv
dmVyIGxldHRlcnMgY2FuIGJlIGxvc3QgdG8gdGhlIGV0aGVyIGFmdGVyIGEgY291cGxlIG9mIHll
YXJzIHdoZXJlYXMNCj4gdGhlIGdpdCBsb2cgaGFzIGEgbXVjaCBsb25nZXIgbGlmZXRpbWUgKHdl
IGhvcGUhKSBhbmQgYSB0aWdodGVyDQo+IGJpbmRpbmcgdG8gdGhlIHJlbGF0ZWQgY29kZS4NCg0K
SGkgUGF1bCwNCg0KYXQgZmlyc3QgdGhhbmsgeW91IGZvciB5b3VyIGNvbW1lbnRzLg0KSSBzZWUg
eW91ciBwb2ludCBhbmQgSSB3aWxsIHJlc3BlY3QgdGhhdCBpbiBwcm92aWRpbmcgdGhlIG5leHQg
dmVyc2lvbiBvZg0KdGhpcyBwYXRjaC1zZXQuDQoNCj4gDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
bWQvS2NvbmZpZyAgICAgICAgIHwgMTAgKysrKysrKw0KPiA+ICBkcml2ZXJzL21kL01ha2VmaWxl
ICAgICAgICB8ICA0ICsrKw0KPiA+ICBkcml2ZXJzL21kL2RtLWF1ZGl0LmMgICAgICB8IDU5ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIGRyaXZlcnMvbWQvZG0t
YXVkaXQuaCAgICAgIHwgMzMgKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIGluY2x1ZGUvdWFw
aS9saW51eC9hdWRpdC5oIHwgIDEgKw0KPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDEwNyBpbnNlcnRp
b25zKCspDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21kL2RtLWF1ZGl0LmMNCj4g
PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWQvZG0tYXVkaXQuaA0KPiA+IA0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL21kL0tjb25maWcgYi9kcml2ZXJzL21kL0tjb25maWcNCj4gPiBp
bmRleCAwNjAyZTgyYTk1MTYuLjQ4YWRiZWMxMjE0OCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJz
L21kL0tjb25maWcNCj4gPiArKysgYi9kcml2ZXJzL21kL0tjb25maWcNCj4gPiBAQCAtNjA4LDYg
KzYwOCw3IEBAIGNvbmZpZyBETV9JTlRFR1JJVFkNCj4gPiAgICAgICAgIHNlbGVjdCBDUllQVE8N
Cj4gPiAgICAgICAgIHNlbGVjdCBDUllQVE9fU0tDSVBIRVINCj4gPiAgICAgICAgIHNlbGVjdCBB
U1lOQ19YT1INCj4gPiArICAgICAgIHNlbGVjdCBETV9BVURJVCBpZiBBVURJVA0KPiA+ICAgICAg
ICAgaGVscA0KPiA+ICAgICAgICAgICBUaGlzIGRldmljZS1tYXBwZXIgdGFyZ2V0IGVtdWxhdGVz
IGEgYmxvY2sgZGV2aWNlIHRoYXQgaGFzDQo+ID4gICAgICAgICAgIGFkZGl0aW9uYWwgcGVyLXNl
Y3RvciB0YWdzIHRoYXQgY2FuIGJlIHVzZWQgZm9yIHN0b3JpbmcNCj4gPiBAQCAtNjQwLDQgKzY0
MSwxMyBAQCBjb25maWcgRE1fWk9ORUQNCj4gPiANCj4gPiAgICAgICAgICAgSWYgdW5zdXJlLCBz
YXkgTi4NCj4gPiANCj4gPiArY29uZmlnIERNX0FVRElUDQo+ID4gKyAgICAgICBib29sICJETSBh
dWRpdCBldmVudHMiDQo+ID4gKyAgICAgICBkZXBlbmRzIG9uIEFVRElUDQo+ID4gKyAgICAgICBo
ZWxwDQo+ID4gKyAgICAgICAgIEdlbmVyYXRlIGF1ZGl0IGV2ZW50cyBmb3IgZGV2aWNlLW1hcHBl
ci4NCj4gPiArDQo+ID4gKyAgICAgICAgIEVuYWJsZXMgYXVkaXQgbG9nZ2luZyBvZiBzZXZlcmFs
IHNlY3VyaXR5IHJlbGV2YW50IGV2ZW50cyBpbiB0aGUNCj4gPiArICAgICAgICAgcGFydGljdWxh
ciBkZXZpY2UtbWFwcGVyIHRhcmdldHMsIGVzcGVjaWFsbHkgdGhlIGludGVncml0eSB0YXJnZXQu
DQo+ID4gKw0KPiA+ICBlbmRpZiAjIE1EDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvTWFr
ZWZpbGUgYi9kcml2ZXJzL21kL01ha2VmaWxlDQo+ID4gaW5kZXggYTc0YWFmOGIxNDQ1Li40Y2Q0
NzYyM2M3NDIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9tZC9NYWtlZmlsZQ0KPiA+ICsrKyBi
L2RyaXZlcnMvbWQvTWFrZWZpbGUNCj4gPiBAQCAtMTAzLDMgKzEwMyw3IEBAIGVuZGlmDQo+ID4g
IGlmZXEgKCQoQ09ORklHX0RNX1ZFUklUWV9WRVJJRllfUk9PVEhBU0hfU0lHKSx5KQ0KPiA+ICBk
bS12ZXJpdHktb2JqcyAgICAgICAgICAgICAgICAgKz0gZG0tdmVyaXR5LXZlcmlmeS1zaWcubw0K
PiA+ICBlbmRpZg0KPiA+ICsNCj4gPiAraWZlcSAoJChDT05GSUdfRE1fQVVESVQpLHkpDQo+ID4g
K2RtLW1vZC1vYmpzICAgICAgICAgICAgICAgICAgICAgICAgICAgICs9IGRtLWF1ZGl0Lm8NCj4g
PiArZW5kaWYNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1hdWRpdC5jIGIvZHJpdmVy
cy9tZC9kbS1hdWRpdC5jDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAw
MDAwMDAwMDAuLmM3ZTU4MjQ4MjFiYg0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9kcml2
ZXJzL21kL2RtLWF1ZGl0LmMNCj4gPiBAQCAtMCwwICsxLDU5IEBADQo+ID4gKy8vIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ID4gKy8qDQo+ID4gKyAqIENyZWF0aW5nIGF1ZGl0
IHJlY29yZHMgZm9yIG1hcHBlZCBkZXZpY2VzLg0KPiA+ICsgKg0KPiA+ICsgKiBDb3B5cmlnaHQg
KEMpIDIwMjEgRnJhdW5ob2ZlciBBSVNFQy4gQWxsIHJpZ2h0cyByZXNlcnZlZC4NCj4gPiArICoN
Cj4gPiArICogQXV0aG9yczogTWljaGFlbCBXZWnDnyA8bWljaGFlbC53ZWlzc0BhaXNlYy5mcmF1
bmhvZmVyLmRlPg0KPiA+ICsgKi8NCj4gPiArDQo+ID4gKyNpbmNsdWRlIDxsaW51eC9hdWRpdC5o
Pg0KPiA+ICsjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9k
ZXZpY2UtbWFwcGVyLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9iaW8uaD4NCj4gPiArI2luY2x1
ZGUgPGxpbnV4L2Jsa2Rldi5oPg0KPiA+ICsNCj4gPiArI2luY2x1ZGUgImRtLWF1ZGl0LmgiDQo+
ID4gKyNpbmNsdWRlICJkbS1jb3JlLmgiDQo+ID4gKw0KPiA+ICt2b2lkIGRtX2F1ZGl0X2xvZ19i
aW8oY29uc3QgY2hhciAqZG1fbXNnX3ByZWZpeCwgY29uc3QgY2hhciAqb3AsDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgIHN0cnVjdCBiaW8gKmJpbywgc2VjdG9yX3Qgc2VjdG9yLCBpbnQgcmVz
dWx0KQ0KPiA+ICt7DQo+ID4gKyAgICAgICBzdHJ1Y3QgYXVkaXRfYnVmZmVyICphYjsNCj4gPiAr
DQo+ID4gKyAgICAgICBpZiAoYXVkaXRfZW5hYmxlZCA9PSBBVURJVF9PRkYpDQo+ID4gKyAgICAg
ICAgICAgICAgIHJldHVybjsNCj4gPiArDQo+ID4gKyAgICAgICBhYiA9IGF1ZGl0X2xvZ19zdGFy
dChhdWRpdF9jb250ZXh0KCksIEdGUF9LRVJORUwsIEFVRElUX0RNKTsNCj4gPiArICAgICAgIGlm
ICh1bmxpa2VseSghYWIpKQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+ID4gKw0KPiA+
ICsgICAgICAgYXVkaXRfbG9nX2Zvcm1hdChhYiwgIm1vZHVsZT0lcyBkZXY9JWQ6JWQgb3A9JXMg
c2VjdG9yPSVsbHUgcmVzPSVkIiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgZG1fbXNn
X3ByZWZpeCwgTUFKT1IoYmlvLT5iaV9iZGV2LT5iZF9kZXYpLA0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgICBNSU5PUihiaW8tPmJpX2JkZXYtPmJkX2RldiksIG9wLCBzZWN0b3IsIHJlc3Vs
dCk7DQo+ID4gKyAgICAgICBhdWRpdF9sb2dfZW5kKGFiKTsNCj4gPiArfQ0KPiA+ICtFWFBPUlRf
U1lNQk9MX0dQTChkbV9hdWRpdF9sb2dfYmlvKTsNCj4gPiArDQo+ID4gK3ZvaWQgZG1fYXVkaXRf
bG9nX3RhcmdldChjb25zdCBjaGFyICpkbV9tc2dfcHJlZml4LCBjb25zdCBjaGFyICpvcCwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGRtX3RhcmdldCAqdGksIGludCByZXN1
bHQpDQo+ID4gK3sNCj4gPiArICAgICAgIHN0cnVjdCBhdWRpdF9idWZmZXIgKmFiOw0KPiA+ICsg
ICAgICAgc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kID0gZG1fdGFibGVfZ2V0X21kKHRpLT50YWJs
ZSk7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKGF1ZGl0X2VuYWJsZWQgPT0gQVVESVRfT0ZGKQ0K
PiA+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+ID4gKw0KPiA+ICsgICAgICAgYWIgPSBhdWRp
dF9sb2dfc3RhcnQoYXVkaXRfY29udGV4dCgpLCBHRlBfS0VSTkVMLCBBVURJVF9ETSk7DQo+ID4g
KyAgICAgICBpZiAodW5saWtlbHkoIWFiKSkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuOw0K
PiA+ICsNCj4gPiArICAgICAgIGF1ZGl0X2xvZ19mb3JtYXQoYWIsICJtb2R1bGU9JXMgZGV2PSVz
IG9wPSVzIiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgZG1fbXNnX3ByZWZpeCwgZG1f
ZGV2aWNlX25hbWUobWQpLCBvcCk7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKCFyZXN1bHQgJiYg
IXN0cmNtcCgiY3RyIiwgb3ApKQ0KPiA+ICsgICAgICAgICAgICAgICBhdWRpdF9sb2dfZm9ybWF0
KGFiLCAiIGVycm9yX21zZz0nJXMnIiwgdGktPmVycm9yKTsNCj4gPiArICAgICAgIGF1ZGl0X2xv
Z19mb3JtYXQoYWIsICIgcmVzPSVkIiwgcmVzdWx0KTsNCj4gPiArICAgICAgIGF1ZGl0X2xvZ19l
bmQoYWIpOw0KPiA+ICt9DQo+IA0KPiBHZW5lcmFsbHkgc3BlYWtpbmcgd2UgdHJ5IHRvIGtlZXAg
YSBjb25zaXN0ZW50IGZvcm1hdCBhbmQgb3JkZXJpbmcNCj4gd2l0aGluIGEgZ2l2ZW4gYXVkaXQg
cmVjb3JkIHR5cGUuICBIb3dldmVyIHlvdSBhcHBlYXIgdG8gaGF2ZSBhdCBsZWFzdA0KPiB0aHJl
ZSBkaWZmZXJlbnQgZm9ybWF0cyBmb3IgdGhlIEFVRElUX0RNIHJlY29yZCBpbiB0aGlzIHBhdGNo
Og0KPiANCj4gICAiLi4uIG1vZHVsZT0lcyBkZXY9JWQ6JWQgb3A9JXMgc2VjdG9yPSVsbHUgcmVz
PSVkIg0KPiAgICIuLi4gbW9kdWxlPSVzIGRldj0lcyBvcD0lcyBlcnJvcl9tc2c9JyVzJyByZXM9
JWQiDQo+ICAgIi4uLiBtb2R1bGU9JXMgZGV2PSVzIG9wPSVzIHJlcz0lZCINCj4gDQo+IFRoZSBm
aXJzdCB0aGluZyB0aGF0IGp1bXBzIG91dCBpcyB0aGF0IHNvbWUgZmllbGRzLCBlLmcuICJzZWN0
b3IiLCBhcmUNCj4gbm90IGFsd2F5cyBwcmVzZW50IGluIHRoZSByZWNvcmQ7IHdlIHR5cGljYWxs
eSBoYW5kbGUgdGhpcyBieSB1c2luZyBhDQo+ICI/IiBmb3IgdGhlIGZpZWxkIHZhbHVlIGluIHRo
b3NlIGNhc2VzIHdoZXJlIHlvdSB3b3VsZCBvdGhlcndpc2UgZHJvcA0KPiB0aGUgZmllbGQgZnJv
bSB0aGUgcmVjb3JkLCBmb3IgZXhhbXBsZSB0aGUgZm9sbG93aW5nIHJlY29yZDoNCj4gDQo+ICAg
Ii4uLiBtb2R1bGU9JXMgZGV2PSVzIG9wPSVzIHJlcz0lZCINCj4gDQo+IC4uLiB3b3VsZCBiZSBy
ZXdyaXR0ZW4gbGlrZSB0aGlzOg0KPiANCj4gICAiLi4uIG1vZHVsZT0lcyBkZXY9JXMgb3A9JXMg
c2VjdG9yPT8gcmVzPSVkIg0KDQpXZWxsLCBJIGRpZG4ndCBrbm93IHRoYXQuDQpGb3IgdGFyZ2V0
IGNyZWF0aW9uIGFuZCBkZXN0cnVjdGlvbiBhIHNlY3RvciBpcyBub3QgcmVsZXZhbnQuDQpTbyB3
b3VsZCBpdCBhbHNvIGJlIGFuIG9wdGlvbiBmb3IgeW91IGlmIHdlIGp1c3QgZGVmaW5lIHR3byBk
aWZmZXJlbnQNCnR5cGUgb2YgbWVzc2FnZXMgbGlrZSB0aGlzIGluIGF1ZGl0Lmg/DQoNCiNkZWZp
bmUgQVVESVRfRE1fQ1RSTCAgICAgICAgICAgMTMzNiAgICAvKiBEZXZpY2UgTWFwcGVyIHRhcmdl
dCBjb250cm9sICovDQojZGVmaW5lIEFVRElUX0RNX0VWRU5UCQkxMzM3CS8qIERldmljZSBNYXBw
ZXIgZXZlbnRzICovDQoNCj4gDQo+IFRoZSBzZWNvbmQgdGhpbmcgdGhhdCBJIG5vdGljZWQgaXMg
dGhhdCB0aGUgImRldiIgZmllbGQgY2hhbmdlcyBmcm9tIGENCj4gIm1ham9yOm1pbm9yIiBudW1i
ZXIgcmVwcmVzZW50YXRpb24gdG8gYW4gYXJiaXRyYXJ5IHN0cmluZyB2YWx1ZSwgZS5nLg0KPiAi
ZGV2PSVzIi4gIFRoaXMgZ2VuZXJhbGx5IGlzbid0IHNvbWV0aGluZyB3ZSBkbyB3aXRoIGF1ZGl0
IHJlY29yZHMsDQo+IHBsZWFzZSBzdGljayB0byBhIHNpbmdsZSByZXByZXNlbnRhdGlvbiBmb3Ig
YSBnaXZlbiBhdWRpdA0KPiByZWNvcmQtdHlwZS9maWVsZCBjb21iaW5hdGlvbi4NCg0KZG1fZGV2
aWNlX25hbWUobWQpIGFscmVhZHkgZG9lcyBwcm92aWRlIGEgbWFqb3I6bWlub3IgaW4gc3RyaW5n
DQpyZXByZXNlbnRhdGlvbiwgdGhhdCBpcyB3aHkgSSB1c2VkIGl0DQpkaXJlY3RseSB3aXRoIGRl
dj0lcw0KYW5kIGluIHRoZSBiaW8gY2FzZSBidWlsZCBpdCB1cCBtYW51YWxseSBvdXQgb2YgbWFq
b3IgYW5kIG1pbm9yDQpvZiB0aGUgYmRldi4NCg0KSSBzZWUgdHdvIG9wdGlvbnMgaGVyZSB0byBi
ZSBtb3JlIGNsZWFyIG9uIHRoaXMgaW4gdGhlIGNvZGUuDQpGaXJzdCwganVzdCBwcm92aWRlIGEN
CmNvbW1lbnQgb3Igc2Vjb25kIHVzZSB0aGUgbWFqb3IgbWlub3IgZGlyZWN0bHkgZnJvbQ0KZG1f
ZGlzayhtZCktPm1ham9yLCBkbV9kaXNrKG1kKS0+Zmlyc3RfbWlub3IuDQoNCkknbSBub3Qgc3Vy
ZSB3aGF0J3MgYmV0dGVyIGhlcmUuDQoNCg0KVGhhbmtzLA0KTWljaGFlbA0K

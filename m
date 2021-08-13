Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF82C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 07:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EAF160241
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 07:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbhHMHH1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 03:07:27 -0400
Received: from mail-edgeka27.fraunhofer.de ([153.96.1.27]:44562 "EHLO
        mail-edgeKA27.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239052AbhHMHHU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 13 Aug 2021 03:07:20 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2021 03:07:18 EDT
IronPort-SDR: Kb3VF3Wib90ppgYymzc5aAvwKVk6pyUXQqLNWA1aqVKWxCfUZRCEdalwI/Oq+5Q88Dvs03PCu1
 zMOPXJJZO/pab7frmrw0NUGUMlXCwPZR92KAAujmnBcGEosIm4yFUEMkftWAWIdIhWVSakW6ov
 T4vZaoaU2BDYf7lhEpyzxw1SpXV3TlqI85rkwCf16+2RUed4ef9TKlb3dfN7uov63Bm3waZ1Wv
 KH8uj8AXY+8zymBvloCmjupNBcmk1syCImPpe4mfkte4g1F+LOTKpwigmqtBnmiz/q51TKMgFW
 ldE=
IronPort-PHdr: =?us-ascii?q?A9a23=3AuLLPqh2cEBDH9vZasmDPX1BlVkEcU/3cJQUV4?=
 =?us-ascii?q?4cpj79UN6+quZ/lOR+X6fZsiQrPWoPWo7JBhvHNuq/tEWoH/d6asX8EfZANM?=
 =?us-ascii?q?n1NicgfkwE6RsLQD0r9Ia3xZCwzAcpGWUUg9Hj9Ok9QS47yYlTIqSi06jgfU?=
 =?us-ascii?q?hz0KQtyILHzHYjf6qb/1+2795DJJQtSgz/oaLJpIR7wox/Yq88WhoVvMOA9x?=
 =?us-ascii?q?0ihnw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EzBABfFxZh/xoBYJlaHgEBCxIMQIF?=
 =?us-ascii?q?OC4FTKSiBV2mESINIA4U5iGkDgRCIHpELgS4UgREDVAsBAQEBAQEBAQEHAQE?=
 =?us-ascii?q?/AgQBAQMDhFMCF4JTASU0CQ4BAgQBAQESAQEGAQEBAQEGBAICgSCFaAEMg1O?=
 =?us-ascii?q?BCAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQUCgQg9AQE?=
 =?us-ascii?q?BAQIBEhEEDQwBATcBDwIBCBgCAiYCAgIwFRACBA4FIoIES4JWAw4gAp1MAYE?=
 =?us-ascii?q?6Aoofen8ygQGCBwEBBgQEhSsYgRaBHgkJAYEGKoJ9hA+FRYEfJ4IpgRU2gQW?=
 =?us-ascii?q?BMzc+hAc9F4MAgmSDHVMgB3QTAYEBgRc/BhYelEpGph2CEgeCAFBbnlErg2W?=
 =?us-ascii?q?RcjWQaYVNgSyPGKUcAgQCBAUCDgEBBoFgghVNJIM4UBkOjiAMFoNQil5DMAI?=
 =?us-ascii?q?2AgYBCgEBAwlbiF0BAQ?=
X-IPAS-Result: =?us-ascii?q?A2EzBABfFxZh/xoBYJlaHgEBCxIMQIFOC4FTKSiBV2mES?=
 =?us-ascii?q?INIA4U5iGkDgRCIHpELgS4UgREDVAsBAQEBAQEBAQEHAQE/AgQBAQMDhFMCF?=
 =?us-ascii?q?4JTASU0CQ4BAgQBAQESAQEGAQEBAQEGBAICgSCFaAEMg1OBCAEBAQEBAQEBA?=
 =?us-ascii?q?QEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQUCgQg9AQEBAQIBEhEEDQwBA?=
 =?us-ascii?q?TcBDwIBCBgCAiYCAgIwFRACBA4FIoIES4JWAw4gAp1MAYE6Aoofen8ygQGCB?=
 =?us-ascii?q?wEBBgQEhSsYgRaBHgkJAYEGKoJ9hA+FRYEfJ4IpgRU2gQWBMzc+hAc9F4MAg?=
 =?us-ascii?q?mSDHVMgB3QTAYEBgRc/BhYelEpGph2CEgeCAFBbnlErg2WRcjWQaYVNgSyPG?=
 =?us-ascii?q?KUcAgQCBAUCDgEBBoFgghVNJIM4UBkOjiAMFoNQil5DMAI2AgYBCgEBAwlbi?=
 =?us-ascii?q?F0BAQ?=
X-IronPort-AV: E=Sophos;i="5.84,318,1620684000"; 
   d="scan'208";a="34979012"
Received: from mail-mtaka26.fraunhofer.de ([153.96.1.26])
  by mail-edgeKA27.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 08:59:19 +0200
IronPort-SDR: UgUSLXpF+6WuanmMeb4QNcrneG/rZgUG8bMUHXcjvUIPuetr1vb6uT8cqveKodNJm9dikD5cjE
 yv8NImWRuAsjxpHz91LTiQA7ctC8BxHaU=
IronPort-PHdr: =?us-ascii?q?A9a23=3AYGX0CRJ/OM1l0PGI2dmcuZEyDhhOgF28FhUe6?=
 =?us-ascii?q?pM6hbZDaOGo9tLpO0mMrflujVqcW4Ld5roEjufNqKnvVCQG5orJq3ENdpFAF?=
 =?us-ascii?q?npnwcUblgAtGoiJXEv8KvO5dCc6FdlMUFJ/unqyd0NSHZW2a1jbuHbn6zkUF?=
 =?us-ascii?q?132PhZ0IeKgHInUgqHVn+C/8pHeeUNGnj24NLpzNxi96wvLv9QQgYxsJ7x3x?=
 =?us-ascii?q?haaykY=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A2kExaK7HL5GaelHVpwPXwZKCI+orL9Y04l?=
 =?us-ascii?q?Q7vn2ZFiY7TiXIrayTdaoguCMc0AxhJU3Jmbi7Scy9qeu1z+813WBjB8bfYO?=
 =?us-ascii?q?CAghrpEGgC1/qt/9SEIUPDH4FmpN5dmsRFeb7N5B1B/LzHCWqDYpUdKbu8gd?=
 =?us-ascii?q?iVbI7lph8HJ2ALV0gj1XYDNu/yKDwqeOAsP+tcKHPo3Lsgm9PWQwVxUi3UPA?=
 =?us-ascii?q?hmY8Hz4/nw0L72ax8PABAqrCOUiymz1bL8Gx+Emj8DTjJm294ZgCr4uj28wp?=
 =?us-ascii?q?/mn+Cwyxfa2WOWxY9RgsHdxtxKA9HJotQJKw/rlh2jaO1aKvi/VXEO0aWSAW?=
 =?us-ascii?q?QR4Z/xSiQbTp1OArTqDzmISC7Wqk7dOfAVmiTfIBGj8CHeSIfCNU0H4oJ69P?=
 =?us-ascii?q?xkm13imhYdVZhHodJ2NyjyjesnMTrQ2Cv6/NTGTBdsiw69pmcji/caizhFXZ?=
 =?us-ascii?q?IZc6I5l/1UwKp5KuZJIMvB0vFtLACuNrCp2N9GNVeBK3zJtGhmx9KhGnw1Ax?=
 =?us-ascii?q?edW0AH/siYySJfknx1x1YRgJV3pAZNyLstD51fo+jUOKVhk79DCscQcKJmHe?=
 =?us-ascii?q?8EBc+6EHbETx7AOH+bZV7nCKYEMXTQrIOf2sR52Mi6PJgTiJcikpXIV11V8W?=
 =?us-ascii?q?Y0ZkL1EMWLmIZG9xjcKV/NFAgFCvsukaSRn4eMC4YDHRfzOmzGovHQ1Mn3WP?=
 =?us-ascii?q?erKMpbEKgmdsPeEQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BEDQBfFxZh/z6wYZlaHgEBCxIMQAm?=
 =?us-ascii?q?BRQuBUykoB0yBAwEmQ4RHg0gDhTmGRoIjAzgBV5kpgS4UgREDVAsBAwEBAQE?=
 =?us-ascii?q?BBwEBBDoBAgQBAYRZAheCUAImNAkOAQIEAQEBEgEBBQEBAQIBBgSBEROFaAE?=
 =?us-ascii?q?MhkIBAQEBAgESEQQNDAEBFCMBDwIBCBgCAiYCAgIwBw4QAgQOBSKCBEuCVgM?=
 =?us-ascii?q?OIAKdTAGBOgKKH3p/MoEBggcBAQYEBIUrGIEWgR4JCQGBBiqCfYQPhUWBH4J?=
 =?us-ascii?q?QgRU2gQWBMzc+hAc9F4MAgmSDHVMgB3QTAYEBgRc/BhYelEpGph2CEgeCAFB?=
 =?us-ascii?q?bnlErg2WRcjWQaYVNgSyPGKUcAgQCBAUCDgEBBoFgO4FZTSSDOFAZDo4gDBa?=
 =?us-ascii?q?DUIpeQgEwAjYCBgEKAQEDCVkBAYhdAQE?=
X-IronPort-AV: E=Sophos;i="5.84,318,1620684000"; 
   d="scan'208";a="121189815"
Received: from 153-97-176-62.vm.c.fraunhofer.de (HELO mobile.exch.fraunhofer.de) ([153.97.176.62])
  by mail-mtaKA26.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 08:59:16 +0200
Received: from XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) by
 XCH-HYBRID-02.ads.fraunhofer.de (10.225.8.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Fri, 13 Aug 2021 08:59:15 +0200
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (10.225.8.37) by
 XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.12
 via Frontend Transport; Fri, 13 Aug 2021 08:59:15 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbCDA3ADZgGB6urwhFSohKT2k8UIAS3U8rQmgiU9FmaSjJDpwsC3Ssq3Lqn/bJuexK83bP4Row+blgZGuAMT8woPFX/GX9ldEyrWgWsUhiXv0dqPqyjVv6FvPKKkE7k3xgTfqKdAHR7LCLxpngH94weAzuA5bAd1zzKkmK9tqkVRL/d0oeu6CQSffr3tEVQvAdGhyeUwQ+nP7MrUckI7IwDAnl9ImbtMNmT9QOzERYDaLOo8GQyVyhGmwJRFQ2ZGumWd+UQaUrtCqVBLjRMgwVj2f4bIXSPsLfCDeFLOCDcyRjRZLxTKmkjGHShKQObAJ7oac4Jo9kkFy4D2xOdoBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BH5JUcNGbnmnfYAcM1FhdDDqWzGFCEwWbTttsyB28GE=;
 b=ND7rjiWxyvKvqm21yFThKNDPI4zUukaTkWJArIUHabw+SH6rmYH/NPY23jvWiHA+bboHEowAHj14PrvMkBtT01A4AqSprbShNuQulExHX9GVPHjwJpTuPVyTZe2goD5ucSwoNNFFpal48MtPDxVGnr45pAKlC25dH5I5/ZzGfkSa8p2lAaDtuDknGf/N6vGOca+DcAU1O6NhoI2k5nQPSYy8+lPJL9gUOR02njv5ndj5p5N5wlPQtAMtCeIVuEMy2GP563z1EL6U3igkjFD7PXw47PlD1gfkZxrXeg5JqlToKC+FXbTw2CDuT4OP5Ia0V+2pv51901DV8CoSJvyymg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aisec.fraunhofer.de; dmarc=pass action=none
 header.from=aisec.fraunhofer.de; dkim=pass header.d=aisec.fraunhofer.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fraunhofer.onmicrosoft.com; s=selector2-fraunhofer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BH5JUcNGbnmnfYAcM1FhdDDqWzGFCEwWbTttsyB28GE=;
 b=gsDp/+h/iPvIRKYn88lCqiZ0NeAOY1KcFMEVGwaeaqN006vqqm83aR+rmhHesZJZVDvl2bbQD4VFfIjgpxVMRI5Z2/ZjhDsu6UyC8WQyte7XVRWOfLTzJhVP3uyPaIte+zF5Zjzp94qg92DCE0/2vmR/LPlcgjo0CnzBcQsYOnQ=
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:3c2::22)
 by AM7P194MB0930.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:176::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Fri, 13 Aug
 2021 06:59:15 +0000
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
 ([fe80::4003:49ec:516:cc88]) by AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
 ([fe80::4003:49ec:516:cc88%9]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 06:59:15 +0000
From:   =?utf-8?B?V2Vpw58sIE1pY2hhZWw=?= 
        <michael.weiss@aisec.fraunhofer.de>
To:     "casey@schaufler-ca.com" <casey@schaufler-ca.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "song@kernel.org" <song@kernel.org>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [PATCH 1/3] dm: introduce audit event module for device mapper
Thread-Topic: [PATCH 1/3] dm: introduce audit event module for device mapper
Thread-Index: AQHXj4p+RhDRkAKAeUGAaCUz8AYYXatwGmOAgADn+wA=
Date:   Fri, 13 Aug 2021 06:59:15 +0000
Message-ID: <e82a0835059181fedbc5b143329b0594151f8221.camel@aisec.fraunhofer.de>
References: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
         <20210812145748.4460-2-michael.weiss@aisec.fraunhofer.de>
         <7f28b3b4-c0a2-cb03-09fd-e0705959576a@schaufler-ca.com>
In-Reply-To: <7f28b3b4-c0a2-cb03-09fd-e0705959576a@schaufler-ca.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1 
authentication-results: schaufler-ca.com; dkim=none (message not signed)
 header.d=none;schaufler-ca.com; dmarc=none action=none
 header.from=aisec.fraunhofer.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 190d2b42-10a3-4873-b965-08d95e27dcdf
x-ms-traffictypediagnostic: AM7P194MB0930:
x-microsoft-antispam-prvs: <AM7P194MB0930C2963524B5993BD5D6E1ACFA9@AM7P194MB0930.EURP194.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:449;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PPUULmddyrdSUq6SdZYIUh1UU5TAPd34u5gSu97C5cyC2mTr+SVvlijHeHHtdXBd3H8WeAVCTICn3CCz+Ry+TeQmH+dqMPl4swuKYwZRTfAls2qiNu5pmYDyKW+42UwH0DWItLzG1QKrmJoUCz4PhekRBFrLqZngso4GdcZ4keNhB5sFJXvI62GYIjv1A1oxFai9nY84aK5wnaLsKZFIADmzET9H02rRIugrQq8uAVPLB3/ijaLbYDXJHh7OUUorrhf3Yf51Zgx4E1Ll/bCKhlj8ZDXpalGw7O3Lt3MXVv99eux+SKOcXL/oVyuPgzELK2dU1NSa883j/5y2YIoTT5kBrHXEuWmEv/iWfTlQt4/xpHMT0X7LGZgkE3MFfEFGWnzs8h2yRPTgiHO99sy7NldQTlTgnI2Bub6YsFYjLg4bVLxlhiDyEmsYmK622DxbsvwHhk2PNaiUJU+D+KtMoHCIwD8saHOs/CdXBOCvXIMVCLaxuZ73oD//5b5HSsVX3K4QGoKfHYeAUbLBvcUNdvtmjU1dPnZHuC5gPoqUDRP2v/R27GHaGptciGwMdVYpUOkGb+EQGR10OlTJpzNjn/2gJ9JZdYUQnEcxw4QbaANVFqSQolylcpmXCcAlqKEh240yMtSpeisnaGU5ibg+Iq6N3vyQB0gDzhiq7ipsOTQpIVOxGGJWNk6BBC+TxlcXs8FY2jckT1w3P2vYZ+t9gg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P194MB1288.EURP194.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(136003)(346002)(366004)(376002)(6916009)(5660300002)(478600001)(6506007)(53546011)(83380400001)(38070700005)(85182001)(71200400001)(76116006)(316002)(91956017)(8676002)(6486002)(8936002)(6512007)(26005)(186003)(64756008)(66556008)(66446008)(66476007)(66946007)(38100700002)(122000001)(4326008)(54906003)(86362001)(2616005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TS95SStPdHFmVmdFUThxa2hrbVZtK2pvMEhqUmNRQWh6RVNTUExZdHM0amRj?=
 =?utf-8?B?UnN1ckxPTkJ1NWdURWRzUXhnMHN1TktOSmpaVlYvS3FJWEpsYVgxaWh5a2lG?=
 =?utf-8?B?TUdRNVVKTm5pbE8yRm9hZ3lrOEFodkxzSUdtNEpaTnl5U2dHNGQyelFRa3Vo?=
 =?utf-8?B?MUlzVGVKV1QzRkt6TkhjSnNPV053dWJId0xpT2xuU0NkY3BRYUc1Ui90c2J1?=
 =?utf-8?B?VGQybHZEZjcwcG92eW02cW5qRVhXeEJFdzZ5RVZ6VlB4SmRVV2VZYjZIck5F?=
 =?utf-8?B?cDMydnBUdnVVRllDMlZsL1I1bDlxbUlWZVRPUzBnSHZnaEJLWldiMktoNjJE?=
 =?utf-8?B?dWN1VEFTTWF0cDNKNXNHbklJSCtrWEVlalFKTFlKeFRJeXBpOW9EcHdEcnVm?=
 =?utf-8?B?MDdHeml1c1l4dzU5eWZCaU4rTkFOVjZpVG9ZUm9IUHY3SjNmWFNOZmhmVGo1?=
 =?utf-8?B?YmNIUk5KR2kwVDk1U05EcjF3U1Z3dnZ4NHlqQ211WTRyR2ZzSFNCRUd1TWhB?=
 =?utf-8?B?VmI5T1cxeEFVaEM0cWNmOG9TR2RTQWthUm1YYjhKRjZVdEtrTndITldPN1Fv?=
 =?utf-8?B?YjFsbUwza0NETEFySnkwVnB3NlVodmhGZFVBSFlSdlU1SjByWmdrMUdadDZF?=
 =?utf-8?B?SitmRk04amRCS3I2MzArcHZiVVZrdWVqbHRnRjhzOEY1aHA3dDhqVW9WKzVp?=
 =?utf-8?B?Z0tRbHVLMnFvL1QxYzZQb091dDVuV2IrTXJsa0k2cHd6VWx6YUVtQ1JkdkJY?=
 =?utf-8?B?Tk13UVRNMnV4aWNRNjhrYTl5TER3NDRwdjIreWlsU0g1QjZGRG80RkMxTkN0?=
 =?utf-8?B?aWVyRVVqSk5QM3hoUzN3WTFnaXdha3hieHM3RVpQOEZWamV2Q2cwYVV3aGRH?=
 =?utf-8?B?M25jS21tZTVkTnQ2VWR1WXBRbjdNODQwbWhpV244UitYOXRoTFZvWkh5TUc5?=
 =?utf-8?B?RFNFODNxK1R3SUdCNEhFNzFnRGFrcitBTUpTTFhwVDg2OC8yYVVpWlFVUVRD?=
 =?utf-8?B?Tng2SjRvNlJBV2NuN1kwYkFKYTExeHhYc090M2I4SDBZVTc5WTZCTHExd3J2?=
 =?utf-8?B?OThaU3RDWkhSNm5sL3JwUHdDQW54emx1TVhadlVoYWp0MUpjS3l2aGFWb2tx?=
 =?utf-8?B?UnZtWFIwRUZRV2V3a2F3bDNJRWMydlF4cjNZa1doQVVkaUhDUEhQNlZNdXh0?=
 =?utf-8?B?SktSemkrSFVnaFY1OTFlU2V6ak5hT2FrMWtXbWM5M0V3eXV5RmxCVW5uSnRz?=
 =?utf-8?B?MnBQUmRCME1XQkhqY25HMmJmdyszQkNQdVFCNmRDcXFBK3QxVERSY3h0dHMx?=
 =?utf-8?B?MlN6OThnNWZxV0VOWWpWdkdiYUN3ZkFrRG0rbVYvUG50VWtacFhGdlV5bVlt?=
 =?utf-8?B?RFh0V0ZwU1BNRDluemxUTXR6dnJEMkRZOWUyaUNKTVV4b3FjNzJyRm1tNWQ1?=
 =?utf-8?B?UWEyUHlDWHRaVlhwRFk5bFJoZEVKcWRIdElPQkQ4MzQ3bFJURDJSNkxTR3Fa?=
 =?utf-8?B?QXZRM1Q4NFp2elg1SURTOWZSOG1PTitDcTRqdGp5QzJpd0pNKzZNeEdnQjJl?=
 =?utf-8?B?SDBEWTlKNUlDSlYrcTRxVTB1bmxtdE1hcW1UMkZVY2Jjc1lRZW1pdDRMWWhT?=
 =?utf-8?B?UU5BN01aR1RGVWx3MnZqdktaWDBEbldVczQrN25FRE9jdEJjS2RxbXY5NDM4?=
 =?utf-8?B?eXIyalp3OGdZS3V5RTFZYU1YU2NmYTlzVEZTODU1MkRLRlFPUzFtMmtkc09K?=
 =?utf-8?Q?Gey5xUlqZNfZ1p3WAoDn2oSjFLAzeoZrY+iq22Q?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E63A4029DB0014BA54829CDE8D347FB@EURP194.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 190d2b42-10a3-4873-b965-08d95e27dcdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2021 06:59:15.1144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1RfFf+wP0WLtbBr4M0i175C1CSJJQq4dZfGmj/RvqcWMUDhR/wnzsmvNCDSdObrBUq3R3myImMdxS/WCsLcKj6EfeN+UfLjzO4k7CQtY9FISqHleeDLUMWemT5lB59Ak
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P194MB0930
X-OriginatorOrg: aisec.fraunhofer.de
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

SGkgQ2FzZXksDQoNCk9uIFRodSwgMjAyMS0wOC0xMiBhdCAxMDowOCAtMDcwMCwgQ2FzZXkgU2No
YXVmbGVyIHdyb3RlOg0KPiBPbiA4LzEyLzIwMjEgNzo1NyBBTSwgTWljaGFlbCBXZWnDnyB3cm90
ZToNCj4gPiBUbyBiZSBhYmxlIHRvIHNlbmQgYXVkaXRpbmcgZXZlbnRzIHRvIHVzZXIgc3BhY2Us
IHdlIGludHJvZHVjZQ0KPiA+IGEgZ2VuZXJpYyBkbS1hdWRpdCBtb2R1bGUuIEl0IHByb3ZpZGVz
IGhlbHBlciBmdW5jdGlvbnMgdG8gZW1pdA0KPiA+IGF1ZGl0IGV2ZW50cyB0aHJvdWdoIHRoZSBr
ZXJuZWwgYXVkaXQgc3Vic3lzdGVtLiBXZSBjbGFpbSB0aGUNCj4gPiBBVURJVF9ETSB0eXBlPTEz
MzYgb3V0IG9mIHRoZSBhdWRpdCBldmVudCBtZXNzYWdlcyByYW5nZSBpbiB0aGUNCj4gPiBjb3Jy
ZXNwb25kaW5nIHVzZXJzcGFjZSBhcGkgaW4gJ2luY2x1ZGUvdWFwaS9saW51eC9hdWRpdC5oJyBm
b3INCj4gPiB0aG9zZSBldmVudHMuDQo+ID4gDQo+ID4gRm9sbG93aW5nIGNvbW1pdHMgdG8gZGV2
aWNlIG1hcHBlciB0YXJnZXRzIGFjdHVhbGx5IHdpbGwgbWFrZQ0KPiA+IHVzZSBvZiB0aGlzIHRv
IGVtaXQgdGhvc2UgZXZlbnRzIGluIHJlbGV2YW50IGNhc2VzLg0KPiA+IA0KPiA+IFNpZ25lZC1v
ZmYtYnk6IE1pY2hhZWwgV2Vpw58gPG1pY2hhZWwud2Vpc3NAYWlzZWMuZnJhdW5ob2Zlci5kZT4N
Cj4gPiAtLS0NCj4gPiAgZHJpdmVycy9tZC9LY29uZmlnICAgICAgICAgfCAxMCArKysrKysrDQo+
ID4gIGRyaXZlcnMvbWQvTWFrZWZpbGUgICAgICAgIHwgIDQgKysrDQo+ID4gIGRyaXZlcnMvbWQv
ZG0tYXVkaXQuYyAgICAgIHwgNTkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4gPiAgZHJpdmVycy9tZC9kbS1hdWRpdC5oICAgICAgfCAzMyArKysrKysrKysrKysrKysr
KysrKysNCj4gPiAgaW5jbHVkZS91YXBpL2xpbnV4L2F1ZGl0LmggfCAgMiArKw0KPiA+ICA1IGZp
bGVzIGNoYW5nZWQsIDEwOCBpbnNlcnRpb25zKCspDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBk
cml2ZXJzL21kL2RtLWF1ZGl0LmMNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWQv
ZG0tYXVkaXQuaA0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL0tjb25maWcgYi9k
cml2ZXJzL21kL0tjb25maWcNCj4gPiBpbmRleCAwNjAyZTgyYTk1MTYuLmZkNTRjNzEzYTAzZSAx
MDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL21kL0tjb25maWcNCj4gPiArKysgYi9kcml2ZXJzL21k
L0tjb25maWcNCj4gPiBAQCAtNjA4LDYgKzYwOCw3IEBAIGNvbmZpZyBETV9JTlRFR1JJVFkNCj4g
PiAgCXNlbGVjdCBDUllQVE8NCj4gPiAgCXNlbGVjdCBDUllQVE9fU0tDSVBIRVINCj4gPiAgCXNl
bGVjdCBBU1lOQ19YT1INCj4gPiArCXNlbGVjdCBETV9BVURJVCBpZiBBVURJVA0KPiA+ICAJaGVs
cA0KPiA+ICAJICBUaGlzIGRldmljZS1tYXBwZXIgdGFyZ2V0IGVtdWxhdGVzIGEgYmxvY2sgZGV2
aWNlIHRoYXQgaGFzDQo+ID4gIAkgIGFkZGl0aW9uYWwgcGVyLXNlY3RvciB0YWdzIHRoYXQgY2Fu
IGJlIHVzZWQgZm9yIHN0b3JpbmcNCj4gPiBAQCAtNjQwLDQgKzY0MSwxMyBAQCBjb25maWcgRE1f
Wk9ORUQNCj4gPiAgDQo+ID4gIAkgIElmIHVuc3VyZSwgc2F5IE4uDQo+ID4gIA0KPiA+ICtjb25m
aWcgRE1fQVVESVQNCj4gPiArCWJvb2wgIkRNIGF1ZGl0IGV2ZW50cyINCj4gPiArCWRlcGVuZHMg
b24gQVVESVQNCj4gPiArCWhlbHANCj4gPiArCSAgR2VuZXJhdGUgYXVkaXQgZXZlbnRzIGZvciBk
ZXZpY2UtbWFwcGVyLg0KPiA+ICsNCj4gPiArCSAgRW5hYmxlcyBhdWRpdCBsb2dpbmcgb2Ygc2V2
ZXJhbCBzZWN1cml0eSByZWxldmFudCBldmVudHMgaW4gdGhlDQo+IA0KPiBzL2xvZ2luZy9sb2dn
aW5nLw0KPiANCj4gPiArCSAgcGFydGljdWxhciBkZXZpY2UtbWFwcGVyIHRhcmdldHMsIGVzcGVj
aWFsbHkgdGhlIGludGVncml0eSB0YXJnZXQuDQo+ID4gKw0KPiA+ICBlbmRpZiAjIE1EDQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvTWFrZWZpbGUgYi9kcml2ZXJzL21kL01ha2VmaWxlDQo+
ID4gaW5kZXggYTc0YWFmOGIxNDQ1Li40Y2Q0NzYyM2M3NDIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9tZC9NYWtlZmlsZQ0KPiA+ICsrKyBiL2RyaXZlcnMvbWQvTWFrZWZpbGUNCj4gPiBAQCAt
MTAzLDMgKzEwMyw3IEBAIGVuZGlmDQo+ID4gIGlmZXEgKCQoQ09ORklHX0RNX1ZFUklUWV9WRVJJ
RllfUk9PVEhBU0hfU0lHKSx5KQ0KPiA+ICBkbS12ZXJpdHktb2JqcwkJCSs9IGRtLXZlcml0eS12
ZXJpZnktc2lnLm8NCj4gPiAgZW5kaWYNCj4gPiArDQo+ID4gK2lmZXEgKCQoQ09ORklHX0RNX0FV
RElUKSx5KQ0KPiA+ICtkbS1tb2Qtb2JqcwkJCQkrPSBkbS1hdWRpdC5vDQo+ID4gK2VuZGlmDQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tYXVkaXQuYyBiL2RyaXZlcnMvbWQvZG0tYXVk
aXQuYw0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi5j
N2U1ODI0ODIxYmINCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9tZC9kbS1h
dWRpdC5jDQo+ID4gQEAgLTAsMCArMSw1OSBAQA0KPiA+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRp
ZmllcjogR1BMLTIuMA0KPiA+ICsvKg0KPiA+ICsgKiBDcmVhdGluZyBhdWRpdCByZWNvcmRzIGZv
ciBtYXBwZWQgZGV2aWNlcy4NCj4gPiArICoNCj4gPiArICogQ29weXJpZ2h0IChDKSAyMDIxIEZy
YXVuaG9mZXIgQUlTRUMuIEFsbCByaWdodHMgcmVzZXJ2ZWQuDQo+ID4gKyAqDQo+ID4gKyAqIEF1
dGhvcnM6IE1pY2hhZWwgV2Vpw58gPG1pY2hhZWwud2Vpc3NAYWlzZWMuZnJhdW5ob2Zlci5kZT4N
Cj4gPiArICovDQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGludXgvYXVkaXQuaD4NCj4gPiArI2lu
Y2x1ZGUgPGxpbnV4L21vZHVsZS5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvZGV2aWNlLW1hcHBl
ci5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvYmlvLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9i
bGtkZXYuaD4NCj4gPiArDQo+ID4gKyNpbmNsdWRlICJkbS1hdWRpdC5oIg0KPiA+ICsjaW5jbHVk
ZSAiZG0tY29yZS5oIg0KPiA+ICsNCj4gPiArdm9pZCBkbV9hdWRpdF9sb2dfYmlvKGNvbnN0IGNo
YXIgKmRtX21zZ19wcmVmaXgsIGNvbnN0IGNoYXIgKm9wLA0KPiA+ICsJCSAgICAgIHN0cnVjdCBi
aW8gKmJpbywgc2VjdG9yX3Qgc2VjdG9yLCBpbnQgcmVzdWx0KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1
Y3QgYXVkaXRfYnVmZmVyICphYjsNCj4gPiArDQo+ID4gKwlpZiAoYXVkaXRfZW5hYmxlZCA9PSBB
VURJVF9PRkYpDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gPiArCWFiID0gYXVkaXRfbG9nX3N0
YXJ0KGF1ZGl0X2NvbnRleHQoKSwgR0ZQX0tFUk5FTCwgQVVESVRfRE0pOw0KPiA+ICsJaWYgKHVu
bGlrZWx5KCFhYikpDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gPiArCWF1ZGl0X2xvZ19mb3Jt
YXQoYWIsICJtb2R1bGU9JXMgZGV2PSVkOiVkIG9wPSVzIHNlY3Rvcj0lbGx1IHJlcz0lZCIsDQo+
ID4gKwkJCSBkbV9tc2dfcHJlZml4LCBNQUpPUihiaW8tPmJpX2JkZXYtPmJkX2RldiksDQo+ID4g
KwkJCSBNSU5PUihiaW8tPmJpX2JkZXYtPmJkX2RldiksIG9wLCBzZWN0b3IsIHJlc3VsdCk7DQo+
ID4gKwlhdWRpdF9sb2dfZW5kKGFiKTsNCj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTChk
bV9hdWRpdF9sb2dfYmlvKTsNCj4gPiArDQo+ID4gK3ZvaWQgZG1fYXVkaXRfbG9nX3RhcmdldChj
b25zdCBjaGFyICpkbV9tc2dfcHJlZml4LCBjb25zdCBjaGFyICpvcCwNCj4gPiArCQkJIHN0cnVj
dCBkbV90YXJnZXQgKnRpLCBpbnQgcmVzdWx0KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgYXVkaXRf
YnVmZmVyICphYjsNCj4gPiArCXN0cnVjdCBtYXBwZWRfZGV2aWNlICptZCA9IGRtX3RhYmxlX2dl
dF9tZCh0aS0+dGFibGUpOw0KPiA+ICsNCj4gPiArCWlmIChhdWRpdF9lbmFibGVkID09IEFVRElU
X09GRikNCj4gPiArCQlyZXR1cm47DQo+ID4gKw0KPiA+ICsJYWIgPSBhdWRpdF9sb2dfc3RhcnQo
YXVkaXRfY29udGV4dCgpLCBHRlBfS0VSTkVMLCBBVURJVF9ETSk7DQo+ID4gKwlpZiAodW5saWtl
bHkoIWFiKSkNCj4gPiArCQlyZXR1cm47DQo+ID4gKw0KPiA+ICsJYXVkaXRfbG9nX2Zvcm1hdChh
YiwgIm1vZHVsZT0lcyBkZXY9JXMgb3A9JXMiLA0KPiA+ICsJCQkgZG1fbXNnX3ByZWZpeCwgZG1f
ZGV2aWNlX25hbWUobWQpLCBvcCk7DQo+ID4gKw0KPiA+ICsJaWYgKCFyZXN1bHQgJiYgIXN0cmNt
cCgiY3RyIiwgb3ApKQ0KPiA+ICsJCWF1ZGl0X2xvZ19mb3JtYXQoYWIsICIgZXJyb3JfbXNnPScl
cyciLCB0aS0+ZXJyb3IpOw0KPiA+ICsJYXVkaXRfbG9nX2Zvcm1hdChhYiwgIiByZXM9JWQiLCBy
ZXN1bHQpOw0KPiA+ICsJYXVkaXRfbG9nX2VuZChhYik7DQo+ID4gK30NCj4gPiArRVhQT1JUX1NZ
TUJPTF9HUEwoZG1fYXVkaXRfbG9nX3RhcmdldCk7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bWQvZG0tYXVkaXQuaCBiL2RyaXZlcnMvbWQvZG0tYXVkaXQuaA0KPiA+IG5ldyBmaWxlIG1vZGUg
MTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi45ZGI0OTU1ZDMyZTENCj4gPiAtLS0gL2Rl
di9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9tZC9kbS1hdWRpdC5oDQo+ID4gQEAgLTAsMCArMSwz
MyBAQA0KPiA+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCAqLw0KPiA+ICsv
Kg0KPiA+ICsgKiBDcmVhdGluZyBhdWRpdCByZWNvcmRzIGZvciBtYXBwZWQgZGV2aWNlcy4NCj4g
PiArICoNCj4gPiArICogQ29weXJpZ2h0IChDKSAyMDIxIEZyYXVuaG9mZXIgQUlTRUMuIEFsbCBy
aWdodHMgcmVzZXJ2ZWQuDQo+ID4gKyAqDQo+ID4gKyAqIEF1dGhvcnM6IE1pY2hhZWwgV2Vpw58g
PG1pY2hhZWwud2Vpc3NAYWlzZWMuZnJhdW5ob2Zlci5kZT4NCj4gPiArICovDQo+ID4gKw0KPiA+
ICsjaWZuZGVmIERNX0FVRElUX0gNCj4gPiArI2RlZmluZSBETV9BVURJVF9IDQo+ID4gKw0KPiA+
ICsjaW5jbHVkZSA8bGludXgvZGV2aWNlLW1hcHBlci5oPg0KPiA+ICsNCj4gPiArI2lmZGVmIENP
TkZJR19ETV9BVURJVA0KPiA+ICt2b2lkIGRtX2F1ZGl0X2xvZ19iaW8oY29uc3QgY2hhciAqZG1f
bXNnX3ByZWZpeCwgY29uc3QgY2hhciAqb3AsDQo+ID4gKwkJICAgICAgc3RydWN0IGJpbyAqYmlv
LCBzZWN0b3JfdCBzZWN0b3IsIGludCByZXN1bHQpOw0KPiA+ICt2b2lkIGRtX2F1ZGl0X2xvZ190
YXJnZXQoY29uc3QgY2hhciAqZG1fbXNnX3ByZWZpeCwgY29uc3QgY2hhciAqb3AsDQo+ID4gKwkJ
CSBzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgaW50IHJlc3VsdCk7DQo+ID4gKyNlbHNlDQo+ID4gK3N0
YXRpYyBpbmxpbmUgdm9pZCBkbV9hdWRpdF9sb2dfYmlvKGNvbnN0IGNoYXIgKmRtX21zZ19wcmVm
aXgsIGNvbnN0IGNoYXIgKm9wLA0KPiA+ICsJCQkJICAgIHN0cnVjdCBiaW8gKmJpbywgc2VjdG9y
X3Qgc2VjdG9yLA0KPiA+ICsJCQkJICAgIGludCByZXN1bHQpOw0KPiA+ICt7DQo+ID4gK30NCg0K
a2VybmVsIHRlc3Qgcm9ib3Qgc3BvdHRlZCBhIHN5bnRheCBlcnJvciBpZiBDT05GSUdfRE1fQVVE
SVQgaXMNCm5vdCBzZXQgaGVyZSwgdG9vLiBXaWxsIGZpeCB0aGlzIGluIHYyLg0KDQo+ID4gK3N0
YXRpYyBpbmxpbmUgdm9pZCBkbV9hdWRpdF9sb2dfdGFyZ2V0KGNvbnN0IGNoYXIgKmRtX21zZ19w
cmVmaXgsDQo+ID4gKwkJCQkgICAgICAgY29uc3QgY2hhciAqb3AsIHN0cnVjdCBkbV90YXJnZXQg
KnRpLA0KPiA+ICsJCQkJICAgICAgIGludCByZXN1bHQpOw0KPiA+ICt7DQo+ID4gK30NCj4gPiAr
I2VuZGlmDQo+ID4gKw0KPiA+ICsjZW5kaWYNCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBp
L2xpbnV4L2F1ZGl0LmggYi9pbmNsdWRlL3VhcGkvbGludXgvYXVkaXQuaA0KPiA+IGluZGV4IGRh
YTQ4MTcyOWU5Yi4uOWQ3NjZmY2JjZjYyIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9s
aW51eC9hdWRpdC5oDQo+ID4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2F1ZGl0LmgNCj4gPiBA
QCAtMTE4LDYgKzExOCw3IEBADQo+ID4gICNkZWZpbmUgQVVESVRfVElNRV9BREpOVFBWQUwJMTMz
MwkvKiBOVFAgdmFsdWUgYWRqdXN0bWVudCAqLw0KPiA+ICAjZGVmaW5lIEFVRElUX0JQRgkJMTMz
NAkvKiBCUEYgc3Vic3lzdGVtICovDQo+ID4gICNkZWZpbmUgQVVESVRfRVZFTlRfTElTVEVORVIJ
MTMzNQkvKiBUYXNrIGpvaW5lZCBtdWx0aWNhc3QgcmVhZCBzb2NrZXQgKi8NCj4gPiArI2RlZmlu
ZSBBVURJVF9ETQkJMTMzNgkvKiBEZXZpY2UgTWFwcGVyIGV2ZW50cyAqLw0KPiA+ICANCj4gPiAg
I2RlZmluZSBBVURJVF9BVkMJCTE0MDAJLyogU0UgTGludXggYXZjIGRlbmlhbCBvciBncmFudCAq
Lw0KPiA+ICAjZGVmaW5lIEFVRElUX1NFTElOVVhfRVJSCTE0MDEJLyogSW50ZXJuYWwgU0UgTGlu
dXggRXJyb3JzICovDQo+ID4gQEAgLTE0MCw2ICsxNDEsNyBAQA0KPiA+ICAjZGVmaW5lIEFVRElU
X01BQ19DQUxJUFNPX0FERAkxNDE4CS8qIE5ldExhYmVsOiBhZGQgQ0FMSVBTTyBET0kgZW50cnkg
Ki8NCj4gPiAgI2RlZmluZSBBVURJVF9NQUNfQ0FMSVBTT19ERUwJMTQxOQkvKiBOZXRMYWJlbDog
ZGVsIENBTElQU08gRE9JIGVudHJ5ICovDQo+ID4gIA0KPiA+ICsNCj4gDQo+IFVubmVjZXNzYXJ5
IGFkZGl0aW9uYWwgd2hpdGVzcGFjZS4NCj4gDQo+ID4gICNkZWZpbmUgQVVESVRfRklSU1RfS0VS
Tl9BTk9NX01TRyAgIDE3MDANCj4gPiAgI2RlZmluZSBBVURJVF9MQVNUX0tFUk5fQU5PTV9NU0cg
ICAgMTc5OQ0KPiA+ICAjZGVmaW5lIEFVRElUX0FOT01fUFJPTUlTQ1VPVVMgICAgICAxNzAwIC8q
IERldmljZSBjaGFuZ2VkIHByb21pc2N1b3VzIG1vZGUgKi8NCg0KVGhhbmtzIGZvciBzcG90dGlu
ZyB0aGUgZXJyb3JzLCBJIHdpbGwgZml4IHRoZW0gaW4gdjIuDQoNClJlZ2FyZHMsDQpNaWNoYWVs
DQo=

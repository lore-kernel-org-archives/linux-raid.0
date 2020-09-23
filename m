Return-Path: <SRS0=yBIz=DA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1DDC2D0A8
	for <linux-raid@archiver.kernel.org>; Wed, 23 Sep 2020 09:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C5442137B
	for <linux-raid@archiver.kernel.org>; Wed, 23 Sep 2020 09:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=intel.onmicrosoft.com header.i=@intel.onmicrosoft.com header.b="W6/eRKbH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgIWJ1K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Sep 2020 05:27:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:65345 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIWJ1J (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 23 Sep 2020 05:27:09 -0400
IronPort-SDR: xm1ZtpTK1E2APazEZinKNwqRQQfEYu4NW6RFVh10+Z9h5slyAxky6RtCt7O6VISebs45knW+zD
 6rYRGPFhnaug==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="161775144"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="161775144"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 02:27:07 -0700
IronPort-SDR: 0wDOdBQV6fI3Gi6Vlt8/km+DX79tMnR9KyFmyIzSMUqSfzbZt2h2LHVJqPbPOW2YbVeh0VFA+P
 /9F6YgKeB5xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="338599530"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 23 Sep 2020 02:27:07 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 23 Sep 2020 02:27:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 23 Sep 2020 02:27:07 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 23 Sep 2020 02:27:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bs4+sMSrUlbcaiAcq3Dxd8H3nRdLV270LeH8U/g+GJ7shu3X59l+H0qoKYG4LjFc3+E8VIa8JEG511LU3mqgoLNZe0w8EtMcBJ4rf6dRHihovs0I1iemPEma46khfkKlFH9gXtYBWQF0QVjzHLd4wspsVeKeuTGHYCN9lU+tU+cDzplXGkhSbq/oQ9KlBEDIHyb6yHQgVAx245/YXW/I7+KEMlKiBEvfmAFnInZ3iPzBtdk4L/DvjE/J6ajFFFQ+wK+/PNMi9XM3NS49BYP+zWJ/CNx3W9nFaytc98QXRTx3dsf2hqMubsO3DvoadN449D9l+MKzlgfIfqDW8cpE4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KofYAcEJ2A1Q+zXC/5KWwub2siqzjHTPZl6R8cKeOIE=;
 b=TvLuam4qH9xz974treyCI4T4/EevskgLYLZJ+TcPXFjw2Y36iONqzVFkjSW4rtvmJEhCgqNwUAgCGf2XWPUoggJPPogL8QFU2zncKXAaq1QkOzLhFelgJ7W6ENkdftnEKwSkx379WIV/I3So7/SjavzCR9ugeELbBSHo5/wSRsr0+zCDTSNXsUjfAdjZULWr5SRtiQ1Pi26QgT3jnd6ks2uixD51XevxCqahZVROHvyswVlFrmGB2AjwWcAgy7up3led8SDAgowDY57MSH+cLoOKsJcudNT4DClWJMpJdZM/fMcbXxrK5rnY35KLwwEZpgI8Fxd0eHxIzozsdb9tnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KofYAcEJ2A1Q+zXC/5KWwub2siqzjHTPZl6R8cKeOIE=;
 b=W6/eRKbHoPH1y5S3QyPpIhOIdcnbHn45YTWBIqJCxp9GYNLMIasLZFlzW4S45RH/0lSyAu9dSD45BVAXQU+sW12ye4fBc39haQX9dft/7il8UAXOi6G25KL25UOVexhVKPOFAOYJ/JabK5dkRh/BCgs1GXDJRqphv7TAMGD71Tk=
Received: from SA0PR11MB4542.namprd11.prod.outlook.com (2603:10b6:806:9f::20)
 by SN6PR11MB3519.namprd11.prod.outlook.com (2603:10b6:805:d0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Wed, 23 Sep
 2020 09:27:02 +0000
Received: from SA0PR11MB4542.namprd11.prod.outlook.com
 ([fe80::98d7:7b2a:6e98:3cdf]) by SA0PR11MB4542.namprd11.prod.outlook.com
 ([fe80::98d7:7b2a:6e98:3cdf%8]) with mapi id 15.20.3391.024; Wed, 23 Sep 2020
 09:27:02 +0000
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>
To:     Song Liu <song@kernel.org>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "Kucman, Blazej" <blazej.kucman@intel.com>
Subject: IMSM is not recognizable on md-next
Thread-Topic: IMSM is not recognizable on md-next
Thread-Index: AdaRi6naSrsMQ2WgQySTTHANJI5vhA==
Date:   Wed, 23 Sep 2020 09:27:02 +0000
Message-ID: <SA0PR11MB4542DC39E397247EE526E4B3FF380@SA0PR11MB4542.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [89.64.90.135]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d873dc6-d2eb-43e2-192b-08d85fa2d493
x-ms-traffictypediagnostic: SN6PR11MB3519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB351911E912C258065D7A1D21FF380@SN6PR11MB3519.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: umohGp5DR1Z6ZwrzYQlOGb9v/nIlOcs9elu6vzYjLZMsE2kC3EwYLGqf1vicQtNtisApNzQHnfuybzWwpPgYw9Qa4KV2Qg84rpHpSydqflPrL7+IW4mXLM7nwZyj8YHn7JNTCJj6uzs1oPkFj2D4GEBEZPhPvBl/imHePmDSMjqaTyZs7MGYw61gfaXsIXkCktgUifeQKwFNZGrreKipfPp9OgfUQsRcr9sTgQNRa56hRtKKHYgeOEtrtfEN+fd9w6a71RZrVTrTuASoLDCwZoPhYweqYR3l/sB9zWiB01e6fBdSpega8hepKyzU4QPMJcpdyIgQDNkAgqharg6fcx6IQldHq1cRZtC/nhFx6LhjNykJVpZZQ7o5L2F0pZtaqF6LWQkyp7TGkN0aBquo3gwMQV8oFCsG/xQ5d78q0cAHPT/yFuRoRhXN5hbdKM3wut4JqrglbtPTAJEL/p4O3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR11MB4542.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(186003)(6916009)(966005)(7696005)(6506007)(478600001)(33656002)(54906003)(316002)(66446008)(71200400001)(558084003)(8936002)(26005)(83380400001)(55016002)(66476007)(66556008)(107886003)(8676002)(2906002)(9686003)(76116006)(86362001)(64756008)(52536014)(4326008)(66946007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aon1KpaWGtai1qJK5yPlRI9ggCCda9WZsE8VaJmgUydfaIN8qgHlNK5EwYxuvV9U9pH3Ekf1fiNkfytNM8IcC8CVKC0CQCv/9gLvk5sm5MWRwj3k31bvmS4g/B26mXZFS0gboGgKaEJlyPczID7CmzuhxmtMBoLi5UJX/Hrn4QjsSjNwO2gCUqwuJYICjBujMjSvueyAwR0W3T5aD29cs2IY8dLhQPl5sZbJLe27Ye9zQ+xLgR2F3+gNTrt0NnydfN2p4rbxDABAakIleH/GtUd+89g8f3L8XWhSpJkfMe5+qVctyjbLj3tMuZ1V9TZA2sQG+NRlofxYo/Uvf7Fo4KH2Q6Bs5yjrn88j92dCt+SOkX5yKGDZqr77/B627JRPCmQyZ/wJaBT6MCiDRmBzH/J7Ri0wNbdn61AxKXY1c1xTs3VLt8tv0D+dCslCXAVedoUS8wOekWvOtweMBZO9yXzj5PyYtthXKLLYDCGQq2skSA7H6U2mX38srLtoxQWvW9fcUO/1Ufy0Oc6xKsKWKNt+e2E8zRcqAMhrx0h7gnmBpriPMUuQ9a5ydLvqlOp+opsiVW8s/m0IErZVniwz7mp0aCZ9gmGl5SJ2ZkHUdcjQUEB9CxRanYoQsH/W2LePtMzMkgGgpSLxZsWOyhLqfg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR11MB4542.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d873dc6-d2eb-43e2-192b-08d85fa2d493
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 09:27:02.6993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Q7Cq1BAWd6e8nC9TPXnzjAuW1Q3pOdBBDCwGymfIcNku1wC/SD/8myRgy3LbK9hejnCpGgI1PRrFTWzKgGXstulSThTif5+OkGU0EDHA80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3519
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,
We have issue on md-next, it is blocking our executions.
See:
https://bugzilla.redhat.com/show_bug.cgi?id=3D1878970

Could you rebase your md-next branch, or cherry-pick the fix?

Thanks,
Mariusz

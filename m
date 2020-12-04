Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50C0C4361A
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9661222517
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgLDD11 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 22:27:27 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:30553 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgLDD10 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 22:27:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607052446; x=1638588446;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=wWO2+DoWaprIN+ldI6tSNf2ap63KBTYEr/zzwHBX9eo=;
  b=GGNdIiIj69mRxxLal0td4SM/Xgko97l8ZhmwnECrsuUUSNFX6xu7XGrw
   j/P/0u6YXK09+WUjrdgOXPvY+Yd3bY1h4iPDLTqZPmHfMwYTLrbVQzdZA
   J90f/sVSH22ZKETyYBYH6iAU5ixIXxM8xfoDggu+wDD323PFIzKaZ45Rk
   V/D3piP79BRcAN/hck90dT39c4Dp4zNsrjZqpl2CxCM+WrmhVCE6OYGKf
   M0kESWlv+mXq2mFyYIK45fdxsqqRQIbpPXru9OZbgdxVlKG8aHWtsGxnC
   1i/vxVCwkxe76w9s1bc2rFVQiNmMVUKZNEUBmqnLt9PI0zb8lhLuBQYcm
   A==;
IronPort-SDR: PmcBKIBiy8cwgufnfh5gBUM+2wsZa60Wi0lDtC6UKHN33juLQktYczJlIrfTdXryooePjxad+o
 UTgiGc5fseo+lv4tkW6r0waYadZITvINuWroJQcJtKvS6vATx2lCrkTD2iioZZdHx7+roX1Qns
 6VKe/NOWSPJnlyfDQsrUq3Y9CXgM9Qbju579jqrvBL1SF9/cArtpOpUvVsy5iWwoZoAzu9VSz3
 T0ZWIv3SzEqqxwmwOutpm6FT/lH3fdIAxyv+VlQ9Fp9lEjQxRx9qN6U/E7fDvgiuzOSYWPI6Gy
 AH4=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; 
   d="scan'208";a="154367103"
Received: from mail-cys01nam02lp2050.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.50])
  by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 11:26:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bo34egS3z40kwoPADC3OLyG2AlHPkbyIMPupIcO4fx5k11XJk/jEH/zOJd9zf4FMdhYANUL9dpQ3Kdn9XLAZfcQ244oLNxXSFloT9i1eoTbWiXifc36ljkdxPpR8F+3cUYPHWLevvHjGsNkG2zIQiTy63gdObbgMW/KkQ6WqdMB0EE42LO4eEJQBxssMK41JzWgh6rkJG48sk4fmMDHNmzOaslDTeBulHo2gb+YXjr8mlk2NwX0e4gX1qmGSMBYcc8Ux3aGvphmFV9g7nc9MRXU0GIrU4xRx+VKCoX93KoHJuYFAYZ9gtC84v/8rAfr7c/kFXook2xf1z1e7ggc0OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWO2+DoWaprIN+ldI6tSNf2ap63KBTYEr/zzwHBX9eo=;
 b=H6WYgKACSzaJtmRPGS7bdEL5cKbRzLZCW94x9zqCMuVrm1oSj9CsHuv3UiDwJY02MJMZzziyz/OXWi/dccm/L2LZCclXpPGztdoQZy6Mu7KqvP33MRiMR3yo9j/1DQlIswDhPZrGamvLz7pLQnRU0EuIe6jtFHU4cMgGmJZX5YhoOW5Nl4QfBFAVHgE7YrO5/u/NQXyuFfFBZxwlewKfSEakWIO8+AagD/N2senQqHO0bWoQixuwzOZ3gM38Z6eJ2oOLP6nibazDhdRKkRlykTsMfgk8oTD9UFf5mdhSG7QnRq3/cHXK+I7ODO/dA5LMO66bDCvHhKHISoCze4fg+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWO2+DoWaprIN+ldI6tSNf2ap63KBTYEr/zzwHBX9eo=;
 b=nFyc2UtksB4Ki9yX1yY7UKFUl+7bkHxdqDzBaC9xAsHpKpEDIJW8CkBWTLo/2Xh0ujnkmN/HX/rxofkdZXqdKJfbG8Rf99hAZBSKKk0fS/7YVjFA2CLWt+bITlpDoVtSlcPKXyiQZPcy5OcpVnl9Ngk3J2BiwZlxJqgKjQD36No=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB7123.namprd04.prod.outlook.com (2603:10b6:a03:227::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 03:26:17 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031; Fri, 4 Dec 2020
 03:26:12 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Tejun Heo <tj@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/5] block: remove the request_queue argument to the
 block_split tracepoint
Thread-Topic: [PATCH 3/5] block: remove the request_queue argument to the
 block_split tracepoint
Thread-Index: AQHWyZEFNTOeNzY5Jka6tRtodLuhyA==
Date:   Fri, 4 Dec 2020 03:26:12 +0000
Message-ID: <BYAPR04MB4965387444860B94FD948AE186F10@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201203162139.2110977-1-hch@lst.de>
 <20201203162139.2110977-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a7d405e-a0ae-453f-88db-08d89804597e
x-ms-traffictypediagnostic: BY5PR04MB7123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB712303C000180BFD3A96292886F10@BY5PR04MB7123.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RFHzhOLqW0GqxvZrmMBcdXTA8LfMiMZmtA2cWCUE6IDuAcw9GSlys+2D29InI78l9XWEApiS9UQgooR6ArscENZGx20nJycLjc7DfhxJ/RRgxBnwW/fgIZWpFmDp0GSBh2jYNMNU4HboPgT/Yzwz1tUfbbyqJWbcsAhNxBlRcDT/YVGAfOB/0ziNYLHhvMn2E+fyd0Ue/qIrDuaBkIhjkAtJEeqSIKjqOCKiSpUm5xO3aiky7k1ntyA7KK3TzT1X1rAQHOUg/GKK/a/NBomilW2N48dCBiIP2/SJdqI0CgUZOAzGMuD3EnM/QRhjJlzZHWXNz7QUAn15syxx1oOsqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(66476007)(66446008)(66946007)(64756008)(186003)(66556008)(4326008)(54906003)(316002)(110136005)(26005)(558084003)(2906002)(7696005)(33656002)(6506007)(86362001)(71200400001)(53546011)(5660300002)(76116006)(52536014)(8676002)(8936002)(55016002)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LNHdLRycY4VB3AN0+nc0o4o0Svn7f99vfSBbx2Mw+ERW3JAdlIplxF3T3Xu4?=
 =?us-ascii?Q?ZPPMPt4Z25xxzYNdHCPocOOSWQipXRMvE0QbLIqO+uDqiX9bS1XmRkbygIqR?=
 =?us-ascii?Q?snb2YlcKsiHayBQKEbk/eX4wGEJm+sPQ0/Ew0QX2N1oETfOM/JyVbV9E/s/G?=
 =?us-ascii?Q?c2on1guwOYMJXYGKjvh8oa/Zi8bM8vMr3ioHctS17OyFypYGbtfG/IZDzbb5?=
 =?us-ascii?Q?A1qfalxBfYeuPlmUWDGrB5PkGFUgnTY1qUJTEeeVwuk3YKHJ4XtZVyWBLgkj?=
 =?us-ascii?Q?y+7l2elWDuaVb0QltPmFrzinT7MAEJuDyjEvtjAJDyBJYR6P0zpClMQdwqol?=
 =?us-ascii?Q?kBBSeewi4tW7jYJlB4OP7/XvkiLLz9LBXS2c62st3NTm0xyDIVg70PuMBKef?=
 =?us-ascii?Q?nxh/O809Kjh6h/4bmQjfyCzoNivUdgbr9QPKVtKNmVU923PAMYtK3gqYxZiD?=
 =?us-ascii?Q?/fpFp4MO00PxwUIlmVdV0SovC011iuLMf5HIbXNBDpnMx5yYC4gA8gY6lIWv?=
 =?us-ascii?Q?qTMHME2k3KJCzg/PfWa8yr+u+dZycvYXxh2j4FxyhxpAN2FqEjrMEHt1a48W?=
 =?us-ascii?Q?Fb4/6kHK236ufrt1Riav5HC9VsQmn4XRy/dlla01rWXCpp1c/KC3ZNABjsor?=
 =?us-ascii?Q?TFH1/NEE1s/2SFMVwtXG0OGDodESS5QrVd8U0mFEnOG4hrtXpeOy//xEv9UX?=
 =?us-ascii?Q?AQBSTjmOQfdSyipij2k0o9QZjJjOMGsxqqlte9qDXC2InSXICsYv3yu5CQ5Z?=
 =?us-ascii?Q?A4bOwYUO+z8mANOOzZpshrA4czHiRn/lR/AVLU8pRxzTGD0yQ7CtaA7pjvMO?=
 =?us-ascii?Q?bb+YmSadkNr4p8JVaiaZYqCYuy0BVSZckiZB8FTpViCsyJFhAtwDiZYLkdTL?=
 =?us-ascii?Q?5CbC1efKgy8/IbtraHmJAq2A7Ju2lcd51i3YUHPv15t03Hv90RDHE+d0sF6O?=
 =?us-ascii?Q?si3FfRrm3bUhXx6rr/1LO911K3dUFWhYNpItMa9yV6bNqnCzni2BZ8b0/W+R?=
 =?us-ascii?Q?mS5N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a7d405e-a0ae-453f-88db-08d89804597e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 03:26:12.1161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h/VSoKtZI1d1V54y3qG5dsGa0QO4EUoEOD0YD/nWLXU/2Dwbr+2848oNPc0oZspSvhz1ipu/nA50SkdlkNtr3/aPAuY2knfxYIRKSWoHgko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7123
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/3/20 08:26, Christoph Hellwig wrote:=0A=
> The request_queue can trivially be derived from the bio.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Reviewed-by: Hannes Reinecke <hare@suse.de>=0A=
> ---=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=

Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63652C4167B
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 03:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2980C22519
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 03:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgLDD0W (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 22:26:22 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:5679 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgLDD0W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 22:26:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607052381; x=1638588381;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=rQsvjltla/RzjugCImDnv2IKAWbQBv/Y1blShSNFhz8=;
  b=Ue66IsITa7rADjxiXAqAb6LpdDR62B37fVuYHM2UcaZStgjf23gGhVKn
   E0hhXatnE4J1kiFXxrHO9bYQO63lc5wFYiXMdW/p2VT3PRfqf2UEG+CE8
   cgfRRblJlD+stXRpNAkpK0xhyAuD/x/R9y2JRSXLlcC9Z3LJl0aq8VBGK
   yCXzev7QioBO/4nr0U8ZZ3/1+wKTBpC98Dnzg4jdRm0BK94AXVvHrRIJo
   QJhUjjVD6T5pJ7PiXFPVWBAwughlSZ1fFNPS06A+8L323TVlvsYJbUkpA
   KFRi8ynL4qVoRbyXc8IC/mKHDime0SypzSN4xzxpzgVZFEkn02MaZv50e
   Q==;
IronPort-SDR: 6TGqd9cAtoI0X0rqu4rpcy2W49ELch59T+vmvjtopV+C/V0Slpm+T3P4KQrfcqaDoPWnVBV1UX
 8+9xOmuAevHhXQBtAMs19alemOboOvwW/4MVfYNZgNRSL/dc+7avcOOUc3/GAdwkQWg1a4kQBW
 ulcz9ZIB1YEPtudBaSNWWP0510bnfS2DnbmAm7AfiLwlFtJNEJ+yIJ+Iht7g6790BgagE2KOdo
 dEMbPI7UbxdiguL8+OB+zCcl93s/DrqRLSGJWTW/eYuj3MxxuM5LmGmSMtB/Otxf/cSMNr4wYQ
 DV0=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; 
   d="scan'208";a="158871639"
Received: from mail-cys01nam02lp2052.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.52])
  by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 11:25:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKYeCt+/jZ1OVT2+7acLVdR+8nDprdwL19dnmSm1/JtQIuHH87hqS+LCigSqntOik1vscNOYgo8c2kclkTOkJxW2jGyWyyNdv4YAiEkRgwhC2BMkHS4iSwXGfCnUejgKA0gLPva3qA7LorSjlwQXCNwJpE2O074o3R+8+2PO9iMkN7NmmKa27ao68ByYoQ6zLvmAwtvVBTB6Dbx1v1EIr+4ymlTA919Tv4IVlDajiS3QDQVi5z66wycs6rUJuxArNXgydis1UrgcRLg+5G7RY7GCXT9N4hwPbtV/Mi3OCn2pQLU9sDlKBcGts+o/2qwL6LM5eG7x38qD2g/2ZJ3hgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQsvjltla/RzjugCImDnv2IKAWbQBv/Y1blShSNFhz8=;
 b=KSxwY0plDrofAcFAidCkjbaioxIPHHlyXEpRfEldzr4XdutchwZdhinDy7173D2Umz9FOiJ7HiSCSAieO9n7zX8GfgQ7GlK2Jv41bDdcjBT8hX+mCPFD734ItyqoXROJ7frmzHSzO0jg7fLUUkn8D3NlblDJDKRoMUPWEDjzigx+9xJGlKtD43B9b2K91AbH+5lloPg4HH/3yu9fXJtQBgbClS3YXmi7psH6ZfNeLZBJ7OqFgVSpZRO9jWU7pZ3iv7gO3zthsPPFbZ+zOoY+JlRVpHOs+C2bCFx+c634ml9Vijfi9oURFLpU/Iyg6R9bD+8n7RtoYI12gdybRykSTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQsvjltla/RzjugCImDnv2IKAWbQBv/Y1blShSNFhz8=;
 b=UZ5T5Ddlx5GKlRzvZiEoXl7JDZf/eNijUwpZeN7Ww7x0SEDQAlKJn7X52ku1ekxxvxKw+v+GNYVyZ0cJgLveN4vyJXSSlC8D8MxQQzIHPfL+0G78P5zooDE/V086SeOp4GplL5ZL9Y0f+uzy2EEelK6lXkZUcMeCNA7CUh1MFyg=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB7123.namprd04.prod.outlook.com (2603:10b6:a03:227::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 03:25:15 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031; Fri, 4 Dec 2020
 03:25:15 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Tejun Heo <tj@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/5] block: remove the unused block_sleeprq tracepoint
Thread-Topic: [PATCH 1/5] block: remove the unused block_sleeprq tracepoint
Thread-Index: AQHWyZDC35x3z2bn6UGINOM1pHH38A==
Date:   Fri, 4 Dec 2020 03:25:15 +0000
Message-ID: <BYAPR04MB4965C0AF4B7461309062FD6186F10@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201203162139.2110977-1-hch@lst.de>
 <20201203162139.2110977-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cb39fcb0-b1eb-492b-9beb-08d8980437a4
x-ms-traffictypediagnostic: BY5PR04MB7123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB7123671F1214CC854F1B554586F10@BY5PR04MB7123.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:901;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yb4iqdoIqWnojrHlcMuIADml8F6IiLKFSLGoIihyLkEFFg08Jpo5JzUgqgukjXh7HNuMmyNaxYCJZF/agR424dUdG9FSQdh8KiLak0gwhPoG3Qh/pABLsCoZjp1Fi/+9ZHTYjLN/TnY/Lvp78+rxZnVXBMb/F3d21/wbbDyhaexHWuyTSnuLVdZvPJSvJKhGyDqTy9T5KxRRyPasx+VoFXSr5RXhDqdrOcGrC+4k2RU8X9F16cGnM0qBF1HJ7t0BVVRgBsS9H/Mq4Upi/kc/3C1PEFhwQdOicaTnQ4mAUJ0Nq8+tBAyeWihV7OfDK/d9hFWYCcaHoFZ+JOnnt0+2MA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(66476007)(66446008)(66946007)(64756008)(186003)(66556008)(4744005)(4326008)(54906003)(316002)(110136005)(26005)(2906002)(7696005)(33656002)(6506007)(86362001)(71200400001)(53546011)(5660300002)(76116006)(52536014)(8676002)(8936002)(55016002)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?PG+wyrnBE/vHz/CUfpCUYs+lj1LPsqrBMOMkT2EK7wkl5UwykT7+aiG/Addm?=
 =?us-ascii?Q?U5bVBanNe5hK65DCWrVVCDfEYlwbHwrmCTsyD5d00TZGmy305kZhEJLnuiwa?=
 =?us-ascii?Q?DnaTuq3PhGRY27wGgPt55POvu0PUa2kc+rxTFa/FMqI/7Ty5lt416ZP3x51i?=
 =?us-ascii?Q?EbQIshE6HnKhnAbYeJwucAav7nnJLwA2cwovgLDuGMXMGUq1T4AdgsO6s2MM?=
 =?us-ascii?Q?E6ejjosqMb4V0rdKRjeu7ffoeyKE00m84rJ7xKkD0qgwVL0gnFezSgmJIafJ?=
 =?us-ascii?Q?a3g0mxj/KcDGvLjOEOvzkviiAHBiun5msx7HvxiPKqrv3E/q8GhS/5CtmcwI?=
 =?us-ascii?Q?RRI7E4nTlUw4qPnrBju/YdNv/L2+devfBWV3mCi8l0DuWW0V/eZWbH2vt3Zy?=
 =?us-ascii?Q?z5WeLAHxU4daSkEloI81eVn/zHDONrkZA44PQCWJ/BB7A/+Y0oo6HKEBawG+?=
 =?us-ascii?Q?Vyomulbbo4FzQl64UmS0+JWoBlfILF87GrEqOUH5uy+2aFKYMN1zRtsxQNZp?=
 =?us-ascii?Q?2FlSuUeiM8KN3cVXDj3/ff58HrW1x2GkI/zre4YhBwuuc0yaNYnxlEn+3q3E?=
 =?us-ascii?Q?W0joT88bzAmBkp6LpO3XDUPCmRnCB7f9ySzYEI9/yJI+DZ5xh6wsLhNnIFZ5?=
 =?us-ascii?Q?CkppSSSQTVL/Oi1lB/wBOgvUeUytaVDKREZnJQgWeaziHQx23k71Gsf76uH7?=
 =?us-ascii?Q?VkzsBmtwVxb9G4abaiS8IXtxxsWJy/+ieCcHrQiszz5gXOoRriVx3GHystXU?=
 =?us-ascii?Q?arKkRDexY5eNnCdIAKoiwjA6GSjKZMle7BER0uwUMO+OZeeGMbcYxEBaxqCa?=
 =?us-ascii?Q?jHNhH4SITe8pFLTi5kWNbfMQ/3WvoGc/kq9KxnyhCqvPh6ceyRxOrdXCVtIx?=
 =?us-ascii?Q?OxwVGonbEKPhJKXdI5bGU2tRMEbB2vwcvqiNSCwKFuemM/mdneHb1262Nqrc?=
 =?us-ascii?Q?TLh1q0ypEEMuM/1I+SN+2Z2aj0tCA9FEMeVlHv9y9ANxxWTK0nrCfYGmJptl?=
 =?us-ascii?Q?sIwn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb39fcb0-b1eb-492b-9beb-08d8980437a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 03:25:15.3031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fjwqt6qsefY0V+LSrT+gbch7JJEWoXDsqdVq041pnYaj2vsWGuGRR3cbJ7/HrbCGyl+cmedvCIkg4P7NDLT0Q40VhFUfnofxNBrEAY05pvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7123
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/3/20 08:24, Christoph Hellwig wrote:=0A=
> The block_sleeprq tracepoint was only used by the legacy request code.=0A=
> Remove it now that the legacy request code is gone.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Reviewed-by: Hannes Reinecke <hare@suse.de>=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=

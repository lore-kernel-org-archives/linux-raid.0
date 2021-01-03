Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6DFC433DB
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jan 2021 23:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A46820784
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jan 2021 23:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbhACXOZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jan 2021 18:14:25 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64216 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbhACXOV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jan 2021 18:14:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609715661; x=1641251661;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ab0kb5LZ+w9RwFWSB55qvoKF9JDyVMoDbVEAnL2FQLY=;
  b=O5cX3HDMlgWR4KOHMSzQVG/xe1D+H/5TWG4WFLcph+tjYbgYc5RnND+J
   8x6fXtaAKUGLjb2NHwt9R3tJlBSCASdmoU4WOby6fZoDPWJd/+ZREusSb
   rdCVFaMYywl4fVRq9y0yS7WqpaEFbhswB5CCeOplkcWp1SMYAFOwbE19s
   j/T9dxMFS9z1OhuZ2DNCLdPvzKBtKxfp62US/CbHURX0q0ZylyqkrLYpP
   Rq8ufvpokclFImum18e1jLMcnGFIW5mLdPcODtJpt44x48lSXOrJR7xp6
   +qTJXAIc1tyvf2iAkRuucGJdCHuISlaVJv5x+kz9ZYuLk6pRkHjJnV19u
   w==;
IronPort-SDR: ix4I4ViaQhlRwSbxKpQr155lohJS61922tKx59scDaTCELuhUFQg68aQe9K/O5kO9/JwzZI6et
 H3CKRS/pODO+rwu/bNBAPGfK4JYTBwErY5f/AWLcSojl//AdzRFfM07vPzqCHggVwHAsCgzWpu
 JHSDy69QylAHgERp2wb//QvsRzPHNuig6C0p+rlbaCZoIKX+V5wFBY2eZrJ/rVyUosueCK03z7
 90RmCSYMy/vxrmM5GaTjNSlkRorDzNoPW1hJw41Ccc0s22LbgkZ44SfsipEBIwgHtt98BTGPjP
 Jb8=
X-IronPort-AV: E=Sophos;i="5.78,472,1599494400"; 
   d="scan'208";a="157644129"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 07:13:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cInmzeP2RcBsonSuqMUWCuDpy2zdnzCWCIG9dtL1Kygw8cROPeupCMvUodCvbR8yMTd2ZR9DwwCQfQy+V2wdFTVBUNio4KiqBwuOhMj5Dt7ArkrKbPAYHeIjtjBzbUc6hjTV3uK6gBz05isGbmZOwTQMgSkRkui0HsdpqKiReyE0JTf3+tDU6yhqmu/8Rp5L9VmMgX6Mx2rJhVrpP23kmBbUiWGoc3/Fc0mVFszNVbuvzDQ3wCQhqVqYuCbJpIngIfVdZxN6rLnjBnk8Ym3tGIhWYSsIsVKAaG70cfNov8lTcgXPi8ooY9RlgX+rrfanA6SpbjU/ZCUXfLvByk+Vfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzqZ/iiwg19MsdDZX1w1G3URkGbEFlUzZ7S5VxGsSE0=;
 b=V12T3aybJKd6WjEh2vzZtgvSJ2V1qNfq5BQWLm+7CORjC7evJ6xzYhsbhQovTZHHWA4+ER8hDn9aZ1vF5/v2acR3vCKG/hHUA/zyjU8pSiy/AcKSf1NgKlvWg2T7RsZQZW6z1HSDLnv1xaSodCGTNWOz0ELiyPmK74FMjS+4orrlFDT4BAN7CfZvVuV2xpb+d9U8x2H7TX15TvwYWJ4+JoTRxSBlEe6yBQeeffz6m2csCUJs8Jr6kvy5h1BAAkLSvlT4b1X4hnXQ5yhinEoO9viJWZm9iVF+Cqx9Sw4YoSH/v80u/Upx9exjFGHxdyGhZt7LBzkDo7yStxtWQ+LIMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzqZ/iiwg19MsdDZX1w1G3URkGbEFlUzZ7S5VxGsSE0=;
 b=0JVU4Ga2ZxtFr/owbWfmEUsm4yy+bdLHNvP+XKl1OdEaGSWSKiIaKrxLfiL6Uykfr4EWVTojbxSDa2ARSFJzaCRwTl/TvazNOFvaUrkgVD8ImPEjCHJ7hd/rFUcxLMhIe3BuQqPViZPGgNkRHJZEGzau+rSqUdksvWTdcD9PvWU=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB4643.namprd04.prod.outlook.com (2603:10b6:208:4c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Sun, 3 Jan
 2021 23:13:12 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024; Sun, 3 Jan 2021
 23:13:12 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Arnd Bergmann <arnd@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Song Liu <song@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm zoned: select CONFIG_CRC32
Thread-Topic: [PATCH] dm zoned: select CONFIG_CRC32
Thread-Index: AQHW4hk3MoWMUn1z2kOBENbDHLE7zw==
Date:   Sun, 3 Jan 2021 23:13:12 +0000
Message-ID: <BL0PR04MB651478B53B0D808BC1C557ABE7D30@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210103214129.1996037-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:4d2:96cc:b27d:4f9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dcf0a944-d935-4b7c-104f-08d8b03d24ae
x-ms-traffictypediagnostic: BL0PR04MB4643:
x-microsoft-antispam-prvs: <BL0PR04MB4643BB72E81F068A8D3EB216E7D30@BL0PR04MB4643.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AVpDQq84GWyrVmbEU/odaPd3bOKQeaIqI19nDgM1MNX9mlE1X6e+b62JMrL/i3BdN0w8zp0BkHha+1j+2g7TUHFIHROmww0SI+8xdgkQbj/WJFGniFBFo4FT8VdD9fILrlJRBaIZLShaxNSQzOZ/CotCGLFWz01IEza3yTt1QK7xTpW+qKeHifBvbmesWiEdpHCQ/jw/I8R52AmVLphxZThKuDmEgZrs0fcL1KbbdjUA7YBKrPPtE/ZyzhYkBRKkFe1K3c8uirXEoreaeNVQG5uXS4GY8oSHvgRhKssPkEPYVmCDPS/qWMQnWLR9phxzmZ0zDenIyidWFtVX5LEloF+OwRhjoAt2meA7c58kw19daQqt5TVC+XHPU69Uu2gMFlKD4uSLY28gBGNBh+a/Mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(376002)(366004)(396003)(316002)(52536014)(64756008)(66476007)(110136005)(5660300002)(8936002)(7696005)(66946007)(76116006)(6506007)(53546011)(2906002)(91956017)(66556008)(7416002)(86362001)(66446008)(54906003)(186003)(33656002)(8676002)(55016002)(9686003)(4326008)(478600001)(83380400001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XuBcuqftDGm4qs+Nt1qGUa9lQGRW/x66oQRiR8bfYij4ut3G3KbEfMOPb3YA?=
 =?us-ascii?Q?y4mK+htE4QuA7nUf1syxYObydmbYG96vmZaQLm/kW+vbQ9851Rde3fbZEIyd?=
 =?us-ascii?Q?aVzIh+7LBPYwDwnCryTL8Kx8tpg2/p5LfBn4W+M7Ko6SLPZaJK38mr1e1DBe?=
 =?us-ascii?Q?GwQjTAvpogEoxHkZiXm1ihTDeQSqcPQRkOJ2lQ3fYc0hOyoNc00MOd0yy6pW?=
 =?us-ascii?Q?kVk+edEVsLsLzNexcWTIVB5C0xKedn/vEIO0DUptM5RIJN99KehGY0DnbXq5?=
 =?us-ascii?Q?64e+Ru9LvqpR5rCzA1xwMrB/C/0bffGVoPQpz9DXx5siilJ4uAi9Q+1zSc6F?=
 =?us-ascii?Q?niwfxrdGxXJnnzWJZbGyNtwF5sEK5fBxsed01hnsnSjjXXbxnrfZo+SZUo3L?=
 =?us-ascii?Q?Xzyqpaf2UPUiSZ/dVyT7YmF7IuflzKCFoRAwMeKBqMcCN2FNmYTJjIF8sefP?=
 =?us-ascii?Q?ZiSvE1dmxgsgoyumaddhTkUA/7BxcVS9hKNWR3dTfTnEVchY47fOFZ47Ak1l?=
 =?us-ascii?Q?e6/zX9G8bHbMi6ZHn2/8edEgfZPIt030H0yXcrSkx0YX0hV6WquzzzcbDIuA?=
 =?us-ascii?Q?lc2WqeSe1R4In3tRNGbS0efX+N3HyR24/+OvJGTPt8BhtTqmQgLRjUGGfb6w?=
 =?us-ascii?Q?NH2FhoVWdMyQcAEIYP4T++vZCJrpNzzkKfmR+8u6saND8bw7T+wZ0QMu0lBG?=
 =?us-ascii?Q?YswigN6zLZN1uBUxnLnFdtpUj4SkWiDvYetGifTJcaY4zy3kUhqG8REc/r5n?=
 =?us-ascii?Q?Y9ahDpnvI6vl7R2lybRfwpJ8BbsGUsaF/vHGIDVg2WF66qjtygnXf/BHg+pd?=
 =?us-ascii?Q?/1ZJGqQAmY/sVSCjAJhRs4wi1+kGgNtpa7sv5gmHB6kwXIdvesqL49iyaFtf?=
 =?us-ascii?Q?Ow8p4zL3RQ/NMrCOPde8RRhEgzVUbVtVmCorjkLDxKP/pSzHdual3s1Yg4Ll?=
 =?us-ascii?Q?sASLpbcKiriX8ztzjuJQPoD7MpLBu7vVi61RL0YjU+L947H1Fo4Tawba6glN?=
 =?us-ascii?Q?jc1uObxW5e/U9thzxS19SxzGLS2xsmVNV7Z2hhXFnEs5PRknm+aHsPLP8W2E?=
 =?us-ascii?Q?UukPQhzW?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf0a944-d935-4b7c-104f-08d8b03d24ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2021 23:13:12.6511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oW+Xs+2hgAMM+c/LEG4Jw049dHHjNgf0gc4rq7vK8Wny8tCCsTLOMv2bpWvluYBQRkz3/1TBWulrdEst7b0gOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4643
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2021/01/04 6:41, Arnd Bergmann wrote:=0A=
> From: Arnd Bergmann <arnd@arndb.de>=0A=
> =0A=
> Without crc32 support, this driver fails to link:=0A=
> =0A=
> arm-linux-gnueabi-ld: drivers/md/dm-zoned-metadata.o: in function `dmz_wr=
ite_sb':=0A=
> dm-zoned-metadata.c:(.text+0xe98): undefined reference to `crc32_le'=0A=
> arm-linux-gnueabi-ld: drivers/md/dm-zoned-metadata.o: in function `dmz_ch=
eck_sb':=0A=
> dm-zoned-metadata.c:(.text+0x7978): undefined reference to `crc32_le'=0A=
> =0A=
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")=
=0A=
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>=0A=
> ---=0A=
>  drivers/md/Kconfig | 1 +=0A=
>  1 file changed, 1 insertion(+)=0A=
> =0A=
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig=0A=
> index b7e2d9666614..a67b9ed3ca89 100644=0A=
> --- a/drivers/md/Kconfig=0A=
> +++ b/drivers/md/Kconfig=0A=
> @@ -622,6 +622,7 @@ config DM_ZONED=0A=
>  	tristate "Drive-managed zoned block device target support"=0A=
>  	depends on BLK_DEV_DM=0A=
>  	depends on BLK_DEV_ZONED=0A=
> +	select CRC32=0A=
>  	help=0A=
>  	  This device-mapper target takes a host-managed or host-aware zoned=0A=
>  	  block device and exposes most of its capacity as a regular block=0A=
> =0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

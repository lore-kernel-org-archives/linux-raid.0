Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C65C64E8A
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 09:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CECA20C56
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 09:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgLCJEJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 04:04:09 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:41378 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgLCJEI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 04:04:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606987252; x=1638523252;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=trhOyce+41V76x7poY7tzK2SB/pQzzL4YXBn+84jvqM=;
  b=F41O4tclLkNKg/y65XA9hN5L2KkqRl0K5iycS+RGnHWKzkWzRYhhedRE
   kg3ueKizVxvQXTvXKNs6zoaEzz3aj2zgdnriB1HUVmW0UiaT8bkqy9Tp6
   7fAx6ujfMo0NELEKl188Gj1Sul25R87+KVIaokWfasdUukgZF13Aw2bw2
   Uw/WVvrrJL6aAilYmIIRnSaW16BuYm+tYGw7xsxASLbl6LbrnPBHQyVGZ
   psSF0100LsRkRCyTITn307z/vRi1levDZwXJ30l12lCiHiV6ftB2LPlbf
   1DqsQd2xjLRFqmvwJFNgcwrovaBagYBKzXrGe5aq7zTmNg2/b8g5pG4VA
   Q==;
IronPort-SDR: /xaIun1MX7pwirgd2wVgHeTRt9jpQQUvg0rFDJ/7UDHUE4Uf/LKyaWXJn3VeRt0QmigvBovPDi
 ofCHHzfoCdyDOJF5X94HSVOuYx8vDc8liHGeeUOfQ/oH1ockR3jxMLYvSJObu5L1VjHZ8dii2F
 0JG8tTlUPowRC9ra/21qN/7HhFEaqSrYUE+JCNICMY3SIWi81ASOqylz6v8ckMEyMp7HLpqWlC
 +tsP1BU86TGQdw7JUiPrcE4O5deKQuVxljk4nml8aT3LDKuItoFbIQCtXyWw16tEpuHiKnFL4j
 PYg=
X-IronPort-AV: E=Sophos;i="5.78,389,1599494400"; 
   d="scan'208";a="257939590"
Received: from mail-bn8nam08lp2045.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.45])
  by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 17:19:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/newenwaqp9607i8cMjoNpW91V0F4AdHbossT0FqsP9zyzbi+xjTkIEe23vgRiGj0ImwpT5nXt+q5+oIi6CF5v19KHMstNhO796b5j9fPtM2eewdXTq+LDAbleiuq6WJp1H8K+UK4kpHb8+g/gWgP2ADZm1fnNRUpO7mBZ8MMV5+WCWDTK5kRkladQNY57e9BTtvT8P89DDOE3YV1HolrtJYTLwftlXpr66BogxHihOMgaoUv/nudosWda+Gt0rsYaRwPgKvweFesn9qcTFnYyMMS23rEc5V6tSdl883lBAgEZ9eV7lgMnBFxbce+P27/suOyhsOj684dHhhkBuBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raz9IgFK28JiYyOUCeygPLPDXy5BtfiWqUSmJjxjUeA=;
 b=AtL/RXu76crtX6vOOfwl4nQrpeqMpWNYYhPZvgaiMxTwouhPJA/7mDw5Es1xRy0aZc4nAou68sp8vXpxyq+m78TfvNsV+VTh/LfTMteUOYhiVxRlrUnFj/YiGOYpCgb/x20Yc5DuuVwTSAmAxgGCXF6EY7zj58xns/lX6zlOOCqAH1l62hwo5zaPsr+yLm8EiIA0QbmrpUlVLoqSmAA7MasLAkFOkkhG/Cc4ZdlMjt9RZilOGgRkrvBPdMwqXlQesbgljFH7uGOQqte045My6YnD7mGGra4iBbwiYLA8tnMF+qCFfNxFoxoA45CDjFjntiOZA2XCahrKGPypZJmRWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raz9IgFK28JiYyOUCeygPLPDXy5BtfiWqUSmJjxjUeA=;
 b=RVsGKZdA6SRYcYo7o+JfNfnvKxR/TlDm5I/3OYZdmodEvqJ2fSlL7kYDpTvuNtr/VfCLa2gfkOhvZ4JC0sNCDVMmdb7lwu7Zyzvako4210MHuCQgAeI3G/qfNewQWtt6rjYjTgIm85lNnJ73daQMOCV4qBTNrM1exMGD4YvVhf8=
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
 by CH2PR04MB6854.namprd04.prod.outlook.com (2603:10b6:610:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Thu, 3 Dec
 2020 09:02:58 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a]) by CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022; Thu, 3 Dec 2020
 09:02:58 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 4/5] block: remove the request_queue argument
 to the block_bio_remap tracepoint
Thread-Topic: [dm-devel] [PATCH 4/5] block: remove the request_queue argument
 to the block_bio_remap tracepoint
Thread-Index: AQHWyVMYnJFmCt1NHkWKCNqf/y7nEA==
Date:   Thu, 3 Dec 2020 09:02:58 +0000
Message-ID: <CH2PR04MB65229B3EE2DBB2BDD215EEA9E7F20@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201130175854.982460-1-hch@lst.de>
 <20201130175854.982460-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9249a803-9606-4da3-2824-08d8976a3b30
x-ms-traffictypediagnostic: CH2PR04MB6854:
x-microsoft-antispam-prvs: <CH2PR04MB68540A0E133BD2A6FA23C9A7E7F20@CH2PR04MB6854.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:61;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ISM7PcOGfuj5JDvIahkwEnO3OJ3UWojj8drM933QjYfCm+HR0vBCXk1fFpj2WDaEX/ZCubNNu5D1queJ2pAxOGz9nVF4XADpbSXjq57d95iHskEvj8nL2jjTG3SGuR1LDFzXS0u04wyA5TusfW5MurAZ6pvvyqrKo7OIPztP0sjCYIpwtj+R8MaQxGliRdozNytPkUfiCpCAF3EOf3avDmOb5gDBIkaxV1Kg0Byo39dynV8Zah5ckkfa1zl4Oeqx3GdGylDgzRL1Abf5zKiNKnR16OWHBSEALHFJadTY/sqZ2PQsFatyrxrFmkhkWhyH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6522.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(66946007)(8676002)(316002)(2906002)(66556008)(64756008)(76116006)(55016002)(66476007)(186003)(66446008)(478600001)(26005)(91956017)(54906003)(110136005)(33656002)(83380400001)(6506007)(4326008)(71200400001)(86362001)(7696005)(5660300002)(9686003)(8936002)(53546011)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?O5fkxDnMJ17LwcWVVrsMdDsCOA7m1Y1DWCHiJC5tuNEfOo1tt4mzhjldaVAv?=
 =?us-ascii?Q?UbhLyAp4AjBk2JWEkLCO7mt7Hc6qEqSKs979T9HlhDcsC+bQ0ASYNQGHNR7f?=
 =?us-ascii?Q?Xgl9+5T0jkhjujj7jIjtyrYLAvN0GxGQVvVY+8v4XYdUNwQdhKUYyN82rcxF?=
 =?us-ascii?Q?lWQLJLFWm4H+o5zafXZ/KFikYFN5gv2hKNdEvX4q72eZDNl448C5ohVQxmRx?=
 =?us-ascii?Q?bQGXlkYlIYGdm0HxTH09Wjf84HhwAa7kpe0jXsqvZIRN/W0b1ysuGQQ2FuO7?=
 =?us-ascii?Q?zUThSvptJimepGwLSaXzX3bCyWl6+Tgih6lkPaZPpMWiuwcQRYvGAPZl5Eyc?=
 =?us-ascii?Q?I2iyu903PvAZYdKM+mTtsGTSpi1OmNzbS7nN8wfy1dCiaGCCa94P1KgZ2sM7?=
 =?us-ascii?Q?V7H/cqTeLZwT43gsCjT2abGSbXwSZLuOn8pwa3iuTWjrw5mgyxaHaO2JWU/1?=
 =?us-ascii?Q?z2oJPhL0uxnHJgQRuBfXJfj5lLdVJtdNNRke4FfmQsgMYOnhWOuA1e7tT3mu?=
 =?us-ascii?Q?4akmkOJL96ro5MSsiNQTSrUS8EGMzFTWVEM8Jw+QHWhdZxcwLKyClukbJEa2?=
 =?us-ascii?Q?Cl4ZIc6MCyoBXS9I7J3zzUHnp3P9R5cNkcZNcA0XfgqjZfABQ7hGMuoZs0rS?=
 =?us-ascii?Q?LDX4wTkFI9Hgp8WN5dl6aaalbL6Sk7Wpw70hqROpEnNpY6uvBjPiKSPjuwzV?=
 =?us-ascii?Q?w2gZGMLlz4yEgkZorw8gS8TuNkL2cmDKucfJ91Sram5T7/PhaJcFYCxBNGGp?=
 =?us-ascii?Q?dVsbivjPIva16tDnRr/0Mw0NeuitS2ghkEV4qQDiuZiwmOBP1gcnEFnVpz/F?=
 =?us-ascii?Q?0ALWKqnzK7VCnGkdKW0+fIm8WNG64CqSM7QEJbLnWlFTK38mvqKeCqMn00Vy?=
 =?us-ascii?Q?EFLIM+FApmzhMIM1aEoarhy4gPpJQnGr5rtQLhS2x+w0Bb5dX15dw8ZrQF8z?=
 =?us-ascii?Q?hD2/8MoK6xYOA2w0WGAI/9oxaKNyKG3OJ8EJmECZveSwvCw5gLhyBf+8WK58?=
 =?us-ascii?Q?8s7s?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9249a803-9606-4da3-2824-08d8976a3b30
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 09:02:58.7338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xo02l5EUbcA2GYEqD/yKWJimF5Vk+2t32idcr1aSMC+vYuBP3TR3lj8obQypFP07jQuMiBs8rvCXsj2aS/Bbfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6854
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2020/12/01 3:09, Christoph Hellwig wrote:=0A=
> The request_queue can trivially be derived from the bio.=0A=
> =0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> ---=0A=
>  block/blk-core.c              |  2 +-=0A=
>  drivers/md/dm.c               |  3 +--=0A=
>  drivers/md/md-linear.c        |  3 +--=0A=
>  drivers/md/md.c               |  5 ++---=0A=
>  drivers/md/raid0.c            |  4 ++--=0A=
>  drivers/md/raid1.c            |  7 +++----=0A=
>  drivers/md/raid10.c           |  6 ++----=0A=
>  drivers/md/raid5.c            | 15 +++++++--------=0A=
>  drivers/nvme/host/multipath.c |  3 +--=0A=
>  include/trace/events/block.h  |  8 +++-----=0A=
>  kernel/trace/blktrace.c       | 14 +++++---------=0A=
>  11 files changed, 28 insertions(+), 42 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-core.c b/block/blk-core.c=0A=
> index cb24654983e1e4..96e5fcd7f071b6 100644=0A=
> --- a/block/blk-core.c=0A=
> +++ b/block/blk-core.c=0A=
> @@ -758,7 +758,7 @@ static inline int blk_partition_remap(struct bio *bio=
)=0A=
>  		if (bio_check_eod(bio, bdev_nr_sectors(p)))=0A=
>  			goto out;=0A=
>  		bio->bi_iter.bi_sector +=3D p->bd_start_sect;=0A=
> -		trace_block_bio_remap(bio->bi_disk->queue, bio, p->bd_dev,=0A=
> +		trace_block_bio_remap(bio, p->bd_dev,=0A=
>  				      bio->bi_iter.bi_sector -=0A=
>  				      p->bd_start_sect);=0A=
>  	}=0A=
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c=0A=
> index 9a5bd90779c7c4..5181907dc59537 100644=0A=
> --- a/drivers/md/dm.c=0A=
> +++ b/drivers/md/dm.c=0A=
> @@ -1276,8 +1276,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)=
=0A=
>  		break;=0A=
>  	case DM_MAPIO_REMAPPED:=0A=
>  		/* the bio has been remapped so dispatch it */=0A=
> -		trace_block_bio_remap(clone->bi_disk->queue, clone,=0A=
> -				      bio_dev(io->orig_bio), sector);=0A=
> +		trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);=0A=
>  		ret =3D submit_bio_noacct(clone);=0A=
>  		break;=0A=
>  	case DM_MAPIO_KILL:=0A=
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c=0A=
> index 98f1b4b2bdcef8..68cac7d1927823 100644=0A=
> --- a/drivers/md/md-linear.c=0A=
> +++ b/drivers/md/md-linear.c=0A=
> @@ -257,8 +257,7 @@ static bool linear_make_request(struct mddev *mddev, =
struct bio *bio)=0A=
>  		bio_endio(bio);=0A=
>  	} else {=0A=
>  		if (mddev->gendisk)=0A=
> -			trace_block_bio_remap(bio->bi_disk->queue,=0A=
> -					      bio, disk_devt(mddev->gendisk),=0A=
> +			trace_block_bio_remap(bio, disk_devt(mddev->gendisk),=0A=
>  					      bio_sector);=0A=
>  		mddev_check_writesame(mddev, bio);=0A=
>  		mddev_check_write_zeroes(mddev, bio);=0A=
> diff --git a/drivers/md/md.c b/drivers/md/md.c=0A=
> index 0065736f05b428..c555be0a8dce78 100644=0A=
> --- a/drivers/md/md.c=0A=
> +++ b/drivers/md/md.c=0A=
> @@ -8591,9 +8591,8 @@ void md_submit_discard_bio(struct mddev *mddev, str=
uct md_rdev *rdev,=0A=
>  	bio_chain(discard_bio, bio);=0A=
>  	bio_clone_blkg_association(discard_bio, bio);=0A=
>  	if (mddev->gendisk)=0A=
> -		trace_block_bio_remap(bdev_get_queue(rdev->bdev),=0A=
> -			discard_bio, disk_devt(mddev->gendisk),=0A=
> -			bio->bi_iter.bi_sector);=0A=
> +		trace_block_bio_remap(discard_bio, disk_devt(mddev->gendisk),=0A=
> +				      bio->bi_iter.bi_sector);=0A=
>  	submit_bio_noacct(discard_bio);=0A=
>  }=0A=
>  EXPORT_SYMBOL(md_submit_discard_bio);=0A=
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c=0A=
> index 6f44177593a552..e5d7411cba9b46 100644=0A=
> --- a/drivers/md/raid0.c=0A=
> +++ b/drivers/md/raid0.c=0A=
> @@ -571,8 +571,8 @@ static bool raid0_make_request(struct mddev *mddev, s=
truct bio *bio)=0A=
>  		tmp_dev->data_offset;=0A=
>  =0A=
>  	if (mddev->gendisk)=0A=
> -		trace_block_bio_remap(bio->bi_disk->queue, bio,=0A=
> -				disk_devt(mddev->gendisk), bio_sector);=0A=
> +		trace_block_bio_remap(bio, disk_devt(mddev->gendisk),=0A=
> +				      bio_sector);=0A=
>  	mddev_check_writesame(mddev, bio);=0A=
>  	mddev_check_write_zeroes(mddev, bio);=0A=
>  	submit_bio_noacct(bio);=0A=
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c=0A=
> index 960d854c07f897..c0347997f6ff73 100644=0A=
> --- a/drivers/md/raid1.c=0A=
> +++ b/drivers/md/raid1.c=0A=
> @@ -1305,8 +1305,8 @@ static void raid1_read_request(struct mddev *mddev,=
 struct bio *bio,=0A=
>  	read_bio->bi_private =3D r1_bio;=0A=
>  =0A=
>  	if (mddev->gendisk)=0A=
> -	        trace_block_bio_remap(read_bio->bi_disk->queue, read_bio,=0A=
> -				disk_devt(mddev->gendisk), r1_bio->sector);=0A=
> +	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),=0A=
> +				      r1_bio->sector);=0A=
>  =0A=
>  	submit_bio_noacct(read_bio);=0A=
>  }=0A=
> @@ -1517,8 +1517,7 @@ static void raid1_write_request(struct mddev *mddev=
, struct bio *bio,=0A=
>  		atomic_inc(&r1_bio->remaining);=0A=
>  =0A=
>  		if (mddev->gendisk)=0A=
> -			trace_block_bio_remap(mbio->bi_disk->queue,=0A=
> -					      mbio, disk_devt(mddev->gendisk),=0A=
> +			trace_block_bio_remap(mbio, disk_devt(mddev->gendisk),=0A=
>  					      r1_bio->sector);=0A=
>  		/* flush_pending_writes() needs access to the rdev so...*/=0A=
>  		mbio->bi_disk =3D (void *)conf->mirrors[i].rdev;=0A=
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c=0A=
> index b7bca6703df814..a6f99fa0b32cfc 100644=0A=
> --- a/drivers/md/raid10.c=0A=
> +++ b/drivers/md/raid10.c=0A=
> @@ -1200,8 +1200,7 @@ static void raid10_read_request(struct mddev *mddev=
, struct bio *bio,=0A=
>  	read_bio->bi_private =3D r10_bio;=0A=
>  =0A=
>  	if (mddev->gendisk)=0A=
> -	        trace_block_bio_remap(read_bio->bi_disk->queue,=0A=
> -	                              read_bio, disk_devt(mddev->gendisk),=0A=
> +	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),=0A=
>  	                              r10_bio->sector);=0A=
>  	submit_bio_noacct(read_bio);=0A=
>  	return;=0A=
> @@ -1250,8 +1249,7 @@ static void raid10_write_one_disk(struct mddev *mdd=
ev, struct r10bio *r10_bio,=0A=
>  	mbio->bi_private =3D r10_bio;=0A=
>  =0A=
>  	if (conf->mddev->gendisk)=0A=
> -		trace_block_bio_remap(mbio->bi_disk->queue,=0A=
> -				      mbio, disk_devt(conf->mddev->gendisk),=0A=
> +		trace_block_bio_remap(mbio, disk_devt(conf->mddev->gendisk),=0A=
>  				      r10_bio->sector);=0A=
>  	/* flush_pending_writes() needs access to the rdev so...*/=0A=
>  	mbio->bi_disk =3D (void *)rdev;=0A=
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c=0A=
> index 39343479ac2a94..3a90cc0e43ca8e 100644=0A=
> --- a/drivers/md/raid5.c=0A=
> +++ b/drivers/md/raid5.c=0A=
> @@ -1222,9 +1222,9 @@ static void ops_run_io(struct stripe_head *sh, stru=
ct stripe_head_state *s)=0A=
>  				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);=0A=
>  =0A=
>  			if (conf->mddev->gendisk)=0A=
> -				trace_block_bio_remap(bi->bi_disk->queue,=0A=
> -						      bi, disk_devt(conf->mddev->gendisk),=0A=
> -						      sh->dev[i].sector);=0A=
> +				trace_block_bio_remap(bi,=0A=
> +						disk_devt(conf->mddev->gendisk),=0A=
> +						sh->dev[i].sector);=0A=
>  			if (should_defer && op_is_write(op))=0A=
>  				bio_list_add(&pending_bios, bi);=0A=
>  			else=0A=
> @@ -1272,9 +1272,9 @@ static void ops_run_io(struct stripe_head *sh, stru=
ct stripe_head_state *s)=0A=
>  			if (op =3D=3D REQ_OP_DISCARD)=0A=
>  				rbi->bi_vcnt =3D 0;=0A=
>  			if (conf->mddev->gendisk)=0A=
> -				trace_block_bio_remap(rbi->bi_disk->queue,=0A=
> -						      rbi, disk_devt(conf->mddev->gendisk),=0A=
> -						      sh->dev[i].sector);=0A=
> +				trace_block_bio_remap(rbi,=0A=
> +						disk_devt(conf->mddev->gendisk),=0A=
> +						sh->dev[i].sector);=0A=
>  			if (should_defer && op_is_write(op))=0A=
>  				bio_list_add(&pending_bios, rbi);=0A=
>  			else=0A=
> @@ -5468,8 +5468,7 @@ static int raid5_read_one_chunk(struct mddev *mddev=
, struct bio *raid_bio)=0A=
>  		spin_unlock_irq(&conf->device_lock);=0A=
>  =0A=
>  		if (mddev->gendisk)=0A=
> -			trace_block_bio_remap(align_bi->bi_disk->queue,=0A=
> -					      align_bi, disk_devt(mddev->gendisk),=0A=
> +			trace_block_bio_remap(align_bi, disk_devt(mddev->gendisk),=0A=
>  					      raid_bio->bi_iter.bi_sector);=0A=
>  		submit_bio_noacct(align_bi);=0A=
>  		return 1;=0A=
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.=
c=0A=
> index 74896be40c1769..106cf5c44ee7ab 100644=0A=
> --- a/drivers/nvme/host/multipath.c=0A=
> +++ b/drivers/nvme/host/multipath.c=0A=
> @@ -312,8 +312,7 @@ blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)=0A=
>  	if (likely(ns)) {=0A=
>  		bio->bi_disk =3D ns->disk;=0A=
>  		bio->bi_opf |=3D REQ_NVME_MPATH;=0A=
> -		trace_block_bio_remap(bio->bi_disk->queue, bio,=0A=
> -				      disk_devt(ns->head->disk),=0A=
> +		trace_block_bio_remap(bio, disk_devt(ns->head->disk),=0A=
>  				      bio->bi_iter.bi_sector);=0A=
>  		ret =3D submit_bio_noacct(bio);=0A=
>  	} else if (nvme_available_path(head)) {=0A=
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h=
=0A=
> index b415e4cba84304..8fb89574d8677f 100644=0A=
> --- a/include/trace/events/block.h=0A=
> +++ b/include/trace/events/block.h=0A=
> @@ -450,9 +450,8 @@ TRACE_EVENT(block_split,=0A=
>  =0A=
>  /**=0A=
>   * block_bio_remap - map request for a logical device to the raw device=
=0A=
> - * @q: queue holding the operation=0A=
>   * @bio: revised operation=0A=
> - * @dev: device for the operation=0A=
> + * @dev: original device for the operation=0A=
>   * @from: original sector for the operation=0A=
>   *=0A=
>   * An operation for a logical device has been mapped to the=0A=
> @@ -460,10 +459,9 @@ TRACE_EVENT(block_split,=0A=
>   */=0A=
>  TRACE_EVENT(block_bio_remap,=0A=
>  =0A=
> -	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,=0A=
> -		 sector_t from),=0A=
> +	TP_PROTO(struct bio *bio, dev_t dev, sector_t from),=0A=
>  =0A=
> -	TP_ARGS(q, bio, dev, from),=0A=
> +	TP_ARGS(bio, dev, from),=0A=
>  =0A=
>  	TP_STRUCT__entry(=0A=
>  		__field( dev_t,		dev		)=0A=
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c=0A=
> index 3ca6d62114f461..405637144a0389 100644=0A=
> --- a/kernel/trace/blktrace.c=0A=
> +++ b/kernel/trace/blktrace.c=0A=
> @@ -993,20 +993,16 @@ static void blk_add_trace_split(void *ignore, struc=
t bio *bio, unsigned int pdu)=0A=
>  /**=0A=
>   * blk_add_trace_bio_remap - Add a trace for a bio-remap operation=0A=
>   * @ignore:	trace callback data parameter (not used)=0A=
> - * @q:		queue the io is for=0A=
>   * @bio:	the source bio=0A=
> - * @dev:	target device=0A=
> + * @dev:	source device=0A=
>   * @from:	source sector=0A=
>   *=0A=
> - * Description:=0A=
> - *     Device mapper or raid target sometimes need to split a bio becaus=
e=0A=
> - *     it spans a stripe (or similar). Add a trace for that action.=0A=
> - *=0A=
> + * Called after a bio is remapped to a different device and/or sector.=
=0A=
>   **/=0A=
> -static void blk_add_trace_bio_remap(void *ignore,=0A=
> -				    struct request_queue *q, struct bio *bio,=0A=
> -				    dev_t dev, sector_t from)=0A=
> +static void blk_add_trace_bio_remap(void *ignore, struct bio *bio, dev_t=
 dev,=0A=
> +				    sector_t from)=0A=
>  {=0A=
> +	struct request_queue *q =3D bio->bi_disk->queue;=0A=
>  	struct blk_trace *bt;=0A=
>  	struct blk_io_trace_remap r;=0A=
>  =0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

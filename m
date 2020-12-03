Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7182C64E7B
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 08:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 613822223C
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 08:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgLCI76 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:59:58 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6896 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgLCI75 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 03:59:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606985997; x=1638521997;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=jnzgJRZowk7ADagABoQRKBmUs3CMpGYrSbepNwMK0YI=;
  b=Zho17AQI6tHvLuLbyRu4t5q2otadb1fxJ0pIACgvDEkiY7OR/AgXKuaL
   FjUS9/+lKSBK877MeAQLWnvq2KimlvLZKJNKtlnuUcuPXHOgI85D6O7v9
   gXqYO4t2FVKqILRF0dXYNIgsYKyQwdQ+S2YEN3egoCv87D54CF0c4pOCw
   4cE3rSPTMenamhR12u+Xz5m0peXmU2mpWXeSyhaGWAHC45o048VgNT5RQ
   IPHNL/KAlXLg/DAfHXaEgeTl2dGb3hMc0foOwNni/Kqw6GmX7RQjk6ETC
   rPiG1VlMQmspdMTxHWB/aK/gr46VP4cAyiTF1YLbM+elZYncLb0rstKLv
   g==;
IronPort-SDR: A89q+U9d7gHLHlb2/gnpieIaA4/C7EafMMq9AmrPaq1m9JZ7CvDmuw2ZyzkPtAnuRsXGlwm9pl
 G9XJFtVG6FcKtZK9J61EtHnEv0tnTAVCiFOCXAQOs/TJJYDkHDsbf8ViRbwjtkVx+UOvuajO8V
 Y3HFwFmsLebYZ6QcU9QPYTcYSL/9ebasH1jgXCEUDiA6aTFku/Na8Brdy/8Dmwfp556RAa22xK
 WL0Ccr/nlUQzruyCOFYivb3CVnsbuT7QzMB9BGmpzuD9NMZPtNBpY1COHr4gsUvH+9cV3DMMOW
 Qpw=
X-IronPort-AV: E=Sophos;i="5.78,389,1599494400"; 
   d="scan'208";a="158712209"
Received: from mail-cys01nam02lp2055.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.55])
  by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 16:59:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyZBLgQJvTxEzARfrUjy0hvwck3L7AiwrzOHpo8o0VyfuG3hmhK0eKNcV0xzNxd325FimQV1FCVqt9zjKxDmA8bLsh3NfWPEkZzlTlzoclr3WI5/rw541Se27A9ictIlYAbOGcTMfbrqblQeuUouCf6Vr1Sq0vyHaR/ukryATQ08EjINUWnjV3LS4dtoKEP8diuFZXq7ZEVjYe4AHcCx0105bgU8LzyzIi7RQqTNGPkfVIpqy9o1P5EKmDlM7PBPgl5M5h0B2V+bkAtDt3lPHaWuV3yCvUhA4LbE5EoQ8kQTA76AmchBqlj55t9jrd7AKXwBJzrkRFwT5yL3LaM5Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zk/ZK9l0ZSX6IvmpXoM3jnqYvLOxPSZfFklt5O2yk2Q=;
 b=S4E6bGzgqJpt8DLrsoMYJ57yW0RP2oTWKD+buMcoD1U8n/7mSU8lxa7ZVB51CFYGdd/6+6cVre96hQ0liTzACcWyOhTFsDsfukHYmEDaN9ST4LSBT+txVSr07EJZhietF3q9yZlYgTNNunnEaBtCfhLrhPwX3I/KuPZRkdMeVcoI05/ieh+lsuJ61vmyHt1Ml/ikNpXiuN/C3lwdq4SR66z+xbkC52aADcGMmeuQeQdsvJOxhvfgGYcreB7t/NRAlqu+NpZQT1TVovPkzFAx7XJkJYhVmS8sLoeT8DQxOrmR5OZgzk6MYdJyYqw3yZEzV+QUv+L4cV436EIJF/UshA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zk/ZK9l0ZSX6IvmpXoM3jnqYvLOxPSZfFklt5O2yk2Q=;
 b=AQn1ufnyasxaNzg9R4CQZ2PLW22gndjdU/jGFAyiB7VCpwcbPlVipXcUlZz9s/sOALdWdfwkqUbWbJeAcB8mzehVwikEKoYyTFVEL4dwRX5++BSsabCc2pOB8rzIkezoSitTtqNIHemGTzP4vZrghASB4q/Fvzt2X2EfmYL9Sc8=
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
 by CH2PR04MB6540.namprd04.prod.outlook.com (2603:10b6:610:64::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Thu, 3 Dec
 2020 08:59:11 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a]) by CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022; Thu, 3 Dec 2020
 08:59:11 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH 3/5] block: remove the request_queue argument to the
 block_split tracepoint
Thread-Topic: [PATCH 3/5] block: remove the request_queue argument to the
 block_split tracepoint
Thread-Index: AQHWx0PymADY0+Bc+UC0df567qTLQg==
Date:   Thu, 3 Dec 2020 08:59:11 +0000
Message-ID: <CH2PR04MB6522398D22B2B461B4037CDDE7F20@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201130175854.982460-1-hch@lst.de>
 <20201130175854.982460-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 977b3004-bc52-48b1-475b-08d89769b3a5
x-ms-traffictypediagnostic: CH2PR04MB6540:
x-microsoft-antispam-prvs: <CH2PR04MB6540FA81CDC0B009DC22E6E0E7F20@CH2PR04MB6540.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SAx+vaEfnngHDRW+DyIWeOpFYEeDPA1OGRCwVDgYz90Qsd3HQm96RgM27j7wBi+QJIiRCOuwAj5shFnEtN1h9eCIzh9IJWdn//Zlwz70uGKyfTw78pmm7H2BTyUnAgcsF6Ndj1QN/yaQyx+cxqkRg5LcMoDJHYxTm7hGY0UUitcA9t4/2iHhYpoQjBYqwymQ18beJp+JybPDwhNaZCMCEWwOcbFuZrReJ+tkVtLDnhupiegi37AMU4eammGsms9wqGz9z5T/BeLKoGkOBp2Ukkx5od3csI3s6ruwfoMk4fwLiECdTL/GYf2kU+g+slL6Sz015M96B4kq0fnxeHAPbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6522.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(8676002)(33656002)(6506007)(9686003)(53546011)(52536014)(83380400001)(64756008)(55016002)(66946007)(66446008)(66476007)(5660300002)(66556008)(478600001)(91956017)(8936002)(186003)(7696005)(76116006)(86362001)(316002)(4326008)(26005)(71200400001)(54906003)(2906002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NoAx3Q/6ksfnUTRpMxmJuQWQfz7yyyR9Unx/EppqPHvRnqucpAwont6iUxiv?=
 =?us-ascii?Q?8XGRGCcA3GeqHVl3Ye8hvubEwGY1kKbfv6QvFd3DmO01eTIuAip9VGUVQUgD?=
 =?us-ascii?Q?KdqM0z1E1Bs1jdBmxGc+OvHnF/PadRUzf/D4aRsLW7pghkbDzTnvAJ//gcKC?=
 =?us-ascii?Q?2TSWyPQSulPfTh4cCge4omw1UzOt01+UhX5XiUUn/LkaYFZ1hoMPrYR6MHJR?=
 =?us-ascii?Q?9eBbGpTYKV+YEg3SdqX6pwX60eDf0+uOtlj61EIvJGEN7PWBq1/C9j4GQJa8?=
 =?us-ascii?Q?YelgOqP6vhMwsXAW4o/SIpIeCYfRmqI9xgE8pIvk4+kVKQn13xOXsqrxoG7E?=
 =?us-ascii?Q?D4G4ZQS4DSci7bStAoC9XPq6eLGgwC4iRQ5fNfCLXBRZ6WImpTE+pLwX2xbt?=
 =?us-ascii?Q?6IzrZ2Wbkwj/e8gxYETQSvW34mslQw7OTyjgvaz4q8dSPn6b6l7ancX5rfL+?=
 =?us-ascii?Q?cmRSTW1blDlNjfN23y08FYOP1tmH8R+rwmuiPbfRxiC7KSyrS9RMRFMePpck?=
 =?us-ascii?Q?0RtkFAI3KDpURRoBNIkSZtiA7fHyPKoE5YLROn9sZSMuyNUzIrtHDZakEsEm?=
 =?us-ascii?Q?EKrp3GIaouoN8nDuiWH1zxzOc4JFDGjL96n9J3tRXvZ/xPnJHkX7mFgoMcyb?=
 =?us-ascii?Q?gSG3J0/JG0rJ5TIuQCP+SmvuQvMc3GwmSw6hSWZngROZGjD7gPVMVcv2QwS/?=
 =?us-ascii?Q?gtRYjfOFTZxoPpwBavVRsSKj573Lou1XU3YRVKdvcCs8jl5Fn8uUd2wCnOZY?=
 =?us-ascii?Q?z8bYEc5KwkiWFb+8mDUW9e84Dg6olT/caIPYgRbKDv0tKOexvuYz/nmRWdGp?=
 =?us-ascii?Q?oAR5HbUCj9z5hoAvstff3VQuXlFKwf/dUa65MJppCb9x9/+ls0a7NmXA7fTa?=
 =?us-ascii?Q?vVCkCxPG8ixz8j2Er7XuhQZQEzY6SZnxx9gA2I6iF5g30pwOYpmaU/E6my1Y?=
 =?us-ascii?Q?TEpSUZulm4BxTqL5+ow6O71uFMEtgut8Z7KaW5SChPPnkSK4VbUn1ZkZFmy3?=
 =?us-ascii?Q?zPLn?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 977b3004-bc52-48b1-475b-08d89769b3a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 08:59:11.3014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YTreMKDag7kuw35THM2ZtVCOMWUELMkeAVvqpPeAZy3CABanCFkdRgSijD6vrD1aiW5LzICnDMy2fdPR5o+2VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6540
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2020/12/01 3:09, Christoph Hellwig wrote:=0A=
> The request_queue can trivially be derived from the bio.=0A=
> =0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> ---=0A=
>  block/blk-merge.c            |  2 +-=0A=
>  drivers/md/dm.c              |  2 +-=0A=
>  include/trace/events/block.h | 14 ++++++--------=0A=
>  kernel/trace/blktrace.c      |  5 ++---=0A=
>  4 files changed, 10 insertions(+), 13 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-merge.c b/block/blk-merge.c=0A=
> index 1a46d5bbd399e3..4071daa88a5eaf 100644=0A=
> --- a/block/blk-merge.c=0A=
> +++ b/block/blk-merge.c=0A=
> @@ -338,7 +338,7 @@ void __blk_queue_split(struct bio **bio, unsigned int=
 *nr_segs)=0A=
>  		split->bi_opf |=3D REQ_NOMERGE;=0A=
>  =0A=
>  		bio_chain(split, *bio);=0A=
> -		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);=0A=
> +		trace_block_split(split, (*bio)->bi_iter.bi_sector);=0A=
>  		submit_bio_noacct(*bio);=0A=
>  		*bio =3D split;=0A=
>  	}=0A=
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c=0A=
> index ed7e836efbcdbc..9a5bd90779c7c4 100644=0A=
> --- a/drivers/md/dm.c=0A=
> +++ b/drivers/md/dm.c=0A=
> @@ -1612,7 +1612,7 @@ static blk_qc_t __split_and_process_bio(struct mapp=
ed_device *md,=0A=
>  				part_stat_unlock();=0A=
>  =0A=
>  				bio_chain(b, bio);=0A=
> -				trace_block_split(md->queue, b, bio->bi_iter.bi_sector);=0A=
> +				trace_block_split(b, bio->bi_iter.bi_sector);=0A=
>  				ret =3D submit_bio_noacct(bio);=0A=
>  				break;=0A=
>  			}=0A=
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h=
=0A=
> index 506c29dc7c76fd..b415e4cba84304 100644=0A=
> --- a/include/trace/events/block.h=0A=
> +++ b/include/trace/events/block.h=0A=
> @@ -411,21 +411,19 @@ DEFINE_EVENT(block_unplug, block_unplug,=0A=
>  =0A=
>  /**=0A=
>   * block_split - split a single bio struct into two bio structs=0A=
> - * @q: queue containing the bio=0A=
>   * @bio: block operation being split=0A=
>   * @new_sector: The starting sector for the new bio=0A=
>   *=0A=
> - * The bio request @bio in request queue @q needs to be split into two=
=0A=
> - * bio requests. The newly created @bio request starts at=0A=
> - * @new_sector. This split may be required due to hardware limitation=0A=
> - * such as operation crossing device boundaries in a RAID system.=0A=
> + * The bio request @bio needs to be split into two bio requests.  The ne=
wly=0A=
> + * created @bio request starts at @new_sector. This split may be require=
d due to=0A=
> + * hardware limitations such as operation crossing device boundaries in =
a RAID=0A=
> + * system.=0A=
>   */=0A=
>  TRACE_EVENT(block_split,=0A=
>  =0A=
> -	TP_PROTO(struct request_queue *q, struct bio *bio,=0A=
> -		 unsigned int new_sector),=0A=
> +	TP_PROTO(struct bio *bio, unsigned int new_sector),=0A=
>  =0A=
> -	TP_ARGS(q, bio, new_sector),=0A=
> +	TP_ARGS(bio, new_sector),=0A=
>  =0A=
>  	TP_STRUCT__entry(=0A=
>  		__field( dev_t,		dev				)=0A=
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c=0A=
> index 7ab88e00c15765..3ca6d62114f461 100644=0A=
> --- a/kernel/trace/blktrace.c=0A=
> +++ b/kernel/trace/blktrace.c=0A=
> @@ -970,10 +970,9 @@ static void blk_add_trace_unplug(void *ignore, struc=
t request_queue *q,=0A=
>  	rcu_read_unlock();=0A=
>  }=0A=
>  =0A=
> -static void blk_add_trace_split(void *ignore,=0A=
> -				struct request_queue *q, struct bio *bio,=0A=
> -				unsigned int pdu)=0A=
> +static void blk_add_trace_split(void *ignore, struct bio *bio, unsigned =
int pdu)=0A=
>  {=0A=
> +	struct request_queue *q =3D bio->bi_disk->queue;=0A=
>  	struct blk_trace *bt;=0A=
>  =0A=
>  	rcu_read_lock();=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

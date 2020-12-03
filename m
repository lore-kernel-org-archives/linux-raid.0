Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FB1C63777
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 08:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCCC62223C
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 08:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387518AbgLCI5k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:57:40 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6760 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgLCI5j (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 03:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606985859; x=1638521859;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=o+XV/p1TamGwQi383NwL7Wdq9qBX3avCUND0SAB+BP4=;
  b=NE7JHkivrz4lPDjypXbrplmkvUvGcteu5oZMJck0vUotA75k4iz5r5O7
   dGq6CrWGexMJ5bM2eTXXlzH07YFhsrrsvgfADN+1rwh/1r1yHzhvq41x6
   K3+Fb2xkuW/TcRA9UEY9uPadyEDTGMxXS7gQbPH9uSE3txOBqdqN86BYt
   kmrvfckCOttwxdgDZUONuJeWhYvbnBI15lJ2SKjEe7/VBPS9f7aeaffw5
   ISwEooHTpD17r+SkyTu1HKSjCDDDWTTDfNAzhyGxcIZtVS4Q1GAKCX3ba
   4qLo0RqqK+hsEpqyuQKAd1IbS2CGs27w5bDLGJ0mz5VAta+sAMy4vQl4Q
   Q==;
IronPort-SDR: p1RO2tQol/vd/+1qkqLBRjdDbAC9/xDPJdaOFDCtkZDKFVZaBlaOA7VD7FKkYQOagDW6LvMs6K
 UfjwMNEFVUJHgFrfkm76AzKDDLtw5NvRZYNe41AgqvHLNtgYpb/6Ld0PaFuy1H6FZ0b4r/2JVW
 f+qu5hFB96EC2YqzE7J5+bH2tZfn1kUBBUXyMr144RYvTTj0Lu2HdjMyd1QSJDrj5F5J+wj/ho
 lrePQzIUcd6SzBp/2kocPxNenCXN2+KaIUPJEiAKavNcGrSK2taiLVYCd8mbypI88NeyFCu8jX
 md4=
X-IronPort-AV: E=Sophos;i="5.78,389,1599494400"; 
   d="scan'208";a="158712084"
Received: from mail-cys01nam02lp2052.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.52])
  by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 16:56:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0NOD00WXFftAy7q2MgIc7P6UV8mbUb9eMpF5LeUSrfxU2ez9w/v7zXA+boQAlyGcFFHONyej4+PnAQ4s20t/RKpfcjLMPNRPnP7pzDW/VrsfOBb/fL/jNAVD5rvkYN5UM026iQc5HaV2Dm6i+GvCYsJAau8IlAw59FfDqJw3Go+rP37PrzTLDSU5XDi2rsH3595A/AGkk1x3ANTTme2wy5CTeTtVduwFVKcQRj8BlkQAUTqUaRRVD/HHdfoRANcRrNm4E7V57oDT6Z0WXubPChWVDoO9w5vs1M4Y3CqOmerKfONwdQtsOH9tov6xDf1Nk7470M9J5d2sXtOZz7P6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDtcARyfl85GMvcUtDVNoLYbGsO+OLaVVog5nGAVx0c=;
 b=TStP+B5m8awGK/ZyHp7OLgIki1Rj27hsHZ0vv8XuAY4S13UFXzgoDTqOELPfQ2qPdnCWpsM/+HgChxeY6tZm1Z8zJDyA+Fv8mCmlnUG5FCObFtXGLMxFD1GEByw3pLklv0s8p/4HQSKAJRAJigPgqmXSIcLbKXgBE3nzKibJSAzh2PwbFQmKQsp54v1NvH0WK1pjJ8Vf1Mf5Q1juCZ5VIYjDFOG3YDLcJfwYPgUyie3KtLPh8vKquEnSpMQyPhu6eGvLdTVjSTvlVRScrdC9ebu/nSNWJ/6wTnG2VYSowxl96nDyjwb15yknijeIKKr6PlFVxyOpLSX54akVPtJo8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDtcARyfl85GMvcUtDVNoLYbGsO+OLaVVog5nGAVx0c=;
 b=Rylkb6l5hKm6tuIKN7g7fzQH+YUY68/xMASLonnufRJPsA2bo6JoZvlswpkMVUVHfsctpLux7xtn2l3Fcw7VU2jI+HnIvL2bUl5tL52+y+apMXGQ9BOW5qKDwg/pqNLO8UtIcVgzOb8XO6zxsjdMcdhSrY7SaLVIAxKoh9k4Zkk=
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
 by CH2PR04MB6540.namprd04.prod.outlook.com (2603:10b6:610:64::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Thu, 3 Dec
 2020 08:56:29 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a]) by CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022; Thu, 3 Dec 2020
 08:56:29 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 2/5] block: simplify and extended the
 block_bio_merge tracepoint class
Thread-Topic: [dm-devel] [PATCH 2/5] block: simplify and extended the
 block_bio_merge tracepoint class
Thread-Index: AQHWyVIw3FSIo2anh0qVPOhlB5mpfQ==
Date:   Thu, 3 Dec 2020 08:56:29 +0000
Message-ID: <CH2PR04MB652293C0177F0CDFE68F44EDE7F20@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201130175854.982460-1-hch@lst.de>
 <20201130175854.982460-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ae48d95e-6bc1-4c2c-f0e1-08d897695352
x-ms-traffictypediagnostic: CH2PR04MB6540:
x-microsoft-antispam-prvs: <CH2PR04MB65407177C571E7F20CB1245CE7F20@CH2PR04MB6540.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NWPVIq+UClThYNiO8fke9JFHnCWgnJbxpPKL9bA0zZygYUdXEUvQosggRDhzMHEQbzoQBbJnrJ4rza501fJHX2sxyScIDlR7ioAB7QHoy2ztMNHt3LlRbsnFo9WBr9cxT3CgCanNAuZxUb43vxvACdJgB+gnK7anh65AsAWpGKwVq/jEMYVA/0ew0ZOGaoZF9HqY/5PxJXKUBZH32qBoE8AqtL1+SpySzn/LTe6135UwKBDnpNvuZqpFRsmMJVsUKTYwTVB5qMSgDK611oRxITRWxo7667CgJbMLVnPPny0+6z7l1zL4/YxqgJQZ5/Wk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6522.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(8676002)(33656002)(6506007)(9686003)(53546011)(52536014)(83380400001)(64756008)(55016002)(66946007)(66446008)(66476007)(5660300002)(66556008)(478600001)(91956017)(30864003)(8936002)(186003)(7696005)(76116006)(86362001)(316002)(4326008)(26005)(71200400001)(54906003)(2906002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xh3xZZMT6f1/5trqxENgoi3wVW386S3Bq3QMyJLUAUfHljYClzGjc8bhIRmB?=
 =?us-ascii?Q?wDybuF8LlviKHQhmltzKp0L1yovoYdAgLeHpDeBYPBm2lGTf34SYLtlZKAI1?=
 =?us-ascii?Q?qxG6DlXJfKo+TIuiTiJoOjMEV3waHbr4AOw9/qVBFK44Rv2Pf4H8TDMRkC1S?=
 =?us-ascii?Q?hcNRFa7iBVmtcvt8XHKzM7fPL/oCUlzOPU+LHqjif/ugUi/HVvkVe4cz8caH?=
 =?us-ascii?Q?6XiZ0FYRcGfN0pdqWAOwpJZo0zHdxpRbFpjxCE1NcSESFV/bhoB7OeDl855O?=
 =?us-ascii?Q?3B/MokMpZAGNjjgJkZch86WSGFSvKR1utwW+c0ZoVYGSm90RZKrWaDe/zWLK?=
 =?us-ascii?Q?TyimzJSU6CxXZg7GBXlAQIzcQVL3DZp5JyUO31SG3M0j5+oEZDqhQwvwx6pN?=
 =?us-ascii?Q?jac3b4FTZ+OsezPJnxS+lFA7G6f1CeN7sc2Kz1JyS2CJdyhPBUE7eBWT+5tm?=
 =?us-ascii?Q?GNV+RW1KeqaMpGyDPVsFCcVZV3cdB3jhADdOrltI+JQ2JhoJMfXW1D5gdznc?=
 =?us-ascii?Q?Z46dXcCmWmtsUs7TQWdMHkkExxP1xWvJZofhidlgwTm9kxGmz7xvqz7SyMRa?=
 =?us-ascii?Q?gzGdpjioQ9UDHRJhgY33ueN9+T9cHgYLxpcUQ6bkaJ5dpev6ho4scipGJ/5m?=
 =?us-ascii?Q?xzSTv1bILbf1BDNnssn1VBuoRBsnBAOl05HKPitJ3QaUDa/VcLI/2ym2RN8S?=
 =?us-ascii?Q?Qj5NiFylCMw1aY5ja6vIlTCuPMqlXm2GpMeUBTRdRrMGsxOB9PE6tIfgDR6K?=
 =?us-ascii?Q?EDq3liMKmrmgg3fEPmm9HMmifjzMkg/EqCXNG3nK/NWiVlTu5nd0k4xssfil?=
 =?us-ascii?Q?lUPu4z3maLUUMUW2AobekTQ10HYnAf+JMN0TCUHiKwMQ+8uowWVM/CEx/jjg?=
 =?us-ascii?Q?iHUjkz091HF4f7heD+RiDk1hpU1nWvW94G9H+zmvra3RX2eJ8eCG4ulqdCAY?=
 =?us-ascii?Q?KkuOAwTvhd9gaTm+C6X+KlTY/p4UUQuCqJujlyzkmBSOOQ4xGnl+Fc0HpGpe?=
 =?us-ascii?Q?FBoD?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae48d95e-6bc1-4c2c-f0e1-08d897695352
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 08:56:29.7234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ix7NPJ5xbpAcY2PhEec9Dx9hseilRxhdwMOXYgy+8XbVO887YCL91ONcdwqQXPh/NikJGe7h2MldK0LmqpVnXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6540
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In the patch title:=0A=
=0A=
s/extended/extend=0A=
=0A=
On 2020/12/01 3:06, Christoph Hellwig wrote:=0A=
> The block_bio_merge tracepoint class can be reused for most bio-based=0A=
> tracepoints.  For that is just needs to lose the superflous and rq=0A=
=0A=
s/is/it=0A=
s/superflous/superfluous=0A=
=0A=
> parameters.=0A=
> =0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> ---=0A=
>  block/blk-core.c             |   2 +-=0A=
>  block/blk-merge.c            |   4 +-=0A=
>  block/blk-mq.c               |   2 +-=0A=
>  block/bounce.c               |   2 +-=0A=
>  include/trace/events/block.h | 158 ++++++++---------------------------=
=0A=
>  kernel/trace/blktrace.c      |  41 +++------=0A=
>  6 files changed, 48 insertions(+), 161 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-core.c b/block/blk-core.c=0A=
> index cee568389b7e11..cb24654983e1e4 100644=0A=
> --- a/block/blk-core.c=0A=
> +++ b/block/blk-core.c=0A=
> @@ -907,7 +907,7 @@ static noinline_for_stack bool submit_bio_checks(stru=
ct bio *bio)=0A=
>  	blkcg_bio_issue_init(bio);=0A=
>  =0A=
>  	if (!bio_flagged(bio, BIO_TRACE_COMPLETION)) {=0A=
> -		trace_block_bio_queue(q, bio);=0A=
> +		trace_block_bio_queue(bio);=0A=
>  		/* Now that enqueuing has been traced, we need to trace=0A=
>  		 * completion as well.=0A=
>  		 */=0A=
> diff --git a/block/blk-merge.c b/block/blk-merge.c=0A=
> index cb351ab9b77dbd..1a46d5bbd399e3 100644=0A=
> --- a/block/blk-merge.c=0A=
> +++ b/block/blk-merge.c=0A=
> @@ -922,7 +922,7 @@ static enum bio_merge_status bio_attempt_back_merge(s=
truct request *req,=0A=
>  	if (!ll_back_merge_fn(req, bio, nr_segs))=0A=
>  		return BIO_MERGE_FAILED;=0A=
>  =0A=
> -	trace_block_bio_backmerge(req->q, req, bio);=0A=
> +	trace_block_bio_backmerge(bio);=0A=
>  	rq_qos_merge(req->q, req, bio);=0A=
>  =0A=
>  	if ((req->cmd_flags & REQ_FAILFAST_MASK) !=3D ff)=0A=
> @@ -946,7 +946,7 @@ static enum bio_merge_status bio_attempt_front_merge(=
struct request *req,=0A=
>  	if (!ll_front_merge_fn(req, bio, nr_segs))=0A=
>  		return BIO_MERGE_FAILED;=0A=
>  =0A=
> -	trace_block_bio_frontmerge(req->q, req, bio);=0A=
> +	trace_block_bio_frontmerge(bio);=0A=
>  	rq_qos_merge(req->q, req, bio);=0A=
>  =0A=
>  	if ((req->cmd_flags & REQ_FAILFAST_MASK) !=3D ff)=0A=
> diff --git a/block/blk-mq.c b/block/blk-mq.c=0A=
> index a2593748fa5342..13636458f32f1c 100644=0A=
> --- a/block/blk-mq.c=0A=
> +++ b/block/blk-mq.c=0A=
> @@ -2183,7 +2183,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)=0A=
>  		goto queue_exit;=0A=
>  	}=0A=
>  =0A=
> -	trace_block_getrq(q, bio, bio->bi_opf);=0A=
> +	trace_block_getrq(bio);=0A=
>  =0A=
>  	rq_qos_track(q, rq, bio);=0A=
>  =0A=
> diff --git a/block/bounce.c b/block/bounce.c=0A=
> index 162a6eee89996a..d3f51acd6e3b51 100644=0A=
> --- a/block/bounce.c=0A=
> +++ b/block/bounce.c=0A=
> @@ -340,7 +340,7 @@ static void __blk_queue_bounce(struct request_queue *=
q, struct bio **bio_orig,=0A=
>  		}=0A=
>  	}=0A=
>  =0A=
> -	trace_block_bio_bounce(q, *bio_orig);=0A=
> +	trace_block_bio_bounce(*bio_orig);=0A=
>  =0A=
>  	bio->bi_flags |=3D (1 << BIO_BOUNCED);=0A=
>  =0A=
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h=
=0A=
> index 76459cf750e14d..506c29dc7c76fd 100644=0A=
> --- a/include/trace/events/block.h=0A=
> +++ b/include/trace/events/block.h=0A=
> @@ -226,45 +226,6 @@ DEFINE_EVENT(block_rq, block_rq_merge,=0A=
>  	TP_ARGS(q, rq)=0A=
>  );=0A=
>  =0A=
> -/**=0A=
> - * block_bio_bounce - used bounce buffer when processing block operation=
=0A=
> - * @q: queue holding the block operation=0A=
> - * @bio: block operation=0A=
> - *=0A=
> - * A bounce buffer was used to handle the block operation @bio in @q.=0A=
> - * This occurs when hardware limitations prevent a direct transfer of=0A=
> - * data between the @bio data memory area and the IO device.  Use of a=
=0A=
> - * bounce buffer requires extra copying of data and decreases=0A=
> - * performance.=0A=
> - */=0A=
> -TRACE_EVENT(block_bio_bounce,=0A=
> -=0A=
> -	TP_PROTO(struct request_queue *q, struct bio *bio),=0A=
> -=0A=
> -	TP_ARGS(q, bio),=0A=
> -=0A=
> -	TP_STRUCT__entry(=0A=
> -		__field( dev_t,		dev			)=0A=
> -		__field( sector_t,	sector			)=0A=
> -		__field( unsigned int,	nr_sector		)=0A=
> -		__array( char,		rwbs,	RWBS_LEN	)=0A=
> -		__array( char,		comm,	TASK_COMM_LEN	)=0A=
> -	),=0A=
> -=0A=
> -	TP_fast_assign(=0A=
> -		__entry->dev		=3D bio_dev(bio);=0A=
> -		__entry->sector		=3D bio->bi_iter.bi_sector;=0A=
> -		__entry->nr_sector	=3D bio_sectors(bio);=0A=
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);=0A=
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);=0A=
> -	),=0A=
> -=0A=
> -	TP_printk("%d,%d %s %llu + %u [%s]",=0A=
> -		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,=0A=
> -		  (unsigned long long)__entry->sector,=0A=
> -		  __entry->nr_sector, __entry->comm)=0A=
> -);=0A=
> -=0A=
>  /**=0A=
>   * block_bio_complete - completed all work on the block operation=0A=
>   * @q: queue holding the block operation=0A=
> @@ -301,11 +262,11 @@ TRACE_EVENT(block_bio_complete,=0A=
>  		  __entry->nr_sector, __entry->error)=0A=
>  );=0A=
>  =0A=
> -DECLARE_EVENT_CLASS(block_bio_merge,=0A=
> +DECLARE_EVENT_CLASS(block_bio,=0A=
>  =0A=
> -	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),=
=0A=
> +	TP_PROTO(struct bio *bio),=0A=
>  =0A=
> -	TP_ARGS(q, rq, bio),=0A=
> +	TP_ARGS(bio),=0A=
>  =0A=
>  	TP_STRUCT__entry(=0A=
>  		__field( dev_t,		dev			)=0A=
> @@ -329,116 +290,63 @@ DECLARE_EVENT_CLASS(block_bio_merge,=0A=
>  		  __entry->nr_sector, __entry->comm)=0A=
>  );=0A=
>  =0A=
> +/**=0A=
> + * block_bio_bounce - used bounce buffer when processing block operation=
=0A=
> + * @bio: block operation=0A=
> + *=0A=
> + * A bounce buffer was used to handle the block operation @bio in @q.=0A=
> + * This occurs when hardware limitations prevent a direct transfer of=0A=
> + * data between the @bio data memory area and the IO device.  Use of a=
=0A=
> + * bounce buffer requires extra copying of data and decreases=0A=
> + * performance.=0A=
> + */=0A=
> +DEFINE_EVENT(block_bio, block_bio_bounce,=0A=
> +	TP_PROTO(struct bio *bio),=0A=
> +	TP_ARGS(bio)=0A=
> +);=0A=
> +=0A=
>  /**=0A=
>   * block_bio_backmerge - merging block operation to the end of an existi=
ng operation=0A=
> - * @q: queue holding operation=0A=
> - * @rq: request bio is being merged into=0A=
>   * @bio: new block operation to merge=0A=
>   *=0A=
> - * Merging block request @bio to the end of an existing block request=0A=
> - * in queue @q.=0A=
> + * Merging block request @bio to the end of an existing block request.=
=0A=
>   */=0A=
> -DEFINE_EVENT(block_bio_merge, block_bio_backmerge,=0A=
> -=0A=
> -	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),=
=0A=
> -=0A=
> -	TP_ARGS(q, rq, bio)=0A=
> +DEFINE_EVENT(block_bio, block_bio_backmerge,=0A=
> +	TP_PROTO(struct bio *bio),=0A=
> +	TP_ARGS(bio)=0A=
>  );=0A=
>  =0A=
>  /**=0A=
>   * block_bio_frontmerge - merging block operation to the beginning of an=
 existing operation=0A=
> - * @q: queue holding operation=0A=
> - * @rq: request bio is being merged into=0A=
>   * @bio: new block operation to merge=0A=
>   *=0A=
> - * Merging block IO operation @bio to the beginning of an existing block=
=0A=
> - * operation in queue @q.=0A=
> + * Merging block IO operation @bio to the beginning of an existing block=
 request.=0A=
>   */=0A=
> -DEFINE_EVENT(block_bio_merge, block_bio_frontmerge,=0A=
> -=0A=
> -	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),=
=0A=
> -=0A=
> -	TP_ARGS(q, rq, bio)=0A=
> +DEFINE_EVENT(block_bio, block_bio_frontmerge,=0A=
> +	TP_PROTO(struct bio *bio),=0A=
> +	TP_ARGS(bio)=0A=
>  );=0A=
>  =0A=
>  /**=0A=
>   * block_bio_queue - putting new block IO operation in queue=0A=
> - * @q: queue holding operation=0A=
>   * @bio: new block operation=0A=
>   *=0A=
>   * About to place the block IO operation @bio into queue @q.=0A=
>   */=0A=
> -TRACE_EVENT(block_bio_queue,=0A=
> -=0A=
> -	TP_PROTO(struct request_queue *q, struct bio *bio),=0A=
> -=0A=
> -	TP_ARGS(q, bio),=0A=
> -=0A=
> -	TP_STRUCT__entry(=0A=
> -		__field( dev_t,		dev			)=0A=
> -		__field( sector_t,	sector			)=0A=
> -		__field( unsigned int,	nr_sector		)=0A=
> -		__array( char,		rwbs,	RWBS_LEN	)=0A=
> -		__array( char,		comm,	TASK_COMM_LEN	)=0A=
> -	),=0A=
> -=0A=
> -	TP_fast_assign(=0A=
> -		__entry->dev		=3D bio_dev(bio);=0A=
> -		__entry->sector		=3D bio->bi_iter.bi_sector;=0A=
> -		__entry->nr_sector	=3D bio_sectors(bio);=0A=
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);=0A=
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);=0A=
> -	),=0A=
> -=0A=
> -	TP_printk("%d,%d %s %llu + %u [%s]",=0A=
> -		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,=0A=
> -		  (unsigned long long)__entry->sector,=0A=
> -		  __entry->nr_sector, __entry->comm)=0A=
> -);=0A=
> -=0A=
> -DECLARE_EVENT_CLASS(block_get_rq,=0A=
> -=0A=
> -	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),=0A=
> -=0A=
> -	TP_ARGS(q, bio, rw),=0A=
> -=0A=
> -	TP_STRUCT__entry(=0A=
> -		__field( dev_t,		dev			)=0A=
> -		__field( sector_t,	sector			)=0A=
> -		__field( unsigned int,	nr_sector		)=0A=
> -		__array( char,		rwbs,	RWBS_LEN	)=0A=
> -		__array( char,		comm,	TASK_COMM_LEN	)=0A=
> -        ),=0A=
> -=0A=
> -	TP_fast_assign(=0A=
> -		__entry->dev		=3D bio ? bio_dev(bio) : 0;=0A=
> -		__entry->sector		=3D bio ? bio->bi_iter.bi_sector : 0;=0A=
> -		__entry->nr_sector	=3D bio ? bio_sectors(bio) : 0;=0A=
> -		blk_fill_rwbs(__entry->rwbs,=0A=
> -			      bio ? bio->bi_opf : 0, __entry->nr_sector);=0A=
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);=0A=
> -        ),=0A=
> -=0A=
> -	TP_printk("%d,%d %s %llu + %u [%s]",=0A=
> -		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,=0A=
> -		  (unsigned long long)__entry->sector,=0A=
> -		  __entry->nr_sector, __entry->comm)=0A=
> +DEFINE_EVENT(block_bio, block_bio_queue,=0A=
> +	TP_PROTO(struct bio *bio),=0A=
> +	TP_ARGS(bio)=0A=
>  );=0A=
>  =0A=
>  /**=0A=
>   * block_getrq - get a free request entry in queue for block IO operatio=
ns=0A=
> - * @q: queue for operations=0A=
>   * @bio: pending block IO operation (can be %NULL)=0A=
> - * @rw: low bit indicates a read (%0) or a write (%1)=0A=
>   *=0A=
> - * A request struct for queue @q has been allocated to handle the=0A=
> - * block IO operation @bio.=0A=
> + * A request struct has been allocated to handle the block IO operation =
@bio.=0A=
>   */=0A=
> -DEFINE_EVENT(block_get_rq, block_getrq,=0A=
> -=0A=
> -	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),=0A=
> -=0A=
> -	TP_ARGS(q, bio, rw)=0A=
> +DEFINE_EVENT(block_bio, block_getrq,=0A=
> +	TP_PROTO(struct bio *bio),=0A=
> +	TP_ARGS(bio)=0A=
>  );=0A=
>  =0A=
>  /**=0A=
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c=0A=
> index ced589df304b57..7ab88e00c15765 100644=0A=
> --- a/kernel/trace/blktrace.c=0A=
> +++ b/kernel/trace/blktrace.c=0A=
> @@ -906,10 +906,9 @@ static void blk_add_trace_bio(struct request_queue *=
q, struct bio *bio,=0A=
>  	rcu_read_unlock();=0A=
>  }=0A=
>  =0A=
> -static void blk_add_trace_bio_bounce(void *ignore,=0A=
> -				     struct request_queue *q, struct bio *bio)=0A=
> +static void blk_add_trace_bio_bounce(void *ignore, struct bio *bio)=0A=
>  {=0A=
> -	blk_add_trace_bio(q, bio, BLK_TA_BOUNCE, 0);=0A=
> +	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_BOUNCE, 0);=0A=
>  }=0A=
>  =0A=
>  static void blk_add_trace_bio_complete(void *ignore,=0A=
> @@ -919,44 +918,24 @@ static void blk_add_trace_bio_complete(void *ignore=
,=0A=
>  			  blk_status_to_errno(bio->bi_status));=0A=
>  }=0A=
>  =0A=
> -static void blk_add_trace_bio_backmerge(void *ignore,=0A=
> -					struct request_queue *q,=0A=
> -					struct request *rq,=0A=
> -					struct bio *bio)=0A=
> +static void blk_add_trace_bio_backmerge(void *ignore, struct bio *bio)=
=0A=
>  {=0A=
> -	blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE, 0);=0A=
> +	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_BACKMERGE, 0);=0A=
>  }=0A=
>  =0A=
> -static void blk_add_trace_bio_frontmerge(void *ignore,=0A=
> -					 struct request_queue *q,=0A=
> -					 struct request *rq,=0A=
> -					 struct bio *bio)=0A=
> +static void blk_add_trace_bio_frontmerge(void *ignore, struct bio *bio)=
=0A=
>  {=0A=
> -	blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE, 0);=0A=
> +	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_FRONTMERGE, 0);=0A=
>  }=0A=
>  =0A=
> -static void blk_add_trace_bio_queue(void *ignore,=0A=
> -				    struct request_queue *q, struct bio *bio)=0A=
> +static void blk_add_trace_bio_queue(void *ignore, struct bio *bio)=0A=
>  {=0A=
> -	blk_add_trace_bio(q, bio, BLK_TA_QUEUE, 0);=0A=
> +	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_QUEUE, 0);=0A=
>  }=0A=
>  =0A=
> -static void blk_add_trace_getrq(void *ignore,=0A=
> -				struct request_queue *q,=0A=
> -				struct bio *bio, int rw)=0A=
> +static void blk_add_trace_getrq(void *ignore, struct bio *bio)=0A=
>  {=0A=
> -	if (bio)=0A=
> -		blk_add_trace_bio(q, bio, BLK_TA_GETRQ, 0);=0A=
> -	else {=0A=
> -		struct blk_trace *bt;=0A=
> -=0A=
> -		rcu_read_lock();=0A=
> -		bt =3D rcu_dereference(q->blk_trace);=0A=
> -		if (bt)=0A=
> -			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_GETRQ, 0, 0,=0A=
> -					NULL, 0);=0A=
> -		rcu_read_unlock();=0A=
> -	}=0A=
> +	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_GETRQ, 0);=0A=
>  }=0A=
>  =0A=
>  static void blk_add_trace_plug(void *ignore, struct request_queue *q)=0A=
> =0A=
=0A=
With the commit message fixed, looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

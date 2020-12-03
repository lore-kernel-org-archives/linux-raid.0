Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CC8C63777
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 09:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C309E2222E
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 09:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388182AbgLCJHV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 04:07:21 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28815 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbgLCJHT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 04:07:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606986439; x=1638522439;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=wr7tP3gDLB4g6olmp2jctqgR6SfEOb0Gnv+73gBYVUQ=;
  b=TwIEi1X/hFy3uXWpgKOAwaTzBRakNF3psGdzSCvPT6BKLWpZdmzslPW/
   Js75dr0Nwy/DqiBXycxpC85pow1PAxB9zaEMEDWs43t/R7EBO/fxfDg42
   pvd4q+hcWbAUWqBn8AB+vsba6WNJEyEvZSDrkt1dKTkMNVvjww8px2Uc1
   +I6CMDy8UFIS7fEUeZ+P7kNJxyV1i6AfaGYRd1N7aUmOVbJ25NuIJw2VQ
   2qojnsHDzly03i1VLO1zF3g6iGDuj+iPuHdwQWMK/U634UEHUXB3GrUfb
   PxR6wj33rH17JZJ5Om6nfo2VZ1ZGQHi78gXQTemsBiPvNAqnLRjl8YaQu
   w==;
IronPort-SDR: RBccr5No0h8bAoQ5FtqzNVbBGi6+WP6nZ58ZGjqMcrt25TVyyDUwjOSjfwTZdPNuzdZTfiNVdH
 0DDfhmXjOSpKLGArHFMh8PSW2dyyW4Fv7O8LU/hs/8FS9tlso+0IKA0akrY7qfP4d/wLRPJp5w
 CQdyMqNsMDUL8CQiSEmK5Zrjkk7PF3M/RRso30bemqYFsRK3V0XSUPHraXZFh/PXtkd95cJ/H4
 sHr3uRbe//avXuJrvH8oTclskAX3Bv6wE4OHcgrq7fcv2VTHFGq/yCjsWRbGXI5FcDxIfHjEVv
 yGE=
X-IronPort-AV: E=Sophos;i="5.78,389,1599494400"; 
   d="scan'208";a="155445590"
Received: from mail-bn8nam08lp2043.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
  by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 17:06:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVQJFk6V7QAD/zQwOAN9VPi/e/MOvNUEJpn1Tg0BZJpidoDBjfJCDqEbyTjw0bmnk5JcZWxLORVZo4W6VGgGGa/q56tFV3CZa2SqIekhMO02b8Yp/AxjIk3bYZAi34kGJ4ab031n0Apz9N+0VSFGNj84qcbrg0L202QvXnii1z1A2eRUXUYW2q9gcxrKClmudCatcgrPd5zL5nScXMutPKrUjRDvcuEw7MjhOxzupOTcKLGExPRkxY20gqvXHOcFMglt4+IAhYrgJNCKEyAADrffDIsunKWaKlKslwEBNxEBCYK0Ws9cnqOUtdhUHU5idXV86tq1CWHkn4Yd6FkeRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QOwoqd6QD1X4zIcZjtKximOxy/TDdIHR+M+bdtMeHjs=;
 b=P9dphGFK5CDCjJw6MSHNs7DI8zuX+XZdybg5d9wsntKt9h5HL8zKaqxHobecaMmYl/nkx/XpPr5GYPFe2Nrit5CobkGZuHJeskhtj9YlAOvdRT4IyvQcN5t9k24WVoa8sN3ASf50c4GFejoeiyR/saI/9XFmlwfG1ED3FNIxcioVUtIDZNy4mSvqVNdk8XdGtkiShfUgrzIFS7TxiChOU4Tv3p+aB/0Dz8k8msg5NaMgZIa36++pZF6zTQ08IAU6V0HxlL+RENqvPYsFzK2QRm+QBpz0lSqHpKB7yAnWYZ0u0d/1KIfyullTvBhVL0S/a59UkRUK49bmYP2SI1l9IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QOwoqd6QD1X4zIcZjtKximOxy/TDdIHR+M+bdtMeHjs=;
 b=KOxi4NKqhUdLfBda+k6mf7fxx/PhUBW+2KkDHr5BWhWIt7gSbLuzkZYG/uvrM+MpAxeyJx7pDsWV1/JBusQat4Ww0Wgqt6DFJyoRXoCPwuqXNJdcJTbT8N6hVtpcgyYMdoLrcG/F8fafP14SsHxEL23ykz1o5WkjfP5azbkwOhE=
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
 by CH2PR04MB6854.namprd04.prod.outlook.com (2603:10b6:610:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Thu, 3 Dec
 2020 09:06:11 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a]) by CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022; Thu, 3 Dec 2020
 09:06:11 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 5/5] block: remove the request_queue to
 argument request based tracepoints
Thread-Topic: [dm-devel] [PATCH 5/5] block: remove the request_queue to
 argument request based tracepoints
Thread-Index: AQHWyVOLwVXcWje+hU6zvE+nFjfD1w==
Date:   Thu, 3 Dec 2020 09:06:11 +0000
Message-ID: <CH2PR04MB6522A9E5DC906CB816CA6150E7F20@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201130175854.982460-1-hch@lst.de>
 <20201130175854.982460-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 29d253d3-32c1-4711-2d95-08d8976aae46
x-ms-traffictypediagnostic: CH2PR04MB6854:
x-microsoft-antispam-prvs: <CH2PR04MB6854325359A2757C2E4AB656E7F20@CH2PR04MB6854.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HAGZwxzDCh+ZhLKClfp00kZxgfPohGl6rYt++pD0mXHFmK02wMt1xyKZfiraUxxJ3b2+KeORl3j0aZ5sVrhRifIL3Q5djo8th9wnVuuGSqn2GRaI/g0NYybJP30GQOIJxZpmHq/kStyJrQ8acSmF6iGXx+IrfDXKXyv/SPNIGnIoGHht6mCLfFTYPv6zaws8BPRjXtu/0ZjdzpeLdsKvM6vOdl+FVED49yYkr2nfO5JHtZ5nPL6SxrrUWkiNWMAi5iqG2OqkXFYvtpl6KLuLoFpUeOSfgh4Wzv5GuiIp2dGhDabT31rZZH4T+88cGg+hvafFYaR00444jWItfXp1gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6522.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(66946007)(8676002)(316002)(2906002)(66556008)(64756008)(76116006)(55016002)(66476007)(186003)(66446008)(478600001)(26005)(91956017)(30864003)(54906003)(110136005)(33656002)(83380400001)(6506007)(4326008)(71200400001)(86362001)(7696005)(5660300002)(9686003)(8936002)(53546011)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GiBbSdoH7CdTs2rXDc/lwdqLnecPpGQHY5tMGFK98pBDwqxcQfzUZclo8cfW?=
 =?us-ascii?Q?AcWkh71a20BYJ7ispAs8iDa/fWy5F6YYZ64kZEFb3/N2Pjd1l/IZITRC+qLe?=
 =?us-ascii?Q?WhyIQ3AivAM2XjSR/4f3QDsWnc2Tz7xufN0zxIiEYLX2P9MDq44GZLJZymib?=
 =?us-ascii?Q?vN80YI/Ur533HYC5WKUm+xsPwjoPbmrYWDSvmGP/46D5VDBmxT4cLMP/Bmq9?=
 =?us-ascii?Q?P8v+83f+9RnxNMAUGmV/jRZX21Ekx3Z4h4km6lJeiqTgYOiomkvHuRREG/Cc?=
 =?us-ascii?Q?lm0y2jN5vbGBDqAu/cGBfN7LK8N4rJBd4ivDu7BEi3U5QnmzUDD0ObBzfskt?=
 =?us-ascii?Q?aC7R82F2KRdzxkPtjviMgUsYMJLnswLkUZQMGyDrPwioqJOhGZs37qLMv9X+?=
 =?us-ascii?Q?EglGoz9rLcj/CaOJoOvbw4az13tFxUfBTZsH/FD3chygKdT5JYT+FhsLE28Z?=
 =?us-ascii?Q?zU3JLAMSAwFxSbZv8p42/9OuneXVHu9G2PcAwwxoyfWNa4bRZEUwn9bANcx4?=
 =?us-ascii?Q?jzJds30Pl/wU6mzaChKy4/n0QfYllTfU8TJcIL+Ro0CmBKjSN34cDra1LhSt?=
 =?us-ascii?Q?+IeAiuPMnX6t5k7GV6tCYRTR/xSP4q/WScCZ/lLd4Fgyr9zATOt3CtYOuIQk?=
 =?us-ascii?Q?Avq3A8bXvY8d4Zs2WNtipuKLjsCX0evXCdC1tb+PSr9q/AzZgkDg9oRxBGCh?=
 =?us-ascii?Q?gOJJjdNPcs3SuLQIXiBbkSIptQ3SK5dx9ckvnJoXgXWCVNuUP8v2Q3AWRiY9?=
 =?us-ascii?Q?GSYQAShIpyjnCpD46Y6uVOFo4r5M4L44htYXD1kq8ZWpEexYHsj4K/Ee6qRp?=
 =?us-ascii?Q?vv6WTzMq6NrOUnWZhu8jBCk85VfUgXjKcBIuCpcKuLiTz/LI4D3RCTkRDCRZ?=
 =?us-ascii?Q?/Cga0uDBQlM021vkLahoGU9dY3hr18XHHk2jFCwUJGOBQzCJ4wKK2NvEXFWR?=
 =?us-ascii?Q?1GBxIGeP5/NmHxWrHrlRX98fgI2tJkXetrlRvXqjdffd4+huDuSN7nT4dd26?=
 =?us-ascii?Q?gn4K?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d253d3-32c1-4711-2d95-08d8976aae46
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 09:06:11.7833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: siB3BbgwIoZ7WXtu+Ec+Toi6T5rRvFkoaVdWOWz+SPQZCMce5+3naHhTcF5mS/dawgHpY0GhHIeM7xhNNzKcdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6854
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2020/12/01 3:11, Christoph Hellwig wrote:=0A=
> The request_queue can trivially be derived from the request.=0A=
> =0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> ---=0A=
>  block/blk-merge.c            |  2 +-=0A=
>  block/blk-mq-sched.c         |  2 +-=0A=
>  block/blk-mq.c               |  8 +++----=0A=
>  drivers/md/dm-rq.c           |  2 +-=0A=
>  drivers/s390/scsi/zfcp_fsf.c |  3 +--=0A=
>  include/linux/blktrace_api.h |  5 ++--=0A=
>  include/trace/events/block.h | 30 ++++++++++--------------=0A=
>  kernel/trace/blktrace.c      | 44 ++++++++++++++----------------------=
=0A=
>  8 files changed, 39 insertions(+), 57 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-merge.c b/block/blk-merge.c=0A=
> index 4071daa88a5eaf..7497d86fff3834 100644=0A=
> --- a/block/blk-merge.c=0A=
> +++ b/block/blk-merge.c=0A=
> @@ -799,7 +799,7 @@ static struct request *attempt_merge(struct request_q=
ueue *q,=0A=
>  	 */=0A=
>  	blk_account_io_merge_request(next);=0A=
>  =0A=
> -	trace_block_rq_merge(q, next);=0A=
> +	trace_block_rq_merge(next);=0A=
>  =0A=
>  	/*=0A=
>  	 * ownership of bio passed from next to req, return 'next' for=0A=
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c=0A=
> index d1eafe2c045caa..deff4e826e234d 100644=0A=
> --- a/block/blk-mq-sched.c=0A=
> +++ b/block/blk-mq-sched.c=0A=
> @@ -386,7 +386,7 @@ EXPORT_SYMBOL_GPL(blk_mq_sched_try_insert_merge);=0A=
>  =0A=
>  void blk_mq_sched_request_inserted(struct request *rq)=0A=
>  {=0A=
> -	trace_block_rq_insert(rq->q, rq);=0A=
> +	trace_block_rq_insert(rq);=0A=
>  }=0A=
>  EXPORT_SYMBOL_GPL(blk_mq_sched_request_inserted);=0A=
>  =0A=
> diff --git a/block/blk-mq.c b/block/blk-mq.c=0A=
> index 13636458f32f1c..bb669b415a387e 100644=0A=
> --- a/block/blk-mq.c=0A=
> +++ b/block/blk-mq.c=0A=
> @@ -732,7 +732,7 @@ void blk_mq_start_request(struct request *rq)=0A=
>  {=0A=
>  	struct request_queue *q =3D rq->q;=0A=
>  =0A=
> -	trace_block_rq_issue(q, rq);=0A=
> +	trace_block_rq_issue(rq);=0A=
>  =0A=
>  	if (test_bit(QUEUE_FLAG_STATS, &q->queue_flags)) {=0A=
>  		rq->io_start_time_ns =3D ktime_get_ns();=0A=
> @@ -759,7 +759,7 @@ static void __blk_mq_requeue_request(struct request *=
rq)=0A=
>  =0A=
>  	blk_mq_put_driver_tag(rq);=0A=
>  =0A=
> -	trace_block_rq_requeue(q, rq);=0A=
> +	trace_block_rq_requeue(rq);=0A=
>  	rq_qos_requeue(q, rq);=0A=
>  =0A=
>  	if (blk_mq_request_started(rq)) {=0A=
> @@ -1820,7 +1820,7 @@ static inline void __blk_mq_insert_req_list(struct =
blk_mq_hw_ctx *hctx,=0A=
>  =0A=
>  	lockdep_assert_held(&ctx->lock);=0A=
>  =0A=
> -	trace_block_rq_insert(hctx->queue, rq);=0A=
> +	trace_block_rq_insert(rq);=0A=
>  =0A=
>  	if (at_head)=0A=
>  		list_add(&rq->queuelist, &ctx->rq_lists[type]);=0A=
> @@ -1877,7 +1877,7 @@ void blk_mq_insert_requests(struct blk_mq_hw_ctx *h=
ctx, struct blk_mq_ctx *ctx,=0A=
>  	 */=0A=
>  	list_for_each_entry(rq, list, queuelist) {=0A=
>  		BUG_ON(rq->mq_ctx !=3D ctx);=0A=
> -		trace_block_rq_insert(hctx->queue, rq);=0A=
> +		trace_block_rq_insert(rq);=0A=
>  	}=0A=
>  =0A=
>  	spin_lock(&ctx->lock);=0A=
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c=0A=
> index 729a72ec30ccae..13b4385f4d5a92 100644=0A=
> --- a/drivers/md/dm-rq.c=0A=
> +++ b/drivers/md/dm-rq.c=0A=
> @@ -397,7 +397,7 @@ static int map_request(struct dm_rq_target_io *tio)=
=0A=
>  		}=0A=
>  =0A=
>  		/* The target has remapped the I/O so dispatch it */=0A=
> -		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),=0A=
> +		trace_block_rq_remap(clone, disk_devt(dm_disk(md)),=0A=
>  				     blk_rq_pos(rq));=0A=
>  		ret =3D dm_dispatch_clone_request(clone, rq);=0A=
>  		if (ret =3D=3D BLK_STS_RESOURCE || ret =3D=3D BLK_STS_DEV_RESOURCE) {=
=0A=
> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c=
=0A=
> index 6cb963a0677714..37d450f4695281 100644=0A=
> --- a/drivers/s390/scsi/zfcp_fsf.c=0A=
> +++ b/drivers/s390/scsi/zfcp_fsf.c=0A=
> @@ -2359,8 +2359,7 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req =
*req, struct scsi_cmnd *scsi)=0A=
>  		}=0A=
>  	}=0A=
>  =0A=
> -	blk_add_driver_data(scsi->request->q, scsi->request, &blktrc,=0A=
> -			    sizeof(blktrc));=0A=
> +	blk_add_driver_data(scsi->request, &blktrc, sizeof(blktrc));=0A=
>  }=0A=
>  =0A=
>  /**=0A=
> diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h=
=0A=
> index 3b6ff5902edce6..05556573b896a2 100644=0A=
> --- a/include/linux/blktrace_api.h=0A=
> +++ b/include/linux/blktrace_api.h=0A=
> @@ -75,8 +75,7 @@ static inline bool blk_trace_note_message_enabled(struc=
t request_queue *q)=0A=
>  	return ret;=0A=
>  }=0A=
>  =0A=
> -extern void blk_add_driver_data(struct request_queue *q, struct request =
*rq,=0A=
> -				void *data, size_t len);=0A=
> +extern void blk_add_driver_data(struct request *rq, void *data, size_t l=
en);=0A=
>  extern int blk_trace_setup(struct request_queue *q, char *name, dev_t de=
v,=0A=
>  			   struct block_device *bdev,=0A=
>  			   char __user *arg);=0A=
> @@ -90,7 +89,7 @@ extern struct attribute_group blk_trace_attr_group;=0A=
>  #else /* !CONFIG_BLK_DEV_IO_TRACE */=0A=
>  # define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)=0A=
>  # define blk_trace_shutdown(q)				do { } while (0)=0A=
> -# define blk_add_driver_data(q, rq, data, len)		do {} while (0)=0A=
> +# define blk_add_driver_data(rq, data, len)		do {} while (0)=0A=
>  # define blk_trace_setup(q, name, dev, bdev, arg)	(-ENOTTY)=0A=
>  # define blk_trace_startstop(q, start)			(-ENOTTY)=0A=
>  # define blk_trace_remove(q)				(-ENOTTY)=0A=
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h=
=0A=
> index 8fb89574d8677f..0d782663a005dc 100644=0A=
> --- a/include/trace/events/block.h=0A=
> +++ b/include/trace/events/block.h=0A=
> @@ -64,7 +64,6 @@ DEFINE_EVENT(block_buffer, block_dirty_buffer,=0A=
>  =0A=
>  /**=0A=
>   * block_rq_requeue - place block IO request back on a queue=0A=
> - * @q: queue holding operation=0A=
>   * @rq: block IO operation request=0A=
>   *=0A=
>   * The block operation request @rq is being placed back into queue=0A=
> @@ -73,9 +72,9 @@ DEFINE_EVENT(block_buffer, block_dirty_buffer,=0A=
>   */=0A=
>  TRACE_EVENT(block_rq_requeue,=0A=
>  =0A=
> -	TP_PROTO(struct request_queue *q, struct request *rq),=0A=
> +	TP_PROTO(struct request *rq),=0A=
>  =0A=
> -	TP_ARGS(q, rq),=0A=
> +	TP_ARGS(rq),=0A=
>  =0A=
>  	TP_STRUCT__entry(=0A=
>  		__field(  dev_t,	dev			)=0A=
> @@ -147,9 +146,9 @@ TRACE_EVENT(block_rq_complete,=0A=
>  =0A=
>  DECLARE_EVENT_CLASS(block_rq,=0A=
>  =0A=
> -	TP_PROTO(struct request_queue *q, struct request *rq),=0A=
> +	TP_PROTO(struct request *rq),=0A=
>  =0A=
> -	TP_ARGS(q, rq),=0A=
> +	TP_ARGS(rq),=0A=
>  =0A=
>  	TP_STRUCT__entry(=0A=
>  		__field(  dev_t,	dev			)=0A=
> @@ -181,7 +180,6 @@ DECLARE_EVENT_CLASS(block_rq,=0A=
>  =0A=
>  /**=0A=
>   * block_rq_insert - insert block operation request into queue=0A=
> - * @q: target queue=0A=
>   * @rq: block IO operation request=0A=
>   *=0A=
>   * Called immediately before block operation request @rq is inserted=0A=
> @@ -191,14 +189,13 @@ DECLARE_EVENT_CLASS(block_rq,=0A=
>   */=0A=
>  DEFINE_EVENT(block_rq, block_rq_insert,=0A=
>  =0A=
> -	TP_PROTO(struct request_queue *q, struct request *rq),=0A=
> +	TP_PROTO(struct request *rq),=0A=
>  =0A=
> -	TP_ARGS(q, rq)=0A=
> +	TP_ARGS(rq)=0A=
>  );=0A=
>  =0A=
>  /**=0A=
>   * block_rq_issue - issue pending block IO request operation to device d=
river=0A=
> - * @q: queue holding operation=0A=
>   * @rq: block IO operation operation request=0A=
>   *=0A=
>   * Called when block operation request @rq from queue @q is sent to a=0A=
> @@ -206,14 +203,13 @@ DEFINE_EVENT(block_rq, block_rq_insert,=0A=
>   */=0A=
>  DEFINE_EVENT(block_rq, block_rq_issue,=0A=
>  =0A=
> -	TP_PROTO(struct request_queue *q, struct request *rq),=0A=
> +	TP_PROTO(struct request *rq),=0A=
>  =0A=
> -	TP_ARGS(q, rq)=0A=
> +	TP_ARGS(rq)=0A=
>  );=0A=
>  =0A=
>  /**=0A=
>   * block_rq_merge - merge request with another one in the elevator=0A=
> - * @q: queue holding operation=0A=
>   * @rq: block IO operation operation request=0A=
>   *=0A=
>   * Called when block operation request @rq from queue @q is merged to an=
other=0A=
> @@ -221,9 +217,9 @@ DEFINE_EVENT(block_rq, block_rq_issue,=0A=
>   */=0A=
>  DEFINE_EVENT(block_rq, block_rq_merge,=0A=
>  =0A=
> -	TP_PROTO(struct request_queue *q, struct request *rq),=0A=
> +	TP_PROTO(struct request *rq),=0A=
>  =0A=
> -	TP_ARGS(q, rq)=0A=
> +	TP_ARGS(rq)=0A=
>  );=0A=
>  =0A=
>  /**=0A=
> @@ -491,7 +487,6 @@ TRACE_EVENT(block_bio_remap,=0A=
>  =0A=
>  /**=0A=
>   * block_rq_remap - map request for a block operation request=0A=
> - * @q: queue holding the operation=0A=
>   * @rq: block IO operation request=0A=
>   * @dev: device for the operation=0A=
>   * @from: original sector for the operation=0A=
> @@ -502,10 +497,9 @@ TRACE_EVENT(block_bio_remap,=0A=
>   */=0A=
>  TRACE_EVENT(block_rq_remap,=0A=
>  =0A=
> -	TP_PROTO(struct request_queue *q, struct request *rq, dev_t dev,=0A=
> -		 sector_t from),=0A=
> +	TP_PROTO(struct request *rq, dev_t dev, sector_t from),=0A=
>  =0A=
> -	TP_ARGS(q, rq, dev, from),=0A=
> +	TP_ARGS(rq, dev, from),=0A=
>  =0A=
>  	TP_STRUCT__entry(=0A=
>  		__field( dev_t,		dev		)=0A=
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c=0A=
> index 405637144a0389..7839a78205c243 100644=0A=
> --- a/kernel/trace/blktrace.c=0A=
> +++ b/kernel/trace/blktrace.c=0A=
> @@ -795,12 +795,12 @@ static u64 blk_trace_bio_get_cgid(struct request_qu=
eue *q, struct bio *bio)=0A=
>  #endif=0A=
>  =0A=
>  static u64=0A=
> -blk_trace_request_get_cgid(struct request_queue *q, struct request *rq)=
=0A=
> +blk_trace_request_get_cgid(struct request *rq)=0A=
>  {=0A=
>  	if (!rq->bio)=0A=
>  		return 0;=0A=
>  	/* Use the first bio */=0A=
> -	return blk_trace_bio_get_cgid(q, rq->bio);=0A=
> +	return blk_trace_bio_get_cgid(rq->q, rq->bio);=0A=
>  }=0A=
>  =0A=
>  /*=0A=
> @@ -841,40 +841,35 @@ static void blk_add_trace_rq(struct request *rq, in=
t error,=0A=
>  	rcu_read_unlock();=0A=
>  }=0A=
>  =0A=
> -static void blk_add_trace_rq_insert(void *ignore,=0A=
> -				    struct request_queue *q, struct request *rq)=0A=
> +static void blk_add_trace_rq_insert(void *ignore, struct request *rq)=0A=
>  {=0A=
>  	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_INSERT,=0A=
> -			 blk_trace_request_get_cgid(q, rq));=0A=
> +			 blk_trace_request_get_cgid(rq));=0A=
>  }=0A=
>  =0A=
> -static void blk_add_trace_rq_issue(void *ignore,=0A=
> -				   struct request_queue *q, struct request *rq)=0A=
> +static void blk_add_trace_rq_issue(void *ignore, struct request *rq)=0A=
>  {=0A=
>  	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_ISSUE,=0A=
> -			 blk_trace_request_get_cgid(q, rq));=0A=
> +			 blk_trace_request_get_cgid(rq));=0A=
>  }=0A=
>  =0A=
> -static void blk_add_trace_rq_merge(void *ignore,=0A=
> -				   struct request_queue *q, struct request *rq)=0A=
> +static void blk_add_trace_rq_merge(void *ignore, struct request *rq)=0A=
>  {=0A=
>  	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_BACKMERGE,=0A=
> -			 blk_trace_request_get_cgid(q, rq));=0A=
> +			 blk_trace_request_get_cgid(rq));=0A=
>  }=0A=
>  =0A=
> -static void blk_add_trace_rq_requeue(void *ignore,=0A=
> -				     struct request_queue *q,=0A=
> -				     struct request *rq)=0A=
> +static void blk_add_trace_rq_requeue(void *ignore, struct request *rq)=
=0A=
>  {=0A=
>  	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_REQUEUE,=0A=
> -			 blk_trace_request_get_cgid(q, rq));=0A=
> +			 blk_trace_request_get_cgid(rq));=0A=
>  }=0A=
>  =0A=
>  static void blk_add_trace_rq_complete(void *ignore, struct request *rq,=
=0A=
>  			int error, unsigned int nr_bytes)=0A=
>  {=0A=
>  	blk_add_trace_rq(rq, error, nr_bytes, BLK_TA_COMPLETE,=0A=
> -			 blk_trace_request_get_cgid(rq->q, rq));=0A=
> +			 blk_trace_request_get_cgid(rq));=0A=
>  }=0A=
>  =0A=
>  /**=0A=
> @@ -1037,16 +1032,14 @@ static void blk_add_trace_bio_remap(void *ignore,=
 struct bio *bio, dev_t dev,=0A=
>   *     Add a trace for that action.=0A=
>   *=0A=
>   **/=0A=
> -static void blk_add_trace_rq_remap(void *ignore,=0A=
> -				   struct request_queue *q,=0A=
> -				   struct request *rq, dev_t dev,=0A=
> +static void blk_add_trace_rq_remap(void *ignore, struct request *rq, dev=
_t dev,=0A=
>  				   sector_t from)=0A=
>  {=0A=
>  	struct blk_trace *bt;=0A=
>  	struct blk_io_trace_remap r;=0A=
>  =0A=
>  	rcu_read_lock();=0A=
> -	bt =3D rcu_dereference(q->blk_trace);=0A=
> +	bt =3D rcu_dereference(rq->q->blk_trace);=0A=
>  	if (likely(!bt)) {=0A=
>  		rcu_read_unlock();=0A=
>  		return;=0A=
> @@ -1058,13 +1051,12 @@ static void blk_add_trace_rq_remap(void *ignore,=
=0A=
>  =0A=
>  	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),=0A=
>  			rq_data_dir(rq), 0, BLK_TA_REMAP, 0,=0A=
> -			sizeof(r), &r, blk_trace_request_get_cgid(q, rq));=0A=
> +			sizeof(r), &r, blk_trace_request_get_cgid(rq));=0A=
>  	rcu_read_unlock();=0A=
>  }=0A=
>  =0A=
>  /**=0A=
>   * blk_add_driver_data - Add binary message with driver-specific data=0A=
> - * @q:		queue the io is for=0A=
>   * @rq:		io request=0A=
>   * @data:	driver-specific data=0A=
>   * @len:	length of driver-specific data=0A=
> @@ -1073,14 +1065,12 @@ static void blk_add_trace_rq_remap(void *ignore,=
=0A=
>   *     Some drivers might want to write driver-specific data per request=
.=0A=
>   *=0A=
>   **/=0A=
> -void blk_add_driver_data(struct request_queue *q,=0A=
> -			 struct request *rq,=0A=
> -			 void *data, size_t len)=0A=
> +void blk_add_driver_data(struct request *rq, void *data, size_t len)=0A=
>  {=0A=
>  	struct blk_trace *bt;=0A=
>  =0A=
>  	rcu_read_lock();=0A=
> -	bt =3D rcu_dereference(q->blk_trace);=0A=
> +	bt =3D rcu_dereference(rq->q->blk_trace);=0A=
>  	if (likely(!bt)) {=0A=
>  		rcu_read_unlock();=0A=
>  		return;=0A=
> @@ -1088,7 +1078,7 @@ void blk_add_driver_data(struct request_queue *q,=
=0A=
>  =0A=
>  	__blk_add_trace(bt, blk_rq_trace_sector(rq), blk_rq_bytes(rq), 0, 0,=0A=
>  				BLK_TA_DRV_DATA, 0, len, data,=0A=
> -				blk_trace_request_get_cgid(q, rq));=0A=
> +				blk_trace_request_get_cgid(rq));=0A=
>  	rcu_read_unlock();=0A=
>  }=0A=
>  EXPORT_SYMBOL_GPL(blk_add_driver_data);=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

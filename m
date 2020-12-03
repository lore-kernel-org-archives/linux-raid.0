Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFF3C63777
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 08:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FB8E2084C
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 08:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgLCIr7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:47:59 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:50064 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729041AbgLCIr6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 03:47:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606985279; x=1638521279;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=GbXJDTO13hIPkQ9VXaxpN83TsDb0SKSRX1kplW/mXws=;
  b=mXc6ul/89ummTKch20LpOSm3aaI1pTakgYNETUwXL6tAOqbpjpLHNb6o
   AWC+gPZ54y9jfUD7RXHFoh6f9ggFcIytbOSPVPIzDF5XOwPGmBQXdnAoN
   soL2Jb69vC0NiPXUnaSRUvYb6lKIEpHMkq9nsyHrJAndDK9/UEYjYsMNH
   SXrm0V4YqQikJ3ojWRgxEneJrqGeT19WgRsepHf2nirfcBvb27tgJnOrY
   aPPKn9U/0Up6YB1P74BaVkl5fKwXccB4kb9w3qhOtj12tZfXj050agCKP
   ME6Su3JFqEA/7Xot8llcCcWy9Hmaot+D9oyDSngnFHF/7RAmGVmmAwKQM
   w==;
IronPort-SDR: PhWxSbg07Ya8IZgduBxMx2OxM/Vmk5CNziQoNqtFxF0akgnPs/dFogyT3aQRRHbIYBjgW8haoX
 AJXywH21NFaEsF7qWcG75o3CDPHSUe7HAHKSop5xLNBXSav4spJow0gLrFgA9ifK4XP1lbFoJQ
 4M8Ci1BcRjzPJsgIyPyjLdTnaH9y4TUR1OVyxyUT9kf9IPhxyBS7TMO0+6r/hWCqDKs89cYRSB
 Dd6eMpT3v/8UJJM2DV+MMjmUPp7TLY8/okkWOThPddhYmTEphtnVE7Knox7dhfGkY5VQ7reysf
 IE4=
X-IronPort-AV: E=Sophos;i="5.78,389,1599494400"; 
   d="scan'208";a="155443909"
Received: from mail-bn3nam04lp2052.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.52])
  by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 16:46:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYmGh5O02xW0+3vFgU71BYEJkB7LIJnHWZOq6ix1/oEje9loJ9fonawO6UrfVkJMZZV2+7U0N1XaqReDHhtykXIKGKIvrMYYfLafCHo3londfat2oV19LvrlwT5qxlV2RB0Vv4MXBhtUD2iy6EuCV/PRf7Ri7pKBadnD4ATQrI6B6k4KD7GKbs9S662sw83vOMFvJPpK80xmVRr59sbb5xAwi4PD6e4u5zmpwko0Awactegp37AOq9l6G1zSNzP5R2IG9tUtIILO+qOYiqB7yYS+sIOG0lGF9fW513fogBh8fLXPdq5uXHIJmclqyn0F6MG2q83BThjvCQwoLAWpgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTCWJ+4+ET6cJhGf82zpwD9AYhVFZUQ4hnCZp11vmlM=;
 b=h/x7JNIFdASvFkpnLe/CatMDehKYGqk3cyqobovSGy5KfYXLeNibhn4k8r5wxNIQG/KqhFpgVDGAUJ4bInOvX4VbSICrYl+QvvznQj+TCoEDTuxY3fHOqOiUaIdZOfn8m6404Q3n2jtEd+RsI10sMBFeW2t3zxIAB1gHTRmDXfVce8gpQMFpmgyQ3621yCWvzgPeh7M08I6rDARtRnKRwk+StZGfM1jHyAHb28nM/XIqrBstzBztKzszG8S38Z07YEIAOVQgfVm8JCUTdc5hsvvpgYMNekdFvlyPexGKEtFFYOYkkZfmIKTSLzBHrgYzoJVOxVS/jkKtqL/FosCd3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTCWJ+4+ET6cJhGf82zpwD9AYhVFZUQ4hnCZp11vmlM=;
 b=dlvHrqZsX8uH6EY1U/Oj4JpjSUsdTQvnu/HiFKmTy3yUsfrJLoQq1v4n/fYBw+tcGpwZFyqdwYEJOHthS3j/aDMzy7vH0+6Yaj3z2mFc6aDywDqdMcf6a/Cunhb17CETkCk4x0aZOZGFq0LU9mksuM3O/fXndS59QqzTg6gRQlo=
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
 by CH2PR04MB6854.namprd04.prod.outlook.com (2603:10b6:610:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Thu, 3 Dec
 2020 08:46:51 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a]) by CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022; Thu, 3 Dec 2020
 08:46:51 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 1/5] block: remove the unused block_sleeprq
 tracepoint
Thread-Topic: [dm-devel] [PATCH 1/5] block: remove the unused block_sleeprq
 tracepoint
Thread-Index: AQHWyVDXj30DQJqHH0qTV+zbakU7rg==
Date:   Thu, 3 Dec 2020 08:46:51 +0000
Message-ID: <CH2PR04MB652225D9AF153543AE4DF758E7F20@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201130175854.982460-1-hch@lst.de>
 <20201130175854.982460-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1083e06a-8894-4d48-d418-08d89767fa65
x-ms-traffictypediagnostic: CH2PR04MB6854:
x-microsoft-antispam-prvs: <CH2PR04MB68548BE747B81B18B29A5E9AE7F20@CH2PR04MB6854.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DbfboezJhFzjcs+esFjS8Iy0oZXcPCMkmUGplS/KmcEzHNCcjqTBzaJ64YDTtV4bAIkUFmPPio+Zw/Wxy3qtf9o/Uwc/mWV+8uiASkgYtNKtlPcYCkL17nw3SaellhSAjc4DF7jqr3BE3Swx/WSnjS97Et4IHi8TntfpY1WCqAE7vCHFPR4olncvLywxMKxH5PMCnyAlHQNbxVMYVhX5P6tJ/Guc68WyL627pVQ5z8h8gVwU5CGKcwfsAL/kbobpwLjJE2h7i0JyAaC5fSgpll5VcN/E/gwp0AE7eXQiZJBYNOv5C749Wz/AuSapMbb0CECZzQ3KZSMNeI7f6M8AWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6522.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(7696005)(5660300002)(9686003)(6506007)(4326008)(71200400001)(86362001)(53546011)(52536014)(8936002)(66556008)(55016002)(76116006)(64756008)(66946007)(2906002)(8676002)(316002)(110136005)(83380400001)(33656002)(54906003)(186003)(66476007)(26005)(91956017)(66446008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hGlm8Z0IQHDnoZ3/236XV6xh96wfyhzTFFwISD61+ZzdJW+m6sj5jKlt2rwk?=
 =?us-ascii?Q?8Nm4szpvaojgLXPXPZuUDcYk8bBOqQpY2FfvFAuB0cXln5d/VhMXOG95/yKE?=
 =?us-ascii?Q?uUNWBdw9jLtTOq/rw34cyh4AqX+hMbIT502qWVMgaZuE4g3tMXwtDe2IOP9x?=
 =?us-ascii?Q?hMESp1We3dcPvnEMNw1fAkt9+LTXtFdPmhr1PBm19OxyMtu7KJF/Uzt4+AFX?=
 =?us-ascii?Q?UW8/BUOr96XevkvUFHVQxHnXYsAEqvTapk9z7yEeEgRKbxgHOST8nndulgid?=
 =?us-ascii?Q?W8dQd0N0GOX9zeaLZEVRAaMA6Nnl9dl0l+yAbBa9+UJeWpwwTNRhyf6mmdL7?=
 =?us-ascii?Q?iO7umMswuVn3ymEEC3bbK8NIwwhiprT/XRiFOFnuSAQ0RZxIA/qUOeCIl+ZG?=
 =?us-ascii?Q?Icl4oZz4VqBv2WwwM8sIIrll1a0qD9AGF3msfmuccBqB3dgEO7OZoaPtus/3?=
 =?us-ascii?Q?3n1oWF+Lu7sAu7dWciNAfmN0RSYgTacOp/GxiAfQfBNI5ctFpCX3XcR1kg+s?=
 =?us-ascii?Q?UDcKpf3qeg9WPndT7nzKgzsgF7S3Kof9Qp50KTTDMUwQONHxduwO/EpiwLm5?=
 =?us-ascii?Q?TDxWteVXJ8NFZv6rviPCKXDnCHDFFBjF26vIEWXsvh8c47z34ih0kouiKdmX?=
 =?us-ascii?Q?NWo5UGY8S7Sx0AZ4fIhxF8qPlb6sTYRGUNDdimxyqOU7/MF1qW1c+hMhUZNb?=
 =?us-ascii?Q?EqHNdv3Fkno/1vAs/1a4v3mpGlQtsCZnRxfCzl8vVhUIHS0cDbSRLsGLMXPm?=
 =?us-ascii?Q?290CGZYdZioGCYg+6Y3+wLYDjfSfEYe2fcaWJp4j3VNLNcQVl/kkY96AU81P?=
 =?us-ascii?Q?/UlMmCo6sBm2Yfh0n1ZH8zQmGdxIqDYajD+pZj7m8Oga73rnaTA+ohuoq1T+?=
 =?us-ascii?Q?CZ+KdpzIDssEAKJfXkLMn428CBUwO/nLUwnhQnczHThIRnxbImtVfjZ1jvJa?=
 =?us-ascii?Q?GEGuqMTsiE6FJcF8oAPDRChpHgECFG+ae2Ghk+OfecGHak1fE9+FpGCqBo1j?=
 =?us-ascii?Q?cj0N?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1083e06a-8894-4d48-d418-08d89767fa65
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 08:46:51.0282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LXG++VDluB0rTxnvtpZeV6at3DAQGt+37adKcB/SENE9hNaw808pgGQZY018d0nYzYTPCY5YG4eekNlzbMvCKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6854
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2020/12/01 3:03, Christoph Hellwig wrote:=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
=0A=
Even if it is just repeating the patch title, a commit message would be nic=
e.=0A=
You could also mention when the last use of this tracepoint was removed.=0A=
=0A=
> ---=0A=
>  include/trace/events/block.h | 18 ------------------=0A=
>  kernel/trace/blktrace.c      | 22 ----------------------=0A=
>  2 files changed, 40 deletions(-)=0A=
> =0A=
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h=
=0A=
> index 34d64ca306b1c7..76459cf750e14d 100644=0A=
> --- a/include/trace/events/block.h=0A=
> +++ b/include/trace/events/block.h=0A=
> @@ -441,24 +441,6 @@ DEFINE_EVENT(block_get_rq, block_getrq,=0A=
>  	TP_ARGS(q, bio, rw)=0A=
>  );=0A=
>  =0A=
> -/**=0A=
> - * block_sleeprq - waiting to get a free request entry in queue for bloc=
k IO operation=0A=
> - * @q: queue for operation=0A=
> - * @bio: pending block IO operation (can be %NULL)=0A=
> - * @rw: low bit indicates a read (%0) or a write (%1)=0A=
> - *=0A=
> - * In the case where a request struct cannot be provided for queue @q=0A=
> - * the process needs to wait for an request struct to become=0A=
> - * available.  This tracepoint event is generated each time the=0A=
> - * process goes to sleep waiting for request struct become available.=0A=
> - */=0A=
> -DEFINE_EVENT(block_get_rq, block_sleeprq,=0A=
> -=0A=
> -	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),=0A=
> -=0A=
> -	TP_ARGS(q, bio, rw)=0A=
> -);=0A=
> -=0A=
>  /**=0A=
>   * block_plug - keep operations requests in request queue=0A=
>   * @q: request queue to plug=0A=
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c=0A=
> index a482a37848bff7..ced589df304b57 100644=0A=
> --- a/kernel/trace/blktrace.c=0A=
> +++ b/kernel/trace/blktrace.c=0A=
> @@ -959,25 +959,6 @@ static void blk_add_trace_getrq(void *ignore,=0A=
>  	}=0A=
>  }=0A=
>  =0A=
> -=0A=
> -static void blk_add_trace_sleeprq(void *ignore,=0A=
> -				  struct request_queue *q,=0A=
> -				  struct bio *bio, int rw)=0A=
> -{=0A=
> -	if (bio)=0A=
> -		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ, 0);=0A=
> -	else {=0A=
> -		struct blk_trace *bt;=0A=
> -=0A=
> -		rcu_read_lock();=0A=
> -		bt =3D rcu_dereference(q->blk_trace);=0A=
> -		if (bt)=0A=
> -			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_SLEEPRQ,=0A=
> -					0, 0, NULL, 0);=0A=
> -		rcu_read_unlock();=0A=
> -	}=0A=
> -}=0A=
> -=0A=
>  static void blk_add_trace_plug(void *ignore, struct request_queue *q)=0A=
>  {=0A=
>  	struct blk_trace *bt;=0A=
> @@ -1164,8 +1145,6 @@ static void blk_register_tracepoints(void)=0A=
>  	WARN_ON(ret);=0A=
>  	ret =3D register_trace_block_getrq(blk_add_trace_getrq, NULL);=0A=
>  	WARN_ON(ret);=0A=
> -	ret =3D register_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);=0A=
> -	WARN_ON(ret);=0A=
>  	ret =3D register_trace_block_plug(blk_add_trace_plug, NULL);=0A=
>  	WARN_ON(ret);=0A=
>  	ret =3D register_trace_block_unplug(blk_add_trace_unplug, NULL);=0A=
> @@ -1185,7 +1164,6 @@ static void blk_unregister_tracepoints(void)=0A=
>  	unregister_trace_block_split(blk_add_trace_split, NULL);=0A=
>  	unregister_trace_block_unplug(blk_add_trace_unplug, NULL);=0A=
>  	unregister_trace_block_plug(blk_add_trace_plug, NULL);=0A=
> -	unregister_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);=0A=
>  	unregister_trace_block_getrq(blk_add_trace_getrq, NULL);=0A=
>  	unregister_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);=0A=
>  	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NUL=
L);=0A=
> =0A=
=0A=
Otherwise, looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

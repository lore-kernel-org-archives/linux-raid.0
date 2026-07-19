Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69222609C5;
	Sun, 19 Jul 2026 11:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784459842; cv=none; b=RmtE+JY6kS2SOFOh7X/PtBlldmtfZf/iGTfsyPsET6TtPK/I0xDj9nuHvk6cT0W+qdkIueu9IQvvXkVEPYahtKknYRYF8ob1hXZHnSXJ3CG9uBUZ22kHZXLwtWSedqDeZguUmpZbIcruHHzJYDvCbkwj56MnMUTTvB6MzsrIpgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784459842; c=relaxed/simple;
	bh=fOSQm4boCt9iJS7RzXD/WQEUismIrL7akQle7Jt1cmA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qERkyeLOU91j+KtzKpMzqA662ApWDEOxiFzOECAfLS1o4cPgtJ3lTzM2ehPmceRq1BYQ7RuHp8Yb0l9eBjVGFVRqmI5TaxvCMW/F2jUYXN8gbPfzvl9ZI7mtXMvmjIXQynTo71I1kpCWBjYNEXOpIJF4o1g5wsCDIaGllRja+V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P08Jtf0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P08Jtf0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294151F000E9;
	Sun, 19 Jul 2026 11:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784459841;
	bh=QwftZwVj+uRDaqqWWQeaCb+B7/5NP0rBHX1WuEjmwp4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P08Jtf0thffG7v1UoDXmk+R2tPkqxSG6gNo/zx6/ASBA4DR+kDSmNNaXoDNlGCb/r
	 2GE2ln01RAHC7g4KrtAYGbzBYC8C5pJPPgf1zBA5GOvK+frPvJHo0FSfeqXG3Nn6OX
	 g5VSEHsGrHrcgHiUMn4odo2VYqdUXSWujUzmW9EyH78riC1Lp/qy+KPJgaXGV41DrQ
	 szgwr82bsZD0XPvXFz6YwHa2mDbtX6bTLJIn+xQo+yQrSre+J+UjN8Bcwe5gYwDXNn
	 UU7acOGixyZNmjkDY1+1yEMPzrhVBbu54qfYU/M8/sbT1eRTBLpT+DUuNtMmdWP9z7
	 4KFC4WAzTP3Eg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 7/7] nvme-rdma: return BLK_STS_TARGET for unsupported
 P2P transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260719105327.864949-8-mykola@meshstor.io>
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-8-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 11:17:20 +0000
Message-Id: <20260719111721.294151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Preexisting use-after-free and DMA unmap corruption in the `nvme_r=
dma_queue_rq` error path.
- [High] Preexisting resource leak of multipath `nr_active` and QoS metrics=
 when `nvme_rdma_post_send()` fails.
--

--- Patch [7]: [PATCH v2 7/7] nvme-rdma: return BLK_STS_TARGET for unsuppor=
ted P2P transfers ---
commit 8ebcd8a34c348b015bd58fe860d4af84c9a7b8c5
Author: Mykola Marzhan <mykola@meshstor.io>

nvme-rdma: return BLK_STS_TARGET for unsupported P2P transfers

This commit updates nvme-rdma to correctly handle P2PDMA mapping failures
by preserving the DMA layer's error code. It translates -EREMOTEIO to
BLK_STS_TARGET to avoid endless requeue livelocks for unreachable peer
memory, and it defers nvme_start_request() until after mapping succeeds.

Cc: stable@vger.kernel.org # v7.1

> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 6909e35427942..9017d927edc41 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c

[ ... ]

> @@ -2026,8 +2029,6 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_m=
q_hw_ctx *hctx,
>  	if (ret)
>  		goto unmap_qe;
> =20
> -	nvme_start_request(rq);
> -
>  	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
>  	    queue->pi_support &&
>  	    (c->common.opcode =3D=3D nvme_cmd_write ||
> @@ -2039,11 +2040,13 @@ static blk_status_t nvme_rdma_queue_rq(struct blk=
_mq_hw_ctx *hctx,
> =20
>  	err =3D nvme_rdma_map_data(queue, rq, c);
>  	if (unlikely(err < 0)) {
> -		dev_err(queue->ctrl->ctrl.device,
> -			     "Failed to map data (%d)\n", err);
> +		dev_err_ratelimited(queue->ctrl->ctrl.device,
> +				    "Failed to map data (%d)\n", err);
>  		goto err;
>  	}
> =20
> +	nvme_start_request(rq);
> +

[Severity: High]
This is a pre-existing issue, but if nvme_rdma_post_send() fails further
down, does returning a block status error after nvme_start_request() has
been called bypass the NVMe completion handlers?

Since the block layer will natively complete the request in this scenario,
it looks like nvme_mpath_end_request() is bypassed, which could permanently
leak the nr_active counter and break multipath load balancing.

>  	sqe->cqe.done =3D nvme_rdma_send_done;
> =20
>  	ib_dma_sync_single_for_device(dev, sqe->dma,
> @@ -2063,6 +2066,13 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_=
mq_hw_ctx *hctx,
>  		ret =3D nvme_host_path_error(rq);
>  	else if (err =3D=3D -ENOMEM || err =3D=3D -EAGAIN)
>  		ret =3D BLK_STS_RESOURCE;
> +	/*
> +	 * The DMA layer refused to map peer memory to this device: a
> +	 * property of the pairing, not a path failure.  Match nvme-pci
> +	 * and do not retry (see blk_path_error()).
> +	 */
> +	else if (err =3D=3D -EREMOTEIO)
> +		ret =3D BLK_STS_TARGET;
>  	else
>  		ret =3D BLK_STS_IOERR;
>  	nvme_cleanup_cmd(rq);

[Severity: High]
This isn't a bug introduced by this patch, but can this error path lead to a
use-after-free and DMA unmap corruption?

If nvme_rdma_post_send() fails with -EIO, nvme_host_path_error(rq) is
called, which synchronously completes and frees the request. The code then
falls through to execute nvme_cleanup_cmd(rq) and ib_dma_unmap_single() on
the already freed request.

Could this unmap the active DMA region of a completely different, newly
allocated I/O command?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719105327.8649=
49-1-mykola@meshstor.io?part=3D7

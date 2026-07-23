Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249553F5BDA;
	Thu, 23 Jul 2026 21:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841581; cv=none; b=S2csCWDRbJ7F33F1LT2v00hoPuNDzsDRiamsPaRFzG+LdoG39ZxYMpqgiqLMzLZ8hL9aDbSrU2gTKmvf15Sjs4h/8F5030t0v/kDsdDIUEfoirXgpr6s9XhJXV7+LAKUlkVPeIKuxR7CjaqvVXfMwKmFqL0HKJj68DaEdnoAbK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841581; c=relaxed/simple;
	bh=lZo1+S9zFdC/mZ/rk1SozNQMmjqU6tGravGTGaKZ7iY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q/ULfthZDDjnezIjh4R8RNw/6g050RTiM/JAkoAyZc3Hsfr2+V7xrrxRCW/frAciM2tXI3rgPorS5uEB9wtw1kN2GeoxedU5MA7RpcFEZxjSBpoWPYLQDquSikxi+hph1EX3DS2ARFaN2xNJ+nCZUnoGeNfCg3k9A6tu/CUVneU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fud/RHdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fud/RHdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB041F000E9;
	Thu, 23 Jul 2026 21:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784841579;
	bh=eO3oK6CIOhONmLL2gFy9UcTeJQ+F3rDCgOy6Lyo16NA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fud/RHdEfJ91mHwN10oBNdLaIFzv/qk+yU0Y5xm7/Li0HQQkPplTRvL3N1075S3Gf
	 ICP7rZz12xuk60dXimN3665E+rxaA+MICndM8+mdKuJSuSWY+OLjGJv7gFmJAAVpnz
	 8PWc7+p8hNpNqQUuBwKaUjKGKkqalkwccfLQZCSp++jcDKttkq3AUcH6W+Hu7kSwgH
	 mPePqB4N0JvUePGfCGiJVvoK5jiSaDd6cHMReSCriORCNLKQsJFl+mTg07VE3UIgY3
	 /nCLyP6BPlvl2rSF06xCILB96/t6FzZnY0nDMhOr1hd21WKp2yuFy15o9av/SEcO5A
	 ggybu967erMIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 10/10] nvme-rdma: return BLK_STS_P2PDMA for
 unsupported P2P transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260723204206.76930-11-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-11-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 21:19:39 +0000
Message-Id: <20260723211939.8EB041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Modifying the PI metadata buffer via nvme_start_request() after it=
 has been mapped for DMA causes cache coherency issues on non-coherent arch=
itectures.

Pre-existing issues:
- [High] Accessing the block request and its associated PDU after being fre=
ed on the error handling path when mapping or post_send fails with -EIO.
- [High] Returning BLK_STS_RESOURCE after the request has been started trig=
gers kernel warnings and false timeouts.
- [Medium] Returning a hard error from queue_rq after calling nvme_start_re=
quest() bypasses nvme_mpath_end_request(), leaking the nr_active counter.
--

--- Patch [10]: [PATCH v5 10/10] nvme-rdma: return BLK_STS_P2PDMA for unsup=
ported P2P transfers ---
commit 2111f8ba9b5738dc4d1ef4e08339058c75231ebd
Author: Mykola Marzhan <mykola@meshstor.io>

nvme-rdma: return BLK_STS_P2PDMA for unsupported P2P transfers

> A P2P transfer the PCIe topology cannot route fails DMA mapping
> with -EREMOTEIO.  nvme-rdma folds every mapping error into -EIO, a
> retryable host-path error: multipath requeues the I/O forever, a
> single path burns its whole retry budget.
>=20
> Propagate the real error code and return the unroutable case as the
> non-retryable BLK_STS_P2PDMA.  As in nvme-pci, -ENOMEM now requeues
> (BLK_STS_RESOURCE) and -EINVAL fails (BLK_STS_IOERR); -EIO stays a
> retryable host-path error.  While at it, start the request only
> after mapping succeeds -- nvme-pci's order -- and ratelimit the
> map-failure message.

> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 63830334c73e2..2f50509a7a616 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> [ ... ]
> @@ -2033,8 +2029,6 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_m=
q_hw_ctx *hctx,
>  	if (ret)
>  		goto unmap_qe;
> =20
> -	nvme_start_request(rq);
> -
>  	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
>  	    queue->pi_support &&
>  	    (c->common.opcode =3D=3D nvme_cmd_write ||
> @@ -2046,11 +2040,13 @@ static blk_status_t nvme_rdma_queue_rq(struct blk=
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

[Severity: High]
Since the patch moves nvme_start_request() to execute after
nvme_rdma_map_data() has mapped the metadata buffer for streaming DMA, can =
this
cause cache coherency issues on non-coherent architectures?

nvme_start_request() invokes blk_integrity_prepare(), which writes to the PI
tags directly in the CPU cache.=20

Because this now happens after the memory is mapped, those modifications mi=
ght
not be synced to main memory, causing the RDMA NIC to read stale PI tags and
leading to silent data corruption and I/O failures.

> +
>  	sqe->cqe.done =3D nvme_rdma_send_done;
> =20
>  	ib_dma_sync_single_for_device(dev, sqe->dma,
> [ ... ]
> @@ -2070,6 +2066,9 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_m=
q_hw_ctx *hctx,
> =20
>  err_unmap:
>  	nvme_rdma_unmap_data(queue, rq);
>  err:
>  	if (err =3D=3D -EIO)
>  		ret =3D nvme_host_path_error(rq);

[Severity: High]
This is a pre-existing issue, but does this lead to a use-after-free when
nvme_rdma_map_data() or nvme_rdma_post_send() fails with -EIO?

nvme_host_path_error() synchronously completes the request via
blk_mq_set_request_complete() and __nvme_complete_rq(). This frees the requ=
est
and its PDU back to the tag allocator, where it can be immediately realloca=
ted.

The code then falls through and accesses the freed request by calling
nvme_cleanup_cmd(rq) and reading req->sqe.dma during ib_dma_unmap_single().

>  	else if (err =3D=3D -ENOMEM || err =3D=3D -EAGAIN)
>  		ret =3D BLK_STS_RESOURCE;

[Severity: High]
This is a pre-existing issue, but does returning BLK_STS_RESOURCE here cause
false I/O timeouts?

At this point, nvme_start_request() has already been called, placing the
request in the MQ_RQ_IN_FLIGHT state and starting its timeout timer.=20

When returning BLK_STS_RESOURCE, the block layer requeues the request witho=
ut
reverting its state to MQ_RQ_IDLE. This leaves the timer ticking while the
request is on the dispatch queue, eventually triggering a false timeout and
controller reset.

> +	/* Peer memory unreachable from this device: don't retry. */
> +	else if (err =3D=3D -EREMOTEIO)
> +		ret =3D BLK_STS_P2PDMA;
>  	else
>  		ret =3D BLK_STS_IOERR;
>  	nvme_cleanup_cmd(rq);

[Severity: Medium]
This is a pre-existing issue, but does returning a hard error here leak the
multipath nr_active counter?

When a hard error is returned to the block layer from nvme_rdma_queue_rq(),
it directly completes the request via blk_mq_end_request(), bypassing the
driver's .complete callback.=20

Since nvme_start_request() was already called and incremented the multipath
nr_active counter, bypassing the completion callback means
nvme_mpath_end_request() is never invoked to balance the counter.

>  unmap_qe:
>  	ib_dma_unmap_single(dev, req->sqe.dma, sizeof(struct nvme_command),
>  			    DMA_TO_DEVICE);
>  	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723204206.7693=
0-1-mykola@meshstor.io?part=3D10

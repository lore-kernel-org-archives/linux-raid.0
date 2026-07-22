Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC2C470E8A;
	Wed, 22 Jul 2026 19:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784748040; cv=none; b=hbnJf4ivdPUjxbIV6jt2xltsw/J481qoKDpSohJdkPYWU+2RHkpi+SIc+5fPZqogz2IYtP7fLHYFpU+Bu931RXcOTVcqu8QXXaXEFn+YVZZJNLmgkofDxNccOLcxD/uk0gg/KGRXuCjsMYb4tq4gdtQyZ7AqCCtKmiBiOJmUH6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784748040; c=relaxed/simple;
	bh=eg8pLUwVLVPA/yVBDNNOlsmabbZvAA49CbsGyaQuL5w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HEM8wA7dsjSGlSHO8FKWffy87mid020oiCVYwJgoF1skdPF5AV1bxmSP3wbGu+bcxtcI2avgVQwc7rLMTRQK6MAVesswIWHbctdyiVUDW3k4DMhQCvsLmqTH7PxtAgeCjaGCgC9cmd2zR8ERoR+NKmXDLLRw6ZULha/NcS49Cc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JS6leCF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JS6leCF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4631F000E9;
	Wed, 22 Jul 2026 19:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784748038;
	bh=qN7gQzfJG7zTzZ8AXbhBDczYb83olBLvlhCwun1q6TY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JS6leCF9DuZhJp+o4OfkdoBMbBKzZ93nd+WvcYYWXKzYlrxa7j6aNk+8eXz3gVdcg
	 eVJIvunsBKdbYlkdF7T7ttEOKAOPK3QbEO/QxKGWowVKhmCNkwgPu4g/YYaNMC0Zr5
	 6OYPfduwGcAEkjUAFvd9LxJlV+GNvkv5zsdDEgx93aFdb6pj6ceDxQ3szR2RWUMsVf
	 5P1LSKBAxY3TQGgJ02EcXGSK4B1QVscRzAKglbkoEeGwfzA4vZYAJbeyQpTtsp4w7T
	 BBJluJTy9UJqqmIUm5foIZJfXznYK1jcR0GrKRFcWyUC+wtCvv4x+YmkL65HEovslo
	 /72aYWRfyphZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 9/9] nvme-rdma: return BLK_STS_P2PDMA for unsupported
 P2P transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260722185841.449934-10-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
 <20260722185841.449934-10-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 19:20:37 +0000
Message-Id: <20260722192038.2E4631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Calling nvme_start_request() after mapping the data for DMA causes=
 stale metadata to be read by the RDMA device on non-coherent architectures.

Pre-existing issues:
- [Critical] Accessing `rq` and `req->sqe.dma` in the error path after `nvm=
e_host_path_error(rq)` completes and frees the request.
- [High] Returning BLK_STS_IOERR or BLK_STS_P2PDMA directly to the block la=
yer after nvme_start_request() has been called leaks the multipath nr_activ=
e counter and I/O stats.
--

--- Patch [9]: [PATCH v4 9/9] nvme-rdma: return BLK_STS_P2PDMA for unsuppor=
ted P2P transfers ---
commit 53acbc82938f48638ba2fe9095582a69fb22439e
Author: Mykola Marzhan <mykola@meshstor.io>

nvme-rdma: return BLK_STS_P2PDMA for unsupported P2P transfers

When the PCIe topology cannot route a P2P transfer between two devices,
the DMA layer fails the mapping with -EREMOTEIO, but ib_dma_map_sg()
returns 0 and the error is lost. nvme-rdma then fails the I/O with a
retryable status, so multipath requeues it forever and a single path
wastes its whole retry budget on an I/O that can never succeed.

> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 6909e35427942..2f50509a7a616 100644
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
Does moving nvme_start_request() here cause stale metadata to be read on
non-coherent architectures?

nvme_start_request() invokes blk_integrity_prepare(), which writes to the PI
metadata buffer via the CPU. Since this now happens after the metadata has
already been mapped for DMA in nvme_rdma_map_data(), these CPU writes won't
be flushed to main memory before the RDMA device accesses them.

>  	sqe->cqe.done =3D nvme_rdma_send_done;
> =20
>  	ib_dma_sync_single_for_device(dev, sqe->dma,
> @@ -2063,6 +2066,9 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_m=
q_hw_ctx *hctx,
>  		ret =3D nvme_host_path_error(rq);

[Severity: Critical]
This is a pre-existing issue, but does this lead to a use-after-free?

nvme_host_path_error() synchronously completes the request via
__nvme_complete_rq(), freeing it back to the block layer where it can be
immediately reallocated.

The error path then continues to dereference rq and req->sqe.dma:

	nvme_cleanup_cmd(rq);
unmap_qe:
	ib_dma_unmap_single(dev, req->sqe.dma, sizeof(struct nvme_command),
			    DMA_TO_DEVICE);

Could this corrupt the newly reallocated request if it's reused by another =
CPU?

>  	else if (err =3D=3D -ENOMEM || err =3D=3D -EAGAIN)
>  		ret =3D BLK_STS_RESOURCE;
> +	/* Peer memory unreachable from this device: don't retry. */
> +	else if (err =3D=3D -EREMOTEIO)
> +		ret =3D BLK_STS_P2PDMA;
>  	else
>  		ret =3D BLK_STS_IOERR;
>  	nvme_cleanup_cmd(rq);

[Severity: High]
This isn't a bug introduced by this patch, but does returning an error stat=
us
directly to the block layer after nvme_start_request() leak multipath
counters?

When nvme_start_request() is executed, it increments the queue depth counter
(nr_active) and starts I/O accounting via nvme_mpath_start_request().

If the driver then returns an error status (like BLK_STS_P2PDMA or
BLK_STS_IOERR) to blk-mq, blk-mq completes the request directly, bypassing =
the
driver's nvme_mpath_end_request() hook. This permanently leaks the nr_active
counter.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722185841.4499=
34-1-mykola@meshstor.io?part=3D9

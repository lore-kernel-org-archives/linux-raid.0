Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409F538BF75;
	Sun, 26 Jul 2026 12:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067816; cv=none; b=ZrHSgw2ehI0HpVFoR24ZFI1BUkO+lizTSYoYvGdCmZHI1jhHRuxuB7nr3FYSYdNgQiIy7c5l8D4kPifKswJyO9k7WSdI1vOaYgMwrbcaAvEPtOYLuXoS9JJuTBHK6V7dGsgYN6ixQ3xAfdQAtdqPJPtTcGAQiKVxIN7WnVRT1pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067816; c=relaxed/simple;
	bh=CVvO+SeTkEXhTn5LUH5gVB4mH5oYpJYGgwPKG9OcWmA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U4X8GzfuK87E5CTdaDlpmAutZ9tYlNTPgNNNF/YHa+kLck8aI5Y9FjMMxLIadAa+AZWr6m0F/IxCIeEDHNLlJTtXjeB/R4vBIPAUJztvjxdqIiUtqs1Xm3L2EA1F9CqnYk6/q/qZ76qX4T9XDDQJVh7KzBT6iQjmu3LzVE6E59k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NxZP8yVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NxZP8yVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4337F1F000E9;
	Sun, 26 Jul 2026 12:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067814;
	bh=Yuu76qoatS/WuUxH0cxHXw7GAWjI07S6yWQP/vcix9s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NxZP8yVOcIaoJyFMkehEtTnsCl0QFHJs20lUXSM+Y4tvrWigR50o1vN7fM2RLEWM+
	 CCUMmQtHTefKf8pzResuzvi9kWgNd+2ICYVPpUYlSspDPDL+Yt7YK7unyil2s4J/st
	 UCIO31UCPq+7rW21kdTzFYR69PHyZupdCeyLYs33tFiPWVuT9VgKLWRQRoPCLre+My
	 m6tNZWlm99yh/3S5z3ervAWkQXncT1Erf2rnsFf0pvhL9xhXMMj4Ob7iOhqddHOWYV
	 asf6H0jJTvcXzYMSOniWusIqF2RTr1zlbK2kxYx++l17jccKVDu3UMXTDk6IC1mhOK
	 EtXoDVnhnKHSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 10/12] nvme-rdma: return BLK_STS_P2PDMA for
 unsupported P2P transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, linux-pci@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260726113229.2154269-11-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-11-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 12:10:13 +0000
Message-Id: <20260726121014.4337F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] DMA API violation causing stale PI metadata (Data Corruption).

Pre-existing issues:
- [High] Incomplete fix: multipath I/O accounting leak on nvme_rdma_post_se=
nd() failure.
--

--- Patch [10]: [PATCH v6 10/12] nvme-rdma: return BLK_STS_P2PDMA for unsup=
ported P2P transfers ---
commit d3d8febf3662843e41333a6adc3c3ea1d88ff373
Author: Mykola Marzhan <mykola@meshstor.io>

nvme-rdma: return BLK_STS_P2PDMA for unsupported P2P transfers

This commit propagates -EREMOTEIO from ib_dma_map_sgtable_attrs() as BLK_ST=
S_P2PDMA
to prevent infinite multipath requeues. It also delays nvme_start_request()=
 until
after data mapping succeeds to avoid multipath accounting leaks on mapping =
errors.

Cc: stable@vger.kernel.org # v7.1: requires BLK_STS_P2PDMA and the ib_dma_m=
ap_sgtable_attrs() conversion

> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 63830334c73e2..c38d949502b7c 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
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
> @@ -2051,6 +2045,8 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_m=
q_hw_ctx *hctx,
>  		goto err;
>  	}
> =20
> +	nvme_start_request(rq);
> +

[Severity: High]
Does moving nvme_start_request() after nvme_rdma_map_data() violate the DMA=
 API?

nvme_start_request() calls blk_mq_start_request(), which invokes
blk_integrity_prepare(). This modifies the PI metadata buffers in CPU memory
to update reference tags.

Because nvme_rdma_map_data() has already mapped these buffers for DMA
(DMA_TO_DEVICE), could CPU writes happening after the map operation remain
unsynced on non-coherent architectures or when bounce buffers are used?

This might cause the device to read stale PI metadata, leading to PI
verification failures or data corruption.

>  	sqe->cqe.done =3D nvme_rdma_send_done;
> =20
>  	ib_dma_sync_single_for_device(dev, sqe->dma,

[ ... ]

> @@ -2070,6 +2066,9 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_m=
q_hw_ctx *hctx,
>  		ret =3D nvme_host_path_error(rq);
>  	else if (err =3D=3D -ENOMEM || err =3D=3D -EAGAIN)
>  		ret =3D BLK_STS_RESOURCE;
> +	/* Peer memory unreachable from this device: don't retry. */
> +	else if (err =3D=3D -EREMOTEIO)
> +		ret =3D BLK_STS_P2PDMA;
>  	else
>  		ret =3D BLK_STS_IOERR;

[Severity: High]
This is a pre-existing issue, but I noticed a potential multipath I/O
accounting leak if nvme_rdma_post_send() fails.

The commit message notes that starting the request before a failure causes
multipath accounting leaks when blk-mq hard-completes the request directly.

If nvme_rdma_post_send() fails (e.g., returns -EINVAL), execution jumps to
err_unmap and falls through to the err: block, returning a hard error status
like BLK_STS_IOERR:

	err =3D nvme_rdma_post_send(queue, sqe, ...);
	if (unlikely(err))
		goto err_unmap;
	...
err:
	...
	else
		ret =3D BLK_STS_IOERR;

Since nvme_start_request() was already called, will blk-mq hard-complete the
request directly, bypassing the driver's nvme_mpath_end_request() and leaki=
ng
multipath accounting like bd_stats->in_flight and nr_active?

This could permanently block block device teardown.

>  	nvme_cleanup_cmd(rq);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D10

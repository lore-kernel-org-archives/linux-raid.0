Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494433D9040;
	Sat, 18 Jul 2026 17:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784394782; cv=none; b=qKDFtXIFSSmbksf8poi97vx+RDKkwY7ANYADvp3+HfK8/NqKfqo7wkbYOL2tFSZLXdcWRcbHgxgQwGDbTa+bjl5uDMoParHWh7VbhYShWHV+YW/AhJVqs0XsqjMYxMpDsrFSmhEeNg01O3b28gmjCNCv3sIKLjXk67qZZHnJ4xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784394782; c=relaxed/simple;
	bh=351ghL5Z+w/cYuvFapUULxw90ykB594R9BtgHTsFdQo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h9T2CISLfFnHJDRL49BFuxvb1HiUXl/yPGwEGpNQT4wksiqHNxt2RmAA74uaXZfrYTDcr2lQbTN/MnU0O3Jjw6fxyfR7/NrRIOq5eNLVcv9o4GMFqbcye/Wp067kU74NbvOvEoPpIrz0Rn4SiFS6kGdY3xeMcMoRcZhc/PqSofU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHSboXUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHSboXUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF181F000E9;
	Sat, 18 Jul 2026 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784394779;
	bh=5zIMFPvbU4ox3idC4iHNoP0VPGwWmJp4Xv96z2HD8+k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cHSboXUbAufnEvdw7iHuFQGr7bnYGnFDEV7bkhBSJiVjDq2+UfMWSBg7E/8IPPyAx
	 BOAH2YqpQExB2O1yblDJfNGBSqwSemdpsR/wIr/URD4i6AhqMb7sScOZIoOh/CI+cp
	 GY9jeU6InucSMJgqji46QzGxpUM/iLzjgJ/MBy2VALJqlggfCSxqH1zxeEEkwof/U5
	 H4gMXBUnzAIXYgsFbugz1TaiYLaec5Eo+teirNdSGVdrMERR8nIOL1dmx2pxeVNMTk
	 xrBOkt5ggrviZ0qCFRS4L6NpPJpkrNNXr+Sf2k3tAl5Xd98hYkQuiblQNh9VNcfNLr
	 Q0jwIrrRnhh9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/6] nvme-rdma: return BLK_STS_TARGET for unsupported
 P2P transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260718162547.448892-7-mykola@meshstor.io>
References: <20260718162547.448892-1-mykola@meshstor.io>
 <20260718162547.448892-7-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Jul 2026 17:12:58 +0000
Message-Id: <20260718171258.BEF181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Data corruption and PI validation failure due to modifying integri=
ty metadata after DMA mapping.

Pre-existing issues:
- [High] Use-After-Free of request and PDU on the -EIO error path.
--

--- Patch [6]: [PATCH 6/6] nvme-rdma: return BLK_STS_TARGET for unsupported=
 P2P transfers ---
commit efc6b55af9178f85e847e999c50cc6efb530a8b9
Author: Mykola Marzhan <mykola@meshstor.io>

nvme-rdma: return BLK_STS_TARGET for unsupported P2P transfers

This patch addresses an issue where mapping failures for peer memory are
misreported as path errors instead of target errors. It changes DMA
mapping to use ib_dma_map_sgtable_attrs() to preserve error codes and maps
-EREMOTEIO to BLK_STS_TARGET. It also reorders nvme_start_request() to
execute after the mapping succeeds.

Cc: stable@vger.kernel.org # v7.1

> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 6909e35427942..b8642cd2fb793 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
[ ... ]
> @@ -2039,11 +2038,13 @@ static blk_status_t nvme_rdma_queue_rq(struct blk=
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
Does moving nvme_start_request() after nvme_rdma_map_data() cause Protection
Information (PI) validation failures?

nvme_start_request() calls blk_mq_start_request(), which eventually calls
blk_integrity_prepare() to insert reference tags into the metadata payload.

Since nvme_rdma_map_data() has already mapped the metadata for DMA
(potentially using SWIOTLB or syncing caches), wouldn't the device receive
stale metadata without the newly generated tags?

>  	sqe->cqe.done =3D nvme_rdma_send_done;
> =20
>  	ib_dma_sync_single_for_device(dev, sqe->dma,
[ ... ]
> @@ -2063,6 +2064,13 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_=
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
This isn't a bug introduced by this patch, but does the -EIO error path
trigger a use-after-free of rq and req?

If nvme_rdma_map_data() fails with -EIO, we call nvme_host_path_error(), wh=
ich
synchronously completes and frees rq via blk_mq_end_request().

The code then falls through to nvme_cleanup_cmd(rq) and ib_dma_unmap_single=
(),
which access the freed rq and its PDU (req).

If the request was immediately re-allocated for another command, could this
read the wrong DMA address and unmap an active DMA mapping?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260718162547.4488=
92-1-mykola@meshstor.io?part=3D6

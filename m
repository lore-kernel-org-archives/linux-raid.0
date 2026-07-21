Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A650047127E;
	Tue, 21 Jul 2026 18:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657624; cv=none; b=tJVugY1wLUruTYdEiTbTahv+x8pW/NGoqe8kQ7cGU11OkSyIk55j9lhbC8fchnWeNog1zp3BmNKIh3Ylh2VV3AlsYCeH7ruCnNxiZ52XDcA4zGp2vUZopaj5tyDetazJ5jHlu1EzFTsakBEqlWC5pm5D3s4baEzrwptYYhcTCtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657624; c=relaxed/simple;
	bh=P+xB9RBSG6R4ASa5iBHgRA2T32QsUwj6q89ozFRv+QM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I3nfsPzziZ50ff/YwasuP+1kiwNyuXwHP2JMeelTTiT7WHe1earGRAN70VOKcje2AzpTpDqdeBjGRoaJGGMVHJsNfmNZfuMzT+/ZWsxTEh0QFBX6ltykd3N1MlLJqG7LAavoLBOKaMJ1lTYjljZmyTSVAZmegCBbct6adwuo70k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+VzDr8A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+VzDr8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3977C1F000E9;
	Tue, 21 Jul 2026 18:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784657623;
	bh=V6KXhqDYxkBnXyQKRMLYM8XUfkk41tV1nMTXNzFibY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J+VzDr8AyYlsnQWgc6GBDrxhblz1AhxmI0zOfBOPUqV4KupMqTrIHNCyi9eZx2zMW
	 6qKjlAXEh/m6+yFYa6+fwR+mcco2CYFzRpU4YBp4yfuzOsgwPSZEvTl74G7wnKrO5G
	 8XNInd63NvO5PRZHL7tEjMWZKBT+it/4ChlMgVLnq8oo2slNOVQxUWXWfSQ51rnuWB
	 FzbE49tsU7Pxr1dqHrt5uqPQ0RVJItVnJ47HqEcwz23dqdKDgEcLpJIyT7QjaG1SQ3
	 DrjmP4OhniXa9kuLmd0fTT9rvZWyNcnOl0Tb61ZTFsIlNXBCsutOWE0EieXe/Xeh9s
	 ttV6+Y7xT2FAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 8/8] nvme-rdma: return BLK_STS_TARGET for unsupported
 P2P transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260721174502.111503-9-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
 <20260721174502.111503-9-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:13:42 +0000
Message-Id: <20260721181343.3977C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Calling `nvme_cleanup_cmd(rq)` and unmapping the command after=
 `nvme_host_path_error(rq)` causes a Use-After-Free.
- [Medium] Multipath accounting and I/O stats leak when `nvme_rdma_post_sen=
d` fails with unhandled errors.
--

--- Patch [8]: [PATCH v3 8/8] nvme-rdma: return BLK_STS_TARGET for unsuppor=
ted P2P transfers ---
commit 2c3b755710303fa594bcae5bdde333ab1b8dc356
Author: Mykola Marzhan <mykola@meshstor.io>

nvme-rdma: return BLK_STS_TARGET for unsupported P2P transfers

This commit updates nvme-rdma to map scatterlists using
ib_dma_map_sgtable_attrs() to properly capture -EREMOTEIO. It returns
BLK_STS_TARGET for this error to avoid infinite requeuing of unsupported
P2P transfers. Additionally, it delays starting the request until after
mapping succeeds to avoid taking multipath accounting for unmapped requests.

Cc: stable@vger.kernel.org # v7.1

> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 6909e35427942..f8edb23552ad2 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
[ ... ]
> @@ -2063,6 +2066,9 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_m=
q_hw_ctx *hctx,
>  		ret =3D nvme_host_path_error(rq);

[Severity: Critical]
This is a pre-existing issue, but does this error path cause a use-after-fr=
ee
if err =3D=3D -EIO?

Looking at nvme_host_path_error(), it synchronously completes and frees the
request back to the blk-mq tag pool:

drivers/nvme/host/core.c:nvme_host_path_error() {
	nvme_req(req)->status =3D NVME_SC_HOST_PATH_ERROR;
	blk_mq_set_request_complete(req);
	__nvme_complete_rq(req);
	return BLK_STS_OK;
}

After it returns, the code falls through to nvme_cleanup_cmd(rq) and
unmaps the sqe.dma:

unmap_qe:
	ib_dma_unmap_single(dev, req->sqe.dma, sizeof(struct nvme_command),
			    DMA_TO_DEVICE);

Could a concurrent thread allocate this freed request and map a new DMA
address before we unmap it here, leading to an IOMMU fault or corruption?

>  	else if (err =3D=3D -ENOMEM || err =3D=3D -EAGAIN)
>  		ret =3D BLK_STS_RESOURCE;
> +	/* Peer memory unreachable from this device: don't retry. */
> +	else if (err =3D=3D -EREMOTEIO)
> +		ret =3D BLK_STS_TARGET;
>  	else
>  		ret =3D BLK_STS_IOERR;

[Severity: Medium]
This is a pre-existing issue, but does returning BLK_STS_IOERR for unhandled
errors bypass NVMe multipath cleanup?

If nvme_rdma_post_send() fails with an unexpected error code (like -EINVAL),
we fall through here and return BLK_STS_IOERR. The block layer will directly
complete the request via blk_mq_end_request().

Since nvme_start_request(rq) was called earlier and set NVME_MPATH_CNT_ACTI=
VE,
does bypassing the NVMe-specific nvme_mpath_end_request() cause multipath
accounting to leak (ns->ctrl->nr_active is never decremented)?

>  	nvme_cleanup_cmd(rq);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721174502.1115=
03-1-mykola@meshstor.io?part=3D8

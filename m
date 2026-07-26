Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391CA3890F6;
	Sun, 26 Jul 2026 12:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067577; cv=none; b=maglFl4ki2Qax8IrqgCByUviNqX9EOnhpodMBO1qHVqVDT22svy3G5mkGwzVIDeNPps2p7kvxAUD18/Nb8GW1pIQjpmHn2IKpH85wRZtsnNM75+XU9s2CU0lzaf9XKpFpMeiLgrfLvBl/x0H67YWj7OCSun2UGUM63QdBCVCW7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067577; c=relaxed/simple;
	bh=FHiAHPazyVbwcw0wqdJXGiT+Pm93B5n0PTCEcG8bBdQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T0o9zX3cfd9i5IuLMI2+oc+AEJvShadc+TxIF6fqDxO2UdVnOCffnXFYZgoj8yN+UjJ9TiqwsCCrUU3mzDOaetNJUpMiwBNFySEAMcmqdqYLbtiG4v0hhJBNsnov2PZ9AOi0bPxo+flRoQQN5/znmTa1NbpYWXKaXjCl8yoFDxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHxKiwG/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHxKiwG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D242A1F000E9;
	Sun, 26 Jul 2026 12:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067576;
	bh=ybnoJYLzClGw3SYd00TrocCojk7iGPE0DmyFbR7cmAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VHxKiwG/UxEEsF/fyPvW+3bsrdN7FI0NR/CITqSc/iUOqK9MdM8w2y5ySqbmPNElD
	 BQN4m2i55/qPWHtUC9TMimg9OYWKTTmIS+gE39PXYBL0964O3/Jet/WKrbz1YT8D/J
	 GWmqYl9vEm45bCua12wfvxDERJgAYcGOqdtQ/6kcIknldPSPN2c+voFw3ql8bEqrwR
	 1MfybyD02pS21AuKBKFlvB3e5/QNloR19ThSkB+ANvnHc8KKCTkE8iUMGgq/xop/J/
	 Ti1/NfVWvov+xAKl6Crctwp9XitWA0a19P+bauGhuq9psKXmGqZZPKFOq6euzqeLEh
	 2kvp9Eno4DhQw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 01/12] block: add BLK_STS_P2PDMA for unsupported
 peer-to-peer transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260726113229.2154269-2-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-2-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 12:06:15 +0000
Message-Id: <20260726120615.D242A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] BLK_STS_INVAL is omitted from the non-retryable list in blk_path_e=
rror(), causing genuine invalid requests to trigger infinite path-flapping =
loops in dm-mpath.
--

--- Patch [1]: [PATCH v6 01/12] block: add BLK_STS_P2PDMA for unsupported p=
eer-to-peer transfers ---
commit d0a7b922115b23f3d33b00adcd1560732559cd9f
Author: Logan Gunthorpe <logang@deltatee.com>

block: add BLK_STS_P2PDMA for unsupported peer-to-peer transfers

This commit introduces BLK_STS_P2PDMA to handle unsupported peer-to-peer DM=
A=20
transfers that cannot be routed by the PCIe topology. It returns this new=20
status from blk_dma_map_iter_start() instead of BLK_STS_INVAL to distinguis=
h=20
it from standard invalid requests. It also adds BLK_STS_P2PDMA to=20
blk_path_error() so multipath does not infinitely retry these failures.

Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
Fixes: 7ce3c1dd78fc ("nvme-pci: convert the data mapping to blk_rq_dma_map")
Cc: stable@vger.kernel.org # v6.17

> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 8808ee76e73c0..c8de7809320ad 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h

[ ... ]

> @@ -188,6 +197,7 @@ static inline bool blk_path_error(blk_status_t error)
>  	case BLK_STS_NOTSUPP:
>  	case BLK_STS_NOSPC:
>  	case BLK_STS_TARGET:
> +	case BLK_STS_P2PDMA:
>  	case BLK_STS_RESV_CONFLICT:
>  	case BLK_STS_MEDIUM:
>  	case BLK_STS_PROTECTION:

[Severity: High]
This is a pre-existing issue, but should BLK_STS_INVAL also be included in
this non-retryable list?

Currently, because BLK_STS_INVAL is omitted from blk_path_error(), it falls
through to the default case and returns true (treating it as a retryable
path failure).

If a user submits an inherently invalid I/O request (such as an atomic write
exceeding hardware limits via RWF_ATOMIC), the block layer correctly rejects
it and returns BLK_STS_INVAL.

However, dm-mpath will incorrectly treat this user error as a path failure,
fail the active path, and requeue the I/O. Since the request is genuinely
invalid, it fails on all paths, causing an infinite path-flapping loop as
the path checker periodically reinstates them.

Could this lead to a Denial of Service for all legitimate I/O on the
affected multipath device?

>  		return false;
>  	}
> =20
>  	/* Anything else could be a path failure, so should be retried */
>  	return true;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D1

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26266364926;
	Sun, 26 Jul 2026 12:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067314; cv=none; b=IYylUS3tyEARbPlNN5+VUdZBOROlZjYyGFKtmM7vhNcn8TDrg5mhdgzY6ucVwUIH4YuckCjsquE1pq7YhXEsdRkH+VUFFTxfgn8u/P03NWJP44LzYWEFn0BjYotlp6IJuTBqorn7zrNPQzDgvi77ZAGlN+mrmjmHULOnJw2lTUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067314; c=relaxed/simple;
	bh=KqZV2QCn8J53FGe/xJ5n1oT3HiMRBERge9K+tFJyp50=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AE55e4ohPd8FKHM5zrFu+7yGV4HzNxWK+rEw5LfUxYGfjhszQZl2f0ZNL/VRXxp+sbStlqAvEI1FwYJyqPyczWlqX958cQaf9YdZroIBTyzH5XWEwnKFsxNtLT5GCDaXid4dPYxbSpmYSZF5XzwxkwBwyGLUl018AX85zUEXwKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pz/KnSOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pz/KnSOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903FF1F000E9;
	Sun, 26 Jul 2026 12:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067312;
	bh=010KAmYRFaF48Fcf8Emg54DnKkpRdU8jVWhJ0A++z0o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pz/KnSOOvnARtB6mEG2dj1uZ9vqe0RR0iKUTALau++xcS2H5Maz3vu4lRFcTcjzU8
	 eAYFcBjWiPh7odVaOADUsXKES3gsMlDHFsjDC54f1EWtFImgTf9aGkMjwapeXM25xz
	 9KXyo6Nuu/w0TBMr8dWadco5PUMUncuvcYCg/iifQMg7wU5c8xE6GDiyzKogYyW0fm
	 HQj/ySTXUYvSzB8vrPE/RI0hgza7t1yX/5RNz1SVAr7dhT5Fs8IGivIr9F8tbHOxXt
	 K0HN10/QVrfmWOA1107n3DUYLeVkTp2/4o4EbbcxH3DDhzruR1LP0pXbIcHy1W594Q
	 +X9k81TsxQGGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/12] nvme-rdma: use ib_dma_map_sgtable_attrs()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260726113229.2154269-10-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-10-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 12:01:52 +0000
Message-Id: <20260726120152.903FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> ib_dma_map_sg() folds every mapping error into a zero return, losing
> the DMA layer's error code.  Switch both scatterlist mappings to
> ib_dma_map_sgtable_attrs(), which preserves it for the next patch to
> act on.  No behavior change: failures are still reported as -EIO.
>=20
> A local sg_table is needed: dma_map_sgtable() maps orig_nents
> entries, and the embedded table's orig_nents is the allocated count,
> not the count blk_rq_map_sg() produced.  rdma_rw_ctx_init() does the
> same.
>=20
> Assisted-by: Claude:claude-fable-5
> Cc: stable@vger.kernel.org # v7.1
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D9


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A111155757;
	Sun, 26 Jul 2026 12:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067365; cv=none; b=jWClC2n8HLzQsh/5rGQgU1O4vNN4yV8LU3Ogjmdl1KyMi2sih/Fzem+vb5azIGZzU5rkqtuLjsIg6LTO1hmWdJ6CM/LVl8q0QLJGvy/4coCupD6sL8qQ0JpMfJEPhrnIZEkrYzxbKibIrZEhZjRfsQdxPdOXHA3NUtxNQ1siK1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067365; c=relaxed/simple;
	bh=lw3CJZHn/sHdwjDEhGSIj+H7YHSxDLawa/UKdh3y9z8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AlKKtzx1zspugm9BjUY420OAqWAzFTkQO8hmkrr6u0QISOTW/crg/35CUVbJlcUCbxIkE8upjYt+0RcauviJ08mZZaXE3VZiZY2o9UXtv0sRJZTufwKNPMHf101AvXqSuWrPlJWfyqz26E9YUGHLzNMYco9/uASYeVoHD5mJDj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NL7N3H1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NL7N3H1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4A61F000E9;
	Sun, 26 Jul 2026 12:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067363;
	bh=Ph6h/Kg/xAZG1eiHM9mYihsGwb5JkG+EejQ1aukQuD0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NL7N3H1/qlNxU4L8EbMs7QF9AzRg9/9g3+9jaaqB09f/bSNRgWnzyEhiSeAmFXHNa
	 T9JObUC285Y+uroAJLZcRFPcrXfC4QBLqfz/UhmHesIMXLNm4PK3EpPNaVpE2jEbJs
	 FME3XdQrTtpW5r1FxIAmjwJ/8vouf25qB1JJzTu4aC5WZxiig53DGUVylDoS6YR8uB
	 xJnz9rzIEkwkmVyrqQUWThOO277HreXydr/0cuNun3QpIPVwFUJZ/4937buvOcUHrt
	 7oHslhYo/QIBrgFcHbW15aHjZpQK9s6W3xjchx+pNceNpJ4axt9gPxwGd2prhpIrG7
	 GjcjQjf/J0DKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 12/12] nvme-rdma: factor out the scatterlist DMA
 mapping helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260726113229.2154269-13-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-13-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 12:02:42 +0000
Message-Id: <20260726120243.5D4A61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> The data and the metadata mapping do the same thing: describe the
> segments blk_rq_map_sg() produced in a local sg_table -- the embedded
> one's orig_nents is the allocated size, not the valid-segment count --
> map that, and hand back the DMA-mapped count.  Fold both into a
> helper.
>=20
> No functional change.
>=20
> Suggested-by: Logan Gunthorpe <logang@deltatee.com>
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D12


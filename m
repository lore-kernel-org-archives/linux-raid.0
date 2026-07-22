Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FE4470E97;
	Wed, 22 Jul 2026 19:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747240; cv=none; b=EGB2US1kPg8dgNpzGl+VCy69E716ASj4fDr3eSsr/14U//QFlWWebjmwtPFqnKF6X5l8xLm0AZBh6SwrQFTjSGOlppOrq7QM2fUzShR1QmeSWVlffn8zzfDeaMTFMWwwd4jepEbWdU/579BTYoUx/Agj7i0Okrb6TnOaBSAU9gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747240; c=relaxed/simple;
	bh=YLXTr3+lfCt5Fy/pNHCD5fN5v7ifhRSAjSbI8Hgh39U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F5G1VdNpkY3dyDBmTSYFSUHt+Yj75/dDvn01CFd/TcKlWtvo3XZWJHhs/a1yXAbVkpQ2BQsn8zXw0yFQOD9XdWsBYQAiD6dmUdMahGH6XLFjxoedqBIzmQbotOoUR81m8f/u8NCYsytgM71rq2wTXvmxz29HeaR2sPdIeKOoYGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJ2TTJix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJ2TTJix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71251F000E9;
	Wed, 22 Jul 2026 19:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784747239;
	bh=Hf15RTMsFmXGPHnfwzyWY8HZECZHsw+hEuLHjd45GBE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kJ2TTJix2SZBcQNJNZije6lctrFVV7gCihwILpt/CEBLfyLqNlUnHWKSpyeQTfh9a
	 VDAPUyEgahC8QHGYYtM+yDldAzBg86dUhv67yWLAonSr8ab5v5tA6WNbo4GOSLe+DX
	 iRL3z6zSpVNuwNREm5mFV3OT31lIzU5xJiQlOzAIUP3Knl69ojes8iQ3esQH3mO3Vc
	 Ugcl9MkLnZ6hUGglEMzHkkrtPwK84SlUPTjhdftxhR4O4fTXkFa+jST/M0JOFEH1by
	 bQhNCFfmFsiJu7DdANrHJ7NijwCMEshoXRRwEqg4N6yx0wD53roXMulnZVEKbhD6ha
	 7OrfOMvqWcOCg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/9] md: ensure REQ_NOMERGE is set on P2PDMA bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260722185841.449934-3-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
 <20260722185841.449934-3-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 19:07:18 +0000
Message-Id: <20260722190718.C71251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> md_submit_bio() strips REQ_NOMERGE from every bio.  For P2PDMA bios
> the flag is what keeps requests single-provider (see
> __bio_add_page()): merging a P2PDMA bio with one over a different
> pgmap, or over host memory, maps the merged request with the wrong
> bus address.  Set the flag on P2PDMA bios -- bios built via
> bio_iov_bvec_set() arrive without it -- and keep stripping it
> otherwise.
>=20
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devic=
es to RAID device")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722185841.4499=
34-1-mykola@meshstor.io?part=3D2


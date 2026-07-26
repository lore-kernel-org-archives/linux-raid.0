Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193DC36AB5A;
	Sun, 26 Jul 2026 11:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067146; cv=none; b=Za+G4Hk0IBuiVoy7XIQgIw+FRgtGlBii0MujXx+fXK2tolLgf07/yMIgN26HHRk1rWoMgJsyq0pZzZYPyz1XTb7UOpwZYOgug+dlbrSMdwgJgmm9ZfPzhMRqm05b939J+1qLoWz27oPi4dHkwwOF80T5NXu8u/YaBYj+rIprMjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067146; c=relaxed/simple;
	bh=cwVQ51EwCm/Grqf1bVlOCzH7enw5OT8urSJqEjfdGxk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Lh0i6Uh8suOoY3CfHUHppvW4PF2GyPDW1jS7brUFs/YjPVPMl9R2sCT5XkOP4mEtP8Gp86EczG8sbwOA4EkKmVhhHsU4Va1KBHVAaxahlJ7swbtSbr1xusg1ZQfPBceWjmf4cp1bfSPZ2j3M/B4mUNxBtWUHhThFr4/bqXNSUzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqLNWxC/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqLNWxC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763C81F000E9;
	Sun, 26 Jul 2026 11:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067144;
	bh=0kRCpuPBcvz9tBh7/1sUoxjk4yJCOFj3iGMJjG1H29I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XqLNWxC/Wam5hPd2eTDiTGXTnolCF5lB0V673CXlIk4qGBCBB5xvYqZrA4OdtpUus
	 auj2NjWXMpNJdHlQa2XPT3qdPfVM/H4RFLBHkjkY5+WRV17cIRsAYzcclk9vKi/Udz
	 tz+371GgrpCf3cr0kli64O+6rZOYcuaoWpwlmyAm9QJ79Tx1FAruFNwoSjsm/RWXRO
	 ELq9vdo2X+9I8plR3x+gHwn26VLBWXhgmac2PBiBQkuCtO0+nc+lnEtWcw4hbbU8Jj
	 u3RZd44uu4dY9OS8mkW8xCZtT3fojpmwh7nvcojNzL5vF9jKQiZ8tDDbpS9ALz77lR
	 6pL8FnJ3ceoUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 02/12] md: ensure REQ_NOMERGE is set on P2PDMA bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, linux-pci@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260726113229.2154269-3-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-3-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 11:59:04 +0000
Message-Id: <20260726115904.763C81F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D2


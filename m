Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE0F3815F8;
	Sun, 26 Jul 2026 12:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067273; cv=none; b=gaoDURpzbBzZoh8D0xpTBBqdUNWx3ze5AkAxCzQ1VDPm+Jfzhqmv88LW2EkPDJsoXlXWZ4oqARQtYA50FL39G9qm0TNCGEg5UyB5VnYreg8+NscTunQCLXwtYuC6h7d/ENbEzSW6ijhiXXvYBIULE44+VJZc+crSdDbFn7jVcMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067273; c=relaxed/simple;
	bh=LvUSu1UkDCLvUe007YN9P7sOYBPpUqslSHPEiZQkGys=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r/0jl8OsbmdQirWtIqkV117k3dFL9Jg4bZuO8OEWLpAaF8dZHDpdReCpUfbysKtgZ424tHdof6voslIoqhpbjSujnsVnqjf6zv0qxsvJf3nftL5hVHUtHg6rKQ5w62xYGobxHBMNfMUj2lie7omTlAWJT9DOhNm/cfKPtAh22/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sem14vP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sem14vP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B259E1F000E9;
	Sun, 26 Jul 2026 12:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067271;
	bh=oYTrwVHmgtFFJlN1f2V+xGnSZnwJ2Hvnv+F7LzDdFxU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sem14vP8+M2zzsseNlQcwELnjf2KIXEymUra1a7cKffF19g5cgs4/JIKiCw9tRbZJ
	 EZemHfF0uOKMFFVUySx8zKEIpfGdW+UcSI/B6RZYnVnEq/3TpWPdyzKMONsZKatVcK
	 U7SYO/Fc1RYiS80m9DqFY/vJGEHFNW8Y7buJlsSr/txUV0wI8B52TrsthTk+P8WsFo
	 islWg6VM87Eds4ReemWUVCZhYJaP79Xc1ZoCyqfSjcEKyLg0qN6dVP0Ku3t4Kj4UfO
	 jPD2rr75rPSeXAFTo4ZsY8CekUyouq09b3Dl8oePJbNPNTJ99Czja5OamjkFemURzJ
	 pUU+fXXwgrm4A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 04/12] md/raid1: don't use write-behind for P2PDMA
 bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260726113229.2154269-5-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-5-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 12:01:11 +0000
Message-Id: <20260726120111.B259E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> alloc_behind_master_bio() copies the bio's data with bio_copy_data(),
> a CPU copy. P2PDMA pages are peer device (BAR) memory; generic code
> must not assume CPU load/store access to them is safe or fast on
> every architecture, and bouncing peer memory through the CPU defeats
> the point of a peer-to-peer transfer.
>=20
> Skip write-behind for P2PDMA bios: they are written directly to all
> members, including write-mostly ones.  Ordering against write-behind
> I/O in flight to overlapping sectors is preserved: the non-behind
> clone path serializes on CollisionCheck rdevs (see the preceding
> fix), which covers these bios like any other write that bypasses
> write-behind.
>=20
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devic=
es to RAID device")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D4


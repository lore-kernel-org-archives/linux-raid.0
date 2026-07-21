Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AC547125C;
	Tue, 21 Jul 2026 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656486; cv=none; b=gnY+QsubEJ3P8u/YQ9/pWtOeRvbrhcUKM2owbAAoqrJv0XFRPcwuihJzG5oJJu1FKF7ASMs+T29UQGCZsPQPaM9XvcNFcP3T+K/VBo5PaiLn9vKIJFXss/+EAuLFY3ejsuF8ATFIMWVIXezifIDSdTSzmvUOvBz407cjmTp8b9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656486; c=relaxed/simple;
	bh=VsxgSGHIrDjbE4z1Sir+dX926ky0ASw5FqMugOzTT5A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sd8glue5RQ6TojGzZPBV7Q06FziVGpD9KolCQSaH4zThZT80fjWzVERFhKMVQ36EtdmuU55QfaL2UuvxD0dYMoruZqlWcgyNlP2LYvQ1TpvyL+43SAx68zhbCq6klmZDEAPceAmJeagMRz8W0o3w7TLW+cm3qlG584oPRWWNeQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHHSuEjy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHHSuEjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12681F00A3D;
	Tue, 21 Jul 2026 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784656485;
	bh=cdP/RUX80kzT4MryGo4eUHqqhbly8a3X34uVQU5OmdE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KHHSuEjyRVHFpSVK59IrixK7ERPxw9Bp9FEp3E+30yShjdMJfw2BD6t+Tbv7FOExB
	 uicg79tG5EmBW4JZIQJnBIJPFdwEgdJaKvavgdW59fsC3EzwBdodJncaRPSNN/JV8Y
	 +DlypmhGOR9ln76bKMwx5iLjoK1gbOE/f00PhE5kYkzTcHinKi5m8subR8UgidmWSI
	 J2N88yyw0ILE+KkWndCk9YNGj2k8K1Jqr1bq938KND1C9EzEA3Y1DeYc5+CBkKPDKV
	 jhHwTsa4fJVN9/s8HKkiVYBKKXzOMLOoxH09WT4KcVylTWeDBn2LZXr4ijabwpyAst
	 9nktvmY/Dv9OA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/8] md/raid1: don't use write-behind for P2PDMA bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260721174502.111503-5-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
 <20260721174502.111503-5-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 17:54:44 +0000
Message-Id: <20260721175444.F12681F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721174502.1115=
03-1-mykola@meshstor.io?part=3D4


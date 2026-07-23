Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CB73C872A;
	Thu, 23 Jul 2026 21:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840510; cv=none; b=A3F4S7XPIKwWdPVSmMIG5WTbhnj5SM196OWPaEtN3WYcTuTZmAqGykOF0Ynm7+WkYQTEBKgCVeT81OK9nI2boQTw9A3scce3dczDun3A57A1axic8ohEE3Q1zbgpIKWPyYXdcUkNA2hXyl0brrCblK/DVSzkiYMaUpDaMlG72CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840510; c=relaxed/simple;
	bh=ol9dBFBibD9sT6WbimjnkYLhGQU+LM1km9eXoG8ImyY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MWX1O/KEezCPP7zqCf5sLf5U+HQrDt9yWFqSZSg3qdxcTE2oVooXKNUskL3DioqQKIDqDOyam/Gzv4YCRBZ/g7R2HahKTAU+Xayp4hUe3KMgSc0t6GrAVckpZFyA3YTctQsb70uaCYH7B2cBnErUSNYFY80//aSDsRcEz5W4s6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8+fz/Hb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8+fz/Hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583331F000E9;
	Thu, 23 Jul 2026 21:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840509;
	bh=XqWvKmVpTqNOqKtLvoCKaLR0PWTLFbCypxGBRKWTLS4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d8+fz/Hbpx0BYAPb9IeDrh+xLkx9ly8BrBysd0aJUuRP+O43w98rtEeYUvV1n+ci8
	 gQ9Z2fZksYTWokRrrTff0IT4AdD27POnAHrCkqO8zqHubG8m8dGR+fCfU9cN4jQax/
	 ALP2RoFwF6++9QV3DgR5wD431ua0xo1M5zaMqzRtBionrmUC81G5nEGYhkeKTmLWp1
	 MCpHhKAButCm1gmTV6xNthT+VANNTP9PZeXJYUkSs3vfD3Y4dV6nnuLFN1rppGNfdJ
	 HjggWKMN7cyI0N2uo9vf14aJZKXj7Q70/FnFhdB4auqexkbyKgsuKzEgPMyiiPT82W
	 QX1F1KzNpGk4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/10] md/raid1: don't use write-behind for P2PDMA
 bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260723204206.76930-5-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-5-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 21:01:48 +0000
Message-Id: <20260723210149.583331F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723204206.7693=
0-1-mykola@meshstor.io?part=3D4


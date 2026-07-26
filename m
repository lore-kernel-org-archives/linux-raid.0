Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2D02AE8D;
	Sun, 26 Jul 2026 11:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785066806; cv=none; b=qUlCst1/2F3CjMOCGq0Ja9T84sC9TjpxAoTot9H0zFE+HCyUWwyR5JSb9NE+jYHvQwkAYNWMWQvvaleW+VNmbRuk0q0KfX/AiErDmzzwnVLIh/pd5lPZulyFTX/RyjqBUaTE9vayobVfrPD4n4BYLe0PHtXfAgxzfupV0vcYH6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785066806; c=relaxed/simple;
	bh=O6VmtaJ8IK5m0R9cDl5x4psJjs0WT+IN87Gf8s2Xo/E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=c5Ki3yQhOaWmKzmxc4IWogEFFu0c5vXF9ra3Af97WC6h6xXz7KeT9nIIrvlm7kLROYHo8lAPgYUKg9C53NC3OodK6IxTsJid0Iadky/v4tou2ct9dBuwwSIG8eFuVfv1feKBlFAiichxxZdtRHQxeFtxvrejc92ZZi6JHUzliks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CeVkAQm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CeVkAQm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BA31F000E9;
	Sun, 26 Jul 2026 11:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785066804;
	bh=W2jaBqmRPcmiZj5ATxtqHhVF3HbCgGf4tJUyRiwLEbQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CeVkAQm31l3QmL1nzXN6eXM8VwqECjbZF91RTRFgivlhVp3hpb9Lw76rhLXDf6tlJ
	 Rbpob5RXMECyuL0sjZ5xnjYKYN73tEF21UiLrFbYhQnDekUoOOdzUn7gW9XBZW9hak
	 h1v8YScQBEuxqVm8zrdbKNCZ7gZnAnv+aEaXK6zHdMJtQ/jpdDppYB6ZaU3zg7r/Fb
	 UIF+RWpgMAwbVXOM2vhLQWNt7Fm2pZMYMx9thGC6cHP71Cgv0GcePgnVoEvRAMzH5B
	 H+71bp80O+JDqSc9K/4/BwiD7kYJkkPZ0FdC7/2vb8UtnW56kJG9AAlHGiZYj9j4sd
	 JI33bx9K6WdLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 11/12] nvme-rdma: ratelimit the map-failure error
 message
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260726113229.2154269-12-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-12-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 11:53:24 +0000
Message-Id: <20260726115324.94BA31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> A mapping failure is per-request and, for an unroutable P2P transfer,
> deterministic: a workload that keeps issuing one turns this into a
> log line per I/O.  Ratelimit it, as nvme's per-I/O error logging
> (nvme_log_error()) already is.
>=20
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D11


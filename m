Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8C7387359;
	Sun, 26 Jul 2026 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067074; cv=none; b=ftmVGkh/HWClw3UWl7KqdBkQ0FbydAe6aM8S21PkvatZCQIdICteB44m3ri5h15iN45t1f1KJ+3cvzpEXLB3qNXbE6vn7A24K2F+EQ62DUzUcwePhl5tTD4lE0ry4sQRE9tjWCcuiB/A1d0mOu+UK+aKVB08Y3vg0OX9EXqzMME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067074; c=relaxed/simple;
	bh=qt8Gj1gUu07JTZnKFSzdOFqeolf8RODCn5QHTZztdOs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sPLEaP5JIeHacTvIMYyKKClLQNrlvx5FdgMBvYFKKYRzvv+f2U4HCorhp1B0q3+QbRPyD87ZHBR8socYAhoOMnb8AB5FZe26AJbRsq9BQwzSNRf0/twYhWAjo8cP0698wGpX7+hjth0yy44tmecdgKK3CTuy2VY5rD+EBLIgBjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IICqYxgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IICqYxgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172F81F000E9;
	Sun, 26 Jul 2026 11:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067073;
	bh=qt8Gj1gUu07JTZnKFSzdOFqeolf8RODCn5QHTZztdOs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IICqYxgTzdo8RHnPvSvt6sFh41p4ovtF0Hi34cfC4JOJuUnvikYLvusJtffLDhnrM
	 CDHAquSmqFFwTDSoI1lOITaETDjzJCQXaNekBZzyZGmq75oeDYGewLVNCZ90ILFS1A
	 eJIZKbrJx10763dssxRRprIR0sGbMoK684vKMTFVATuKC7xykS13KW8TS1PkKth58S
	 YJwEIp0JKoP91KqUENA54iWKIAdarCGfP3DHiQdRcnwI2iW5jYsKavy4bcwfiQpTjI
	 3TDPyINVZ7a0KEXIJfTUYGNjfxQjJrz6jiGT7UVD0bx0fCMIDsAsSz7Edq5L6JnMM+
	 8WBNsXpKF8H6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/12] md/raid1,raid10: factor out
 raid1_write_error() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260726113229.2154269-6-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-6-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 11:57:52 +0000
Message-Id: <20260726115753.172F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> From: Logan Gunthorpe <logang@deltatee.com>
>=20
> Factor out a common raid1_write_error() helper from raid1.c and
> raid10.c.
>=20
> This will help reduce code duplication in subsequent patches.
>=20
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D5


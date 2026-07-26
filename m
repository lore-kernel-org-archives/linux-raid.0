Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38E9364926;
	Sun, 26 Jul 2026 12:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067400; cv=none; b=F4xPupb662YswptSDqS1PGZ05r5QyOf/Kh025S9aABrejUbp8uym/EG1DXyIDERhZH7FtqbgX7QZUXJAzmNG3CaOeaMEpf1oV+tLwzcQk7hNRLcD/uywxxEIoE5q8O3jTehrngz+fa6rdmVHgMWpASzO8oV4kBxQjwCXZ/i16es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067400; c=relaxed/simple;
	bh=CZsHXAyE5SXaeEBer7Sutc7JrCZah1ro23GzHWJLNkk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gw1PK2dn8hr2MWfm9Qs8IorpaUSX81qWho2cOSt3vQbdL8d0HBnF8BFpJlhf047ctW8VBPejag9XtLWR/eZKigTAQm02JnDSi93cVqEJ1lt/ATaqy/m2G7IbtUkC8Qfk3czYUyR/SCFpVfNOgGe17/j88rRnTt+KxiabeoLiaj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gMt3uyAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gMt3uyAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4022E1F000E9;
	Sun, 26 Jul 2026 12:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067399;
	bh=fXbcMlcTXwB6kQc2xfVMfWDlZzNmxoUK9O44S8xiCIg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gMt3uyACHKfwvfrt57SCKFdOGf3KBbxNIeqhveIwtssr7qxI05daEPZ64h3Nm7sYt
	 jbfI7DfehrzlpXpRweuH8B9OWzZS4NMkBC/K7iONKmC6e3kuBfi5OHwOhnTRRawgWF
	 oFniKxNOKwkTecjvUpmCYONFe9m2RF3LXES5JF6LPPVxH+F0H4X+bdOYlplZL9D08G
	 Y7ou5hJLooXPk1+lBaLWBI+pjXw+nlJMtMiSrl2kScPvopSiG7QF6IJRZLhc3Hc76d
	 N9Ng3mQG8nA1G4nt3HXMn39vObngy3/TyY7GF1pigl3jMZ1TQoqJiPdd+k7FmJZOjg
	 SxBIdhvWeptXA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/12] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260726113229.2154269-8-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-8-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 12:03:18 +0000
Message-Id: <20260726120319.4022E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> BLK_STS_P2PDMA reflects the peer/member pairing, not member health:
> retrying the same pages on the same member cannot succeed.  Keep
> WriteErrorSeen so the range stays fenced, but skip WantReplacement and
> FailFast eviction, as commit f7b24c7b41f2 ("md/raid1,raid10: don't fail
> devices for invalid IO errors") did for BLK_STS_INVAL.  raid10
> replacement legs are unchanged: a write error there fails the
> replacement, whatever the status.
>=20
> The failure is whole-range and deterministic, so narrow_write_error()'s
> block-by-block submit_bio_wait() retries are pointless.  Record the
> whole range as a bad block in the completion handler instead.
>=20
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devic=
es to RAID device")
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D7


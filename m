Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98032E2286
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 08:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782203356; cv=none; b=o6yK1aOXrqmJPEEzW9gxZJiA+75mfrieWJGcU4o3rUw95LdL+1pYrgXO1BISH4RncEKUN23+lBewC1UCSsReCJtfK5zEZlkiE6BVZvsyHpBr536PVpbgOz8B1ss0MhYjrzwycAODICBT5n1la2GRfY5SkF/yzCXjLmsoTCSJxkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782203356; c=relaxed/simple;
	bh=7I4spP17pne2wla5cctXKEE3DnG2+SMuHYNacG3hJLs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TZGSGsfThiWdbPnRtEXmBuUA4vDpzxgIx3TAla6HchuiBjkw0EaZ8mrEbWNorTljTnIVPgIRdoMIdkqdHciFWfNr7i0qP0mQFBCEavq00A06d02t40wid6X8YQjWqwJuy7KXZfeBza7MEXAS+jQ7AUbmAfLA2QeafNlke/deiX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IrP0mkyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IrP0mkyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8A71F000E9;
	Tue, 23 Jun 2026 08:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782203355;
	bh=NFBNuJCYgsBIUHyLvlUyJ6T67AUo5+1TxyHwo+YoePs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IrP0mkyM2WsVME2uKzDABsDX8wDpoBnH8wV8tw7fQDyhPGLnw79n7yxR7Mx+HdFjT
	 nHMmJ0UWoYlAZakB5UvzWIb3sq4ciYxUW086aiARmwi3+foiP0OL7g/5J/uhBCAXSI
	 zRxxWrbFnl3iz/Kq1jVX7t76Qt1OCpD5Az6DU0BtbpVaoFj9ApZxqMOrjTQE3rlfHM
	 Db1fb+o3jgDDfNLgcGf6KMEcjAUsZaCWDUCSunMoUOWUPSlGVpAtGRrL5E2XnRsEm7
	 usD93I3KbIHDNNJtpR/gek9UdWZXpt+qztLi5R/x4IGAVSFr0LI7P9Uorh4IxbG5gc
	 h4Ey0FwWtX6SQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: use READ_ONCE() for lockless reads of sb_flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260623081942.2488045-1-chencheng@fnnas.com>
References: <20260623081942.2488045-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 08:29:14 +0000
Message-Id: <20260623082915.1B8A71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incomplete fix: The patch claims to resolve KCSAN data races on =
`sb_flags` in md, raid1, raid5, and raid10, but completely omits the necess=
ary `READ_ONCE()` updates to the `raid1`, `raid5`, and `raid10` subsystems.
--

commit adcaa558925c24a70a377065ea735febac939f0b
Author: Chen Cheng <chencheng@fnnas.com>

md: use READ_ONCE() for lockless reads of sb_flags

This commit adds READ_ONCE() wrappers around lockless reads of mddev->sb_fl=
ags
to prevent KCSAN data race warnings. The commit message states it addresses
issues across md, raid1, raid5, and raid10.

>     sb_flags is checked without a lock in md, raid1, raid5, and raid10.
>     KCSAN reports these reads as data races.
>    =20
>     The write side uses atomic bit ops.
>     The read side still has plain loads in a few places.
>    =20
>     Use READ_ONCE() for the lockless reads of sb_flags.

[Severity: Medium]
Does this patch completely address the data races mentioned in the commit
message?

The commit message indicates that sb_flags is checked without a lock in md,
raid1, raid5, and raid10, and includes KCSAN traces for raid1d, raid5d, and
raid10d. However, the provided diff only includes changes to drivers/md/md.=
c.

Are there additional READ_ONCE() updates missing for the raid1, raid5, and
raid10 subsystems? For example:
- drivers/md/raid1.c:raid1d()
- drivers/md/raid5.c:raid5d(), ops_run_io(), and reshape_request()
- drivers/md/raid10.c:raid10d() and reshape_request()

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 096bb64e87bd5..f83cca895f85f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -10425,7 +10425,7 @@ void md_check_recovery(struct mddev *mddev)
>  			spin_unlock(&mddev->lock);
>  		}
> =20
> -		if (mddev->sb_flags)
> +		if (READ_ONCE(mddev->sb_flags))
>  			md_update_sb(mddev, 0);
> =20
>  		/*

[Severity: Medium]
Are there other plain reads of sb_flags remaining in this file?

Looking at drivers/md/md.c:__md_stop_writes(), there appears to be another
plain lockless read of mddev->sb_flags. Should that also be wrapped with
READ_ONCE() to fully eliminate the KCSAN warnings?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623081942.2488=
045-1-chencheng@fnnas.com?part=3D1

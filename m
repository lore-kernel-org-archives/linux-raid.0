Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C515775801
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703523; cv=none; b=Y2HmYWXlRL91O8GyWB8qiqjwktUT8ZVMG3s5d7KW8IQcFjmyTPbmTaPO18+KDHlnKn0qZOlxtta7MZgKgE0qwvbqBIblpyngyTxINvIo6kWg2tbvPQWbYzSzBJHsqX89RPU8OAB9ybztD76p6uT5i4nxheu+vXL/lj8Ikph1Mu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703523; c=relaxed/simple;
	bh=f1U2+wi2mQ/+2faB+puQ91BvYvj8LYlE7pLEdqQIzKQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R9sQtgcyJ3nyqZ0sAM0VFC6mSviwe/QHinvpYU0Ijl+pP20SGn+kZzUwljBYiof9KcB+Y8csNyyPkb2tnEL+oKjuCTaM9moDhTVRKpnQruKpiQmZuxKR15I8L9Cw4YkKGQmUuP72GnPdJhA1nl+mylOYkxrgR2ECr7sIzYErXeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OP7O5E02; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OP7O5E02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE7C1F00A3A;
	Sun,  2 Aug 2026 20:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703518;
	bh=M73ZGDFus4nBdVzdzXHatMnYZg4B1U2OsrhDRkmc2Rc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OP7O5E0232mXtV4y53I8V50X1sGjaKhAjo+1vmwUvLC3poynE541Y6vRL40dLzqwL
	 moncazETJJQgdbocRsKY3KDpP/Qiqy4ebrHf0G6ZmJJBaEv+kCXeVRqNtLSz5Tvpm1
	 cNyVca/gjK/TlMlxPdfUu9UMIO+XPHfNOfk7Z+O15Pnh2frDby3JVTdqNbJN4COEnt
	 kYF34BVK13Or6INAi+MZrRrfTSy6S10vYyY6+Ilb6VvNlNMUf53x4l7A+80ono+0jo
	 yNxw4HJYiGfX+YityQns7zzYyFZFQz1cwo8AFb1ZINZIj2GoxlfSZqwCGeN4nRU5/A
	 7KZA7WzWJE9dA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/29] md: avoid stale clone I/O accounting
 timestamps
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260802195038.164272-8-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-8-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:45:17 +0000
Message-Id: <20260802204518.5BE7C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Permanent in-flight I/O counter leak when jiffies wraps to 0.
--

--- Patch [7]: [PATCH v5 07/29] md: avoid stale clone I/O accounting timest=
amps ---
commit 3831c24d41ef696f06d6f215b39197db739a0831
Author: Yu Kuai <yukuai@fygo.io>

md: avoid stale clone I/O accounting timestamps
   =20
This commit avoids stale clone I/O accounting timestamps by explicitly
setting start_time to 0 when queue I/O stats are disabled. This prevents
the completion path in md_end_clone_io() from using a stale non-zero value=
=20
from a pooled bio and performing accounting that was never started.
   =20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9448,6 +9448,8 @@ static void md_clone_bio(struct mddev *mddev, struc=
t bio **bio)
>  	md_io_clone->mddev =3D mddev;
>  	if (blk_queue_io_stat(bdev->bd_disk->queue))
>  		md_io_clone->start_time =3D bio_start_io_acct(*bio);
> +	else
> +		md_io_clone->start_time =3D 0;

[Severity: High]
This is a pre-existing issue, but does using 0 as a sentinel value here
create a permanent in-flight I/O counter leak when jiffies wraps to 0?

In bio_start_io_acct(), the returned value is the current jiffies. On 32-bit
systems, jiffies is initialized to -300*HZ and naturally wraps to 0 exactly
five minutes after boot. If a bio is cloned exactly at the tick where
jiffies is 0, start_time will be recorded as 0 even though accounting
was started.

When completion occurs in md_end_clone_io(), the check sees 0:

    if (md_io_clone->start_time)
        bio_end_io_acct(orig_bio, md_io_clone->start_time);

This evaluates to false, bypassing the end accounting and leaving the
in-flight counter permanently incremented. This can cause operations that
wait for a queue freeze, such as suspend or device removal, to hang
indefinitely.

Would it be safer to use a separate boolean flag to track if accounting was
started, rather than overloading start_time?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D7

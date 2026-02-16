Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973D1318EE6
	for <linux-raid@vger.kernel.org>; Mon, 16 Feb 2026 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771254899; cv=none; b=PD+BhKCULKMN73LDaznXQrtUnfmDsFY8WJGV4SI1oP/sEQq48wJJ6MOnm7g2azhd4WfHWYNkxyJbDUsM0CgZ2/VQgMtHWGIaBoyp84OjFox7MwKGTZfw6cZpvVu9SR6ZWXC9NzCKClwdEU3aI8YNN/GIm/XFTtQG8C9/dyPQHT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771254899; c=relaxed/simple;
	bh=U7PfRewuB7dQJzbI14Y48Xf91R7Idcrdh5VlbVlt1pY=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o95ybKu8eu3G7KYnR0Gs5DTxGJd/3fQIEFMOIiNd4QEW4peF1MmIH9Q6hN5HQqCt1RODSwZMF6FsgujEGkhlHlIliLEEJDXJuSJEr89cLwYFxXfGAL033VoXTvIqKz/1iY/C87gdxHyK3YkCKpiBqy99UwJ8DX7WG/+xP+r2a4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=MHbUP62d; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="MHbUP62d"
Received: (qmail 1215 invoked from network); 16 Feb 2026 15:14:55 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 16 Feb 2026 15:14:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; s=2018; bh=U7PfRewuB7dQ
	JzbI14Y48Xf91R7Idcrdh5VlbVlt1pY=; b=MHbUP62dD7BpqSOBpOXuRsYqEB6l
	umwsOerq/E0Gu5lukiV/gl/b7E2CxDFM3qrxvVT/8qVcvmtSDwgK/uFdpimbqz5Q
	y6Qkq4TM+DhKCGMzqBHTTfGKTSDDCHTk5pdqwP55F6+HrW5Vvvp+P0QUm+JbSG2I
	ZYZkZ5LoiI6+BWs=
Received: (qmail 1588 invoked from network); 16 Feb 2026 09:14:55 -0600
Received: by simscan 1.4.0 ppid: 1574, pid: 1582, t: 0.3181s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MjE3LjE4Mi4yMDYuNjY=)
  by nl101.vfemail.net with ESMTPA; 16 Feb 2026 15:14:55 -0000
Date: Mon, 16 Feb 2026 10:14:52 -0500
From: simd@vfemail.net
To: <linux-kernel@vger.kernel.org>, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Cannot change RAID array check speed
Message-ID: <20260216101452.2f28a76b@Core-Ultra-2-x20>
In-Reply-To: <CALtW_ahB7MUVgRuf=3itf-XbYW_nuEyj_p2-BGEk71mkrVg6FA@mail.gmail.com>
References: <20260215220843.6b28e632@Core-Ultra-2-x20>
 <CALtW_ahB7MUVgRuf=3itf-XbYW_nuEyj_p2-BGEk71mkrVg6FA@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

It worked with LK 6.9 on Devuan (Debian Stretch) ASCII.

I upgraded the system, both HW and SW, to Daedalus and I had to go with a
newer kernel to use the newer Intel iGPU. I'm now on Devuan (Debian
Bookworm) Daedalus.

I used to change this value all the time to get the check done faster or
to slow it down because I needed to access the array.

Maybe it's a distro security policy? IDK. But as I said, I used to change
it all the time. That's why there's a sync_speed_min/max, or so I thought.

Thanks,
David

PS: Accidentally sent to the user instead of to the list. Sorry.


On Mon, 16 Feb 2026 06:20:58 +0100
Dragan Milivojevi=C4=87 <galileo@pkm-inc.com> wrote:
> When did that work?
> /sys/devices/virtual/ etc
> is readonly on 4.18,  6.12 and  6.18 (a few boxes that I have).
>=20
>=20
>=20
> On Mon, 16 Feb 2026 at 04:15, David Niklas <simd@vfemail.net> wrote:
> >
> > Hello,
> > I upgraded my kernel from 6.9 to 6.17. They're both the "same" custom
> > config. I tried:
> >
> > # echo 200000 > /sys/devices/virtual/block/md7/md/sync_speed
> > bash: /sys/devices/virtual/block/md7/md/sync_speed: Permission denied
> > # id
> > uid=3D0(root) gid=3D0(root) groups=3D0(root)
> >
> > This used to work. Any ideas as to what I could have set wrong? I
> > haven't a clue!
> >
> > Is there a security debugging tool or a log-file I could use to trace
> > this down?
> >
> > Thanks,
> > David
> > =20


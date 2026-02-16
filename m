Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF84EED8
	for <linux-raid@vger.kernel.org>; Mon, 16 Feb 2026 20:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771272124; cv=none; b=oapkMekTgnNX8oNHDXo6uczb2tqt03d/T6rGGafyrURWIYCpygo96maQsZvK7DgZX3CwyxXiiHkAXT0LDyWxfeuJLs5uJNqJd6go5CzQFyTlFE+//NeKSTUJE0YVwgviBZgKDYI+N0kWCnXkN1AgCPLSDF3ndvhpxhEn0JC0sHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771272124; c=relaxed/simple;
	bh=u6aZNybuMrq3jVeLPgE2QgzeK8DTeDWh/3TZ/Zq0EMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kCniu+11a153VbnlspZJ75gAKJQxedAqkZ72DzcGB31SWabVHYKmTzJupFCc1ovNUTBDEG2AK+zeDSbrLCp2yWgLVLRFek8E6SG0lVoxr4KJw2zT/0SetVVTHmehPyr6q+SJXOf/1xmSCcRf8Z3MyrGWk1PSstuCgohlZZyOJSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=mssFBsnP; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="mssFBsnP"
Received: (qmail 1253 invoked from network); 16 Feb 2026 20:02:01 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 16 Feb 2026 20:02:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:cc:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; s=2018; bh=u6aZNybuMrq3
	jVeLPgE2QgzeK8DTeDWh/3TZ/Zq0EMQ=; b=mssFBsnPD64Xg18rm/16T+NV/LgC
	b9tjJTRC0Po2wWFVpVb7Zk4S1dTZNTHGkSK3AkCErsw28Wg9pxQ54P8Ij1cwsbo1
	Y1nzrf/cBB67ZlHTZrDNR7VQop5QJOr6MCPSlPc038++PZDw2t9ukwzeVg43hwJX
	rqiYcexy6yoLORk=
Received: (qmail 17794 invoked from network); 16 Feb 2026 14:02:01 -0600
Received: by simscan 1.4.0 ppid: 17470, pid: 17683, t: 0.3202s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MjE3LjE4Mi4yMDYuNjY=)
  by nl101.vfemail.net with ESMTPA; 16 Feb 2026 20:02:00 -0000
Date: Mon, 16 Feb 2026 15:01:58 -0500
From: David Niklas <simd@vfemail.net>
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Cannot change RAID array check speed
Message-ID: <20260216150158.4d94bb67@Core-Ultra-2-x20>
In-Reply-To: <20260216101452.2f28a76b@Core-Ultra-2-x20>
References: <20260215220843.6b28e632@Core-Ultra-2-x20>
	<CALtW_ahB7MUVgRuf=3itf-XbYW_nuEyj_p2-BGEk71mkrVg6FA@mail.gmail.com>
	<20260216101452.2f28a76b@Core-Ultra-2-x20>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hey,
I think I figured this out. I need to change it via the
sync_speed_min/max. I can't used sync_speed anymore.

Thanks guys!


On Mon, 16 Feb 2026 10:14:52 -0500
simd@vfemail.net wrote:
> It worked with LK 6.9 on Devuan (Debian Stretch) ASCII.
>=20
> I upgraded the system, both HW and SW, to Daedalus and I had to go with
> a newer kernel to use the newer Intel iGPU. I'm now on Devuan (Debian
> Bookworm) Daedalus.
>=20
> I used to change this value all the time to get the check done faster or
> to slow it down because I needed to access the array.
>=20
> Maybe it's a distro security policy? IDK. But as I said, I used to
> change it all the time. That's why there's a sync_speed_min/max, or so
> I thought.
>=20
> Thanks,
> David
>=20
> PS: Accidentally sent to the user instead of to the list. Sorry.
>=20
>=20
> On Mon, 16 Feb 2026 06:20:58 +0100
> Dragan Milivojevi=C4=87 <galileo@pkm-inc.com> wrote:
> > When did that work?
> > /sys/devices/virtual/ etc
> > is readonly on 4.18,  6.12 and  6.18 (a few boxes that I have).
> >=20
> >=20
> >=20
> > On Mon, 16 Feb 2026 at 04:15, David Niklas <simd@vfemail.net> wrote: =20
> > >
> > > Hello,
> > > I upgraded my kernel from 6.9 to 6.17. They're both the "same"
> > > custom config. I tried:
> > >
> > > # echo 200000 > /sys/devices/virtual/block/md7/md/sync_speed
> > > bash: /sys/devices/virtual/block/md7/md/sync_speed: Permission
> > > denied # id
> > > uid=3D0(root) gid=3D0(root) groups=3D0(root)
> > >
> > > This used to work. Any ideas as to what I could have set wrong? I
> > > haven't a clue!
> > >
> > > Is there a security debugging tool or a log-file I could use to
> > > trace this down?
> > >
> > > Thanks,
> > > David
> > >   =20
>=20
>=20


Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2331168B8
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 04:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708402053; cv=none; b=hZnS06wcyn+licZMMlqhoBWk3DTQiMbD4WaeEnwprI9SzgY5S1Zex3gB6W0Gv5nD1WRNWdC86sS2rx7hIi5pl555O0aZI1e6gZ4og9PDQYDSxCFXYMQaxu9fBDIxuDYdnJMKabVGQgLza0Nw3Kz58MldlAIjR9ajqKwkRBtIH/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708402053; c=relaxed/simple;
	bh=RU/g5F/8l1YuCo39O9ickLg01QhE8hYOcaylK89nAvI=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FMW+8jVb4LmiEO7nKq0gfF799u94o2GkcTRpkntiXZ3Q1OKqqEyZ8RNM5xcbphmO5UbikbHmRmjWMFYrLOtMlk44p5XAIHRiCG2CIhGgfkCi2cgoMr0QQT4kjIJjWxccc+eBYqRReupaJx+bS/i1KF5+sw/bqcB1QA9qH9/VfLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=k21R5rls; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="k21R5rls"
Received: (qmail 6846 invoked from network); 20 Feb 2024 04:07:22 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with ESMTPS (ECDHE-RSA-AES256-GCM-SHA384 encrypted); 20 Feb 2024 04:07:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; s=2018; bh=RU/g5F/8l1Yu
	Co39O9ickLg01QhE8hYOcaylK89nAvI=; b=k21R5rlsLY42Bdn2AtvNt/c0JMSI
	qeIs8aSmwcOUKrT6p9gaPZmFO5116Hsx5PlqDkBBx0zWb1yBI7WQ6HEGQbXi9BhF
	OLLxA7Tp1oSiqs4jkAKjDY+2giQI5K25AAKXQf/4UfgMbLgyJuFRbYbnQHlU5jVb
	14a+0vSF/KEeM7o=
Received: (qmail 39999 invoked from network); 20 Feb 2024 04:07:22 -0000
Received: by simscan 1.4.0 ppid: 39990, pid: 39995, t: 0.2080s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 20 Feb 2024 04:07:22 -0000
Date: Mon, 19 Feb 2024 23:07:19 -0500
From: David Niklas <simd@vfemail.net>
To: Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Array will not resync.
Message-ID: <20240219230719.09c5a795@firefly>
In-Reply-To: <CAJj0OutmJKP6F1ZRMEoNQyYgJsM+ZUXMzLE5mOzhAAiiF34xRw@mail.gmail.com>
References: <20240218112349.61a97801@firefly>
	<7b07aac9-9242-879b-44b2-df4acb7a4043@huaweicloud.com>
	<CAJj0OutmJKP6F1ZRMEoNQyYgJsM+ZUXMzLE5mOzhAAiiF34xRw@mail.gmail.com>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ah! I needed to issue repair to the sync_action. Thanks!
mdstat looks normal.

David


On Sun, 18 Feb 2024 19:47:19 -0800
"C.J. Collier" <cjac@colliertech.org> wrote:
> Does the content of /proc/mdstat look interesting to you?
>=20
> On Sun, Feb 18, 2024, 17:13 Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> > Hi,
> >
> > =E5=9C=A8 2024/02/19 0:23, simd@vfemail.net =E5=86=99=E9=81=93: =20
> > > Hello,
> > >
> > > I cannot get my RAID 6 array to resync.
> > >
> > > I'm using mdadm version v4.1. I've tried kernels 5.18.X, 6.0.X, and
> > > 6.3.X on Devuan (Debian) Linux.
> > >
> > > % echo resync > /sys/devices/virtual/block/md127/md/sync_action
> > >
> > > Does nothing.
> > >
> > > % mdadm --assemble --update=3Dresync /dev/md127
> > >
> > > Does nothing. =20
> >
> > Please note that resync is one-time after assemble the array the first
> > time, you can't resync again after the array is clean.
> > =20
> > >
> > > I should see a status change to resync with mdadm
> > > --detail /dev/md127 and hear some activity from the drives.
> > >
> > > I tried adding the verbose option, but it only lists the
> > > recognizing of the drives and adding them to the array.
> > >
> > > The array currently has some mismatches which need to be corrected.
> > > It's currently registering all devices in "active sync" status and
> > > says that it is "clean". =20
> >
> > What you want is "echo check > sync_action", then "cat mismatch_cnt",
> > if there are really mismatches, "echo repair > sync_action" to fix it.
> >
> > Thanks,
> > Kuai
> > =20
> > >
> > > I tried setting the flag, in misc mode, to readonly and then back to
> > > readwrite but that still doesn't allow the array to be resync'd.
> > >
> > > In desperation, I tried unplugging one of the drives, it holds
> > > most/all of the mismatches -- the SATA cable was going bad, and
> > > then I touch(1)ed =20
> > a =20
> > > file on the FS and unmounted the FS. Although the array recognized
> > > the failure of the drive, it did not start resync the array upon
> > > adding the drive back into the array.
> > >
> > >
> > >
> > >
> > > Any ideas how to resync the array?
> > >
> > > Thanks,
> > > David
> > >
> > > .
> > > =20
> >
> >
> > =20


Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C20C1E3DF2
	for <linux-raid@vger.kernel.org>; Tue, 16 Sep 2025 07:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758009261; cv=none; b=eKppGhm7oqHPooiGEltWje5zDWCwYG4MzlvyaYEWZxW3dD8e9I1oZW/ZP+P9I54n25o/HohDMalTxhfr+q13sRcEyd0lfCZLAcvbUSyEiONjNYoLI2VwAZmMwbE63TkGlztWUx/mKDYZRHU1wpjytmV9mBGv/DEfq0/+h7Y5/YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758009261; c=relaxed/simple;
	bh=hqfN2VTbZspuzoRF/eV9h4v7mYE7+CW92ZHQ16SDEHU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iRCwZO4DCo7BUb/CGdvXfxjjYVYo22TB3H0XH8CgnGKjoR9ZM1N085NIAk8rDsUWBGm9IGS9Icdzt05yiZwslDrofpFJ0mMHMt9vjsTIgwaBkSZJw4df76zKy0bsIpFyIUZUFYHlB1q38h8cvH28C2j9fzmQNakEWVlcj/Xy7Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ELMS5fAB; arc=none smtp.client-ip=209.85.221.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ELMS5fAB"
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-3e9ca387425so1717205f8f.0
        for <linux-raid@vger.kernel.org>; Tue, 16 Sep 2025 00:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758009257; x=1758614057; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hqfN2VTbZspuzoRF/eV9h4v7mYE7+CW92ZHQ16SDEHU=;
        b=ELMS5fABucT3HB07S0Np3jDoXg73KOkWxoACknwc0nYZv2KtaAPeUFQyzAEv5WvVv1
         Evvic9fE3fOIhA0m/fh2V1pOQxqlSmWODIGW+pjTn8KSga+6uN17Oa+tVJ5CfU7Nfo/I
         IIiYgZJsOQZVCaseCIjnX8Sas3otjQRO12wh301L3jcB2v2MBCyBFooLmpmrxY3u1nsI
         d1K0HSo4BYlCZq7r9rMcoqDnHNexF1ZavFHMG1mQDiwsdXko5dezsT7lH6aPLaFqCSlF
         n9SQBX1XZ91DTtDIDSQxDrbrscjdOikRIR9Kur+UyqDL2F1dMWByOMaf6VZZM5OC+ZNd
         h9CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758009257; x=1758614057;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hqfN2VTbZspuzoRF/eV9h4v7mYE7+CW92ZHQ16SDEHU=;
        b=oMbAkBHez3ewQ3xXLtCWJByIdwdk1wmsWb9OMjqc3ogUNBVGsVf1Uxu2o/OydYN+2a
         mwcnG47zEx2d7P5CMPpbGt4E65ANA0HwHom7io2thKWUSD4717AzMfkedUIN8r2ywT0I
         oDwyFvdJ+/+1CQB5wmlQoVvivroElaXHsJbpw7PKQ/9JJ55zBynvbEGQJkehGkAJqTMO
         oVtiaYKfMl4eQUMvyRg3DIl5o7XlATM8giugEJYHybR7iYBBWvjYDln0aYTNrLqbda0Q
         WUdvS0mLrqEGALuGBcWeatRQk1KjidmbS6mqy3kL5HWJ6ic6Y7jvl+41ZhhYTmYem8/O
         gSnQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9ExhNYojYo/0vtjGKx8W4h/SbKl3CdHlYt/IDzxTmGMyMSm9g29fw+hEkz4ZY/FVkeoChJsotsc5t@vger.kernel.org
X-Gm-Message-State: AOJu0YxJVTCnNvHJ23d1nwwsvJBgAuG1E2cU0utSWTm39AesntoIEvO3
	eRSoBdPFWB4JrU4Zk1/cc5sklKmDGBNeFy97v5o0t5e7+lDM6YOyZyG9nOOmGqfeexo=
X-Gm-Gg: ASbGnct/8+YPU1D4P5d99aHpgeNj+9nC5A9Y8QpiTZSNdSxMuvPqGF/Sq+FmCSK9Liz
	OQM70xlTjX67iPMPyX6Y0+LDsad9lgwuhOgmA676+4/9yJ3A5XCdGgaQCDeZUkfvETVCYSURitw
	QaZ12j+EdxwQolW39YWUVQZc6DtIrUoJSXw06b8dCzOatuRLezhQpHWmtGhOZsVz+oeSIeSl+ue
	8dYjqRmLDjPTAvkwOmfuhRapXavH8grlvxI0QkydzijgG37e5A2QWp4VlBghWGg3wkH7HCK/sqn
	MVvPpMgOukICoIcC8wMrXgPvsaaZPsrkqio0XE3mWN6mHVkGBeSPDPA5J471mnwkBv0OOQ9jDW3
	dXtNh83pGyFCtE3ZtONjSWv6ENg7CGmCXuhvn+FHi+L5i8YxuT3PhMyZx6eRPkVdFO72PNxhTNq
	zJ5yf4zB+V5NZXHlkqvtKiGAvys/ApQ0x/6GAucax+GK0Tx/Qn+iZH5UioZ7ahebn797BM
X-Google-Smtp-Source: AGHT+IH5YMRXSb12uOGMPEwbFvbKAxmxVh26mzH2+NDoVWkekp4ey8EFBVE9PYQlaBAi3n9nHaCkLg==
X-Received: by 2002:a05:6000:178e:b0:3e5:47a9:1c7f with SMTP id ffacd0b85a97d-3e7659f94admr11223657f8f.47.1758009257367;
        Tue, 16 Sep 2025 00:54:17 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecc6424444sm1170313f8f.53.2025.09.16.00.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 00:54:17 -0700 (PDT)
Message-ID: <05fbe7e0fad8850ddfece894625ef5995af45cec.camel@suse.com>
Subject: Re: [PATCH 0/4] mdadm: rework mdcheck systemd service logic
From: Martin Wilck <martin.wilck@suse.com>
To: Xiao Ni <xni@redhat.com>
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org, Yu
 Kuai	 <yukuai@kernel.org>, Nigel Croxon <ncroxon@redhat.com>, Li Nan	
 <linan122@huawei.com>
Date: Tue, 16 Sep 2025 09:54:16 +0200
In-Reply-To: <CALTww28cWpfeZBwppRkUnpy9hmrU9hjY9CtE1Eb-Gg1a4GOThA@mail.gmail.com>
References: <20250912153352.66999-1-mwilck@suse.com>
	 <CALTww2_yJADqiLsS2dMdfA8pcJyYK3-rCfkrmHRSFhx3vzwnTg@mail.gmail.com>
	 <9dd783b8722d85e466fcc024f49ce7e71325437c.camel@suse.com>
	 <CALTww28cWpfeZBwppRkUnpy9hmrU9hjY9CtE1Eb-Gg1a4GOThA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-09-16 at 09:39 +0800, Xiao Ni wrote:
> On Mon, Sep 15, 2025 at 6:15=E2=80=AFPM Martin Wilck <martin.wilck@suse.c=
om>
> wrote:
> >=20
> > On Mon, 2025-09-15 at 08:54 +0800, Xiao Ni wrote:
> > > On Fri, Sep 12, 2025 at 11:34=E2=80=AFPM Martin Wilck
> > > <martin.wilck@suse.com>
> > > wrote:
> > > >=20
> > > > This Patch set changes the logic of the "mdcheck" tool and the
> > > > related systemd
> > > > services mdcheck_start.service and mdcheck_continue.service.
> > > > The set and related discussion are also posted as GitHub PR
> > > > [1].
> > > >=20
> > > > The set is meant to be applied on top of PR#189 [2], which has
> > > > already been
> > > > merged in the current main branch on GitHub.
> > > >=20
> > > > [1] https://github.com/md-raid-utilities/mdadm/pull/190
> > > > [2] https://github.com/md-raid-utilities/mdadm/pull/189
> > > >=20
> > > > The current behavior is like this:
> > > >=20
> > > > * mdcheck without arguments starts a RAID check on all arrays
> > > > on
> > > > the system,
> > > > =C2=A0 starting at position 0. This is started from
> > > > mdcheck_start.service,
> > > > =C2=A0 started by a systemd timer once a month.
> > > > * mdcheck --continue looks for files
> > > > /var/lib/mdcheck/MD_UUID_$UUID, reads the
> > > > =C2=A0 start position from them, and starts a check from that
> > > > position
> > > > on the array
> > > > =C2=A0 with the respective UUID. This is started from a systemd
> > > > timer
> > > > every night.
> > > >=20
> > > > In either case, mdcheck won't do anything if the kernel is
> > > > already
> > > > running a
> > > > sync_action on a given array. The check runs for a given period
> > > > of
> > > > time
> > > > (default 6h) and saves the last position in the MD_UUID file,
> > > > to be
> > > > taken up
> > > > when mdcheck --continue is called next time. When the entire
> > > > array
> > > > has been
> > > > checked, the MD_UUID_ file is deleted. When all checks are
> > > > finished,
> > > > mdcheck_continue.timer is stopped, to be restarted when
> > > > mdcheck_start.timer
> > > > expires next time.
> > > >=20
> > > > Before the recent commit 8aa4ea9 ("systemd: start
> > > > mdcheck_continue.timer
> > > > before mdcheck_start.timer"), this could lead to a race
> > > > condition
> > > > when the
> > > > check for a given array didn't complete throughout the month.
> > > > mdcheck_start.service would start and reset the check position
> > > > to 0
> > > > before mdcheck_continue.service could pick up at the last saved
> > > > position. Commit 8aa4ea9 works around this by starting
> > > > mdcheck_continue.service a few minutes before
> > > > mdcheck_start.timer.
> > >=20
> > > Hi Martin
> > >=20
> > > The race condition is caused by the faulty modification by admin.
> > > commit 8aa4ea9 ("systemd: start mdcheck_continue.timer before
> > > mdcheck_start.timer") already fixes the problem that an array
> > > should
> > > continue to do the check if it doesn't finish checking in one
> > > month.
> > > The admin changes the timer sequence back again, it's a faulty
> > > action.
> > > We can add a warning comment in the timer service file to avoid
> > > such
> > > a
> > > race.
> >=20
> > True. Still, the cleaner solution is to avoid multiple user space
> > services interacting with the kernel's sync_action API. Why hope
> > that a
> > warning comment will be adhered to, if we can avoid the issue in
> > the
> > first place?
>=20
> The sync_action can handle multiple access. In fact all sys files can
> handle such races. =C2=A0

Sure. But the two competing scripts make logic difficult to follow.

> And we should think about backward compatibility as
> we talked. It's better to keep the original meaning of these scripts
> themselves. start_check kicks off the check and start_continue is
> used
> to continue the check if the check can't finish.
> >=20
> > > >=20
> > > > Yet the general problem still exists: both services trigger
> > > > checks
> > > > on the
> > > > kernel's part which they can only passively monitor. So if a
> > > > user
> > > > plays with
> > > > the timer settings (which he is in his rights to do), another
> > > > similar race
> > > > might happen.
> > >=20
> > > diff --git a/misc/mdcheck b/misc/mdcheck
> > > index 398a1ea607ca..7d1d79f795f0 100644
> > > --- a/misc/mdcheck
> > > +++ b/misc/mdcheck
> > > @@ -116,7 +116,7 @@ do
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdadm --detail --export "$=
dev" | grep '^MD_UUID=3D' > $tmp
> > > ||
> > > continue
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 source $tmp
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fl=3D"/var/lib/mdcheck/MD_=
UUID_$MD_UUID"
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if [ -z "$cont" ]
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if [ -z "$cont" -a ! -f "$fl" ]
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 then
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 start=3D0
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 logger -p daemon.info mdcheck start checking $dev
> > >=20
> > > How about this? The start action checks the UUID file. So the
> > > check
> > > will continue if it doesn't finish in one month.
> >=20
> > Yes, we could do that. The question is if it's better than what I'm
> > proposing. Personally, I started looking closely at "mdcheck" and
> > the
> > related services only recently, and I found the way the two
> > services
> > interoperate kind of confusing. The fact that it took more than 10y
> > to discover the discussed race condition indicates that I wasn't
> > the
> > only one who was confused.
> >=20
> > Therefore I would like to get rid of two independent systemd
> > services
> > that both start and stop RAID checks. To try an analogy, instead of
> > two
> > drivers competing for the steering wheel, we'll have just one
> > driver
> > and one that operates the traffic light. IMO that logic is easier
> > to
> > assess. You seem to disagree; I'd like to understand what your
> > reasons
> > are. So far you have argued that this change isn't strictly
> > necessary.
> > That's true, but that doesn't imply that the idea is wrong.
>=20
> The reason is mentioned above about backward compatibility. If it's a
> new function, I totally agree with you. But the two services have run
> for many years on many machines. So can you fix this problem based on
> the two services and mark mdcheck_continue as deprecated? And we can
> remove mdcheck_continue in future.

I don't understand why you want to keep two concurrent services doing
the same thing. What potential backward compatibilty issue does this
solve?=C2=A0

I agree that backward compatibility is important for mdcheck itself and
its various incantations, but I have a hard time getting the point for
the services. What matters here, AFAICS, is that we have a "long" time
interval in which we start new checks, and a "short" one in which we
continue previously started ones (defaulting to "1 month" and "1 day",
respectively). My patch doesn't change these semantics. Actually, it
makes them more obvious.

I also don't understand how we'd be able to deprecate
mdcheck_continue.service if we want to keep both services.

Anyway, to avoid going in circles, I will just drop the patch you
dislike. As discussed, it isn't strictly necessary to avoid the known
race.

Martin

>=20
> Regards
> Xiao
> >=20
> > Best Regards,
> > Martin
> >=20
> > >=20
> > > Best Regards
> > > Xiao
> > > >=20
> > > > This patch set changes the behavior as follows:
> > > >=20
> > > > Only mdcheck_continue.service actually starts and stops kernel-
> > > > based sync
> > > > actions. This service will continue at the saved start position
> > > > if
> > > > an MD_UUID*
> > > > file exists, or start a new check at position 0 otherwise.
> > > > Starting
> > > > at 0 can
> > > > be inhibited by creating a file /var/lib/mdcheck/Checked_$UUID.
> > > > These files
> > > > will be created by mdcheck when it finishes checking a given
> > > > array.
> > > > Thus
> > > > future invocations of mdcheck_continue.service will not restart
> > > > the
> > > > check on
> > > > this array.
> > > >=20
> > > > mdcheck_start.service runs mdcheck --restart, which simply
> > > > removes
> > > > all
> > > > Checked_* markers from /var/lib/mdcheck, so that the next
> > > > invocation of
> > > > mdcheck_continue.service will start new checks on all arrays
> > > > which
> > > > don't have
> > > > already running checks.
> > > >=20
> > > > The general behavior of the systemd timers and services is like
> > > > before, but
> > > > the mentioned race condition is avoided, even if the user
> > > > modifies
> > > > the timer
> > > > settings arbitrarily.
> > > >=20
> > > > This set slightly changes the behavior of the mdcheck script.
> > > > Without
> > > > --continue, it will still start checks on all array, but unlike
> > > > before it will
> > > > skip arrays for with a Checked_ marker exists. To avoid that,
> > > > run
> > > > mdcheck
> > > > --restart before mdcheck.
> > > >=20
> > > > More details in the commit description of the patch "mdcheck:
> > > > simplify start /
> > > > continue logic and add "--restart" logic".
> > > >=20
> > > > Martin Wilck (4):
> > > > =C2=A0 mdcheck: loop over sync_action files in sysfs
> > > > =C2=A0 mdcheck: replace deprecated "$[cnt+1]" syntax
> > > > =C2=A0 mdcheck: simplify start / continue logic and add "--restart"
> > > > logic
> > > > =C2=A0 mdcheck: log to stderr from systemd units
> > > >=20
> > > > =C2=A0misc/mdcheck=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
105 ++++++++++++++++++++---
> > > > ----
> > > > ----
> > > > =C2=A0systemd/mdcheck_continue.service |=C2=A0=C2=A0 6 +-
> > > > =C2=A0systemd/mdcheck_start.service=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=
 3 +-
> > > > =C2=A0systemd/mdcheck_start.timer=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 2 +-
> > > > =C2=A04 files changed, 75 insertions(+), 41 deletions(-)
> > > >=20
> > > > --
> > > > 2.51.0
> > > >=20
> >=20

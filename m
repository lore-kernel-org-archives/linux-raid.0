Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8347729A9FA
	for <linux-raid@vger.kernel.org>; Tue, 16 Sep 2025 09:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758013495; cv=none; b=PJ0q7nGG+WS0sei085YPDO264i9xlmQNCKpIaV0UltykWStNiuvHysntX8LcZtl9OyXLFepcHtA9kz0myseMN6FANJMSnkCAR7EqfRI1BBRPogf5XOmIcyaecgLbRXR3Fbf1oW+O6sAKwKCjEx1OBRUcR177BJxd+R+c2qxnLss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758013495; c=relaxed/simple;
	bh=mvm6HXNc2WF3j9AtqGMV+I737PDksRGtgElvqdoDT4U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VzOULhZXD0LWsa3aeZqEHNLld3/D9M359ZL6e1LI61ke+EEVvByIjquaynCeSndZMvDaTiCFvHa7vVtUD7j0OI7ajFafVZsqMXa8Cph/6lTUAa6eTiedEYc2qUZlLfEZNvqWa1MUAoaOmA5qUCVjpEeqE/g2FJ640vC2OJV3Dcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f+39Zh2Q; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f+39Zh2Q"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-45ed646b656so43308865e9.3
        for <linux-raid@vger.kernel.org>; Tue, 16 Sep 2025 02:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758013491; x=1758618291; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mvm6HXNc2WF3j9AtqGMV+I737PDksRGtgElvqdoDT4U=;
        b=f+39Zh2QKUVQGltQ9SgEkbZ4glTlB0KVCX0fGJpMfuk38bxzeJ4W57vc+CJmTy513y
         5Hch7Jnxf+0gih3FX1lbAK8KnpDR3qDm+eykG2XyiIQLwZUzbPmD0k+EvWcfl7RXCjHx
         XlKs5SraKyOnA/3QcoPjMI1zZ6tLwIZHgBY79JHsipDUo+UhOER9YSIxiTj+oJU5w8B+
         SLl829ZSqFebSjcFppHifBGELoYxyCWdHCdSzdlc0edsCdRRdkzNUbEn5+rPacZafA++
         IA2erEltI1V0x749S5uYmXhopkLN2nfQdK1RzWdh+59fb3frHWBJeKEc3HuI4Sy0btpR
         jh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013491; x=1758618291;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mvm6HXNc2WF3j9AtqGMV+I737PDksRGtgElvqdoDT4U=;
        b=HrlcUxX0zDepG74byShgFaVAAYaALDPsVhCd56nONVVL16cdZSHjl80lzMy9/jBrpD
         nAbKm+g5/FKarotxlpqBsJ9XTYPgUaSU3fzYx9sVOFfyCmpZgwwnR645zV+fZZ2Ko8Xu
         qmWpMzhnEIir3EZQUsN1ZO6YFRd1kpmgDXb6+wNwF3Aq0kZgtQsY1KnSSCa4SNhOFxI9
         nuT+OYlZuidDbxK61qT4Qiq58espN3HS3OpmVfNXwdVFuMRife3NmChG1NF/ydJvAkL1
         CtTVcrKSlVtO4LTa5jSM3Odw5OZqU6qpwynwEmY7qXydUOm0L0pOCSux3a5G+QL9SSh4
         1mtg==
X-Forwarded-Encrypted: i=1; AJvYcCXwQ2dninjFZkPDI9r9slRKWdNvM3LgVetAGP0oInToxYJqqTjwx7LDenXBrqxmk9PLzkzIJgcezrvL@vger.kernel.org
X-Gm-Message-State: AOJu0YyIvSC1AdyoDS9gIIKb0PKiVtasv197XW8f1B4N7zPKoknD0OGn
	AugGVNWL72k3Hj1AnmYCmg4Cg2d6qKcJLo3C9DAeG+FSSaXtPjF3hSbfx3DzcgyN8a01fRNkhob
	8GRGqCb800w==
X-Gm-Gg: ASbGncsB7k9JC8Sb/DQ+uQyasthg7Oo2RBJDS2LN8ihKvpb32tpvuAxGXhm/q3ITk7U
	l2PpV1It9gGvDYC3Uoi8bx8qumVJi4BrVSsTjbqTrhGjl2QLiZgBJEdkuNH7wn6vvpEKD6xKb4F
	b6PxTZrWJ1WyPOiGeOmpJD/d4wqggoUPBYGBnJT/9qST3N2FddWH4SSBPJF6Bt2T9QoGZE7b83P
	pIXuZm8a/hD6ZoODqO7eyJHIZHEANRMYiSdbEn+9Ilw3qx45Nkx+PWP1QNn0L9CX30FeC2dtbo2
	UPCPx8BIkEoQZ0fDAtF9W5f7Vguc+3+DIZDdC+WFa3Lyn3c7c59bDG0ILwIpUPI4NUH+zt3tA63
	woXOWljOakAcG3Se/K51L+HTHKnvrTxQHiauU5sEB9QPKh3dM3/GDrXwCvDL7HCmSWYe4UeGKV8
	mFlp1U9Zk31610z4qHMDenLAiwZqkVeR+fPrZJeWEf3Ciy6zwOPc0ubdIjIQ==
X-Google-Smtp-Source: AGHT+IE8JSPxq0uut4nHleAcT79O5X3VfxDS44TgJScSwcjk1xvbFNhTJeeEo6FpjqrHQ3oQxHdo2w==
X-Received: by 2002:a05:600c:1994:b0:45f:2cf9:c236 with SMTP id 5b1f17b1804b1-45f2cf9c56fmr62656745e9.4.1758013490460;
        Tue, 16 Sep 2025 02:04:50 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm213129065e9.5.2025.09.16.02.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:04:50 -0700 (PDT)
Message-ID: <189df75805e43b975cf8c4723b8e63317bea793b.camel@suse.com>
Subject: Re: [PATCH 0/4] mdadm: rework mdcheck systemd service logic
From: Martin Wilck <martin.wilck@suse.com>
To: Xiao Ni <xni@redhat.com>
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org, Yu
 Kuai	 <yukuai@kernel.org>, Nigel Croxon <ncroxon@redhat.com>, Li Nan	
 <linan122@huawei.com>
Date: Tue, 16 Sep 2025 11:04:49 +0200
In-Reply-To: <CALTww28SH9xffrT5edmK_P4UfJ+Ne_MHtGR+SNdbHdW9MAbMXA@mail.gmail.com>
References: <20250912153352.66999-1-mwilck@suse.com>
	 <CALTww2_yJADqiLsS2dMdfA8pcJyYK3-rCfkrmHRSFhx3vzwnTg@mail.gmail.com>
	 <9dd783b8722d85e466fcc024f49ce7e71325437c.camel@suse.com>
	 <CALTww28cWpfeZBwppRkUnpy9hmrU9hjY9CtE1Eb-Gg1a4GOThA@mail.gmail.com>
	 <05fbe7e0fad8850ddfece894625ef5995af45cec.camel@suse.com>
	 <CALTww28SH9xffrT5edmK_P4UfJ+Ne_MHtGR+SNdbHdW9MAbMXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-09-16 at 16:36 +0800, Xiao Ni wrote:
> On Tue, Sep 16, 2025 at 3:54=E2=80=AFPM Martin Wilck <martin.wilck@suse.c=
om>
> wrote:
> >=20
> > On Tue, 2025-09-16 at 09:39 +0800, Xiao Ni wrote:
> > > On Mon, Sep 15, 2025 at 6:15=E2=80=AFPM Martin Wilck
> > > <martin.wilck@suse.com>
> > > wrote:
> > > >=20
> > > > On Mon, 2025-09-15 at 08:54 +0800, Xiao Ni wrote:
> > > > > On Fri, Sep 12, 2025 at 11:34=E2=80=AFPM Martin Wilck
> > > > > <martin.wilck@suse.com>
> > > > > wrote:
> > > > > >=20
> > > > > > This Patch set changes the logic of the "mdcheck" tool and
> > > > > > the
> > > > > > related systemd
> > > > > > services mdcheck_start.service and
> > > > > > mdcheck_continue.service.
> > > > > > The set and related discussion are also posted as GitHub PR
> > > > > > [1].
> > > > > >=20
> > > > > > The set is meant to be applied on top of PR#189 [2], which
> > > > > > has
> > > > > > already been
> > > > > > merged in the current main branch on GitHub.
> > > > > >=20
> > > > > > [1] https://github.com/md-raid-utilities/mdadm/pull/190
> > > > > > [2] https://github.com/md-raid-utilities/mdadm/pull/189
> > > > > >=20
> > > > > > The current behavior is like this:
> > > > > >=20
> > > > > > * mdcheck without arguments starts a RAID check on all
> > > > > > arrays
> > > > > > on
> > > > > > the system,
> > > > > > =C2=A0 starting at position 0. This is started from
> > > > > > mdcheck_start.service,
> > > > > > =C2=A0 started by a systemd timer once a month.
> > > > > > * mdcheck --continue looks for files
> > > > > > /var/lib/mdcheck/MD_UUID_$UUID, reads the
> > > > > > =C2=A0 start position from them, and starts a check from that
> > > > > > position
> > > > > > on the array
> > > > > > =C2=A0 with the respective UUID. This is started from a systemd
> > > > > > timer
> > > > > > every night.
> > > > > >=20
> > > > > > In either case, mdcheck won't do anything if the kernel is
> > > > > > already
> > > > > > running a
> > > > > > sync_action on a given array. The check runs for a given
> > > > > > period
> > > > > > of
> > > > > > time
> > > > > > (default 6h) and saves the last position in the MD_UUID
> > > > > > file,
> > > > > > to be
> > > > > > taken up
> > > > > > when mdcheck --continue is called next time. When the
> > > > > > entire
> > > > > > array
> > > > > > has been
> > > > > > checked, the MD_UUID_ file is deleted. When all checks are
> > > > > > finished,
> > > > > > mdcheck_continue.timer is stopped, to be restarted when
> > > > > > mdcheck_start.timer
> > > > > > expires next time.
> > > > > >=20
> > > > > > Before the recent commit 8aa4ea9 ("systemd: start
> > > > > > mdcheck_continue.timer
> > > > > > before mdcheck_start.timer"), this could lead to a race
> > > > > > condition
> > > > > > when the
> > > > > > check for a given array didn't complete throughout the
> > > > > > month.
> > > > > > mdcheck_start.service would start and reset the check
> > > > > > position
> > > > > > to 0
> > > > > > before mdcheck_continue.service could pick up at the last
> > > > > > saved
> > > > > > position. Commit 8aa4ea9 works around this by starting
> > > > > > mdcheck_continue.service a few minutes before
> > > > > > mdcheck_start.timer.
> > > > >=20
> > > > > Hi Martin
> > > > >=20
> > > > > The race condition is caused by the faulty modification by
> > > > > admin.
> > > > > commit 8aa4ea9 ("systemd: start mdcheck_continue.timer before
> > > > > mdcheck_start.timer") already fixes the problem that an array
> > > > > should
> > > > > continue to do the check if it doesn't finish checking in one
> > > > > month.
> > > > > The admin changes the timer sequence back again, it's a
> > > > > faulty
> > > > > action.
> > > > > We can add a warning comment in the timer service file to
> > > > > avoid
> > > > > such
> > > > > a
> > > > > race.
> > > >=20
> > > > True. Still, the cleaner solution is to avoid multiple user
> > > > space
> > > > services interacting with the kernel's sync_action API. Why
> > > > hope
> > > > that a
> > > > warning comment will be adhered to, if we can avoid the issue
> > > > in
> > > > the
> > > > first place?
> > >=20
> > > The sync_action can handle multiple access. In fact all sys files
> > > can
> > > handle such races.
> >=20
> > Sure. But the two competing scripts make logic difficult to follow.
> >=20
> > > And we should think about backward compatibility as
> > > we talked. It's better to keep the original meaning of these
> > > scripts
> > > themselves. start_check kicks off the check and start_continue is
> > > used
> > > to continue the check if the check can't finish.
> > > >=20
> > > > > >=20
> > > > > > Yet the general problem still exists: both services trigger
> > > > > > checks
> > > > > > on the
> > > > > > kernel's part which they can only passively monitor. So if
> > > > > > a
> > > > > > user
> > > > > > plays with
> > > > > > the timer settings (which he is in his rights to do),
> > > > > > another
> > > > > > similar race
> > > > > > might happen.
> > > > >=20
> > > > > diff --git a/misc/mdcheck b/misc/mdcheck
> > > > > index 398a1ea607ca..7d1d79f795f0 100644
> > > > > --- a/misc/mdcheck
> > > > > +++ b/misc/mdcheck
> > > > > @@ -116,7 +116,7 @@ do
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdadm --detail --expor=
t "$dev" | grep '^MD_UUID=3D' >
> > > > > $tmp
> > > > > > >=20
> > > > > continue
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 source $tmp
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fl=3D"/var/lib/mdcheck=
/MD_UUID_$MD_UUID"
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if [ -z "$cont" ]
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if [ -z "$cont" -a ! -f "$f=
l" ]
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 then
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 start=3D0
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 logger -p daemon.info mdcheck start checking
> > > > > $dev
> > > > >=20
> > > > > How about this? The start action checks the UUID file. So the
> > > > > check
> > > > > will continue if it doesn't finish in one month.
> > > >=20
> > > > Yes, we could do that. The question is if it's better than what
> > > > I'm
> > > > proposing. Personally, I started looking closely at "mdcheck"
> > > > and
> > > > the
> > > > related services only recently, and I found the way the two
> > > > services
> > > > interoperate kind of confusing. The fact that it took more than
> > > > 10y
> > > > to discover the discussed race condition indicates that I
> > > > wasn't
> > > > the
> > > > only one who was confused.
> > > >=20
> > > > Therefore I would like to get rid of two independent systemd
> > > > services
> > > > that both start and stop RAID checks. To try an analogy,
> > > > instead of
> > > > two
> > > > drivers competing for the steering wheel, we'll have just one
> > > > driver
> > > > and one that operates the traffic light. IMO that logic is
> > > > easier
> > > > to
> > > > assess. You seem to disagree; I'd like to understand what your
> > > > reasons
> > > > are. So far you have argued that this change isn't strictly
> > > > necessary.
> > > > That's true, but that doesn't imply that the idea is wrong.
> > >=20
> > > The reason is mentioned above about backward compatibility. If
> > > it's a
> > > new function, I totally agree with you. But the two services have
> > > run
> > > for many years on many machines. So can you fix this problem
> > > based on
> > > the two services and mark mdcheck_continue as deprecated? And we
> > > can
> > > remove mdcheck_continue in future.
> >=20
> > I don't understand why you want to keep two concurrent services
> > doing
> > the same thing. What potential backward compatibilty issue does
> > this
> > solve?
> >=20
> > I agree that backward compatibility is important for mdcheck itself
> > and
> > its various incantations, but I have a hard time getting the point
> > for
> > the services. What matters here, AFAICS, is that we have a "long"
> > time
> > interval in which we start new checks, and a "short" one in which
> > we
> > continue previously started ones (defaulting to "1 month" and "1
> > day",
> > respectively). My patch doesn't change these semantics. Actually,
> > it
> > makes them more obvious.
> >=20
> > I also don't understand how we'd be able to deprecate
> > mdcheck_continue.service if we want to keep both services.
> >=20
> > Anyway, to avoid going in circles, I will just drop the patch you
> > dislike. As discussed, it isn't strictly necessary to avoid the
> > known
> > race.
>=20
> Hi Martin
>=20
> It looks like I understood you wrongly. I thought you wanted to
> remove
> mdcheck_continue.service totally in future.=C2=A0

The history of my GitHub PR probably confused you. Sorry for that.

The first version of the PR on GitHub ("combine mdcheck_start and
mdcheck_continue into a single service") actually removed one of the
services.=C2=A0But I'd changed that in the 2nd version on Aug 21st [1].

[1] https://github.com/md-raid-utilities/mdadm/pull/190#event-19274907168

I'd realized that this was problematic in terms of backward
compatibility.=C2=A0Removing or renaming systemd services in a package
update is almost impossible do properly for distributions. Being a
distribution person myself, I didn't want to cause needless trouble for
myself and fellow distro people ;-)

Moreover, I'd started to think my first approach wasn't elegant. It had
big backward compatibility issues, much more than the current version.

> So I tried to discuss this
> problem with you. For patch 3/4, I'd like you to describe the race in
> detail. Because commit 8aa4ea9 ("systemd: start
> mdcheck_continue.timer
> before mdcheck_start.timer") already fixes this problem. Why does the
> race come up again?

It would only come up again if a user modified the timer schedule such
that mdcheck_start.service was again started before
mdcheck_continue.service on the same day. That's possible, but not
likely, and we could blame the user if it happened.

OTOH, my approach in this patchset would have completely avoided this
sort of race.

> I have a question about the mdcheck_start.timer change. Now by
> default, the start timer is triggered at 0:45:00 and the continue
> timer is triggered at 1:00. So the check can't continue if the check
> hasn't finished in one month which you fixed in 8aa4ea9?

No. Checks that haven't been finished yet would continue normally. With
this set, mdcheck_start.service would just delete the markers that
inhibit starting new checks.

Consider two arrays A and B. A has finished checking, B has not. So
under /var/lib/mdcheck, you'd have files "MD_UUID_$B" and "Checked_$A".

* On a "normal" day, only mdcheck_continue.service would run and
continue the check for B. Nothing would happen for A.

* On a "monthly" day, mdcheck_start.service runs first and deletes
"Checked_$A". When mdcheck_continue.service starts later, it will
continue checking B at the position saved in "MD_UUID_$B", and start
checking A from position 0.

Anyway, I've already closed this PR and I'll send a new one that keeps
the services as they used to be.=C2=A0If I've convinced you of this set now=
,
let me know :-)

Otherwise I'll just send a minimal new PR without the controversial
patch.

Regards,
Martin

Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C593A221D87
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 10:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757931330; cv=none; b=gjQbRjkBc89BwQG6D+aDmiHxDEKh5UOioU/nzlFLg4CL6ibDgSwGEVA1OoC5xleaG4LNvrvg93n1gEhKd3Tyu8ZCmj92cINtFEs99eQfESDjyzbJNk8kEDFEChBX27GV7IKaPdBFEH1PBiN2kltOFxvXCV33Bsb3zPngMX4zg50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757931330; c=relaxed/simple;
	bh=v2QTv6THRUWGqWSa5aWnglKFsRV8uLlWh+Vx7q8rUeQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H2l19UBxDDfRMep+MMnkUHTxBOdAS/ztXURfHUVVp88d91r7UREwXHNJruffp/JQaFkXEFujxFAojx6tasPZKn1dvxLlKp1J06ZESFEik6fTyw2khHRC1TjrSBXWsadlIyOg97jRCAWk4Pgt56GbvZ1+8yQl7r4unR08RO6eMuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UqB1Mf5O; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UqB1Mf5O"
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-45cb6428c46so49184425e9.1
        for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 03:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757931326; x=1758536126; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v2QTv6THRUWGqWSa5aWnglKFsRV8uLlWh+Vx7q8rUeQ=;
        b=UqB1Mf5OcLVlS5ivom/lzfSho0NMKowTxYZ/8b2xTIwOv58GKrue/RUpk6fNmIye95
         E70l3kLJN0mWwiW0IN8i5kuUmzDB5h0aUE8YlMO1BuTkBrPs4Xzft2+a3CZk7n4ekQ4H
         p/jtWW/1eQK45+K5zhLKQ9zN5SUuJkZbO/yOzkFchUOigp3/MdAzabewXhFHMLroDL9E
         MCv+3fT0D+Xr2iSX76TsAvR08J2FWLRcebx09Em1xXKBQ13fCfZ57g1L00M1kpuwI3ev
         RrrIiHTHG8HwfLf33UJhyyRBp2JlGogiiTHFH49K96XybOE2g0s8/E+AfyYNafnJHvOr
         Au1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757931326; x=1758536126;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v2QTv6THRUWGqWSa5aWnglKFsRV8uLlWh+Vx7q8rUeQ=;
        b=LxPtTZz81CdXpd06QnTnhSbhFKNROzlxKAYTkskD4Qkv6xhl4dbaEE0EpatHLfMX+/
         VAkmSz8KZKfG0Bo3rG27QmD1z335aGxW81t8K4gL5uKNV9IxJs/zrZvQWQ5UaFXJ8Lkk
         yxCo/H4pDnfD/g0g7D8uL+bRVdBMygrcQHVAbQ9CLLVrCIAl/sDc6Kh/BP/1RDqU5pRl
         YZpNJpvER4SKpSI9Ebqw6m1YYbp/z5LU0EV1fvI5YmAlTPlQoCyCr5cuogkcZatUFSPh
         OlHEIPvw24TJALSHh3bl2cjldgJILeQ4YvFuY2w3VVX6M2upfdIsQ065V0osnl3oXu6G
         RRkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjLRshJt9H/7zrvgKSbte5SZxP3UyQ/OCFYK2nBxnVQEIMDr0lufsBhJo2PVLkE5dXcWTQqaZyftc8@vger.kernel.org
X-Gm-Message-State: AOJu0YwVaXcosxMw21Mbp9pD7A20Kdm+wKvNJlH5oYIm74Yl0ntvviF0
	DFBFQXK5+vnS7Xt0MbFPcvwRfmjh1c/9xCGLnUyVFlHEizJ6+B/DO+JXa98439arGdc=
X-Gm-Gg: ASbGnctcvvU0Op+Av4YaS0DN/3KLDZDaKRRHITICconNUf2gJ43nEw2QnWP0vOlnaSq
	6Ec/Mn3/ebUaXy7lR0iDq9oiKm+gCpWQjA6mumnthO0kxkDidhl8OcX3blmcGF/5EvdxpspWcdc
	/RQaTNaqpMp+X+mdK9joubBrDLb6OpeNuGOr6leaAgeVEFsFOCWV3iMTPaxIGWm8IizyWQGwmjS
	7yUPTuS8y8yUbVs6BW+LbQxd+Gu5u8uEfgRBwBpQ0PXVoPoBcEheJU9uCIoQ4XIKVMxfCQ00qOY
	S6y8eylajxdHLhaEPmd4vV8ehgdsc1GMEwtZ1y5bFxsuHJaJtOv1b96CQPrfdiBWUwwDIJ0Dac4
	jabZ+pWm15VB7JAUXtpEa8GQrh3mLKVJATM3mx9mstsPeBfWqR65j14pmH+WbY+9sWLflHfE5hS
	b9zwo7Gf2j40RPCdo9xBGz1/LvZ9ipcJ9Ipa8NQHgIzsOgz+dMconrsSt95A==
X-Google-Smtp-Source: AGHT+IFQJnQ9bL284EfZy+MkeVM1z+hF5qYf0OAy32vdtt3n7q+LAtgkFlBIJgDxERzpTvZe4nJktA==
X-Received: by 2002:a05:600c:1f14:b0:45d:dc9b:e85f with SMTP id 5b1f17b1804b1-45f211c9c09mr100380885e9.2.1757931325905;
        Mon, 15 Sep 2025 03:15:25 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037d62besm169685605e9.21.2025.09.15.03.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 03:15:25 -0700 (PDT)
Message-ID: <9dd783b8722d85e466fcc024f49ce7e71325437c.camel@suse.com>
Subject: Re: [PATCH 0/4] mdadm: rework mdcheck systemd service logic
From: Martin Wilck <martin.wilck@suse.com>
To: Xiao Ni <xni@redhat.com>
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org, Yu
 Kuai	 <yukuai@kernel.org>, Nigel Croxon <ncroxon@redhat.com>, Li Nan	
 <linan122@huawei.com>
Date: Mon, 15 Sep 2025 12:15:24 +0200
In-Reply-To: <CALTww2_yJADqiLsS2dMdfA8pcJyYK3-rCfkrmHRSFhx3vzwnTg@mail.gmail.com>
References: <20250912153352.66999-1-mwilck@suse.com>
	 <CALTww2_yJADqiLsS2dMdfA8pcJyYK3-rCfkrmHRSFhx3vzwnTg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-09-15 at 08:54 +0800, Xiao Ni wrote:
> On Fri, Sep 12, 2025 at 11:34=E2=80=AFPM Martin Wilck <martin.wilck@suse.=
com>
> wrote:
> >=20
> > This Patch set changes the logic of the "mdcheck" tool and the
> > related systemd
> > services mdcheck_start.service and mdcheck_continue.service.
> > The set and related discussion are also posted as GitHub PR [1].
> >=20
> > The set is meant to be applied on top of PR#189 [2], which has
> > already been
> > merged in the current main branch on GitHub.
> >=20
> > [1] https://github.com/md-raid-utilities/mdadm/pull/190
> > [2] https://github.com/md-raid-utilities/mdadm/pull/189
> >=20
> > The current behavior is like this:
> >=20
> > * mdcheck without arguments starts a RAID check on all arrays on
> > the system,
> > =C2=A0 starting at position 0. This is started from
> > mdcheck_start.service,
> > =C2=A0 started by a systemd timer once a month.
> > * mdcheck --continue looks for files
> > /var/lib/mdcheck/MD_UUID_$UUID, reads the
> > =C2=A0 start position from them, and starts a check from that position
> > on the array
> > =C2=A0 with the respective UUID. This is started from a systemd timer
> > every night.
> >=20
> > In either case, mdcheck won't do anything if the kernel is already
> > running a
> > sync_action on a given array. The check runs for a given period of
> > time
> > (default 6h) and saves the last position in the MD_UUID file, to be
> > taken up
> > when mdcheck --continue is called next time. When the entire array
> > has been
> > checked, the MD_UUID_ file is deleted. When all checks are
> > finished,
> > mdcheck_continue.timer is stopped, to be restarted when
> > mdcheck_start.timer
> > expires next time.
> >=20
> > Before the recent commit 8aa4ea9 ("systemd: start
> > mdcheck_continue.timer
> > before mdcheck_start.timer"), this could lead to a race condition
> > when the
> > check for a given array didn't complete throughout the month.
> > mdcheck_start.service would start and reset the check position to 0
> > before mdcheck_continue.service could pick up at the last saved
> > position. Commit 8aa4ea9 works around this by starting
> > mdcheck_continue.service a few minutes before mdcheck_start.timer.
>=20
> Hi Martin
>=20
> The race condition is caused by the faulty modification by admin.
> commit 8aa4ea9 ("systemd: start mdcheck_continue.timer before
> mdcheck_start.timer") already fixes the problem that an array should
> continue to do the check if it doesn't finish checking in one month.
> The admin changes the timer sequence back again, it's a faulty
> action.
> We can add a warning comment in the timer service file to avoid such
> a
> race.

True. Still, the cleaner solution is to avoid multiple user space
services interacting with the kernel's sync_action API. Why hope that a
warning comment will be adhered to, if we can avoid the issue in the
first place?

> >=20
> > Yet the general problem still exists: both services trigger checks
> > on the
> > kernel's part which they can only passively monitor. So if a user
> > plays with
> > the timer settings (which he is in his rights to do), another
> > similar race
> > might happen.
>=20
> diff --git a/misc/mdcheck b/misc/mdcheck
> index 398a1ea607ca..7d1d79f795f0 100644
> --- a/misc/mdcheck
> +++ b/misc/mdcheck
> @@ -116,7 +116,7 @@ do
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdadm --detail --export "$dev"=
 | grep '^MD_UUID=3D' > $tmp ||
> continue
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 source $tmp
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fl=3D"/var/lib/mdcheck/MD_UUID=
_$MD_UUID"
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if [ -z "$cont" ]
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if [ -z "$cont" -a ! -f "$fl" ]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 then
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 start=3D0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 logger -p daemon.info mdcheck start checking $dev
>=20
> How about this? The start action checks the UUID file. So the check
> will continue if it doesn't finish in one month.

Yes, we could do that. The question is if it's better than what I'm
proposing. Personally, I started looking closely at "mdcheck" and the
related services only recently, and I found the way the two services
interoperate kind of confusing. The fact that it took more than 10y
to discover the discussed race condition indicates that I wasn't the
only one who was confused.

Therefore I would like to get rid of two independent systemd services
that both start and stop RAID checks.=C2=A0To try an analogy, instead of tw=
o
drivers competing for the steering wheel, we'll have just one driver
and one that operates the traffic light. IMO that logic is easier to
assess. You seem to disagree; I'd like to understand what your reasons
are. So far you have argued that this change isn't strictly necessary.
That's true, but that doesn't imply that the idea is wrong.

Best Regards,
Martin

>=20
> Best Regards
> Xiao
> >=20
> > This patch set changes the behavior as follows:
> >=20
> > Only mdcheck_continue.service actually starts and stops kernel-
> > based sync
> > actions. This service will continue at the saved start position if
> > an MD_UUID*
> > file exists, or start a new check at position 0 otherwise. Starting
> > at 0 can
> > be inhibited by creating a file /var/lib/mdcheck/Checked_$UUID.
> > These files
> > will be created by mdcheck when it finishes checking a given array.
> > Thus
> > future invocations of mdcheck_continue.service will not restart the
> > check on
> > this array.
> >=20
> > mdcheck_start.service runs mdcheck --restart, which simply removes
> > all
> > Checked_* markers from /var/lib/mdcheck, so that the next
> > invocation of
> > mdcheck_continue.service will start new checks on all arrays which
> > don't have
> > already running checks.
> >=20
> > The general behavior of the systemd timers and services is like
> > before, but
> > the mentioned race condition is avoided, even if the user modifies
> > the timer
> > settings arbitrarily.
> >=20
> > This set slightly changes the behavior of the mdcheck script.
> > Without
> > --continue, it will still start checks on all array, but unlike
> > before it will
> > skip arrays for with a Checked_ marker exists. To avoid that, run
> > mdcheck
> > --restart before mdcheck.
> >=20
> > More details in the commit description of the patch "mdcheck:
> > simplify start /
> > continue logic and add "--restart" logic".
> >=20
> > Martin Wilck (4):
> > =C2=A0 mdcheck: loop over sync_action files in sysfs
> > =C2=A0 mdcheck: replace deprecated "$[cnt+1]" syntax
> > =C2=A0 mdcheck: simplify start / continue logic and add "--restart"
> > logic
> > =C2=A0 mdcheck: log to stderr from systemd units
> >=20
> > =C2=A0misc/mdcheck=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 105=
 ++++++++++++++++++++-------
> > ----
> > =C2=A0systemd/mdcheck_continue.service |=C2=A0=C2=A0 6 +-
> > =C2=A0systemd/mdcheck_start.service=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +=
-
> > =C2=A0systemd/mdcheck_start.timer=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 2 +-
> > =C2=A04 files changed, 75 insertions(+), 41 deletions(-)
> >=20
> > --
> > 2.51.0
> >=20

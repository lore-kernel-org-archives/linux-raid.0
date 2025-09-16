Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88F12DC763
	for <linux-raid@vger.kernel.org>; Tue, 16 Sep 2025 01:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757986767; cv=none; b=uMuF+qsamFy0SknAq2+HOEPV2Keupm4N7v0GqlqV42V5KlmtDplcDioDYNMuHNgsVb7Gz/kEq9ZwLR1Ad2OcC2iPM8AFzEXy8s5PUW8ZYuG7FQV+FqZOxcvJEZX7fLperzpgIUY/MtnMmK5cV1RbEHxqbqAxBHH1S1NuUbdVfkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757986767; c=relaxed/simple;
	bh=2XPw70bV1+AYvK8L77Rqafzhk+W1+9sglGBIQFElSIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y8PgmM+Bi1IecXzI2LTh9l33VBLluTSURTez4m3zqEdSCfnL6kFJ+olWoxGridBhl8o2J7HuXpQQYacvksXRiTGE/SGrGjNYQVLCMGpoP9QM8UBG2Ehq5qrisC9G3GXsaylYocBgI140I+AMZEaRNbT1n/DTEJvkcpsIBmBe5Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fgrrDR0D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fgrrDR0D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757986764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gF/CfJvRGwfS4wT562CfYQQ7cdB+qeoYbGG01AeV+nM=;
	b=fgrrDR0DsWZ2QDx7XygzZs16EVaB2d9spbzLohQA+wk+D2R5qrsDfRq8llQY7sh6w1pznu
	Np2I4F7LCh7XUJeu8p08nc70NjslZYtWQPuxWtRmFzGndAihHEYFN7glKlNm9ZwqNW4f6x
	R2NjwXsZJYXKDe478OVpzwtwaOabPXs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-jeyVUcKlOg2w7_gPu1aWJQ-1; Mon, 15 Sep 2025 21:39:22 -0400
X-MC-Unique: jeyVUcKlOg2w7_gPu1aWJQ-1
X-Mimecast-MFC-AGG-ID: jeyVUcKlOg2w7_gPu1aWJQ_1757986761
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5707130ca7bso2437044e87.0
        for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 18:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757986761; x=1758591561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gF/CfJvRGwfS4wT562CfYQQ7cdB+qeoYbGG01AeV+nM=;
        b=eCK6IJnOOsqulKiTBGpNlL+mrhI0YqwNj3V9M5XKUfAXe8MyjXwtDx3ueCPEjPAPy1
         WMDeW6Mu0rNrwJm8HyCFk2ftfT2QEQE4odv4TaOhGFax++CQv9I9CxvC4GGUekVNkFRp
         Wzf4a+cJTQTkGq3qNKhHJgSxZTTjKaLNCUwBPe68SHnAu96k7VzXYiO7EuRbYqlwwpqT
         itHSJ53QlQZGc7St7feM9owUb6VKQtDFuTcWVTnWLBbMuD/oNZ9Vgm9/+WzMsiDZf+uW
         iQQheO3+kuXeLHy1xSRj4T+4IsI6mNXqJUT7TNoz3Z4Qv8nuK30CUQAv6ffmIJytWDiD
         9ZEw==
X-Forwarded-Encrypted: i=1; AJvYcCXeSxaSV27vTwWaldHZt51ZpCIcl37CkIdlpLat1qAAHC36zebkexg/8JsDN2u5hBTg1mfZ5LPApy7y@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwlyai99155nJJoC44UNFcaNjm8Q+B15vkk4mxOxW72FUa9FVD
	+C3yil8z+SHDAg2HeIQ4ZhEqIyXmR3LRQ+axlyofJKrwFCMF9dCP94POvFyB4+xR5HstdXs2aVA
	tv+DLCMY42CVGXe9WgG7QnbsNfGhCNIP2LICBDGJ17ygtFqk3bR0OFZW5HbKkMOSyHRyzWLQIdt
	qPk07SAB7rgROqmuNn4XKEsfDCU05Z4WuILqglHw==
X-Gm-Gg: ASbGncsPulutLeIlviMRq7QXmDG7lx+EUpR1/3ARL9k4onSqahtwFiDcYEnBwEQjHUT
	NYJUPq8esV4N6sHgzR1N/rS0tuTKw0eNOOHNXYP2RcriFp80YTJc9hYk1s5b5zyX/e0S4HBhNjc
	eoJy7SfdRZhGA19NVeEWOg6A==
X-Received: by 2002:a05:6512:1286:b0:55f:6a49:6e71 with SMTP id 2adb3069b0e04-5704d3e0432mr3633145e87.29.1757986760810;
        Mon, 15 Sep 2025 18:39:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQB7Gpa4qhfoDXLj8RUxpJUqrKI9Bn5nhsXf4u9CuSfazkPh3NvTmEd3dtVYBlzWS4u0pmrY6GIew29Gvei5U=
X-Received: by 2002:a05:6512:1286:b0:55f:6a49:6e71 with SMTP id
 2adb3069b0e04-5704d3e0432mr3633138e87.29.1757986760310; Mon, 15 Sep 2025
 18:39:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912153352.66999-1-mwilck@suse.com> <CALTww2_yJADqiLsS2dMdfA8pcJyYK3-rCfkrmHRSFhx3vzwnTg@mail.gmail.com>
 <9dd783b8722d85e466fcc024f49ce7e71325437c.camel@suse.com>
In-Reply-To: <9dd783b8722d85e466fcc024f49ce7e71325437c.camel@suse.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 16 Sep 2025 09:39:08 +0800
X-Gm-Features: AS18NWAHnjg0QKjYFT_5SndqXShbLiAD4cLyL7NoxVtf8ehDrldrINHi3-5ncCM
Message-ID: <CALTww28cWpfeZBwppRkUnpy9hmrU9hjY9CtE1Eb-Gg1a4GOThA@mail.gmail.com>
Subject: Re: [PATCH 0/4] mdadm: rework mdcheck systemd service logic
To: Martin Wilck <martin.wilck@suse.com>
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org, 
	Yu Kuai <yukuai@kernel.org>, Nigel Croxon <ncroxon@redhat.com>, Li Nan <linan122@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 6:15=E2=80=AFPM Martin Wilck <martin.wilck@suse.com=
> wrote:
>
> On Mon, 2025-09-15 at 08:54 +0800, Xiao Ni wrote:
> > On Fri, Sep 12, 2025 at 11:34=E2=80=AFPM Martin Wilck <martin.wilck@sus=
e.com>
> > wrote:
> > >
> > > This Patch set changes the logic of the "mdcheck" tool and the
> > > related systemd
> > > services mdcheck_start.service and mdcheck_continue.service.
> > > The set and related discussion are also posted as GitHub PR [1].
> > >
> > > The set is meant to be applied on top of PR#189 [2], which has
> > > already been
> > > merged in the current main branch on GitHub.
> > >
> > > [1] https://github.com/md-raid-utilities/mdadm/pull/190
> > > [2] https://github.com/md-raid-utilities/mdadm/pull/189
> > >
> > > The current behavior is like this:
> > >
> > > * mdcheck without arguments starts a RAID check on all arrays on
> > > the system,
> > >   starting at position 0. This is started from
> > > mdcheck_start.service,
> > >   started by a systemd timer once a month.
> > > * mdcheck --continue looks for files
> > > /var/lib/mdcheck/MD_UUID_$UUID, reads the
> > >   start position from them, and starts a check from that position
> > > on the array
> > >   with the respective UUID. This is started from a systemd timer
> > > every night.
> > >
> > > In either case, mdcheck won't do anything if the kernel is already
> > > running a
> > > sync_action on a given array. The check runs for a given period of
> > > time
> > > (default 6h) and saves the last position in the MD_UUID file, to be
> > > taken up
> > > when mdcheck --continue is called next time. When the entire array
> > > has been
> > > checked, the MD_UUID_ file is deleted. When all checks are
> > > finished,
> > > mdcheck_continue.timer is stopped, to be restarted when
> > > mdcheck_start.timer
> > > expires next time.
> > >
> > > Before the recent commit 8aa4ea9 ("systemd: start
> > > mdcheck_continue.timer
> > > before mdcheck_start.timer"), this could lead to a race condition
> > > when the
> > > check for a given array didn't complete throughout the month.
> > > mdcheck_start.service would start and reset the check position to 0
> > > before mdcheck_continue.service could pick up at the last saved
> > > position. Commit 8aa4ea9 works around this by starting
> > > mdcheck_continue.service a few minutes before mdcheck_start.timer.
> >
> > Hi Martin
> >
> > The race condition is caused by the faulty modification by admin.
> > commit 8aa4ea9 ("systemd: start mdcheck_continue.timer before
> > mdcheck_start.timer") already fixes the problem that an array should
> > continue to do the check if it doesn't finish checking in one month.
> > The admin changes the timer sequence back again, it's a faulty
> > action.
> > We can add a warning comment in the timer service file to avoid such
> > a
> > race.
>
> True. Still, the cleaner solution is to avoid multiple user space
> services interacting with the kernel's sync_action API. Why hope that a
> warning comment will be adhered to, if we can avoid the issue in the
> first place?

The sync_action can handle multiple access. In fact all sys files can
handle such races. And we should think about backward compatibility as
we talked. It's better to keep the original meaning of these scripts
themselves. start_check kicks off the check and start_continue is used
to continue the check if the check can't finish.
>
> > >
> > > Yet the general problem still exists: both services trigger checks
> > > on the
> > > kernel's part which they can only passively monitor. So if a user
> > > plays with
> > > the timer settings (which he is in his rights to do), another
> > > similar race
> > > might happen.
> >
> > diff --git a/misc/mdcheck b/misc/mdcheck
> > index 398a1ea607ca..7d1d79f795f0 100644
> > --- a/misc/mdcheck
> > +++ b/misc/mdcheck
> > @@ -116,7 +116,7 @@ do
> >         mdadm --detail --export "$dev" | grep '^MD_UUID=3D' > $tmp ||
> > continue
> >         source $tmp
> >         fl=3D"/var/lib/mdcheck/MD_UUID_$MD_UUID"
> > -       if [ -z "$cont" ]
> > +       if [ -z "$cont" -a ! -f "$fl" ]
> >         then
> >                 start=3D0
> >                 logger -p daemon.info mdcheck start checking $dev
> >
> > How about this? The start action checks the UUID file. So the check
> > will continue if it doesn't finish in one month.
>
> Yes, we could do that. The question is if it's better than what I'm
> proposing. Personally, I started looking closely at "mdcheck" and the
> related services only recently, and I found the way the two services
> interoperate kind of confusing. The fact that it took more than 10y
> to discover the discussed race condition indicates that I wasn't the
> only one who was confused.
>
> Therefore I would like to get rid of two independent systemd services
> that both start and stop RAID checks. To try an analogy, instead of two
> drivers competing for the steering wheel, we'll have just one driver
> and one that operates the traffic light. IMO that logic is easier to
> assess. You seem to disagree; I'd like to understand what your reasons
> are. So far you have argued that this change isn't strictly necessary.
> That's true, but that doesn't imply that the idea is wrong.

The reason is mentioned above about backward compatibility. If it's a
new function, I totally agree with you. But the two services have run
for many years on many machines. So can you fix this problem based on
the two services and mark mdcheck_continue as deprecated? And we can
remove mdcheck_continue in future.

Regards
Xiao
>
> Best Regards,
> Martin
>
> >
> > Best Regards
> > Xiao
> > >
> > > This patch set changes the behavior as follows:
> > >
> > > Only mdcheck_continue.service actually starts and stops kernel-
> > > based sync
> > > actions. This service will continue at the saved start position if
> > > an MD_UUID*
> > > file exists, or start a new check at position 0 otherwise. Starting
> > > at 0 can
> > > be inhibited by creating a file /var/lib/mdcheck/Checked_$UUID.
> > > These files
> > > will be created by mdcheck when it finishes checking a given array.
> > > Thus
> > > future invocations of mdcheck_continue.service will not restart the
> > > check on
> > > this array.
> > >
> > > mdcheck_start.service runs mdcheck --restart, which simply removes
> > > all
> > > Checked_* markers from /var/lib/mdcheck, so that the next
> > > invocation of
> > > mdcheck_continue.service will start new checks on all arrays which
> > > don't have
> > > already running checks.
> > >
> > > The general behavior of the systemd timers and services is like
> > > before, but
> > > the mentioned race condition is avoided, even if the user modifies
> > > the timer
> > > settings arbitrarily.
> > >
> > > This set slightly changes the behavior of the mdcheck script.
> > > Without
> > > --continue, it will still start checks on all array, but unlike
> > > before it will
> > > skip arrays for with a Checked_ marker exists. To avoid that, run
> > > mdcheck
> > > --restart before mdcheck.
> > >
> > > More details in the commit description of the patch "mdcheck:
> > > simplify start /
> > > continue logic and add "--restart" logic".
> > >
> > > Martin Wilck (4):
> > >   mdcheck: loop over sync_action files in sysfs
> > >   mdcheck: replace deprecated "$[cnt+1]" syntax
> > >   mdcheck: simplify start / continue logic and add "--restart"
> > > logic
> > >   mdcheck: log to stderr from systemd units
> > >
> > >  misc/mdcheck                     | 105 ++++++++++++++++++++-------
> > > ----
> > >  systemd/mdcheck_continue.service |   6 +-
> > >  systemd/mdcheck_start.service    |   3 +-
> > >  systemd/mdcheck_start.timer      |   2 +-
> > >  4 files changed, 75 insertions(+), 41 deletions(-)
> > >
> > > --
> > > 2.51.0
> > >
>


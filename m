Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9023D277C96
	for <linux-raid@vger.kernel.org>; Tue, 16 Sep 2025 08:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758011813; cv=none; b=DfgjqXsPHk3xLqJ4HhExh5fzO5QpFrrefU2rfXoIWW6DsLe6aUDE72DikTejwip9dYWgoZ/0/yLqU8xAT6V2qGWQzGHEcd6e1Q10SmvLF/A6ss+AsoMUka7MlM9uOouOVd+Q01y4Bw1OLOxnuKlIAbGt6QX0jpFGIg67/UcCRy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758011813; c=relaxed/simple;
	bh=4hVdmX1ieq1Tp0dUwKsuG8T63ebz4+b1nz554Supgvk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HLRAPhFBmcfXm2avAH0x4y5+ng3dkazwcX6J7PUw/0ynnrz1O+Uf2l0PMGLUwfHtdN3Xe60Yo2fqT2WeY+zeH7IRlUQqBRSgzAiLeH9bg78AqwDngQ5Wz1FkBYqMJaI7J3TkQGLD7sjB+7MiaGtxB8kJ8UqhwFpuajE8Y3UwaqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fnMG/MnN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fnMG/MnN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758011810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OjDSArzMkV88mIJGN1vLBHCvTiC/ZPhDNtgquhaiHbo=;
	b=fnMG/MnNTTxKzf0Dd0bvElr8mo3Jx66+20pIdkX6TV2aVGpxFM4XMOC5uvFnT2gd9eSz/s
	v1JrJdyjmusF6IbuN8neSrpTtX1ra3hi53SzuRB1vE3Co8zqk37x6GwVajbLM/qeHQBw3q
	D8O3KPQquX1UL4/R0gOpYslUz7p2lEA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-hOlxiQ6MOkaRjWqCQF2h9A-1; Tue, 16 Sep 2025 04:36:49 -0400
X-MC-Unique: hOlxiQ6MOkaRjWqCQF2h9A-1
X-Mimecast-MFC-AGG-ID: hOlxiQ6MOkaRjWqCQF2h9A_1758011807
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-55f75effcd1so1767870e87.1
        for <linux-raid@vger.kernel.org>; Tue, 16 Sep 2025 01:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758011807; x=1758616607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OjDSArzMkV88mIJGN1vLBHCvTiC/ZPhDNtgquhaiHbo=;
        b=HBZmIN5CFhtb7RPqeEchLScSFJpNfZ6RuZTjEmTTL2hExSpjMyQ3xTYUOCC1w5L069
         VPMy52dDEKccjNZ5kjEHLX3fHZjQ/sIhFLsFdcFb03eHGFJMFR2QyKx1jruuqpDTkuqA
         xK98U/GaLgTSVUMEPQHYwtzKzUyrel9XsJltuXdrlnrtHeB6Fpp0rem6+ToeMSfbJkPg
         6CVqdIs27IkFncOMgHIEzcDpcIrKEcJRcXbxxb7IFj1wrz77JUzv7GHralrt/+e1jmK9
         zu3C8tArNA1ed+ezJWjCaObbRx6x7V2Tr2X0WDoDmnMa5XU4s9c+dRUUbSyx+YKnij/b
         RQyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVg6ef33qbt+Q5jS+j8D0heKYI4LyFHUrYLacdUxpGJIvsZHBEn3ii3lknhwR28lV2dLq/Wv+q9UEC1@vger.kernel.org
X-Gm-Message-State: AOJu0YxeL/5t1+7ZWZFWBqsNWnQ8S8zCibc7PAtPXaAp0kYFViqqgiFu
	GItajbCOAKJjoO2IBXgzYnXgNCTGOMPvwrgCIGg/i7vw4U9GaJXmCVtdnbGIupJlpQRZhzW368I
	7JldRlg1bWvaJxusFhXXXIpo/nO/0vEHKpR2HcG/kglULh3+wVguUzCHkkmtqDFxvP/WSosfr7R
	RXEOmWZJ1hwfvovJK1txnUpp+a+wJXhWjwybPmvg==
X-Gm-Gg: ASbGncsi6Y+Z1RU8jaPYUARxoIigOU8xvP3/y+zJkgKCf9E1YM9XSE2OE/QhUr+slug
	QALBiUW985q2AIERZH1f/t4pP30TbRqWE+XN7n8k0yBny4F94iutQwoe010GOfYbz4exQeOXyeW
	Us6hLOuzF9AuboMkP8HVIsHw==
X-Received: by 2002:a05:6512:3158:b0:567:b11e:1d95 with SMTP id 2adb3069b0e04-57050255740mr4059981e87.41.1758011807187;
        Tue, 16 Sep 2025 01:36:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGy2v19Jd1rGype4asCe7WhXll7o6qzmiJRyorGygXAWDHUQe0OWS6QnYD1awpOgSNg2YgEyi6gcOiNU+3XYxM=
X-Received: by 2002:a05:6512:3158:b0:567:b11e:1d95 with SMTP id
 2adb3069b0e04-57050255740mr4059969e87.41.1758011806597; Tue, 16 Sep 2025
 01:36:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912153352.66999-1-mwilck@suse.com> <CALTww2_yJADqiLsS2dMdfA8pcJyYK3-rCfkrmHRSFhx3vzwnTg@mail.gmail.com>
 <9dd783b8722d85e466fcc024f49ce7e71325437c.camel@suse.com> <CALTww28cWpfeZBwppRkUnpy9hmrU9hjY9CtE1Eb-Gg1a4GOThA@mail.gmail.com>
 <05fbe7e0fad8850ddfece894625ef5995af45cec.camel@suse.com>
In-Reply-To: <05fbe7e0fad8850ddfece894625ef5995af45cec.camel@suse.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 16 Sep 2025 16:36:33 +0800
X-Gm-Features: AS18NWAehabenpEVsaliTvTz31nomBtkbI21wpRSu5couEQOzS9QUj1Wh6PtW-Y
Message-ID: <CALTww28SH9xffrT5edmK_P4UfJ+Ne_MHtGR+SNdbHdW9MAbMXA@mail.gmail.com>
Subject: Re: [PATCH 0/4] mdadm: rework mdcheck systemd service logic
To: Martin Wilck <martin.wilck@suse.com>
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org, 
	Yu Kuai <yukuai@kernel.org>, Nigel Croxon <ncroxon@redhat.com>, Li Nan <linan122@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 3:54=E2=80=AFPM Martin Wilck <martin.wilck@suse.com=
> wrote:
>
> On Tue, 2025-09-16 at 09:39 +0800, Xiao Ni wrote:
> > On Mon, Sep 15, 2025 at 6:15=E2=80=AFPM Martin Wilck <martin.wilck@suse=
.com>
> > wrote:
> > >
> > > On Mon, 2025-09-15 at 08:54 +0800, Xiao Ni wrote:
> > > > On Fri, Sep 12, 2025 at 11:34=E2=80=AFPM Martin Wilck
> > > > <martin.wilck@suse.com>
> > > > wrote:
> > > > >
> > > > > This Patch set changes the logic of the "mdcheck" tool and the
> > > > > related systemd
> > > > > services mdcheck_start.service and mdcheck_continue.service.
> > > > > The set and related discussion are also posted as GitHub PR
> > > > > [1].
> > > > >
> > > > > The set is meant to be applied on top of PR#189 [2], which has
> > > > > already been
> > > > > merged in the current main branch on GitHub.
> > > > >
> > > > > [1] https://github.com/md-raid-utilities/mdadm/pull/190
> > > > > [2] https://github.com/md-raid-utilities/mdadm/pull/189
> > > > >
> > > > > The current behavior is like this:
> > > > >
> > > > > * mdcheck without arguments starts a RAID check on all arrays
> > > > > on
> > > > > the system,
> > > > >   starting at position 0. This is started from
> > > > > mdcheck_start.service,
> > > > >   started by a systemd timer once a month.
> > > > > * mdcheck --continue looks for files
> > > > > /var/lib/mdcheck/MD_UUID_$UUID, reads the
> > > > >   start position from them, and starts a check from that
> > > > > position
> > > > > on the array
> > > > >   with the respective UUID. This is started from a systemd
> > > > > timer
> > > > > every night.
> > > > >
> > > > > In either case, mdcheck won't do anything if the kernel is
> > > > > already
> > > > > running a
> > > > > sync_action on a given array. The check runs for a given period
> > > > > of
> > > > > time
> > > > > (default 6h) and saves the last position in the MD_UUID file,
> > > > > to be
> > > > > taken up
> > > > > when mdcheck --continue is called next time. When the entire
> > > > > array
> > > > > has been
> > > > > checked, the MD_UUID_ file is deleted. When all checks are
> > > > > finished,
> > > > > mdcheck_continue.timer is stopped, to be restarted when
> > > > > mdcheck_start.timer
> > > > > expires next time.
> > > > >
> > > > > Before the recent commit 8aa4ea9 ("systemd: start
> > > > > mdcheck_continue.timer
> > > > > before mdcheck_start.timer"), this could lead to a race
> > > > > condition
> > > > > when the
> > > > > check for a given array didn't complete throughout the month.
> > > > > mdcheck_start.service would start and reset the check position
> > > > > to 0
> > > > > before mdcheck_continue.service could pick up at the last saved
> > > > > position. Commit 8aa4ea9 works around this by starting
> > > > > mdcheck_continue.service a few minutes before
> > > > > mdcheck_start.timer.
> > > >
> > > > Hi Martin
> > > >
> > > > The race condition is caused by the faulty modification by admin.
> > > > commit 8aa4ea9 ("systemd: start mdcheck_continue.timer before
> > > > mdcheck_start.timer") already fixes the problem that an array
> > > > should
> > > > continue to do the check if it doesn't finish checking in one
> > > > month.
> > > > The admin changes the timer sequence back again, it's a faulty
> > > > action.
> > > > We can add a warning comment in the timer service file to avoid
> > > > such
> > > > a
> > > > race.
> > >
> > > True. Still, the cleaner solution is to avoid multiple user space
> > > services interacting with the kernel's sync_action API. Why hope
> > > that a
> > > warning comment will be adhered to, if we can avoid the issue in
> > > the
> > > first place?
> >
> > The sync_action can handle multiple access. In fact all sys files can
> > handle such races.
>
> Sure. But the two competing scripts make logic difficult to follow.
>
> > And we should think about backward compatibility as
> > we talked. It's better to keep the original meaning of these scripts
> > themselves. start_check kicks off the check and start_continue is
> > used
> > to continue the check if the check can't finish.
> > >
> > > > >
> > > > > Yet the general problem still exists: both services trigger
> > > > > checks
> > > > > on the
> > > > > kernel's part which they can only passively monitor. So if a
> > > > > user
> > > > > plays with
> > > > > the timer settings (which he is in his rights to do), another
> > > > > similar race
> > > > > might happen.
> > > >
> > > > diff --git a/misc/mdcheck b/misc/mdcheck
> > > > index 398a1ea607ca..7d1d79f795f0 100644
> > > > --- a/misc/mdcheck
> > > > +++ b/misc/mdcheck
> > > > @@ -116,7 +116,7 @@ do
> > > >         mdadm --detail --export "$dev" | grep '^MD_UUID=3D' > $tmp
> > > > ||
> > > > continue
> > > >         source $tmp
> > > >         fl=3D"/var/lib/mdcheck/MD_UUID_$MD_UUID"
> > > > -       if [ -z "$cont" ]
> > > > +       if [ -z "$cont" -a ! -f "$fl" ]
> > > >         then
> > > >                 start=3D0
> > > >                 logger -p daemon.info mdcheck start checking $dev
> > > >
> > > > How about this? The start action checks the UUID file. So the
> > > > check
> > > > will continue if it doesn't finish in one month.
> > >
> > > Yes, we could do that. The question is if it's better than what I'm
> > > proposing. Personally, I started looking closely at "mdcheck" and
> > > the
> > > related services only recently, and I found the way the two
> > > services
> > > interoperate kind of confusing. The fact that it took more than 10y
> > > to discover the discussed race condition indicates that I wasn't
> > > the
> > > only one who was confused.
> > >
> > > Therefore I would like to get rid of two independent systemd
> > > services
> > > that both start and stop RAID checks. To try an analogy, instead of
> > > two
> > > drivers competing for the steering wheel, we'll have just one
> > > driver
> > > and one that operates the traffic light. IMO that logic is easier
> > > to
> > > assess. You seem to disagree; I'd like to understand what your
> > > reasons
> > > are. So far you have argued that this change isn't strictly
> > > necessary.
> > > That's true, but that doesn't imply that the idea is wrong.
> >
> > The reason is mentioned above about backward compatibility. If it's a
> > new function, I totally agree with you. But the two services have run
> > for many years on many machines. So can you fix this problem based on
> > the two services and mark mdcheck_continue as deprecated? And we can
> > remove mdcheck_continue in future.
>
> I don't understand why you want to keep two concurrent services doing
> the same thing. What potential backward compatibilty issue does this
> solve?
>
> I agree that backward compatibility is important for mdcheck itself and
> its various incantations, but I have a hard time getting the point for
> the services. What matters here, AFAICS, is that we have a "long" time
> interval in which we start new checks, and a "short" one in which we
> continue previously started ones (defaulting to "1 month" and "1 day",
> respectively). My patch doesn't change these semantics. Actually, it
> makes them more obvious.
>
> I also don't understand how we'd be able to deprecate
> mdcheck_continue.service if we want to keep both services.
>
> Anyway, to avoid going in circles, I will just drop the patch you
> dislike. As discussed, it isn't strictly necessary to avoid the known
> race.

Hi Martin

It looks like I understood you wrongly. I thought you wanted to remove
mdcheck_continue.service totally in future. So I tried to discuss this
problem with you. For patch 3/4, I'd like you to describe the race in
detail. Because commit 8aa4ea9 ("systemd: start mdcheck_continue.timer
before mdcheck_start.timer") already fixes this problem. Why does the
race come up again?

I have a question about the mdcheck_start.timer change. Now by
default, the start timer is triggered at 0:45:00 and the continue
timer is triggered at 1:00. So the check can't continue if the check
hasn't finished in one month which you fixed in 8aa4ea9?

Sorry for bringing this trouble to you.

Best Regards
Xiao
>
> Martin
>
> >
> > Regards
> > Xiao
> > >
> > > Best Regards,
> > > Martin
> > >
> > > >
> > > > Best Regards
> > > > Xiao
> > > > >
> > > > > This patch set changes the behavior as follows:
> > > > >
> > > > > Only mdcheck_continue.service actually starts and stops kernel-
> > > > > based sync
> > > > > actions. This service will continue at the saved start position
> > > > > if
> > > > > an MD_UUID*
> > > > > file exists, or start a new check at position 0 otherwise.
> > > > > Starting
> > > > > at 0 can
> > > > > be inhibited by creating a file /var/lib/mdcheck/Checked_$UUID.
> > > > > These files
> > > > > will be created by mdcheck when it finishes checking a given
> > > > > array.
> > > > > Thus
> > > > > future invocations of mdcheck_continue.service will not restart
> > > > > the
> > > > > check on
> > > > > this array.
> > > > >
> > > > > mdcheck_start.service runs mdcheck --restart, which simply
> > > > > removes
> > > > > all
> > > > > Checked_* markers from /var/lib/mdcheck, so that the next
> > > > > invocation of
> > > > > mdcheck_continue.service will start new checks on all arrays
> > > > > which
> > > > > don't have
> > > > > already running checks.
> > > > >
> > > > > The general behavior of the systemd timers and services is like
> > > > > before, but
> > > > > the mentioned race condition is avoided, even if the user
> > > > > modifies
> > > > > the timer
> > > > > settings arbitrarily.
> > > > >
> > > > > This set slightly changes the behavior of the mdcheck script.
> > > > > Without
> > > > > --continue, it will still start checks on all array, but unlike
> > > > > before it will
> > > > > skip arrays for with a Checked_ marker exists. To avoid that,
> > > > > run
> > > > > mdcheck
> > > > > --restart before mdcheck.
> > > > >
> > > > > More details in the commit description of the patch "mdcheck:
> > > > > simplify start /
> > > > > continue logic and add "--restart" logic".
> > > > >
> > > > > Martin Wilck (4):
> > > > >   mdcheck: loop over sync_action files in sysfs
> > > > >   mdcheck: replace deprecated "$[cnt+1]" syntax
> > > > >   mdcheck: simplify start / continue logic and add "--restart"
> > > > > logic
> > > > >   mdcheck: log to stderr from systemd units
> > > > >
> > > > >  misc/mdcheck                     | 105 ++++++++++++++++++++---
> > > > > ----
> > > > > ----
> > > > >  systemd/mdcheck_continue.service |   6 +-
> > > > >  systemd/mdcheck_start.service    |   3 +-
> > > > >  systemd/mdcheck_start.timer      |   2 +-
> > > > >  4 files changed, 75 insertions(+), 41 deletions(-)
> > > > >
> > > > > --
> > > > > 2.51.0
> > > > >
> > >
>


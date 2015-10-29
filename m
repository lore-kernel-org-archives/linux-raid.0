From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] md/raid5: fix locking in handle_stripe_clean_event()
Date: Thu, 29 Oct 2015 14:22:32 -0700
Message-ID: <20151029212232.GA6009@kroah.com>
References: <1446022340-1453-1-git-send-email-klamm@yandex-team.ru>
 <87r3kebjgx.fsf@notabene.neil.brown.name>
 <30651446128148@webcorp02d.yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <30651446128148@webcorp02d.yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: Neil Brown <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Oct 29, 2015 at 05:15:48PM +0300, Roman Gushchin wrote:
> 29.10.2015, 03:35, "Neil Brown" <neilb@suse.de>:
> > On Wed, Oct 28 2015, Roman Gushchin wrote:
> >
> >> =A0After commit 566c09c53455 ("raid5: relieve lock contention in g=
et_active_stripe()")
> >> =A0__find_stripe() is called under conf->hash_locks + hash.
> >> =A0But handle_stripe_clean_event() calls remove_hash() under
> >> =A0conf->device_lock.
> >>
> >> =A0Under some cirscumstances the hash chain can be circuited,
> >> =A0and we get an infinite loop with disabled interrupts and locked=
 hash
> >> =A0lock in __find_stripe(). This leads to hard lockup on multiple =
CPUs
> >> =A0and following system crash.
> >>
> >> =A0I was able to reproduce this behavior on raid6 over 6 ssd disks=
=2E
> >> =A0The devices_handle_discard_safely option should be set to enabl=
e trim
> >> =A0support. The following script was used:
> >>
> >> =A0for i in `seq 1 32`; do
> >> =A0=A0=A0=A0=A0dd if=3D/dev/zero of=3Dlarge$i bs=3D10M count=3D100=
 &
> >> =A0done
> >>
> >> =A0Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
> >> =A0Cc: Neil Brown <neilb@suse.de>
> >> =A0Cc: Shaohua Li <shli@kernel.org>
> >> =A0Cc: linux-raid@vger.kernel.org
> >> =A0Cc: <stable@vger.kernel.org> # 3.10 - 3.19
> >
> > Hi Roman,
> > =A0thanks for reporting this and providing a fix.
> >
> > I'm a bit confused by that stable range: 3.10 - 3.19
> >
> > The commit you identify as introducing the bug was added in 3.13, s=
o
> > presumably 3.10, 3.11, 3.12 are not affected.
>=20
> Sure, it's my mistake. Correct range is 3.13 - 3.19. Sorry.
>=20
> > Also the bug is still present in mainline, so 4.0, 4.1, 4.2 are als=
o
> > affected, though the patch needs to be revised a bit for 4.1 and la=
ter.
>=20
> Yes, exactly, but things are a bit more complicated in mainline.
> I'll try to prepare a patch for mainline in a couple of days.

We can't do anything with a patch that is not already in Linus's tree,
which is why this isn't even in my patch queue anymore.  Please resend
this once the fix is in Linus's tree, with the git commit id of what it
is there and we will be glad to queue it up.

thanks,

greg k-h

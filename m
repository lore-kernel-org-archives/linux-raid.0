From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 08/34] md/raid5: replace sh->lock with an 'active'
 flag.
Date: Thu, 4 Aug 2011 09:35:32 +1000
Message-ID: <20110804093532.04446213@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.96772.stgit@notabene.brown>
	<CAA9_cmfwBe64jpCGzTHLSXNVu=Mg_nKQwGMixEms7RiYZ7nHXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfwBe64jpCGzTHLSXNVu=Mg_nKQwGMixEms7RiYZ7nHXw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 3 Aug 2011 15:47:47 -0700 Dan Williams <dan.j.williams@intel.co=
m>
wrote:

> On Wed, Jul 20, 2011 at 7:32 PM, NeilBrown <neilb@suse.de> wrote:
> > sh->lock is now mainly used to ensure that two threads aren't runni=
ng
> > in the locked part of handle_stripe[56] at the same time.
> >
> > That can more neatly be achieved with an 'active' flag which we set
> > while running handle_stripe. =A0If we find the flag is set, we simp=
ly
> > requeue the stripe for later by setting STRIPE_HANDLE.
> >
> > For safety we take ->device_lock while examining the state of the
> > stripe and creating a summary in 'stripe_head_state / r6_state'.
> > This possibly isn't needed but as shared fields like ->toread,
> > ->towrite are checked it is safer for now at least.
> >
> > We leave the label after the old 'unlock' called "unlock" because i=
t
> > will disappear in a few patches, so renaming seems pointless.
> >
> > This leaves the stripe 'locked' for longer as we clear STRIPE_ACTIV=
E
> > later, but that is not a problem.
> >
>=20
> This removal reminds me of one thing I have wondered about, but to
> date have not found the time to measure (maybe someone might beat me
> to it if the idea is out there), is what is the overhead of all the
> atomic operations that raid5.c generates?  If we can guarantee that
> certain updates only happen under sh->lock (now STRIPE_ACTIVE) can we
> downgrade set_bit and clear_bit to their non-atomic __set_bit and
> __clear_bit versions and recover some cpu cycles?
>=20

You can only used the unlocked version if you know that no other CPU wi=
ll
change any of the bits in the 'unsigned long'.  As STRIPE_HANDLE can be=
 set
at any time, I think all accesses to sh->state must be atomic.

However 'struct stripe_head_state' is thread-local so setting/clearing =
flags
in ops_request can probably benefit from non-atomic ops.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 23 Oct 2007 20:36:51 -0400
Message-ID: <1193186211.10336.24.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>
	 <471A47CC.1070508@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RmFS2WyOKGKbhO4LLmMP"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471A47CC.1070508@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-RmFS2WyOKGKbhO4LLmMP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-20 at 22:24 +0400, Michael Tokarev wrote:
> John Stoffel wrote:
> >>>>>> "Michael" =3D=3D Michael Tokarev <mjt@tls.msk.ru> writes:

> > As Doug says, and I agree strongly, you DO NOT want to have the
> > possibility of confusion and data loss, especially on bootup.  And
>=20
> There are different point of views, and different settings etc.

Indeed, there are different points of view.  And with that in mind, I'll
just point out that my point of view is that of an engineer who is
responsible for all the legitimate md bugs in our products once tech
support has weeded out the "you tried to do what?" cases.  From that
point of view, I deal with *every* user's preferred use case, not any
single use case.

> For example, I once dealt with a linux user who was unable to
> use his disk partition, because his system (it was RedHat if I
> remember correctly) recognized some LVM volume on his disk (it
> was previously used with Windows) and tried to automatically
> activate it, thus making it "busy".

Yep, that can still happen today under certain circumstances.

>   What I'm talking about here
> is that any automatic activation of anything should be done with
> extreme care, using smart logic in the startup scripts if at
> all.

We do.  Unfortunately, there is no logic smart enough to recognize all
the possible user use cases that we've seen given the way things are
created now.

> The Doug's example - in my opinion anyway - shows wrong tools
> or bad logic in the startup sequence, not a general flaw in
> superblock location.

Well, one of the problems is that you can both use an md device as an
LVM physical volume and use an LVM logical volume as an md constituent
device.  Users have done both.

> For example, when one drive was almost dead, and mdadm tried
> to bring the array up, machine just hanged for unknown amount
> of time.  An unexpirienced operator was there.  Instead of
> trying to teach him how to pass parameter to the initramfs
> to stop trying to assemble root array and next assembling
> it manually, I told him to pass "root=3D/dev/sda1" to the
> kernel.  Root mounts read-only, so it should be a safe thing
> to do - I only needed root fs and minimal set of services
> (which are even in initramfs) just for it to boot up to SOME
> state where I can log in remotely and fix things later.

Umm, no.  Generally speaking (I can't speak for other distros) but both
Fedora and RHEL remount root rw even when coming up in single user mode.
The only time the fs is left in ro mode is when it drops to a shell
during rc.sysinit as a result of a failed fs check.  And if you are
using an ext3 filesystem and things didn't go down clean, then you also
get a journal replay.  So, then what happens when you think you've fixed
things, and you reboot, and then due to random chance, the ext3 fs check
gets the journal off the drive that wasn't mounted and replays things
again?  Will this overwrite your fixes possibly?  Yep.  Could do all
sorts of bad things.  In fact, unless you do a full binary compare of
your constituent devices, you could have silent data corruption and just
never know about it.  You may get off lucky and never *see* the
corruption, but it could well be there.  The only safe way to
reintegrate your raid after doing what you suggest is to kick the
unmounted drive out of the array before rebooting by using mdadm to zero
its superblock, boot up with a degraded raid1 array, and readd the
kicked device back in.

So, while you list several more examples of times when it was convenient
to do as you suggest, these times can be handled in other ways (although
it may mean keeping a rescue CD handy at each location just for
situations like this) that are far safer IMO.

Now, putting all this back into the point of view I have to take, which
is what's the best default action to take for my customers, I'm sure you
can understand how a default setup and recommendation of use that leaves
silent data corruption is simply a non-starter for me.  If someone wants
to do this manually, then go right ahead.  But as for what we do by
default when the user asks us to create a raid array, we really need to
be on superblock 1.1 or 1.2 (although we aren't yet, we've waited for
the version 1 superblock issues to iron out and will do so in a future
release).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-RmFS2WyOKGKbhO4LLmMP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHHpOjTzP9PM7pjw8RAupLAJ0R0VaBmcD7mktgD/p8aYScyTpD1wCcDgVs
4o3SEqwdQPh9eNQObKrqmlo=
=PkLs
-----END PGP SIGNATURE-----

--=-RmFS2WyOKGKbhO4LLmMP--


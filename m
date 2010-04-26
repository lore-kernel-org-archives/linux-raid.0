From: Doug Ledford <dledford@redhat.com>
Subject: Re: &quot;failed&quot; vs &quot;removed&quot; or &quot;locked-out&quot;
 state and --incremental auto-re-adding
Date: Mon, 26 Apr 2010 19:15:51 -0400
Message-ID: <4BD61EA7.5060609@redhat.com>
References: <loom.20100423T140059-877@post.gmane.org> <loom.20100427T002749-963@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig94128150541E07FE40E651D9"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100427T002749-963@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig94128150541E07FE40E651D9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/26/2010 06:28 PM, Christian Gatzemeier wrote:
>=20
> As comming to "terms" working with mdadm took me a while, I'll add my c=
urrent
> "translations" of the actions to the discussion:
>=20
> 1) The "failed" state is the state a member that failed or is missing g=
ets,
> while it can stay listed in mdstat.

Yes.  In particular failed simply means that the kernel no longer
considers it a running member of the array.  However, the kernel still
holds open the reference to the device (which means anything/anyone else
is still locked out from attempting to access the device, which prevents
anything bad from happening to the data that was on it when it failed).

> 2) To "unbind", "unlist" or "dismiss" a member from the md device stats=
 is
> currently called to --remove it. In particular you can "unbind", "unlis=
t" or
> "dismiss" failed or detatched members with --remove failed/detached.

You can use --remove failed/detached/<devname>, they all work.  But yes,
the underlying action here is to take an already failed device go ahead
and release all references to the device from the raid stack.  In
particular, this releases the exclusive open the raid stack holds on the
device and now makes the device available for other things to
open/modify.  At this point there is no longer any guarantee that the
device will not be modified from the pristine state it was in when it
failed.

> 3) A safe way to "lock-out" or "really remove" members from udev/--incr=
emental
> assembly is not available yet AFAIK. (--zero-superblock on mirror membe=
rs makes
> the md device content detectable/available directly)

This is a shortcoming of version 0.90/1.0 superblocks and raid1 arrays.
 For all other superblock versions and raid types, this is not true.
The default superblock version changed from 0.90 to 1.2 as of the mdadm
3.1 series and so this won't be a problem in the future.

> IMHO the ones mentioned first could seen as implied by those mentioned =
later.

No, and this is a safety feature.  We won't remove a good device in
order to prevent a typo from rendering an array dead.  Imagine that
/dev/sdd1 was already failed, and you typed mdadm /dev/md0 -r /dev/sdc1
and we just blindly failed and then removed sdc1, and assume the array
could only handle one failed member (aka, raid4 or raid5), you've just
rendered the array dead in the water.  We could ask questions I suppose,
but it's just as well off to require that a drive be failed before we
remove it.

> I am unclear why --incremental seems to require a device to be unbound =
first
> (--removed) in order to re-add it after it failed. IMHO it could do it =
itself if
> it is really necessary without bothering the user.

It would be kind of useless to put that support into incremental.
Incremental isn't really intended to be run from the command line
(although you can), it's intended to be done on hotplug events.  Those
hotplug events never happen when the device is failed but not removed
from an array, so it's a condition we don't need to handle.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig94128150541E07FE40E651D9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWHqcACgkQg6WylM+/8ZS0zACdEOK0FgNVa0NKGUv/dWjakKpK
GB0AnjyLTbOAih8jn0hxAiuHymjvp9cd
=JP51
-----END PGP SIGNATURE-----

--------------enig94128150541E07FE40E651D9--

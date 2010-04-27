From: Doug Ledford <dledford@redhat.com>
Subject: Re: "failed" vs "released" and "locked-out" state and --incremental
 auto-re-adding
Date: Tue, 27 Apr 2010 11:45:46 -0400
Message-ID: <4BD706AA.9090404@redhat.com>
References: <loom.20100423T140059-877@post.gmane.org> <loom.20100427T002749-963@post.gmane.org> <4BD61EA7.5060609@redhat.com> <loom.20100427T113838-836@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCCB98E1BB1C06720A6C95BB3"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100427T113838-836@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCCB98E1BB1C06720A6C95BB3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/27/2010 06:13 AM, Christian Gatzemeier wrote:
>=20
> Thanks you for responding and adding insight.
>=20
> Doug Ledford <dledford <at> redhat.com> writes:
>> On 04/26/2010 06:28 PM, Christian Gatzemeier wrote:
>>> 2) To "unbind", "unlist" or "dismiss" a member from the md device sta=
ts is
>>> currently called to --remove it. In particular you can "unbind", "unl=
ist"
>>> or "dismiss" failed or detatched members with --remove failed/detache=
d.
>>
>> You can use --remove failed/detached/=E2=89=A4devname>, they all work.=
  But yes,
>> the underlying action here is to take an already failed device go ahea=
d
>> and release
>=20
> There we have a very good word to name --remove so that mdadm is easier=
 to
> understand (IMHO). "release"

You're probably right, but it's also too late to change it now :-(
Remove has been in use for quite some time and there are untold numbers
of programs and scripts that use it as it is so that it would be very
difficult to change it.

>> No, and this is a safety feature.  We won't remove a good device in
>> order to prevent a typo from rendering an array dead.
>=20
> I understand, makes sense to me.
> Ok, if mdadm --remove (release) could give a little hint to --fail firs=
t, if
> "device is busy", it may be able save some head scratches. ;)

Very valid request.

>>> I am unclear why --incremental seems to require a device to be
>>>  --removed (released) first
>>
>> It would be kind of useless to put that support into incremental.
>> Incremental isn't really intended to be run from the command line
>> (although you can), it's intended to be done on hotplug events.
>=20
> That is exactly were I encountered this. Unplugging a failed disk, and
> plugging it back in again would fail, unless I manually --remove (relea=
sed)
> the device before plugging it back in.
>=20
> But I think the hot-unplugging support you added will probably fix this=
 in
> the future even nicer. (Automatically releasing devices as soon as they=
 are
> detached.)

Yep, the hot unplug support solves this issue quite nicely.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigCCB98E1BB1C06720A6C95BB3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAkvXBqoACgkQg6WylM+/8ZRccQCgk3BtlujGdeC5OOzIjfcoS8Ht
n/0AmNdwFs3j2TMHrBmqb8Kh6IGnlKc=
=vZgo
-----END PGP SIGNATURE-----

--------------enigCCB98E1BB1C06720A6C95BB3--

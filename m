From: Doug Ledford <dledford@redhat.com>
Subject: Re: safe segmenting of conflicting changes
Date: Mon, 26 Apr 2010 14:05:43 -0400
Message-ID: <4BD5D5F7.208@redhat.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com> <4BD5D20B.9020900@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2228BF23F6BCD3728192CBBC"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD5D20B.9020900@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2228BF23F6BCD3728192CBBC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/26/2010 01:48 PM, Phillip Susi wrote:
> On 4/26/2010 12:59 PM, Doug Ledford wrote:
>>> This goes ahead and adds the disk back to the array, despite the fact=

>>> that it has been explicitly removed.
>>
>> Of course it does.  You've just explicitly readded it, which is no
>> different than your explicit removal.  Mdadm honors both.
>=20
> No, --incremental is automatically invoked by udev to scan disks as the=
y
> are detected and try to assemble them.  It isn't an explicit --add
> operation.

So, the point of raid is to be as reliable as possible, if the disk that
was once gone is now back, we want to use it if possible.

>>> Whether or not the superblock on sdb is updated when it is removed,
>>> --incremental should NOT use it as long as mdadm -D /dev/md0 says tha=
t
>>> disk is removed, at least not use it in /dev/md0.
>>
>> Why not?  It's not like it uses it without correcting the missing bits=

>> first.  My guess is that you've either A) got a write intent bitmap or=

>=20
> Actually under the right circumstances it DOES use the second disk's
> incorrect data without correcting it first,

A problem for which I suggested a specific fix in another email.

> and if it does overwrite it,
> that causes data loss so should not be done without an explicit --add
> --force.  The fact that this happens is the entire reason for this thre=
ad.

The problem is the cause of this thread, and it's a bug that should be
fixed, it should not cause us to require things to have an explicit
--add --force to use a previously failed drive.  This is a case of
reacting to a bug by disabling a useful aspect of the stack instead of
simply fixing the bug IMO.  When the raid stack thinks that things are
out of sync, it doesn't automatically do anything bad.  The real bug
here is that there is a way to get things out of sync behind the raid
stack's back.

> Whether or not it can be added safely, the disk has been explicitly
> removed so automatically adding it back is not acceptable.

The md raid stack makes no distinction between explicit removal or a
device that disappeared because of a glitch in a USB cable or some such.
 In both cases the drive is failed and removed.  So the fact that you
draw a distinction is irrelevant until such time as the raid superblocks
are changed to be able to encode the cause of a device being removed in
addition to the fact that it simply was removed.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig2228BF23F6BCD3728192CBBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvV1fcACgkQg6WylM+/8ZT9SwCeNFSEirJg571P/jCbeZ8jEDMk
s+oAn37o3sYCD/vm1wZtGeL4uUObNiog
=K+T1
-----END PGP SIGNATURE-----

--------------enig2228BF23F6BCD3728192CBBC--

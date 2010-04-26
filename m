From: Doug Ledford <dledford@redhat.com>
Subject: Re: safe segmenting of conflicting changes, and hot-plugging between
 alternative versions
Date: Mon, 26 Apr 2010 13:11:03 -0400
Message-ID: <4BD5C927.6030608@redhat.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <loom.20100423T213339-797@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2622F2F0DECB3820DF481A6D"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100423T213339-797@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2622F2F0DECB3820DF481A6D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/23/2010 05:04 PM, Christian Gatzemeier wrote:
> Phillip Susi <psusi <at> cfl.rr.com> writes:
>=20
>> when mdadm
>> --incremental sees the second disk claims the first disk is failed, bu=
t
>> it is active and working fine in the running array, it should realize
>> that the superblock on the second disk is wrong, and correct it, which=

>> would leave the second disk as failed, removed, and neither use the ou=
t
>> of sync data on the disk, nor overwrite it with a copy from the first.=

>=20
> "Correcting the superblocks" of conflicting members, would translate in=
to having
> a defined way to mark those members as composing a segment that contain=
s a known
> alternative version of the array. The earliest an alternative version c=
an be
> detected, and thus be known and marked as such, is on an incident when =
a
> conflicting segment comes up while another segment of the array is alre=
ady
> running degraded. (To simply support segments consisting of single raid=
 member
> devices it may be enough if a superblock marking itself as failed would=
 mean it
> is contains conflicting changes. Multi member segments would require se=
gment IDs)
>=20
> IMHO all segments with alternative versions can be marked as known on s=
uch=20
> incidences. However whether the segments containing alternative version=
s
> continue to be normally assembled when they come up after the incident =
like
> before, or if they get ignored in favor of the arbitrary first segment =
of the
> incidence, should be configurable.
>=20
> For users that don't need or want to be able to switch between versions=
 of an
> array by simply switching disks in a hot-pluggable manner, and for thos=
e
> concerned about a failure mode that may exist and make disks available =
in an
> alternating manner and them not noticing it all the time until an incid=
ent, I
> suggested "AUTO -SINGLE_SEGMENTS_WITH_KNOWN_ALTERNATIVE_VERSIONS".
>=20
> In order to manage segments with alternative versions in a hot-plug man=
ner
> however, all segments need to continue to show up under their real arra=
y ID, if
> they are connected first or one at a time. (KNOWN_ALTERNATIVE_VERSIONS =
need to
> be assembled if they come up.) If the segments would be transformed int=
o
> separate arrays the system won't recognize the segment of the array as =
such and
> not boot or open it correctly any more. And you wouldn't be able to swi=
tch
> between versions by switching the disks that are connected.

Actually, I have a feature request that I haven't gotten around to yet
for something similar to this.  It's the ability pause a raid1 array,
causing a member of the array to stop all updates while the rest of the
array operates as normal.  You then do your system updates, do your
testing, and if you decide it was a bad update, then you revert the
paused state of the array and you are back to the state you had prior to
the update.  The basic guidelines that I've worked out for how this must
be done are as follows:

1) Use mdadm to mark a constituent device of an array as a paused member
(add an internal write intent bitmap if no bitmap currently exists and
use bitmap to track changed areas of array).
2) Reboot, pause becomes effective on next assembly (this is because you
want to make sure the pause takes effect at a point in time when the
filesystem is clean, pausing the system while live would be bad).
3) Perform updates, do testing.
4) Either unpause the array, keeping current setup (in which case the
unpause is immediate and you start syncing the current array data to the
paused array member), or unpause --revert, in which case the unpause
does just like the pause did and waits until the next reboot to become
effective for the obvious reason that we can't revert filesystem state
on a live filesystem.
5) If we added a bitmap where none existed before, remove it.

Done.

However, this is fairly orthogonal to the original problem you
mentioned, specifically that mounting to members of a raid1 array
independently can trick them into thinking they are in sync when they
aren't.  The simplest solution to solve that problem would be to add a
generation count to each device's data in each superblock such that if
device B is failed from the array, then the subsequent update to the
superblock on device A would record not only that device B was failed,
but what the generation count was when device B was failed.  On
subsequent reassembly, if device B reappears, and the generation count
on device B does not match the recorded generation count for device B's
failure incident, then refuse to reassemble the devices into the same
array as this would indicate that the arrays have changed independent of
each other.  But that would probably require a superblock version update
to start storing that for each failed device.  Unless Neil could find
some place to stash the data in the current superblock layouts.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig2622F2F0DECB3820DF481A6D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvVyScACgkQg6WylM+/8ZT+NwCfe7nuL2CUX9OIqYzC1o/NYsGB
Gt4Anj+KZ+llPhihf4R0F2sH86f0WiQk
=iaZW
-----END PGP SIGNATURE-----

--------------enig2622F2F0DECB3820DF481A6D--

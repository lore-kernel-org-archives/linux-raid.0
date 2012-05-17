From: NeilBrown <neilb@suse.de>
Subject: Re: sync speed strangeness and other advice
Date: Fri, 18 May 2012 07:20:32 +1000
Message-ID: <20120518072032.1f779bda@notabene.brown>
References: <CALFpzo6EgYjNKDjq41ZFj1_NL6AYy7OLDF18Zeis5iWd21taRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/isB7hMzdQR4tjJzFjf23knY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo6EgYjNKDjq41ZFj1_NL6AYy7OLDF18Zeis5iWd21taRA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/isB7hMzdQR4tjJzFjf23knY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 May 2012 09:37:50 -0600 Marcus Sorensen <shadowsor@gmail.com>
wrote:

> First off, I'm using the stock RHEL 6.2 kernel, so obviously not the
> latest, but I want to get some input on a strange issue I'm seeing.
> Maybe it rings a bell and someone knows a fix or a specific kernel to
> try.

Could I get that a as linux-kernel version number?  RHEL numbers don't mean
anything to me.

>=20
> I have a few RAID 1 arrays that while resyncing refuse to use the
> bandwidth allowed to them. I'm using an internal bitmap. My impression
> was that the various sync speed settings are supposed to use all
> available bandwidth, backing off if there is other system activity.
> The disks are capable of syncing at 400MB/s, and my sync_speed_min is
> set to 10000, sync_speed_max is set to 500000, yet they sync at
> ~80MB/s and iostat shows the disks as being mostly idle.  If I
> increase sync_speed_min to 200000, the array happily complies and
> resyncs at 200MB/s, no problem.

400MB/s!!  SSDs??

The "is the device idle" algorithm was quite fragile for a while there,
though I feel that was quite a while ago.
So it might be a known problem but I would need the kernel version to be su=
re.

>=20
> Also, I seem to have run into an issue similar to the following
> thread, where failing a disk, then restarting the array and re-adding
> the disk results in a full resync. I'll see if I can replicate via the
> included instructions.
>=20
> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg08745.html
>=20
> Last, I've been reading bits about a bad block bitmap, and if I'm
> going to a newer kernel I want to make sure I'm not using one. My
> understanding was that I have to use a new version of the mdadm
> userspace utility to even create an array with a bad block bitmap, and
> even then it's not on by default, correct?

It isn't a bitmap, it is a list.  And it needs to be explicitly enabled by
mdadm, and no released version of mdadm does that.
I don't know yet what the default will be once I do add that support proper=
ly.
Suggestions welcome.

NeilBrown


>=20
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/isB7hMzdQR4tjJzFjf23knY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7VroDnsnt1WYoG5AQL+QA//T1w7XY0QNmLDGXlblQqHtIU3LV0jEuJx
HoF/f7fufgACfDziHEyClhbXalawVpbeldtnxPGMP7HPnRuI/TPmUrkw0mX8frBu
XOu9waMRylDjMi+xwxgchDK2QvBJvggWAwRF5H9CsKpuHbymkCS4Yz5BsxOvSuoX
I9HWEWFN1NqHAY1/SHwNzIhRQ7JHZwMKmo4ZpNAwNQpuMIoXob8yMUQ3rxwCxOXI
BxcbosyiKv+nwMvEihMIzxNlMIrBhUx6OGoIb+dEh+qABbBEI5R5W5MAv8Tqgf8F
upmfh1uO8zd75n0aoGdBVKqQf9luzOwCGTJsMqW3Pjke8zB7/OETMhbauknTMRE6
N0VI/c4GwzfCPS89451JWLMWG0Xk82gjfM6WIbRB2+1criPofp2ROjbK3lOpdDQg
93VfYXD3r4Ixczd+ALLEFncEaxlSXpNkL1rxfIxI8uBoxXxv7b2mf+Ddf9+MppaE
UtqBXto+GsJeuFNo4HnXLWmQcDWPSRdYCJDd2wdLEM4OxJlwxZaFcsGoO2zJXaGS
RRZWWRM4BhIZ3IcjdtzQfRKM7EAaqZx0/KPfLH4CqCNFbNJr10DJAHxhF2WdqDQZ
DFV5k4tomWdmJDQUkfiFyTzMi3sXtJ2iyYCiryug8GUVa3YTDyEUL7fPANntKpU6
FvU8s7OXc8w=
=wk+E
-----END PGP SIGNATURE-----

--Sig_/isB7hMzdQR4tjJzFjf23knY--

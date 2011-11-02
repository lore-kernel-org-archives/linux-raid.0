From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/12] More leak and NULL pointer dereference fixes
Date: Thu, 3 Nov 2011 08:12:51 +1100
Message-ID: <20111103081251.517d462a@notabene.brown>
References: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qLht=2IXncVV8kHtx.OeycM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

--Sig_/qLht=2IXncVV8kHtx.OeycM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  2 Nov 2011 15:42:05 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> As promised, here is another batch of fixes for small memory leaks,
> use of invalid file descriptors and NULL pointer dereferences.
>=20
> The coverity output is starting to look a lot better by now :)
>=20
> Cheers,
> Jes

Thanks.


>=20
>=20
> Jes Sorensen (12):
>   mdadm: add missing break for UpdateSubarray

This was wasn't correct.  The code was actually doing  the right thing.
But I agree that it looked wrong so I rearranged the code a bit to make it
(hopefully) less confusing.

All the rest applied.

thanks,
NeilBrown



>   ping_monitor(): check file descriptor is valid before using and
>     closing it
>   mdstat_read(): Check return value of dup() before using file
>     descriptor
>   get_component_size(): Check read() return value for error before
>     using it
>   array_try_spare(): open_dev() returns -1 on error, not zero
>   disk_init_and_add(): Fail if opening sysfs file descriptors fail
>   close_aa(): Verify file descriptors are valid before trying to close
>     them
>   ahci_enumerate_ports(): Don't close fd that failed to open
>   unblock_monitor(): Check sra is valid before dereferencing
>   Manage_ro(): Check pointer rather than dereferencing it
>   fd2devname(): Don't dereference NULL pointer
>   match_metadata_desc(): Fix memory leak
>=20
>  Incremental.c |    2 +-
>  Manage.c      |    2 +-
>  managemon.c   |   21 ++++++++++++++++-----
>  mdadm.c       |    1 +
>  mdstat.c      |    7 ++++++-
>  msg.c         |   11 +++++++++--
>  super-intel.c |    8 +++++---
>  super-mbr.c   |    7 ++++---
>  sysfs.c       |    2 +-
>  9 files changed, 44 insertions(+), 17 deletions(-)
>=20


--Sig_/qLht=2IXncVV8kHtx.OeycM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrGyWjnsnt1WYoG5AQLxyhAAk+fADHB3x30EqesKcuW1VJTLKEfo6SeT
makM72j3rrAv3aeduvgDPU2h8BQwE6q7Cjp0kboY4Zh7CWQBSVuSgWfeQD4VyXFK
9QtVxSXR6bvDqg/jWeXliSknQdk+0yrgbKBsnnIWRErIl8FFXJfjl2g0TxhG/Mvb
0/aK7ZfrndDPHs3jgewckF/tCzVdE7SxYJoXM84tpQpwpvAzuF9taKF4du6ZdOkB
5nbX0bgpqNUgAwmMmQnORWR9bl8JGsN42cLAq/N0p4++26t7HeJKEj7+5tWBrFQP
hih7tPjFj/D+83F5gmihq/hqQjaBkJ9yspA5IPcziIM2OBtSSEk/fNozMEUX+eN+
4OgoR0G9kXfJ4+tBcqYCwIvc14z6dIQuQeakTN/SFc4JvzY5zLYeXGQkLYebnZZy
0IQ58oa+r2+yRc2zQ5U+rVCjKoIdNp4kSInd1PNHYrEngQVlu+xjCAUo8jHJhuXi
x99DKC16SYpbbHsTS4N8UkQMTQGNdsIlvXnTv3Yj0wZgo5A0zFJ3Ci7D5CPJySPM
tlYUNX2XfNiyxSq+aDU3wKQV8q3qekGBi7jN/1WPLTCJRh3p9/Aya84OoPu4m4fy
b7HCLtY8D5VLHNDJA8Fd8+QMBWlScUj7r6yK1VYl46cKx7N5Eu2jkyQQF9AakLpF
MMm0cANAfgc=
=kbJJ
-----END PGP SIGNATURE-----

--Sig_/qLht=2IXncVV8kHtx.OeycM--

From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/19] More fixes for resource leaks and warnings
Date: Wed, 2 Nov 2011 11:25:30 +1100
Message-ID: <20111102112530.2fd3cb7f@notabene.brown>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pVRvTTQB_uz.6x1CG2TqVue"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

--Sig_/pVRvTTQB_uz.6x1CG2TqVue
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Nov 2011 16:09:16 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> Another 'small' pile of fixes for various resource leaks, null pointer
> dereferencing and out of bounds buffer access found by Coverity.

Thanks Jes.
I've applied all of these - using the second version of patch 19.

I'm not normally very fussed about freeing and closing things shortly before
the process is going to exit anyway, but I'm not against it.  And some of
your patches were for other leaks.

>=20
> This is the bulk of these for now. Please notice that I haven't
> touched super-ddf.c at all, and that is probably the single biggest
> offender. Also note that I haven't addressed a number of warnings in
> sysfs.c where we know for sure that files aren't bigger than a given
> size. The tool obviously doesn't know this, so it spews warnings when
> we strcpy() content we just read. While the code per-ce is probably
> safe, we may want to switch to strncpy() just to reduce the noise
> ratio?

Maybe.  I hate strncpy because it doesn't reliably nul-terminate but I'm
happy to make the code 'safer' as long as we avoid making it ugly.

Thanks,
NeilBrown


>=20
> Cheers,
> Jes
>=20
>=20
> Jes Sorensen (19):
>   Grow_Add_device(): dev_open() return a negative fd on error
>   Grow_addbitmap(): don't try to close a file descriptor which failed
>     to open
>   Incremental(): Check return value of dev_open() before trying to use
>     it
>   sysfs_unique_holder(): Check read() return value before using as
>     buffer index
>   remove_devices(): readlink returns -1 on error
>   assemble_container_content(): fix memory leak
>   Grow_restart(): free() offsets after use
>   Assemble(): don't dup_super() before we need it.
>   Detail(): Remember to free 'avail'
>   Grow_reshape(): Fix another 'sra' leak
>   enough_fd(): remember to free buffer for avail array
>   Manage_subdevs(): avoid leaking super
>   IncrementalScan(): Fix memory leak
>   Managa_ro(): free() mdi before exiting
>   Manage_runstop(): Avoid memory leak
>   Monitor(): free allocated memory on exit
>   bitmap_fd_read(): fix memory leak
>   validate_geometry_imsm_volume(): Avoid NULL pointer dereference
>   make_parts(): Avoid false positive security warning
>=20
>  Assemble.c    |    9 +++++++--
>  Detail.c      |    3 ++-
>  Grow.c        |   19 +++++++++++++------
>  Incremental.c |    7 +++++++
>  Manage.c      |   56 ++++++++++++++++++++++++++++++++++++++++-----------=
-----
>  Monitor.c     |    6 ++++++
>  bitmap.c      |    3 +++
>  mdopen.c      |   14 +++++++-------
>  super-intel.c |    4 +++-
>  sysfs.c       |    2 ++
>  util.c        |    9 +++++----
>  11 files changed, 95 insertions(+), 37 deletions(-)
>=20


--Sig_/pVRvTTQB_uz.6x1CG2TqVue
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrCN+jnsnt1WYoG5AQL3GxAAp6U1Am2hGbEkuHOgAxJrc9mqyRRfQxfL
ZmLz9AzwWmumnYzWIETW/eEz3qluC+HjOWR423QMH+ivibeqFXZ0VjxmmOTWCKKN
Y7uhwWv9rk+87+9pXbKlUr82W2A2CdQdGCD9kZQjg2xvZwasRioS7xQOxu3DD+xV
sc0r6MTmuUfMoUub2FpEGZk8BSh656bi5Vklm8MmZ1VPDiDzAjl4cfDRbKL3G8lh
6dIE6Stlu5680ERACpjNSOsAjQ3uyLnV1ZO0CjdLINNvYEXAY4W50Pj1i2FdTMhV
cTXkIBUT5HuQYW4dCzDIkdUoeXDH6QVVz80P1y1/QWt6lD7FeuzrE3iZ7hNeFFS5
5bm6iLiCuSkpCPwdhyX7cEJjcAiDbl0xYiVCVeLO4tdjQhpqTJUShG5HohpgtVMt
U04hYZPgIzwT1j3maGMvUaVTOKUcfk3AP43aAq7ML6seTSqkS+9JZ/MdG57ysNTN
AV3ceeByGYdTUdkaJFTsWXQqXh+DkGO+LPIo72I65yJBb2V0qZj+pF88MxwjU6Ti
QdaVaY1uFu0PbRczpMQSZqiTUDIYusRUwbZEYWu7iaptjrh/F2Lq3YSDI6zWWrfg
fisSwlpuGlM0c6YqzcyRJMpFS+3PhVX3aCNu4vXvbnVzp5VZOdxS7CjDrbsvZj/w
K49OKQ2LKDM=
=ZUcm
-----END PGP SIGNATURE-----

--Sig_/pVRvTTQB_uz.6x1CG2TqVue--

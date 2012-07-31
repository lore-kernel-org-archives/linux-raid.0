From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Tue, 31 Jul 2012 15:53:04 +1000
Message-ID: <20120731155304.11c40f9b@notabene.brown>
References: <20120726080150.GA21457@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7TAS3DSamKpg9UH6BKOQdf6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120726080150.GA21457@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7TAS3DSamKpg9UH6BKOQdf6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Jul 2012 16:01:50 +0800 Shaohua Li <shli@kernel.org> wrote:

> Write has some impacts to SSD:
> 1. wear out flash. Frequent write can speed out the progress.
> 2. increase the burden of garbage collection of SSD firmware. If no space
> left for write, SSD firmware garbage collection will try to free some spa=
ce.
> 3. slow down subsequent write. After write SSD to some extents (for examp=
le,
> write the whole disk), subsequent write will slow down significantly (bec=
ause
> almost every write invokes garbage collection in such case).
>=20
> We want to avoid unnecessary write as more as possible. raid sync general=
ly
> involves a lot of unnecessary write. For example, even two disks don't ha=
ve
> any data, we write the second disk for the whole disk size.
>=20
> To reduce write, we always compare raid disk data and only write mismatch=
 part.
> This means sync will have extra IO read and memory compare. So this schem=
e is
> very bad for hard disk raid and sometimes SSD raid too if mismatch part is
> majority. But sometimes this can be very helpful to reduce write, in that=
 case,
> since sync is rare operation, the extra IO/CPU usage is worthy paying. Pe=
ople
> who want to use the feature should understand the risk first. So this abi=
lity
> is off by default, a sysfs entry can be used to enable it.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/md.c    |   41 +++++++++++++++++++++++++++++++
>  drivers/md/md.h    |    3 ++
>  drivers/md/raid1.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++=
+++----
>  3 files changed, 110 insertions(+), 4 deletions(-)
>=20
> Index: linux/drivers/md/md.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/md.h	2012-07-25 13:51:00.353775521 +0800
> +++ linux/drivers/md/md.h	2012-07-26 10:36:38.500740552 +0800
> @@ -325,6 +325,9 @@ struct mddev {
>  #define	MD_RECOVERY_FROZEN	9
> =20
>  	unsigned long			recovery;
> +#define MD_RECOVERY_MODE_REPAIR		0
> +#define MD_RECOVERY_MODE_DISCARD	1
> +	unsigned long			recovery_mode;

You have not documented the meaning of these two flags at all, and I don't
feel up to guessing.

The patch looks more complex that it should be.  The behaviour you are
suggesting is exactly the behaviour you get when MD_RECOVERY_REQUESTED is
set, so at most I expect to see a few places where that flag is tested
changed to test something else as well.

How would this be used?  It affects resync and resync happens as soon as the
array is assembled.  So when and how would you set the flag which says
"prefer reads to writes"?  It seems like it needs to be set in the metadata.

BTW RAID10 already does this - it reads and compares for a normal sync.  So
maybe just tell people to use raid10 if they want this behaviour?

NeilBrown

--Sig_/7TAS3DSamKpg9UH6BKOQdf6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBdywDnsnt1WYoG5AQLH0w/+P7FqY+x8nct2yquk+Zo18rJA7IXLpUCw
Ye34UZhev3VrXKZlGDtFhYMPbL1PPz2FsvJ3ddJKnJk1js4zXeB1WMbwNQv2shXO
uc7+E38IEWLKdc3CDUddTTlPBLOA2TY/8KJVkvgE0d8QkOMbzU1xev6SuEOMmga9
spVjwIv7XAzkx2X0sCnf4PyE+CTastZm/0oF7HKRqRTF477u7k8y4t9cGrFYtmhK
o3Xl+3MXrtsgFVfvhYX2tf0iE+uAmMktSJACjSnCg4QCHRH+msGvmoHXXdDc+upO
L3rSmHtuyX2FsNZqo90KFOVrRs/hdfhYNSOgpUJHP2okRUUp7a3SfiBL7jLt6LvF
rTzuNll13rP/doLSr7BLeF7/mGqqWc6je5ZkOOVdsoO6bMtp5jBOZYhYsivCbG8M
kweuNUSOPZqYHusvmGE7YRNjohW0aUgHvp4JQneY6xFjFEyIjLbicgPhl4wjX9JY
0xNBvKnwwOc59tUeRplB+40KjmkVQYVsReChu41JF/c1bUvZODD0knk1QQhqX1l0
DI5mHqwwlGF/fz9fonk2M7qAlfnzrihgG+Wc8+2MyiZWyzQQZ2VI2EySjfGrBZhn
6ifNqAMYhlSYsm98bxvVVKy3+J9Ji24v67Tj0YL/1iNrfzoOWb09BZt6esdHIViq
rYZIHLY8FHU=
=QJQ1
-----END PGP SIGNATURE-----

--Sig_/7TAS3DSamKpg9UH6BKOQdf6--

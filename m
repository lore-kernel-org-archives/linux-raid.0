From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm-3.2.5 coming soon :-(
Date: Thu, 17 May 2012 15:44:49 +1000
Message-ID: <20120517154449.2eeb0512@notabene.brown>
References: <20120503142201.649766de@notabene.brown>
	<20120515215020.76fd9c6f@notabene.brown>
	<4FB274B3.8040907@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SkMX+MeeokrvJ3dq3nT5tn."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB274B3.8040907@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Cc: linux RAID <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Doug Ledford <dledford@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, Dan Williams <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>, Clint Byrum <clint@ubuntu.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Tomczak, Marcin" <marcin.tomczak@intel.com>
List-Id: linux-raid.ids

--Sig_/SkMX+MeeokrvJ3dq3nT5tn.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 May 2012 17:22:27 +0200 Maciej Naruszewicz
<maciej.naruszewicz@intel.com> wrote:

> > If anyone knows of any other issues that have cropped up wit 3.2.4, ple=
ase
> > let me know.
> >
> > Thanks,
> > NeilBrown
>=20
> Since mdadm-3.2.4 creating volumes using IMSM containers is impossible=20
> (segfaults), unless the kernel is 3.1.x or higher (for instance=20
> everything SEEMS to work in RHEL 7.0 Alpha and openSUSE 12.1). Full=20
> story from SLES 11 SP2 (kernel-3.0.13-0.27-default) with mdadm-3.2.4 :
>=20
> $ mdadm --zero-superblock /dev/sd[cd]
> $ mdadm -C /dev/md/imsm0 -a md -e imsm -n 2 /dev/sd[cd] -R
>=20
>      [...]
>=20
> $ tail /var/log/messages
>=20
>      May 15 17:16:10 gklab-128-174 kernel: [  317.653470] md: bind<sdc>
>      May 15 17:16:10 gklab-128-174 kernel: [  317.653519] md: bind<sdd>
>      May 15 17:16:11 gklab-128-174 udevd-work[5249]: '/sbin/mdadm=20
> --detail --export /dev/md127' unexpected exit with status 0x000b
>      May 15 17:16:11 gklab-128-174 kernel: [  317.701434] mdadm[5250]:=20
> segfault at 78 ip 0000000000450c4f sp 00007fff6c99ada0 error 4 in=20
> mdadm[400000+69000]
>=20
> $ mdadm -C /dev/md/raid1_2disks -a md -l 1  --size 1500000 -n 2=20
> /dev/sd[cd] -R -f
>=20
>      mdadm: cannot open device: 11:0
>      [...]
>      mdadm: cannot open device: 11:0
>      [...]
>      Segmentation fault
>=20
> $ tail /var/log/messages
>=20
>      May 15 17:18:36 gklab-128-174 kernel: [  463.291235] mdadm[5298]:=20
> segfault at 78 ip 0000000000450c4f sp 00007fff8ad887e0 error 4 in=20
> mdadm[400000+69000]
>=20
> Similiar story in RHEL 6.3 Beta, those errors don't happen with kernel=20
>  >=3D 3.1.x though (or mdadm-3.2.3 :)).
>=20
> Maciek N

Could the difference be that fact that 3.2.4 default to using /run, which
doens't exist on SLES11 and may on in RHEL 6.3?
If you compile with
   make MAP_DIR=3D/var/run/mdadm
does it work better?

However I think this will fix the crash you are seeing.

diff --git a/mapfile.c b/mapfile.c
index b890ed2..70ff355 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -404,6 +404,8 @@ void RebuildMap(void)
 			if (ok !=3D 0)
 				continue;
 			info =3D st->ss->container_content(st, subarray);
+			if (!info)
+				continue;
=20
 			if (md->devnum >=3D 0)
 				path =3D map_dev(MD_MAJOR, md->devnum, 0);

Thanks,
NeilBrown

--Sig_/SkMX+MeeokrvJ3dq3nT5tn.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7SQUTnsnt1WYoG5AQLLdxAAv+ZO8CSdco3IHQ/9WiEtHWH2P+S9WL4x
LfYofY+IS3x9P05KXKmbjLkSV6YPvUJNoMjGHU5akLRVXJ56cnmmN6RwFduhSHWO
GnK1454lCOnEpwirHQHBdrY503V9oTI4Ov2Xo++9iKatTsB13ueAwYFHuU76jj4W
G1uuag4DAgbT5xJJCmHi9+tDhL7EGJIIwesLA1vONGa58CACQ/Ql4+sP9io7FafJ
BNvU/OIpG/mqNJ9pz0foW1/8fo8fDyx3Az4TPi3pJvh4e9K9nOsmUSbeMSNnP35/
7y82sJLM65mm1dZNQo13zn5CkLadR7X4Nl/vP3Hbi3jHJftsu0sGW7SAkipBa6r3
b8/lfMpPV30FVgwxfRaTbJwLCZVNeDy1P4JcUjoK3iAiH8kV+wbeOMSXnON5M/5U
Sp659hjLgIjK6AoPuJ7EIM57pyh3oTrVYLg0vK/awMGUZUvrZMSX4Ru2BynUIKA4
z2fcq9oMN9obbwwWPWSI/pOTJqDsMLW/pD4TO+I8KSzM41j1EU7/lXhcrA7NKhb5
XRjXvlgKsUtLwlIuQ8kkM/ty0EF9pFomkzzVc+8+UgqWL+XjONFpua+YZJmVK1bM
QijDAyaeoupJr/tbqFKZTL8sWiz6L1/p6gDv7lYw3wJ2T7NBWPv1CotHQ/cnw2Oo
uPJvoN8TLhk=
=pGag
-----END PGP SIGNATURE-----

--Sig_/SkMX+MeeokrvJ3dq3nT5tn.--

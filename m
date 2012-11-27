From: NeilBrown <neilb@suse.de>
Subject: Re: [BUG?] Grow on raid0 causes a level change to raid4 on metadata
 v1.2
Date: Tue, 27 Nov 2012 11:38:32 +1100
Message-ID: <20121127113832.51544a66@notabene.brown>
References: <8565BDA60DEA9E4C91B1047AD1958FBE1DEC60DA@IRSMSX104.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/f=wUIIw0rmdBV4TUdNzOX1j"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8565BDA60DEA9E4C91B1047AD1958FBE1DEC60DA@IRSMSX104.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Tomczak, Marcin" <marcin.tomczak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Dorau, Lukasz" <lukasz.dorau@intel.com>
List-Id: linux-raid.ids

--Sig_/f=wUIIw0rmdBV4TUdNzOX1j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Nov 2012 14:06:09 +0000 "Tomczak, Marcin"
<marcin.tomczak@intel.com> wrote:

> Hi. There is a problem when I try to resize raid0 by adding disk to raid=
=20
> volume. I have checked the problem on mdadm v3.2.3 and on a code from=20
> neil_master branch.
>=20
> OS: Red Hat 6.3 GA
> reproduction: always
> system disk: sda
> other disks: sdb, sdc, sdd
>=20
>=20
> I. mdadm version: v3.2.3
>=20
> # mdadm -CR /dev/md/vol metadata=3D1.2 -l 0 --size=3D4G -n 2 /dev/sdb /de=
v/sdc
> # mdadm -G /dev/md/vol -n 3 --add /dev/sdd
> mdadm: /dev/md/vol: could not set level to raid4
>=20
>=20
> II. mdadm version: branch neil_master
>=20
> SHA1 ID: 30d48159710996be7770bfbfbddc826317b561aa
> Monitor: don't complain about non-monitorable arrays in mdadm.conf
> Author: NeilBrown <neilb@suse.de>  2012-10-24 04:09:09
> Committer: NeilBrown <neilb@suse.de>  2012-10-24 04:09:09
>=20
> # mdadm -CR /dev/md127 --metadata=3D1.2 -l 0 --size=3D15G -n 2 /dev/sdb /=
dev/sdc

--size isn't honoured for RAID0 (or Linear).  I should probably do something
about that - generate a warning at least.

> # mdadm -G /dev/md127 -n 3 --add /dev/sdd
> mdadm: level of /dev/md127 changed to raid4
> mdadm: added /dev/sdd
> mdadm: this change will reduce the size of the array.
>        use --grow --array-size first to truncate array.
>        e.g. mdadm --grow /dev/md127 --array-size 47185920

This happens because the metadata has a size recorded in it, but it is being
ignored, which results in confusions.


> # cat /proc/mdstat
> Personalities : [raid0] [raid6] [raid5] [raid4]
> md127 : active raid4 sdd[3] sdc[1] sdb[0]
>       78107648 blocks super 1.2 level 4, 512k chunk, algorithm 5 [3/3] [U=
UU]
>=20
>=20
> What do you think about this mdadm behaviour?

Not ideal, but not a big problem if you avoid trying to set --size for RAID=
0.

NeilBrown


--Sig_/f=wUIIw0rmdBV4TUdNzOX1j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULQLiDnsnt1WYoG5AQIwWg//blzJX9vBZSqNfsFMeSIQ1oe5tsSih/nB
DxWlS0hNt/dnQfa+QyVxlHPKCFds/ICu1tAY6vqIaZgmBRTo4AsD99C4zKkERCyT
iVlBRM6mqom0hxJs/YIE5CIFrqo8xpqZx4ePRPy2b+MGYjiHN+N6JICJSBKyE5YX
gIvQr5d7xJtn5EJ5W3LVMkVkDLfausLWwV24HqiMSfmC5kDndISLRRbMTJVLexCw
pOMeQ82n8J7S+zPsPueLElAvkncbU8FWfPj4eUcBRmWFD2JRcaGIv14sTHF9LE1J
cJ6chcEMyR8RGkYDJUJPjMsmBS5axlUFCnOkzk/HPiydPvaLk17lzztQ3eG9aVQl
Js2kXpx3a3xD3uMjcn+SeeevJpFzSbbMaOgYj9OFGr/a2+RS23aEEjWORPZNbd+r
dKmV75lhRTnXZoqz5tLAyV9GU1pO8pj6wSX7k/TnmRvV1D1+qxJQCX9FOyIKlnfp
43kc6VfT80uo3Ssm5ZHcC452+4RWUkxrKkWxNORp8db2vYlypVs5vl2nyckVW51q
tJ9GKUaautr8fJZhV71EicuyJmDsvZBDEbEy+cGcEj92dDQleEmYCowy9WWfRyaD
3m5RNZ48TCsFnMCfA4jy3c/AXg66Wc+4ArPL3AiGCL02hkyjdjPpmZFuqxqsOc/B
Q1+NCzt97qI=
=81yO
-----END PGP SIGNATURE-----

--Sig_/f=wUIIw0rmdBV4TUdNzOX1j--

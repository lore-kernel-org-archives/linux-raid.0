From: NeilBrown <neilb@suse.de>
Subject: Re: Filesystem corruption MD (imsm) Raid0 via 2 SSD's + discard
Date: Thu, 21 May 2015 17:14:25 +1000
Message-ID: <20150521171425.32e6bf23@notabene.brown>
References: <alpine.LRH.2.11.1505201918570.4751@praktifix.dwd.de>
	<20150521013213.536deed0@natsu>
	<20150521090845.7e228e46@notabene.brown>
	<alpine.LRH.2.11.1505210636230.9060@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5BKhu=bdAHiU=ayibKN.aaZ"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1505210636230.9060@praktifix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Roman Mamedov <rm@romanrm.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/5BKhu=bdAHiU=ayibKN.aaZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 May 2015 06:44:27 +0000 (UTC) Holger Kiehl <Holger.Kiehl@dwd.de>
wrote:

> On Thu, 21 May 2015, NeilBrown wrote:
>=20
> > On Thu, 21 May 2015 01:32:13 +0500 Roman Mamedov <rm@romanrm.net> wrote:
> >
> >> On Wed, 20 May 2015 20:12:31 +0000 (UTC)
> >> Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
> >>
> >>> The kernel I was running when I discovered the
> >>> problem was 4.0.2 from kernel.org. However, after reinstalling from D=
VD
> >>> I updated to Fedora's lattest kernel, which was 3.19.? (I do not reme=
mber
> >>> the last numbers). So that kernel seems also effected, but I assume it
> >>> contains many 'fixes' from 4.0.x. As filesystem I use ext4, distribut=
ion
> >>> is Fedora 21 and hardware is: Xeon E3-1275, 16GB ECC Ram.
> >>>
> >>> My system seems to be now running stable for some days with kernel.org
> >>> kernel 4.0.3 and with discard DISABLED. But I am still unsure what co=
uld
> >>> be the real cause.
> >>
> >> It is a bug in the 4.0.2 kernel, fixed in 4.0.3.
> >>
> >> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D785672
> >> https://bbs.archlinux.org/viewtopic.php?id=3D197400
> >> https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-=
stable/+/d2dc317d564a46dfc683978a2e5a4f91434e9711
> >>
> >>
> >
> > I suspect that is a different bug.
> > I think this one is
> >  https://bugzilla.kernel.org/show_bug.cgi?id=3D98501
> >
> Should there not be a big fat warning going around telling users to disab=
le
> discard on Raid 0 until this is fixed? This breaks the filesystem complet=
ely
> and I believe there is absolutly no way one can get back the data.

Probably.  Would you like to do that?

>=20
> Is this fixed in 4.0.4? And which kernels are effected? There could be ma=
ny
> people running systems that have not noticed this and don't know in what
> dangerous situation they are when they delete data.

The patch was only added to my tree today.  I will send to Linus tomorrow so
it should appear in the next -rc.
Any -stable kernel released since mid-April probably has the bug.  It was
caused by
commit 47d68979cc968535cb87f3e5f2e6a3533ea48fbd

Once the fix gets into Linus' tree, it should get into subsequent -stable r=
eleases.

The fix is here:

http://git.neil.brown.name/?p=3Dmd.git;a=3Dcommitdiff;h=3Da81157768a00e8cf8=
a7b43b5ea5cac931262374f

commit id should remain unchanged.

Thanks,
NeilBrown


--Sig_/5BKhu=bdAHiU=ayibKN.aaZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVV2F0Tnsnt1WYoG5AQIDxxAAtQAjV5poWEVd4bpQ9DgjfjDk39ezC6RU
XFmDwdJJZuqaoZH4BVGoPFaHpcttxqkdNueK9qc8CymVRAzE+tYINpGvK4onNsUu
fufUL3wmyJ34HFzg63xGKDa/Y3myaipPjL86yTbRhviAvvsjzD3kYaFAh+YsQagT
II1uk2jhV/uNhNideduNpeU9WrCzcnte27fNZPMrYQ1ci7qaVJGD9ss0si58/rrX
Wy46RQN8VbAeRHrldEO3w+H1JKxqMmXO+do5+QS70NeEnoA/YSSlUI91e8cMJqfR
PG1jUxlOaL/nJqmZVbgsDl+sKY872Jbpu9HeJTxUXrHJCiZ0ARiZ4QuJx+4Jy/sA
CacK8SiyU3AHD8Q/GoxMEBVeQOBfoJuPVG6QzywDnVJU4wqMdyvktTb95n78BiSY
9Smx0fKcH+saYDof+IHOedGiDMOeu6wwAutdbsqeOkUt9jXiCkrlzaDFJEQYwIzt
1IQDrMrGdPv8/eYLDcWMwzQzpkvYkuEoTHLtQp1eq8BpcfSvf0VEpUZSKB/DL4BY
hM+ChG9ov2bjhHGyjKFYborqrm5b8/QBDO5D6T9nOQzHISdYmRmnf7niYEs75NfX
vpFcZD6CCBbxgfBZ2XPiOhlN4Ynb1x/LEbT0ocsWNX4N4DwxT6rKU5MQV3cUTQNM
yiisYmBxJDc=
=EkJK
-----END PGP SIGNATURE-----

--Sig_/5BKhu=bdAHiU=ayibKN.aaZ--

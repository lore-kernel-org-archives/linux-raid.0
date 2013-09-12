From: NeilBrown <neilb@suse.de>
Subject: Re: =?UTF-8?B?5Zue5aSNOg==?= [RFC PATCH V3] raid1: rewrite the
 iobarrier =?UTF-8?B?4oCV?= Linux RAID Storage
Date: Thu, 12 Sep 2013 16:37:34 +1000
Message-ID: <20130912163734.50d9031f@notabene.brown>
References: <201308281940028090534@gmail.com>
	<2013091214210358767013@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FGNXY+sNMONmUQLFUiDezYS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2013091214210358767013@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/FGNXY+sNMONmUQLFUiDezYS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Sep 2013 14:21:05 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Hi Neil,
> 	How about this patchset?
> Thanks!
> Jianpeng Ma

Sorry - it fell of my todo list.  I might not be able to look at it properly
for a few weeks (due to leave) but I'll make sure it stays on my list.

NeilBrown

> >Patch1/2/3 are only to easy implemented for patch4.They don't effect the=
 performance.
> >
> >Performance Result:
> >Requirement:
> >A: sync_speed_max =3D sync_speed_min =3D 200000
> >B: echo repair > sync_action
> >
> >Without the patch3:
> >TestA:
> >fio --rw=3Dread --bs=3D512k --filename=3D/dev/md0 --offset=3D10001994670=
08 --rate=3D50M --ratemin=3D30M --name=3Dtest --runtime=3D600s
> >>>READ: io=3D8861.6MB, aggrb=3D15123KB/s, minb=3D15123KB/s, maxb=3D15123=
KB/s, mint=3D600012msec, maxt=3D600012msec
> >cat /proc/mdstat
> >>>speed=3D25522K/sec
> >
> >TestB:
> >fio --rw=3Dwrite --bs=3D512k --filename=3D/dev/md0 --offset=3D1000199467=
008 --rate=3D50M --name=3Dtest --runtime=3D600s
> >>>WRITE: io=3D1939.6MB, aggrb=3D3309KB/s, minb=3D3309KB/s, maxb=3D3309KB=
/s, mint=3D600033msec, maxt=3D600033msec
> >cat /proc/mdstat
> >>>speed=3D7732K/sec
> >
> >
> >With the patch3:
> >TestA:(Make sure the position of read after resync)
> >fio --rw=3Dread --bs=3D512k --filename=3D/dev/md0 --offset=3D10001994670=
08  --rate=3D50m  --name=3Dtest=20
> >>>READ: io=3D12547MB, aggrb=3D40810KB/s, minb=3D40810KB/s, maxb=3D40810K=
B/s, mint=3D314815msec, maxt=3D314815msec
> >cat /proc/mdstat:
> >>>speed=3D43745K/sec
> >
> >TestB:(Make sure the position of write after resync)
> >fio --rw=3Dwrite --bs=3D512k --filename=3D/dev/md0 --offset=3D1000199467=
008 --rate=3D50m  --name=3Dtest --runtime=3D600
> >>>WRITE: io=3D30001MB, aggrb=3D51200KB/s, minb=3D51200KB/s, maxb=3D51200=
KB/s, mint=3D600001msec, maxt=3D600001msec
> >cat /proc/mdstat
> >>>speed=3D26686K/sec
> >
> >TestC:(Make sure the position of read before resync)
> >fio --rw=3Dread --bs=3D512k --filename=3D/dev/md0 --offset=3D0 --rate=3D=
50m --name=3Dtest --runtime=3D600
> >>>READ: io=3D29725MB, aggrb=3D50729KB/s, minb=3D50729KB/s, maxb=3D50729K=
B/s, mint=3D600004msec, maxt=3D600004msec
> >cat /proc/mdstat
> >>>speed=3D44839K/sec
> >
> >TestD:(Make sure the positon of write before resync)
> >fio --rw=3Dwrite --bs=3D512k --filename=3D/dev/md0 --offset=3D0 --rate=
=3D50m --name=3Dtest --runtime=3D600
> >>> WRITE: io=3D30001MB, aggrb=3D51200KB/s, minb=3D51200KB/s, maxb=3D5120=
0KB/s, mint=3D600001msec, maxt=3D600001msec
> >cat /proc/mdstat
> >>>speed=3D30884K/sec
> >
> >V3:
> >	patch1: rename a paramter make it more understandable.
> >	patch2: not change.
> >	patch3 draw from patch3 of V2.
> >	patch4: reconstruct some code
> >            rename some parameters make it more understandable.
> >			modify some trivial bugs.
> >
> >V2:http://www.spinics.net/lists/raid/msg44138.html
> >
> >V1:http://www.spinics.net/lists/raid/msg41710.html
> >
> >
> >Jianpeng Ma (4):
> >  raid1: Add a filed array_frozen to indicate whether raid in freeze   =
=20
> >    state.
> >  radi1: Relace raise_barrier/lower_barrrier with
> >    freeze_array/unfreeze_array for reconfigure the array.
> >  raid1: Add some macros to make code clearly.
> >  raid1: Rewrite the implementation of iobarrier.
> >
> > drivers/md/raid1.c | 151 +++++++++++++++++++++++++++++++++++++++++++---=
-------
> > drivers/md/raid1.h |  15 ++++++
> > 2 files changed, 137 insertions(+), 29 deletions(-)
> >
> >--=20
> >1.8.1.2

--Sig_/FGNXY+sNMONmUQLFUiDezYS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFhLjnsnt1WYoG5AQLcfg//dllCqzz5ZL80z4CxuxRt6jybJqxJYNY0
QX6+NAHsc2NDOieefxoKwblD8EA2rzUy6FjQLbYilHV1WUKG3mSjRcXJYyCpQ5Pv
6P6XxduCuT2LyoKq4Px8uCm2QdUVip2doh1jPu6G64IINqm4Ris1xJrLSh2rbPWO
nhLMaPBTj70TGpGDUVlP2IbhfI6YTXHjgB1QbuBJWPamg/lA6c1A72f2IfO44pVz
hhC7W2heC6T6KVgu2TejaYJqAJI8efok2nGE5yaSpeirW9p0Nds2eR/OgKyhxWrI
LNmkrNpe1uu/vfOvdt331okovZnUmHdNU/z8eQtTEthoA0gZfTiCN9U39CenkEx2
b92xTwEDs/H9421so/zzVx+cN8vyWzbJSCCUQ6ixdxZRRsuxSyVbyoaObt8JyzsD
qzH+eLdD+E8GEoKci9MiCCXNYVltf/ojhxTok6Oao6ahZT44bbGFxn8o3kv6G7Vs
xKFRksMUCm5e3hExyDJjSdd1fJAolBPl/PO00VZXoHbWUqcWD1+EKyUIYl/AO4XB
B7qh/3bHN6vRObfZ0W8Sap1I9LjGtXA1nbimHUqna7iPZ3oUm5IlDjVz/vc5Dhyp
4lwbSUVBsQYkMIkoPbQBmAu8mu8vX88BwkJJeuXGu9kVW8awee7P/YB1mpZ6flLy
DxU1GSMfDeM=
=l8EV
-----END PGP SIGNATURE-----

--Sig_/FGNXY+sNMONmUQLFUiDezYS--

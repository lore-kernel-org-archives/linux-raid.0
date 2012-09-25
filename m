From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: Avoid doing more read on dev of a stripe at the
 same time
Date: Tue, 25 Sep 2012 17:29:12 +1000
Message-ID: <20120925172912.65db0e03@notabene.brown>
References: <2012091510203206229010@gmail.com>
	<20120920125144.0ed69ec3@notabene.brown>
	<201209201104415460652@gmail.com>
	<20120920132422.0f7841f1@notabene.brown>
	<201209211024418590971@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3PauO7cYUswK3N6m=kLaT_Z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201209211024418590971@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/3PauO7cYUswK3N6m=kLaT_Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Sep 2012 10:24:45 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> On 2012-09-20 11:24 NeilBrown <neilb@suse.de> Wrote:
> >On Thu, 20 Sep 2012 11:04:46 +0800 "Jianpeng Ma" <majianpeng@gmail.com> =
wrote:
> >
> >> On 2012-09-20 10:51 NeilBrown <neilb@suse.de> Wrote:
> >> >On Sat, 15 Sep 2012 10:20:35 +0800 "Jianpeng Ma" <majianpeng@gmail.co=
m> wrote:
> >> >
> >> >> In func 'ops_run_bio' if you read the dev which the last reading
> >> >> of this dev didn't return,it will destrory the  req/rreq'source of =
rdev.
> >> >> It may call hung-task.
> >> >> For example, for badsector or other reasons, read-operation only us=
ed
> >> >> stripe instead of chunk_aligned_read.
> >> >> First:stripe 0;second: stripe 8;third:stripe 16.At the block-layer,=
three
> >> >> bios merged.
> >> >> Because media error of sector from 0 to 7, the request retried.
> >> >> At this time, raid5d readed stripe0 again.But it will set 'bio->nex=
t =3D
> >> >> NULL'.So the stripe 8 and 16 didn't return.
> >> >>=20
> >> >> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> >> >
> >> >Hi,
> >> > I'm really trying, but I cannot understand what you are saying.
> >> >
> >> Sorry for my bad english.
> >> >I think the situation that you are describing involves a 24 sector re=
quest.
> >> >This is attached to 3 stripe_heads - 8 sectors each - at address 0, 8=
, 16.
> >> >
> >> >So 'toread' on the first device of each stripe points to this bio, and
> >> >bi_next is NULL.
> >> >
> >> >The "req" bio for each device is filled out to read one page and thes=
e three
> >> >'req' bios are submitted.  The block layer merges these into a single=
 request.
> >> >
> >> >This request reports an error because there is a read error somewhere=
 in the
> >> >first  8 sectors.
> >> >
> >> Yes,
> >> >So one, or maybe all, of the 'req' bios return with an error?
> >> From my test, when req did not return and at the same time, the bio(st=
ripe 0) send.
> >> So this operation will set bi_next is NULL.
> >
> >Are you saying that we send another bio before the first one has returne=
d?
> >That shouldn't be possible as sh->count will prevent it from happening.
> >While there is an outstanding request, sh->count will be >0, and until
> >sh->count is 0, we won't try to send any more requests.
> >
> >So I still don't understand.  Please try to provide as much detail as
> >possible.  If it is easier, write in your own language and use
> >translate.google.com to convert to english. ??
> >
> >Thanks,
> >NeilBrown
>=20
> Hi,
>  i wrote a shell-script can reproduct this bug.
> Note: mdadm -V
> mdadm - v3.3-pre - Unreleased
>=20
>=20
> #!/bin/bash
>=20
> declare -i count
> declare -i sector
> count=3D0
> sector=3D2048
> while true
> do
> 	hdparm --make-bad-sector $sector --yes-i-know-what-i-am-doing /dev/sdc >=
 /dev/null
> 	hdparm --make-bad-sector $sector --yes-i-know-what-i-am-doing /dev/sdd >=
 /dev/null
> 	hdparm --make-bad-sector $sector --yes-i-know-what-i-am-doing /dev/sde >=
 /dev/null
> 	let count++
> 	let sector+=3D$count*8
> 	if (($count =3D=3D 40));then
> 		break
> 	fi
> done
>=20
> while true
> do
> 	mdadm -S /dev/md0
> 	mdadm -CR /dev/md0 -l5 -c4 -n4 missing /dev/sd[cde]
> 	dd if=3D/dev/md0 of=3D/dev/null bs=3D10M count=3D1 iflag=3Ddirect
> 	sleep 1
> done
>=20
>=20
> Thanks

Thanks a lot!
I'll try this out and see what I find.

NeilBrown

--Sig_/3PauO7cYUswK3N6m=kLaT_Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGFdSDnsnt1WYoG5AQK67Q//faDaj/XPRH6TI4qwvB6s+xZoYeUEXyQl
VUYfSV1eZcQmZRGw3EliF54Sx/PWNYfksRhqSwg64ElHu/iGOCKLGBIFfF6yoGL8
3z+xdTPgk7mqnli8sVpRX4r0rMCmYN5MxEWWqoAks2Mj9RBrVhpYifgh31XE8t0L
MvO1cTUSetx8mEoLL5AAIsEiIFvYHcAPU5I5OcBOB8FncHjtNXOkgxuFdKsz/VPr
gToqATStGBoHDBTeGvSEN43yFjsTEz4H3ELf5Y1s28n4fLF3uiqOQGmhPuQqsgIg
F0E6Nh+OvS4ZzlRco1XJ5WWdbQjaPon/gsSOiLP9QCOBPIgiH4ivpspGoyavxyC3
XIMeO3wv1krraxxFLXIKgQdiw0msxULYBsxgxDhpA4iLdOSTPcqfyCaAoYxVd3rK
UBxDzhjdzySrTzz1OP6iqYXVC07nbkN+GXc+ou9I3E0/R2hetM9A3RDf8bNLpQcR
4tiD+cWqdrxA6hwLUirJ6L/r9IoWLiRxFuhAPYjeHI/j2FlNLJ62TOxyQfW+ZPVp
Wy4d8Busq44ocw6np+2Om7D4us8RkuJP1iyD63WXNDa+XecTWIgk7Ec1yZulZeru
TbH6VdEu+KfEWyCP3Jxfn0GIjpD/h4d6toRmHjXNgtO0HRigeEAXb8DAHarbsNTA
fUEU+dMh5I4=
=m7wd
-----END PGP SIGNATURE-----

--Sig_/3PauO7cYUswK3N6m=kLaT_Z--

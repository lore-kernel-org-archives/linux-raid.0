From: NeilBrown <neilb@suse.de>
Subject: Re: Converting from Raid 5 to 6
Date: Tue, 25 Oct 2011 07:39:08 +1100
Message-ID: <20111025073908.6d754588@notabene.brown>
References: <CAFsPQ_85omy81WkxKkFg+OCGmdD7A+UtyKo64qMLZBBVKpbBDw@mail.gmail.com>
	<CADNH=7H90HX58zh8mSH54FdFgh46umEscj89t372PZjj9DnHtg@mail.gmail.com>
	<CAFsPQ__G3j3CbMDJyYO7BaJrxnPi=MAZFiRfgbruzMhiCVQYag@mail.gmail.com>
	<20111025071443.4c497656@notabene.brown>
	<CAFsPQ_9UBtLJX_5KZSVxiQfM7+mBnU1=8P_nNLmUKo7vHcQypQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/woCMn8K.MlNnfYkXLV6=a15"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFsPQ_9UBtLJX_5KZSVxiQfM7+mBnU1=8P_nNLmUKo7vHcQypQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Busby <michael.a.busby@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/woCMn8K.MlNnfYkXLV6=a15
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Oct 2011 21:19:22 +0100 Michael Busby <michael.a.busby@gmail.com>
wrote:

> Ok thanks, i have 1 small issue, when added the extra disk its been
> maked as spare, is this normal?
>=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid6 sde[0] sdg[6](S) sda[4] sdb[3] sdd[2] sdc[1]
>       7814055936 blocks super 1.0 level 6, 512k chunk, algorithm 18
> [6/5] [UUUUU_]
>       [>....................]  reshape =3D  3.0% (59244544/1953513984)
> finish=3D11122.8min speed=3D2837K/sec
>=20

It looks like the extra drive was added after you started the grow.

So it is still a spare.
Once the grow finishes you will have a singly-degraded RAID6.
Then it will immediately start recovering the missing device to the spare.

Did you add the extra drive after starting the grow - or before??

NeilBrown



>=20
>=20
>=20
> On 24 October 2011 21:14, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 24 Oct 2011 17:03:46 +0100 Michael Busby <michael.a.busby@gmail=
.com>
> > wrote:
> >
> >> should the speed be very slow when doing this progress, its a lot
> >> slower than a normal grow
> >
> > Yes.
> > The array is being reshaped in-place. =A0i.e. data is being read from p=
art of
> > the array, rearranged, and written back to the same part of the array.
> > As you can imagine, this is risky - a crash will leave an inconsistent =
state.
> > Hence the backup file. =A0Everything in the array is first written to t=
he
> > backup file, then back to the array. =A0So it is slow.
> >
> > A "normal" grow is writing to somewhere where there is no valid data, s=
o it
> > doesn't need the backup.
> >
> > I do have a plan to make this faster.... but I have lots of plans and l=
ittle
> > time.
> >
> > NeilBrown
> >
> >
> >
> >
> >>
> >> reshape =3D =A01.2% (25006080/1953513984) finish=3D12481.8min speed=3D=
2574K/sec
> >>
> >> On 24 October 2011 15:11, Mathias Bur=E9n <mathias.buren@gmail.com> wr=
ote:
> >> > On 24 October 2011 14:11, Michael Busby <michael.a.busby@gmail.com> =
wrote:
> >> >> At the moment i have a raid5 setup with 5 disks, i am looking=A0to =
add a
> >> >> 6th disk and change from raid 5 to raid 6
> >> >>
> >> >> having looked at Neil's site i have found the following command, and
> >> >> just want to double check this is still the recommend way of
> >> >> converting
> >> >>
> >> >> mdadm --grow /dev/md0 --level=3D6 --raid-disks=3D6 --backup-file=3D=
/home/md.backup
> >> >>
> >> >> also would i need to add the extra disk before or after the command?
> >> >>
> >> >> cheers
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> >> >>
> >> >
> >> > Hi,
> >> >
> >> > I grew my 6 disk RAID5 to a 7 disk RAID6. First, add the drive. Then
> >> > partition it as required. Then add the drive to the array (I think
> >> > it'll become a spare?). Then you can grow it.
> >> >
> >> > Make sure you're using the latest mdadm tools available.
> >> >
> >> > Regards,
> >> > Mathias
> >> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> >
> >


--Sig_/woCMn8K.MlNnfYkXLV6=a15
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqXM7Tnsnt1WYoG5AQJ4Eg/+NR9SH8i2lmDUFZ3k1ttGcubMLjU1Is4H
4Vk8AzPCki1p13bIr8OqXNWsLrJzCnSQeiMRwpBedureth5hc97pVPq1+HfxyTVL
FLyNceecyhsz6CcUrEnqoBdVwCp/dUyxGwbhwbBgp61aVsK/bpBqUL7pPji5TbS8
L5ttzo6a5fKf7qCft/0avjttx7Ki0+NFkICJu449WjPuBoLk+EMoqqpnABRSyiRs
EUBFfP+JIFfivDuoVTl25XzkKJTipZX+aVKVbowqVLelBHYyODN90C8m7NYyoZ5e
rzvIZ84ZKXIdyBcvcVnyCS3bPzjLedCi5908pBTMCb86Fo9xIWxCT4Fco+1duwBK
/q57PR77ZIX9Z5+nfQO8FYdSsm1xGpIyi23A9ijUoLCrmqn4pztF/zS4qrisJqeo
PSqTBjjh3ReTRNyfhnbLf9bfzrWUEPOblDaj/f1bP6zylhHBwT+Mj2WK00M4N2+H
po3wulf3qTCYIfTvqd60os0BAiYaksO7NZwQR3x9dWPcd/Xx4GsmrWdhtXoBwSZ6
fcQX08n6ese9i3hm4onzvPWO990UcftORfFrLsHPtYUHJYdZt79ELqasRbvbfD6s
ktuQGhnUe1QFJ6vf5v6lnf0/MeBe+k5khxIV3QQ7s31zaWVNOuCixpZhVeVsT4xt
YZ+4VpkpN+k=
=Wrlf
-----END PGP SIGNATURE-----

--Sig_/woCMn8K.MlNnfYkXLV6=a15--

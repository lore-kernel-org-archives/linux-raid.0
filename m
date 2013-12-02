From: NeilBrown <neilb@suse.de>
Subject: Re: Converting from Raid 5 to 6
Date: Tue, 3 Dec 2013 07:38:09 +1100
Message-ID: <20131203073809.3238b7e4@notabene.brown>
References: <CAFsPQ_85omy81WkxKkFg+OCGmdD7A+UtyKo64qMLZBBVKpbBDw@mail.gmail.com>
	<CADNH=7H90HX58zh8mSH54FdFgh46umEscj89t372PZjj9DnHtg@mail.gmail.com>
	<CAFsPQ__G3j3CbMDJyYO7BaJrxnPi=MAZFiRfgbruzMhiCVQYag@mail.gmail.com>
	<20111025071443.4c497656@notabene.brown>
	<CAFsPQ_9UBtLJX_5KZSVxiQfM7+mBnU1=8P_nNLmUKo7vHcQypQ@mail.gmail.com>
	<20111025073908.6d754588@notabene.brown>
	<CAFsPQ_-9BU_x_VKJSThTNhmQrcYZaoyJTfWgyGKVjhtEVe5-oA@mail.gmail.com>
	<CAFsPQ_87o6mB9jAP-bXRjyjWvOeb17-ke2fJCJOqeKQumoksiA@mail.gmail.com>
	<20131202165127.0fe2dd5f@notabene.brown>
	<2042216353575894098@unknownmsgid>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QVZor3yjGpFJkbAY3O3s=SY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2042216353575894098@unknownmsgid>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Busby <michael.a.busby@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/QVZor3yjGpFJkbAY3O3s=SY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Dec 2013 15:07:57 +0000 Michael Busby <michael.a.busby@gmail.com>
wrote:

> Using -f seems to have worked just running e2fsck now

Excellent.

>=20
> When running a command like mdadm --assemble -- force --verbose
> /dev/md0 /dev/sa[abcde] how important it the drive order?

Not at all.  The order is only important for --create.

NeilBrown

>=20
>=20
> Sent from my iPad
>=20
> > On 2 Dec 2013, at 05:51 am, NeilBrown <neilb@suse.de> wrote:
> >
> > On Sat, 30 Nov 2013 22:13:58 +0000 Michael Busby <michael.a.busby@gmail=
.com>
> > wrote:
> >
> >> Sorry to bring up a old thread, last night i had a power cut and this
> >> morning when the power has come back i have tried to boot the server,
> >> but the raid will not assemble on using a live CD i have found that
> >> one of the disk is reporting "possibly out of date" is there any way
> >> to force this disk back in? the bigger problem i have is that my
> >> external caddie has died so i was running a degraded raid 6 but now it
> >> is only starting with 4 out of 6 devices. is there anyway to get this
> >> back?
> >
> > It's really hard to know what is possible without precise details.
> > Output of "mdadm -E" for each member device is always a good idea.
> > If you are having trouble assembling, then output of the assemble comma=
nd
> > with -vv added never goes astray.
> > Have you tried adding "-f" to the assemble command.  Often helps and is
> > unlikely to hurt.
> >
> >>
> >> i have though about recreating the array using the --assume-clean
> >> option but not sure if that's a good idea
> >
> > Not a good idea except as a very last resort.
> >
> > NeilBrown
> >
> >
> >>
> >> any help will be much appreciated
> >>
> >>
> >>
> >>> On 24 October 2011 21:47, Michael Busby <michael.a.busby@gmail.com> w=
rote:
> >>>
> >>> I was sure i added the device before, but when rebooted the system it
> >>> has seemed to lose the extra drive and i had already restarted the
> >>> grow command with out checking the disk was there, so more than likely
> >>> a mistake by me
> >>>
> >>>
> >>>
> >>>> On 24 October 2011 21:39, NeilBrown <neilb@suse.de> wrote:
> >>>> On Mon, 24 Oct 2011 21:19:22 +0100 Michael Busby <michael.a.busby@gm=
ail.com>
> >>>> wrote:
> >>>>
> >>>>> Ok thanks, i have 1 small issue, when added the extra disk its been
> >>>>> maked as spare, is this normal?
> >>>>>
> >>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> >>>>> [raid4] [raid10]
> >>>>> md0 : active raid6 sde[0] sdg[6](S) sda[4] sdb[3] sdd[2] sdc[1]
> >>>>>      7814055936 blocks super 1.0 level 6, 512k chunk, algorithm 18
> >>>>> [6/5] [UUUUU_]
> >>>>>      [>....................]  reshape =3D  3.0% (59244544/195351398=
4)
> >>>>> finish=3D11122.8min speed=3D2837K/sec
> >>>>
> >>>> It looks like the extra drive was added after you started the grow.
> >>>>
> >>>> So it is still a spare.
> >>>> Once the grow finishes you will have a singly-degraded RAID6.
> >>>> Then it will immediately start recovering the missing device to the =
spare.
> >>>>
> >>>> Did you add the extra drive after starting the grow - or before??
> >>>>
> >>>> NeilBrown
> >>>
> >>>
> >>>>
> >>>>>
> >>>>>
> >>>>>
> >>>>>> On 24 October 2011 21:14, NeilBrown <neilb@suse.de> wrote:
> >>>>>> On Mon, 24 Oct 2011 17:03:46 +0100 Michael Busby <michael.a.busby@=
gmail.com>
> >>>>>> wrote:
> >>>>>>
> >>>>>>> should the speed be very slow when doing this progress, its a lot
> >>>>>>> slower than a normal grow
> >>>>>>
> >>>>>> Yes.
> >>>>>> The array is being reshaped in-place.  i.e. data is being read fro=
m part of
> >>>>>> the array, rearranged, and written back to the same part of the ar=
ray.
> >>>>>> As you can imagine, this is risky - a crash will leave an inconsis=
tent state.
> >>>>>> Hence the backup file.  Everything in the array is first written t=
o the
> >>>>>> backup file, then back to the array.  So it is slow.
> >>>>>>
> >>>>>> A "normal" grow is writing to somewhere where there is no valid da=
ta, so it
> >>>>>> doesn't need the backup.
> >>>>>>
> >>>>>> I do have a plan to make this faster.... but I have lots of plans =
and little
> >>>>>> time.
> >>>>>>
> >>>>>> NeilBrown
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>>>
> >>>>>>> reshape =3D  1.2% (25006080/1953513984) finish=3D12481.8min speed=
=3D2574K/sec
> >>>>>>>
> >>>>>>>> On 24 October 2011 15:11, Mathias Bur=C3=A9n <mathias.buren@gmai=
l.com> wrote:
> >>>>>>>>> On 24 October 2011 14:11, Michael Busby <michael.a.busby@gmail.=
com> wrote:
> >>>>>>>>> At the moment i have a raid5 setup with 5 disks, i am looking t=
o add a
> >>>>>>>>> 6th disk and change from raid 5 to raid 6
> >>>>>>>>>
> >>>>>>>>> having looked at Neil's site i have found the following command=
, and
> >>>>>>>>> just want to double check this is still the recommend way of
> >>>>>>>>> converting
> >>>>>>>>>
> >>>>>>>>> mdadm --grow /dev/md0 --level=3D6 --raid-disks=3D6 --backup-fil=
e=3D/home/md.backup
> >>>>>>>>>
> >>>>>>>>> also would i need to add the extra disk before or after the com=
mand?
> >>>>>>>>>
> >>>>>>>>> cheers
> >>>>>>>>> --
> >>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
> >>>>>>>>> the body of a message to majordomo@vger.kernel.org
> >>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
> >>>>>>>>
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> I grew my 6 disk RAID5 to a 7 disk RAID6. First, add the drive. =
Then
> >>>>>>>> partition it as required. Then add the drive to the array (I thi=
nk
> >>>>>>>> it'll become a spare?). Then you can grow it.
> >>>>>>>>
> >>>>>>>> Make sure you're using the latest mdadm tools available.
> >>>>>>>>
> >>>>>>>> Regards,
> >>>>>>>> Mathias
> >>>>>>> --
> >>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
> >>>>>>> the body of a message to majordomo@vger.kernel.org
> >>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >


--Sig_/QVZor3yjGpFJkbAY3O3s=SY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpzvsTnsnt1WYoG5AQKf1RAAmPfrTqIpLmGpa7oPFnjra2onEJqwSiSV
B/x6kDMmaMmzd8inJEHghTFcuCTkRf+Jy+f7Oo3fXDaRsZPD1Yc0iGfp2nh8y1GM
STcs8owyg6sQGMsLp5zji7XwtFyMgs1M5cUtozSz4ofaWn7KjQKBzH3I+UMxnQwR
Amea//dFaUQbY7GwANAsSAq2NxXkS8thk4wl80GAH/xPd3+SuqQlVlyaCTtE3Mpy
10lewel+95QuwDPRZACkH7aHArycz6CAH0p5VNXwllzKBg0aJZGF8Jr0IWC4ib7U
RZuFm+rMSpCDCMQNfdrd0wS8CsNOdQheCN9MkfNiPZndigED0t8LjTSbOpWxF3Ae
p1ClHyva4ZpscY1rPSxf7DSQ1grM2OvOE18m9so6tX8XCUP5ZmmXSL+a0uZrPuIa
yQPPWdbgehf1aEkZbiQEcrQLRMQ6gMHLPcLfWKdCBqWLPodcY42PQrO6GdsCT7M5
0C4DJy8obYj477urYzauBxeGnHRxAIUuFDasms4JzH/zKqTOSRn426ae48LLjy3L
0FdvMy2yy9muzvfKvBDUF40YLfdGsXNGSyjKr/kqTsBxe4/UGOPoyubtVave9gsb
OjHpUKMSsD0tUiJk7ZPv9lfhWbd3SByqwdngrnYw1E/lg6587CNt4pO+5xinckk9
1W0SyHalM0s=
=pU8F
-----END PGP SIGNATURE-----

--Sig_/QVZor3yjGpFJkbAY3O3s=SY--

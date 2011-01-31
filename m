From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 20:28:58 +0100
Message-ID: <20110131192858.GD27952@www2.open-std.org>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com> <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com> <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com> <20110131152151.GD7861@cthulhu.home.robinhill.me.uk> <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com> <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com> <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com> <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com> <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Top-posting...

How is the raid0+1 problem of only 33 % survival for 2 disk with RAID10=
?

I know for RAID10,F2 the implementation in Linux MD is bad.
It is only 33 % survival, while it with a probably minor fix could be 6=
6%.

But how with RAID10,n2 and RAID10,o2?

best regards
keld


On Mon, Jan 31, 2011 at 05:15:29PM -0200, Roberto Spadim wrote:
> ok, but lost of a disk =3D problem with hardware =3D big problems =3D=
 mirror failed
> think about a 'disaster recover' system
> you can?t lost the main data (you MUST have one 'primary' data source=
)
>=20
> raid1 don?t have ecc or anyother 'paged' data recover solution (it
> have just all mirror resync)
>=20
> let?s get back a level... (inside hard disk)
> if your hard disk have 2 heads, you have a raid0 inside you disk (got
> the point?)
> using your math, you should consider head problem (since it make the
> real read of information)
>=20
> but at raid (1/0) software (firmware) level, you have devices (with
> out without heads, can be memory or anyother type of adresseable
> information souce, RAID0 =3D DEVICE for raid software/firmware,  but =
you
> have A DEVICE)
>=20
> for raid 1 you have mirrors(a copy of one primary device)
> if software find 1bit of error inside this mirror(device), you lost
> the full mirror, 1bit of fail =3D mirror fail!!!!! it?s not more sync
> with the main(primary) data source!!!!
>=20
> got the problem? mirror will need a resync if any disk fail (check
> what fail make you mirror to fail, but i think linux raid1 mirror fai=
l
> with any disk fail)
>=20
> if you have 4 mirrors you can loose 4 disks (1 disk fail =3D mirror
> fail, 2 disk fail =3D mirror fail, 3 disk fail =3D mirror fail, any d=
evice
> with fail inside a raid1 device will make the mirror to fail, got? yo=
u
> can have good and bad disks on raid0, but you will have a mirror
> failed if you have >=3D1 disk fail inside your raid0)
>=20
> got the point?
> what?s the probability of your mirror fail?
> if you use raid0 as mirror
> any disk of raid0 failed =3D mirror failed got?
> you can lose all raid0 but you have just 1 mirror failed!
>=20
>=20
> could i be more explicit? you can?t make probability using bit, you
> must make probability using mirror, since it?s you level of data
> consistency
> =3D] got?
>=20
>=20
> 2011/1/31 Denis <denismpa@gmail.com>:
> > 2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
> >> i think that partial failure (raid0 fail) of a mirror, is a fail
> >> (since all mirror is repaired and resync)
> >> the security is, if you lose all mirrors you have a device
> >> so your 'secure' is the number of mirrors, not the number of disks=
 ssd
> >> or another type of device...
> >> how many mirrors you have here:
> >> raid0=3D 1,2(a) 3,4(b)
> >> raid1=3Da,b
> >> 1 mirror (a or b)
> >>
> >> and here:
> >> raid1=3D1,2(a) 3,4(b)
> >> raid0=3Dab
> >> 1 mirror (a or b)
> >>
> >> let?s think about hard disk?
> >> your hard disk have 2 disks?
> >> why not make two partition? first partition is disk1, second parti=
tion is disk2
> >> mirror it
> >> what?s your security? 1 mirror
> >> is it security? normaly when a harddisk crash all disks inside it
> >> crash but you is secury if only one internal disk fail...
> >>
> >> that?s the point, how many mirror?
> >> the point is
> >> with raid1+0 (raid10) we know that disks are fragments (raid1)
> >> with raid0+1 we know that disks are a big disk (raid0)
> >> the point is, we can?t allow that information stop, we need mirror=
 to
> >> be secured (1 is good, 2 better, 3 really better, 4 5 6 7...)
> >> you can?t break mirror (not disk) to don?t break mirror have a sec=
ond
> >> mirror (raid0 don?t help here! just raid1)
> >>
> >> with raid10 you will repair smal size of information (raid1), here
> >> sync will cost less time
> >> with raid01 you will repair big =A0size of information (raid0), he=
re
> >> sync will cost more time
> >
> > Roberto, to quite understend how better a raid 10 is over raid 01 =A0=
you
> > need to take down into a mathematical level:
> >
> > once I had the same doubt:
> >
> > "The difference is that the chance of system failure with two drive
> > failures in a RAID 0+1 system with two sets of drives is (n/2)/(n -=
 1)
> > where n is the total number of drives in the system. The chance of
> > system failure in a RAID 1+0 system with two drives per mirror is 1=
/(n
> > - 1). So, for example, using a 8 drive system, the chance that losi=
ng
> > a second drive would bring down the RAID system is 4/7 with a RAID =
0+1
> > system and 1/7 with a RAID 1+0 system."
> >
> >
> > Another problem is that in the case of a failury of one disk ( in a
> > two sets case), in a raid01 you will loose redundancy for ALL your
> > data, while in a raid10 you will loose redundancy for 1/[(n/2
> > -1)/(n/2)], in the same case 1/4 of your data set.
> >
> > And also, in a raid 10 you will have o re-mirror just one disk in t=
he
> > case of a disk failure, in raid 01 you will have to re-mirror the
> > whole failed set.
> >
> > --
> > Denis Anjos,
> > www.versatushpc.com.br
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
>=20
> --=20
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

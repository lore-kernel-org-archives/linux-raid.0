From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 18:56:25 +0100
Message-ID: <20110201175625.GA25953@www2.open-std.org>
References: <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com> <20110131225235.GA11775@www2.open-std.org> <ii8lcv$3jg$1@dough.gmane.org> <20110201160245.GA25659@www2.open-std.org> <AANLkTikUuJ5T8r0btFGzeb73BSW97kcsV5JDAjD9my+9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikUuJ5T8r0btFGzeb73BSW97kcsV5JDAjD9my+9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 01, 2011 at 02:24:01PM -0200, Roberto Spadim wrote:
> thinking about this:
>=20
> > I don't think you get the striping performance of raid10,f2 with th=
is
> > layout. And that is one of the main advantages of raid10,f2 layout.
> > Have you tried it out?
>=20
> since you have a raid1, you don?t need striping, you can read from an=
y
> mirror, the information is the same, raid1 read is as fast as raid0
> read, just write is slower (it must read on each mirror)
> the only problem is raid0 part, or you use linear or stripe, i think
> raid10 mdadm algorithm use stripe for raid0 part

well, raid0 is for reading sequentially, about double as fast as raid1.
https://raid.wiki.kernel.org/index.php/Performance

best regards
keld

> 2011/2/1 Keld J=F8rn Simonsen <keld@keldix.com>:
> > On Tue, Feb 01, 2011 at 11:01:33AM +0100, David Brown wrote:
> >> On 31/01/2011 23:52, Keld J=F8rn Simonsen wrote:
> >> >raid1+0 and Linux MD raid10 are similar, but significantly differ=
ent
> >> >in a number of ways. Linux MD raid10 can run on only 2 drives.
> >> >Linux raid10,f2 has almost RAID0 striping performance in sequenti=
al read.
> >> >You can have an odd number of drives in raid10.
> >> >And you can have as many copies as you like in raid10,
> >> >
> >>
> >> You can make raid10,f2 functionality from raid1+0 by using partiti=
ons.
> >> For example, to get a raid10,f2 equivalent on two drives, partitio=
n them
> >> into equal halves. =A0Then make md0 a raid1 mirror of sda1 and sdb=
2, and
> >> md1 a raid1 mirror of sdb1 and sda2. =A0Finally, make md2 a raid0 =
stripe
> >> set of md0 and md1.
> >
> > I don't think you get the striping performance of raid10,f2 with th=
is
> > layout. And that is one of the main advantages of raid10,f2 layout.
> > Have you tried it out?
> >
> > As far as I can see the layout of blocks are not alternating betwee=
n the
> > disks. You have one raid1 of sda1 and sdb2, there a file is allocat=
ed on
> > blocks sequentially on sda1 and then mirrored on sdb2, where it is =
also
> > sequentially allocated. That gives no striping.
> >
> >> I don't think there is any way you can get the equivalent of raid1=
0,o2
> >> in this way. =A0But then, I am not sure how much use raid10,o2 act=
ually is
> >> - are there any usage patterns for which it is faster than raid10,=
n2 or
> >> raid10,f2?
> >
> > In theory raid10,o2 should have better performance on SSD's because=
 of
> > the low latency, and raid10,o2 doing multireading from each drive, =
which
> > raid0,n2 does not.
> >
> > We lack some evidence from benchmarks, tho.
> >
> > best regards
> > keld
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

From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 21:32:10 +0100
Message-ID: <20110201203210.GB26468@www2.open-std.org>
References: <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com> <20110131225235.GA11775@www2.open-std.org> <ii8lcv$3jg$1@dough.gmane.org> <20110201160245.GA25659@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110201160245.GA25659@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 01, 2011 at 05:02:46PM +0100, Keld J=F8rn Simonsen wrote:
> On Tue, Feb 01, 2011 at 11:01:33AM +0100, David Brown wrote:
> > On 31/01/2011 23:52, Keld J=F8rn Simonsen wrote:
> > >raid1+0 and Linux MD raid10 are similar, but significantly differe=
nt
> > >in a number of ways. Linux MD raid10 can run on only 2 drives.
> > >Linux raid10,f2 has almost RAID0 striping performance in sequentia=
l read.
> > >You can have an odd number of drives in raid10.
> > >And you can have as many copies as you like in raid10,
> > >
> >=20
> > You can make raid10,f2 functionality from raid1+0 by using partitio=
ns.=20
> > For example, to get a raid10,f2 equivalent on two drives, partition=
 them=20
> > into equal halves.  Then make md0 a raid1 mirror of sda1 and sdb2, =
and=20
> > md1 a raid1 mirror of sdb1 and sda2.  Finally, make md2 a raid0 str=
ipe=20
> > set of md0 and md1.
>=20
> I don't think you get the striping performance of raid10,f2 with this
> layout. And that is one of the main advantages of raid10,f2 layout.
> Have you tried it out?
>=20
> As far as I can see the layout of blocks are not alternating between =
the
> disks. You have one raid1 of sda1 and sdb2, there a file is allocated=
 on
> blocks sequentially on sda1 and then mirrored on sdb2, where it is al=
so
> sequentially allocated. That gives no striping.

Well, maybe the RAID0 layer provides the adequate striping.=20
I am noy sure, but it looks like it could hold in theory.
One could try it out.

One advantage of this scheme could be improved probability
When 2 drives fail, eg. in the case of a 4 drive array.
The probability of survival of a running system could then
be enhaced form 33 % to 66 %.

One problem could be the choice of always the lowest block number, whic=
h
is secured in raid10,f2, but not in a raid0 over raid1 (or raid10,n2) s=
cenario.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

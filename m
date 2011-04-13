From: NeilBrown <neilb@suse.de>
Subject: Re: expand raid10
Date: Thu, 14 Apr 2011 09:28:24 +1000
Message-ID: <20110414092824.337d3874@notabene.brown>
References: <BANLkTimFwM0m3jT4mg8ZL4VvSXkbi4pU6g@mail.gmail.com>
	<BANLkTimqdD39TgbghGi3hK4b1gh1FmcmdQ@mail.gmail.com>
	<BANLkTi=udXzNJwK9CKtK1QEqK1PznSp_2g@mail.gmail.com>
	<20110413111015.GA10195@www2.open-std.org>
	<20110413211715.286d9203@notabene.brown>
	<20110413123413.GA10377@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110413123413.GA10377@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?ISO-8859-1?B?Svhybg==?= Simonsen <keld@keldix.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Mathias =?ISO-8859-1?B?QnVy?= =?ISO-8859-1?B?6W4=?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 13 Apr 2011 14:34:14 +0200 Keld J=F8rn Simonsen <keld@keldix.co=
m> wrote:

> On Wed, Apr 13, 2011 at 09:17:15PM +1000, NeilBrown wrote:
> > On Wed, 13 Apr 2011 13:10:16 +0200 Keld J=F8rn Simonsen <keld@keldi=
x.com> wrote:
> >=20
> > > On Wed, Apr 13, 2011 at 07:47:26AM -0300, Roberto Spadim wrote:
> > > > raid10 with other layout i could expand?
> > >=20
> > > My understanding is that you currently cannot expand raid10.
> > > but there are things in the works. Expansion of raid10,far
> > > was not on the list from neil, raid10,near was. But it should be =
fairly
> > > easy to expand raid10,far. You can just treat one of the copies a=
s your
> > > refence data, and copy that data to the other raid0-like parts of=
 the
> > > array.  I wonder if Neil thinks he could leave that as an exersiz=
e for
> > > me to implement... I would like  to be able to combine it with a
> > > reformat to a more robust layout of raid10,far that in some cases=
 can survive more
> > > than one disk failure.
> > >=20
> >=20
> > I'm very happy for anyone to offer to implement anything.
> >=20
> > I will of course require the code to be of reasonable quality befor=
e I accept
> > it, but I'm also happy to give helpful review comments and guidance=
=2E
> >=20
> > So don't wait for permission, if you want to try implementing somet=
hing, just
> > do it.
> >=20
> > Equally if there is something that I particularly want done I won't=
 wait for
> > ever for someone else who says they are working on it.  But RAID10 =
reshape is
> > a long way from the top of my list.
>=20
> Hi Neil!
>=20
> Yes, that is how I understand your policy on contributions.
>=20
> Do you by RAID10 reshaping also mean RAID10 expansion?
> In my eyes this is quite important, and something that I have wanted =
for
> a long time. I think it is a quite common task for many Linux MD user=
s.
>=20
> best regards
> keld


Yes, by 'reshaping' I mean everything included here:

http://neil.brown.name/blog/20110216044002#11

which includes size changes.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

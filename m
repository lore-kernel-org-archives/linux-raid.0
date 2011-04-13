From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: expand raid10
Date: Wed, 13 Apr 2011 14:34:14 +0200
Message-ID: <20110413123413.GA10377@www2.open-std.org>
References: <BANLkTimFwM0m3jT4mg8ZL4VvSXkbi4pU6g@mail.gmail.com> <BANLkTimqdD39TgbghGi3hK4b1gh1FmcmdQ@mail.gmail.com> <BANLkTi=udXzNJwK9CKtK1QEqK1PznSp_2g@mail.gmail.com> <20110413111015.GA10195@www2.open-std.org> <20110413211715.286d9203@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110413211715.286d9203@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Roberto Spadim <roberto@spadim.com.br>, Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 13, 2011 at 09:17:15PM +1000, NeilBrown wrote:
> On Wed, 13 Apr 2011 13:10:16 +0200 Keld J=F8rn Simonsen <keld@keldix.=
com> wrote:
>=20
> > On Wed, Apr 13, 2011 at 07:47:26AM -0300, Roberto Spadim wrote:
> > > raid10 with other layout i could expand?
> >=20
> > My understanding is that you currently cannot expand raid10.
> > but there are things in the works. Expansion of raid10,far
> > was not on the list from neil, raid10,near was. But it should be fa=
irly
> > easy to expand raid10,far. You can just treat one of the copies as =
your
> > refence data, and copy that data to the other raid0-like parts of t=
he
> > array.  I wonder if Neil thinks he could leave that as an exersize =
for
> > me to implement... I would like  to be able to combine it with a
> > reformat to a more robust layout of raid10,far that in some cases c=
an survive more
> > than one disk failure.
> >=20
>=20
> I'm very happy for anyone to offer to implement anything.
>=20
> I will of course require the code to be of reasonable quality before =
I accept
> it, but I'm also happy to give helpful review comments and guidance.
>=20
> So don't wait for permission, if you want to try implementing somethi=
ng, just
> do it.
>=20
> Equally if there is something that I particularly want done I won't w=
ait for
> ever for someone else who says they are working on it.  But RAID10 re=
shape is
> a long way from the top of my list.

Hi Neil!

Yes, that is how I understand your policy on contributions.

Do you by RAID10 reshaping also mean RAID10 expansion?
In my eyes this is quite important, and something that I have wanted fo=
r
a long time. I think it is a quite common task for many Linux MD users.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: NeilBrown <neilb@suse.de>
Subject: Re: expand raid10
Date: Wed, 13 Apr 2011 21:17:15 +1000
Message-ID: <20110413211715.286d9203@notabene.brown>
References: <BANLkTimFwM0m3jT4mg8ZL4VvSXkbi4pU6g@mail.gmail.com>
	<BANLkTimqdD39TgbghGi3hK4b1gh1FmcmdQ@mail.gmail.com>
	<BANLkTi=udXzNJwK9CKtK1QEqK1PznSp_2g@mail.gmail.com>
	<20110413111015.GA10195@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110413111015.GA10195@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?ISO-8859-1?B?Svhybg==?= Simonsen <keld@keldix.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Mathias =?ISO-8859-1?B?QnVy?= =?ISO-8859-1?B?6W4=?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 13 Apr 2011 13:10:16 +0200 Keld J=F8rn Simonsen <keld@keldix.co=
m> wrote:

> On Wed, Apr 13, 2011 at 07:47:26AM -0300, Roberto Spadim wrote:
> > raid10 with other layout i could expand?
>=20
> My understanding is that you currently cannot expand raid10.
> but there are things in the works. Expansion of raid10,far
> was not on the list from neil, raid10,near was. But it should be fair=
ly
> easy to expand raid10,far. You can just treat one of the copies as yo=
ur
> refence data, and copy that data to the other raid0-like parts of the
> array.  I wonder if Neil thinks he could leave that as an exersize fo=
r
> me to implement... I would like  to be able to combine it with a
> reformat to a more robust layout of raid10,far that in some cases can=
 survive more
> than one disk failure.
>=20

I'm very happy for anyone to offer to implement anything.

I will of course require the code to be of reasonable quality before I =
accept
it, but I'm also happy to give helpful review comments and guidance.

So don't wait for permission, if you want to try implementing something=
, just
do it.

Equally if there is something that I particularly want done I won't wai=
t for
ever for someone else who says they are working on it.  But RAID10 resh=
ape is
a long way from the top of my list.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

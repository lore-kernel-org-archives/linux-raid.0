From: NeilBrown <neilb@suse.de>
Subject: Re: expand raid10
Date: Thu, 14 Apr 2011 09:36:57 +1000
Message-ID: <20110414093657.1e848952@notabene.brown>
References: <BANLkTimFwM0m3jT4mg8ZL4VvSXkbi4pU6g@mail.gmail.com>
	<BANLkTimqdD39TgbghGi3hK4b1gh1FmcmdQ@mail.gmail.com>
	<BANLkTi=udXzNJwK9CKtK1QEqK1PznSp_2g@mail.gmail.com>
	<20110413111015.GA10195@www2.open-std.org>
	<20110413211715.286d9203@notabene.brown>
	<io454g$fq3$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <io454g$fq3$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Apr 2011 14:34:15 +0200 David Brown <david@westcontrol.com> =
wrote:

> On 13/04/2011 13:17, NeilBrown wrote:
> > On Wed, 13 Apr 2011 13:10:16 +0200 Keld J=F8rn Simonsen<keld@keldix=
=2Ecom>  wrote:
> >
> >> On Wed, Apr 13, 2011 at 07:47:26AM -0300, Roberto Spadim wrote:
> >>> raid10 with other layout i could expand?
> >>
> >> My understanding is that you currently cannot expand raid10.
> >> but there are things in the works. Expansion of raid10,far
> >> was not on the list from neil, raid10,near was. But it should be f=
airly
> >> easy to expand raid10,far. You can just treat one of the copies as=
 your
> >> refence data, and copy that data to the other raid0-like parts of =
the
> >> array.  I wonder if Neil thinks he could leave that as an exersize=
 for
> >> me to implement... I would like  to be able to combine it with a
> >> reformat to a more robust layout of raid10,far that in some cases =
can survive more
> >> than one disk failure.
> >>
> >
> > I'm very happy for anyone to offer to implement anything.
> >
> > I will of course require the code to be of reasonable quality befor=
e I accept
> > it, but I'm also happy to give helpful review comments and guidance=
=2E
> >
> > So don't wait for permission, if you want to try implementing somet=
hing, just
> > do it.
> >
> > Equally if there is something that I particularly want done I won't=
 wait for
> > ever for someone else who says they are working on it.  But RAID10 =
reshape is
> > a long way from the top of my list.
> >
>=20
> I know you have other exciting things on your to-do list - there was=20
> lots in your roadmap thread a while back.
>=20
> But I'd like to put in a word for raid10,far - it is an excellent cho=
ice=20
> of layout for small or medium systems with a combination of redundanc=
y=20
> and near-raid0 speed.  It is especially ideal for 2 or 3 disk systems=
=2E=20
> The only disadvantage is that it can't be resized or re-shaped.  The=20
> algorithm suggested by Keld sounds simple to implement, but it would=20
> leave the disks in a non-redundant state during the resize/reshape.=20
> That would be good enough for some uses (and better than nothing), bu=
t=20
> not good enough for all uses.  It may also be scalable to include bot=
h=20
> resizing (replacing each disk with a bigger one) and adding another d=
isk=20
> to the array.
>=20
> Currently, it /is/ possible to get an approximate raid10,far layout t=
hat=20
> is resizeable and reshapeable.  You can divide the member disks into =
two=20
> partitions and pair them off appropriately in mirrors.  Then use thes=
e=20
> mirrors to form a degraded raid5 with "parity-last" layout and a miss=
ing=20
> last disk - this is, as far as I can see, equivalent to a raid0 layou=
t=20
> but can be re-shaped to more disks and resized to use bigger disks.
>=20

There is an interesting idea in here....

Currently if the devices in an md/raid array with redundancy (1,4,5,6,1=
0) are
of difference sizes, they are all treated as being the size of the smal=
lest
device.
However this doesn't really make sense for RAID10-far.

=46or RAID10-far, it would make the offset where the second slab of dat=
a
appeared not be 50% of the smallest device (in the far-2 case), but 50%=
 of
the current device.

Then replacing all the devices in a RAID10-far with larger devices woul=
d mean
that the size of the array could then be increased with no further data
rearrangement.

A lot of care would be needed to implement this as the assumption that =
all
drives are only as big as the smallest is pretty deep.  But it could be=
 done
and would be sensible.

That would make point 2 of http://neil.brown.name/blog/20110216044002#1=
1 a
lot simpler.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

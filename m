From: NeilBrown <neilb@suse.de>
Subject: Re: expand raid10
Date: Mon, 18 Apr 2011 10:46:15 +1000
Message-ID: <20110418104615.005d865a@notabene.brown>
References: <BANLkTimFwM0m3jT4mg8ZL4VvSXkbi4pU6g@mail.gmail.com>
	<BANLkTimqdD39TgbghGi3hK4b1gh1FmcmdQ@mail.gmail.com>
	<BANLkTi=udXzNJwK9CKtK1QEqK1PznSp_2g@mail.gmail.com>
	<20110413111015.GA10195@www2.open-std.org>
	<20110413211715.286d9203@notabene.brown>
	<io454g$fq3$1@dough.gmane.org>
	<20110414093657.1e848952@notabene.brown>
	<20110415165203.GA31684@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110415165203.GA31684@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?ISO-8859-1?B?Svhybg==?= Simonsen <keld@keldix.com>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 15 Apr 2011 18:52:03 +0200 Keld J=F8rn Simonsen <keld@keldix.co=
m> wrote:

> On Thu, Apr 14, 2011 at 09:36:57AM +1000, NeilBrown wrote:
> > On Wed, 13 Apr 2011 14:34:15 +0200 David Brown <david@westcontrol.c=
om> wrote:
> >=20
> > > On 13/04/2011 13:17, NeilBrown wrote:
> > > > On Wed, 13 Apr 2011 13:10:16 +0200 Keld J=F8rn Simonsen<keld@ke=
ldix.com>  wrote:
> > > >
> > > >> On Wed, Apr 13, 2011 at 07:47:26AM -0300, Roberto Spadim wrote=
:
> > > >>> raid10 with other layout i could expand?
> > > >>
> > > >> My understanding is that you currently cannot expand raid10.
> > > >> but there are things in the works. Expansion of raid10,far
> > > >> was not on the list from neil, raid10,near was. But it should =
be fairly
> > > >> easy to expand raid10,far. You can just treat one of the copie=
s as your
> > > >> refence data, and copy that data to the other raid0-like parts=
 of the
> > > >> array.  I wonder if Neil thinks he could leave that as an exer=
size for
> > > >> me to implement... I would like  to be able to combine it with=
 a
> > > >> reformat to a more robust layout of raid10,far that in some ca=
ses can survive more
> > > >> than one disk failure.
> > > >>
> > > >
> > > > I'm very happy for anyone to offer to implement anything.
> > > >
> > > > I will of course require the code to be of reasonable quality b=
efore I accept
> > > > it, but I'm also happy to give helpful review comments and guid=
ance.
> > > >
> > > > So don't wait for permission, if you want to try implementing s=
omething, just
> > > > do it.
> > > >
> > > > Equally if there is something that I particularly want done I w=
on't wait for
> > > > ever for someone else who says they are working on it.  But RAI=
D10 reshape is
> > > > a long way from the top of my list.
> > > >
> > >=20
> > > I know you have other exciting things on your to-do list - there =
was=20
> > > lots in your roadmap thread a while back.
> > >=20
> > > But I'd like to put in a word for raid10,far - it is an excellent=
 choice=20
> > > of layout for small or medium systems with a combination of redun=
dancy=20
> > > and near-raid0 speed.  It is especially ideal for 2 or 3 disk sys=
tems.=20
> > > The only disadvantage is that it can't be resized or re-shaped.  =
The=20
> > > algorithm suggested by Keld sounds simple to implement, but it wo=
uld=20
> > > leave the disks in a non-redundant state during the resize/reshap=
e.=20
> > > That would be good enough for some uses (and better than nothing)=
, but=20
> > > not good enough for all uses.  It may also be scalable to include=
 both=20
> > > resizing (replacing each disk with a bigger one) and adding anoth=
er disk=20
> > > to the array.
> > >=20
> > > Currently, it /is/ possible to get an approximate raid10,far layo=
ut that=20
> > > is resizeable and reshapeable.  You can divide the member disks i=
nto two=20
> > > partitions and pair them off appropriately in mirrors.  Then use =
these=20
> > > mirrors to form a degraded raid5 with "parity-last" layout and a =
missing=20
> > > last disk - this is, as far as I can see, equivalent to a raid0 l=
ayout=20
> > > but can be re-shaped to more disks and resized to use bigger disk=
s.
> > >=20
> >=20
> > There is an interesting idea in here....
> >=20
> > Currently if the devices in an md/raid array with redundancy (1,4,5=
,6,10) are
> > of difference sizes, they are all treated as being the size of the =
smallest
> > device.
> > However this doesn't really make sense for RAID10-far.
> >=20
> > For RAID10-far, it would make the offset where the second slab of d=
ata
> > appeared not be 50% of the smallest device (in the far-2 case), but=
 50% of
> > the current device.
> >=20
> > Then replacing all the devices in a RAID10-far with larger devices =
would mean
> > that the size of the array could then be increased with no further =
data
> > rearrangement.
> >=20
> > A lot of care would be needed to implement this as the assumption t=
hat all
> > drives are only as big as the smallest is pretty deep.  But it coul=
d be done
> > and would be sensible.
> >=20
> > That would make point 2 of http://neil.brown.name/blog/201102160440=
02#11 a
> > lot simpler.
>=20
> Hmm, I am not sure I understand. Eg for the simple case of growing a =
2
> disk raid10-far to a 3 disk or 4 disk, how would that be done? I thin=
k
> you need to rewrite the whole array. But I think you also need to do
> that when growing most of the other array types.
>=20
> Quoting point 2 of http://neil.brown.name/blog/20110216044002#11:
>=20
> > 2/ Device size of 'far' arrays cannot be changed easily. Increasing
> > device size of 'far' would require re-laying out a lot of data. We =
would
> > need to record the 'old' and 'new' sizes which metadata doesn't
> > currently allow. If we spent 8 bytes on this we could possibly mana=
ge a
> > 'reverse reshape' style conversion here.
> >=20
> > EDIT: if we stored data on drives a little differently this could b=
e a
> > lot easier. Instead of starting the second slab of data at the same
> > location on all devices, we start it an appropriate fraction into t=
he
> > size of 'this' device, then replacing all devices in a raid10-far w=
ith
> > larger drives would be very effective. However just increasing the =
size
> > of the device (e.g. using LVM) would not work very well=20
>=20
> I am not sure I understand the problem here. Are you saying that ther=
e
> is no room in the metadata to hold info on the reshaping while it is
> processed?=20

No, though adding stuff to the metadata shouldn't be done lightly.

I'm saying that if we layout that RAID10-far data on the device a littl=
e bit
differently, then making a RAID10-far make full use of the devices afte=
r
replacing all the devices becomes very easy.

>=20
> For a simple grow with more partitions of the same size I see problem=
s=20
> in just keeping the old data. I think that would damage the striping
> performance.
The preceding is about increasing the size of individual drives.  That =
is
quite different to adding more drives of the same size.
When you add more drives you certainly have to re-layout all the stripe=
s.
This isn't conceptually difficult - just a lot of reads and writes and =
some
care in writing the code to make it safe and efficient.

>=20
> And I don't understand what is meant with "we start it an appropriate
> fraction" - what fraction would that be? Eg growing from 2 to 3 disks=
?

It doesn't apply to that case.  It only applies to growing the size of
individual disks.  For far2, the fraction would be 1/2.  For far3 it wo=
uld be
1/3.


>=20
> If you want integrity of the data, understood as always having the
> required number of copies available, then you could copy from the end=
 of
> the half  array and then have a pointer that tells whereto the proces=
s
> is completed. There may be some initial problems with consistency, bu=
t
> maybe there is some recovery areas in the new array data that could b=
e
> used for bootstrapping the process - once you are over an initial siz=
e,
> you are not overwriting old data.

Yes.  The 'pointer' would be the 'reshape_position' value in the metada=
ta.
Data before this has been relocated.  Data after this has not...  At le=
ast
that is how RAID5 works.  For RAID10 we might want slightly different r=
anges.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

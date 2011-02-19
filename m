From: NeilBrown <neilb@suse.de>
Subject: Re: External bitmap, questions
Date: Sat, 19 Feb 2011 16:30:18 +1100
Message-ID: <20110219163018.26058ce3@notabene.brown>
References: <AANLkTinb3TvJr_-GPjMhXsyA-zwkf45GRAfpb7+Xio6H@mail.gmail.com>
	<20110219154924.2218c87c@notabene.brown>
	<AANLkTimpQ2=EM97ELX3z4c=Yf6gDp=Ekdn6m+ws6O8rm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimpQ2=EM97ELX3z4c=Yf6gDp=Ekdn6m+ws6O8rm@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 19 Feb 2011 04:55:32 +0000 Mathias Bur=E9n <mathias.buren@gmail=
=2Ecom>
wrote:

> On 19 February 2011 04:49, NeilBrown <neilb@suse.de> wrote:
> > On Sat, 19 Feb 2011 00:47:10 +0000 Mathias Bur=E9n <mathias.buren@g=
mail.com>
> > wrote:
> >
> >> Hi,
> >>
> >> >From the mdadm manual:
> >>
> >> "-b, --bitmap=3D
> >> [...]
> >> Note: external bitmaps are only known to work on ext2 and ext3.
> >> Storing bitmap files on other filesystems may result in serious
> >> problems."
> >>
> >> I was planning to store the external bitmap on an ext4 partition. =
Will
> >> this be a problem, or is the warning there because it hasn't been
> >> tested enough but no problems found?
> >
> > External bitmaps use 'BMAP' to find where the file lives on the dev=
ice and
> > then writes directly to the device - not through the filesystem.
> >
> > So as long as there is no tail-packing to block migration happening=
 it should
> > work fine.
> >
> > I haven't looked inside ext4 but I am fairly confident that externa=
l bitmaps
> > will work properly.
> >
> > NeilBrown
> >
> >
>=20
> Thanks, Neil. Are there any differences between using an internal or
> external bitmap? Also, does one need a bitmap at all when not plannin=
g
> to "mess" with the array? (does it provide any other purpose?)

The difference between internal and external is simply that one is stor=
ed in
the array - a copy on each device - and the other is stored externally =
to the
array  - a single copy in a file.
External are slightly harder to work with as you need somewhere separat=
e to
store the bitmap (it cannot be in the array) and you need to tell mdadm=
 where
to find it (so it needs to be listed in mdadm.conf).

I don't know what you mean by "mess" with the array.  The main purpose =
of the
bitmap is the accelerate resync after an unclean shutdown.  The seconda=
ry
purpose is to accelerate recovery if you remove and then re-add a devic=
e.
Maybe that is what you mean by "mess with".

So if you don't want to "mess" with the array and you are certain that =
your
machine will never crash, then you don't really need a bitmap.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

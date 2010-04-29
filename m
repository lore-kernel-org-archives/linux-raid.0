From: Neil Brown <neilb@suse.de> (by way of Neil Brown <neilb@suse.de>)
Subject: Re: increasing stripe_cache_size decreases RAID-6 read throughput
Date: Thu, 29 Apr 2010 14:34:03 +1000
Message-ID: <20100429143403.44bef7a1@notabene.brown>
References: <h2y11f0870e1004241636z1f3e302g913be494ec0aefa5@mail.gmail.com>
 <20100427164126.2765f9e0@notabene.brown>
 <n2x11f0870e1004271018t742e933tba7e0d37428271f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <n2x11f0870e1004271018t742e933tba7e0d37428271f2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Williams <jwilliams315@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 27 Apr 2010 10:18:36 -0700
Joe Williams <jwilliams315@gmail.com> wrote:

> >
> >
> >> Next question, is it normal for md0 to have no queue_depth setting=
?
> >
> > Yes. =C2=A0The stripe_cache_size is conceptually a similar think, b=
ut only
> > at a very abstract level.
> >
> >>
> >> Are there any other parameters that are important to performance t=
hat
> >> I should be looking at?
> >
>=20
> >> I was expecting a little faster sequential reads, but 191 MB/s is =
not
> >> too bad. I'm not sure why it decreases to 130-131 MB/s at larger
> >> record sizes.
> >
> > I don't know why it would decrease either. =C2=A0For sequential rea=
ds, read-ahead
> > should be scheduling all the read requests and that actual reads sh=
ould just
> > be waiting for the read-ahead to complete. =C2=A0So there shouldn't=
 be any
> > variability - clearly there is. =C2=A0I wonder if it is an XFS thin=
g....
> > care to try a different filesystem for comparison? =C2=A0ext3?
>=20
> I can try ext3. When I run mkfs.ext3, are there any parameters that I
> should set to other than the default values?
>=20

No, the defaults are normally fine.  There might be room for small
improvements through tuning, but for now we are really looking for big
effects.

> >
>=20
> > That is very weird, as reads don't use the stripe cache at all - wh=
en
> > the array is not degraded and no overlapping writes are happening.
> >
> > And the stripe_cache is measured in pages-per-device. =C2=A0So 2560=
 means
> > 2560*4k for each device. There are 3 data devices, so 30720K or 60 =
stripes.
> >
> > When you set stripe_cache_size to 16384, it would have consumed
> > =C2=A016384*5*4K =3D=3D 320Meg
> > or 1/3 of your available RAM. =C2=A0This might have affected throug=
hput,
> > I'm not sure.
>=20
> Ah, thanks for explaining that! I set the stripe cache much larger
> than I intended to. But I am a little confused about your
> calculations. FIrst you multiply 2560 x 4K x 3 data devices to get th=
e
> total stripe_cache_size. But then you multiply 16384 x 4K x 5 devices
> to get the RAM usage. Why multiply time 3 in the first case, and 5 in
> the second? Does the stripe cache only cache data devices, or does it
> cache all the devices in the array?

I multiply by 3 when I'm calculating storage space in the array.
I multiply by 4 when I'm calculating the amount of RAM consumed.

The holds content for each device, whether data or parity.
We do all the parity calculations in the cache, so it has to store ever=
ything.

>=20
> What stripe_cache_size value or values would you suggest I try to
> optimize write throughput?

No idea.  It is dependent on load and hardware characteristics.
Try lots of different numbers and draw a graph.


>=20
> The default setting for stripe_cache_size was 256. So 256 x 4K =3D 10=
24K
> per device, which would be two stripes, I think (you commented to tha=
t
> effect earlier). But somehow the default setting was not optimal for
> sequential write throughput. When I increased stripe_cache_size, the
> sequential write throughput improved. Does that make sense? Why would
> it be necessary to cache more than 2 stripes to get optimal sequentia=
l
> write performance?

The individual devices have some optimal write size - possible one
track or one cylinder (if we pretend those words mean something useful =
these
days).
To be able to fill that you really need that much cache for each device=
=2E
Maybe your drives work best when they are sent 8M (16 stripes, as you s=
ay in
a subsequent email) before expecting the first write to complete..

You say you get about 250MB/sec, so that is about 80MB/sec per drive
(3 drives worth of data).
Rotational speed is what?  10K?  That is 166revs-per-second.
So about 500K per revolution.
I imagine you would need at least 3 revolutions worth of data in the ca=
che,
one that is currently being written, one that is ready to be written ne=
xt
(so the drive knows it can just keep writing) and one that you are in t=
he
process of filling up.
You find that you need about 16 revolutions (it seems to be about one
revolution per stripe).  That is more than I would expect .... maybe th=
ere is
some extra latency somewhere.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Kasper Sandberg <postmaster@metanurb.dk>
Subject: Re: raid10 layout for 2xSSDs
Date: Tue, 17 Nov 2009 16:05:49 +0100
Message-ID: <1258470349.31633.58.camel@localhost>
References: <1258381745.31633.35.camel@localhost>
	 <878we61oev.fsf@frosties.localdomain> <20091116161325.GA22644@rap.rap.dk>
	 <87y6m5lqgs.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y6m5lqgs.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Keld Jorn Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-11-17 at 05:34 +0100, Goswin von Brederlow wrote:
> Keld J=F8rn Simonsen <keld@keldix.com> writes:
>=20
> > On Mon, Nov 16, 2009 at 04:26:32PM +0100, Goswin von Brederlow wrot=
e:
> >> Kasper Sandberg <postmaster@metanurb.dk> writes:
> >>=20
> >> > Hello.
> >> >
> >> > I've been wanting to create a raid10 array of two SSDs, and I am
> >> > currently considering the layout.
> >> >
> >> > As i understand it, near layout is similar to raid1, and will on=
ly
> >> > provide a speedup if theres 2 reads at the same time, not a sing=
le
> >> > sequential read.
> >> >
> >> > so the choice is really between far and offset. As i see it, the
> >> > difference is, that offset tries to reduce the seeking for writi=
ng
> >> > compared to far, but that if you dont consider the seeking penal=
ty,
> >> > average sequential write speed across the entire array should be=
 roughly
> >> > the same with offset and far, with offset perhaps being a tad mo=
re
> >> > "stable", is this a correct assumption? if it is, that would mea=
n offset
> >> > provides a higher "garantueed" speed than far, but with a lower =
maximum
> >> > speed.
> >> >
> >> > mvh.
> >> > Kasper Sandberg
> >>=20
> >> Doesn't offset have the copies of each stripe right next to each o=
ther
> >> (just rotated). So writing one stripe would actualy write a 2 bloc=
k
> >> continous chunk per device.
> >>=20
> >> With far copies the stripes are far from each other and you get 2
> >> seperate continious chunks per device.
> >>=20
> >> What I'm aiming at is that offset might better fit into erase bloc=
ks,
> >> cause less internal fragmentation on the disk and give better wear
> >> leveling. Might improve speed and lifetime. But that is just a
> >> thought. Maybe test and do ask Intel (or other vendors) about it.
> >
> > I think the caching of the file system levies out all of this, if w=
e
> > talk SSD. The presumption on this is that there is no rotational la=
tency
> > with SSD, and that no head movement.=20
>=20
> Filesystem has nothing to do with this. It caches the same for both
> situations. The only change happens on the block layer.
>=20
> > The caching means that for writing, more buffers are chained togeth=
er
> > and can be written at once. For near, logical blocks 1-8
> > can be written to sector 0 of disk 1 in one go, and logical blocks
> > 1-8 can be written to sector 0 of disk 2 in one go.
>=20
> Which is what I was saying.
>=20
> > For far it will be for disk 1: block 1, 3, 5, and 7 to sector 0, an=
d
> > block 2, 4, 6 and 8 to sector n/2 - n being the number of sectors o=
n the
> > diskpartition. For far and disk 2, it will be blocks 2, 4, 6 and 8 =
to
> > sector 0, and blocks 1, 3, 5 and 7 to sector n/2. caching thus redu=
ces
> > seeking significantly, from once per block, to once per flushing of=
 the
> > cache (syncing). Similarily the cache also would almost eliminate
> > seeking for the offset layout.
>=20
> There is no seeking (head movement) and no rotational latency
> involved. That part is completly irelevant.
>=20
> The important part is that you now have 4 IO operations of half the
> size comapred to the 2 IO operations of the offset case. The speed an=
d
> wear will depends on the quality of the SSD, how well it copes with
> small IO.
Very interresting, i have some older SSDs where they are slower when
doing a SMALLER write, so in this case offset should be alot better.

>=20
> > but I would like to see some numbers on this, for SSD.
> > Why don't you try it out and tell us what you find?
>=20
> I would be interested in this myself. I don't have an SSD yet but I'm
> tempted to buy. When you test please also test random access. I would
> guess that in any sequential test the amount of caching going on will
> make all IO operations so big that no difference shows.
>=20
> > Best regards
> > keld
>=20
> MfG
>         Goswin
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

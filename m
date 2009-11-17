From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: raid10 layout for 2xSSDs
Date: Tue, 17 Nov 2009 05:34:11 +0100
Message-ID: <87y6m5lqgs.fsf@frosties.localdomain>
References: <1258381745.31633.35.camel@localhost>
	<878we61oev.fsf@frosties.localdomain>
	<20091116161325.GA22644@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091116161325.GA22644@rap.rap.dk> (Keld Jorn Simonsen's message
	of "Mon, 16 Nov 2009 17:13:25 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Keld Jorn Simonsen <keld@keldix.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Kasper Sandberg <postmaster@metanurb.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen <keld@keldix.com> writes:

> On Mon, Nov 16, 2009 at 04:26:32PM +0100, Goswin von Brederlow wrote:
>> Kasper Sandberg <postmaster@metanurb.dk> writes:
>>=20
>> > Hello.
>> >
>> > I've been wanting to create a raid10 array of two SSDs, and I am
>> > currently considering the layout.
>> >
>> > As i understand it, near layout is similar to raid1, and will only
>> > provide a speedup if theres 2 reads at the same time, not a single
>> > sequential read.
>> >
>> > so the choice is really between far and offset. As i see it, the
>> > difference is, that offset tries to reduce the seeking for writing
>> > compared to far, but that if you dont consider the seeking penalty=
,
>> > average sequential write speed across the entire array should be r=
oughly
>> > the same with offset and far, with offset perhaps being a tad more
>> > "stable", is this a correct assumption? if it is, that would mean =
offset
>> > provides a higher "garantueed" speed than far, but with a lower ma=
ximum
>> > speed.
>> >
>> > mvh.
>> > Kasper Sandberg
>>=20
>> Doesn't offset have the copies of each stripe right next to each oth=
er
>> (just rotated). So writing one stripe would actualy write a 2 block
>> continous chunk per device.
>>=20
>> With far copies the stripes are far from each other and you get 2
>> seperate continious chunks per device.
>>=20
>> What I'm aiming at is that offset might better fit into erase blocks=
,
>> cause less internal fragmentation on the disk and give better wear
>> leveling. Might improve speed and lifetime. But that is just a
>> thought. Maybe test and do ask Intel (or other vendors) about it.
>
> I think the caching of the file system levies out all of this, if we
> talk SSD. The presumption on this is that there is no rotational late=
ncy
> with SSD, and that no head movement.=20

=46ilesystem has nothing to do with this. It caches the same for both
situations. The only change happens on the block layer.

> The caching means that for writing, more buffers are chained together
> and can be written at once. For near, logical blocks 1-8
> can be written to sector 0 of disk 1 in one go, and logical blocks
> 1-8 can be written to sector 0 of disk 2 in one go.

Which is what I was saying.

> For far it will be for disk 1: block 1, 3, 5, and 7 to sector 0, and
> block 2, 4, 6 and 8 to sector n/2 - n being the number of sectors on =
the
> diskpartition. For far and disk 2, it will be blocks 2, 4, 6 and 8 to
> sector 0, and blocks 1, 3, 5 and 7 to sector n/2. caching thus reduce=
s
> seeking significantly, from once per block, to once per flushing of t=
he
> cache (syncing). Similarily the cache also would almost eliminate
> seeking for the offset layout.

There is no seeking (head movement) and no rotational latency
involved. That part is completly irelevant.

The important part is that you now have 4 IO operations of half the
size comapred to the 2 IO operations of the offset case. The speed and
wear will depends on the quality of the SSD, how well it copes with
small IO.

> but I would like to see some numbers on this, for SSD.
> Why don't you try it out and tell us what you find?

I would be interested in this myself. I don't have an SSD yet but I'm
tempted to buy. When you test please also test random access. I would
guess that in any sequential test the amount of caching going on will
make all IO operations so big that no difference shows.

> Best regards
> keld

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

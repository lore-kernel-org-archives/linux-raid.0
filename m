From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: raid10 layout for 2xSSDs
Date: Mon, 16 Nov 2009 17:13:25 +0100
Message-ID: <20091116161325.GA22644@rap.rap.dk>
References: <1258381745.31633.35.camel@localhost> <878we61oev.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878we61oev.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Kasper Sandberg <postmaster@metanurb.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 16, 2009 at 04:26:32PM +0100, Goswin von Brederlow wrote:
> Kasper Sandberg <postmaster@metanurb.dk> writes:
> 
> > Hello.
> >
> > I've been wanting to create a raid10 array of two SSDs, and I am
> > currently considering the layout.
> >
> > As i understand it, near layout is similar to raid1, and will only
> > provide a speedup if theres 2 reads at the same time, not a single
> > sequential read.
> >
> > so the choice is really between far and offset. As i see it, the
> > difference is, that offset tries to reduce the seeking for writing
> > compared to far, but that if you dont consider the seeking penalty,
> > average sequential write speed across the entire array should be roughly
> > the same with offset and far, with offset perhaps being a tad more
> > "stable", is this a correct assumption? if it is, that would mean offset
> > provides a higher "garantueed" speed than far, but with a lower maximum
> > speed.
> >
> > mvh.
> > Kasper Sandberg
> 
> Doesn't offset have the copies of each stripe right next to each other
> (just rotated). So writing one stripe would actualy write a 2 block
> continous chunk per device.
> 
> With far copies the stripes are far from each other and you get 2
> seperate continious chunks per device.
> 
> What I'm aiming at is that offset might better fit into erase blocks,
> cause less internal fragmentation on the disk and give better wear
> leveling. Might improve speed and lifetime. But that is just a
> thought. Maybe test and do ask Intel (or other vendors) about it.

I think the caching of the file system levies out all of this, if we
talk SSD. The presumption on this is that there is no rotational latency
with SSD, and that no head movement. 

The caching means that for writing, more buffers are chained together
and can be written at once. For near, logical blocks 1-8
can be written to sector 0 of disk 1 in one go, and logical blocks
1-8 can be written to sector 0 of disk 2 in one go.
For far it will be for disk 1: block 1, 3, 5, and 7 to sector 0, and
block 2, 4, 6 and 8 to sector n/2 - n being the number of sectors on the
diskpartition. For far and disk 2, it will be blocks 2, 4, 6 and 8 to
sector 0, and blocks 1, 3, 5 and 7 to sector n/2. caching thus reduces
seeking significantly, from once per block, to once per flushing of the
cache (syncing). Similarily the cache also would almost eliminate
seeking for the offset layout.

but I would like to see some numbers on this, for SSD.
Why don't you try it out and tell us what you find?

Best regards
keld


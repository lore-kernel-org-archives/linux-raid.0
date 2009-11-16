From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: raid10 layout for 2xSSDs
Date: Mon, 16 Nov 2009 16:26:32 +0100
Message-ID: <878we61oev.fsf@frosties.localdomain>
References: <1258381745.31633.35.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1258381745.31633.35.camel@localhost> (Kasper Sandberg's message
	of "Mon, 16 Nov 2009 15:29:05 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Kasper Sandberg <postmaster@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kasper Sandberg <postmaster@metanurb.dk> writes:

> Hello.
>
> I've been wanting to create a raid10 array of two SSDs, and I am
> currently considering the layout.
>
> As i understand it, near layout is similar to raid1, and will only
> provide a speedup if theres 2 reads at the same time, not a single
> sequential read.
>
> so the choice is really between far and offset. As i see it, the
> difference is, that offset tries to reduce the seeking for writing
> compared to far, but that if you dont consider the seeking penalty,
> average sequential write speed across the entire array should be roughly
> the same with offset and far, with offset perhaps being a tad more
> "stable", is this a correct assumption? if it is, that would mean offset
> provides a higher "garantueed" speed than far, but with a lower maximum
> speed.
>
> mvh.
> Kasper Sandberg

Doesn't offset have the copies of each stripe right next to each other
(just rotated). So writing one stripe would actualy write a 2 block
continous chunk per device.

With far copies the stripes are far from each other and you get 2
seperate continious chunks per device.

What I'm aiming at is that offset might better fit into erase blocks,
cause less internal fragmentation on the disk and give better wear
leveling. Might improve speed and lifetime. But that is just a
thought. Maybe test and do ask Intel (or other vendors) about it.

MfG
        Goswin

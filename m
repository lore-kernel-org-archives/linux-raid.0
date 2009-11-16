From: Kasper Sandberg <postmaster@metanurb.dk>
Subject: Re: raid10 layout for 2xSSDs
Date: Mon, 16 Nov 2009 22:33:54 +0100
Message-ID: <1258407234.31633.52.camel@localhost>
References: <1258381745.31633.35.camel@localhost>
	 <7bc80d500911160808o4ca4d335gdeeb50fff61b2149@mail.gmail.com>
	 <1258405373.31633.49.camel@localhost>
	 <70ed7c3e0911161319u5d6fd6c7vf9d41fa2da96801b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0911161319u5d6fd6c7vf9d41fa2da96801b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2009-11-17 at 00:19 +0300, Majed B. wrote:
> Wouldn't you be getting the same data twice? or would the kernel
> request the half the data from one disk & the other from the other
> disk? (file1-> chunk1@disk1 & chunk2@disk2, chunk3@disk1 &
> chunk3@disk2)

it will request different chunks from different disks, to speed up

> 
> On Tue, Nov 17, 2009 at 12:02 AM, Kasper Sandberg
> <postmaster@metanurb.dk> wrote:
> >
> > On Mon, 2009-11-16 at 08:08 -0800, Christopher Chen wrote:
> > > On Mon, Nov 16, 2009 at 6:29 AM, Kasper Sandberg <postmaster@metanurb.dk> wrote:
> > > > Hello.
> > > >
> > > > I've been wanting to create a raid10 array of two SSDs, and I am
> > > > currently considering the layout.
> > > >
> > > > As i understand it, near layout is similar to raid1, and will only
> > > > provide a speedup if theres 2 reads at the same time, not a single
> > > > sequential read.
> > > >
> > > > so the choice is really between far and offset. As i see it, the
> > > > difference is, that offset tries to reduce the seeking for writing
> > > > compared to far, but that if you dont consider the seeking penalty,
> > > > average sequential write speed across the entire array should be roughly
> > > > the same with offset and far, with offset perhaps being a tad more
> > > > "stable", is this a correct assumption? if it is, that would mean offset
> > > > provides a higher "garantueed" speed than far, but with a lower maximum
> > > > speed.
> > >
> > > Do you plan to have more than two devices in the array? Raid 10 isn't
> > no
> > > magic. If you don't have more than do devices, I suppose your seek
> > > time might be half for reads (and higher for writes), but you won't be
> > > able to do any striping.
> > >
> > > I'm a bit confused as to the number of people popping in recently
> > > wanting to run raid 10 on two disk "arrays".
> > to get the doubled singlestream sequential read performance..
> > >
> > > cc
> > >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
>       Majed B.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


From: Hans Kristian Rosbach <hk@isphuset.no>
Subject: Re: RAID1 & 2.6.9 performance problem
Date: Tue, 18 Jan 2005 14:18:04 +0100
Message-ID: <1106054284.17481.21.camel@linux.local>
References: <41EBD827.80701@pipi.ma.cx>
	 <Pine.LNX.4.56.0501171528010.21510@lion.drogon.net>
	 <1105977081.15184.12.camel@linux.local>  <6o6tb2-cj2.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6o6tb2-cj2.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2005-01-17 at 17:46, Peter T. Breuer wrote:
> Hans Kristian Rosbach <hk@isphuset.no> wrote:
> > -It selects the disk that is closest to the wanted sector by
remembering
> >  what sector was last requested and what disk was used for it.
> > -For sequential reads (sucha as hdparm) it will override and use the
> >  same disk anyways. (sector = lastsector+1)
> > 
> > I gained a lot of throughput by alternating disk, but seek time was
> > roughly doubled. I also tried to get smart and played some with the
> > code in order to avoid seeking both disks back and forth wildly when
> > there were two sequential reads. I didn't find a good way to do it
> > unfortunately.
> 
> Interesting. How did you measure latency? Do you have a script you
> could post?

It's part of another application we use internally at work. I'll check
to see wether part of it could be GPL'ed or similar.

But it is also logical since for two requests in a row to sector and 
sector +1, it will first seek disk1 and then disk2 when the second 
request arrives. Atleast it was that way with my hack.

I was pondering maybe doing something like a virtual stripe array, such
that the data reads are logically alternated between the functioning
disks. Since it's virtual the block-size and number of disks could be
changed in run-time for speed tweaking or failed disks.

The tweaking of block size could be managed automagically by a userspace
daemon that monitors load patterns and such. A step further would be to
monitor disk-speed, so if a disk is slow it gets less/smaller stripe
segments than the other disks do. This would be ideal for a software
mirror running atop two raid-5 volumes for example, so that if one of
the raid5 volumes is degraded the speed won't fail totally.

> > I'm not going to make any patch available, because I removed
bad-disk
> > checking in order to simplify it.
> 
> The FR1 patch measures disk latency and weights the disk head
distances
> by the measured latency, which may help.  It probably also gets rid of
> that sequential read thing (I haven't done anything but port the patch
> to 2.6, not actually run it in anger!).

Latency measuring is an excellent profile imho, this would probably also
reduce the speed variation when using disks of different types.

I'll take a look at the code, and do some benchmarks when I get time.
It'll probably be this weekend.

>   ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.15b.tgz
> 
> (I am doing a 2.16 with the robust-read patch I suggested added in).

Keep me posted =)

> I really don't think this measuring disk head position can help unless
> raid controls ALL of the disks in question, or the disks are otherwise
> inactive.  Is that your case?

Yep, head position is imho not a factor to be considered at all.

Currently I'm working on a database project that needs all the read
speed I can get. So what i'd like to do is to add for example 8 disks in
a mirror, and hopefully get 4-6x the overall read speed.

-HK



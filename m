From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: RAID10 Performance
Date: Wed, 2 Mar 2011 11:14:09 +0100
Message-ID: <20110302101408.GC20427@www2.open-std.org>
References: <4D6E0813.1070903@cendio.se> <20110302092425.GA4264@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110302092425.GA4264@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Sowry <aaron@cendio.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 02, 2011 at 09:24:25AM +0000, Robin Hill wrote:
> On Wed Mar 02, 2011 at 10:04:19AM +0100, Aaron Sowry wrote:
> 
> > Hello,
> > 
> > I have been testing different RAID configurations on a 2-disk setup, and
> > have a couple of questions regarding performance. The information I have
> > found online so far seems to contradict itself fairly regularly so I was
> > hoping for a more coherent answer :)
> > 
> > 1) As I understand it, a RAID10 'near' configuration using two disks is
> > essentially equivalent to a RAID1 configuration. Is this correct?
> > 
> It should be, yes, though I've not actually sat down and verified this.
> 
> > 2) Does md RAID1 support 'striped' reads? If not, is RAID1 read
> > performance in any way related to the number of disks in the array?
> > 
> No, it doesn't support 'striped' reads (there's no real performance
> advantage to doing so as you'd be losing the time skipping between
> stripes that you'd gain on reading from multiple drives concurrently).
> You do get a performance advantage with multiple drives in that more
> requests can be handled concurrently though.
> 
> > 3) From what I have read so far, a RAID10 'far' configuration on 2 disks
> > provides increased read performance over an equivalent 'near'
> > configuration, however I am struggling to understand exactly why. I
> > understand the difference between the 'near' and 'far' configurations,
> > but not *why* this should provide any speed increases. What am I missing?
> > 
> The speed increase is because the read speed varies across a disk -
> reading from the outer sectors is faster than reading from the inner
> sectors. The 'far' configuration means that all data is available on the
> outer half of the drive, so reads should mostly be served from there.

Also for sequential reads you get something like double the performance,
compared to raid1. This is because the layout of "far" is the same as
raid0, so you get striping performance. 

> > 4) I have performed a(n admittedly fairly basic) benchmark on the same
> > system under two different configurations - RAID10,n2 and RAID10,f2
> > using tiobench with default settings. In short, the results showed a
> > significant speed increase for single-threaded sequential reads (83Mb/s
> > vs 166MB/s), some increase for single-threaded random reads (1.85Mb/s vs
> > 2.25Mb/s), but a decrease for every other metric, including
> > multi-threaded sequential and random reads. I was expecting write
> > performance to decrease under RAID10,f2 compared to RAID10,n2, but am
> > slightly confused about the multi-threaded read performance. Is it my
> > expectations or my testing that needs to be reviewed?
> > 
> I'm not sure about that one - I'd expect multi-threaded reads to be at
> least as good on a "far" layout as a "near", but I've not actually run
> any benchmarks myself.

I would also think multi-threaded sequential reads to be faster with
"far". Especially I would think that an additional sequential read on a
running file system would be much faster than with "near" or raid1. 
That is my experience with the systems I run here.

There are some figures on performance in:
https://raid.wiki.kernel.org/index.php/Performance
That indicates that the multi-threaded random reads are also better, 
in the order of 40 % better that "near", and 125 % better than raid1.
This was on a quite old kernel, but I don't think things have improved
much in this area in the kernel. It would be nice to also have your
numbers on the page.

best regards
keld

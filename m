From: keld@keldix.com
Subject: Re: "Missing" RAID devices
Date: Fri, 24 May 2013 21:22:58 +0200
Message-ID: <20130524192258.GA32547@www5.open-std.org>
References: <519C0B13.3040906@turmel.org> <519D4A15.7020107@hardwarefreak.com> <519D541B.1090508@turmel.org> <519DB04B.5030505@hardwarefreak.com> <20130523083032.GA2579@www5.open-std.org> <519EE274.5030905@hardwarefreak.com> <20130524063228.GB30833@www5.open-std.org> <519F189D.6030103@hardwarefreak.com> <20130524171525.GA25643@www5.open-std.org> <519FBA08.5030208@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519FBA08.5030208@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 24, 2013 at 02:05:44PM -0500, Stan Hoeppner wrote:
> On 5/24/2013 12:15 PM, keld@keldix.com wrote:
> > On Fri, May 24, 2013 at 02:37:01AM -0500, Stan Hoeppner wrote:
> >> On 5/24/2013 1:32 AM, keld@keldix.com wrote:
> >>> On Thu, May 23, 2013 at 10:45:56PM -0500, Stan Hoeppner wrote:
> >>>> On 5/23/2013 3:30 AM, keld@keldix.com wrote:
> >>>>> On Thu, May 23, 2013 at 12:59:39AM -0500, Stan Hoeppner wrote:
> >>>>
> >>>>>> You may be tempted to use md/RAID10 of some layout
> >>>>>> to optimize for writes, but you'd gain nothing, and you'd lose some
> >>>>>> performance due to overhead.  The partitions you'll be using in this
> >>>>>> case are so small that they easily fit in a single physical disk track,
> >>>>>> thus no head movement is required to seek between sectors, only rotation
> >>>>>> of the platter.
> >>>> ...
> >>>>> I think a raid10,far3 is a good choice for swap, then you will enjoy
> >>>>> RAID0-like reading speed. and good write speed (compared to raid6),
> >>>>> and a chance of live surviving if just one drive keeps functioning.
> >>>>
> >>>> As I mention above, none of the md/RAID10 layouts will yield any added
> >>>> performance benefit for swap partitions.  And I state the reason why.
> >>>> If you think about this for a moment you should reach the same conclusion.
> >>>
> >>> I think it is you who are not fully aquainted with Linux MD. Linux 
> >>> MD RAID10,far3 offers improved performance in single read, 
> >>
> >> On most of today's systems, read performance is largely irrelevant WRT
> >> swap performance.  However write performance is critical.  None of the
> >> md/RAID10 layouts are going to increase write throughput over RAID1
> >> pairs.  And all the mirrored RAIDs will be 2x slower than interleaved
> >> swap across direct disk partitions.
> > 
> > In my experience read performance from swap is critical, at least 
> > on single user systems. Eg swapping in firefox  or libreoffice 
> > may take quite some time and there raid10,far helps by almost halfing
> > the time for the swapping in. writes are not important, as long as you are not trashing.
> 
> If a single user system has multiple drives configured in RAID10 and
> productivity applications are being swapped, then the user should be
> smacked in the head.  2GB DIMMs are $10.  Any hard drive is $50+ but
> usually much more.
> 
> This is not a valid argument.

And the cost to select, buy and install RAM is much more than USD 10.
And some systems dont have room for more RAM, etc.

> > In general halfing the swapping in with raid10,far is nice for a process, but 
> > for small processes it is not noticable for a laptop user or a 
> > server user, say http or ftp.
> 
> Neither is this.  Laptop users don't run RAID10.  And server swap
> performance is all about page write, not read, as I previously stated.

Some laptop users and desktop users run raid10. I think all laptop
and desktop users should have at least 2 disks and run mirrorred raid on them.
Both for security and for performance.

Server performance for properly configured servers will benefit from
snappy swap read performance. Write performance of swap would normally 
not be noticable - not a bottleneck.

best regards
keld

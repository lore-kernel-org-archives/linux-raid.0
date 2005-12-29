From: Rik Herrin <rikherrin@yahoo.com>
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports Raid Level Migration and Online Capacity Expansion
Date: Thu, 29 Dec 2005 03:20:11 -0800 (PST)
Message-ID: <20051229112011.18591.qmail@web52904.mail.yahoo.com>
References: <62b0912f0512220431l4d1ec130q137b737c1956ddd9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0512220431l4d1ec130q137b737c1956ddd9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry for taking so long to reply but it's been a
hectic week.  Thanks for your reply.  Out of
curiousity, what is MD's linear personality or DM? 
Would this affect performance if I expanded my RAID
using this?

--- Molle Bestefich <molle.bestefich@gmail.com> wrote:

> Rik Herrin wrote:
> > I was interested in Linux's RAID capabilities and
> > read that mdadm was the tool of choice.  We are
> > currently comparing software RAID with hardware
> RAID
> 
> MD is far superior to most of the hardware RAID
> solutions I've touched.
> In short, it seems MD is developed with the goal of
> keeping your data
> safe, not selling hardware.
> 
> I've had problems both with MD and with hardware
> RAID.  With hardware
> RAID, once things go bad, they really go bad.  With
> MD, there's
> usually a straight-forward way to rescue things. 
> And when there's
> not, Neil's a real nice guy who always stands up to
> help and fix bugs.
> 
> I would trust my data with MD over any hardware RAID
> solution,
> including professional server RAID solutions from
> eg. Compaq or IBM.
> 
> MD is a little more difficult to set up and also
> lacks in that it
> doesn't integrate with BIOS level stuff and boot
> loaders (maybe
> there's minimal MD RAID 1 support in Lilo, not
> sure).  Depending on
> your choice of hardware, you might also get more
> features than MD can
> currently offer.
> 
> > 	1) OCE: Online Capacity Expansion:  From the
> latest
> > version of mdadm (v2.2), it ssems that there is
> > support for it with the -G option.  How well
> tested is
> > this?
> 
> New feature, so obviously not tested very well.
> 
> Neil said at one point that he was going to release
> this to the
> general public when it's stable and when it can
> recover an interrupted
> resize process.  Sounds like a very reasonable and
> sane goal to me, I
> hope that this is still the case.
> 
> Otherwise, it's easy to work around - you can just
> create a new RAID
> array on your new disks / extra disk space and then
> join it to the end
> of the old array using MD's linear personality or
> DM.  Never tried it,
> but should work just fine.
> 
> >  Also, in the Readme / Man page, it mentions:
> > 		This usage causes mdadm to attempt to
> reconfigure a
> > running array.  This is only possibly if the
> kernel
> > being used supports a particular reconfiguration.
> > 	How can I know if the kernel I am using supports
> this
> > reconfiguration?  What if I'm compiling the kernel
> by
> > hand.  What options would I have to enable?
> 
> Just the usual MD stuff I think.
> You'll probably need a quite new kernel where Neil's
> bitmap patches
> has been applied.
> Hopefully MD will detect whether the kernel is new
> enough or not, but
> I haven't tried myself ;-).
> 
> > 	2) RAID Level Migration:  Does mdadm currently
> > support this feature?
> 
> I don't think so, but sounds like RAID5 --> RAID6 is
> planned.
> Check back in a year or so ;-).
> 
> Or choose the RAID level you *really* want to begin
> with (duh).
> 
> Since you say "we", I assume you're part of a very
> large corporation
> and thus intend to RAID a whole bunch of disks.  Go
> with RAID6 + a
> couple of spares for that.  If you intend to use
> really many disks,
> make multiple arrays.  (Not sure whether you can
> share spares across
> arrays, but I think you can.)
> 
> > 	3) Performance issues:  I'm currently thinking of
> > using either RAID 10 or LVM2 with RAID 5 to serve
> as a
> > RAID server.  The machine will be running either
> an
> > AMD 64 processor or a dual-core AMD 64 processor,
> so I
> > don't think the CPU will be a bottleneck.  In
> fact, it
> > should easily pass the speed of most "hardware"
> based
> > RAID systems.
> 
> I think there's two issues to cover,
>  * Throughput
>  * Seek times
> 
> And of course they're not entirely separate issues -
> throughput will
> be lower when you're doing random access (seeking)
> and seek times will
> be higher when you're pulling lots of data out.
> 
> I've seen lots of MD tests, but none that covered
> profiling MD's
> random access performance.  So I suppose that most
> hardware solutions
> will do a lot better than MD here since they have
> been profiled with
> this in mind.
> 
> Throughput-wise, I think MD is probably very good.
> But I can't back that up with factual data, sorry.
> 
> > 	4) Would anyone recommend a certain hotswap
> > enclosure?
> 
> I would, but can't remember their name, sorry :-)
> 



	
		
__________________________________ 
Yahoo! for Good - Make a difference this year. 
http://brand.yahoo.com/cybergivingweek2005/

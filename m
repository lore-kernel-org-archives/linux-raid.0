From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: poor performance with raid1 / raid0
Date: Wed, 18 Jun 2003 10:59:59 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EF07E6F.FF55F908@SteelEye.com>
References: <PERBUMSGID-ul6fzm7tvl3.fsf@ipchains.linpro.no>		<1055943743.31927.20.camel@cinshrlnxws01.shermfin.com> <PERBUMSGID-ul63ci7trhw.fsf@ipchains.linpro.no> <3EF079A9.9FB561AF@SteelEye.com> <3EF07C9C.7070802@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Farkas Levente <lfarkas@bnap.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Farkas Levente wrote:
> 
> Paul Clements wrote:
> > Per Andreas Buer wrote:
> >
> >>Andrew Rechenberg <arechenberg@shermfin.com> writes:
> >>
> >>
> >>>Check /proc/sys/dev/raid/speed_limit_[min|max].  If they are set too low
> >>>then your re-mirror will behave as such.  To change just echo a new
> >>>value:
> >>>
> >>>echo 30000 > /proc/sys/dev/raid/speed_limit_min
> >>>echo 50000 > /proc/sys/dev/raid/speed_limit_max
> >>>
> >>
> >>I did so - and now:
> >>
> >>md6 : active raid1 md16[2] sdd6[0]
> >>      117185984 blocks [2/1] [U_]
> >>      [>....................]  recovery =  0.1% (229120/117185984)
> >>finish=59.5min speed=32731K/sec
> >
> >
> > That's probably because you just lowered the values. The maximum is
> > normally 100000. To check what the default values are, reboot and do:
> >
> > cat /proc/sys/dev/raid/speed_limit_*
> >
> > Then echo a _larger_ number into those files.
> >
> > There is no absolute maximum value (except maybe 2^32), so don't be
> > afraid to raise the values to 10 or 100 times what they were. That
> > should ensure that your resync speed is close to its theoretical
> > maximum.
> 
> can someone tell me what these numbers means?

I think I posted something a week or two ago that explained what these
are...


> of course my goal (as everyones) to achieve the maximum possible
> performance.

Well, this is a trade-off, that's precisely why these values are
tunables. 

These tunables govern the _resync_ speed of a raid1/5 array. They do not
control the regular I/O throughput. So what you generally want to do is
to set these values as high as possible without there being an impact on
normal I/O (or for that matter, system responsiveness on the whole)
during a resync.


> can I do any harm if I set these numbers to high?

Yes, the system might become sluggish or your regular I/O throughput to
the device might become very slow during resyncs if these values are too
high.

--
Paul

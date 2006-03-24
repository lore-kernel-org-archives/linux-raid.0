From: Alex Izvorski <aizvorski@gmail.com>
Subject: Re: raid5 that used parity for reads only when degraded
Date: Fri, 24 Mar 2006 15:16:32 -0800
Message-ID: <1143242192.8573.79.camel@starfire>
References: <loom.20060323T003324-767@post.gmane.org>
	 <17441.59458.918847.175664@cse.unsw.edu.au>
	 <1143175107.7404.88.camel@starfire>
	 <Pine.LNX.4.64.0603240907020.20234@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0603240907020.20234@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2006-03-24 at 09:19 -0800, dean gaudet wrote:
> On Thu, 23 Mar 2006, Alex Izvorski wrote:
> 
> > Also the cpu load is measured with Andrew Morton's cyclesoak
> > tool which I believe to be quite accurate.
> 
> there's something cyclesoak does which i'm not sure i agree with: 
> cyclesoak process dirties an array of 1000000 bytes... so what you're 
> really getting is some sort of composite measurement of memory system 
> utilisation and cpu cycle availability.
> 
> i think that 1MB number was chosen before 1MiB caches were common... and 
> what you get during calibration is a L2 cache-hot loop, but i'm not sure 
> that's an important number.
> 
> i'd look at what happens if you increase cyclesoak.c busyloop_size to 8MB 
> ... and decrease it to 128.  the two extremes are going to weight the "cpu 
> load" towards measuring available memory system bandwidth and available 
> cpu cycles.
> 
> also for calibration consider using a larger "-p n" ... especially if 
> you've got any cpufreq/powernowd setup which is varying your clock 
> rates... you want to be sure that it's calibrated (and measured) at a 
> fixed clock rate.
> 
> -dean

Dean - those are interesting ideas.  I tried them out, but they do not
appear to make much difference:  the measured load with busyloop_size of
128, 1M and 8M is the same within a couple of percent.  As far as I can
determine busyloop spends most of its time in the "for (thumb = 0; thumb
< twiddle; thumb++)" loop, and only touches about 150MB memory per
second (2.3M loops/sec, one cacheline or 64 bytes affected per loop).  I
don't have cpufreq so that's not a factor.  So far everything leads me
to believe that what cyclesoak reports is quite accurate.  I've even
confirmed it by timing other cpu-bound tasks (like compressing a file in
memory) and the results are essentially identical.

Regards,
--Alex



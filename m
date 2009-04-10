From: jim owens <jowens@hp.com>
Subject: Re: RAID halting
Date: Fri, 10 Apr 2009 08:50:05 -0400
Message-ID: <49DF407D.1080900@hp.com>
References: <20090410045146.TNPB12747.cdptpa-omta01.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090410045146.TNPB12747.cdptpa-omta01.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Leslie Rhorer wrote:
>>>  for f in /sys/block/*/queue/scheduler; do
>>>     echo noop > $f
>>>     echo $f "$(cat $f)"
>>>   done
>> OK, I did this.  Two questions:
> 
> It doesn't seem to have helped or hindered.  I still get halts, but under
> moderate loads not every time.
> 
>>> Leslie: I still think finding out what the kernel is doing during the
>>> stall would be a HUGE hint to the problem. Did you look into oprofile or
>>> ftrace?
>> I couldn't find a Debian source for ftrace, but I did download oprofile.
> 
> Something very disturbing is happening now, however.  Just a few minutes
> after loading oprofile, the system did a sudden total shutdown.  The file
> systems were all left dirty, and power was suddenly cut to the main chassis.
> This has never happened before.  I rebooted the system, and the file systems
> replayed their journals.  Some data was lost, of course, but nothing
> serious.  A few hours later, the exact same thing happened again:  A sudden
> shut-down.  Nothing like this has ever happened before.  Of course the
> system can issue a power shutdown from software, but it is supposed to clean
> up the file systems first, and it's not supposed to just do it autonomously.

There are some problems with oprofile on recent kernels and
various hardware platforms.  From the discussions I have seen,
it appears to be conflicts between the platform interrupt
handlers that manage things like power events and the CPU
performance counter non-maskable interrupts that are triggered
by oprofile.  The result is the system goes boom.

Your platform/distro is not where this was reported, but what
is happening to you sounds like the same problem.

Two approaches have been tried to work around this:

1) disable those platform management drivers.
2) run oprofile using the kernel clock (1000hz) to collect
    events instead of the hardware counters.

Since it is only very recently that the cause of this problem
was identified (and I was not really paying attention), I don't
know how successful either work around is or when fixes might
be available.

jim

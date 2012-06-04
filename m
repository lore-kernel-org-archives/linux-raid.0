From: Andy Smith <andy@strugglers.net>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Mon, 4 Jun 2012 00:02:34 +0000
Message-ID: <20120604000234.GO3867@bitfolk.com>
References: <20120531083158.GE3867@bitfolk.com>
 <4FC81B85.8090807@hardwarefreak.com>
 <20120601192524.GH3867@bitfolk.com>
 <4FC9A8D4.9060803@hardwarefreak.com>
 <20120603033042.GI3867@bitfolk.com>
 <4FCB08F3.1050703@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FCB08F3.1050703@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Stan,

Thanks for your detailed reply.

On Sun, Jun 03, 2012 at 01:49:23AM -0500, Stan Hoeppner wrote:
> On 6/2/2012 10:30 PM, Andy Smith wrote:
> > md0 is mounted as /boot
> > md1 is used as swap
> > md2 is mounted as /
> 
> What's the RAID level of each of these and how many partitions in each?

$ cat /proc/mdstat
Personalities : [raid1] [raid10]
md3 : active raid10 sdd5[0] sdb5[3] sdc5[2] sda5[1]
      581022592 blocks 64K chunks 2 near-copies [4/4] [UUUU]

md2 : active raid10 sdd3[0] sdb3[3] sdc3[2] sda3[1]
      1959680 blocks 64K chunks 2 near-copies [4/4] [UUUU]

md1 : active raid10 sdd2[0] sdb2[3] sdc2[2] sda2[1]
      1959680 blocks 64K chunks 2 near-copies [4/4] [UUUU]

md0 : active raid1 sdd1[0] sdb1[3] sdc1[2] sda1[1]
      489856 blocks [4/4] [UUUU]

unused devices: <none>

> > Even though it was a guest that was attacked, the hypervisor still
> > had to route the traffic through its userspace and its CPU got
> > overwhelmed by the high packets-per-second.
> 
> How many cores in this machine and what frequency?

It is a single quad core Xeon L5420 @ 2.50GHz.

> > would I not just have got I/O errors on the single md device that
> > everything was running from, causing instant crash?
> 
> Can you post the SCSI/ATA and md errors?

Sure. I posted an excerpt in the first email but here is a fuller
example:

Actually it's pretty big so I've put it at
http://paste.ubuntu.com/1022219/

At this point the logs stop because /var is an LV out of md3. I'm
moving remote syslog servers further up my priority list...

If there hadn't been a DDoS attack at the exact same time then
I'd have considered this purely hardware failure due to the way that
"mptscsih: ioc0: attempting task abort! (sc=ffff8800352d80c0)" is
the absolute first thing of interest. But the timing is too
coincidental.

It's also been fine since, including a quite IO-intensive backup job
and yesterday's "first Sunday of the month" sync_action.

> > Unfortunately my monitoring of IOPS for this host cut out during the
> > attack and later problems so all I have for that period is a blank
> > graph, but I don't think the IOPS requirement would actually have
> > been that high. 
> 
> What was actually being written to md3 during this attack?  Just
> logging, or something else?

All the VMs would have been doing their normal writing of course,
but on the hypervisor host /usr and /var come from md3. From the
logs, the main thing it seems to be having problems with is dm-1
which is the /usr LV.

> What was the exact nature of the DDOS attack?  What service was it
> targeting?  I assume this wasn't simply a ping flood.

It was a UDP short packet (78 bytes) multiple source single
destination flood, ~300Mbit/s but the killer was the ~600kpps. Less
than 10Mbit/s made it through to the VM it was targeting.

> > The CPU was certainly overwhelmed, but my main concern is that I
> > am never going to be able to design a system that will cope with
> > routing DDoS traffic in userspace.
> 
> Assuming the network data rate of the attack was less than 1000 Mb/s,
> most any machine with two or more 2GHz+ cores and sufficient RAM should
> easily be able to handle this type of thing without falling over.

I really don't think it is easy to spec a decent VM host that can
also route hundreds of thousands of packets per sec to guests,
without a large budget. I am OK with the host giving up, I just
don't want it to corrupt its storage.

I mean I'm sure it can be done, but the budget probably doesn't
allow it and temporary problems for all VMs on the host are
acceptable in this case; filesystem corruption isn't.

> Can you provide system hardware details?

My original email:

> > Controller: LSISAS1068E B3, FwRev=011a0000h
> > Motherboard: Supermicro X7DCL-3
> > Disks: 4x SEAGATE  ST9300603SS      Version: 0006

Network: e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2

The hypervisor itself has access to only 1GB RAM (the rest dedicated
to guest VMs) which may be rather low; I could look at boosting
that.

The other thing is that the hypervisor and all VM guests share the
same four CPU cores. It may be prudent to dedicate one CPU core to
the hypervisor and then let the guests share the other three.

Any other hardware details that might be relevant?

> > I am OK with the hypervisor machine being completely hammered and
> > keeling over until the traffic is blocked upstream on real routers.
> > Not so happy about the hypervisor machine kicking devices out of
> > arrays and ending up with corrupted filesystems though. I haven't
> > experienced that before.
> 
> Well, you also hadn't experienced an attack like this before.  Correct?

No, they happen from time to time and I find that a pretty big one
will cripple the host but I haven't yet seen that cause storage
problems. But as I say, all the other servers are 3ware+BBU.

To be honest I do find I get a better price/performance spot out of
3ware setup; this host represented an experiment with 10kRPM SAS
drives and software RAID a few years ago and whilst the performance
is decent, the much higher cost per GB of the SAS drives ultimately
makes this uneconomical for me, as I do have to provide a certain
storage capacity as well.

So I haven't gone with md RAID for this use case for a couple of
years now and am unlikely to do so in the future anyway. I do still
need to work out what to do with this particular server though.

> Consider this.  If the hypervisor was writing heavily to logs, and if
> the hypervisor went into heavy swap during the attack, and the
> partitions in md3 that were kicked reside on disks where the swap array
> and/or / arrays exist, this would tend to bolster my theory regarding
> seek starvation causing the timeouts and kicks.

I have a feeling it was trying to swap a lot from the repeated
mentions of "swapper" in the logs. The swap partition is md1 which
doesn't feature in any of the logs, but perhaps what is being logged
there is the swapper kernel thread being unable to do anything
because of extreme CPU starvation.

> Or, if this is truly a single CPU/core machine, the core was pegged, and
> the hypervisor kernel scheduler wasn't giving enough time to md threads,
> this may also explain the timeouts, though with any remotely recent
> kernel this 'shouldn't' happen under load.

Admittedly this is an old Debian lenny server running 2.6.26-2-xen
kernel. Pushing ahead the timescale of clearing VMs off of it and
doing an upgrade would probably be a good idea.

Although it isn't exactly the hardware setup I would like it's been
a pretty good machine for a few years now so I would rather not junk
it, if I can reassure myself that this won't happen again.

> > Also still wondering if what I did to recover was the best way to go
> > or if I could have made it easier on myself.
> 
> I don't really have any input on this aspect, except to say that if you
> got all your data recovered that's the important part.  If you spent
> twice as long as you needed to I wouldn't sweat that at all.  I'd put
> all my concentration on the root cause analysis.

Sure, though this was a completely new experience for me so if
anyone has any tips for better recovery then that will help should I
ever face anything like it again. I do use md RAID in quite a few
places (just not much for this use).

Notably, the server was only recoverable because I had backups of
/usr and /var. There were some essential files corrupted but being
able to get them from backups saved having to do a rebuild.

Actually corruption of VM block devices was quite minimal -- many of
them just had to replay the journal and clean up a handful of
orphaned inodes. Apparently a couple of them did lose a small number
of files but these VMs are all run by different admins and I don't
have great insight into it.

Anything I could have done to lessen that would have been useful.
They're meant to have backups but meh, human nature...

Cheers,
Andy

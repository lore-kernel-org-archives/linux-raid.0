From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Mon, 04 Jun 2012 01:58:16 -0500
Message-ID: <4FCC5C88.9050107@hardwarefreak.com>
References: <20120531083158.GE3867@bitfolk.com> <4FC81B85.8090807@hardwarefreak.com> <20120601192524.GH3867@bitfolk.com> <4FC9A8D4.9060803@hardwarefreak.com> <20120603033042.GI3867@bitfolk.com> <4FCB08F3.1050703@hardwarefreak.com> <20120604000234.GO3867@bitfolk.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120604000234.GO3867@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/3/2012 7:02 PM, Andy Smith wrote:
> Hi Stan,
> 
> Thanks for your detailed reply.

Welcome.  More detailed reply and question follow.

> $ cat /proc/mdstat
> Personalities : [raid1] [raid10]
> md3 : active raid10 sdd5[0] sdb5[3] sdc5[2] sda5[1]
>       581022592 blocks 64K chunks 2 near-copies [4/4] [UUUU]
> 
> md2 : active raid10 sdd3[0] sdb3[3] sdc3[2] sda3[1]
>       1959680 blocks 64K chunks 2 near-copies [4/4] [UUUU]
> 
> md1 : active raid10 sdd2[0] sdb2[3] sdc2[2] sda2[1]
>       1959680 blocks 64K chunks 2 near-copies [4/4] [UUUU]
> 
> md0 : active raid1 sdd1[0] sdb1[3] sdc1[2] sda1[1]
>       489856 blocks [4/4] [UUUU]
> 
> unused devices: <none>

You laid it out nicely, but again, not good practice to have this many
md arrays on the same disks.

> It is a single quad core Xeon L5420 @ 2.50GHz.

Ok, now that's interesting.

> Actually it's pretty big so I've put it at
> http://paste.ubuntu.com/1022219/

Ok, found the source of the mptscsi problem, not hardware failure.  Note
you're using:

Pid: 0, comm: swapper Not tainted 2.6.26-2-xen-amd64 #1

2.6.26 is so old its bones are turning to dust.  Note this Red Hat bug,
and the fact this is an upstream LSI driver problem:

https://bugzilla.redhat.com/show_bug.cgi?id=483424

This driver issue is well over 3 years old and has since been fixed.  It
exists in isolation of your DDOS attack.  And it is probably not the
cause of the partitions being kicked.  Most likely cause is CPU soft
lockup for 60, 90, 120 seconds.  To fix both of these, upgrade to a
kernel that's not rotting in the grave, something in the 3.x.x stable
series is best, and the most recent version of Xen.  Better yet, switch
to KVM as it's in mainline and better supported.

> At this point the logs stop because /var is an LV out of md3. I'm
> moving remote syslog servers further up my priority list...

Yes, good idea.  Even in absence of this mess.

> If there hadn't been a DDoS attack at the exact same time then
> I'd have considered this purely hardware failure due to the way that
> "mptscsih: ioc0: attempting task abort! (sc=ffff8800352d80c0)" is
> the absolute first thing of interest. But the timing is too
> coincidental.

Not hardware failure, note above LSI driver bug.

> It's also been fine since, including a quite IO-intensive backup job
> and yesterday's "first Sunday of the month" sync_action.

Check your logs for these mptscsi errors for the past month.  You should
see some even with zero load on the system, according to the bug report.

> All the VMs would have been doing their normal writing of course,
> but on the hypervisor host /usr and /var come from md3. From the

I wouldn't have laid it out like that.  I'm sure you're thinking the
same thing about now.

> logs, the main thing it seems to be having problems with is dm-1
> which is the /usr LV.

What was the hypervisor kernel writing to /usr during the attack?  Seems
to me it should have been writing nothing there, but just to /var/log.

>> What was the exact nature of the DDOS attack?  What service was it
>> targeting?  I assume this wasn't simply a ping flood.
> 
> It was a UDP short packet (78 bytes) multiple source single
> destination flood, ~300Mbit/s but the killer was the ~600kpps. Less
> than 10Mbit/s made it through to the VM it was targeting.

What, precisely, was it targeting?  What service was listening on the
UDP port that was attacked?  You still haven't named the UDP port.
Anything important?  Can you simply disable that service?  If it's only
used legitimately by local hosts, drop packets originating outside the
local network.

>>> The CPU was certainly overwhelmed, but my main concern is that I
>>> am never going to be able to design a system that will cope with
>>> routing DDoS traffic in userspace.

Why would you want to?  Kill it before it reaches that user space.

> I really don't think it is easy to spec a decent VM host that can
> also route hundreds of thousands of packets per sec to guests,
> without a large budget. 

Again, why would you even attempt this?  Kill it upstream before it
reaches the physical network interface.

> I am OK with the host giving up, I just
> don't want it to corrupt its storage.

The solution, again, isn't beefing up the VM host machine, but hardening
the kernel against DDOS, and more importantly, getting the upstream FW
squared away so it drops all these DDOS packets on the floor.

> I mean I'm sure it can be done, but the budget probably doesn't
> allow it and temporary problems for all VMs on the host are
> acceptable in this case; filesystem corruption isn't.

There are many articles easily found via Google explaining how to harden
a Linux machine against DDOS attacks.  None of them say anything about
beefing up the hardware in an effort to ABSORB the attack.  What you
need is a better upstream firewall, or an intelligent firewall running
in the hypervisor kernel, or both.

> The other thing is that the hypervisor and all VM guests share the
> same four CPU cores. It may be prudent to dedicate one CPU core to
> the hypervisor and then let the guests share the other three.

If you do that the host may simply fail more quickly, but still with damage.

> No, they happen from time to time and I find that a pretty big one
> will cripple the host but I haven't yet seen that cause storage
> problems. But as I say, all the other servers are 3ware+BBU.

Why are DDOS attack frequent there?  Are you a VPS provider?

> To be honest I do find I get a better price/performance spot out of
> 3ware setup; this host represented an experiment with 10kRPM SAS
> drives and software RAID a few years ago and whilst the performance
> is decent, the much higher cost per GB of the SAS drives ultimately
> makes this uneconomical for me, as I do have to provide a certain
> storage capacity as well.

But for your current investment in HBA RAID boards, and with limited
knowledge of your operation, it's sounding like you may be a good
candidate for a low cost midrange iSCSI SAN array.  Use a single 20GB
Intel SSD to boot the hypervisor and serve swap, etc, then mount iSCSI
LUNs for each VM with the hypervisor software initiator.  Yields much
more flexibility in storage provisioning that HBA RAID w/local disks.

You should be able to acquire a single controller Nexsan SATABoy w/2GB
BBWC, dual GbE iSCSI ports (and dual 4Gb FC ports), and 14x 2TB 7.2k
SATA drives for less than $15k.  Using RAID6 easily gets you near line
rate throughput (370MB/s), and gives you 24TB of space to slice into 256
virtual drives.  You'd want to do multipathing, so you would do up to
254 virtual drives, exporting each one as a LUN on each iSCSI port.  You
can size each virtual drive per the needs of the VM.  Creating and
deleting virtual drives is a few mouse clicks in the excellent web gui.
 This is the cheapest array in Nexsan's lineup.  The next step up the
Nexsan ladder gets you a single controller E18 with 18x 3TB drives in 2U
for a little over $20K.  A single RAID6 yields 48TB to slice up.  The
E18 allows expansion with a 60 drive 4U enclosure, up to 234TB total.
You're probably looking at the $50K neighborhood for the expansion
chassis loaded w/3TB drives.

> So I haven't gone with md RAID for this use case for a couple of
> years now and am unlikely to do so in the future anyway. I do still
> need to work out what to do with this particular server though.

Slap in a 3ware 9750-4i and write cache battery and redeploy.
http://www.newegg.com/Product/Product.aspx?Item=N82E16816116109
http://www.newegg.com/Product/Product.aspx?Item=N82E16816118118

W/512MB BBWC and those 10K SAS drives it will perform very well, better
than md and the current HBA WRT writes.

> I have a feeling it was trying to swap a lot from the repeated
> mentions of "swapper" in the logs. The swap partition is md1 which
> doesn't feature in any of the logs, but perhaps what is being logged
> there is the swapper kernel thread being unable to do anything
> because of extreme CPU starvation.

Makes sense.

> Admittedly this is an old Debian lenny server running 2.6.26-2-xen
> kernel. Pushing ahead the timescale of clearing VMs off of it and
> doing an upgrade would probably be a good idea.

Heheh, yeah, as I mentioned here way up above.  This Lenny kernel was
afflicted by the aforementioned LSI bug.  And there were plenty of other
issues with 2.6.26.

> Although it isn't exactly the hardware setup I would like it's been
> a pretty good machine for a few years now so I would rather not junk
> it, if I can reassure myself that this won't happen again.

You will probably suffer again if DDOSed.  And as I mentioned the
solution has little to do with (lack of) machine horsepower.  A modern
kernel will help out considerably.  But, you probably still need to
configure it against DDOS.  Lots of articles/guides available @Google
search.  Without knowing all the technicals of your attack, I can't say
for sure what kernel options would help.

A relatively simple solution you may want to consider is implementing a
daemon to monitor interface traffic in the hypervisor.  If/when the
packet/bit rate clearly shows signs of [D]DOS, run a script that
executes ifdown to take that interface offline and email you an alert
through the management interface (I assume you have both).  You may want
to automatically bring the interface back up after 5 minutes or so.  If
DDOS traffic still exists, down the interface again.  Rinse repeat until
the storm passes.  Your VMs will be non functional during an attack
anyway so there's no harm in downing the interface.  And doing so should
save your bacon.

> Sure, though this was a completely new experience for me so if
> anyone has any tips for better recovery then that will help should I
> ever face anything like it again. I do use md RAID in quite a few
> places (just not much for this use).
> 
> Notably, the server was only recoverable because I had backups of
> /usr and /var. There were some essential files corrupted but being
> able to get them from backups saved having to do a rebuild.

This is refreshing.  Too many times folks post that they MUST get their
md array or XFS filesystem back because they have no backup.  Neil, and
some of the XFS devs, save the day sometimes, but just as often md and
XFS superblocks are completely corrupted or overwritten with zeros,
making recovery impossible, and very unhappy users.

> Actually corruption of VM block devices was quite minimal -- many of
> them just had to replay the journal and clean up a handful of
> orphaned inodes. Apparently a couple of them did lose a small number
> of files but these VMs are all run by different admins and I don't
> have great insight into it.

I take it no two partitions in the same mirror pair were kicked, downing
the array?  I don't recall that you stated you actually lost the md3
array.  Sorry if you did.  Long thread, lots of words to get lost.

> Anything I could have done to lessen that would have been useful.
> They're meant to have backups but meh, human nature...

Well, yea, but it still sucks to do restores, and backups aren't always
bulletproof.

At this point I think your best bet is automated ifdown/ifup.  It's
simple, effective, should be somewhat cheap to implement.  It can all be
done in a daemonized perl script.  Just don't ask me to write it.  ;)
If I had the skill I'd have already done it.

Hope I've been of at least some help to you Andy, given you some decent
ideas, if not solid solutions.  I must say this is the most unique
troubleshooting thread I can recall on linux-raid.

-- 
Stan

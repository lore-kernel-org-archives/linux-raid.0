From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Sun, 03 Jun 2012 01:49:23 -0500
Message-ID: <4FCB08F3.1050703@hardwarefreak.com>
References: <20120531083158.GE3867@bitfolk.com> <4FC81B85.8090807@hardwarefreak.com> <20120601192524.GH3867@bitfolk.com> <4FC9A8D4.9060803@hardwarefreak.com> <20120603033042.GI3867@bitfolk.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120603033042.GI3867@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/2/2012 10:30 PM, Andy Smith wrote:
> Hi Stan,

Hay Andy,

> On Sat, Jun 02, 2012 at 12:47:00AM -0500, Stan Hoeppner wrote:
>> You could still use md RAID in your scenario.  But instead of having
>> multiple md arrays built of disk partitions and passing each array up to
>> a VM guest, the proper way to do this thin provisioning is to create one
>> md array and then create partitions on top.  Then pass a partition to a
>> guest.
> 
> I probably didn't give enough details. On this particular host there
> are four md arrays:

Yeah, I made some incorrect assumptions about how you were using your
arrays.

> md0 is mounted as /boot
> md1 is used as swap
> md2 is mounted as /

What's the RAID level of each of these and how many partitions in each?

> md3 is an LVM PV for "everything else"

This one is the RAID 10 correct?

> Some further filesystems on the hypervisor host come from LVs in md3
> (/usr, /var and so on).
> 
> VM guests get their block devices from LVs in md3. But we can ignore
> the presence of VMs for now since my concern is only with the
> hypervisor host itself at this point.
> 
> Even though it was a guest that was attacked, the hypervisor still
> had to route the traffic through its userspace and its CPU got
> overwhelmed by the high packets-per-second.

How many cores in this machine and what frequency?

> You made a point that multiple mdadm arrays should not be used,
> though in this situation I can't see how that would have helped me;

As I mentioned, the disks would have likely been seeking less, but I
can't say for sure with the available data.  If the disks were seek
saturated this could explain why md3 component partitions were kicked.

> would I not just have got I/O errors on the single md device that
> everything was running from, causing instant crash?

Can you post the SCSI/ATA and md errors?

> Although an instant crash might have been preferable from the point of
> view of enabling less corruption, I suppose.
> 
>> The same situation can occur on a single OS bare metal host when the
>> storage system isn't designed to handle the IOPS load.
> 
> Unfortunately my monitoring of IOPS for this host cut out during the
> attack and later problems so all I have for that period is a blank
> graph, but I don't think the IOPS requirement would actually have
> been that high. 

What was actually being written to md3 during this attack?  Just
logging, or something else?  What was the exact nature of the DDOS
attack?  What service was it targeting?  I assume this wasn't simply a
ping flood.

> The CPU was certainly overwhelmed, but my main
> concern is that I am never going to be able to design a system that
> will cope with routing DDoS traffic in userspace.

Assuming the network data rate of the attack was less than 1000 Mb/s,
most any machine with two or more 2GHz+ cores and sufficient RAM should
easily be able to handle this type of thing without falling over.

Can you provide system hardware details?

> I am OK with the hypervisor machine being completely hammered and
> keeling over until the traffic is blocked upstream on real routers.
> Not so happy about the hypervisor machine kicking devices out of
> arrays and ending up with corrupted filesystems though. I haven't
> experienced that before.

Well, you also hadn't experienced an attack like this before.  Correct?

> I don't think md is to blame as such because the logs show I/O
> errors on all devices so no wonder it kicked them out. I was just
> wondering if it was down to bad hardware, bad hardware _choice_, a
> bug in the driver, some bug in the kernel or what.

This is impossible to determine with the information provided so far.
md isn't to blame, but the way you're using it may have played a role in
the partitions being kicked.

Consider this.  If the hypervisor was writing heavily to logs, and if
the hypervisor went into heavy swap during the attack, and the
partitions in md3 that were kicked reside on disks where the swap array
and/or / arrays exist, this would tend to bolster my theory regarding
seek starvation causing the timeouts and kicks.

If this isn't the case, and you simply had high load hammering md3 and
the underlying disks, with little IO on the other arrays, then the
problem likely lay elsewhere, possibly with the disks themselves, the
HBA, or even the system board.

Or, if this is truly a single CPU/core machine, the core was pegged, and
the hypervisor kernel scheduler wasn't giving enough time to md threads,
this may also explain the timeouts, though with any remotely recent
kernel this 'shouldn't' happen under load.

If the problem was indeed simply a hammered single core CPU, I'd suggest
swapping it for a multi-core model.  This will eliminate the possibility
of md threads starving for cycles, though I wouldn't think this alone
would cause 30 second BIO timeouts, and thus devices being kicked.  It's
far more likely the drives were seek saturated, which would explain the
30 second BIO timeouts.

> Also still wondering if what I did to recover was the best way to go
> or if I could have made it easier on myself.

I don't really have any input on this aspect, except to say that if you
got all your data recovered that's the important part.  If you spent
twice as long as you needed to I wouldn't sweat that at all.  I'd put
all my concentration on the root cause analysis.

-- 
Stan

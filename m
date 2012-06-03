From: Andy Smith <andy@strugglers.net>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Sun, 3 Jun 2012 03:30:42 +0000
Message-ID: <20120603033042.GI3867@bitfolk.com>
References: <20120531083158.GE3867@bitfolk.com>
 <4FC81B85.8090807@hardwarefreak.com>
 <20120601192524.GH3867@bitfolk.com>
 <4FC9A8D4.9060803@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FC9A8D4.9060803@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Stan,

On Sat, Jun 02, 2012 at 12:47:00AM -0500, Stan Hoeppner wrote:
> You could still use md RAID in your scenario.  But instead of having
> multiple md arrays built of disk partitions and passing each array up to
> a VM guest, the proper way to do this thin provisioning is to create one
> md array and then create partitions on top.  Then pass a partition to a
> guest.

I probably didn't give enough details. On this particular host there
are four md arrays:

md0 is mounted as /boot
md1 is used as swap
md2 is mounted as /
md3 is an LVM PV for "everything else"

Some further filesystems on the hypervisor host come from LVs in md3
(/usr, /var and so on).

VM guests get their block devices from LVs in md3. But we can ignore
the presence of VMs for now since my concern is only with the
hypervisor host itself at this point.

Even though it was a guest that was attacked, the hypervisor still
had to route the traffic through its userspace and its CPU got
overwhelmed by the high packets-per-second.

You made a point that multiple mdadm arrays should not be used,
though in this situation I can't see how that would have helped me;
would I not just have got I/O errors on the single md device that
everything was running from, causing instant crash?

Although an instant crash might have been preferable from the point of
view of enabling less corruption, I suppose.

> The same situation can occur on a single OS bare metal host when the
> storage system isn't designed to handle the IOPS load.

Unfortunately my monitoring of IOPS for this host cut out during the
attack and later problems so all I have for that period is a blank
graph, but I don't think the IOPS requirement would actually have
been that high. The CPU was certainly overwhelmed, but my main
concern is that I am never going to be able to design a system that
will cope with routing DDoS traffic in userspace.

I am OK with the hypervisor machine being completely hammered and
keeling over until the traffic is blocked upstream on real routers.
Not so happy about the hypervisor machine kicking devices out of
arrays and ending up with corrupted filesystems though. I haven't
experienced that before.

I don't think md is to blame as such because the logs show I/O
errors on all devices so no wonder it kicked them out. I was just
wondering if it was down to bad hardware, bad hardware _choice_, a
bug in the driver, some bug in the kernel or what.

Also still wondering if what I did to recover was the best way to go
or if I could have made it easier on myself.

Cheers,
Andy

From: Troy Cauble <troycauble@gmail.com>
Subject: Re: Can't boot with drive pulled from RAID-1 /home (was: problem
	growing raid-1)
Date: Mon, 2 Feb 2009 23:55:05 -0500
Message-ID: <6d344ffd0902022055v214a26f7xc6a7f6bdd1d36228@mail.gmail.com>
References: <6d344ffd0902011418k4eaf1a10sc58358f289f1d5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d344ffd0902011418k4eaf1a10sc58358f289f1d5c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 1, 2009 at 5:18 PM, Troy Cauble <troycauble@gmail.com> wrote:

> Why doesn't my system boot when I pull a drive that's
> part of the the RAID-1 /home?
>
> Recent history:
> I discovered a couple of weeks ago that I had been running
> this RAID degraded for an unknown amount of time.  So it
> could boot and run degraded then.
> I did a (fail, add, remove) pattern and was up and running.
>
> Later, I figured out that my partition types for the raid drives
> shouldn't be 83 and I changed them to 0xDA with fdisk.  I
> did this while the raid was mounted, if it matters.
>
> NOW I find out that if I shutdown, pull a disk and boot, I get
> dropped into a repair shell with:
>
> fsck.ext3: Unable to resolve 'UUID=806153bf-6917-440d-ae48-553418cfbbeb'
>
>  which is the UUID of the raid filesystem.
>
> But when I put the drive back in and reboot, and everything is fine.


I discovered that my problem was a known Ubuntu Hardy bug/feature:
https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/259145

triggered by this udev rule:

    # This file causes block devices with Linux RAID (mdadm) signatures to
    # automatically cause mdadm to be run.
    # See udev(8) for syntax

     SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="linux_raid*", \
	RUN+="watershed /sbin/mdadm --assemble --scan --no-degraded"


My earlier (mis-)configured partition type 83 raid didn't trigger this
assembly failure, but the re-configured type 0xDA raid did.

The only question is, if udev wasn't assembling the earlier raid,
what was?

Thanks all,
-troy

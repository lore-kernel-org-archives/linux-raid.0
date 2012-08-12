From: Jake Thomas <thomasj10@georgefox.edu>
Subject: Re: Device Unusable At Startup
Date: Sun, 12 Aug 2012 15:17:09 -0700
Message-ID: <CACO8vio9vg_E9bwV6E0KdK43jg26_VBg0KC-YO5S4TSr7DoJuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

CC to linux-raid mailing list:

Hi Neil!

   Sorry for the delayed response. I kept checking on my iPhone for a
response, and for some reason or lack thereof didn't see it. I figured
that I'd have to wait a few days for my post to go through. I started
checking over here everyday and never got a response:
http://marc.info/?l=linux-raid&m=134415164808677&w=2 . I guess I
neglected this blog. And I was out camping for a few days.

   When I do "sudo /sbin/mdadm.moved -D /dev/md127" after startup
(before it's working), it says:

mdadm: md device /dev/md127 does not appear to be active.

(I now moved /sbin/mdadm.moved back to /sbin/mdadm for ease of use.)

When I do "sudo mdadm --misc --query /dev/md127", I get:

/dev/md127: is an md device which is not active


I found out that I can do:

"sudo mdadm -R /dev/md127" and that starts it up just fine and
everything is good again. (Don't have to stop it or anything.)

I can then do:
sudo mdadm /dev/md127 -a /dev/ram0.

However, the problem still remains that it is not started on start-up,
thus I cannot have /usr be such a raid device, which needs to be
mounted very early in startup, before any scripts get ran. Therefore I
can't just put "mdadm -R /dev/md127" in a script somewhere to fix the
issue. I even tried the raid=autodetect option at the kernel
parameters line (And yes, "mdadm_udev" was in the HOOKS line in
mkinitcpio.conf and "md_mod" and "raid0" were in the MODULES line in
mkinitcpio.conf when I built the initial ramdisk with mkinitcpio.)
I also tried doing "md=1,/dev/sda2" at the kernel line, which was
ignored, because /dev/md1 was not created. Instead, I got the regular
/dev/md127 (which is not active). Also tried "md=1,/dev/sda2,missing".
Same result. Also tried "md=1,/dev/sda2,/dev/ram0". Same result. Also
tried "md=1,/dev/ram0,/dev/sda2". Same result. Also tried
"md=1,missing,/dev/sda2". Same result.
I also tried  md-mod.start_dirty_degraded=1. Still wasn't active on startup.

After running the above two commands (before the kernel parameters
paragraph) to get the raid device going, "sudo mdadm -D /dev/md127"
gives:
/dev/md127:
        Version : 1.2
  Creation Time : Wed Aug  1 19:33:20 2012
     Raid Level : raid1
     Array Size : 3144692 (3.00 GiB 3.22 GB)
  Used Dev Size : 3144692 (3.00 GiB 3.22 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sun Aug 12 13:39:56 2012
          State : clean, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

 Rebuild Status : 9% complete

           Name : archbang:0
           UUID : 31f0bda6:4cd69924:46a0e3b2:4f7e32ba
         Events : 166

    Number   Major   Minor   RaidDevice State
       2       1        0        0      spare rebuilding   /dev/ram0
       1       8        2        1      active sync writemostly   /dev/sda2


Also, when I first startup, if I do:
sudo mdadm --manage /dev/md127 --remove /dev/sda2

I get:
mdadm: cannot get array info for /dev/md127

And if I do:
sudo mdadm --manage /dev/md* --remove /dev/sda2

I get:
mdadm: Must give one of -a/-r/-f for subsequent devices at /dev/md127

What's going on with the above two command outputs?


I will put a copy of this reply here:
http://marc.info/?l=linux-raid&m=134415164808677&w=2

For those of you looking at the linux-raid mailing list, I am coming
from here: http://neil.brown.name/blog/20120615073245 .

The idea of RAID1ing with a ramdisk came from
here:https://bbs.archlinux.org/viewtopic.php?pid=493773#p493773 .

Cheers,
Jake

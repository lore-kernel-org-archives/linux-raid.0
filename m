From: Vegard Haugland <vegard@haugland.at>
Subject: Help with assembling a stopped array
Date: Wed, 13 Jul 2016 03:23:01 +0200
Message-ID: <CANz1=TGr3_ayX-CxcjsBx6Q0Ggh5PXp1STmqHW1XuMS8GGE7Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have a raid6 setup (called /dev/md4) with 10 harddrives, ranged from
sda to sdj.

One of my drives fell out recently, /dev/sde3/ (not entirely sure how
this happened), but I readded it as /dev/sdk3, and the array started
rebuilding. This went on for several hours, and it hit 60% completed
around 8 hours ago.

However, a few hours after that, I lost both /dev/sdg3 and /dev/sdh3 -
and the array stopped completely. My OS was also running on that
array, so my entire system freezed forcing me to reboot.

I've now booted into busybox and md tells me that it cannot reassemble
the array as it can only find 7 out of 10 good drives..

I then read the instructions on
https://raid.wiki.kernel.org/index.php/RAID_Recovery, I started using
mdadm --examine and found that 8 out of 10 drives has identical event
counters. The two that deviates from this is /dev/sdg3 and /dev/sdh3.
I'm not entirely sure if the disk symbolic names are still the same,
so I further assume that the 8/10 drives that are still good are the
ones that were running OK before any of this started happening.

As such, I try forcing a reassemble using mdadm -A /dev/md4 --force.
When I now run mdadm -D /md4, it lists one device as spare (even
though my array does not use any spares) - and I guess this is the
main reason the array doesn't start. Can anyone confirm this, or am i
missing something?

Also, if I try setting the spare as failed by running mdadm -f
/dev/md4 /dev/sde3, I get "no such device" (as recalled from human
memory). Removing it works (mdadm -r /dev/md4 /dev/sde3), but every
time I reassemble, it gets the "spare" tag. I also tried reassemble
with force, but the same happened..

The initrd on this computer does not have networking unfortunately, so
I cannot attach any output from any logs.

If you agree with my summary so far, what should be my next action? Is
there anything left to try before running mdadm create (with level 6
and 2 missing drives)?

Best regards,
Vegard Haugland

-- 
Vegard Haugland <vegard@haugland.at>
Mob. +47 976 68 262
Web: www.v3gard.com | foto.haugland.at

If you want to send me encrypted email, my public GPG key is located
at http://v3gard.com/files/gpg.pub

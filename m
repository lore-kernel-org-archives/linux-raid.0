From: Nix <nix@esperi.org.uk>
Subject: mdadm --misc --readonly -> ENODEV indefinitely
Date: Sun, 28 May 2017 11:43:41 +0100
Message-ID: <87y3th2rdu.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I was trying to flip on the RAID journal now I'd fully populated my
array and cut over to it. So, from early userspace, I did

   # first line done by initramfs scripting
   /sbin/mdadm --assemble --scan --auto=md --freeze-reshape
   mdadm --misc --readonly /dev/md/fast
   mdadm --manage /dev/md/fast --add-journal /dev/ssd1
   mdadm --misc --readwrite /dev/md/fast

This did not work as planned, or indeed at all. After the first
--readonly, all requests for /dev/md/fast report "No such device or
address" until a reboot, though /proc/mdstat says the thing is still
there and /sys/block/md125/dev reports no change in major/minor numbers.
(I don't have udev in my early-userspace environment, but mdev reports
no change, either.)

It's a bit hard to do anything else after that, like, say, turn the
journal on.

... maybe an mdadm --assemble --scan --auto=md --readonly in one go
would work better, rather than starting with the default (?read-mostly?)
and flipping it? I'll give that a try later.

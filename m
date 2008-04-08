From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Re-assembling a software RAID in which device names have changed.
Date: Tue, 08 Apr 2008 21:25:10 +0400
Message-ID: <47FBAA76.20008@msgid.tls.msk.ru>
References: <fa037c550804072134w59f0f280g3d86ed76a99a271e@mail.gmail.com>
Reply-To: linux-raid <linux-raid@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa037c550804072134w59f0f280g3d86ed76a99a271e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Sean H." <silverwraithii@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sean H. wrote:
> To preface, I'm a fairly new Linux user, and have little experience
> with RAID. I've taken this question several places and have yet to get
> an answer which solves my problem, so I figured I'd come to the
> experts.
> 
> I have a five-disk RAID 5, and one of the disks is failing. Every few
> days it'll start buzzing, and will continue buzzing until the drive is
> forced to spin down and back up, by either a restart or suspending to
> RAM.
> 
>  Now, today, I wanted to determine which disk was failing, so I
> unmounted my array and unplugged drives - Specifically, three. The
> third was the culprit, and I plugged the drives back in and rebooted.
> 
>  The gift, or in this case, curse of my motherboard is that it
> supports hot-swapping of SATA drives. So the drives didn't just
> disappear inside the OS and reappear after a reboot. They disappeared
> and re-appeared in the OS with incorrect /dev/sd* locations, and then
> I rebooted.
> 
>  I was unable to boot until I removed the line detailing the array
> from my fstab. Now, when I manually 'mdadm --assemble /dev/md0' mdadm
> finds the two untouched drives, then stops and tells me that they're
> not enough to start the array.
> 
>  So... How can I reassemble the array without knowing what order the
> drives are in?

Don't list individual component devices in mdadm.conf.
Use array UUIDs instead.

I.e., instead of:

--- WRONG ---
ARRAY /dev/md1 devices=/dev/sda1,/dev/sdb1,/dev/sdc1
--- WRONG ---

use this:

--- RIGHT ---
ARRAY /dev/md1 UUID=11111111:22222222:33333333:44444444
--- RIGHT ---

Or use modern ways to assemble the arrays - such as homehost
(requires version 1 superblock).

In either case mdadm will find the relevant components (assuming
DEVICE line in mdadm.conf is correct) and figure out the right
order.

/mjt

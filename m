From: Jason Keltz <jas@cse.yorku.ca>
Subject: MD component device renaming with udev and MD on full disk
Date: Fri, 21 Nov 2014 16:42:15 -0500
Message-ID: <546FB1B7.3050304@cse.yorku.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

I have two questions about MD..

1) I've written a udev rule to remap /dev/sdX devices on my system to 
/dev/cXeYsZpA (controller, enclosure, slot, partition) mapping. When I 
reboot the system, I see that all the devices in /dev are appropriately 
renamed.  If I look at /proc/mdstat, it still has the kernel names of 
the devices (/dev/sdX) even though those devices no longer exist.  If I 
do an mdadm --detail /dev/mdX the system reports the proper device name 
makeup.  I manually failed a device, and I got the correct device name 
in the email.  I'm just wondering what command I would execute to make 
/proc/mdstat update the devices in its output?

2) Unrelated to 1) -- the argument re: using MD on full devices versus 
partitions has been around for a long time.  I've been experimenting 
with using it on full devices.  One of the arguments that I've read for 
not using full devices is that apparently, if you have two devices that 
are identical, but one of them is slightly smaller than the other due to 
say, bad sectors, then these disks can't be used together in one MD 
because they are different sizes. I'm wondering how valid that argument 
is?  Surely it would make sense if MD was using full devices for it to 
actually stop short of the end of the disk for situations like these...

Thanks for any help you can provide.

Jason.

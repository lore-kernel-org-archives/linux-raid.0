From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: mdadm --add Device or resource busy error and multiple drives
	"failing" on RAID 6 at once
Date: Fri, 16 Jul 2010 04:54:30 -0700
Message-ID: <AANLkTikx_L6R0839o-MWu2CscFEdhlSf65a2cGTPl1Ex@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I am using Ubuntu Jaunty (9.04) 64-bit with mdadm 2.6.9 on a whitebox
server with 8GB RAM and dual Xeon quad-core CPUs. I have a RAID 6
consisting of 12 drives all located in the same enclosure, using the
1.2 superblock. For some reason, mdadm seems to "kick out" numerous
drives out of the array at once (sometimes 5 or more). This results in
a degraded state. I've tried replacing the cabling, SAS controller to
which the drives are connected, and even updating the drive firmware
but mdadm still seems to do this on occasion (like once a week). I am
highly doubting all these drives are failing at once. Any further
ideas on what might be causing this issue?

Also, when I attempt to add the kicked out drives (their partitions)
back in using mdadm --add -f (to force it to clear the failed flag), I
often get a "Device or resource busy error". Is there any way around
this error, without rebooting the machine? If I reboot the machine,
then I can easily using the -add -f command, but I would rather not
reboot.

I welcome your ideas. Thank you for your guidance!

-Steve S

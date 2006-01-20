From: Bill Cizek <cizek@rcn.com>
Subject: Re: Followup: Adding a device to an active RAID1 array
Date: Thu, 19 Jan 2006 19:30:22 -0600
Message-ID: <43D03D2E.3000504@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil Brown wrote:

 >On Wednesday January 18, cizek@rcn.com wrote:
 >
 >>Hi,
 >>
 >>Are there any known issues with changing the number of active devices in
 >>a RAID1 array?
 >
 >
 >There is now, thanks.
 >
 >>I'm trying to add a third mirror to an existing RAID1 array of two disks.
 >>
 >>I have /dev/md5 as a mirrored pair of two 40 GB disks.  Directly on top
 >>of it is a 40 GB XFS filesystem.
 >>
 >>When I do "mdadm --grow /dev/md5 -n 3" the count of devices changes from
 >>2 to 3, as expected.
 >>If the XFS filesystem is mounted, the array size changes to 3.0 GB.
 >>If it is not mounted everything works fine.
 >>
 >>Is this supposed to work, is it required that the array be inactive to
 >>add a disk, or am I just doing
 >>something stupid?
 >
 >
 >It is supposed to work, it doesn't, but it is the code doing something
 >stupid, not you.
 >Try the patch below.
 >

[snip]

The patch you gave me worked, Neil, but the I ran into an odd problem where
 the change is lost after a reboot.

I have raid1 devices for both superblocks 0.90.? and 1.0
If I update the superblock 1.0 device,  mdadm --detail shows the update, 
but if I reboot it is lost.
As well, evms complains about a mismatch between the kernel and disk 
(this is how I first noticed it).
Superblock 0.90 works fine.

i.e.  Starting with /dev/md4, superblock 1.0 with 2 devices:

mdadm --detail /dev/md4 shows

   Raid Devices : 2
Active Devices : 2


I do "mdadm --grow /dev/md4 -n3"

mdadm --detail /dev/md4 shows

   Raid Devices : 3
Active Devices : 2

I reboot....

mdadm --detail /dev/md4 shows

   Raid Devices : 2
Active Devices : 2

Hope this makes sense.

Thanks,
-Bill



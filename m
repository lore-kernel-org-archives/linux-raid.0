From: Bill Cizek <cizek@rcn.com>
Subject: Adding a device to an active RAID1 array
Date: Wed, 18 Jan 2006 12:58:36 -0600
Message-ID: <43CE8FDC.4020501@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

Are there any known issues with changing the number of active devices in 
a RAID1 array?

I'm trying to add a third mirror to an existing RAID1 array of two disks.

I have /dev/md5 as a mirrored pair of two 40 GB disks.  Directly on top 
of it is a 40 GB XFS filesystem.

When I do "mdadm --grow /dev/md5 -n 3" the count of devices changes from 
2 to 3, as expected.
If the XFS filesystem is mounted, the array size changes to 3.0 GB.
If it is not mounted everything works fine.

Is this supposed to work, is it required that the array be inactive to 
add a disk, or am I just doing
something stupid?

If there is a better forum for this question, please direct me there.
In any case TIA for any help.

-Bill




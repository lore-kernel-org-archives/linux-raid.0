From: Bill Cizek <cizek@rcn.com>
Subject: RAID1 Array corruption when adding an extra device with mdadm
Date: Fri, 13 Jan 2006 10:36:23 -0600
Message-ID: <43C7D707.5040903@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I've got a system running 2.6.14.6 with a raid1 array of 2 disks.

The size of the array is as follows (from mdadm --detail):
     Raid Level : raid1
     Array Size : 28314496 (27.00 GiB 28.99 GB)
    Device Size : 28314496 (27.00 GiB 28.99 GB)
   Raid Devices : 2
  Total Devices : 2

I'm trying to add an extra disk to make a three-way mirror using mdadm:

mdadm --grow /dev/md0 -n 3

When I do this, the disk gets added (so there are 3 raid devices) --BUT--
also, the Array Size changes to 3.0 GB.  If I immediately reboot, things 
end up ok,
but if I let it run it destroys the array contents.

This happened under mdadm v2.1 and 2.2. I hacked mdadm to print out what 
it's doing,
and things look ok in Manage_resize() until the mdu_array_info_t 
structure is updated using
ioctl (SET_ARRAY_INFO), then the above mentioned size change happens.

Does anyone know what's up with this?

Thanks,
-Bill






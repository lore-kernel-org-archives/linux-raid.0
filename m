From: Colin McCabe <Colin.P.McCabe@gmail.com>
Subject: Re: Fwd: Identify SATA Disks
Date: Thu, 24 May 2007 11:53:15 -0400
Message-ID: <4655B4EB.5050102@gmail.com>
References: <8c4e120705230023v71a2ffa3p182f1e02ccb9cd54@mail.gmail.com> <8c4e120705231629q727718f2yb0704ff33b7012c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8c4e120705231629q727718f2yb0704ff33b7012c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

lewis shobbrook wrote:
> Hi All,
> I'm wondering if anyone has discovered any nice tricks to assist in
> identification of hdd devices.
> I have an 8 bay hotswap array, pretty lights and have been wondering
> what others out there might be doing to determine which disk in an
> array is which.
> 
> I've noted that device allocation can change with the generation of
> new initrd's and installation of new kernels; i.e. /dev/sdc becomes
> /dev/sda depending upon what order the modules load etc.
> I'm wondering if one could send a looped read/write task to a swap
> partition or something to determine which the device is?
> 

The device UUID in the RAID superblock doesn't change across a reboot.

If you run mdadm --examine on the disk, you should see something like
[root@ss-110 root]# mdadm --examine /dev/sda
/dev/sda:
           Magic : a92b4efc
         Version : 01
     Feature Map : 0x0
      Array UUID : eab59421:6ddd9761:05e6ca46:d2342b03
            Name : 408088ETX1:single
   Creation Time : Mon Dec  4 21:25:55 2006
      Raid Level : raid1
    Raid Devices : 2

     Device Size : 117210096 (55.89 GiB 60.01 GB)
      Array Size : 117187500 (55.88 GiB 60.00 GB)
       Used Size : 117187500 (55.88 GiB 60.00 GB)
    Super Offset : 117210224 sectors
           State : active
==>Device UUID : 06795ada:d2fb18a1:2e7de09f:af66a7e3 <==

     Update Time : Thu May 24 11:49:21 2007
        Checksum : 7a695b9f - correct
          Events : 4346975

That number should always uniquely identify your disks.

Maybe even a better way is to run:
[root@ss-110 root]# smartctl -d ata /dev/sda -i
smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     FUJITSU MHV2060BH
====> Serial Number:    NW02T6826LM5 <====
Firmware Version: 00000028
User Capacity:    60,011,642,880 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 4a
Local Time is:    Thu May 24 11:51:16 2007 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

That serial number never changes, even if you wipe the disk.

Colin

> Cheers,
> 
> Lew


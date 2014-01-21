From: Phil Turmel <philip@turmel.org>
Subject: Re: request help with RAID1 array that endlessly attempts to sync
Date: Tue, 21 Jan 2014 08:23:31 -0500
Message-ID: <52DE74D3.10706@turmel.org>
References: <20131217065028.GC20941@nx5.priv> <20131217165348.GA5070@localhost.localdomain> <52B09027.5090605@turmel.org> <20131217192637.GB5070@localhost.localdomain> <52B0A956.7030501@turmel.org> <20131218034556.GA9457@localhost.localdomain> <52B19045.5010102@turmel.org> <20140121063808.GA27520@ssh2.neuro.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121063808.GA27520@ssh2.neuro.berkeley.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Julie Ashworth <ashworth@berkeley.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Julie,

On 01/21/2014 01:38 AM, Julie Ashworth wrote:
> On 18-12-2013 07.08 -0500, Phil Turmel wrote:
>> I'd let the sync continue until it fails or completes.  And if it
>> completes, exercise the array to see if it stays flaky.  If it does not
>> complete, start swapping parts in the system.
> ---end quoted text---
> 
> I'm responding to an old thread, but current problem. I started a RAID1 rebuild in mid-December, and it's still running - now with 2712 read errors - and counting. (I enclosed smartctl output).

The smartctl report says the drive is relatively healthy (3 total
relocations after 30,000 hours of operation).  That implies all of your
read errors are transient.  Or it is the other drive?  (Show the other
drive's smartctl output, too, perhaps.)

> # cat /proc/mdstat
> Personalities : [raid1] 
> md0 : active raid1 sda1[0] sdb1[1]
>       521984 blocks [2/2] [UU]
>       
> md1 : active raid1 sda2[2] sdb2[1]
>       976237824 blocks [2/1] [_U]
>       [==============>......]  recovery = 70.9% (692700480/976237824) finish=68.5min speed=68956K/sec

I would *not* disturb the rebuild (yet).  You have a better option.

> md0 is a boot partition, and md1 is the operating system. 
> I configured LVM on md1, and allocated 68GB (of 1TB): 
> 
> # vgdisplay /dev/VolGroup00
>   VG Name               VolGroup00
>   VG Size               931.00 GB
>   Alloc PE / Size       2176 / 68.00 GB
>   Free  PE / Size       27616 / 863.00 GB
>  
> Currently, only ~5GB of the 1TB disk is used.
> 
> At this point, what is my best option for limiting downtime of the server (i.e. avoiding a rebuild)? 
> I added a drive (/dev/sdc) with identical geometry, and consider using dd, i.e.
> 
> # dd if=/dev/sdb of=/dev/sdc bs=4096 conv=sync,noerror

No, this would also duplicate the raid metadata, confusing MD if you had
an unexpected reboot in the middle.

> This may not be the most efficient method of transferring data, since .5% of the disk is used. But obviously, I'm not in a hurry.

No hurry is good, as I suggest you take advantage of LVM to establish a
new raid under your volume group.  This can be done on the fly, but
involves several steps.

> Please excuse my ignorance, but after it's cloned, is it possible to add /dev/sdc2 to md1 while it's syncing (to /dev/sda2)? Or do I need to wait until /dev/sdb fails to replace it with /dev/sdc? 

Using LVM can achieve the equivalent.

Here's what I recommend:

1) Partition sdc to match the old drives
2) Expand /dev/md0 onto sdc1:
  mdadm --add /dev/md0 /dev/sdc1
  mdadm --grow /dev/md0 -n 3
3) Create a new, degraded raid1 on sdc2
  mdadm --create --level=1 -n 2 /dev/md2 /dev/sdc2 missing
4) Update mdadm.conf and initramfs to include /dev/md2
5) Add the new array to your volume group
  pvcreate /dev/md2
  vgextend VolGroup00 /dev/md2
6) Convert your logical volume(s) into mirrors across both PVs
  lvconvert -m1 --mirrorlog=mirrored /dev/VolGroup00/lvname
  {wait for this background task to complete}
7) Fail the rebuilding drive out of /dev/md1 and add it to /dev/md2
  mdadm /dev/md1 --fail /dev/sd?2
  mdadm /dev/md1 --remove /dev/sd?2
  mdadm /dev/md2 --add /dev/sd?2
  {wait for the background rebuild to complete}
8) Unmirror your logical volume(s), dropping the /dev/md1 copy
  lvconvert -m0 /dev/VolGroup00/lvname /dev/md1
9) Drop the empty /dev/md1 from the volume group
  vgreduce -a VolGroup00
  pvremove /dev/md1
10) Update mdadm.conf and initramfs to omit /dev/md1
11) Destroy /dev/md1 and add its device to the new array
  mdadm --stop /dev/md1
  mdadm --add /dev/md2 /dev/sd?2
  mdadm --grow /dev/md2 -n 3

Enjoy your triple redundancy.

Phil

From: =?windows-1252?Q?Tom=E1=9A_Dul=EDk?= <dulik@unart.cz>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Tue, 13 Apr 2010 11:28:24 +0200
Message-ID: <4BC43938.2020109@unart.cz>
References: <4BBA1289.4010705@redhat.com>	<20100407113035.3ca437f2@notabene.brown>	<4BBBE7D2.6090608@redhat.com>	<20100409093153.690ea963@notabene.brown> <20100409103330.37d9dff5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100409103330.37d9dff5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Doug,

first of all: thanks for your work on hot-unplug!
I am new to Linux RAID, have been using HW RAID before but after my LSI 
controller burned to ashes I decided I don't want to see HW RAID ... ever.

First thing I found weird on Linux RAID was the missing support for dead 
device removal.
I spent last 3 weeks trying to write various scripts for UDEV "remove" 
and mdadm "Fail" events handling, but finally I found the same thing 
like you - it is not possible to remove dead device from an array, 
because the events are issued too late. The only way to remove dead 
device is reboot, which is not what I would expect as solution in Linux 
world.

So I downloaded your code from Neil's git 
(http://neil.brown.name/git?p=mdadm;a=shortlog;h=refs/heads/hotunplug)
and also applied the "Minor incremental fixup" mentioned in your message 
below.

The compiled mdadm works OK for normal operations (--fail, --remove, 
--add), but crashes with Segmentation fault for the "--incremental 
--fail" operation if I use it for a disk that I have just disconnected.
Here is what I've got:

# gdb --args ./mdadm -If sda3
GNU gdb 6.8-debian
This GDB was configured as "x86_64-linux-gnu"...
(gdb) run
Starting program: /root/mdadm-git/mdadm/mdadm -If sda3
Program received signal SIGSEGV, Segmentation fault.
0x000000000040a796 in mdstat_by_component (name=0x7fff0d0aee83 "sda3") 
at mdstat.c:351
351                     if (ent->metadata_version &&
(gdb) where
#0  0x000000000040a796 in mdstat_by_component (name=0x7fff0d0aee83 
"sda3") at mdstat.c:351
#1  0x000000000042411c in IncrementalRemove (devname=0x7fff0d0aee83 
"sda3", verbose=0) at Incremental.c:867
#2  0x00000000004075a7 in main (argc=3, argv=0x7fff0d0ad698) at mdadm.c:1545

It does not matter if I use sda3 or sda, the result is the same.
What am I doing wrong?

This is my environment:
# uname -a
Linux xeric 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009 x86_64 
GNU/Linux

# modinfo md_mod
filename:       /lib/modules/2.6.26-2-xen-amd64/kernel/drivers/md/md-mod.ko
alias:          block-major-9-*
alias:          md
license:        GPL
depends:
vermagic:       2.6.26-2-xen-amd64 SMP mod_unload modversions Xen
parm:           start_dirty_degraded:int

# cat /proc/mdstat
Personalities : [raid1]
md2 : active (auto-read-only) raid1 sda3[0] sdb3[1]
      9767424 blocks [2/2] [UU]
      bitmap: 0/150 pages [0KB], 32KB chunk

md1 : active raid1 sda2[2](F) sdb2[1]
      468752512 blocks [2/1] [_U]
      bitmap: 18/224 pages [72KB], 1024KB chunk

md0 : active raid1 sda1[0] sdb1[1]
      497856 blocks [2/2] [UU]
      bitmap: 0/61 pages [0KB], 4KB chunk


Thanks for your help!

Tomas Dulik,
FAI TBU Zlin,
Nad Stranemi 4511,
CZECH REPUBLIC
phone: +420 57 603 5187

On 04/05/2010 12:40 PM, Doug Ledford wrote:
> Minor incremental fixup: In the case of passing in faulty or
> disconnected as the device name, since we now use the value of tfd to
> determine if we should attempt ioctls or go straight to using sysfs
> entries, we now need to make sure we init tdf and then set it properly
> in both of the loops where we check for faulty and disconnected devices
> (although I'm now highly suspicious of the faulty check code as I
> suspect all the faulty devices will have the same problem that our hot
> unplug code ran into and the faulty devices will not be openable and
> that will mean that passing in faulty is probably just broken at this
> point in time...but that's another patch for another day).
>
> -- 
> Doug Ledford <dledford@xxxxxxxxxx>
> GPG KeyID: CFBFF194
> http://people.redhat.com/dledford
>
> Infiniband specific RPMs available at
> http://people.redhat.com/dledford/Infiniband 


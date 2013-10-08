From: Brian Candler <b.candler@pobox.com>
Subject: Using mdadm instead of dmraid for BIOS-RAID root volume
Date: Tue, 08 Oct 2013 13:17:06 +0100
Message-ID: <5253F7C2.2030401@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a number of systems with Ubuntu 12.04 and Intel BIOS-RAID 
mirrored pairs for the boot disk. These come up as dmraid, with the root 
filesystem on /dev/mapper/isw_XXXXXXXXXX_Volume0p1.

I would like to convert them to use mdadm instead (so for example I can 
monitor them with /proc/mdstat)

The mdadm version is 3.2.5, and the manpage says that dff and imsm 
metadata is supported. mdadm --examine confirms this:

|# mdadm --examine /dev/sda
/dev/sda:
           Magic : Intel Raid ISM Cfg Sig.
         Version : 1.1.00
     Orig Family : 8bc6b015
          Family : 8bc6b015
      Generation : 00000010
      Attributes : All supported
            UUID : 2ff8e106:XXXXXXXX:XXXXXXXX:XXXXXXXX
        Checksum : b92d117e correct
     MPB Sectors : 1
           Disks : 2
    RAID Devices : 1

   Disk00 Serial : S14CNEAXXXXXXXX
           State : active
              Id : 00000000
     Usable Size : 234435342 (111.79 GiB 120.03 GB)

[Volume0]:
            UUID : a7fb0d20:XXXXXXXX:XXXXXXXX:XXXXXXXX
      RAID Level : 1
         Members : 2
           Slots : [UU]
     Failed disk : none
       This Slot : 0
      Array Size : 222715904 (106.20 GiB 114.03 GB)
    Per Dev Size : 222716168 (106.20 GiB 114.03 GB)
   Sector Offset : 0
     Num Stripes : 869984
      Chunk Size : 64 KiB
        Reserved : 0
   Migrate State : idle
       Map State : uninitialized
     Dirty State : clean

   Disk01 Serial : S14CNEAXXXXXXXX
           State : active
              Id : 00000001
     Usable Size : 234435342 (111.79 GiB 120.03 GB)

|(ditto for /dev/sdb)

Since this machine is going to need a reinstall for an unrelated reason 
anyway, I thought as an experiment I'd first try to convert it to use 
mdadm at boot.

What I did was:

1. apt-get remove dmraid; apt-get autoremove

This gets rid of:

/lib/udev/rules.d/97-dmraid.rules
/usr/share/initramfs-tools/scripts/local-top/dmraid
/usr/share/initramfs-tools/hooks/dmraid

but we still have:

/lib/udev/rules.d/64-md-raid.rules
/usr/share/initramfs-tools/hooks/mdadm
/usr/share/initramfs-tools/scripts/mdadm-functions
/usr/share/initramfs-tools/scripts/local-premount/mdadm
/usr/share/initramfs-tools/scripts/init-premount/mdadm

2. /usr/share/mdadm/mkconf >/etc/mdadm/mdadm.conf

ARRAY metadata=imsm UUID=2ff8...
ARRAY /dev/md/Volume0 container=2ff8... member=0 UUID=...


However, after a reboot, the machine came up with /dev/sdb1 as its root. 
I was hoping for /dev/md/Volume0

3. Reboot with "raid=autodetect md=1"

No difference, although it did come up with /dev/sda1 as its root 
(possibly coincidental change)

4. After a few more failed experiments with kernel command line options, 
I tried to put it back using "apt-get install dmraid". However after 
that, further boots failed - the kernel panicked because it couldn't 
find the root partition with the given UUID. I guess this means that 
neither dmraid nor mdadm was able to assemble the volume.

The screen shows:

md: Scanned 0 and added 0 devices.
md: autorun ..
md: ... autorun DONE.
VFS: Cannot open root device "UUID=..." or unknown-block(0,0)
Please append a correct "root=" boot option; here are the available 
partitions
(then shows sda, sda1, sdb, sdb1 and a backtrace)

Unfortunately I cannot scroll back to see previous lines. I *can* boot 
the system in a crippled way with root=/dev/sda1 though.

Back at the shell, it looks like the dmraid volume is still present:

# dmraid -r
/dev/sdb: isw, "isw_XXXXXXXXXX", GROUP, ok, 234441646 sectors, data@ 0
/dev/sda: isw, "isw_XXXXXXXXXX", GROUP, ok, 234441646 sectors, data@ 0
# dmraid -s
*** Group superset isw_XXXXXXXXXX
--> Subset
name   : isw_XXXXXXXXXX_Volume0
size   : 222716160
stride : 128
type   : mirror
status : ok
subsets: 0
devs   : 2
spares : 0
# ls /dev/mapper
control
#

The machine is probably toast anyway, as it has written to /dev/sdb1 and 
/dev/sda1 independently.

Anyway, I'm not so worried about having broken this machine, as it 
needed a reinstall anyway, but I do wonder what would have been the 
correct way to get mdraid instead of dmraid at boot time for this root 
volume?

Thanks,

Brian.

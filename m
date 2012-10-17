From: Haakon Alstadheim <hakon.alstadheim@gmail.com>
Subject: Interrupted reshape -- mangled backup ?
Date: Wed, 17 Oct 2012 23:34:26 +0200
Message-ID: <507F2462.2050409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a Raid5 array with 4 devices that I wanted to see if I could get 
a better performance out of, so i tried changing the chunk size from 64K 
to something bigger. (famous last words) .  I got into some other 
trouble and thought I needed a reboot. On reboot I several times managed 
to mount and specify the device with my backup file during initramfs, 
but the reshape stopped every time once the system was at initialized.

This is under debian sqeeze with a 3.2.0-0.bpo.3-686-pae kernel from 
backports. I installed mdadm from backports to get the latest version of 
that as well, and tried rebooting with --freeze-reshape. Suspect that I 
mixed up my initrd.img-files and started without --freeze-reshape the 
first time after installing the new mdadm. Now mdadm says it can not 
find a backup in my backup file. Opening up the backup in emacs, it 
seems to contain only NULs. Can't be right, can it? I have been mounting 
the backup under a directory under /dev/, on the assumption that the 
mount wold survive past the initramfs stage.

My bumbling has been happening with a current, correct, 
/etc/mdadm/mdadm.conf containigng:
--------
DEVICE /dev/sdh /dev/sde /dev/sdc /dev/sdd
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
ARRAY /dev/md1 level=raid5 num-devices=4 
UUID=583001c4:650dcf0c:404aaa6f:7fc38959 spare-group=main
-------
The show-stopper happened with an initramfs and a script in 
/scripts/local-top/mdadm along the lines of:
-------
/sbin/mdadm --assemble -f --backup-file=/dev/bak/md1-backup /dev/md1 
--run --auto=yes /dev/sdh /dev/sde /dev/sdc /dev/sdd
-------

At times I have also had to use the env-variable MDADM_GROW_ALLOW_OLD=1

Below is the output of mdadm -Evvvvs:
--------


/dev/sdh:
           Magic : a92b4efc
         Version : 0.91.00
            UUID : 583001c4:650dcf0c:404aaa6f:7fc38959
   Creation Time : Wed Dec  3 19:45:33 2008
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 2930287488 (2794.54 GiB 3000.61 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 1

   Reshape pos'n : 2368561152 (2258.84 GiB 2425.41 GB)
   New Chunksize : 131072

     Update Time : Wed Oct 17 02:15:53 2012
           State : active
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 14da0760 - correct
          Events : 778795

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8      112        0      active sync   /dev/sdh

    0     0       8      112        0      active sync   /dev/sdh
    1     1       8       48        1      active sync   /dev/sdd
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       64        3      active sync   /dev/sde
/dev/sde:
           Magic : a92b4efc
         Version : 0.91.00
            UUID : 583001c4:650dcf0c:404aaa6f:7fc38959
   Creation Time : Wed Dec  3 19:45:33 2008
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 2930287488 (2794.54 GiB 3000.61 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 1

   Reshape pos'n : 2368561152 (2258.84 GiB 2425.41 GB)
   New Chunksize : 131072

     Update Time : Wed Oct 17 02:15:53 2012
           State : active
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 14da0736 - correct
          Events : 778795

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3       8       64        3      active sync   /dev/sde

    0     0       8      112        0      active sync   /dev/sdh
    1     1       8       48        1      active sync   /dev/sdd
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       64        3      active sync   /dev/sde
/dev/sdc:
           Magic : a92b4efc
         Version : 0.91.00
            UUID : 583001c4:650dcf0c:404aaa6f:7fc38959
   Creation Time : Wed Dec  3 19:45:33 2008
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 2930287488 (2794.54 GiB 3000.61 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 1

   Reshape pos'n : 2368561152 (2258.84 GiB 2425.41 GB)
   New Chunksize : 131072

     Update Time : Wed Oct 17 02:15:53 2012
           State : active
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 14da0714 - correct
          Events : 778795

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     2       8       32        2      active sync   /dev/sdc

    0     0       8      112        0      active sync   /dev/sdh
    1     1       8       48        1      active sync   /dev/sdd
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       64        3      active sync   /dev/sde
/dev/sdd:
           Magic : a92b4efc
         Version : 0.91.00
            UUID : 583001c4:650dcf0c:404aaa6f:7fc38959
   Creation Time : Wed Dec  3 19:45:33 2008
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 2930287488 (2794.54 GiB 3000.61 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 1

   Reshape pos'n : 2368561152 (2258.84 GiB 2425.41 GB)
   New Chunksize : 131072

     Update Time : Wed Oct 17 02:15:53 2012
           State : active
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 14da0722 - correct
          Events : 778795

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1       8       48        1      active sync   /dev/sdd

    0     0       8      112        0      active sync   /dev/sdh
    1     1       8       48        1      active sync   /dev/sdd
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       64        3      active sync   /dev/sde
---------------------------

I guess the moral of all this is that if you want to use mdadm you 
should pay attention and not be in too much of a hurry :-/ .
I'm just hoping that I can get my system back. This raid contains my 
entire system, and will take a LOT of work to recreate. Mail, calendars 
... . Backups are a couple of weeks old ...

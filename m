From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: mdadm --assemble considers event count for spares
Date: Mon, 27 May 2013 13:05:34 +0300
Message-ID: <CAGRgLy6fc8fF8KWoO7EEG6Uo8d4jUPPLcucwX-fNw9O5qKMJgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,
It can happen that a spare has a higher event count than a in-array drive.
For exampe: RAID1 with two drives is rebuilding one of the drives.
Then the "good" drive fails. As a result, MD stops the rebuild and
ejects the rebuilding drive from the array. The failed drive stays in
the array, because RAID1 never ejects the last drive. However, the
"good" drive fails all IOs, so the ejected drive has a larger event
count now.
Now if MD is stopped and re-assembled, mdadm considers the spare drive
as the chosen one:

root@vc:/mnt/work/alex/mdadm-neil# ./mdadm --assemble /dev/md200
--name=alex --config=none --homehost=vc --run --auto=md --metadata=1.2
--verbose --verbose /dev/sdc2 /dev/sdd2
mdadm: looking for devices for /dev/md200
mdadm: /dev/sdc2 is identified as a member of /dev/md200, slot 0.
mdadm: /dev/sdd2 is identified as a member of /dev/md200, slot -1.
mdadm: added /dev/sdc2 to /dev/md200 as 0 (possibly out of date)
mdadm: no uptodate device for slot 2 of /dev/md200
mdadm: added /dev/sdd2 to /dev/md200 as -1
mdadm: failed to RUN_ARRAY /dev/md200: Input/output error
mdadm: Not enough devices to start the array.

Kernel doesn't accept the non-spare drive considering it as non-fresh:
May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.679396] md: md200 stopped.
May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.686870] md: bind<sdc2>
May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.687623] md: bind<sdd2>
May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.687675] md: kicking
non-fresh sdc2 from array!
May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.687680] md: unbind<sdc2>
May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.687683] md: export_rdev(sdc2)
May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.693574]
md/raid1:md200: active with 0 out of 2 mirrors
May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.693583] md200:
failed to create bitmap (-5)

This happens with the latest mdadm from git, and kernel 3.8.2.

Is this the expected behavior?
Maybe mdadm should not consider spares at all for its "chosen_drive"
logic, and perhaps not try to add them to the kernel?

Superblocks of both drives:
sdc2 - the "good" drive:
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 8e051cc5:c536d16e:72b413fa:e7049d4b
           Name : zadara_vc:alex
  Creation Time : Mon May 27 11:33:50 2013
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 975063127 (464.95 GiB 499.23 GB)
     Array Size : 209715200 (200.00 GiB 214.75 GB)
  Used Dev Size : 419430400 (200.00 GiB 214.75 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=555632727 sectors
          State : clean
    Device UUID : 1f661ca3:fdc8b887:8d3638ab:f2cc0a40

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon May 27 11:34:57 2013
       Checksum : 72a97357 - correct
         Events : 9

sdd2 - the "rebuilding" drive:
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 8e051cc5:c536d16e:72b413fa:e7049d4b
           Name : zadara_vc:alex
  Creation Time : Mon May 27 11:33:50 2013
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 976123417 (465.45 GiB 499.78 GB)
     Array Size : 209715200 (200.00 GiB 214.75 GB)
  Used Dev Size : 419430400 (200.00 GiB 214.75 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=556693017 sectors
          State : clean
    Device UUID : 9abc7fa9:6bf95a51:51f2cd65:14232e81

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon May 27 11:35:56 2013
       Checksum : 3e793a34 - correct
         Events : 26


   Device Role : spare
   Array State : A. ('A' == active, '.' == missing, 'R' == replacing)


Thanks,
Alex.

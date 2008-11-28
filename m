From: Chris Webb <chris@arachsys.com>
Subject: Synchronous vs asynchonous mdadm operations
Date: Fri, 28 Nov 2008 16:27:03 +0000
Message-ID: <20081128162703.GA22404@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I notice that some mdadm operations appear to be asynchronous. For instance,

  mdadm --fail /dev/md/shelf.51000 /dev/mapper/slot.51000.1
  mdadm --remove /dev/md/shelf.51000 /dev/mapper/slot.51000.1

will always fail at the --remove stage with

  mdadm: hot remove failed for /dev/mapper/slot.51000.1: Device or resource busy

whereas adding a short sleep in between will make it successful.

Is there a 'standard' way to wait for this operation to complete or to
perform both steps in one go, other than something horrible like:

  mdadm --fail /dev/md/shelf.51000 /dev/mapper/slot.51000.1
  MD=$((`stat -c '%#T' -L /dev/md/shelf.51000`))
  MAJOR=$((`stat -c '%#t' -L /dev/mapper/slot.51000.1`))
  MINOR=$((`stat -c '%#T' -L /dev/mapper/slot.51000.1`))
  for RD in /sys/block/md$MD/md/rd*; do
    [ -f $RD/block/dev ] || continue
    [ "`<$RD/block/dev`" = "$MAJOR:$MINOR" ] || continue
    while [ "< $RD/state" != "faulty ]; do sleep 0.1; done
  done
  mdadm --remove /dev/md/shelf.51000 /dev/mapper/slot.51000.1


Also, is mdadm --stop asynchronous in the same way? If mdadm --stop succeeds
on one host and I immediately run mdadm --assemble on another host which is
able to access the same slots, am I at risk of corrupting the array?

The reason for the question is that I'm seeing occasional cases of arrays which
won't reassemble following such an operation. dmesg alleges there is an invalid
superblock for all of the six slots which were originally part of the array:

  md: md126 stopped.
  md: etherd/e24.1 does not have a valid v1.1 superblock, not importing!
  md: md_import_device returned -22
  md: etherd/e24.4 does not have a valid v1.1 superblock, not importing!
  md: md_import_device returned -22
  md: etherd/e24.5 does not have a valid v1.1 superblock, not importing!
  md: md_import_device returned -22
  md: etherd/e24.2 does not have a valid v1.1 superblock, not importing!
  md: md_import_device returned -22
  md: etherd/e24.3 does not have a valid v1.1 superblock, not importing!
  md: md_import_device returned -22
  md: etherd/e24.0 does not have a valid v1.1 superblock, not importing!
  md: md_import_device returned -22

This array had been grown from 258MB slots to 13GB slots on the old host
shortly before being stopped and attempting to reassemble on a new host, and
mdadm --examine on each of the slots shows a superblock reflecting the old
array size, rather than the new. Presumably there is other corruption too,
which I can't see.

  # mdadm --examine /dev/etherd/e24.3 
  /dev/etherd/e24.3:
            Magic : a92b4efc
          Version : 1.1
      Feature Map : 0x0
       Array UUID : 94de9400:e0cb45f4:36e50a70:184a6875
             Name : 3:shelf.24
    Creation Time : Fri Nov 21 18:22:38 2008
       Raid Level : raid6
     Raid Devices : 6

   Avail Dev Size : 27789808 (13.25 GiB 14.23 GB)
       Array Size : 2107392 (1029.17 MiB 1078.98 MB)
    Used Dev Size : 526848 (257.29 MiB 269.75 MB)
      Data Offset : 16 sectors
     Super Offset : 0 sectors
            State : clean
      Device UUID : d51aaa04:d51a524b:77b766d1:10eb7ec6

      Update Time : Fri Nov 28 13:18:19 2008
         Checksum : 9644dd7f - correct
           Events : 22

       Chunk Size : 4K

      Array Slot : 5 (0, 1, 2, 3, 4, 5)
     Array State : uuuuuU

The event count shown by mdadm --examine matches across all the slots.


For what it's worth, the underlying aoe devices through which remote slots are
made visible to the old and new hosts should correctly handle synchronous
writes/fsync(). If the sync returns as completed, the written data should
genuinely be visible and consistent from every host which can see the device,
whether locally or remotely. (Obviously if I wasn't respecting fsync()
behaviour at the network block device level, I'd expect all sorts of
consistency problems in moving an array from host to host like this.)

Cheers,

Chris.


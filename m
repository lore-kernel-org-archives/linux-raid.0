From: val <valkoles@gmail.com>
Subject: raid6 problem
Date: Sat, 2 Dec 2017 15:25:55 -0800
Message-ID: <CAAVX1adjSKT-G9-h0J1Ly7QTpMqJ+jQ4Luqi_+WDC1aThMCYdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have (or had? :-( ) raid6 with 5 drives (sd[echdg]).
Status was good and I decided to replace working 3TB drive with 5TB drive:

mdadm /dev/md127 --fail /dev/sdd --remove /dev/sdd
# replaced hdd and rebooted (shouldn't have done next two lines - now
I know that)
cryptsetup luksOpen /dev/md127 en_r6
mount /dev/mapper/en_r6 /mnt/en_r6/
smartctl -t short /dev/sdd
# waited for short test to finish
smartctl -t long /dev/sdd
mdadm  /dev/md127 --add /dev/sdd

After an hour (7% done) there was long error chunk in
/var/log/messages.  Here is the end of it:
Dec  2 02:55:14 vision kernel: sd 7:0:0:0: [sdh] tag#2 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Dec  2 02:55:14 vision kernel: sd 7:0:0:0: [sdh] tag#2 CDB: Read(16)
88 00 00 00 00 00 21 53 03 28 00 00 00 18 00 00
Dec  2 02:55:14 vision kernel: blk_update_request: I/O error, dev sdh,
sector 559088424
Dec  2 02:55:14 vision kernel: blk_update_request: I/O error, dev sdg,
sector 559088424
Dec  2 02:55:14 vision kernel: md: super_written gets error=-5
Dec  2 02:55:14 vision kernel: md/raid:md127: Disk failure on sdh,
disabling device.\x0amd/raid:md127: Operation continuing on 3 devices.
Dec  2 02:55:14 vision kernel: md: super_written gets error=-5
Dec  2 02:55:14 vision kernel: md/raid:md127: Disk failure on sde,
disabling device.\x0amd/raid:md127: Operation continuing on 2 devices.
Dec  2 02:55:14 vision kernel: md: super_written gets error=-5
Dec  2 02:55:14 vision kernel: md/raid:md127: Disk failure on sdg,
disabling device.\x0amd/raid:md127: Operation continuing on 1 devices.
Dec  2 02:55:14 vision kernel: md/raid:md127: read error not
correctable (sector 559128928 on sde).
Dec  2 02:55:14 vision kernel: md/raid:md127: read error not
correctable (sector 559128928 on sdg).
Dec  2 02:55:14 vision kernel: md/raid:md127: read error not
correctable (sector 559128928 on sdh).
Dec  2 02:56:32 vision kernel: md: md127: recovery interrupted.
Dec  2 10:59:01 vision CROND[4393]: (root) CMD (rm -f
/var/spool/cron/lastrun/cron.hourly)
Dec  2 11:00:01 vision CROND[4403]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons)
Dec  2 03:06:15 vision kernel: Buffer I/O error on dev dm-0, logical
block 0, lost sync page write
Dec  2 03:06:15 vision kernel: VFS: Dirty inode writeback failed for
block device dm-0 (err=-5).
Dec  2 03:06:55 vision shutdown[4482]: shutting down for system reboot

# before shutdown I did:
umount /mnt/en_r6/
cryptsetup luksClose /dev/mapper/en_r6


rebooted and now I have:
vision ~ # mdadm --detail /dev/md127
/dev/md127:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 5
    Persistence : Superblock is persistent

          State : inactive

           Name : vision:0  (local to host vision)
           UUID : 4eab7c9d:75996247:fc6cdd24:15002f0b
         Events : 189186

    Number   Major   Minor   RaidDevice

       -       8       64        -        /dev/sde
       -       8       32        -        /dev/sdc
       -       8      112        -        /dev/sdh
       -       8       48        -        /dev/sdd
       -       8       96        -        /dev/sdg
vision ~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md127 : inactive sde[5](S) sdg[4](S) sdh[6](S) sdc[0](S) sdd[7](S)
      20511189560 blocks super 1.2

unused devices: <none>

timeout output:
/dev/sdc  is good Device Model:     TOSHIBA DT01ACA300
/dev/sdd  is good Device Model:     TOSHIBA HDWE150
/dev/sde  is good Device Model:     TOSHIBA MD04ACA500
/dev/sdg  is good Device Model:     TOSHIBA MD04ACA500
/dev/sdh  is  bad Device Model:     ST3000DM008-2DM166

* /dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 4eab7c9d:75996247:fc6cdd24:15002f0b
           Name : vision:0  (local to host vision)
  Creation Time : Mon Feb  1 10:20:56 2016
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 8790405120 (8383.18 GiB 9001.37 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=944 sectors
          State : clean
    Device UUID : 41ce7046:7ebdceea:65d19621:f1ca61e4

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Dec  2 03:06:16 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 11fe1830 - correct
         Events : 191432

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.... ('A' == active, '.' == missing, 'R' == replacing)

* /dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 4eab7c9d:75996247:fc6cdd24:15002f0b
           Name : vision:0  (local to host vision)
  Creation Time : Mon Feb  1 10:20:56 2016
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 9767279024 (4657.40 GiB 5000.85 GB)
     Array Size : 8790405120 (8383.18 GiB 9001.37 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=3907008944 sectors
          State : clean
    Device UUID : 886a5eec:9e849621:21abfb4e:a369cd89

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Dec  2 03:06:16 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
       Checksum : aa642a14 - correct
         Events : 191432

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : A.... ('A' == active, '.' == missing, 'R' == replacing)

* /dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 4eab7c9d:75996247:fc6cdd24:15002f0b
           Name : vision:0  (local to host vision)
  Creation Time : Mon Feb  1 10:20:56 2016
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 9767279024 (4657.40 GiB 5000.85 GB)
     Array Size : 8790405120 (8383.18 GiB 9001.37 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=3907008944 sectors
          State : clean
    Device UUID : 115d79b4:69962035:97d4e787:9111f3d9

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Dec  2 02:53:46 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : f1ff417 - correct
         Events : 189186

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)

* /dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 4eab7c9d:75996247:fc6cdd24:15002f0b
           Name : vision:0  (local to host vision)
  Creation Time : Mon Feb  1 10:20:56 2016
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 9767279024 (4657.40 GiB 5000.85 GB)
     Array Size : 8790405120 (8383.18 GiB 9001.37 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=3907008944 sectors
          State : clean
    Device UUID : 488e865c:38b2a55d:98af3012:b923d816

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Dec  2 02:53:46 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : a6e02e43 - correct
         Events : 189186

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)

* /dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 4eab7c9d:75996247:fc6cdd24:15002f0b
           Name : vision:0  (local to host vision)
  Creation Time : Mon Feb  1 10:20:56 2016
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 8790405120 (8383.18 GiB 9001.37 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=944 sectors
          State : clean
    Device UUID : 9e72158d:5129c8d1:50a2f7a5:0e8b8ed1

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Dec  2 02:53:46 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : b12eadc2 - correct
         Events : 189186

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)


# trying to assemble raid6 with all drives
vision ~ # mdadm --assemble --no-degraded --readonly /dev/md127
/dev/sde /dev/sdc /dev/sdh /dev/sdd /dev/sdg
mdadm: /dev/md127 assembled from 1 drive (out of 5), but not started.
vision ~ # mdadm --stop /dev/md127
mdadm: stopped /dev/md127

# trying to assemble raid6 without newly added drive
vision ~ # mdadm --assemble --no-degraded --readonly /dev/md127
/dev/sde /dev/sdc /dev/sdh /dev/sdg
mdadm: /dev/md127 assembled from 1 drive (out of 5), but not started.
vision ~ # mdadm --detail /dev/md127
/dev/md127:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 4
    Persistence : Superblock is persistent

          State : inactive

           Name : vision:0  (local to host vision)
           UUID : 4eab7c9d:75996247:fc6cdd24:15002f0b
         Events : 189186

    Number   Major   Minor   RaidDevice

       -       8       64        -        /dev/sde
       -       8       32        -        /dev/sdc
       -       8      112        -        /dev/sdh
       -       8       96        -        /dev/sdg
vision ~ # mdadm --stop /dev/md127
mdadm: stopped /dev/md127

# trying to assemble raid6 with three drives with Array State : AAAAA
vision ~ # mdadm --assemble --no-degraded --readonly /dev/md127
/dev/sde /dev/sdh /dev/sdg
mdadm: /dev/md127 assembled from 3 drives (out of 5), but not started.
vision ~ # mdadm --detail /dev/md127
/dev/md127:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 3
    Persistence : Superblock is persistent

          State : inactive

           Name : vision:0  (local to host vision)
           UUID : 4eab7c9d:75996247:fc6cdd24:15002f0b
         Events : 189186

    Number   Major   Minor   RaidDevice

       -       8       64        -        /dev/sde
       -       8      112        -        /dev/sdh
       -       8       96        -        /dev/sdg
vision ~ # mdadm --stop /dev/md127
mdadm: stopped /dev/md127


Don't want to loose my data, so asking for the help.
Haven't had any new suspicious lines in /var/log/messages since the
accident (though raid6 wasn't used either)

Is my data lost or is there a hope?

Why mdadm insists that it's raid0, while --examine has correct raid6
for all drives?

How can I save info from raid?  (Restoring raid with it would be
preferred though)

Thank you in advance

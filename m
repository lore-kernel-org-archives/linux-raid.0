From: Marc MERLIN <marc_news@merlins.org>
Subject: SW Raid doesn't play nice with devfs?
Date: Sun, 8 Sep 2002 22:48:00 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020909054800.GV3806@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Short version:
I have 3 disk arrays and I created several SW Raid 5 mds under 2.4.14 with
devfs, and remade them under 2.4.19 to see whether it helped.

All is well unless one of my disk arrays isn't powered when the system boots

Thanks to devfs, my drives still show up where they're supposed to be but md
tries to access the drives with the /dev/sd?1 names instead of 
/dev/scsi/host3/bus0/target?/lun0/part1


Longer version:
Just to make  sure, I remade the  array on top of itself  with the following
lines in /etc/raidtab.
raiddev /dev/md3             
        raid-level              5
        nr-raid-disks           7
        nr-spare-disks          0
        chunk-size              32
        persistent-superblock   1
        device                  /dev/scsi/host3/bus0/target8/lun0/part1
        raid-disk               0
        device                  /dev/scsi/host3/bus0/target9/lun0/part1
        raid-disk               1
        device                  /dev/scsi/host3/bus0/target10/lun0/part1
        raid-disk               2
        device                  /dev/scsi/host3/bus0/target11/lun0/part1
        raid-disk               3
        device                  /dev/scsi/host3/bus0/target12/lun0/part1
        raid-disk               4
        device                  /dev/scsi/host3/bus0/target13/lun0/part1
        raid-disk               5
        device                  /dev/scsi/host3/bus0/target14/lun0/part1
        raid-disk               6

Yet, if my other arrays are down  at boot time, /dev/md3 doesn't get created
at boot time, and a manual raidstart /dev/md3 yields:

kernel: md: could not lock sdm1, zero-size? Marking faulty.
kernel: md: could not import sdm1, trying to run array nevertheless.
kernel: md: could not lock sdn1, zero-size? Marking faulty.
kernel: md: could not import sdn1, trying to run array nevertheless.
kernel: md: could not lock sdo1, zero-size? Marking faulty.
kernel: md: could not import sdo1, trying to run array nevertheless.
kernel: md: could not lock sdp1, zero-size? Marking faulty.
kernel: md: could not import sdp1, trying to run array nevertheless.
kernel: md: could not lock sdq1, zero-size? Marking faulty.
kernel: md: could not import sdq1, trying to run array nevertheless.
kernel: md: could not lock sdr1, zero-size? Marking faulty.
kernel: md: could not import sdr1, trying to run array nevertheless.
kernel: md: could not lock sds1, zero-size? Marking faulty.
kernel: md: could not import sds1, trying to run array nevertheless.
kernel: md: autorun ...
kernel: md: considering scsi/host3/bus0/target8/lun0/part1 ...
kernel: md:  adding scsi/host3/bus0/target8/lun0/part1 ...
kernel: md: created md3
kernel: md: bind<scsi/host3/bus0/target8/lun0/part1,1>
kernel: md: running: <scsi/host3/bus0/target8/lun0/part1>
kernel: md: scsi/host3/bus0/target8/lun0/part1's event counter: 00000002
kernel: md: device name has changed from sdm1 to scsi/host3/bus0/target8/lun0/part1 since last import!
kernel: md3: former device sdn1 is unavailable, removing from array!
kernel: md3: former device sdo1 is unavailable, removing from array!
kernel: md3: former device sdp1 is unavailable, removing from array!
kernel: md3: former device sdq1 is unavailable, removing from array!
kernel: md3: former device sdr1 is unavailable, removing from array!
kernel: md3: former device sds1 is unavailable, removing from array!
kernel: md: md3: raid array is not clean -- starting background reconstruction
kernel: md3: max total readahead window set to 1488k
kernel: md3: 6 data-disks, max readahead per data-disk: 248k
kernel: raid5: device scsi/host3/bus0/target8/lun0/part1 operational as raid disk 0
kernel: raid5: not enough operational devices for md3 (6/7 failed)
kernel: RAID5 conf printout:
kernel:  --- rd:7 wd:1 fd:6
kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host3/bus0/target8/lun0/part1
kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 00:00]
kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
kernel:  disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 00:00]
kernel:  disk 6, s:0, o:0, n:6 rd:6 us:1 dev:[dev 00:00]
kernel: raid5: failed to run raid set md3
kernel: md: pers->run() failed ...
kernel: md :do_md_run() returned -22
kernel: md: md3 stopped.
kernel: md: unbind<scsi/host3/bus0/target8/lun0/part1,0>
kernel: md: export_rdev(scsi/host3/bus0/target8/lun0/part1)

I've even tried making the symlinks:
gargamel:/dev# cat /tmp/script
ln -s scsi/host3/bus0/target8/lun0/part1 sdm1
ln -s scsi/host3/bus0/target9/lun0/part1 sdn1
ln -s scsi/host3/bus0/target10/lun0/part1 sdo1
ln -s scsi/host3/bus0/target11/lun0/part1 sdp1
ln -s scsi/host3/bus0/target12/lun0/part1 sdq1
ln -s scsi/host3/bus0/target13/lun0/part1 sdr1
ln -s scsi/host3/bus0/target14/lun0/part1 sds1
gargamel:/dev# bash /tmp/script 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking 
Home page: http://marc.merlins.org/   |   Finger marc_f@merlins.org for PGP key

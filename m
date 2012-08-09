From: Sam Clark <sclark_77@hotmail.com>
Subject: RAID5 - Disk failed during re-shape
Date: Thu, 9 Aug 2012 10:38:05 +0200
Message-ID: <BLU153-ds1688A6A36A974526D12FDB94CC0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-gb
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,=20

Hoping you can help recover my data!

I have (had?) a software RAID 5 volume, created on Ubuntu 10.04 a few y=
ears
back consisting of 4 x 1500GB drives.=A0 Was running great until the
motherboard died last week.=A0=A0 Purchased new motherboard, CPU & RAM,
installed Ubuntu 12.04, and got everything assembled fine, and working =
for
around 48 hours.=A0=20

After that I added a 2000GB drive to increase capacity, and ran mdadm -=
-add
/dev/md0 /dev/sdf.=A0 The Re-configuration started to run, and then aro=
und
11.4% of the reshaping I saw that the server had some errors:
Aug=A0 8 22:17:41 nas kernel: [ 5927.453434] Buffer I/O error on device=
 md0,
logical block 715013760
Aug=A0 8 22:17:41 nas kernel: [ 5927.453439] EXT4-fs warning (device md=
0):
ext4_end_bio:251: I/O error writing to inode 224003641 (offset 15781068=
8
size 4096 starting block 715013760)
Aug=A0 8 22:17:41 nas kernel: [ 5927.453448] JBD2: Detected IO errors w=
hile
flushing file data on md0-8
Aug=A0 8 22:17:41 nas kernel: [ 5927.453467] Aborting journal on device=
 md0-8.
Aug=A0 8 22:17:41 nas kernel: [ 5927.453642] Buffer I/O error on device=
 md0,
logical block 548962304
Aug=A0 8 22:17:41 nas kernel: [ 5927.453643] lost page write due to I/O=
 error
on md0
Aug=A0 8 22:17:41 nas kernel: [ 5927.453656] JBD2: I/O error detected w=
hen
updating journal superblock for md0-8.
Aug=A0 8 22:17:41 nas kernel: [ 5927.453688] Buffer I/O error on device=
 md0,
logical block 0
Aug=A0 8 22:17:41 nas kernel: [ 5927.453690] lost page write due to I/O=
 error
on md0
Aug=A0 8 22:17:41 nas kernel: [ 5927.453697] EXT4-fs error (device md0)=
:
ext4_journal_start_sb:327: Detected aborted journal
Aug=A0 8 22:17:41 nas kernel: [ 5927.453700] EXT4-fs (md0): Remounting
filesystem read-only
Aug=A0 8 22:17:41 nas kernel: [ 5927.453703] EXT4-fs (md0): previous I/=
O error
to superblock detected
Aug=A0 8 22:17:41 nas kernel: [ 5927.453826] Buffer I/O error on device=
 md0,
logical block 715013760
Aug=A0 8 22:17:41 nas kernel: [ 5927.453828] lost page write due to I/O=
 error
on md0
Aug=A0 8 22:17:41 nas kernel: [ 5927.453842] JBD2: Detected IO errors w=
hile
flushing file data on md0-8
Aug=A0 8 22:17:41 nas kernel: [ 5927.453848] Buffer I/O error on device=
 md0,
logical block 0
Aug=A0 8 22:17:41 nas kernel: [ 5927.453850] lost page write due to I/O=
 error
on md0
Aug=A0 8 22:20:54 nas kernel: [ 6120.964129] INFO: task md0_reshape:297
blocked for more than 120 seconds.

On checking the progress of /proc/mdstat, I found that 2 drives were li=
sted
as failed (__UUU), and the finish time was simply growing by hundreds o=
f
minutes at a time.

I was able to browse some data on the Raid set (incl my Home folder), b=
ut
couldn't browse some other sections - shell simply hung when I tried to
issue "ls /raidmount".=A0 I tied to add one of the failed disks back in=
, but
got the response that there was no superblock on it.=A0 rebooted it at =
that
time.

During boot I was given the option to manually recover, or skip mountin=
g - I
chose the latter.=20

Now that the system is running, I tried to assemble, but keeps failing.=
=A0
Have tried:
mdadm --assemble --force /dev/md0 /dev/sdb /dev/sdc /dev/sdd /dev/sde
/dev/sdf

I am able to see all the drives, but can see the UUID is incorrect and =
the
Raid Level states -unknown-, as below... does this mean the data can't =
be
recovered?=A0=20

root@nas:/var/log$ mdadm --examine /dev/sd[b-f]
/dev/sdb:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 0.90.00
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 00000000:00000000:00000000:000000=
00
=A0 Creation Time : Thu Aug=A0 9 07:44:48 2012
=A0=A0=A0=A0 Raid Level : -unknown-
=A0=A0 Raid Devices : 0
=A0 Total Devices : 5
Preferred Minor : 0

=A0=A0=A0 Update Time : Thu Aug=A0 9 07:45:10 2012
=A0=A0=A0=A0=A0=A0=A0=A0 =A0State : active
Active Devices : 0
Working Devices : 5
=46ailed Devices : 0
=A0 Spare Devices : 5
=A0=A0=A0=A0=A0=A0 Checksum : a0b6e863 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 1


=A0=A0=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
this=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=A0=
=A0=A0=A0 0=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdb

=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdb
=A0=A0 1=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 48=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdd
=A0=A0 2=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 80=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdf
=A0=A0 3=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 64=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sde
=A0=A0 4=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 32=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdc
/dev/sdc:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 0.90.00
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 00000000:00000000:00000000:000000=
00
=A0 Creation Time : Thu Aug=A0 9 07:44:48 2012
=A0=A0=A0=A0 Raid Level : -unknown-
=A0=A0 Raid Devices : 0
=A0 Total Devices : 5
Preferred Minor : 0

=A0=A0=A0 Update Time : Thu Aug=A0 9 07:45:10 2012
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
Active Devices : 0
Working Devices : 5
=46ailed Devices : 0
=A0 Spare Devices : 5
=A0=A0=A0=A0=A0=A0 Checksum : a0b6e87b - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 1


=A0=A0=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
this=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 32=A0=A0=A0=A0=
=A0=A0=A0 4=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdc

=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdb
=A0=A0 1=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 48=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdd
=A0=A0 2=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 80=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdf
=A0=A0 3=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 64=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sde
=A0=A0 4=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 32=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdc
/dev/sdd:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 0.90.00
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 00000000:00000000:00000000:000000=
00
=A0 Creation Time : Thu Aug=A0 9 07:44:48 2012
=A0=A0=A0=A0 Raid Level : -unknown-
=A0=A0 Raid Devices : 0
=A0 Total Devices : 5
Preferred Minor : 0

=A0=A0=A0 Update Time : Thu Aug=A0 9 07:45:10 2012
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
Active Devices : 0
Working Devices : 5
=46ailed Devices : 0
=A0 Spare Devices : 5
=A0=A0=A0=A0=A0=A0 Checksum : a0b6e885 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 1


=A0=A0=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
this=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 48=A0=A0=A0=A0=
=A0=A0=A0 1=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdd

=A0=A0 0=A0=A0=A0=A0 0 =A0=A0=A0=A0=A0=A08=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdb
=A0=A0 1=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 48=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdd
=A0=A0 2=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 80=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdf
=A0=A0 3=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 64=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sde
=A0=A0 4=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 32=A0=A0=A0=
 =A0=A0=A0=A04=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdc
/dev/sde:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 0.90.00
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 00000000:00000000:00000000:000000=
00
=A0 Creation Time : Thu Aug=A0 9 07:44:48 2012
=A0=A0=A0=A0 Raid Level : -unknown-
=A0=A0 Raid Devices : 0
=A0 Total Devices : 5
Preferred Minor : 0

=A0=A0=A0 Update Time : Thu Aug=A0 9 07:45:10 2012
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
Active Devices : 0
Working Devices : 5
=46ailed Devices : 0
=A0 Spare Devices : 5
=A0=A0=A0=A0=A0=A0 Checksum : a0b6e899 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 1


=A0=A0=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
this=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 64=A0=A0=A0=A0=
=A0=A0=A0 3=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sde

=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdb
=A0=A0 1=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 48=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdd
=A0=A0 2=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 80=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdf
=A0=A0 3=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 64=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sde
=A0=A0 4=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 32=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdc
/dev/sdf:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 0.90.00
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 00000000:00000000:00000000:000000=
00
=A0 Creation Time : Thu Aug=A0 9 07:44:48 2012
=A0=A0=A0=A0 Raid Level : -unknown-
=A0=A0 Raid Devices : 0
=A0 Total Devices : 5
Preferred Minor : 0

=A0=A0=A0 Update Time : Thu Aug=A0 9 07:45:10 2012
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
Active Devices : 0
Working Devices : 5
=46ailed Devices : 0
=A0 Spare Devices : 5
=A0=A0=A0=A0=A0=A0 Checksum : a0b6e8a7 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 1


=A0=A0=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
this=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 80=A0=A0=A0=A0=
=A0=A0=A0 2=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdf

=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdb
=A0=A0 1=A0 =A0=A0=A01=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 48=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdd
=A0=A0 2=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 80=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdf
=A0=A0 3=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 64=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sde
=A0=A0 4=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 32=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdc

According to Syslog, the only drive failure that I had was /dev/sde, bu=
t I
guess that the re-shape has caused this to go awry.
syslog.1:Aug=A0 8 22:17:41 nas mdadm[1029]: Fail event detected on md d=
evice
/dev/md0, component device /dev/sde

I tried removing the /etc/mdadm/mdadm.conf file, and re-running the sca=
n,
where I got:
root@nas:/var/log$ sudo mdadm --assemble --scan -f -vv
mdadm: looking for devices for further assembly
mdadm: cannot open device /dev/sda5: Device or resource busy
mdadm: no RAID superblock on /dev/sda2
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sdf is identified as a member of /dev/md/0_0, slot 2.
mdadm: /dev/sde is identified as a member of /dev/md/0_0, slot 3.
mdadm: /dev/sdd is identified as a member of /dev/md/0_0, slot 1.
mdadm: /dev/sdc is identified as a member of /dev/md/0_0, slot 4.
mdadm: /dev/sdb is identified as a member of /dev/md/0_0, slot 0.
mdadm: failed to add /dev/sdd to /dev/md/0_0: Invalid argument
mdadm: failed to add /dev/sdf to /dev/md/0_0: Invalid argument
mdadm: failed to add /dev/sde to /dev/md/0_0: Invalid argument
mdadm: failed to add /dev/sdc to /dev/md/0_0: Invalid argument
mdadm: failed to add /dev/sdb to /dev/md/0_0: Invalid argument
mdadm: /dev/md/0_0 assembled from -1 drives and 1 spare - not enough to
start the array.
mdadm: looking for devices for further assembly
mdadm: No arrays found in config file or automatically

I guess the 'invalid argument' is the -unknown- in the raid level.. but=
 it's
only a guess.=20

I'm at the extent of my knowledge - would appreciate some expert assist=
ance
in recovering this array, if it's possible!

Many thanks,=20
Sam


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Guillaume Paumier <guillaume.paumier@gmail.com>
Subject: Re: Guidance on reshape stuck at 0% after --grow
Date: Tue, 22 Sep 2015 20:20:30 -0700
Message-ID: <CAKWBTuG2AngM6joiODt15Qe+HAXfF6OnJVD-HNuNKikfyv-6MQ@mail.gmail.com>
References: <CAKWBTuFk4Tz20B4aZHgPF3FoEYXDqwQeKeAwN3Nt-cSAopUQ0Q@mail.gmail.com>
	<alpine.DEB.2.02.1509221224470.8750@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1509221224470.8750@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

On 22 September 2015 at 03:29, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>
> You're not the first one here with this problem.
>
> I can't find it right now, but I believe someone issued --grow --continue on
> the array to get it out of the state that you have right now.
>
> I don't know if it's this:
>
> http://www.spinics.net/lists/raid/msg49077.html
>
> I do not recommend a reboot or anything else, others have had problems with
> this. Also make sure you collect as much information as possible, mdadm
> --examine, copy the superblocks in binary form using dd to somewhere etc, so
> you can get back to the state where you are now.
>
> Look through the mailing list archives from the past 6 months, you're not
> alone in having this problem.

Thank you for your advice and pointers. I looked further into that
thread and others, and they helped to investigate the issue.

Unfortunately, it seems (of course) that I have only succeeded in
making the situation worse.

The thread you linked to was indeed similar to my issue. I first
looked into mdadm-grow-continue@md0.service, as suggested in
http://www.spinics.net/lists/raid/msg49042.html :

______________________________________________

# systemctl status mdadm-grow-continue@md0.service

-------------------------------------------------------------------------------

mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
   Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service; static)
   Active: failed (Result: exit-code) since dim. 2015-09-20 16:48:15
PDT; 1 day 20h ago
  Process: 10989 ExecStart=/sbin/mdadm --grow --continue /dev/%I
(code=exited, status=1/FAILURE)
 Main PID: 10989 (code=exited, status=1/FAILURE)
______________________________________________


The service was inactive, which was consistent with the fact that I
didn't see any activity in top. I tried to re-start it, but the result
was the same.

Per http://www.spinics.net/lists/raid/msg49098.html , I commented out
the StandardInput, StandardOutput and StandardError entries in the
service file, and reloaded the daemon. This gave me these additional
lines (bottom two lines of the output):

______________________________________________

# nano /usr/lib/systemd/system/mdadm-grow-continue@.service
# systemctl daemon-reload
# systemctl start mdadm-grow-continue@md0.service
# systemctl status mdadm-grow-continue@md0.service

-------------------------------------------------------------------------------

mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
   Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service; static)
   Active: failed (Result: exit-code) since mar. 2015-09-22 13:03:26 PDT; 2s ago
  Process: 14688 ExecStart=/sbin/mdadm --grow --continue /dev/%I
(code=exited, status=1/FAILURE)
 Main PID: 14688 (code=exited, status=1/FAILURE)

sept. 22 13:03:26 mdadm[14688]: mdadm: Need to backup 5376K of
critical section..
sept. 22 13:03:26 mdadm[14688]: mdadm: array: Cannot grow - need a
spare or backup-file to backup critical section

______________________________________________


So apparently, the array couldn't be grown because there was no backup
file originally specified.

At that point, I figured I would stop the array and try to re-assemble
it in its prior state. In retrospect, it was probably a bad idea, but
I didn't realize at the time that stopping the array would be so
problematic.

I attempted to re-assemble using the "--update=revert-reshape" option
as suggested in http://www.spinics.net/lists/raid/msg49596.html , but
that didn't work:

______________________________________________

# mdadm --assemble --force --update=revert-reshape /dev/md0 /dev/sdc1
/dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1
--backup-file=/root/backup.bak --invalid-backup --verbose

-------------------------------------------------------------------------------

mdadm: looking for devices for /dev/md0
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 7.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdj1 is identified as a member of /dev/md0, slot 5.
mdadm: :/dev/md0 has an active reshape - checking if critical section
needs to be restored
mdadm: Cannot read from /root/backup.bak
mdadm: Failed to find backup of critical section
mdadm: continuing without restoring backup
mdadm: added /dev/sdd1 to /dev/md0 as 1
mdadm: added /dev/sdg1 to /dev/md0 as 2
mdadm: added /dev/sdh1 to /dev/md0 as 3
mdadm: added /dev/sdi1 to /dev/md0 as 4
mdadm: added /dev/sdj1 to /dev/md0 as 5
mdadm: added /dev/sdf1 to /dev/md0 as 6
mdadm: added /dev/sde1 to /dev/md0 as 7
mdadm: no uptodate device for slot 16 of /dev/md0
mdadm: added /dev/sdc1 to /dev/md0 as 0
mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument
______________________________________________


This was the output of mdadm -D afterwards:

______________________________________________

# mdadm -D /dev/md0
-------------------------------------------------------------------------------

/dev/md0:
        Version : 1.0
     Raid Level : raid0
  Total Devices : 8
    Persistence : Superblock is persistent

          State : inactive

  Delta Devices : -1, (1->0)
      New Level : raid6
     New Layout : left-symmetric
  New Chunksize : 128K

           Name : (redacted):0
           UUID : eea59047:120a0365:353da182:6787e030
         Events : 35500

    Number   Major   Minor   RaidDevice

       -       8       33        -        /dev/sdc1
       -       8       49        -        /dev/sdd1
       -       8       65        -        /dev/sde1
       -       8       81        -        /dev/sdf1
       -       8       97        -        /dev/sdg1
       -       8      113        -        /dev/sdh1
       -       8      129        -        /dev/sdi1
       -       8      145        -        /dev/sdj1
______________________________________________


dmesg provided some additional information, saying "reshape_position
too early for auto-recovery":

______________________________________________

# dmesg | grep md

-------------------------------------------------------------------------------

[164758.944492] md: bind<sdd1>
[164758.944819] md: bind<sdg1>
[164758.944977] md: bind<sdh1>
[164758.945152] md: bind<sdi1>
[164758.945339] md: bind<sdj1>
[164758.945472] md: bind<sdf1>
[164758.945610] md: bind<sde1>
[164758.945785] md: bind<sdc1>
[164758.952353] md/raid:md0: reshape_position too early for
auto-recovery - aborting.
[164758.952357] md: pers->run() failed ...

______________________________________________



I think this is the same situation as the one described by Daniel Koch
in the thread "Failed to grow" from August 2015:
http://www.spinics.net/lists/raid/msg49643.html . The signs look very
similar.

I have a version of mdadm --examine before stopping the array, and one
of it now (both are posted at the end of this message). I've also
posted a diff at
https://gist.github.com/gpaumier/da3200b357f35288021d/revisions to
make it easier to see the differences.

As far as I can tell, the only difference is the additional disk I
initially tried to add to the array. When trying to re-assemble, mdadm
complained that that disk (/dev/sdb1) had a different superblock
("mdadm: superblock on /dev/sdb1 doesn't match others - assembly
aborted") so I left it out when trying to re-assemble.

I now realize (per http://www.spinics.net/lists/raid/msg49090.html )
that I should have tried to manually do "mdadm --grow --continue" with
an empty backup file before stopping the array, unfortunately that
wasn't clear to me at the time.

According to http://www.spinics.net/lists/raid/msg49669.html , my last
option seems to be to re-create the array, which worked for the
poster. However, that operation (described at
https://raid.wiki.kernel.org/index.php/RAID_Recovery#Restore_array_by_recreating_.28after_multiple_device_failure.29
) seems very dangerous so I wanted to ask again here before doing
anything else.

This is how I see the current situation:
* The good news is that all the data and metadata still appear clean,
so if I tread carefully I should be able to recover my array with no
data loss (and then re-attempt to grow)
* The bad news is that my only option at this point seems to be to try
to re-create the array manually, which would basically cause all data
to be lost if if doesn't work.

I figure I have a 50% chance of restoring the array, and 50% chance of
making it completely unusable. I'm not very comfortable with those
odds, so I would appreciate if anyone had any advice regarding what to
do now, and alternatives to manually re-creating the array, if there
are any.

Many thanks for your help.

______________________________________________

Appendix 1: Output of mdadm --examine /dev/sd[b-j]1 before stopping the array

-------------------------------------------------------------------------------

# mdadm --examine /dev/sd[b-j]1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033128 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : bde6e5ab:5f4a56e9:10ad82fc:301d477b

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (8->9)

    Update Time : Sun Sep 20 16:48:15 2015
  Bad Block Log : 512 entries available at offset -8 sectors
       Checksum : 28369459 - correct
         Events : 35499

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 8
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : e1b689b5:b4a2c5a7:56057b69:a9101af0

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (8->9)

    Update Time : Sun Sep 20 16:48:15 2015
       Checksum : d20d0897 - correct
         Events : 35499

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 1d8e74d3:9abd37f8:f2cf0ab8:02fdcfd6

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (8->9)

    Update Time : Sun Sep 20 16:48:15 2015
       Checksum : 75afb1b0 - correct
         Events : 35499

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : ddf17d3d:ea944bfb:6886cc91:3366f55f

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (8->9)

    Update Time : Sun Sep 20 16:48:15 2015
       Checksum : 45b40c6b - correct
         Events : 35499

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 7
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 38675f59:ea412b1f:67d6ed9a:a33fc5dd

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (8->9)

    Update Time : Sun Sep 20 16:48:15 2015
       Checksum : c665836 - correct
         Events : 35499

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 6
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : b24758e6:042412c5:9b5a3c06:f167aedf

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (8->9)

    Update Time : Sun Sep 20 16:48:15 2015
       Checksum : ac7dc747 - correct
         Events : 35499

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 00e47d82:b49c3905:3ed961fe:40a5f259

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (8->9)

    Update Time : Sun Sep 20 16:48:15 2015
       Checksum : fb349837 - correct
         Events : 35499

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : a7e34040:fa12382f:c2ef3d85:9c95b1d0

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (8->9)

    Update Time : Sun Sep 20 16:48:15 2015
       Checksum : e0911505 - correct
         Events : 35499

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 4
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 9d89c55d:9f4a2181:6b87922f:0681d580

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (8->9)

    Update Time : Sun Sep 20 16:48:15 2015
       Checksum : aa777dfc - correct
         Events : 35499

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 5
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

______________________________________________



______________________________________________

Appendix 2: Output of mdadm --examine /dev/sd[b-j]1 currently.

-------------------------------------------------------------------------------

# mdadm --examine /dev/sd[b-j]1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033128 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : bde6e5ab:5f4a56e9:10ad82fc:301d477b

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
  Bad Block Log : 512 entries available at offset -8 sectors
       Checksum : 283907e0 - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 8
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : e1b689b5:b4a2c5a7:56057b69:a9101af0

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : d20f7c1e - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 1d8e74d3:9abd37f8:f2cf0ab8:02fdcfd6

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : 75b22537 - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : ddf17d3d:ea944bfb:6886cc91:3366f55f

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : 45b67ff2 - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 7
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 38675f59:ea412b1f:67d6ed9a:a33fc5dd

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : c68cbbd - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 6
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : b24758e6:042412c5:9b5a3c06:f167aedf

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : ac803ace - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 00e47d82:b49c3905:3ed961fe:40a5f259

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : fb370bbe - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : a7e34040:fa12382f:c2ef3d85:9c95b1d0

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : e093888c - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 4
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 9d89c55d:9f4a2181:6b87922f:0681d580

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : aa79f183 - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 5
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)


______________________________________________



-- 
Guillaume Paumier

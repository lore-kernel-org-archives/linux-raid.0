From: Pierre =?iso-8859-1?q?Vign=E9ras?= <pierre@vigneras.name>
Subject: Re: mdadm: failed devices become spares!
Date: Mon, 17 May 2010 20:10:36 +0200
Message-ID: <201005172010.36157.pierre@vigneras.name>
References: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On dimanche 16 mai 2010, Leslie Rhorer wrote:
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Pierre Vign=E9ras
> > Sent: Sunday, May 16, 2010 10:41 AM
> > To: linux-raid@vger.kernel.org
> > Subject: mdadm: failed devices become spares!
> >
> > Hi,
> >
> > I encountered a critical problem with mdadm that I submitted to the
> > Debian mailing list (it's a debian lenny/stable). They asked me to =
submit
> > this to you. So that's what I do.
> >
> > To prevent duplication of description/information, I give you the U=
RL of
> > that
> > bug description:
> >
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D578352
> >
> > If you prefer the full stuff to be copy/pasted to that mailing list=
, just
> > ask
> > for it.
> >
> > Note: that bug happened again today, on another RAID array. So the =
good
> > news
> > is that it is somewhat reproducible! The bad news, is that unless y=
ou
> > have a
> > magic solution, all my data are just lost (half of it was in the ba=
ckup
> > pipe!)...
> >
> > Thanks for any help, and regards.
> > --
> > Pierre Vign=E9ras
>=20
> 	It's not quite clear to me from the link whether your drives are
> truly toast, or not.  If they are, then you are hosed.  Assuming not,=
 then
> you need to use
>=20
> `mdadm --examine /dev/sdxx` and `mdadm -Dt /dev/mdyy`
>=20
> 	to determine precisely all the parameters and the order of the block
> devices in the array.  You need the chunk size, the superblock type, =
which
> slot was occupied by each device in the array (this may not be the sa=
me as
> when the array was created), the size of the array (if it did not fil=
l the
> entire partition in every case), the RAID level, etc.  Once you are c=
ertain
> you have all the information to enable you to re-create the array, if=
 need
> be, the try to re-assemble the array with
>=20
> `mdadm --assemble --force /dev/mdyy`
>=20
> 	If it works, then fsck the file system.  (I think I noticed you are
> using XFS.  If so, do not use XFS_Check.  Instead, use XFS_Repair wit=
h the
> -n option.)  After you have a clean file system, issue the command
>=20
> `echo repair > /sys/block/mdyy/md/sync_action`
>=20
> 	to re-sync the array.  If the array does not assemble, then you will
> need to stop it and re-create it using the options you obtained from =
your
> research above and adding the --assume-clean switch to prevent a resy=
nc if
> something is wrong.  If the fsck won't work after re-creating the arr=
ay,
> then you probably got one or more of the parameters incorrect.

Thanks for your help. Here is what I did:

=20
# cat /proc/mdstat         =20
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]=20
[...]
md2 : inactive sdc1[2](S) sdd1[5](S) sdf1[4](S) sde1[3](S)
      1250274304 blocks                                  =20
[...]                                                         =20
                             =20
# mdadm --examine /dev/sdc1 /dev/sdd1 /dev/sdf1 /dev/sde1
/dev/sdc1:                                            =20
          Magic : a92b4efc                            =20
        Version : 00.90.00                            =20
           UUID : b34f4192:f823df58:24bf28c1:396de87f (local to host ph=
obos)
  Creation Time : Thu Aug  6 01:59:44 2009                             =
    =20
     Raid Level : raid10                                               =
    =20
  Used Dev Size : 312568576 (298.09 GiB 320.07 GB)                     =
    =20
     Array Size : 625137152 (596.18 GiB 640.14 GB)                     =
    =20
   Raid Devices : 4                                                    =
    =20
  Total Devices : 4                                                    =
    =20
Preferred Minor : 2                                                    =
    =20

    Update Time : Tue Apr 13 19:22:21 2010
          State : clean                  =20
Internal Bitmap : present                =20
 Active Devices : 2                      =20
Working Devices : 4                      =20
 Failed Devices : 0                      =20
  Spare Devices : 2                      =20
       Checksum : 5baf7939 - correct     =20
         Events : 90612                  =20

         Layout : near=3D2, far=3D1
     Chunk Size : 64K         =20

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      spare   /dev/sdf1     =20
   5     5       8       49        5      spare   /dev/sdd1     =20
/dev/sdd1:                                                      =20
          Magic : a92b4efc                                      =20
        Version : 00.90.00                                      =20
           UUID : b34f4192:f823df58:24bf28c1:396de87f (local to host ph=
obos)
  Creation Time : Thu Aug  6 01:59:44 2009                             =
    =20
     Raid Level : raid10                                               =
    =20
  Used Dev Size : 312568576 (298.09 GiB 320.07 GB)                     =
    =20
     Array Size : 625137152 (596.18 GiB 640.14 GB)                     =
    =20
   Raid Devices : 4                                                    =
    =20
  Total Devices : 4                                                    =
    =20
Preferred Minor : 2                                                    =
    =20

    Update Time : Tue Apr 13 19:22:21 2010
          State : clean                  =20
Internal Bitmap : present                =20
 Active Devices : 2                      =20
Working Devices : 4                      =20
 Failed Devices : 0                      =20
  Spare Devices : 2                      =20
       Checksum : 5baf7949 - correct     =20
         Events : 90612                  =20

         Layout : near=3D2, far=3D1
     Chunk Size : 64K         =20

      Number   Major   Minor   RaidDevice State
this     5       8       49        5      spare   /dev/sdd1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      spare   /dev/sdf1     =20
   5     5       8       49        5      spare   /dev/sdd1     =20
/dev/sdf1:                                                      =20
          Magic : a92b4efc                                      =20
        Version : 00.90.00                                      =20
           UUID : b34f4192:f823df58:24bf28c1:396de87f (local to host ph=
obos)
  Creation Time : Thu Aug  6 01:59:44 2009                             =
    =20
     Raid Level : raid10                                               =
    =20
  Used Dev Size : 312568576 (298.09 GiB 320.07 GB)                     =
    =20
     Array Size : 625137152 (596.18 GiB 640.14 GB)                     =
    =20
   Raid Devices : 4                                                    =
    =20
  Total Devices : 4                                                    =
    =20
Preferred Minor : 2                                                    =
    =20

    Update Time : Tue Apr 13 19:22:21 2010
          State : clean                  =20
Internal Bitmap : present                =20
 Active Devices : 2                      =20
Working Devices : 4                      =20
 Failed Devices : 0                      =20
  Spare Devices : 2                      =20
       Checksum : 5baf7967 - correct     =20
         Events : 90612                  =20

         Layout : near=3D2, far=3D1
     Chunk Size : 64K         =20

      Number   Major   Minor   RaidDevice State
this     4       8       81        4      spare   /dev/sdf1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      spare   /dev/sdf1
   5     5       8       49        5      spare   /dev/sdd1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : b34f4192:f823df58:24bf28c1:396de87f (local to host ph=
obos)
  Creation Time : Thu Aug  6 01:59:44 2009
     Raid Level : raid10
  Used Dev Size : 312568576 (298.09 GiB 320.07 GB)
     Array Size : 625137152 (596.18 GiB 640.14 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2

    Update Time : Tue Apr 13 19:22:21 2010
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 2
       Checksum : 5baf795b - correct
         Events : 90612

         Layout : near=3D2, far=3D1
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       65        3      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      spare   /dev/sdf1
   5     5       8       49        5      spare   /dev/sdd1

# mdadm -Dt /dev/md2
mdadm: md device /dev/md2 does not appear to be active.
phobos:~#

# mdadm --assemble --force /dev/md2
mdadm: /dev/md2 assembled from 2 drives and 2 spares - not enough to st=
art the=20
array.

#

What I don't get, is how those devices /dev/sdf1 and /dev/sdd1 have bee=
n=20
marked as spares after being marked as faulty! I never asked for it. As=
 shown=20
at the previous Debian Bug link (repeated here for your convenience):

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D578352

<bug description extract>
=2E..
Apr 12 20:10:02 phobos mdadm[3157]: Fail event detected on md device /d=
ev/md2,=20
component device /dev/sdf1
Apr 12 20:11:02 phobos mdadm[3157]: SpareActive event detected on md de=
vice=20
/dev/md2, component device /dev/sdf1=20

Is that last line normal? It seems to me that this failed drive has
been made a spare!  (I really hope that I misunderstood something). Is
it possible that the USB system (with its "plug'n play" sort-of
feature) had made the behaviour of mdadm so strange?

</bug>

And the next question is: how to activate those 2 spare drives? I was=20
expecting mdadm to use them automagically.

Did I miss something, or is there something really strange happening th=
ere?

Thanks again.
--=20
Pierre Vign=E9ras
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

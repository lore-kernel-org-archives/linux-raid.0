From: =?iso-8859-1?Q?Jes=FAs_Rojo_Mart=EDnez?=
	<jrojomartinez@mi.madritel.es>
Subject: Problems with Linux RAID in kernel 2.6
Date: Thu, 10 Mar 2005 19:12:37 +0100
Message-ID: <20050310181237.GA2569@nerv.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>, Jakob =?iso-8859-1?Q?=D8stergaard?= <jakob@ostenfeld.dk>, Neil Brown <neilb@cse.unsw.edu.au>, Miguel de Icaza <miguel@ximian.com>, Gadi Oxman <gadio@netvision.net.il>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

  I have many problems with RAID in kernel 2.6.10.

  First of all, I have the md, raid1,... into the kernel, superblocks i=
n
the RAIDs and "Linux RAID autodetect" as the partition types. Moreover,
I make an initrd. However, when the kernel boots, it doesn't recognize
the RAID disks:

md: raid1 personality registered as nr 3
md: md driver 0.90.1 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
[...]
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.

  And I have four RAID disks (/dev/md[1-4]) bind on /dev/sdb[1-4] and
/dev/sdc[1-4].


  Secondly, I try to get up the RAID disks manually and the most times
it fails:

centralmad:~# cat /proc/mdstat=20
Personalities : [raid1]=20
unused devices: <none>
centralmad:~#=20
centralmad:~# raidstart /dev/md2=20
/dev/md2: Invalid argument                     <-- Why did it say it?
centralmad:~# cat /proc/mdstat=20
Personalities : [raid1]=20
md2 : active raid1 sdc2[0] sdb2[1]	       <-- Although It seems to run =
Ok
      14651200 blocks [2/2] [UU]
     =20
unused devices: <none>


  And dmesg says:

md: raidstart(pid 2944) used deprecated START_ARRAY ioctl. This will no=
t	<-- !!!
be supported beyond 2.6								<-- !!!
md: could not bd_claim sda2.							<-- I have a =ABfailured disk=BB
md: autostart failed!								<-- !!! Is it because the failured dik?
md: raidstart(pid 2944) used deprecated START_ARRAY ioctl. This will no=
t
be supported beyond 2.6
md: autorun ...
md: considering sdc2 ...
md:  adding sdc2 ...
md:  adding sdb2 ...
md: created md2
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2>
raid1: raid set md2 active with 2 out of 2 mirrors
md: ... autorun DONE.

  Maybe raidstart need to change the ioctl to use. I have raidtools2
version 1.00.3-17 (Debian package in Sarge). A strace of that command
shows:

[...]
open("/dev/md2", O_RDWR)                =3D 3
fstat64(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(9, 2), ...}) =3D =
0
ioctl(3, 0x800c0910, 0xbfffefb0)        =3D 0
fstat64(3, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(9, 2), ...}) =3D =
0
ioctl(3, 0x800c0910, 0xbffff070)        =3D 0
ioctl(3, 0x400c0930, 0xbffff100)        =3D -1 EINVAL (Invalid argument=
)
write(2, "mdadm: failed to run array /dev/"..., 54mdadm: failed to run
array /dev/md2: Invalid argument
) =3D 54
close(3)                                =3D 0
exit_group(1)                           =3D ?


  Raidstop seems not to have problems:

md: md2 stopped.
md: unbind<sdc2>
md: export_rdev(sdc2)
md: unbind<sdb2>
md: export_rdev(sdb2)

  And with mdadm also fails:

centralmad:~# mdadm -R /dev/md2=20
mdadm: failed to run array /dev/md2: Invalid argument
centralmad:~# cat /proc/mdstat=20
Personalities : [raid1]=20
unused devices: <none>

  Moreover, dmesg says the md driver fails:

md: bug in file drivers/md/md.c, line 1514

md:     **********************************
md:     * <COMPLETE RAID STATE PRINTOUT> *
md:     **********************************
md2:=20
md0:=20
md:     **********************************


  That line is in the function =ABstatic int do_md_run(mddev_t * mddev)=
=BB,
and the code that produce the bug is:

        if (list_empty(&mddev->disks)) {
                MD_BUG();
                return -EINVAL;
        }


  Again, with =ABmdadm -S /dev/md2=BB there are no problems to stop the
RAID.


  Here there are more information about my sistem. It is a Debian Sarge
with kernel 2.6, RAID 1 and SATA disks.

centralmad:~# mdadm -E /dev/sdb2=20
/dev/sdb2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8c51d044:cb84e69a:64968ecd:2e36133c
  Creation Time : Sun Mar  6 16:11:00 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2

    Update Time : Mon Mar  7 17:59:30 2005
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 1906699c - correct
         Events : 0.1491


      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       8       34        0      active sync   /dev/sdc2
   1     1       8       18        1      active sync   /dev/sdb2



  Why do these problems occur? How can I/You solve them?

  Thanks a lot. I will wait your response.


  Regards,

--=20

		--- Jes=FAs Rojo Mart=EDnez. ---


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

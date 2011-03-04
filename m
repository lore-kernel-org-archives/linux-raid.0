From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: Impact of missing parameter during mdadm create
Date: Thu, 3 Mar 2011 23:55:58 -0500
Message-ID: <BAY148-w62ED1C087E0BA99B49301BEFC20@phx.gbl>
References: <BAY148-w11FE2CD7493A098E62E08DEFC10@phx.gbl>,<1299150410.10282.14.camel@tankquad>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1299150410.10282.14.camel@tankquad>
Sender: linux-raid-owner@vger.kernel.org
To: linuxraid@kendrummond.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Thu, 3 Mar 2011 21:06:50 +1000 <linuxraid@kendrummond.com> wrote:
> > On Tue, 2011-03-01 at 13:38 -0500, Mike Viau wrote:
> > QUESTION: What does '(auto-read-only)' mean?
>
> auto-read-only means the array is read-only until the first write is
> attempted at which point it will become read-write.
>

Thanks for the info.

> > cat /etc/mdadm/mdadm.conf
> > # mdadm.conf
> > #
> > # Please refer to mdadm.conf(5) for information about this file.
> > #
> >
> > # by default, scan all partitions (/proc/partitions) for MD superbl=
ocks.
> > # alternatively, specify devices to scan, using wildcards if desire=
d.
> > DEVICE partitions containers
> >
> > # auto-create devices with Debian standard permissions
> > CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
> >
> > # automatically tag new arrays as belonging to the local system
> > HOMEHOST
> >
> > # definitions of existing MD arrays
> > ARRAY /dev/md/0 metadata=3D1.2 UUID=3D7d8a7c68:95a230d0:0a8f6e74:4c=
8f81e9 name=3DXEN-HOST:0
> >
>
> I'm not sure if specifying /dev/md/0 is the same as /dev/md0, but I u=
se
> the /dev/mdX format and things seem to work for me.
>



Thanks I updated my config to use the /dev/mdX format and updated my ke=
rnel's initramfs as well.


> >
> >
> > In trying to fix the problem I
attempted to change the preferred minor of an MD array (RAID) by follow
these instructions.
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > # you need to manually assemble the array to change the preferred m=
inor
> > # if you manually assemble, the superblock will be updated to refle=
ct
> > # the preferred minor as you indicate with the assembly.
> > # for example, to set the preferred minor to 4:
> > mdadm --assemble /dev/md4 /dev/sd[abc]1
> >
> > # this only works on 2.6 kernels, and only for RAID levels of 1 and=
 above.
> >
> >
> > mdadm --assemble /dev/md0 /dev/sd{a,b,d}1 -vvv
> > mdadm: looking for devices for /dev/md0
> > mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
> > mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> > mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> > mdadm: added /dev/sdb1 to /dev/md0 as 1
> > mdadm: added /dev/sdd1 to /dev/md0 as 2
> > mdadm: added /dev/sda1 to /dev/md0 as 0
> > mdadm: /dev/md0 has been started with 2 drives (out of 3) and 1 reb=
uilding.
> >
> >
>
> So because I specified all the drives, I assume this is the same
things as assembling the RAID degraded and then manually re-adding the
last one (/dev/sdd1).
> >
>
> So if you wait for the resync to complete, what happens if you:
>
> mdadm -S /dev/md0
> mdadm -Av /dev/md0

I allowed the resync to complete and when stopping the array and then a=
ssembling all three drives assembled again.

After a system reboot though, the mdadm raid 5 array was only automatic=
ally assembled with /dev/sd{a,b}1.

mdadm -Av /dev/md0 would also start the array degraded with  /dev/sd{a,=
b}1 only unless all three drives were manually specified when assemblin=
g the array, so this doesn't help=A0 :(


Back tracking a bit... by re-worded one of my previous questions:

Where does the mdadm -D /dev/md0 command get the Major/Minor informatio=
n for each drive that is a member of the array from?=20

Does this information have to _exactly_ match the Major/Minor of the bl=
ock devices on the system in order for the array to be built automatica=
lly on system start up? When I created the raid 5 array I passed 'missi=
ng' in place of the block-device/partition that is now /dev/sdd1 (the t=
hird drive in the array).

I searched through the hexdump of my array drives (starting at 0x1000 w=
here the Superblock began), but I could not detect where the major/mino=
r were stored on the drive.


Without knowing exactly what information or where the information is up=
dated for the Major/Minor information, I ran:

mdadm --assemble /dev/md0 --update=3Dhomehost=A0=A0 (To change the home=
host as recorded in the superblock. For version-1 superblocks, this inv=
olves updating the name.)

and

mdadm --assemble /dev/md0 --update=3Dsuper-minor (To update the preferr=
ed minor field on each superblock to match the minor number of=A0 the a=
rray being assembled)


Now the system still unfortunately reboots with 2 of 3 drives in the ar=
ray (degraded), but manually assembly now _works_ by running mdadm -Av =
/dev/md0 (which produces):

mdadm: looking for devices for /dev/md0
mdadm: no RAID superblock on /dev/dm-6
mdadm: /dev/dm-6 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-5
mdadm: /dev/dm-5 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-4
mdadm: /dev/dm-4 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-3
mdadm: /dev/dm-3 has wrong uuid.
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: /dev/dm-2 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-1
mdadm: /dev/dm-1 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-0
mdadm: /dev/dm-0 has wrong uuid.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdc7: Device or resource busy
mdadm: /dev/sdc7 has wrong uuid.
mdadm: cannot open device /dev/sdc6: Device or resource busy
mdadm: /dev/sdc6 has wrong uuid.
mdadm: cannot open device /dev/sdc5: Device or resource busy
mdadm: /dev/sdc5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc2
mdadm: /dev/sdc2 has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
mdadm: added /dev/sdb1 to /dev/md0 as 1
mdadm: added /dev/sdd1 to /dev/md0 as 2
mdadm: added /dev/sda1 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 3 drives.


Additionally the tail of mdadm -D /dev/md0 has changed and now shows:

=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda1
=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=A0=
=A0=A0 1=A0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
=A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 49=A0=A0=A0=A0=
=A0=A0 2=A0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdd1


Rather than (previously):

=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=
=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda1
=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=A0=
=A0 1=A0=A0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
=A0=A0=A0=A0=A0=A0 2 =A0=A0=A0=A0=A0 0 =A0=A0=A0=A0=A0 0 =A0=A0=A0=A0=A0=
=A0 2=A0=A0=A0=A0=A0=A0=A0 removed


QUESTION: Is that normal that the details output has incremented a Numb=
er as indicated in the first column? (e.g: 2 changing to 3 on a raid 5 =
array of only 5 drives with no spares)


When the array is manually assembled the state is now considered 'clean=
=2E'

mdadm -D /dev/md0
/dev/md0:
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0 Creation Time : Mon Dec 20 09:48:07 2010
=A0=A0=A0=A0 Raid Level : raid5
=A0=A0=A0=A0 Array Size : 1953517568 (1863.02 GiB 2000.40 GB)
=A0 Used Dev Size : 976758784 (931.51 GiB 1000.20 GB)
=A0=A0 Raid Devices : 3
=A0 Total Devices : 3
=A0=A0=A0 Persistence : Superblock is persistent

=A0=A0=A0 Update Time : Thu Mar=A0 3 23:12:23 2011
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0Active Devices : 3
Working Devices : 3
=A0Failed Devices : 0
=A0 Spare Devices : 0


cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md0 : active (auto-read-only) raid5 sda1[0] sdd1[3] sdb1[1]
=A0=A0=A0=A0=A0 1953517568 blocks super 1.2 level 5, 512k chunk, algori=
thm 2 [3/3] [UUU]
=A0=A0=A0=A0=A0=20
unused devices: <none>



> If it has, and still comes up as degraded on reboot it may pay to add=
 a
> bitmap; to make resyncs much quicker while working this out.
>

Could you please explain what you mean further?

I have a feeling I will not going to be so lucky in identifying this de=
graded array after rebooting problem in the near future, but would like=
 to make my efforts more efficient if possible.

I am very determined, find the solution :)


-M

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

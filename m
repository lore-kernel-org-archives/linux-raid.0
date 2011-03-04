From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: Impact of missing parameter during mdadm create
Date: Fri, 4 Mar 2011 00:01:04 -0500
Message-ID: <BAY148-w44131E0410876344156C70EFC20@phx.gbl>
References: <BAY148-w11FE2CD7493A098E62E08DEFC10@phx.gbl>,<1299150410.10282.14.camel@tankquad>,<BAY148-w62ED1C087E0BA99B49301BEFC20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w62ED1C087E0BA99B49301BEFC20@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linuxraid@kendrummond.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> > On Thu, 3 Mar 2011 21:06:50 +1000  wrote:
> > > On Tue, 2011-03-01 at 13:38 -0500, Mike Viau wrote:
> > > QUESTION: What does '(auto-read-only)' mean?
> >
> > auto-read-only means the array is read-only until the first write is
> > attempted at which point it will become read-write.
> >
>
> Thanks for the info.
>
> > > cat /etc/mdadm/mdadm.conf
> > > # mdadm.conf
> > > #
> > > # Please refer to mdadm.conf(5) for information about this file.
> > > #
> > >
> > > # by default, scan all partitions (/proc/partitions) for MD superblocks.
> > > # alternatively, specify devices to scan, using wildcards if desired.
> > > DEVICE partitions containers
> > >
> > > # auto-create devices with Debian standard permissions
> > > CREATE owner=root group=disk mode=0660 auto=yes
> > >
> > > # automatically tag new arrays as belonging to the local system
> > > HOMEHOST
> > >
> > > # definitions of existing MD arrays
> > > ARRAY /dev/md/0 metadata=1.2 UUID=7d8a7c68:95a230d0:0a8f6e74:4c8f81e9 name=XEN-HOST:0
> > >
> >
> > I'm not sure if specifying /dev/md/0 is the same as /dev/md0, but I use
> > the /dev/mdX format and things seem to work for me.
> >
>
>
>
> Thanks I updated my config to use the /dev/mdX format and updated my kernel's initramfs as well.
>
>
> > >
> > >
> > > In trying to fix the problem I
> attempted to change the preferred minor of an MD array (RAID) by follow
> these instructions.
> > > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > # you need to manually assemble the array to change the preferred minor
> > > # if you manually assemble, the superblock will be updated to reflect
> > > # the preferred minor as you indicate with the assembly.
> > > # for example, to set the preferred minor to 4:
> > > mdadm --assemble /dev/md4 /dev/sd[abc]1
> > >
> > > # this only works on 2.6 kernels, and only for RAID levels of 1 and above.
> > >
> > >
> > > mdadm --assemble /dev/md0 /dev/sd{a,b,d}1 -vvv
> > > mdadm: looking for devices for /dev/md0
> > > mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
> > > mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> > > mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> > > mdadm: added /dev/sdb1 to /dev/md0 as 1
> > > mdadm: added /dev/sdd1 to /dev/md0 as 2
> > > mdadm: added /dev/sda1 to /dev/md0 as 0
> > > mdadm: /dev/md0 has been started with 2 drives (out of 3) and 1 rebuilding.
> > >
> > >
> >
> > So because I specified all the drives, I assume this is the same
> things as assembling the RAID degraded and then manually re-adding the
> last one (/dev/sdd1).
> > >
> >
> > So if you wait for the resync to complete, what happens if you:
> >
> > mdadm -S /dev/md0
> > mdadm -Av /dev/md0
>
> I allowed the resync to complete and when stopping the array and then assembling all three drives assembled again.
>
> After a system reboot though, the mdadm raid 5 array was only automatically assembled with /dev/sd{a,b}1.
>
> mdadm -Av /dev/md0 would also start the array degraded with /dev/sd{a,b}1 only unless all three drives were manually specified when assembling the array, so this doesn't help  :(
>
>
> Back tracking a bit... by re-worded one of my previous questions:
>
> Where does the mdadm -D /dev/md0 command get the Major/Minor information for each drive that is a member of the array from?
>
> Does this information have to _exactly_ match the Major/Minor of the block devices on the system in order for the array to be built automatically on system start up? When I created the raid 5 array I passed 'missing' in place of the block-device/partition that is now /dev/sdd1 (the third drive in the array).
>
> I searched through the hexdump of my array drives (starting at 0x1000 where the Superblock began), but I could not detect where the major/minor were stored on the drive.
>
>
> Without knowing exactly what information or where the information is updated for the Major/Minor information, I ran:
>
> mdadm --assemble /dev/md0 --update=homehost   (To change the homehost as recorded in the superblock. For version-1 superblocks, this involves updating the name.)
>
> and
>
> mdadm --assemble /dev/md0 --update=super-minor (To update the preferred minor field on each superblock to match the minor number of  the array being assembled)
>
>
> Now the system still unfortunately reboots with 2 of 3 drives in the array (degraded), but manually assembly now _works_ by running mdadm -Av /dev/md0 (which produces):
>
> mdadm: looking for devices for /dev/md0
> mdadm: no RAID superblock on /dev/dm-6
> mdadm: /dev/dm-6 has wrong uuid.
> mdadm: no RAID superblock on /dev/dm-5
> mdadm: /dev/dm-5 has wrong uuid.
> mdadm: no RAID superblock on /dev/dm-4
> mdadm: /dev/dm-4 has wrong uuid.
> mdadm: no RAID superblock on /dev/dm-3
> mdadm: /dev/dm-3 has wrong uuid.
> mdadm: cannot open device /dev/dm-2: Device or resource busy
> mdadm: /dev/dm-2 has wrong uuid.
> mdadm: no RAID superblock on /dev/dm-1
> mdadm: /dev/dm-1 has wrong uuid.
> mdadm: no RAID superblock on /dev/dm-0
> mdadm: /dev/dm-0 has wrong uuid.
> mdadm: no RAID superblock on /dev/sde
> mdadm: /dev/sde has wrong uuid.
> mdadm: no RAID superblock on /dev/sdd
> mdadm: /dev/sdd has wrong uuid.
> mdadm: cannot open device /dev/sdc7: Device or resource busy
> mdadm: /dev/sdc7 has wrong uuid.
> mdadm: cannot open device /dev/sdc6: Device or resource busy
> mdadm: /dev/sdc6 has wrong uuid.
> mdadm: cannot open device /dev/sdc5: Device or resource busy
> mdadm: /dev/sdc5 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdc2
> mdadm: /dev/sdc2 has wrong uuid.
> mdadm: cannot open device /dev/sdc1: Device or resource busy
> mdadm: /dev/sdc1 has wrong uuid.
> mdadm: cannot open device /dev/sdc: Device or resource busy
> mdadm: /dev/sdc has wrong uuid.
> mdadm: no RAID superblock on /dev/sdb
> mdadm: /dev/sdb has wrong uuid.
> mdadm: no RAID superblock on /dev/sda
> mdadm: /dev/sda has wrong uuid.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
> mdadm: added /dev/sdb1 to /dev/md0 as 1
> mdadm: added /dev/sdd1 to /dev/md0 as 2
> mdadm: added /dev/sda1 to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 3 drives.
>
>
> Additionally the tail of mdadm -D /dev/md0 has changed and now shows:
>
>    Number   Major   Minor   RaidDevice State
>        0       8        1        0       active sync   /dev/sda1
>        1       8       17       1       active sync   /dev/sdb1
>        3       8       49       2       active sync   /dev/sdd1
>
>
> Rather than (previously):
>
>    Number   Major   Minor   RaidDevice State
>        0       8        1       0        active sync   /dev/sda1
>        1       8       17      1        active sync   /dev/sdb1
>        2       0       0        2        removed
>
>
> QUESTION: Is that normal that the details output has incremented a Number as indicated in the first column? (e.g: 2 changing to 3 on a raid 5 array of only 5 drives with no spares)

EDIT: that should have read "on a raid 5 array of only 3 drives with no spares"

>
>
> When the array is manually assembled the state is now considered 'clean.'
>
> mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Mon Dec 20 09:48:07 2010
>      Raid Level : raid5
>      Array Size : 1953517568 (1863.02 GiB 2000.40 GB)
>   Used Dev Size : 976758784 (931.51 GiB 1000.20 GB)
>    Raid Devices : 3
>   Total Devices : 3
>     Persistence : Superblock is persistent
>
>     Update Time : Thu Mar  3 23:12:23 2011
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>
>
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active (auto-read-only) raid5 sda1[0] sdd1[3] sdb1[1]
>       1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
>
> unused devices: 
>
>
>
> > If it has, and still comes up as degraded on reboot it may pay to add a
> > bitmap; to make resyncs much quicker while working this out.
> >
>
> Could you please explain what you mean further?
>
> I have a feeling I will not going to be so lucky in identifying this degraded array after rebooting problem in the near future, but would like to make my efforts more efficient if possible.
>
> I am very determined, find the solution :)
>
>
> -M
 		 	   		  
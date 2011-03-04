From: Ken Drummond <linuxraid@kendrummond.com>
Subject: RE: Impact of missing parameter during mdadm create
Date: Fri, 04 Mar 2011 17:36:13 +1000
Message-ID: <1299224173.4392.41.camel@tankquad>
References: <BAY148-w11FE2CD7493A098E62E08DEFC10@phx.gbl>
	 ,<1299150410.10282.14.camel@tankquad>
	 ,<BAY148-w62ED1C087E0BA99B49301BEFC20@phx.gbl>
	 <BAY148-w44131E0410876344156C70EFC20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w44131E0410876344156C70EFC20@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2011-03-04 at 00:01 -0500, Mike Viau wrote:
> > > On Thu, 3 Mar 2011 21:06:50 +1000  wrote:
> > > > On Tue, 2011-03-01 at 13:38 -0500, Mike Viau wrote:
> >
> > > > cat /etc/mdadm/mdadm.conf
> > > > # mdadm.conf
> > > > #
> > > > # Please refer to mdadm.conf(5) for information about this file.
> > > > #
> > > >
> > > > # by default, scan all partitions (/proc/partitions) for MD superblocks.
> > > > # alternatively, specify devices to scan, using wildcards if desired.
> > > > DEVICE partitions containers
> > > >
> > > > # auto-create devices with Debian standard permissions
> > > > CREATE owner=root group=disk mode=0660 auto=yes
> > > >
> > > > # automatically tag new arrays as belonging to the local system
> > > > HOMEHOST
> > > >
> > > > # definitions of existing MD arrays
> > > > ARRAY /dev/md/0 metadata=1.2 UUID=7d8a7c68:95a230d0:0a8f6e74:4c8f81e9 name=XEN-HOST:0
> > > >
> > >
> > > I'm not sure if specifying /dev/md/0 is the same as /dev/md0, but I use
> > > the /dev/mdX format and things seem to work for me.
> > >
> >
> >
> >
> > Thanks I updated my config to use the /dev/mdX format and updated my kernel's initramfs as well.
> >

Can you post the output of "dmesg | grep md" after a reboot?  

Alternatively you might like to review your system log for what is
happening during the boot.

> >
> > > >
> > > >
> > > > In trying to fix the problem I
> > attempted to change the preferred minor of an MD array (RAID) by follow
> > these instructions.
> > > > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > # you need to manually assemble the array to change the preferred minor
> > > > # if you manually assemble, the superblock will be updated to reflect
> > > > # the preferred minor as you indicate with the assembly.
> > > > # for example, to set the preferred minor to 4:
> > > > mdadm --assemble /dev/md4 /dev/sd[abc]1
> > > >
> > > > # this only works on 2.6 kernels, and only for RAID levels of 1 and above.
> > > >
> > > >
> > > > mdadm --assemble /dev/md0 /dev/sd{a,b,d}1 -vvv
> > > > mdadm: looking for devices for /dev/md0
> > > > mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
> > > > mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> > > > mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> > > > mdadm: added /dev/sdb1 to /dev/md0 as 1
> > > > mdadm: added /dev/sdd1 to /dev/md0 as 2
> > > > mdadm: added /dev/sda1 to /dev/md0 as 0
> > > > mdadm: /dev/md0 has been started with 2 drives (out of 3) and 1 rebuilding.
> > > >
> > > >
> > >
> > > So because I specified all the drives, I assume this is the same
> > things as assembling the RAID degraded and then manually re-adding the
> > last one (/dev/sdd1).
> > > >
> > >
> > > So if you wait for the resync to complete, what happens if you:
> > >
> > > mdadm -S /dev/md0
> > > mdadm -Av /dev/md0
> >
> > I allowed the resync to complete and when stopping the array and then assembling all three drives assembled again.
> >
> > After a system reboot though, the mdadm raid 5 array was only automatically assembled with /dev/sd{a,b}1.
> >
> > mdadm -Av /dev/md0 would also start the array degraded with /dev/sd{a,b}1 only 
> > unless all three drives were manually specified when assembling the array, so this doesn't help  :(
> >

So you're saying that "mdadm -Av /dev/md0" assembled the array
completely before a reboot but didn't do the same after a reboot?

> >
> > Back tracking a bit... by re-worded one of my previous questions:
> >
> > Where does the mdadm -D /dev/md0 command get the Major/Minor information 
> > for each drive that is a member of the array from?

I might be mistaken, but I think you are confusing the Major/Minor of
the devices making up the array and the Major/Minor of the md device
itself.  You can specify the actual component device names in the
mdadm.conf file but this is not a good option because those device names
change between reboots which I why I specify the UUID of the the array
and is also what you have done.  mdadm then scans all devices looking
for that UUID.  From what you have provided it seems that all three
devices have the array UUID set correctly.

> >
> > Does this information have to _exactly_ match the Major/Minor of the block devices on the system in order for the array to be built automatically on system start up? When I created the raid 5 array I passed 'missing' in place of the block-device/partition that is now /dev/sdd1 (the third drive in the array).
> >
> > I searched through the hexdump of my array drives (starting at 0x1000 where the Superblock began), but I could not detect where the major/minor were stored on the drive.
> >
> >
> > Without knowing exactly what information or where the information is updated for the Major/Minor information, I ran:
> >
> > mdadm --assemble /dev/md0 --update=homehost   (To change the homehost as recorded in the superblock. For version-1 superblocks, this involves updating the name.)
> >

So can you post the output

mdadm -D /dev/md0
mdadm -E /dev/sd{b,d,a}1

and the contents of mdadm.conf as they currently stand.

along with the "dmesg | grep md" straight after a reboot as requested
above.

> > and
> >
> > mdadm --assemble /dev/md0 --update=super-minor (To update the preferred minor field on each superblock to match the minor number of  the array being assembled)
> >
> >
> > Now the system still unfortunately reboots with 2 of 3 drives in the array 
> > (degraded), but manually assembly now _works_ by running mdadm -Av /dev/md0 
> > (which produces):
> >
> > mdadm: looking for devices for /dev/md0
> > mdadm: no RAID superblock on /dev/dm-6
> > mdadm: /dev/dm-6 has wrong uuid.
> > mdadm: no RAID superblock on /dev/dm-5
> > mdadm: /dev/dm-5 has wrong uuid.
> > mdadm: no RAID superblock on /dev/dm-4
> > mdadm: /dev/dm-4 has wrong uuid.
> > mdadm: no RAID superblock on /dev/dm-3
> > mdadm: /dev/dm-3 has wrong uuid.
> > mdadm: cannot open device /dev/dm-2: Device or resource busy
> > mdadm: /dev/dm-2 has wrong uuid.
> > mdadm: no RAID superblock on /dev/dm-1
> > mdadm: /dev/dm-1 has wrong uuid.
> > mdadm: no RAID superblock on /dev/dm-0
> > mdadm: /dev/dm-0 has wrong uuid.
> > mdadm: no RAID superblock on /dev/sde
> > mdadm: /dev/sde has wrong uuid.
> > mdadm: no RAID superblock on /dev/sdd
> > mdadm: /dev/sdd has wrong uuid.
> > mdadm: cannot open device /dev/sdc7: Device or resource busy
> > mdadm: /dev/sdc7 has wrong uuid.
> > mdadm: cannot open device /dev/sdc6: Device or resource busy
> > mdadm: /dev/sdc6 has wrong uuid.
> > mdadm: cannot open device /dev/sdc5: Device or resource busy
> > mdadm: /dev/sdc5 has wrong uuid.
> > mdadm: no RAID superblock on /dev/sdc2
> > mdadm: /dev/sdc2 has wrong uuid.
> > mdadm: cannot open device /dev/sdc1: Device or resource busy
> > mdadm: /dev/sdc1 has wrong uuid.
> > mdadm: cannot open device /dev/sdc: Device or resource busy
> > mdadm: /dev/sdc has wrong uuid.
> > mdadm: no RAID superblock on /dev/sdb
> > mdadm: /dev/sdb has wrong uuid.
> > mdadm: no RAID superblock on /dev/sda
> > mdadm: /dev/sda has wrong uuid.
> > mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> > mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> > mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
> > mdadm: added /dev/sdb1 to /dev/md0 as 1
> > mdadm: added /dev/sdd1 to /dev/md0 as 2
> > mdadm: added /dev/sda1 to /dev/md0 as 0
> > mdadm: /dev/md0 has been started with 3 drives.
> >

So the array does assemble without specifying the component devices on
the mdadm command line?  I thought you said this didn't happen above?

> > > If it has, and still comes up as degraded on reboot it may pay to add a
> > > bitmap; to make resyncs much quicker while working this out.
> > >
> >
> > Could you please explain what you mean further?
> >
> > I have a feeling I will not going to be so lucky in identifying this degraded array after 
> > rebooting problem in the near future, but would like to make my efforts more efficient if possible.

A bitmap stores a data structure where each bit represents a "section"
of the array (the size of that section is determined by the size of the
bitmap) and when any data in a "section" is updated the corresponding
bit is turned on. So if an array is written to while degraded mdadm can
check the bitmap and only resync the changed "sections" when a missing
device is added back.


Ken.


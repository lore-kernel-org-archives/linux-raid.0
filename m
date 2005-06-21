From: Ron Murray <murrayr@dor.state.ma.us>
Subject: Is my raid-1 array working?
Date: Tue, 21 Jun 2005 09:21:49 -0400
Message-ID: <42B8146D.4030004@dor.state.ma.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

    I'm not sure whether this is a RAID problem or an LVM problem. I'll
start here since I can see more weird things happening with RAID than
LVM at the moment.

    I have a Debian testing system running on a Sun box (2 x 400 MHz
Ultrasparc II processors). There are currently three 18G SCSI drives in
it: sda (not used), sdb and sdc (both of which have root partitions of
500M, and the remainder (sd[bc]4)combine to make up md0, a RAID-1
array. This has LVM2 on it to make up the /usr, /home and /var
partitions. Originally there was also an external SCSI disk drive tower,
and I'd used two drives of it in md0 to form another partition.

    Everything ran OK until a week or so ago when I needed to turn the
machine off overnight. Before I brought it up the next morning, I
disconnected the external tower since I wasn't using it and it was
making a lot of noise. When I booted the box, LVM wouldn't start the
volume group because the other two drives were missing. After clearing
that one up, eventually, I could mount the VG, but LVM gave this error:

 > Found duplicate PV xxxxxxxxxxxxxxxx: using /dev/sdc4 not /dev/sdb4

    I couldn't seem to fix this. Eventually I gave up, copied the data 
to another drive, deleted the VG, stopped the array, zeroed the 
superblocks on the drives, and rebuilt the whole thing. Here's what I 
get when I boot the system:

 > input: Sun mouse on su/serio0
 > md: linear personality registered as nr 1
 > md: raid1 personality registered as nr 3
 > md: raid5 personality registered as nr 4
 > raid5: measuring checksumming speed
 >    VIS:      :   120.000 MB/sec
 > raid5: using function: VIS (120.000 MB/sec)
 > md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
 > device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
 >
 >  (5 lines of net-related stuff)
 >
 > md: Autodetecting RAID arrays.
 > md: autorun ...
 > md: ... autorun DONE.
 > kjournald starting. Commit interval 5 seconds
 >
 >  ...
 >
 > All modules loaded.
 > Creating device-mapper devices...done.
 > Creating device-mapper devices...done.
 > Setting up LVM Volume groups...
 >   Reading all physical volumes. This may take a while...
 >   Found duplicate PV tS784Ip4IRpt8EwL84tETKpe1H4A11IG: using 
/dev/sdc4 not /dev/sdb4
 >   Found volume group "curly_vg" using metadata type lvm2
 >   Found duplicate PV tS784Ip4IRpt8EwL84tETKpe1H4A11IG: using 
/dev/sdc4 not /dev/sdb4
 >   3 logical volume(s) in volume group "curly-vg" now active

    So I still have the "Found duplicate" problem. A little more poking
around with mdadm made me wonder whether the RAID array is working at
all. I get conflicting results.

/proc/mdstat has this:
 > Personalities : [linear] [raid1] [raid5]
 > unused devices: <none>

mdadm -Q /dev/md0 gets me:
 > /dev/md0: is an md device which is not active
 > /dev/md0: is too small to be an md component.

mdadm -Q /dev/sdb4 gets me:
 > /dev/sdb4: is not an md array
 > /dev/sdb4: device 0 in 2 device undetected raid1 md0.  Use mdadm 
--examine for more detail.

mdadm -Q /dev/sdc4 gets me:
 > /dev/sdc4: is not an md array
 > /dev/sdc4: device 1 in 2 device undetected raid1 md0.  Use mdadm 
--examine for more detail.

mdadm -D /dev/md0 has:
 > mdadm: md device /dev/md0 does not appear to be active.

On the other hand, mdadm --examine /dev/sdb4 gets me:
 > /dev/sdb4:
 >           Magic : a92b4efc
 >         Version : 00.90.00
 >            UUID : a138d961:627a9a93:d92158f3:f4e786e0
 >   Creation Time : Mon Jun 20 11:43:17 2005
 >      Raid Level : raid1
 >    Raid Devices : 2
 >   Total Devices : 2
 > Preferred Minor : 0
 >
 >     Update Time : Mon Jun 20 13:07:57 2005
 >           State : clean
 >  Active Devices : 2
 > Working Devices : 2
 >  Failed Devices : 0
 >   Spare Devices : 0
 >        Checksum : 1567d8d - correct
 >          Events : 0.12756
 >
 >
 >       Number   Major   Minor   RaidDevice State
 > this     0       8       20        0      active sync 
/dev/.static/dev/sdb4
 >
 >    0     0       8       20        0      active sync 
/dev/.static/dev/sdb4
 >    1     1       8       36        1      active sync 
/dev/.static/dev/sdc4

and mdadm --examine /dev/sdc4:
 > /dev/sdc4:
 >           Magic : a92b4efc
 >         Version : 00.90.00
 >            UUID : a138d961:627a9a93:d92158f3:f4e786e0
 >   Creation Time : Mon Jun 20 11:43:17 2005
 >      Raid Level : raid1
 >    Raid Devices : 2
 >   Total Devices : 2
 > Preferred Minor : 0
 >
 >     Update Time : Mon Jun 20 13:07:57 2005
 >           State : clean
 >  Active Devices : 2
 > Working Devices : 2
 >  Failed Devices : 0
 >   Spare Devices : 0
 >        Checksum : 1567d9f - correct
 >          Events : 0.12756
 >
 >
 >       Number   Major   Minor   RaidDevice State
 > this     1       8       36        1      active sync 
/dev/.static/dev/sdc4
 >
 >    0     0       8       20        0      active sync 
/dev/.static/dev/sdb4
 >    1     1       8       36        1      active sync 
/dev/.static/dev/sdc4

The results of mdadm --examine --scan are:
 > ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=a138d961:627a9a93:d92158f3:f4e786e0
 >    devices=/dev/sdc4,/dev/sdb4

and the contents /etc/mdadm/mdadm.conf are:
 > DEVICE /dev/sd*[0-9]
 > ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=3570b3b2:58eaa1de:4064ed19:b8b2607b

    mdadm version is 1.9.0, and I'm running kernel 2.6.11.

    I suspect that the RAID array isn't working, and that LVM has picked
one of the two disks and is using that. Is that likely? What do I need
to do at this point?

Thanks,

  .....Ron

**********************************************************************
This email and any files transmitted with it are confidential and 
intended solely for the use of the individual or entity to whom they   
are addressed. If you have received this email in error please notify 
the system manager at postmaster at dor.state.ma.us.
**********************************************************************

From: Jeff Kadonoff <jeffk@quotemedia.com>
Subject: md multipath, sun t3 partner group, multinode cluster
Date: 23 Feb 2004 11:31:35 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1077564695.28587.141.camel@apogee>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am trying to set up a 2 node cluster using linux 2.4.21 and a sun t3
partner group.

I have set up the multipath md like so:

raiddev                 /dev/md0
raid-level              multipath
nr-raid-disks           1
nr-spare-disks          1
chunk-size              4
device                  /dev/sdf1
raid-disk               0
device                  /dev/sdb1
spare-disk              1

The mkraid wouldn't work until I poke the second device with an fdisk,
wait for the t3 to switch paths and then write the partition map.

# /sbin/mkraid -R /dev/md0
DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/sdf1, 69930913kB, raid superblock at 69930816kB
couldn't open device /dev/sdb1 -- No such device or address
mkraid: aborted.
(In addition to the above messages, see the syslog and /proc/mdstat as
well for potential clues.)

# /sbin/fdisk /dev/sdb
 
Unable to read /dev/sdb

---- wait a bit for the failover to occur -----

# /sbin/fdisk /dev/sdb
 
The number of cylinders for this disk is set to 8706.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)
 
Command (m for help): w
The partition table has been altered!
 
Calling ioctl() to re-read partition table.
Syncing disks.

# /sbin/mkraid -R /dev/md0
DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/sdf1, 69930913kB, raid superblock at 69930816kB
disk 1: /dev/sdb1, 69930913kB, raid superblock at 69930816kB

# cat /proc/mdstat
Personalities : [multipath]
read_ahead 1024 sectors
Event: 1
md0 : active multipath sdb1[1] sdf1[0]
      69930816 blocks [1/1] [U]
       
unused devices: <none>

# /sbin/raidstop /dev/md0
# /sbin/raidstart /dev/md0
# cat /proc/mdstat
Personalities : [multipath]
read_ahead 1024 sectors
Event: 2
md0 : active multipath sdf1[0]
      69930816 blocks [1/1] [U]
       
unused devices: <none>

The t3 arrays like to talk through one line or the other, this behavior
seems to lead the md driver to think that one of the lines is always
down. Then, in an actual failover the entire system hangs, disallowing
login etc. even if the failure is restored (I was running the mdmpd too
btw). /proc/mdstat shows two device files after the mkraid but after a
raidstop and a raidstart, it only ever sees 1 device per md group.
Sometimes a raidhotadd can be used to re-add the device, but if the t3
isn't actively using that particular line you get something like this:

# /sbin/raidhotadd /dev/md1 /dev/sdg1
/dev/md1: can not hot-add disk: invalid argument.


It then occurred to me that the md driver stores state on the disks and
so it might be unsuitable for a clustered setup anyway. It is quite
possible that the device ordering or failure states could be different
for different nodes. In addition, it might not be safe for the different
nodes to write their state to the same disk locations without
coordination.

Am I off base with this setup? Is md suitable for what I am trying to
achieve?

regards,

Jeff


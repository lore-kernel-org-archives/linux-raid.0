From: Kevin Page <krp@ecs.soton.ac.uk>
Subject: Software RAID-1 and badblocks
Date: Sun, 7 Apr 2002 23:52:24 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0204072315190.926-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I've suffered some ext3 corruptions recently (I don't know why these
occured yet), and despite not seeing any ide errors (as I've seen when
disks have died before :( ) it worried me into running badblocks on my
partitions.

I run 5 software raid1 devices on from the two onboard IDE channels on
my motherboard (and a raid0 on a highpoint controller, but the
problems aren't there). (More specific system details at the end of
the mail).

It occurs to me that I'm not actually sure which devices to run
badblocks on.

I can run badblocks on the /dev/md<x> device, which it seems to
accept; but is this useful? Is the badblock "check" (whatever that may
be) passed down to the actual constituent devices by the software raid
subsystem? Anyway, when I run badblocks in this way, I don't get any
errors.

So I then ran badblocks on one of the partitions that makes up the
raid1 device (on which the broken filesystem resides).
This turned up some badblocks, although suspiciously these were the
last two blocks of the device (5124701 and 5124702 on a device
badblocks reported as going to 5124703).

I presumed these blocks were junk, and struggled to work out how to
map these from the device - or more specifically from the raid1 device
- there was a posting here a while back working on the principle that
the device blocks are matched by the filesystem so you just map out
the blocks reported bad on the raid1 filesystem. However, I had real
problems going this way, mainly because raidhotremove didn't seem to
be functioning correctly. (I still have system logs for the errors,
but basically it told me the device was busy and couldn't be removed.
The logs included a "bug in file md.c, line 2344"; but in hindsight
I'd run non-destructive r/w badblocks by then, which may have messed
up the raid?).

In the end, I nuked the partition (on the "bad" disk, not the raid1),
and recreated it. badblocks on this didn't return any errors (although
could this be the drive itself mapping the bad sectors out?). I then
rebuilt the raid1 device, and reformatted it ext3 to "make sure".

By this point I'm pretty paranoid about the state of my disk. Once my
machine is back up, I run a read-only badblocks on all of the
partitions (the actual disk partitions, not the raid1).

And I found several badblocks on several of the hda<x> partitions. The
suspicious thing was, that they were all in the one to two blocks at
the end of the partition. As I understand it the raid superblock is at
the end of the device? Could this be confusing badblocks?

I'm left not knowing whether to trust the output of badblocks, and not
knowing whether there are really any problems with my disk (let alone
working out what led to the fs corruption in the first place).
Can anyone definitively tell me how I should check my disks in this
situation?


Gory details:
Running Redhat 7.2 with all updates applied, 2.4.9-31 i686.

/proc/mdstat:
Personalities : [raid0] [raid1] 
read_ahead 1024 sectors
md0 : active raid0 hde2[0] hdg2[1]
      78320384 blocks 64k chunks
      
md4 : active raid1 hda6[1] hdc6[0]
      1048704 blocks [2/2] [UU]
      
md3 : active raid1 hda5[1] hdc5[0]
      2559680 blocks [2/2] [UU]
      
md2 : active raid1 hda9[0] hdc3[1]
      5120064 blocks [2/2] [UU]
      
md5 : active raid1 hda3[1] hdc2[0]
      1043200 blocks [2/2] [UU]
      
md1 : active raid1 hda7[0] hdc1[1]
      5227840 blocks [2/2] [UU]

Useful bit of mount:
/dev/md5 on / type ext3 (rw)
/dev/md4 on /home type ext3 (rw)
/dev/md3 on /opt type ext3 (rw)
/dev/md1 on /opt/media1 type ext3 (rw)
/dev/md0 on /opt/media2 type ext3 (rw)
/dev/md2 on /usr type ext3 (rw)
/dev/hda8 on /mnt/scratch type ext3 (rw)

badblocks reported on hda3 (0 to 1044225 blocks):
1044224

badblocks reported on hda8 (0 to 8594743 blocks):
8594740
8594741
8594742

Happy to provide any other info on request.

Regards,

kev

-- 
Kevin R. Page           
krp@ecs.soton.ac.uk      http://www.ecs.soton.ac.uk/info/people/krp
Intelligence, Agents, Multimedia      University of Southampton, UK


From: Andrew Burgess <aab@cichlid.com>
Subject: mdadm confusion between whole disk and partition
Date: Mon, 03 Jan 2011 08:14:57 -0800
Message-ID: <1294071297.9742.0@athlon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I had a power failure while changing the chunk size
on a raid6 array. This happened before (well, last time
I interrupted the reshape manually).

This time as well as last, on reassembly mdadm got confused
between the first partition and the whole disk on two
of the devices.

The alarming thing is that if there hadn't been a reshape
in progress I think the array would have been assembled
with e.g. sdg instead of sdg1 which would have of course been
a disaster.

My workaround now is to specify devices=/dev/sd?1 in mdadm.conf.

An idea I had was maybe after assembling an array mdadm should
test read a few (hundred) stripes and see if parity is ok
before allowing writes to the array, refusing to start if there
are mismatches and this could be overridden with a
--dont-sanity-check or something.

Here is the transcript:

root@athlon:~ # mdadm -A /dev/md5
mdadm: WARNING /dev/sdg1 and /dev/sdg appear to have very similar  
superblocks.
       If they are really different, please --zero the superblock on one
       If they are the same or overlap, please remove one from the
       DEVICE list in mdadm.conf.

root@athlon:~ # cat /proc/mdstat

<shows other valid arrays but not md5>

root@athlon:~ # mdadm -Av /dev/md5
mdadm: looking for devices for /dev/md5
...
mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 5.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdg is identified as a member of /dev/md5, slot 7.        
<<<<<<<<<<<<<<< ERROR s.b sdg1
mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 8.
mdadm: /dev/sdf is identified as a member of /dev/md5, slot 8.        
<<<<<<<<<<<<<<< now sdf
mdadm: WARNING /dev/sdf1 and /dev/sdf appear to have very similar  
superblocks.
       If they are really different, please --zero the superblock on one
       If they are the same or overlap, please remove one from the
       DEVICE list in mdadm.conf.

<notice how subsequent mdadm runs lose the partitions, perhaps
something still has them open from a previous run?>

root@athlon:~ # mdadm -Av /dev/md5
mdadm: looking for devices for /dev/md5
...
mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 5.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdg is identified as a member of /dev/md5, slot 7.  
<<<<<<<<<<<<< whole disk
mdadm: /dev/sdf is identified as a member of /dev/md5, slot 8.  
<<<<<<<<<<<<< whole disk
mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 1.
mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot 0.
mdadm:/dev/md5 has an active reshape - checking if critical section  
needs to be restored
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.
       Possibly you needed to specify the --backup-file

<so then I tried specifying the partitions, it ignores g1 and f1>

root@athlon:~ # mdadm -Av /dev/md5 /dev/sd[lkjhgfdcb]1
...
mdadm: looking for devices for /dev/md5
mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 5.
mdadm:/dev/md5 has an active reshape - checking if critical section  
needs to be restored
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.
       Possibly you needed to specify the --backup-file

<Neil suggested blockdev last time so I tried that again>

root@athlon:~ # blockdev --rereadpt /dev/sdg
root@athlon:~ # blockdev --rereadpt /dev/sdf
root@athlon:~ # mdadm -Av /dev/md5 /dev/sd[lkjhgfdcb]1
mdadm: looking for devices for /dev/md5
mdadm: cannot open device /dev/sdf1: Device or resource busy
mdadm: /dev/sdf1 has no superblock - assembly aborted

<this is probably just a tiny error reporting bug, failure to
open doesn't mean there is no superblock>

root@athlon:~ # cat /proc/mdstat
Personalities : [raid0] [raid6] [raid5] [raid4]
md5 : inactive sdf1[8](S) sdg1[7](S)
       3907026944 blocks super 0.91

<ok, someone (udev?) grabbed the partitions as soon as blockdev
made them available and tried to assemble something. No problem.>

root@athlon:~ # mdadm -S /dev/md5
mdadm: stopped /dev/md5

root@athlon:~ # mdadm -Av /dev/md5 /dev/sd[lkjhgfdcb]1
mdadm: looking for devices for /dev/md5
mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 8.
mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 7.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 5.
mdadm:/dev/md5 has an active reshape - checking if critical section  
needs to be restored
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.
       Possibly you needed to specify the --backup-file

<and now everything is fine>

root@athlon:~ # mdadm -Av /dev/md5 --backup-file  
/my/raid/RAID_BACKUP_FILE /dev/sd[lkjhgfdcb]1
mdadm: looking for devices for /dev/md5
mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 8.
mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 7.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 5.
mdadm:/dev/md5 has an active reshape - checking if critical section  
needs to be restored
mdadm: restoring critical section
mdadm: added /dev/sdc1 to /dev/md5 as 1
mdadm: added /dev/sdd1 to /dev/md5 as 2
mdadm: added /dev/sdj1 to /dev/md5 as 3
mdadm: added /dev/sdh1 to /dev/md5 as 4
mdadm: added /dev/sdl1 to /dev/md5 as 5
mdadm: added /dev/sdk1 to /dev/md5 as 6
mdadm: added /dev/sdg1 to /dev/md5 as 7
mdadm: added /dev/sdf1 to /dev/md5 as 8
mdadm: added /dev/sdb1 to /dev/md5 as 0
mdadm: /dev/md5 has been started with 9 drives.

root@athlon:~ # cat /proc/mdstat
Personalities : [raid0] [raid6] [raid5] [raid4]
md5 : active raid6 sdb1[0] sdf1[8] sdg1[7] sdk1[6] sdl1[5] sdh1[4]  
sdj1[3] sdd1[2] sdc1[1]
       13674583552 blocks super 0.91 level 6, 128k chunk, algorithm 2  
[9/9] [UUUUUUUUU]
       [=============>.......]  reshape = 68.6% (1341812608/1953511936)  
finish=7496.3min speed=1359K/sec


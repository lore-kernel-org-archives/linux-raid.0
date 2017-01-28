From: George Rapp <george.rapp@gmail.com>
Subject: RAID 5 reshape stalled at 77.5% - next steps??
Date: Sat, 28 Jan 2017 18:01:30 -0500
Message-ID: <CAF-Kpgbz_Ld5WVOid1SHopcOjdx63kM-zVDUScZowtQzxrtZHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
Cc: Matthew Krumwiede <matt.krumwiede@me.com>
List-Id: linux-raid.ids

Hello linux-raid team. I have a reshape operation that is stuck and
refuses to respond to commands. I'm wondering what my options are to
safely get it moving again.

Background: I added two new partitions to a RAID 5 array, using a
backup-file on a
separate device:

# mdadm --add /dev/md4 /dev/sdb4 /dev/sdd4
mdadm: added /dev/sdb4
mdadm: added /dev/sdd4

# mdadm --grow --raid-devices=10
--backup-file=/home/gwr/c/md4_backup__2017-01-25 /dev/md4
mdadm: Need to backup 32256K of critical section..

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
[...]
md4 : active raid5 sdd4[13](R) sdb4[12] sdg4[10] sdi4[8] sdl4[9]
sdf4[1] sdj4[7] sdh4[2] sde4[0] sdk4[11]
13454923776 blocks super 1.1 level 5, 512k chunk, algorithm 2 [10/9]
[UUUUUUUUU_]
[>....................] reshape = 0.8% (16715456/1922131968)
finish=965.4min speed=32892K/sec

The reshape proceeded normally until it hit 77.5%, where it has been
stuck for the last couple of days:

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md4 : active raid5 sdd4[13](R) sdb4[12] sdg4[10](F) sdi4[8] sdl4[9]
sdf4[1] sdj4[7] sdh4[2] sde4[0] sdk4[11]

13454923776 blocks super 1.1 level 5, 512k chunk, algorithm 2 [10/9]
[UUUU_UUUU_]
[===============>.....] reshape = 77.5% (1490403328/1922131968)
finish=2544246.9min speed=2K/sec

The backup file was last accessed at about the time I started the reshape:
-rw-------. 1 root root  33034240 Jan 25 11:52 md4_backup__2017-01-25

I tried to idle the RAID reshape, but the "echo" command just hung:

# cd /sys/block/md4/md
# echo idle > sync_action

I can get some data from the files in this directory, though:

# cat reshape_direction
forwards
# cat reshape_position
26825379840

I tried to pull mdadm data about this array to add to this post, but that
command also hung:

# mdadm --misc --examine /dev/md4

The server CPU load is pegged, with md4_raid5 as the top CPU hog.

What are my safe alternatives here? Can I safely reboot without corrupting
the reshape? How can I get the reshape unstuck?

-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)

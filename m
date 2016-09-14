From: scar <scar-47zfDnpWZoPQT0dZR+AlfA@public.gmane.org>
Subject: moving spares into group and checking spares
Date: Tue, 13 Sep 2016 22:18:41 -0700
Message-ID: <nramjg$n07$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

i currently have four RAID-5 md arrays which i concatenated into one 
logical volume (lvm2), essentially creating a RAID-50.  each md array 
was created with one spare disk.

instead, i would like to move the four spare disks into one group that 
each of the four arrays can have access to when needed.  i was wondering 
how to safely accomplish this, preferably without unmounting/disrupting 
the filesystem.

secondly, i have the checkarray script scheduled via cron to 
periodically check each of the four arrays.  i noticed in the output of 
checkarray that it doesn't list the spare disk(s).  so i'm guessing they 
are not being checked?  i was wondering, then, how i could also check 
the spare disks to make sure they are healthy and ready to be used if 
needed?

below is output of /proc/mdstat and mdadm.conf

thanks
--

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md3 : active (auto-read-only) raid5 sdal1[0] sdaw1[11](S) sdav1[10] 
sdau1[9] sdat1[8] sdas1[7] sdar1[6] sdaq1[5] sdap1[4] sdao1[3] sdan1[2] 
sdam1[1]
       9766297600 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[11/11] [UUUUUUUUUUU]
       bitmap: 0/8 pages [0KB], 65536KB chunk

md2 : active raid5 sdaa1[0] sdak1[11](S) sdz1[10] sdaj1[9] sdai1[8] 
sdah1[7] sdag1[6] sdaf1[5] sdae1[4] sdad1[3] sdac1[2] sdab1[1]
       9766297600 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[11/11] [UUUUUUUUUUU]
       bitmap: 1/8 pages [4KB], 65536KB chunk

md1 : active raid5 sdn1[0] sdy1[11](S) sdx1[10] sdw1[9] sdv1[8] sdu1[7] 
sdt1[6] sds1[5] sdr1[4] sdq1[3] sdp1[2] sdo1[1]
       9766297600 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[11/11] [UUUUUUUUUUU]
       bitmap: 1/8 pages [4KB], 65536KB chunk

md0 : active raid5 sdb1[0] sdm1[11](S) sdl1[10] sdk1[9] sdj1[8] sdi1[7] 
sdh1[6] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1]
       9766297600 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[11/11] [UUUUUUUUUUU]
       bitmap: 0/8 pages [0KB], 65536KB chunk

unused devices: <none>

# cat /etc/mdadm/mdadm.conf
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR root
ARRAY /dev/md/0  metadata=1.2 UUID=6dd6eba5:50fd8c6d:33ad61ee:e84763a8 
name=hind:0
    spares=1
ARRAY /dev/md/1  metadata=1.2 UUID=9336c73a:8b8993bf:ea6cfc3d:bf9f7441 
name=hind:1
    spares=1
ARRAY /dev/md/2  metadata=1.2 UUID=817bf91c:4f14fcb0:9ba8b112:768321ee 
name=hind:2
    spares=1
ARRAY /dev/md/3  metadata=1.2 UUID=1251c6b7:36aca0eb:b66b4c8c:830793ad 
name=hind:3
    spares=1

#

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

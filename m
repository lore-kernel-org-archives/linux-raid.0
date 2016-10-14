From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: "bitmap" line in /proc/mdstat
Date: Fri, 14 Oct 2016 12:06:01 +0200
Message-ID: <5800AE09.70608@bluewin.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

When I have added a new RAID5 yesterday I saw that it has an additional 
line (bitmap: 0/30 pages [0KB], 65536KB chunk) in /proc/mdstat for md5 
in contrast to md[1234] not having this line:

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear]
md5 : active raid5 sdt[4] sds[2] sdr[1] sdi[0]
       11720662272 blocks super 1.2 level 5, 128k chunk, algorithm 2 
[4/4] [UUUU]
       bitmap: 0/30 pages [0KB], 65536KB chunk

md0 : active linear md5[4] md1[0] md4[3] md3[2] md2[1]
       33697299328 blocks super 1.2 0k rounding

md4 : active raid5 sdj[5] sdm[4] sdl[2] sdk[1]
       5860149888 blocks super 1.2 level 5, 128k chunk, algorithm 2 
[4/4] [UUUU]

md3 : active raid5 sdn[0] sdq[4] sdp[2] sdo[1]
       5860540032 blocks super 1.2 level 5, 128k chunk, algorithm 2 
[4/4] [UUUU]

md2 : active raid5 sde[0] sdh[4] sdg[2] sdf[1]
       4395412224 blocks super 1.2 level 5, 128k chunk, algorithm 2 
[4/4] [UUUU]

md1 : active raid5 sda[0] sdd[3] sdc[2] sdb[1]
       5860540032 blocks super 1.2 level 5, 128k chunk, algorithm 2 
[4/4] [UUUU]

unused devices: <none>


What I did yesterday was the following:

# mdadm -C /dev/md5 -c 128 -n4 -l5 /dev/sd[irst]

# mdadm --grow /dev/md0 --add /dev/md5

# xfs_growfs /mnt/media-raid


 From what I was reading [1,2] it is useful for faster rebuilds.
But why is it not present for md[1234] as I used the same command to 
create these RAIDs?
Is it only possible for the last of the linear devices, or is it only 
used for almost empty devices, or was the bitmap introduced in a recent 
update?
I wonder if I should and could add a bitmap for the other devices as well?


Best regards,
Ramon


[1] https://raid.wiki.kernel.org/index.php/Write-intent_bitmap
[2] https://raid.wiki.kernel.org/index.php/Mdstat#bitmap_line

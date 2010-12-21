From: Andrew Burgess <aab@cichlid.com>
Subject: reshape changing chunk size won't restart
Date: Tue, 21 Dec 2010 12:01:37 -0800
Message-ID: <1292961697.20216.0@athlon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mdadm 3.14
kernel 2.6.35.8

I started a reshape changing chunk size and after it ran
for a while i realized the disk i used for the
backup file was slow so I killed the mdadm
running in the background and tried to restart
with the new location (i moved the file just in case)

mdadm /dev/md5 --grow --chunk=8 --backup-file=/my/raid/RAID_BACKUP_FILE

it complains:

mdadm: /dev/md5 is performing resync/recovery and cannot be reshaped

/proc/mdstat for md5 shows partial progress but the numbers don't change
(except finish grows):

md5 : active raid6 sdd1[2] sdf1[8] sdc1[1] sdb1[0] sdh1[4] sdl1[5]  
sdj1[3] sdg1[7] sdk1[6]
       13674583552 blocks super 0.91 level 6, 128k chunk, algorithm 2  
[9/9] [UUUUUUUUU]
       [>....................]  reshape =  0.1% (2715648/1953511936)  
finish=850711.5min speed=38K/sec

The mdadm 3.14 is freshly compiled. I started the reshape
with mdadm 3.13.

I didn't try rebooting as the filesystem is mounted and
the data seems ok. Didn't want to make things worse...

Thank you for any help

From: Sharif Islam <mislam@uiuc.edu>
Subject: Confusing failed disk situation
Date: Wed, 05 Jan 2005 11:50:41 -0600
Message-ID: <41DC28F1.6030109@uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am rebuilding a RAID-5 with 5 disk. Last night when it finished I saw
the RAID is done with one failed disk. Not sure what happened. It gave 
me inode
error on mke2fs. Then I replaced the failed disk(hdi) with another old 
disk. I am pretty
sure both disks are fine. I noticed this.

Jan  5 11:12:50 kernel:  --- rd:5 wd:4 fd:1
Jan  5 11:12:50  kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdg1
Jan  5 11:12:50  kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdh1
Jan  5 11:12:50  kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdj1
Jan  5 11:12:50  kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdf1
Jan  5 11:12:50  kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
Jan  5 11:12:50  kernel: RAID5 conf printout:
Jan  5 11:12:50  kernel:  --- rd:5 wd:4 fd:1
Jan  5 11:12:50  kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdg1
Jan  5 11:12:50  kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdh1
Jan  5 11:12:50  kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdj1
Jan  5 11:12:50  kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdf1
Jan  5 11:12:50  kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
Jan  5 11:12:50  kernel: md2: resyncing spare disk hdi1 to replace 
failed disk
Jan  5 11:12:50  kernel: RAID5 conf printout:
Jan  5 11:12:50  kernel:  --- rd:5 wd:4 fd:1
Jan  5 11:12:50  kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdg1
Jan  5 11:12:50  kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdh1
Jan  5 11:12:50  kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdj1
Jan  5 11:12:50  kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdf1
Jan  5 11:12:50  kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
Jan  5 11:12:50  kernel: RAID5 conf printout:
Jan  5 11:12:50  kernel:  --- rd:5 wd:4 fd:1
Jan  5 11:12:50  kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdg1
Jan  5 11:12:50  kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdh1
Jan  5 11:12:50  kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdj1
Jan  5 11:12:50  kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdf1
Jan  5 11:12:50  kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
Jan  5 11:12:50  kernel: md: syncing RAID array md2
Jan  5 11:12:50  kernel: md: minimum _guaranteed_ reconstruction speed: 
100 KB/sec/disc.
Jan  5 11:12:50  kernel: md: using maximum available idle IO bandwith 
(but not more than 10000 KB/sec) for reconstruction.

cat /proc/mdstat
Personalities : [linear] [raid5]
read_ahead 1024 sectors
Event: 2
md2 : active raid5 hdi1[5] hdf1[3] hdj1[2] hdh1[1] hdg1[0]
      468882432 blocks level 5, 128k chunk, algorithm 2 [5/4] [UUUU_]
      [===>.................]  recovery = 17.7% (20796612/117220608) 
finish=156.3min speed=10274K/sec
unused devices: <none>

Is hdi again failed? Or something wrong with the cable/raid card for 
that drive?




From: =?ISO-8859-1?Q?Bj=F8rn_Eikeland?= <beikeland@gmail.com>
Subject: raid 5 created with 7 out of 8
Date: Mon, 10 Jan 2005 02:38:37 +0100
Message-ID: <f4146e7c0501091738200dd32e@mail.gmail.com>
Reply-To: =?ISO-8859-1?Q?Bj=F8rn_Eikeland?= <beikeland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I'm trying to set up a raid5 array using 8 ide drives (
/dev/hd[e-l] ) but I'm having a hard time.

I'm using slackware 10, kernel 2.4.26 and madm 1.8.1 (downloading
2.4.28 overnight now)

The problem is mdadm creates the array with 7 of 8 drives up and
running and the last as a spare and does not start recovering with the
spare. And it will not let me remove it and re-add it. Below follows a
script output of the whole thing (less repartitioning the drives and
zero'ing any remaining superblocks)

Any help will be greatly appreciated.
-thanks

root@filebear:~# mdadm -C /dev/md0 -l5 -n8 -c512 /dev/hd[e-l]1
VERS = 9000
mdadm: array /dev/md0 started.
root@filebear:~# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid5] 
read_ahead 1024 sectors
md0 : active raid5 hdl1[8] hdk1[6] hdj1[5] hdi1[4] hdh1[3] hdg1[2]
hdf1[1] hde1[0]
      1094017792 blocks level 5, 512k chunk, algorithm 2 [8/7] [UUUUUUU_]
      
unused devices: <none>
root@filebear:~# mdadm /dev/md0 -f /dev/hdl1
mdadm: set /dev/hdl1 faulty in /dev/md0
root@filebear:~# mdadm /dev/md0 -r /dev/hdl
mdadm: hot removed /dev/hdl1
root@filebear:~# mdadm /dev/md0 -a /dev/hdl1
mdadm: hot add failed for /dev/hdl1: No space left on device
root@filebear:~# mdadm /dev/md0 -f /dev/hde1
mdadm: set /dev/hde1 faulty in /dev/md0
root@filebear:~# mdadm /dev/md0 -r /dev/hde1
mdadm: hot removed /dev/hde1
root@filebear:~# mdadm /dev/md0 -a /dev/hde1
mdadm: hot add failed for /dev/hde1: No space left on device

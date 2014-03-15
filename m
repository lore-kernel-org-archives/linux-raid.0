From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Raid stalls during --replace and other disk activity...
Date: Sat, 15 Mar 2014 00:28:44 -0400
Message-ID: <CAK_KU4bEFkydyqJfrUWNoq9R7AxVwPU29Kyzp+5mn=tmf7GgHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 4 disk RAID5.  I added a spare disk and am in the process of
--replace[ing] a disk in the array.

~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
md5 : active raid5 sde1[4](R) sda1[1] sdb1[7] sdd1[8] sdf1[0]
      4395302400 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
      [==============>......]  recovery = 71.7%
(1051281152/1465100800) finish=334.3min speed=20628K/sec

I am replacing /dev/sdf with /dev/sde. This WAS running at about 120MB/second.

However, when I started a format of an unrelated partition on
/dev/sda, the RAID 'recovery' disk-replacement completely stopped. I
suspect the RAID rebuild mechanism is pausing because of the activity
on /dev/sda.

I monkeyed with
echo 90000 > speed_limit_min
and now I get 10 second bursts of 20-100MB/sec every 30 seconds or so,
so at least the jobs will finish in parallel..

I feel the RAID --replace option should only concern itself with the
two disks involved not get caught up because of activity on another
disk. Is this a bug?

Thoughts?

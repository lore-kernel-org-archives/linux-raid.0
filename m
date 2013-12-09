From: Mark Knecht <markknecht@gmail.com>
Subject: Rebuild events while scrubbing - problems or just informational?
Date: Mon, 9 Dec 2013 14:27:09 -0800
Message-ID: <CAK2H+ed3vEJVF8To8FWD_Ltj7jGKgrBAvz-Aum4viR=VZE+gww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   A few weeks back I set up cron to do a weekly scrub on my home
machine. I've since noticed these rebuild event messages in the logs
for each scrub that's occurred so far. Are they just part of the
normal process of mdadm doing it's work or are they pointing to some
sort of problem I'm not yet recognizing? I found it interesting that
they were all almost exactly 33 minutes, 20 seconds apart. Are the 5
messages related to the 5 drives in my RAID6?

   I found numerous others who have seen this over the years and say
it's not indicative of any problem but did recommend running smartctl
so I've done smartctl -t long tests on all the drives and didn't see
anything special getting reported. All tests completed without errors
so I'm hoping these messages just part of the normal reporting but
don't remember seeing them in the past. Note that for a long time (a
year maybe?) I completely forgot about scrubbing so there is a big gap
in my memory here.

   I'm running a more or less stable Gentoo amd64 box. The kernel is
3.10.22 and mdadm is version 3.2.6-r1 which is the latest stable
version in portage.

Thanks in advance,
Mark

c2RAID6 log # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md3 : active raid6 sdb3[9] sdf3[5] sde3[6] sdd3[7] sdc3[8]
      1452264480 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]

unused devices: <none>
c2RAID6 log #


Dec  8 14:30:01 c2RAID6 kernel: [29557.910269] md: data-check of RAID array md3
Dec  8 14:30:01 c2RAID6 kernel: [29557.910272] md: minimum
_guaranteed_  speed: 1000 KB/sec/disk.
Dec  8 14:30:01 c2RAID6 kernel: [29557.910274] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
data-check.
Dec  8 14:30:01 c2RAID6 kernel: [29557.910278] md: using 128k window,
over a total of 484088160k.


Dec  8 14:30:01 c2RAID6 mdadm[1838]: RebuildStarted event detected on
md device /dev/md/3
Dec  8 15:03:21 c2RAID6 mdadm[1838]: Rebuild26 event detected on md
device /dev/md/3
Dec  8 15:36:41 c2RAID6 mdadm[1838]: Rebuild49 event detected on md
device /dev/md/3
Dec  8 16:10:01 c2RAID6 mdadm[1838]: Rebuild70 event detected on md
device /dev/md/3
Dec  8 16:43:21 c2RAID6 mdadm[1838]: Rebuild87 event detected on md
device /dev/md/3

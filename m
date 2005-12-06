From: "JaniD++" <djani22@dynamicweb.hu>
Subject: RAID5 resync question
Date: Tue, 6 Dec 2005 01:18:11 +0100
Message-ID: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list,


Is there a way to force the raid to skip this type of resync?

Every 2s: cat /proc/mdstat                              Tue Dec  6 01:28:55
2005

Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
[raid10] [f
aulty]
md0 : active raid5 sdb1[4] sda1[10] hds1[5] hdq1[2] hdo1[3] hdm1[8] hdk1[6]
hdi1
[7] hde1[9] hdc1[1] hda1[0]
      1953583360 blocks level 5, 32k chunk, algorithm 2 [11/11]
[UUUUUUUUUUU]
      [=>...................]  resync =  6.0% (11758724/195358336)
finish=1216.8
min speed=2512K/sec

unused devices: <none>


md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md:  adding hds1 ...
md:  adding hdq1 ...
md:  adding hdo1 ...
md:  adding hdm1 ...
md:  adding hdk1 ...
md:  adding hdi1 ...
md:  adding hde1 ...
md:  adding hdc1 ...
md:  adding hda1 ...
md: created md0
md: bind<hda1>
md: bind<hdc1>
md: bind<hde1>
md: bind<hdi1>
md: bind<hdk1>
md: bind<hdm1>
md: bind<hdo1>
md: bind<hdq1>
md: bind<hds1>
md: bind<sda1>
md: bind<sdb1>
md: running:
<sdb1><sda1><hds1><hdq1><hdo1><hdm1><hdk1><hdi1><hde1><hdc1><hda1>
md: md0: raid array is not clean -- starting background reconstruction

Thanks,
Janos


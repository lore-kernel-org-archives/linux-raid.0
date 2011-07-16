From: Pol Hallen <raid1@fuckaround.org>
Subject: standard performance (write speed 20Mb/s)
Date: Sat, 16 Jul 2011 21:40:58 +0200
Message-ID: <201107162140.58883.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks :-)

after assembled a new hw (xeon, ich10 controller with 5 disks of 2Tb wd - 
radi5) I have slow write performance:

20Mb/s :-(((

dd if=/dev/zero of=/share/raid/1Gb bs=1024M count=1
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB) copied, 48.7203 s, 22.0 MB/s

I repeated same test also creating a 10Gb file.. same results..

write speed is better:

dd if=/share/raid/1Gb of=/dev/null
2097152+0 records in
2097152+0 records out
1073741824 bytes (1.1 GB) copied, 1.82054 s, 590 MB/s

20Mb/s is a disk/controller problem or controller can't do better?

hw is new, I already check all disks..

thanks!
 
Pol

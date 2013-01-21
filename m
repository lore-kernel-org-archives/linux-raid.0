From: Eddy Ilg|univation <eddy.ilg@univation.de>
Subject: Determine resync direction from syslog?
Date: Mon, 21 Jan 2013 21:33:20 +0100
Message-ID: <50FDA610.6030702@univation.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

here's a somewhat funny situation:

A drive (/dev/sdb) of a RAID1 with damaged superblock is attached to a 
laptop. Someone stupid attaches another drive (/dev/sdc) with a very old 
backup mirror of /dev/sdb. And -
the raid starts to sync:

Jan 21 20:46:32 localhost kernel: [ 7789.680603] md: bind<sdc1>
Jan 21 20:46:32 localhost kernel: [ 7789.681358] md: bind<sdc2>
Jan 21 20:46:32 localhost kernel: [ 7789.685163] RAID1 conf printout:
Jan 21 20:46:32 localhost kernel: [ 7789.685168]  --- wd:1 rd:2
Jan 21 20:46:32 localhost kernel: [ 7789.685173]  disk 0, wo:1, o:1, 
dev:sdc1
Jan 21 20:46:32 localhost kernel: [ 7789.685178]  disk 1, wo:0, o:1, 
dev:sdb1
Jan 21 20:46:32 localhost kernel: [ 7789.685387] md: recovery of RAID 
array md0
Jan 21 20:46:32 localhost kernel: [ 7789.685392] md: minimum 
_guaranteed_  speed: 1000 KB/sec/disk.
Jan 21 20:46:32 localhost kernel: [ 7789.685396] md: using maximum 
available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Jan 21 20:46:32 localhost kernel: [ 7789.685402] md: using 128k window, 
over a total of 3903680 blocks.
Jan 21 20:46:32 localhost kernel: [ 7789.685707] RAID1 conf printout:
Jan 21 20:46:32 localhost kernel: [ 7789.685712]  --- wd:1 rd:2
Jan 21 20:46:32 localhost kernel: [ 7789.685717]  disk 0, wo:1, o:1, 
dev:sdc2
Jan 21 20:46:32 localhost kernel: [ 7789.685721]  disk 1, wo:0, o:1, 
dev:sdb2
Jan 21 20:46:32 localhost kernel: [ 7789.685819] md: delaying recovery 
of md1 until md0 has finished (they share one or more physical units)
Jan 21 20:50:01 localhost kernel: [ 7997.625245] md: md0: recovery done.
Jan 21 20:50:01 localhost kernel: [ 7997.723416] md: recovery of RAID 
array md1
Jan 21 20:50:01 localhost kernel: [ 7997.723421] md: minimum 
_guaranteed_  speed: 1000 KB/sec/disk.
Jan 21 20:50:01 localhost kernel: [ 7997.723425] md: using maximum 
available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Jan 21 20:50:01 localhost kernel: [ 7997.723432] md: using 128k window, 
over a total of 191454528 blocks.


Which direction did the sync go?


Best regards,


Eddy Ilg


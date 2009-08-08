From: Matthias Dahl <ml_linux_raid@mortal-soul.de>
Subject: partitioned raid 5 and proper partition alignment
Date: Sat, 8 Aug 2009 08:12:45 +0200
Message-ID: <200908080812.45509.ml_linux_raid@mortal-soul.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone.

I've really looked around everywhere but it is hard to find any decent 
information about partitioned software raid 5. If someone could please help me 
out that would be great. Thanks a lot in advance...

I am trying to partition a raid 5 but I cannot figure out the partition 
alignment. My raid has 3 disks and a chunk size of 64kib, thus a total stripe 
width of 192kib (data + parity). I am using sfdisk w/ sector units and I 
currently align everything to the stripe width size:

dreamgate ~ # sfdisk -l -uS /dev/md_d0

Disk /dev/md_d0: 485990272 cylinders, 2 heads, 4 sectors/track
Units = sectors of 512 bytes, counting from 0

   Device Boot    Start       End   #sectors  Id  System
/dev/md_d0p1           384 314572799  314572416  83  Linux
/dev/md_d0p2     314572800 629145599  314572800  83  Linux
/dev/md_d0p3     629145600 3887922175 3258776576  83  Linux
/dev/md_d0p4             1       383        383  83  Linux

The problem is I cannot figure out how to deal with sector 0 which usually 
contains the mbr and partition table. So does the striping begin w/ sector 0 
or w/ sector 1 because sector 0 is handled specially?

If sector 0 is not handled specially and striping starts there, my partitions 
above are properly aligned otherwise they are off exactly 512 byte.

Like I said, if someone could give me a hint, I'd really appreciate it.

Thanks a lot in advance,
matthew.

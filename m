From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re: is this raid5 OK ?
Date: Fri, 30 Mar 2007 13:43:43 +0200
Message-ID: <460CF7EF.1000203@kaneda.iguw.tuwien.ac.at>
References: <237230840.20070329193857@kaneda.iguw.tuwien.ac.at> <17932.22575.558925.535963@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17932.22575.558925.535963@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

1) the kernel was:
[root@alfred ~]# uname -a
Linux alfred 2.6.19-1.2288.fc5xen0 #1 SMP Sat Feb 10 16:57:02 EST 2007 
i686 athlon i386 GNU/Linux

now upgraded to:

[root@alfred ~]# uname -a
Linux alfred 2.6.20-1.2307.fc5xen0 #1 SMP Sun Mar 18 21:59:42 EDT 2007 
i686 athlon i386 GNU/Linux

OS is fedora core 6

[root@alfred ~]# mdadm --version
mdadm - v2.3.1 - 6 February 2006

2) I got the impression that the old 350W power supply was to weak, I 
replaced it by a 400W version.

3) re-created the raid:

[root@alfred ~]# mdadm --misc --zero-superblock /dev/hde1
[root@alfred ~]# mdadm --misc --zero-superblock /dev/hdf1
[root@alfred ~]# mdadm --misc --zero-superblock /dev/hdg1
[root@alfred ~]# mdadm --misc --zero-superblock /dev/hdh1
[root@alfred ~]# mdadm --create --verbose /dev/md0 --level=5 
--raid-devices=4 --spare-devices=0 /dev/hde1 /dev/hdf1 /dev/hdg1 /dev/hdh1
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 64K
mdadm: size set to 390708736K
mdadm: array /dev/md0 started.
[root@alfred ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 hdh1[4] hdg1[2] hdf1[1] hde1[0]
       1172126208 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

unused devices: <none>

same as before.

4) did as dan suggested:

[root@alfred ~]# mdadm -S /dev/md0
[root@alfred ~]# mdadm --misc --zero-superblock /dev/hde1
[root@alfred ~]# mdadm --misc --zero-superblock /dev/hdf1
[root@alfred ~]# mdadm --misc --zero-superblock /dev/hdg1
[root@alfred ~]# mdadm --misc --zero-superblock /dev/hdh1
[root@alfred ~]# mdadm --create /dev/md0 -n 4 -l 5 /dev/hd[efg]1 missing
mdadm: array /dev/md0 started.
[root@alfred ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 hdg1[2] hdf1[1] hde1[0]
       1172126208 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

unused devices: <none>
[root@alfred ~]# mdadm --add /dev/md0 /dev/hdh1
mdadm: added /dev/hdh1
[root@alfred ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 hdh1[4] hdg1[2] hdf1[1] hde1[0]
       1172126208 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
       [>....................]  recovery =  0.0% (47984/390708736) 
finish=406.9min speed=15994K/sec

unused devices: <none>

seems like it's working now - tnx !

cu

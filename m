From: "Mike Black" <mblack@csi-inc.com>
Subject: Re: filesystems for large arrays
Date: Tue, 11 Feb 2003 07:21:12 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <028201c2d1c8$111c7fe0$f6de11cc@black>
References: <200302110925.BAA08326@astra.scripps.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andy Arvai <arvai@scripps.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dual Athlon 2000MP
3G Memory
FiberChannel qla2100 interface.
Almost 2TB
Running for about a year now with no problems.  Used for data mining development (a fair# of files).

ext3 filesystem on RAID5
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md6             1949323256 1563695060 366125948  82% /usr6
md6 : active raid5 sdt1[12] sdl1[0] sdk1[11] sdj1[10] sdi1[9] sdh1[8] sdg1[7] sdf1[6] sde1[5] sdd1[4] sda1[3] sdc1[2] sdb1[1]
     1950225024 blocks level 5, 128k chunk, algorithm 2 [12/12] [UUUUUUUUUUUU]

Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/md6             6190080  401503 5788577    7% /usr6

Done 6/21/02 
Linux 2.4.19-pre10 #1 SMP Tue Jun 11 07:04:12 EDT 2002 i686 unknown
tiobench.pl --size 4000
Size is MB, BlkSz is Bytes, Read, Write, and Seeks are MB/secd . -T

         File   Block  Num  Seq Read    Rand Read   Seq Write  Rand Write
  Dir    Size   Size   Thr Rate (CPU%) Rate (CPU%) Rate (CPU%) Rate (CPU%)
------- ------ ------- --- ----------- ----------- ----------- -----------
   .     4000   4096    1  123.2 98.7% 1.090 1.25% 58.23 83.5% 2.755 2.64%
   .     4000   4096    2  116.9 94.4% 1.413 1.85% 57.80 102.% 2.759 3.09%
   .     4000   4096    4  117.3 95.9% 1.749 2.31% 56.49 104.% 2.760 3.53%
   .     4000   4096    8  116.3 96.0% 2.092 2.77% 48.26 91.1% 2.760 3.84%

----- Original Message ----- 
From: "Andy Arvai" <arvai@scripps.edu>
To: <linux-raid@vger.kernel.org>
Sent: Tuesday, February 11, 2003 4:25 AM
Subject: filesystems for large arrays


> Hi,
> 
> Does anyone have comments about the various filesystems typically used
> with large (terabyte) arrays, regarding performance and reliability?
> 
> The three most common filesystems seem to be ext3, reiser and xfs. Ext3
> and reiser are part of the standard linux kernel (not sure about xfs),
> implying that they are fairly robust. I've been using reiser and
> haven't had any problems, but I've heard that when the filesystem gets
> full there may be problems and it's also optimized for many small files
> instead of larger files. Ext3 sounds like it is very robust (since it
> is based on ext2), although I've heard the performance is worse than
> reiser. I've heard some good things about xfs, but have never used it.
> 
> If anyone has any real-world experiences or benchmarks I would be
> interested.
> 
> Andy
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

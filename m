From: AndyLiebman@aol.com
Subject: Fwd: XFS file corruption bug ?
Date: Wed, 16 Mar 2005 06:47:12 EST
Message-ID: <5b.65943ac5.2f6976c0@aol.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="part1_5b.65943ac5.2f6976c0_boundary"
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--part1_5b.65943ac5.2f6976c0_boundary
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Have people on the linux-raid list seen this? Could the observations made  by 
these folks be a Linux RAID issue and not an XFS problem, even though it  
hasn't been reproduced with other filesystems? 
 
Andy Liebman
 
 
jforis@wi.rr.com writes:
I may have found a way to reproduce a file  corruption bug and I would 
like to know
if I am seeing something unique  to our environment, or if this is a 
problem for everyone.

Summary:  when writing to a XFS formated software raid0 partition which 
is > 70%  full,
unmounting, then remounting the partition will show random 4K block  file 
corruption in
files larger than the raid chunk size.  We  (myself and a coworker)  have 
tested 2.6.8-rc2-bk5
and 2.6.11; both  show the same behavior.


The original test configuration was using a  HP8000, 2 GBytes RAM, with  
2.6.8-rc2-bk5 smp kernel,
1-36 GB system  disk, 2-74 GB data disk configured as a single RAID0 
partition with  256K
chunk size.  This "md0" partition is formatted as XFS with external  
journal on the system disk:

/sbin/mkfs.xfs -f -l  logdev=/dev/sda5,sunit=8 /dev/md0

using tools from  "xfsprogs-2.6.25-1".

First the partition was zeroed ("dd if=dev/zero  of=/dev/md0 ....."), 
then a known pattern
was written in 516K files (4K +  2 x 256K).  The partition (~140 GBytes) 
was filled to 98%,
then the  partition was first unmounted, then remounted.

On checking the sum of  each file, is was found that some file checksums 
were not as  expected.
Examination of the mismatched files showed that one 4K block in the  file 
contained zeros, not
the expected pattern.  This corruption  always occurred at an offset 256K 
or greater into the file.

(The fact  that the blocks were zeroed is due to the previous scrubbing, 
I  believe.  The actual
failures seen that we have been trying to chase  showed non-zero content 
that was recognized as
being previously written  to the disk.  It also showed a data loss of 
between 1 and 3  contiguous
blocks of data on the corrupted files.)

After much  experimenting the following has been established:

1. The problem shows  with both external and internal journaling.
2. Total size of file system used  does not matter, but percentage does: 
a 140 GByte
partition filled 50% shows no corruption, while a 70 GByte partition 
filled  98% does.
3. File system creation options do not matter; the using the  default 
mkfs.xfs settings
shows corruption, too.
4.  The offset where file corruption begins changes with chunk size: when  
changed
to 128K, corruption started being  detected as low as 128K into the 
file.
5. Issuing "sync" commands before  unmount/mount had no effect.
6. Rebooting the system had the same affect as  unmount/mount cycles.
7. The file system must be full to show the  problem.  The 70% mark was 
established
during one test cycle by grouping files into directories, ~100 
files  per.  All directories
containing corrupted  files were deleted - after which the file 
system showed 68%  full.
Repeated attempts to reproduce the problem by  filling the file 
system to only 50% full
have  failed.
8. No errors are reported in the system log.  No errors are  reported 
when remounting
the file system,  either.  And "xfs_check" on the partition shows no 
problems.
9. The  failure has been repeated on multiple systems.
10. The problem does not  reproduce when using ext3 or reiserfs on the 
"md0"  partition.
So far, only XFS shows this  problem.


What is NOT known yet:
1. We have only used 2-disk  RAID0.  Unknown the affect of 3-disk or greater.
2. We have only tried  128K  and 256K chunk sizes.  We will be trying 64K  and
32K chunks tomorrow.
3. I do not know if a minimum  partition size is required.  We have tested as
small  as 32 GBytes, and that fails.
4. I know that the 2nd chunk is where the  corruption occurs - I do not know
if any chunk beyond the  2nd is affected.   This will be checked 
tomorrow.
5. We have  only tested software RAID0.  The test needs to be repeated on 
the  other
RAID modes.
6. We have only checked 2.6.8-rc2 and  2.6.11.  Prior and intermediate 
kernels may
show  the problem, too.
7. We have not tried JFS yet.  That will be done  tomorrow.


The behavior has been very repeatable, and actually  resembles a 
kernel.org bugzilla bug #2336,
"Severe data corrupt on XFS  RAID and XFS LVM dev after reboot",  which 
has been (I  think
incorrectly) marked as a dup of kernel.org bugzilla bug 2155, "I/O (  
filesystem ) sync issue".
It does not appear as if either of these bugs  have been resolved, nor 
were they really generally
reproducible as  described in the original bug reports.  This is (I think).

One final  though (before my pleading for help) is that the system 
appears to be acting  like
some file cache pages are getting "stuck" or "lost" somehow.  I say  this 
because writing/creating
>40 GBytes of new files after the  corruption starts on a system with 2 
GBytes of physical memory
should  have flushed out all previous file references/pages.  Instead, 
reading  back >ANY< file prior
to rebooting/unmounting will show no corruption -  the data is still in 
some file cache rather than
pushed to disk.   Once you unmount, the data is gone and the original 
disk content shows  through.


Now the pleading:

Can anyone  duplicate this?  And if not, where should I be looking to 
what could be  causing
this behavior?


Thanks,

Jim  Foris
 

--part1_5b.65943ac5.2f6976c0_boundary
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <linux-xfs-bounce@oss.sgi.com>
Received: from  rly-xh04.mx.aol.com (rly-xh04.mail.aol.com [172.20.115.233]) by air-xh02.mail.aol.com (v104.18) with ESMTP id MAILINXH23-4a44237d93db1; Wed, 16 Mar 2005 01:59:34 -0500
Received: from  oss.sgi.com (oss.sgi.com [192.48.159.27]) by rly-xh04.mx.aol.com (v104.18) with ESMTP id MAILRELAYINXH48-4a44237d93db1; Wed, 16 Mar 2005 01:59:09 -0500
Received: from oss.sgi.com (localhost [127.0.0.1])
	by oss.sgi.com (8.13.0/8.13.0) with ESMTP id j2G6wxB4019388;
	Tue, 15 Mar 2005 22:58:59 -0800
Received: with ECARTIS (v1.0.0; list linux-xfs); Tue, 15 Mar 2005 22:58:57 -0800 (PST)
Received: from ms-smtp-02.rdc-kc.rr.com (ms-smtp-02.rdc-kc.rr.com [24.94.166.122])
	by oss.sgi.com (8.13.0/8.13.0) with ESMTP id j2G6woKT019371
	for <linux-xfs@oss.sgi.com>; Tue, 15 Mar 2005 22:58:50 -0800
Received: from [192.168.2.2] (rrcs-67-52-12-36.west.biz.rr.com [67.52.12.36])
	by ms-smtp-02.rdc-kc.rr.com (8.12.10/8.12.7) with ESMTP id j2G6MCY1000631
	for <linux-xfs@oss.sgi.com>; Wed, 16 Mar 2005 00:22:13 -0600 (CST)
Message-ID: <4237C29B.2020001@wi.rr.com>
Date: Tue, 15 Mar 2005 23:22:35 -0600
From: James Foris <jforis@wi.rr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20041116
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-xfs@oss.sgi.com
Subject: XFS file corruption bug ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV 0.83/762/Sun Mar 13 15:35:33 2005 on oss.sgi.com
X-Virus-Scanned: ClamAV 0.83/762/Sun Mar 13 15:35:33 2005 on oss.sgi.com
X-Virus-Scanned: Symantec AntiVirus Scan Engine
X-Virus-Status: Clean
X-archive-position: 5092
X-ecartis-version: Ecartis v1.0.0
Sender: linux-xfs-bounce@oss.sgi.com
Errors-to: linux-xfs-bounce@oss.sgi.com
X-original-sender: jforis@wi.rr.com
Precedence: bulk
X-list: linux-xfs
X-AOL-IP: 192.48.159.27
X-Mailer: Unknown (No Version)

I may have found a way to reproduce a file corruption bug and I would 
like to know
if I am seeing something unique to our environment, or if this is a 
problem for everyone.

Summary: when writing to a XFS formated software raid0 partition which 
is > 70% full,
unmounting, then remounting the partition will show random 4K block file 
corruption in
files larger than the raid chunk size.  We (myself and a coworker)  have 
tested 2.6.8-rc2-bk5
and 2.6.11; both show the same behavior.


The original test configuration was using a HP8000, 2 GBytes RAM, with  
2.6.8-rc2-bk5 smp kernel,
1-36 GB system disk, 2-74 GB data disk configured as a single RAID0 
partition with 256K
chunk size.  This "md0" partition is formatted as XFS with external 
journal on the system disk:

    /sbin/mkfs.xfs -f -l logdev=/dev/sda5,sunit=8 /dev/md0

using tools from "xfsprogs-2.6.25-1".

First the partition was zeroed ("dd if=dev/zero of=/dev/md0 ....."), 
then a known pattern
was written in 516K files (4K + 2 x 256K).  The partition (~140 GBytes) 
was filled to 98%,
then the partition was first unmounted, then remounted.

On checking the sum of each file, is was found that some file checksums 
were not as expected.
Examination of the mismatched files showed that one 4K block in the file 
contained zeros, not
the expected pattern.  This corruption always occurred at an offset 256K 
or greater into the file.

(The fact that the blocks were zeroed is due to the previous scrubbing, 
I believe.  The actual
failures seen that we have been trying to chase showed non-zero content 
that was recognized as
being previously written to the disk.  It also showed a data loss of 
between 1 and 3 contiguous
blocks of data on the corrupted files.)

After much experimenting the following has been established:

1. The problem shows with both external and internal journaling.
2. Total size of file system used does not matter, but percentage does: 
a 140 GByte
    partition filled 50% shows no corruption, while a 70 GByte partition 
filled 98% does.
3. File system creation options do not matter; the using the default 
mkfs.xfs settings
    shows corruption, too.
4. The offset where file corruption begins changes with chunk size: when 
changed
     to 128K, corruption started being detected as low as 128K into the 
file.
5. Issuing "sync" commands before unmount/mount had no effect.
6. Rebooting the system had the same affect as unmount/mount cycles.
7. The file system must be full to show the problem.  The 70% mark was 
established
     during one test cycle by grouping files into directories, ~100 
files per.  All directories
     containing corrupted files were deleted - after which the file 
system showed 68% full.
     Repeated attempts to reproduce the problem by filling the file 
system to only 50% full
     have failed.
8. No errors are reported in the system log.  No errors are reported 
when remounting
    the file system, either.  And "xfs_check" on the partition shows no 
problems.
9. The failure has been repeated on multiple systems.
10. The problem does not reproduce when using ext3 or reiserfs on the 
"md0" partition.
       So far, only XFS shows this problem.


What is NOT known yet:
1. We have only used 2-disk RAID0.  Unknown the affect of 3-disk or greater.
2. We have only tried 128K  and 256K chunk sizes.  We will be trying 64K and
    32K chunks tomorrow.
3. I do not know if a minimum partition size is required.  We have tested as
    small as 32 GBytes, and that fails.
4. I know that the 2nd chunk is where the corruption occurs - I do not know
    if any chunk beyond the 2nd is affected.   This will be checked 
tomorrow.
5. We have only tested software RAID0.  The test needs to be repeated on 
the other
    RAID modes.
6. We have only checked 2.6.8-rc2 and 2.6.11.  Prior and intermediate 
kernels may
    show the problem, too.
7. We have not tried JFS yet.  That will be done tomorrow.


The behavior has been very repeatable, and actually resembles a 
kernel.org bugzilla bug #2336,
"Severe data corrupt on XFS RAID and XFS LVM dev after reboot",  which 
has been (I think
incorrectly) marked as a dup of kernel.org bugzilla bug 2155, "I/O ( 
filesystem ) sync issue".
It does not appear as if either of these bugs have been resolved, nor 
were they really generally
reproducible as described in the original bug reports.  This is (I think).

One final though (before my pleading for help) is that the system 
appears to be acting like
some file cache pages are getting "stuck" or "lost" somehow.  I say this 
because writing/creating
 >40 GBytes of new files after the corruption starts on a system with 2 
GBytes of physical memory
should have flushed out all previous file references/pages.  Instead, 
reading back >ANY< file prior
to rebooting/unmounting will show no corruption - the data is still in 
some file cache rather than
pushed to disk.  Once you unmount, the data is gone and the original 
disk content shows through.


Now the pleading:

    Can anyone duplicate this?  And if not, where should I be looking to 
what could be causing
    this behavior?


Thanks,

Jim Foris
















--part1_5b.65943ac5.2f6976c0_boundary--

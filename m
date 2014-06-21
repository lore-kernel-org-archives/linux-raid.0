From: Bill <billstuff2001@sbcglobal.net>
Subject: raid5 (re)-add recovery data corruption
Date: Sat, 21 Jun 2014 00:31:39 -0500
Message-ID: <53A518BB.60709@sbcglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

I'm running a test on 3.14.8 and seeing data corruption after a recovery.
I have this array:

     md5 : active raid5 sdc1[2] sdb1[1] sda1[0] sde1[4] sdd1[3]
           16777216 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
           bitmap: 0/1 pages [0KB], 2048KB chunk

with an xfs filesystem on it:
     /dev/md5 on /hdtv/data5 type xfs 
(rw,noatime,barrier,swalloc,allocsize=256m,logbsize=256k,largeio)

and I do this in a loop:

1. start writing 1/4 GB files to the filesystem
2. fail a disk. wait a bit
3. remove it. wait a bit
4. add the disk back into the array
5. wait for the array to sync and the file writes to finish
6. checksum the files.
7. wait a bit and do it all again

The checksum QC will eventually fail, usually after a few hours.

My last test failed after 4 hours:

     18:51:48 - mdadm /dev/md5 -f /dev/sdc1
     18:51:58 - mdadm /dev/md5 -r /dev/sdc1
     18:52:06 - start writing 3 files
     18:52:08 - mdadm /dev/md5 -a /dev/sdc1
     18:52:18 - array recovery done
     18:52:23 - writes finished. QC failed for one of three files.

dmesg shows no errors and the disks are operating normally.

If I "check" /dev/md5 it shows mismatch_cnt = 896
If I dump the raw data on sd[abcde]1 underneath the bad file, it shows
sd[abde]1 are correct, and sdc1 has some chunks of old data from a 
previous file.

If I fail sdc1, --zero-superblock it, and add it, it then syncs and the 
QC is correct.

So somehow is seems like md is loosing track of some changes which need 
to be
written to sdc1 in the recovery. But rarely - in this case it failed 
after 175 cycles.

Do you have any idea what could be happening here?

Thanks,
Bill


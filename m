From: Ole Tange <tange@binf.ku.dk>
Subject: --grow RAID6 gives: md: md_do_sync() got signal ... exiting + hang
Date: Tue, 7 May 2013 13:36:56 +0200
Message-ID: <CANU9nTmqXjPFqU=p0vex2SgXjyv9L2NO5mafHoWqfH7n1kkhcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am expanding my 9 harddisk RAID6 to 10 harddisk RAID6:

md1 : active raid6 sdg[0] sdi[12](S) sdt[15](S) sdy[17](S) sdx[16](S)
sdh[8] sdw[13] sdo[14] sdk[5] sdd[11] sdc[3] sdv[9] sdn[10]
      27349121408 blocks super 1.2 level 6, 128k chunk, algorithm 2
[9/9] [UUUUUUUUU]
      bitmap: 2/2 pages [8KB], 1048576KB chunk

It is, however, hanging the system.

# remove the bitmap
mdadm -v --grow /dev/md1 -b none

# Do the reshape
mdadm -v --grow /dev/md1 --raid-devices=10
--backup-file=/root/back-md1
mdadm: Need to backup 7168K of critical section..

cat /proc/mdstat
<<hangs>>

dmesg says:

[4328128.021614] md: reshape of RAID array md1
[4328128.021618] md: minimum _guaranteed_  speed: 10000 KB/sec/disk.
[4328128.021621] md: using maximum available idle IO bandwidth (but
not more than 30000 KB/sec) for reshape.
[4328128.021783] md: using 128k window, over a total of 3907017344k.
[4328128.312637] md: md_do_sync() got signal ... exiting

Disk I/O is blocked to the RAID.

What to do?


/Ole

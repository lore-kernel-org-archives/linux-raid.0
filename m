From: "Jeffrey W. Baker" <jwbaker@acm.org>
Subject: Just plain bad RAID5 performance?
Date: Thu, 13 May 2004 17:08:14 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1084493294.20832.24.camel@noodles>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have this array:

md0 : active raid5 sdb[0] sdd[2] sdc[1]
      145225728 blocks level 5, 256k chunk, algorithm 2 [3/3] [UUU]

... on three Western Digital Raptor 74GB drives.  These are attached
with a 3ware 8506-8 SATA thingy, the fs is ext2 w/ 4096 block size.

Basic test: dd from all three devices at once.  Aggregate I/O: roughly
150MB/sec, > 95% CPU usage.  dd from /dev/md0: about 60MB/sec, < 30% CPU
usage.  Any way to improve this result?  I would expect it to be at
least 100MB/sec.

More complicated test: single postgresql query on a 40GB database. 
Query uses three index scans, so it is highly random access.  On the
RAID i'm getting about 10-20 tps per device, about 4MB/sec effective
aggregate throughput, according to iostat.  On a single 5-year-old SCSI
device I get 1000s of tps and the query finishes roughly 20 times
faster.  What could I be seeing here?

The machine is a dual opteron, so I doubt that the CPU is starving the
RAID5 XOR routines or anything silly like that.

Software is: Linux 2.4.26, PostgreSQL 7.4.2.

Any information appreciated.

-jwb

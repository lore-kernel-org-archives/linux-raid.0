From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: howto on performance
Date: Mon, 11 Feb 2008 18:22:35 +0100
Message-ID: <20080211172235.GA25678@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have put up a new howto text on performance:
http://linux-raid.osdl.org/index.php/Performance#Performance_of_raids_with_2_disks

Enjoy!
Keld

=Performance of raids with 2 disks=

I have made some testing of performance of different types of RAIDs,
with 2 disks involved. I have used my own home grown testing methods,
which are quite simple, to test sequential and random reading and writing of 
200 files of 40 MB. The tests were meant to see what performance I could 
get out of a system mostly oriented towards file serving, such as a mirror site.

My configuration was

    1800 MHz AMD Sempron(tm) Processor 3100+
    1500 MB RAM
    2 x  Hitachi Ultrastar SCSI-II 1 TB.
    Linux version 2.6.12-26mdk

Figures are in MB/s, and the file system was ext3. Times were measured with iostat,
and an estimate for steady performance was taken. The times varied quite 
a lot over the different 10 second intervals, for example the estimate 155 MB/s
ranged from 135 MB/s to 163 MB/s. I then looked at the avearge over the period when
a test was running in full scale (all processes started, and none stopped).

    RAID type      sequential read     random read    sequential write   random write
    Ordinary disk       82                 34                 67                56
    RAID0              155                 80                 97                80
    RAID1               80                 35                 72                55
    RAID10              79                 56                 69                48
    RAID10,f2          150                 79                 70                55

Random read for RAID1 and RAID10 were quite unbalanced, almost only coming out of one of the disks.

The results are quite as expected:

RAID0 and RAID10,f2 reads are double speed compared to ordinary file system for sequential reads
(155 vs 82) and more than double for random reads (80 vs 35).

Writes (both sequential and random) are roughly the same for ordinary disk, RAID1, RAID10 and
RAID10,f2, around 70 MB/s for sequential, and 55 MB/s for random.

Sequential reads are about the same (80 MB/s) for ordinary partition, RAID1 and RAID10.

Rndom reads for ordinary partition and RAID1 is about the same (35 MB/s) and about 50 % higher for
RAID10. I am puzzled why RAID10 is faster than RAID1 here.

All in all RAID10,f2 is the fastest mirrored RAID for both sequential and random reading for this test,
while it is about equal with the other mirrored RAIDs when writing.

My kernel did not allow me to test RAID10,o2 as this is only supported from kernel 2.6.18.

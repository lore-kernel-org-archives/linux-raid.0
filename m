From: Marc MERLIN <marc@merlins.org>
Subject: Buffer I/O error on dev md5, logical block 7073536, async page read
Date: Sat, 29 Oct 2016 19:16:14 -0700
Message-ID: <20161030021614.asws67j34ji64qle@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy,

I'm struggling with this problem.

I have this md5 array with 5 drives:
Personalities : [linear] [raid0] [raid1] [raid10] [multipath] [raid6] [raid5] [raid4] 
md5 : active raid5 sdg1[0] sdh1[6] sdf1[2] sde1[3] sdd1[5]
      15627542528 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
      bitmap: 0/30 pages [0KB], 65536KB chunk

I started having filesystem problems with it, so I did a scan with hdrecover on the drives first,
and that passed. Then I did it on the md5 array, and it failed.

With a simple dd, I get this:

25526374400 bytes (26 GB) copied, 249.888 s, 102 MB/s
dd: reading `/dev/md5': Input/output error
56588288+0 records in
56588288+0 records out
28973203456 bytes (29 GB) copied, 283.325 s, 102 MB/s
[1]+  Exit 1                  dd if=/dev/md5 of=/dev/null
kernel: [202693.708639] Buffer I/O error on dev md5, logical block 7073536, async page read

Yes, I can read the entire disk devices without problem (took a long time
to run, but it finished)

Can someone tell me how this is possible?
More generally, is it possible for the kernel to return an md error and then not log
any underlying hardware error on the drives the md was being read from?

Kernel 4.6.0. I'll upgrade just in case, but md has been stable enough for so many years that I'm 
thinking the problem is likely elsewhere.

Any ideas?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

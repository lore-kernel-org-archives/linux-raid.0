From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Odd IO traffic during raid5 reshape
Date: Thu, 18 Apr 2013 20:48:22 +0200
Message-ID: <20130418184822.GB16749@frosties>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm currently upgrading a NAS system with new disks. Since I'm
changing the filesystem type and due to a lack of enough SATA ports I
have to do add one new disk at a time, copy data, shrink the old
filesystem, remove an old disks and repeat. I've started with a 2 disk
raid5, copied data, freed a 3rd SATA slot and added the 3rd new disk.

Now I'm reshaping the new raid5 from 2 disks to 3 disks:

md0 : active raid5 sdd1[3] sdc1[2] sda1[0]
      3907015168 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
      [==>..................]  reshape = 14.0% (547848840/3907015168) finish=1355.4min speed=41302K/sec

so far everything works fine. But the speed is rather low and the IO
traffic is higher than I think it should be:

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             604.33     81706.00     40904.73    4902360    2454284
md0               0.00         0.00         0.00          0          0
sdc             440.78     81839.40     40542.07    4910364    2432524
sdd             509.72         0.00     40817.67          0    2449060

To reshape the kernel needs to read 1 data block from sda, 1 data
block from sdc, compute the XOR of both blocks and write 2 data blocks
+ parity block back to the 3 disks. The kernel read 160MB/s, add
80MB/s parity and it should write 240MB/s (or 80MB/s per disk).
Instead it only writes 120MB/s (40MB/s per disk), only half of what I
expect.

So what is going on there? Is the kernel reading both data and parity
blocks and verifying them?

MfG
	Goswin

PS: please CC me on replies.

From: Bill Davidsen <davidsen@tmr.com>
Subject: Odd (slow) RAID performance
Date: Thu, 30 Nov 2006 09:13:10 -0500
Message-ID: <456EE6F6.6000808@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pardon if you see this twice, I sent it last night and it never showed up...

I was seeing some bad disk performance on a new install of Fedora Core 
6, so I did some measurements of write speed, and it would appear that 
write performance is so slow it can't write my data as fast as it is 
generated :-(

The method: I wrote 2GB of data to various configurations with

	sync; time bash -c "dd if=/dev/zero bs=1024k count=2048 of=XXXXX; sync"

where XXXXX was a raw partition, raw RAID device, or ext2 filesystem 
over a RAID device. I recorded the time reported by dd, which doesn't 
include a final sync, and total time from start of write to end of sync, 
which I believe represents the true effective performance. All tests 
were run on a dedicated system, with the RAID devices or filesystem 
freshly created.

For a baseline, I wrote to a single drive, single raw partition, which 
gave about 50MB/s transfer. Then I created a RAID-0 device, striped over 
three test drives. As expected this gave a speed of about 147 MB/s. Then 
I created an ext2 filesystem over that device, and the test showed 139 
MB/s speed. This was as expected.

Then I stopped and deleted the RAID-0 and built a RAID-5 on the same 
partitions. A write to this raw RAID device showed only 37.5 MB/s!! 
Putting an ext2 f/s over that device dropped the speed to 35 MB/s. Since 
I am trying to write bursts at 60MB/s, this is a serious problem for me.

Then I recreated a new RAID-10 array on the same partitions. This showed 
a write speed of 75.8 MB/s, double the speed even though I was 
(presumably) writing twice the data. And and ext2 f/s on that array 
showed 74 MB/s write speed. I didn't use /proc/diskstats to gather 
actual counts, nor do I know if they show actual transfer data below all 
the levels of o/s magic, but that sounds as if RAID-5 is not working 
right. I don't have enough space to use RAID-10 for incoming data, so 
that's not an option.

Then I thought that perhaps my chunk size, defaulted to 64k, was too 
small. So I created and array with 256k chunk size. That showed about 36 
MB/s to the raw array, and 32.4 MB/s to an ext2 f/s using the array. 
Finally I decided to create a new f/s using the "stride=" option, and 
see if that would work better. I had 256k chunks, two data and a parity 
per stripe, so I used the data size, 512k, for calculation. The man page 
says to use the f/s block size, 4k in this case, for calculation, so 
512/4 was 128 stride size, and I used that. The increase was below the 
noise, about 50KB/s faster.

Any thoughts on this gratefully accepted, I may try the motherboard RAID 
if I can't make this work, and it certainly explains why my swapping is 
so slow. That I can switch to RAID-1, it's used mainly for test, big 
data sets and suspend. If I can't make this fast I'd like to understand 
why it's slow.

I did make the raw results 
<http://www.tmr.com/%7Edavidsen/RAID_speed.html> available if people 
want to see more info.
http://www.tmr.com/~davidsen/RAID_speed.html

-- 
Bill Davidsen <davidsen@tmr.com>
  "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


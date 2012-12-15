From: John Robinson <john.robinson@anonymous.org.uk>
Subject: I love md RAID
Date: Sat, 15 Dec 2012 11:11:07 +0000
Message-ID: <50CC5ACB.7090500@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Currently reshaping a 3TB (5-drive) RAID6 with 512K chunk into a 4TB 
(6-drive) RAID6 with 64K chunk.

Having set
   echo 750000 > /proc/sys/dev/raid/speed_limit_min
   echo 750000 > /proc/sys/dev/raid/speed_limit_max
   echo 8192 > /sys/block/md1/md/stripe_cache_size

I am seeing /proc/mdstat report a reshape speed of ~40000K/sec. Viewing 
iostat though shows 5 drives reading at ~50MB/s and 6 drives writing at 
~40MB/s - probably about as fast as these SATA drives can manage. So in 
fact the reshape is proceeding at ~160MB/sec of real data. Fantastic!

Perhaps slightly interestingly, I see slightly lower tps (transactions 
per second) numbers on two of the drives. They happen to be Seagates, 
while the others are Samsungs and Hitachis. I wonder whether the 
Seagates accept larger read/write requests than the others, and the 
kernel is able to amalgamate multiple requests, so we see slightly lower 
tps.

Neil and everyone else concerned, thank you very much for all your 
excellent work!

Cheers,

John.

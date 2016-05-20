From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Mystery RCWs
Date: Fri, 20 May 2016 17:46:51 -0500
Message-ID: <CAE9DZUQCOZN-nX3Z6uQxkFD_yCxDVomCK=G9AnYMTjjWReJRtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

I've got a new little piece of NAS hardware I am working with and
trying to evaluate RAID 5, 6 performance on it.  It has an ARM based
Annapurna Alpine SoC which apparently has a built-in XOR engine to
help out with RAID 5, 6.  This little box has four spinning drives
which each have a transfer rate of about 150 MB/s.

I am only seeing a little over 200 MB/s sequential write throughput
for RAID 6 as measured with fio.  This is a bit disappointing.  I was
hoping that if writing stripe-aligned blocks I would get at least 250
MB/s.

I am measuring the peformance of writing 1M blocks to the array.  My
RAID 6 array was constructed with a 512KB chunk size.

# fio --runtime=30 --ramp_time=5 --numjobs=4 --iodepth=32
--ioengine=libaio --direct=1 --filename=/dev/md10 --bs=1M --rw=write
-name poi

I am expecting with a 512KB chunk size that I will be writing stripe
aligned blocks.

I then used blktrace to see what is going on suspecting that there
might be excessive RMWs.  I did not see any RMWs but I did see many
RCWs (about 20K).

 9,10   3       66     0.701873200 22465  Q  WS 347136 + 1024 [fio]
  9,10   3       67     0.701925540 22465  U   N [fio] 16
  9,10   3       68     0.702259400 22465  Q  WS 348160 + 1024 [fio]
  9,10   3       69     0.702324340 22465  Q  WS 349184 + 1024 [fio]
  9,10   3       70     0.702378960 22465  U   N [fio] 16
  9,10   3       71     0.702627200 22465  Q  WS 350208 + 1024 [fio]
  9,10   3       72     0.702668180 22465 UT   N [fio] 10
  9,10   0      287     0.666149800  6504  C  WS 300032 [0]
  9,10   0      288     0.666154080  6504  C  WS 299008 [0]
  9,10   0      289     0.666491900  6504  C  WS 301056 [0]
  9,10   0      290     0.666495620  6504  C  WS 302080 [0]
  9,10   0      291     0.669055940  6504  C  WS 305152 [0]
  9,10   0      292     0.669059720  6504  C  WS 306176 [0]
  9,10   0        0     0.671655160     0  m   N raid5 rcw 168960 1 1 0
  9,10   0        0     0.671671240     0  m   N raid5 rcw 169024 1 1 0
  9,10   0        0     0.671679220     0  m   N raid5 rcw 169088 1 1 0
  9,10   0        0     0.671684620     0  m   N raid5 rcw 169152 1 1 0
  9,10   0        0     0.671697260     0  m   N raid5 rcw 169216 1 1 0
  9,10   0        0     0.671702560     0  m   N raid5 rcw 169280 1 1 0
  9,10   0        0     0.671708620     0  m   N raid5 rcw 169344 1 1 0
  9,10   0        0     0.671713600     0  m   N raid5 rcw 169408 1 1 0

It seems that prior to the RCWs, this process 6504 starts doing some
writes.  It looks like this is the md driver.

# ps -elf | grep 6504
1 S root      6504     2  0  80   0 -     0 md_thr May19 ?
00:00:36 [md10_raid6]

Can anyone explain what the md driver may be doing and why it's
triggering all these RCWs?

By the way this is running on a Annapurna modified 3.10 kernel:

     3.10.20-031020-generic-sa #201311201536 SMP

Thanks,

Dallas

From: "George Spelvin" <linux@horizon.com>
Subject: Why are reads not balanced across my RAID-1?
Date: 24 Jan 2014 05:47:57 -0500
Message-ID: <20140124104757.8256.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com
List-Id: linux-raid.ids

I was doing some bulk reads on an ext4 file system on
a simple mirrored device (3.13 x86_64 kernel):

md2 : active raid1 sdd3[0] sde3[1]
      1932514496 blocks [2/2] [UU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

And I noticed that the reads were all hitting the first disk.
The second was basically idle.  Here's "dstat -d -D md2,sdd,sde":

--dsk/md2-----dsk/sdd-----dsk/sde--
 read  writ: read  writ: read  writ
 510k   55k: 484k   58k:  27k   58k
 129M    0 : 129M    0 :  48k    0
 108M   48k: 108M   60k: 576k   60k
 123M    0 : 123M 8192B:   0  8192B
 133M    0 : 133M    0 : 360k    0
 132M    0 : 132M    0 :  20k    0
 138M    0 : 138M    0 : 304k    0
 128M    0 : 128M    0 : 896k    0
 129M    0 : 129M 4096B:  64k 4096B
 135M    0 : 135M    0 :  36k    0
 116M   12k: 116M   24k:  36k   28k
 117M    0 : 116M 4096B: 632k    0
 127M    0 : 127M    0 : 288k    0
 130M    0 : 130M    0 : 336k    0
 133M    0 : 133M    0 : 212k    0
 134M    0 : 134M    0 : 304k    0
 130M    0 : 129M 4096B: 100k 4096B
 128M    0 : 127M    0 : 280k    0
 106M   12k: 106M   28k: 372k   28k
 129M    0 : 129M    0 : 344k    0
 134M    0 : 134M    0 : 196k    0
 134M    0 : 134M    0 : 384k    0
 129M    0 : 129M    0 : 304k    0

I thought (drivers/md/raid1.c:read_balance()) the driver was
supposed to do some striping on large reads.

While 125M/s is nice, more than that would be nicer.

The drives are identical, but are plugged in to different controllers.
sdd is on an AMD SB600 controller, while sde is on a PDC42819.

Is there some knob I need to adjust to make read balancing happen?

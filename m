From: Gordon Henderson <gordon@drogon.net>
Subject: RE: Raid5 Construction Question
Date: Thu, 19 Aug 2004 19:35:06 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408191923290.15484@lion.drogon.net>
References: <200408191817.i7JIHg313827@watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408191817.i7JIHg313827@watkins-home.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Aug 2004, Guy wrote:

> You don't need to wait.  You can use the array now.

Indeed - but maybe you are already using the array which is why the
rebuild it taking so long?

> But ouch 305K/sec!  If this a 386-33?  :)
>
> Have you tried dd tests on each disk to verify each works well?
>
> Something like:
> time dd if=/dev/sdc1 of=/dev/null bs=64k count=100000
> This is just a read test.  My disks take about 340 seconds.  Yours should be
> about twice as fast.

You can also use hdparm - although really designed for IDE drives, it'll
do the test on SCSI withou any problems:

Eg. on a reasonable PC with an IDE drive:

/dev/hda:
 Timing buffer-cache reads:   1008 MB in  2.00 seconds = 504.00 MB/sec
 Timing buffered disk reads:  142 MB in  3.02 seconds =  47.02 MB/sec


On a SCSI server (Dell 4xxxx something)

/dev/sda:
 Timing buffer-cache reads:   128 MB in  0.18 seconds =711.11 MB/sec
 Timing buffered disk reads:  64 MB in  0.97 seconds = 65.98 MB/sec

This is a RAID1 on the same server

/dev/md0:
 Timing buffer-cache reads:   128 MB in  0.18 seconds =711.11 MB/sec
 Timing buffered disk reads:  64 MB in  1.03 seconds = 62.14 MB/sec

This isa RAID5 on the same server.

/dev/md4:
 Timing buffer-cache reads:   128 MB in  0.18 seconds =711.11 MB/sec
 Timing buffered disk reads:  64 MB in  0.34 seconds =188.24 MB/sec

> Each disk should give about the same performance.
> You may find 1 that has issues.

I've seen this with IDE drives - one drive was very much slower than the
other. No idea why.

How is it configured? Are all 8 drives on the same cable? You might want
to split them and put 4 on a cable with 2 controllers - There may still
issues with PCI bus bandwidth then, but it might help things along. On
that server above, I have 4 SCSI drives, 2 on each bus. sda & b on one
bus, sdc and d on the 2nd. I haven't made tests to see if alternating the
drives in the /etc/raditab makes a difference, but thats what I do anyway
as it "feels" the right thing to do.

Eg:

raiddev /dev/md2
  raid-level            5
  nr-raid-disks         4
  nr-spare-disks        0
  persistent-superblock 1
  chunk-size            32
  device                /dev/sda3
  raid-disk             0
  device                /dev/sdc3
  raid-disk             1
  device                /dev/sdb3
  raid-disk             2
  device                /dev/sdd3
  raid-disk             3

Reading the follow-ups, performance will be slow with the raid-speed-min
parameter set high... If you want performance, during a rebuild, then
set this low.

Gordon

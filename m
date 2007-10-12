From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: raid5: degraded after reboot
Date: Fri, 12 Oct 2007 10:38:55 -0500
Message-ID: <cccedfc60710120838nd2bb38pf57f03faa803b6c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a software raid5 using /dev/sd{a,b,c}4.
It's been up for months, through many reboots.

I had to do a reboot using sysrq

When the box came back up, the raid did not re-assemble.
I am not using bitmaps.

I believe it comes down to this:

<4>md: kicking non-fresh sda4 from array!

what does that mean?

I also have this:

raid5: raid level 5 set md0 active with 2 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
mdadm: forcing event count in /dev/sdb4(1) from 327615 upto 327626

Why was /dev/sda4 kicked?

Contents of /etc/mdadm.conf:

DEVICE /dev/hd*[a-h][0-9] /dev/sd*[a-h][0-9]
ARRAY /dev/md0 level=raid5 num-devices=3
UUID=b4597c3f:ab953cb9:32634717:ca110bfc

Current /proc/mdstat:

md0 : active raid5 sda4[3] sdb4[1] sdc4[2]
      613409664 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]
      [==>..................]  recovery = 13.1% (40423368/306704832)
finish=68.8min speed=64463K/sec

65-70KB/s is about what these drives can do so the rebuild speed is just peachy.

-- 
Jon

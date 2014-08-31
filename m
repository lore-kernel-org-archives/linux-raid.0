From: Fabio Bacigalupo <info1@open-haus.de>
Subject: Re: Seeking help to get a failed RAID5 system back to life
Date: Sun, 31 Aug 2014 11:12:44 +0200
Message-ID: <CAGgRf0RXPcmzN3Bk2uj3UJyNzRxy2p2ijBwgaG=xns=CeC8Nfg@mail.gmail.com>
References: <CAGgRf0Qe1EU6wZm4BbWqs0diwwnBCeStiVAXaOdHV88Ttn=vfw@mail.gmail.com>
	<20140829074627.GA8321@cthulhu.home.robinhill.me.uk>
	<CAGgRf0TZG28nGAHsvZzLkPhYv422GC=r5-km=6OL5-5EXJZQjQ@mail.gmail.com>
	<20140829091018.GB8321@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140829091018.GB8321@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Fabio Bacigalupo <info1@open-haus.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Robin, hello list,

> then you absolutely need that data off the second disk.

I ran ddrescue and it found errors but succeeded in copying the data.

# ddrescuelog -t /root/ddrescue_raid.log

current pos:     1500 GB,  current status: finished
domain size:     1500 GB,  in    1 area(s)
    rescued:     1500 GB,  in    8 area(s)  ( 99.99%)
  non-tried:         0 B,  in    0 area(s)  (  0%)

    errsize:    122368 B,  errors:       7  (  0.00%)
non-trimmed:         0 B,  in    0 area(s)  (  0%)
  non-split:    116736 B,  in    9 area(s)  (  0.00%)
 bad-sector:      5632 B,  in    9 area(s)  (  0.00%)

2014-08-29 11:10 GMT+02:00 Robin Hill <robin@robinhill.me.uk>:
> You'll need to use --assemble --force in order to get the array going
> again afterwards (as the event counts are different on the two disks).

I finally got my RAID array back up and running. Thank you for your
guidance, Robin. There is one last question. The third drive just to
be /dev/sda3 which is now occupied by the system disk. If I add
another disk (a new one) into system it will be /dev/sdd. What do I
need to do to add this to the RAID array? Can it fill the unsed slot
[_UU] or do I have to add it as a new drive to get something like this
[_UUU] ?

It did not work right away. So if anyone stumbles upon this thread
here is what I did:

# mdadm --assemble /dev/md127 /dev/sd[bc]3 --force
mdadm: forcing event count in /dev/sdc3(2) from 68856326 upto 68856340
mdadm: clearing FAULTY flag for device 1 in /dev/md127 for /dev/sdc3
mdadm: Marking array /dev/md127 as 'clean'
mdadm: /dev/md127 assembled from 2 drives - not enough to start the array.

# cat /proc/mdstat
Personalities : [raid1]
md127 : inactive sdb3[1](S) sdc3[2](S)
      2925532672 blocks
unused devices: <none>

# mdadm --stop /dev/md127
mdadm: stopped /dev/md127

# mdadm --assemble /dev/md127 /dev/sd[bc]3 --force
mdadm: /dev/md127 has been started with 2 drives (out of 3).

 # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md127 : active raid5 sdb3[1] sdc3[2]
      2925532672 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]
unused devices: <none>

# fsck /dev/md127

I was lucky this time. fsck complained only twice.

Ciao
Fabio

From: Adam Kropelin <akropel1@rochester.rr.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Sat, 21 Jan 2006 23:42:34 -0500
Message-ID: <20060121234234.A32306@mail.kroptech.com>
References: <20060117174531.27739.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060117174531.27739.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
> In line with the principle of "release early", following are 5 patches
> against md in 2.6.latest which implement reshaping of a raid5 array.
> By this I mean adding 1 or more drives to the array and then re-laying
> out all of the data.

I've been looking forward to a feature like this, so I took the
opportunity to set up a vmware session and give the patches a try. I
encountered both success and failure, and here are the details of both.

On the first try I neglected to read the directions and increased the
number of devices first (which worked) and then attempted to add the
physical device (which didn't work; at least not the way I intended).
The result was an array of size 4, operating in degraded mode, with 
three active drives and one spare. I was unable to find a way to coax
mdadm into adding the 4th drive as an active device instead of a 
spare. I'm not an mdadm guru, so there may be a method I overlooked.
Here's what I did, interspersed with trimmed /proc/mdstat output:

  mdadm --create -l5 -n3 /dev/md0 /dev/sda /dev/sdb /dev/sdc

    md0 : active raid5 sda[0] sdc[2] sdb[1]
          2097024 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

  mdadm --grow -n4 /dev/md0

    md0 : active raid5 sda[0] sdc[2] sdb[1]
          3145536 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

  mdadm --manage --add /dev/md0 /dev/sdd

    md0 : active raid5 sdd[3](S) sda[0] sdc[2] sdb[1]
          3145536 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

  mdadm --misc --stop /dev/md0
  mdadm --assemble /dev/md0 /dev/sda /dev/sdb /dev/sdc /dev/sdd

    md0 : active raid5 sdd[3](S) sda[0] sdc[2] sdb[1]
          3145536 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

For my second try I actually read the directions and things went much
better, aside from a possible /proc/mdstat glitch shown below.

  mdadm --create -l5 -n3 /dev/md0 /dev/sda /dev/sdb /dev/sdc

    md0 : active raid5 sda[0] sdc[2] sdb[1]
          2097024 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

  mdadm --manage --add /dev/md0 /dev/sdd

    md0 : active raid5 sdd[3](S) sdc[2] sdb[1] sda[0]
          2097024 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

  mdadm --grow -n4 /dev/md0

    md0 : active raid5 sdd[3] sdc[2] sdb[1] sda[0]
          2097024 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
                                ...should this be... --> [4/3] [UUU_] perhaps?
          [>....................]  recovery =  0.4% (5636/1048512) finish=9.1min speed=1878K/sec

    [...time passes...]

    md0 : active raid5 sdd[3] sdc[2] sdb[1] sda[0]
          3145536 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

My final test was a repeat of #2, but with data actively being written
to the array during the reshape (the previous tests were on an idle,
unmounted array). This one failed pretty hard, with several processes
ending up in the D state. I repeated it twice and sysrq-t dumps can be
found at <http://www.kroptech.com/~adk0212/md-raid5-reshape-wedge.txt>.
The writeout load was a kernel tree untar started shortly before the
'mdadm --grow' command was given. mdadm hung, as did tar. Any process
which subsequently attmpted to access the array hung as well. A second
attempt at the same thing hung similarly, although only pdflush shows up
hung in that trace. mdadm and tar are missing for some reason.

I'm happy to do more tests. It's easy to conjur up virtual disks and
load them with irrelevant data (like kernel trees ;)

--Adam


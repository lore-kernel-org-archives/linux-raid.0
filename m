From: Andrew McCready <ajmccready@yahoo.com>
Subject: raid0 problem starting
Date: Sat, 25 Sep 2004 11:40:19 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040925184019.12881.qmail@web50107.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have two sata disks in a raid0 array that show up on
my system as hde and hdg. I tried adding an ide pata
card, so I could add a few temporary disks to the
system . That didn't go so well. However, I wasn't
able to boot far enough to modify anything on the hard
drives, so I pulled the pata card out and rebooted.
Now, I'm getting the following error while starting
the raid array:

md: could not lock [dev 38:01], zero-size? Marking
faulty.
md: could not import [dev 38:01], trying to run array
nevertheless.
md: could not lock [dev 39:01], zero-size? Marking
faulty.
md: could not import [dev 39:01], trying to run array
nevertheless.

then a few lines later

md: device name has changed from [dev 38:01] to hde1
since last import!

I'm assuing its getting the old device names from the
persistent-superblock, but I thought I'd at least be
able to raidstart with a correct /etc/raidtab (it
hasn't changed since I built the array), but I get the
same errors then.

I checked /dev, and there are no devices with a major
number of 38 or 39. hde is 33 and hdg is 34. I don't
know enough about the device system to know what would
make those numbers change (but I was under the
impression that they were pretty much 100% static),
but the big question is, how can I get my raid0 array
back? (or is this all a red herring and the disks are
actually toast?)


Thanks, Andrew


ps. I just checked the smart data on the disks, and
one has just one error and the other had 35, but the
last errors occured after 390 hours, and the current
power_on_hours is 4287. 



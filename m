From: Dovli X <the_dovlets@yahoo.com>
Subject: Replacing a RAID 1 array
Date: Wed, 24 Apr 2002 05:07:46 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020424120746.33046.qmail@web13707.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I intend to change the RAID configuration on a RedHat
Linux server(with kernel 2.4.9-6) that uses raidtools
0.90.
At this moment I have a RAID 1 array made up of two
devices /dev/hde2 and /dev/hdg2. The problem is these
are 20MB hard drives and they're almost full at this
moment. I have another 2 60GB drives that I intend to
use instead of those two disks. Another problem is
that I cannot keep the 20GB drives that are to be
moved on another server.
Here is my scenario for the move , I would like to
know whether this is possible:
1) install the two 60Gb hard-drives as /dev/hdf and
/dev/hdh (slaves on the two IDE buses used by the
current RAID installation)
2) initialize a new RAID 1 device /dev/md1 made up of
/dev/hdf2 and /dev/hdh2 format it.
3) copy the contents of the first RAID device
(/dev/md0/) to the new RAID(/dev/md1) device.
Now comes the hard part that I am not sure it will
work:
4) stop /dev/md0 and /dev/md1. Update /etc/raidtab to
leave only the second RAID installation with the 60Gb
hard disks repositioned as masters on the IDE buses (
I also want to physically move the new disks in the
position of the old disks)
5) turn off the computer and eject the old hard drives
and reposition the new hard-drives
6)Turn the computer on and pray to God it works

Will that work? Is there another way to do that? I
need your help
Thank you very much for your support
Dovli 


__________________________________________________
Do You Yahoo!?
Yahoo! Games - play chess, backgammon, pool and more
http://games.yahoo.com/

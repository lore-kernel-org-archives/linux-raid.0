From: Tom Oehser <tom@toms.net>
Subject: mount-by-label finds drive not array ????
Date: Thu, 1 Jul 2004 07:41:27 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407010736180.15444@jupiter.toms.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I'm accustomed to doing something like:

LABEL=tomsvol2  /mnt/foo   ext3      defaults        0 2

But if I do that on my raid-5 md arrays, it tries to mount
disk 1 of the 4 disks that make up the array!  Apparently,
the first stripe has enough of the filesystem that it must
be thinking that is what to mount!  Even with type "FD"!!!

So, with an array /dev/md0 made of hda1 hdb1 hdc1 hdd1, I
am having to do a literal:

/dev/md0        /mnt/bar      ext3      defaults        0 4

Since if I do it by "LABEL=", it tries to mount hda1, not md0!

Is this just a known/accepted brain-deadness of the mount code?

-Tom


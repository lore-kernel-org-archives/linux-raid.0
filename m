From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: RAID1 Mirroring question.
Date: Mon, 5 Apr 2004 12:50:00 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404051242480.13902-100000@coffee.psychology.mcmaster.ca>
References: <E1BAVLe-0001EM-00@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1BAVLe-0001EM-00@intern.SerNet.DE>
To: Timo.Bolse@SerNet.DE
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> We have a Linux Software RAID1 (mirroring). If there is a little error on one
> of the disks (such a little error that the kernel dosn't recognize it). There
> is a read request on the raid for a specific file. The output of one of the
> disks differ from the output of the other disk. (But there are no errors 
> recognized by the kernel / fs / raid-driver. Only one inverted bit for example)
> What is RAID/MD doing? Are there checksums for the original file?

afaikt, MD raid1 assumes that any data-corrupting errors are reported.
if the device corrupts data and lies to the driver/kernel/md, then you
are in trouble.  this applies to both reads and writes.

it's easy to imagine a ckraid1 tool that somehow forces reads of all
copies of each block. but with two mirrors, there would presumably
be no way to decide which to use...

all that said, I've never seen this happen.

then again, raid1 is a sort of ugly niche feature, IMO.  how many 
systems can afford two but not three disks?  raid5 is not scary!

regards, mark hahn.



From: Flemming Frandsen <ff@partyticket.net>
Subject: Non-equal sized partitions vs RAID 1
Date: Mon, 01 Jul 2002 13:29:46 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D203D2A.5030307@partyticket.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have two disks in my box, both are MAXTOR 6L080L4 (80GB IDE) and 
physically the same disks, both have 3 partitions, one for /boot one for 
swap and one huge one for the rest for the mirrored data.

The mirror works as expected, but somewhere something went slightly 
wrong because one disks geometry is:
physical     155114/16/63
logical      155114/16/63

The other disk is:
physical     155114/16/63
logical      9732/255/63

Now, this has the annoying sideeffect of making it impossible for me to 
partition them exactly the same way, so I ended up creating the mirror 
on disk 1 (which has a slightly smaller partition for mirroring than 
disk 2) and then adding disk 2 later.

This will get me in trouble (I tested it) when disk 1 fails and I need 
to replace it, because then I have to make that partition slightly 
larger than the disk 2 partition so it can be added to the mirror.

Now for the questions:
* Is there a way to change the logical geometry of disk 2, so I can 
partition correctly (well if there is then this post is OT)?

* Is there a way to force the array to keep being the same size, even 
after the smaller partition has failed?

* Why does the BIOS think that it's cool to translate similar disks 
differently, are BIOS writers crackheads or was I just unlucky?


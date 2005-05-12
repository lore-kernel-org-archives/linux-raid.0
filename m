From: "janaka@clanwind.com" <janaka@clanwind.com>
Subject: Failed RAID5
Date: Thu, 12 May 2005 02:43:23 -0600
Message-ID: <4283172b.242.630.20549@clanwind.com>
Reply-To: janaka@clanwind.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey,

I am trying to rebuild a failed raid 5.  I have one disk
that's bad, and one disk that, in the confusion, has become
convinced that it is a spare.  I don't know where it got
this idea, but I have drive "mdadm --assemble --force
/dev/md2 /dev/hda3 /dev/hdc3 /dev/hde3 /dev/hdg3 /dev/hdi3
/dev/hdk3" as well as "mkraid --force /dev/md2" and my
raidtab hasn't changed except to state that HDA has failed.

Is there anyway for me to force the "spare disk" to
reconsider its purpose in life?  Which is presently to make
my data accessable so I can move to raid 10 or some other
more simple raid format.

I mean, I am sure it is some bit in the superblock that is
miss set, but how do I fix that?

Thanks
-fro

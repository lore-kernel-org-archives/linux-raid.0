From: Tobias McNulty <tobias@caktusgroup.com>
Subject: permanently removing a spare
Date: Wed, 11 May 2011 21:49:35 -0400
Message-ID: <BANLkTinbk9VMuiLNUA8VW-gE1Znbf9caWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

After successfully converting my raid6 array to raid5, I of course
neglected to update mdadm.conf, so the array was absent on reboot.  A
quick mdadm --assemble brought the array back online.

However, now I am trying to update mdadm.conf, and I hit what I think
is this bug:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=610184

So I thought I'd try to remove the spare from my raid5 array.  I
marked it as failed and then removed it, and the spare no longer shows
in /proc/mdstat:

md0 : active raid5 sda[0] sdd[3] sdc[2] sdb[1]
      5860543488 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

However, when I do mdadm -Es, I still see it:

ARRAY /dev/md0 UUID=25a818ff:68f07e28:0d7656f3:2f233380
   spares=1

And I still see the "error: superfluous RAID member (4 found)." error
when running update-grub (even if I leave out the spares=1 part).

Is there a way to "permanently" remove the spare "slot" from the
array?  I tried mdadm --grow --spare-devices=0, since the man page
arguably suggests that --spare-devices should work in grow mode, but
running the command reports that it's not actually supported.  To the
credit of the man page, the description of --spare-devices *does* say
it is used in the *initial* array creation.

Does what I'm trying to do make sense?  Is there a way to make the
array forget that it ever had a spare in the first place?

I'm a little afraid to reboot until I get this figured out.

Thank you!
Tobias
-- 
Tobias McNulty, Managing Partner
Caktus Consulting Group, LLC
http://www.caktusgroup.com

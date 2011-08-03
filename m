From: Jan Vejvalka <jan.vejvalka@lfmotol.cuni.cz>
Subject: Mdadm re-add fails
Date: Wed, 03 Aug 2011 10:03:23 +0200
Message-ID: <4E3900CB.6030800@lfmotol.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi *,

   I'm using mdadm 3.1.5 from Slackware64 13.37, for RAID1.
After running the RAID degraded for a while, I can't bring it
back.

At boot, dmesg says (correctly]:

md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md1
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
md: kicking non-fresh sda1 from array!
md: unbind<sda1>
md: export_rdev(sda1)
md/raid1:md1: active with 1 out of 3 mirrors

And when I try to:~#  mdadm --add /dev/md1 /dev/sda1 ,
I get
mdadm: /dev/sda1 reports being an active member for /dev/md1, but a 
--re-add fails.
mdadm: not performing --add as that would convert /dev/sda1 in to a spare.
mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sda1" first.

I guess that for getting the array up it doesn't make much difference
to clear /dev/sda1 and to add it clear (does it ?), but it's a bit
embarrassing to find this behaviour in a moreless standard situation.

There seems to be previous conversation on this topic between Annemarie
Schmidt and Neil Brown that ends on Fri, 27 May 2011 17:16:46 -0400, 
with Msg-Id 
<5AA430FFE4486C448003201AC83BC85E01B0353E@xxxxxxxxxxxxxxxxxxxxx>
(at least on http://www.spinics.net/lists/raid/thrd2.html) but I'm not
sure which version of mdadm it concerns and what is the final action.

I'm ready to test a fix.

Thanks,

Jan Vejvalka

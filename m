From: "John Stoffel" <john@stoffel.org>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 2 Jul 2014 15:01:39 -0400
Message-ID: <21428.22291.488446.833507@quad.stoffel.home>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
	<20140702204502.6b538fa8@notabene.brown>
	<20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
	<21428.13989.101969.396667@quad.stoffel.home>
	<20140702193706.Horde.Q4yuGvYRo99TtFFSw8qw6-A@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702193706.Horde.Q4yuGvYRo99TtFFSw8qw6-A@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>
Cc: John Stoffel <john@stoffel.org>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Pedro> I can't destroy the fs at the moment. The problem is not
Pedro> filesystem related as md throws an error when reading with dd
Pedro> when the filesystem is not mounted.

I hope you have backups of all this data, because I stongly suspect
you've run into either an MD coding problem, or you have the data
structures so confused that MD really needs to be re-built from
scratch.  

Pedro> The controler is flashed with the latest P19 firmware IT mode,
Pedro> meaning that disks are "passed-though". No raid or jbod.

JBOD means Just a Bunch Of Disks, which is what you have, so good.  

Pedro> Power supply has a singe 12v rail and total output of 800w.

Should be ok then.

Pedro> Graphics card is a pcie 1x nvidia card. I have a very similar
Pedro> machine, that has the same case, the same power supply, the
Pedro> same LSI controller in the same mode with the same firmware,
Pedro> same OS, same kernel. Diferences are the motherboard Z87
Pedro> chipset and i7 cpu, and the hard disks are 16x 4TB seagate
Pedro> HDD's in raid6 created the exact same way as this one. I have
Pedro> no problems with it.

Hmm... so how did the system crash and lose the disk(s) in the fist
place?  Did the cables get knocked?  Are they in a disk cage or hot
swap bays?  Why kinds of physical cabling are you using here?    

The suggestion to use blktrace to examine how IO flows into the MD
device and then down into the various devices is a good one, but I
don't have any good suggestions on what to do here.

But in any case, I'll repeat this now.  Backup your data, and
basically assume some of it is toast and needs to be restored or
re-created if at all possible.  With all the errors you're showing,
there's bound to be major filesystem corruption and even undetected
corruption in some files on there.  Not a good place to be.

Too bad you can't just copy the data off to the other machine with the
16 x 4Tb disks.  That would give you a good chance to save your data.

John

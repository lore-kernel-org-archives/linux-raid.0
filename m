From: starlight.2012q4@binnacle.cx
Subject: question: no-bitmap RAID1 with off-site drive
Date: Sun, 11 Nov 2012 16:40:27 -0500
Message-ID: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Sorry if this has been answered before,
but I'm having trouble finding the
relevant messages by searching.  Several
solutions are floating around.

Want to configure a simple no-bitmap
RAID1 with three-drives, one always
stored off-site.

Will rotate only two or three times a
year so I'd rather have the no-bitmap
setup where the incoming drive gets a
full resync--takes just eight hours.
Have a daily incremental cloud-backup,
which allows infrequent visits to the
safe-deposit box.

What are the correct approach and
commands for this?  Will never
have three drives together on-site.

I'm nervous about using --fail --remove
to take the mirror copy offline, fearing
that it could put the backup in an
unusable state.  Thinking a --stop
might be cleanest approach.

Wondering if --grow --raid-devices=1 --force
after the drive is removed and then
--grow --add --raid-devices=2 with
the returning drive is correct or if a
--raid-devices=3 with no --grow on
rotation is better.

I'm looking for the most correct way to
go, but don't have enough experience of
'mdadm' to have a sense of what it
should be.

Thank you for any help!


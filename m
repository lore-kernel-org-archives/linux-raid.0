From: NeilBrown <neilb@suse.de>
Subject: Re: Mdadm re-add fails
Date: Wed, 3 Aug 2011 19:25:41 +1000
Message-ID: <20110803192541.7a6e11f6@notabene.brown>
References: <4E3900CB.6030800@lfmotol.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3900CB.6030800@lfmotol.cuni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Vejvalka <jan.vejvalka@lfmotol.cuni.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 03 Aug 2011 10:03:23 +0200 Jan Vejvalka
<jan.vejvalka@lfmotol.cuni.cz> wrote:

> Hi *,
> 
>    I'm using mdadm 3.1.5 from Slackware64 13.37, for RAID1.
> After running the RAID degraded for a while, I can't bring it
> back.
> 
> At boot, dmesg says (correctly]:
> 
> md: considering sdb1 ...
> md:  adding sdb1 ...
> md:  adding sda1 ...
> md: created md1
> md: bind<sda1>
> md: bind<sdb1>
> md: running: <sdb1><sda1>
> md: kicking non-fresh sda1 from array!
> md: unbind<sda1>
> md: export_rdev(sda1)
> md/raid1:md1: active with 1 out of 3 mirrors
> 
> And when I try to:~#  mdadm --add /dev/md1 /dev/sda1 ,
> I get
> mdadm: /dev/sda1 reports being an active member for /dev/md1, but a 
> --re-add fails.
> mdadm: not performing --add as that would convert /dev/sda1 in to a spare.
> mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sda1" first.
> 
> I guess that for getting the array up it doesn't make much difference
> to clear /dev/sda1 and to add it clear (does it ?), but it's a bit
> embarrassing to find this behaviour in a moreless standard situation.

Do you have a write-intent bitmap?

If yes, please report the output of "mdadm --examine" and "mdadm
--examine-bitmap" of both devices.

If no, then this is now expected behaviour.  It may be a slight inconvenience
for you to have to "--zero-superblock" first, but I have seen numerous cases
where people have "--add"ed devices when they shouldn't have and had the
device turned in to a spare when they didn't want that, and so lost valuable
information.

So if there is no write-intent bitmap, the just do as the message suggests
and have a happy array again.

NeilBrown


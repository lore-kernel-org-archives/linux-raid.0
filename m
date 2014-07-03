From: Pedro Teixeira <finas@aeiou.pt>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Thu, 03 Jul 2014 22:06:04 +0100
Message-ID: <20140703220604.Horde.INYPOvYRo99TtcW8JM7TniA@webmail.aeiou.pt>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
 <20140702204502.6b538fa8@notabene.brown>
 <20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
 <20140703124046.74272588@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140703124046.74272588@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was able to fix the volume and the filesystem!

  - the command Neil posted didn't work but I got the idea and made a =20
script that cleared the list for all disks. The --examine-bad-blocks =20
still lists the bad blocks, and stopping and assembling the volume =20
again will populate the bad block list again. Still, I cleared them =20
all again and issued a "repair" on the volume. I got a bunch of errors =
=20
from a couple of disks, mostly sdk and sdb but the volume synced till =20
the end, and after stopping it and assembling it again, no bad blocks =20
in any disk, and --examine-bad-blocks also showed no bad blocks. I =20
have since replaced sdk and sdb, with no errors when syncing and no =20
errors on dmesg. After that I fsck'd the filesystem, and it's up and =20
running again. I will now replace the other two disks that exibited =20
read errors when repairing the volume as soon as I get some =20
replacements.

Thanks all for the help!!!

As a sugestion, I would make md distinguish a read error that is =20
caused by no good strip available due to bad block list from other =20
read errors to ease troubleshooting and maybe implement a way to clear =
=20
bad block list from disks with mdadm ( and maybe forcing a resync of =20
that strip after the list is cleared ).


Cheers
Pedro

_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

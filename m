From: Kourosh Ghassemieh <linux-raid@mindwaresystems.com>
Subject: Re: raid1 problems
Date: Thu, 06 Mar 2003 12:34:28 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.2.0.9.0.20030306121958.00b1a900@lain.mindwaresystems.com>
References: <58ABCB36087FD6409D2C2DBDBB1978A16D4A@harmony.afinite.co.uk
 >
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58ABCB36087FD6409D2C2DBDBB1978A16D4A@harmony.afinite.co.uk
 >
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 01:44 PM 3/4/2003, Adrian Inman wrote:
>Help!!!
>
>Installed debian about 10 times now.
>
>Last attempt - managed to get it working properly, but had to recompile 
>kernel again - needed to add in quota support. GRRR.
>
>I have 2 raid devices: one for boot/root/everything and one for swap.
>
>I did the lilo stuff for each disk - had and hdb and then for /md0 and it 
>was all okay. Well just about.
>
>Lilo with boot=/dev/md0 won't work - it moans:
>Warning: using BIOS device code 0x80 for RAID boot blocks
>Reading boot sector from /dev/md0
>Merging with /boot/boot-menu.b
>Fatal: map file must be on the boot RAID partition

Adrian,

I had problems getting RADI-1 to boot with Debian as well.
What worked for me was adding this line to my lili.conf file:

append="md=0,/dev/hda1,/dev/hdc1 root=/dev/md0"

You should change /dev/hdc1 to /dev/hdb1 to reflect you own config.
I don't know why lilo had so much trouble even after I specified the
boot and root devices but it might be because I left my partition types
as linux rather than raid autodetect.  Anyway, this worked for me.

Also, you may want to think about moving your second drive
to the second channel, i.e. hdc, to help with i/o.  When I did that
I saw a significant increase in the speed of array rebuilds.

I hope this helps.

Kourosh



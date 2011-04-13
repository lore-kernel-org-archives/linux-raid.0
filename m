From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Wed, 13 Apr 2011 15:24:17 -0700 (PDT)
Message-ID: <724474.42236.qm@web65102.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Fri, 8/4/11, Gavin Flower <gavinflower@yahoo.com> wrote:

> From: Gavin Flower <gavinflower@yahoo.com>
> Subject: RAID6 data-check took almost 2 hours, clicking sounds, syste=
m unresponsive
[...]
> This morning, I noticed my system was extremely
> unresponsive, and that there were clicking sounds coming
> from one of my 5 hard drives.=A0=20
[...]

Hi Neil,

When I do=20
   badblocks -s -v /dev/sdc
I hear clicking sounds from the hard drive, and notice lots and lots of=
 log messages such as:
ata3: exception Emask 0x10 SAct 0x0 SErr 0x90200 action 0xe frozen
ata3: irq_stat 0x00400000, PHY RDY changed
ata3: SError: { Persist PHYRdyChg 10B8B }
ata3: hard resetting link
ata3: softreset failed (device not ready)
ata3: applying SB600 PMP SRST workaround and retrying
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: EH complete

So I assume that the clicking corresponds to the hard reset, but I'm no=
t certain of that.  Initially, I thought it might be some kind of disk =
head problems.  Note that smart reports no bad blocks.


Regards,
Gavin

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

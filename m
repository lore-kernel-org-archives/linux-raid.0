From: Jean-Baptiste Thomas <cau2jeaf1honoq@laposte.net>
Subject: Re: Massive RAID-1 desync
Date: Sun, 26 Apr 2015 10:48:37 +0200 (CEST)
Message-ID: <824955940.20886272.1430038117467.JavaMail.zimbra@laposte.net>
References: <1919189912.18202330.1429908372364.JavaMail.zimbra@laposte.net> <1810942606.18204832.1429908469113.JavaMail.zimbra@laposte.net> <20150425172527.21a34428@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150425172527.21a34428@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2015-04-25 17:25 +1000, NeilBrown wrote:

> Perfectly normal.  Metadata is at the end, at least 64K from the end
> and 64K aligned.

Yes. Format 0.90.

> And what were those messages about sda?

The actual messages have been displaced by lockd's rambling but as I
remember, it was this sort of thing :

ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: BMDMA stat 0x4
ata1.00: failed command: READ DMA EXT
ata1.00: cmd 25/00:80:a9:54:70/00:00:74:00:00/e0 tag 0 dma 65536 in
         res 51/40:00:25:55:70/40:00:74:00:00/e0 Emask 0x9 (media error)
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: configured for UDMA/133
ata1: EH complete

I ran e2fsck on copies of sda1 and sdc1. They are both heavily damaged,
not just sdc1.

Looks like I'm going to have to replace a disk and see. I'd like to
avoid replacing two, though. Or going through more crashes. Does 
MD have a paranoid mode in which reading a sector from a RAID-1
device would not return successfully until it got matching data
from at least two components ?

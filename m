From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Possible failures in raid5?
Date: Tue, 28 Dec 2004 08:48:42 +0100
Message-ID: <qnf7a2-fln.ln1@news.it.uc3m.es>
References: <41CF6209.2050209@advocap.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John McMonagle <johnm@advocap.org> wrote:
> I am  concerned what will happen if the computer dies while writing a strip.

Well, the strip will be partially written.

> Is it possible that the stripe will be corrupted?

No - it will be partially written.  The parity data may or may not be
consistent with the real data at that point, and if you lose a disk
before the next resync (at next reboot) you may get some different data
reconstructed using parity than if you had used the data itself. OTOH
if you reboot with all disks intact the parity will be reconstructed
properly and the inconsistency will be removed. But any missed writes
will remain missing.

> If so will the  the rest of the raid array be OK?

Apart from that strip?  I'm not sure exactly what you mean by "strip"
(probably some raid jargon?  Don't they use "chunks" and "stripes"?)!
But clearly the data inconsistency will be confined to it.

> if so is there anything one can do  about it?

? Nothing has happened - you have simply not written all the
data you wanted to write. This happens all the time when writing to
disks and crashing your computer! But since raid writes at least twice,
once for data and once for parity, you have the extra pssibility of 
having missed some of the parity data (or having written parity but not
data). That produces an inconsistency in the redundant data. You can
fix it by rebooting with all disks intact. Hey - you even fix the
inconsistency by rebooting with one missing; you just have less chance
of reconstructing the intended data that way.

Peter


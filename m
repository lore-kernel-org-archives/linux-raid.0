From: Dirk Meul <dirk.meul@epost.de>
Subject: Re: SW-RAID1 and 2.5.34
Date: 13 Sep 2002 22:24:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1031948663.1034.10.camel@aragorn>
References: <1031835624.1155.3.camel@aragorn>
	<15745.13537.81300.413518@notabene.cse.unsw.edu.au>
Reply-To: dirk.meul@epost.de
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15745.13537.81300.413518@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you!

Am Fre, 2002-09-13 um 02.44 schrieb Neil Brown:
> > I'm not able to boot plain 2.5.34 with RAID1 enabled. My root partition
> > is RAID1 and with 2.4.19 everything is ok. But bug on md.c:3153 in
> > md_queue_proc. What can i do to fix it?
> 
> The patch just went it Linus' BK tree.
> It is below.
> I don't promise that this fixes everything, just that if fixes the
> "bug at md.c:3153".

With the patch applied the kernel didn't oops, but 2.5.34 tries to use
hde2. The RAID1 partitions are hde1/hdg1! hde2 is a swap partition so
following message is correct:
invalid raid superblock magic on hde2.

There is a [events: a8bc0fb6] message.

How can i fix this? Or do i have to make a new RAID1 device?

Regards,
-- 
Dirk Meul <dirk.meul@epost.de>


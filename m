From: James Doebbler <jamesdoebbler@gmail.com>
Subject: Fwd: Corruption during RAID5->RAID6 migration
Date: Tue, 14 May 2013 17:07:22 -0500
Message-ID: <CAJDy475do3iU3o1gsi9y-jDg2qT32aCETrMfpiQSWLF+iLxdFw@mail.gmail.com>
References: <CAJDy474SBN7qMgccmkzc++=ZP43L1M=jVkyx_YVkqdZmbvwZfg@mail.gmail.com>
 <20130515020814.77ff1407@natsu> <CAJDy477412O8_saeP-YYxXSoQsgMy8jEgdfXa7p5_2V54nMG=Q@mail.gmail.com>
 <20130515031303.653f6d56@natsu> <CAJDy476Akqz+Q8FA-dRXVf6FxqYB2QgcozFnFZ9dCa9mWv_90A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJDy476Akqz+Q8FA-dRXVf6FxqYB2QgcozFnFZ9dCa9mWv_90A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Roman Mamedov <rm@romanrm.ru>
List-Id: linux-raid.ids

Roman,

Thank you very much, I hadn't seen those reports.  I had searched
through the Newegg reviews for linux/ubuntu and saw good
support/reviews.  Now searching more generally I see several
corruption reports in the feedback.  Wow, that's really bad.  I'll
definitely be leaving some reviews there of my own to warn others.

I have on hand a HighPoint Rocket 640L 4-port SATAIII card (Marvell
88SE9235 chipset) which I can use.  I will do some research, but do
you know of any issues with this card/chipset?  If so, can you
recommend a reliable, inexpensive card or cards?  I have one each
PCI-Express 1x and 16x slots available and would like a total of 6 or
more SATAII or SATAIII ports.


It is interesting that I was still seeing problems after only having
one drive active across the two cards.  I'll be avoiding using even
one port at a time on these cards.

Based on my high-level understanding, the reshape shouldn't read any
data from the two new drives during the reshape, just write to them.
All read data should obviously have come from the original 6 RAID5
drives.  Hopefully this means all my original data is still valid
across the 6 original drives.

I'm hopeful that I can fail and remove both new drives, leaving a
degraded, partially-reshaped RAID6.  Then, re-add the new drives on a
reliable controller (after wiping, clearing superblocks?) and
rebuild/reshape from there.  I'd expect only the data written to the
drive after the migration started would potentially be corrupt, which
I can accept greatfully.

Any advice anyone can give on the proper steps to recover from this
situation after installing a working controller card would be
appreciated.

Thanks,
James


On Tue, May 14, 2013 at 4:13 PM, Roman Mamedov <rm@romanrm.ru> wrote:
>
> On Tue, 14 May 2013 15:56:57 -0500
> James Doebbler <jamesdoebbler@gmail.com> wrote:
>
> > Roman,
> >
> > I suppose that means you think it's hardware-related then.  Do you
> > have any suggestions on what/how I might be able to recover?
> >
> > Hardware details:
> >
> > The motherboard is ECS A785GM-M with 6x internal SATAII and 2x eSATAII
> > I have installed 2 x SYBA SD-SA2PEX-2IR (SiI3132 Chipset), each with
> > 2x onboard SATAII
>
> Hello,
>
> This card and in fact the 3132 chipset is known to corrupt data when both
> ports are accessed simultaneously at high speed.
>
> > http://lime-technology.com/wiki/index.php/Hardware_Compatibility
> > SYBA (PCI-E X1) 2 port SATA II (SiI3132)
> > Beware!!! There are numerous providers of SiL3132-based addon cards, and a few of them (unknown how many) are known to be faulty, causing unseen (SILENT) data corruption - see
> > http://lime-technology.com/forum/index.php?topic=18428.msg167122#msg167122
> > http://lime-technology.com/forum/index.php?topic=21052.msg187437#msg187437
>
> Earlier discussions on linux-raid:
> http://comments.gmane.org/gmane.linux.raid/30629
> http://permalink.gmane.org/gmane.linux.raid/33369
> http://comments.gmane.org/gmane.linux.raid/33346
>
> Some more reports:
> http://s.lowendshare.com/4/1368565867.495.2013-05-14T211035Z-syba3132.png
> http://forum.ixbt.com/topic.cgi?id=11:35147-39#1199 (Russian)
>
> --
> With respect,
> Roman

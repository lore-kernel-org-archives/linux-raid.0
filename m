From: "Bill Rugolsky Jr." <rugolsky@ti19.telemetry-investments.com>
Subject: Re: How safe is software RAID compared to how safe hardware RAID is!?
Date: Wed, 19 Nov 2003 11:55:19 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031119165519.GB14191@ti19.telemetry-investments.com>
References: <16314.40792.616508.878124@notabene.cse.unsw.edu.au> <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
To: linux-raid@vger.kernel.org
Cc: James R Bamford <jim@jimtreats.com>
List-Id: linux-raid.ids

On Tue, Nov 18, 2003 at 11:12:43PM -0000, James R Bamford wrote:
> I am going to stick with this software RAID for the near future if it
> carries on working correctly.. I was just wondering what peoples views were
> of software vs hardware raid... anything and everything really.. I'm not
> that up on all the technology... I know that 3ware have a good rep in
> hardware... I also imagine that for more exotic RAID configurations its
> obviously a help to not stress the CPU with the RAID tasks.. for me tho with
> simple mirroring the CPU costs are minimal.. the linux core is a sturdy base
> to build upon so is software raid in this way a perfectly acceptible
> reliable RAID solution..
 
I have had a 3ware 7800 RAID controller for a while, and I'm pleased with
it, but I use it in JBOD mode, with Linux MD on top.  Why?

1. The version of the firmware that I have on the card requires one
   to reboot into the BIOS to change the configuration.  My understanding
   is that later firmware revisions allow it to be reconfigured from
   the command line.

2. The 3dm monitoring package was closed source.  That may have changed.

3. The RAID meta-data was undocumented last time I checked.  With Linux MD,
   I can plug the drives into any IDE controller and figure out what is
   going on.  Not so long ago, I had a two drive failure in the same day;
   I was able to partially resurrect the second drive, and recovered the
   data from it.

The benefit of hardware RAID1, in particular, is to not send the same
data twice over the bus.  Were I trying to eek every last bit of
performance, I'd use the hardware solution.

I played with the 3ware hardware RAID back at 2.4.early when there were
concerns about the interaction between ext3, LVM, and MD.  But once that
settled down, I switched to soft-RAID.

Ideally, hardware RAID vendors would publish complete meta-data specs,
and provide a simple userland tool to extract and parse when the drive
is plugged into a non-RAID controller.  Perhaps some do.
If meta-data were documented, it might be relatively easy to extract data
with just a script, or perhaps a small Device Mapper module.

Regards,

	Bill Rugolsky

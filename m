From: Kasper Sandberg <postmaster@metanurb.dk>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 10:42:11 +0100
Message-ID: <1257846132.22155.155.camel@localhost>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2009-11-09 at 09:59 -0700, Chris Worley wrote:
> On Mon, Nov 9, 2009 at 9:42 AM, Majed B. <majedb@gmail.com> wrote:
> > Well, SATA uses SCSI emulation so I guess that's no problem, right?
> 
> The only problem is SSD's put Solid State Storage (SSS) behind
> SATA/SAS controllers... while compatible w/ old disk technology, it
> severely limits performance (i.e. none of these SSD drives do even
> 300MB/s... while SSS drives do 800MB/s).  While the initial 2.6.27
No, around 280MB/s... and obviously they dont do more, because of the
simple limitation of the sata controllers.. this also means they dont
need to do as many channels as other devices..
> drivers and ext4 "discard" worked very well with forward-thinking SSS
> not encumbered by old controller technology... but, SSD's were not
> able to handle it well:
> 
> http://lwn.net/Articles/347511/
> 
> So it looks like "design by committee" Linux is well behind Windows 7,
And how exactly does windows 7 handle this so much better?
> while Linux contemplates slowing new technology down to optimize for
> ill-designed SSD's.
It does?
> 
> Be glad "thumb drives" didn't try to be floppy-drive-compatible!!!
> 
> Chris
> >
> > On Mon, Nov 9, 2009 at 7:37 PM, Chris Worley <worleys@gmail.com> wrote:
> >> On Sun, Nov 8, 2009 at 6:13 PM, Majed B. <majedb@gmail.com> wrote:
> >>> The firmware which introduced the TRIM command was deemed buggy and
> >>> has been pulled out.
> >>>
> >>> Are there any filesystems that are TRIM-aware?
> >>
> >> Ext4 (at that level in the kernel, it's referred to as "discard", it's
> >> not TRIM until it's issued as a SCSI command).
> >>
> >> Chris
> >>>
> >>> On Sun, Nov 8, 2009 at 8:57 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> >>>> For those of us playing with use of SSD for journals on ext[34], this does
> >>>> have implications for RAID performance.
> >>>>
> >>>> http://hardware.slashdot.org/story/09/10/27/1427209/Intel-Updates-SSDs-Supports-TRIM-Faster-Writes
> >>>>
> >>>> --
> >>>> Bill Davidsen <davidsen@tmr.com>
> >>>>  Unintended results are the well-earned reward for incompetence.
> >>>>
> >>>>
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >>>> the body of a message to majordomo@vger.kernel.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>
> >>>
> >>>
> >>>
> >>> --
> >>>       Majed B.
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>
> >
> >
> >
> > --
> >       Majed B.
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


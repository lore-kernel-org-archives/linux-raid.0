From: Kasper Sandberg <postmaster@metanurb.dk>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 19:40:31 +0100
Message-ID: <1257878431.22155.163.camel@localhost>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	 <1257846132.22155.155.camel@localhost>
	 <f3177b9e0911100739p56a98992p26f9a42e8b689dcf@mail.gmail.com>
	 <70ed7c3e0911100743y55a1eef5p5705cd9cd1f1aa51@mail.gmail.com>
	 <f3177b9e0911100758n2a663d16hc15a6c90e88346b7@mail.gmail.com>
	 <70ed7c3e0911100801j2880965p7a5d6e03c74248dd@mail.gmail.com>
	 <f3177b9e0911100818p36cbc0d9r56c95fa1f13ef46c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0911100818p36cbc0d9r56c95fa1f13ef46c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2009-11-10 at 09:18 -0700, Chris Worley wrote:
> On Tue, Nov 10, 2009 at 9:01 AM, Majed B. <majedb@gmail.com> wrote:
> > Which disks can provide 2ms response with a read of 250 MB/s and write
> > of 170 MB/s other than SSDs?!
> 
> The drives I use average <50usecs latency at 4KB packets (properly
> measured as the complete turn-around time of a single outstanding
> I/O), 800MB/s reads and >600MB/s writes at 128KB blocks.
> 
> >
> > Are you saying that it doesn't matter whether we use Linux or Windows
> > with SSDs because the limitation is coming from the disk's controller
> > itself?
> 
> To some degree, yes, when using SSD's behind a controller, the
> controller is the biggest performance issue, and given they use
> chicklets for processors, they all hamper performance given the speed
> potential of the underlying storage.
> 
> As none of the enterprise distros are handling TRIM yet, W7 can claim
> it was first, and putting together a TRIM-capable kernel is manual
Except it wasnt, it may be earlier than the enterprise distros, but
thats not first.
> currently in Linux, and given only ext4 supports it (strangely, FAT
> supported it, then the code was pulled... XFS may support it, but I
> believe that's still in the works), you have the additional problem
> that ext4 has some maturity issues.  Porting "discard" to ext2/3 would
> not be too difficult, especially w/o journal considerations.
And given W7 supports it, it is going to have the same issues which
linux faces, i dont know what solution microsoft has chosen, but that
doesnt mean linux shouldnt choose the best one..

> 
> Chris
> >
> > On Tue, Nov 10, 2009 at 6:58 PM, Chris Worley <worleys@gmail.com> wrote:
> >> On Tue, Nov 10, 2009 at 8:43 AM, Majed B. <majedb@gmail.com> wrote:
> >>> Does that mean we won't be able to squeeze the juice out of Intel's
> >>> Extreme SSDs on Linux?
> >>
> >> The limitation is in the design.  You'll be able to get as much
> >> performance as they can offer, given the bad design (of putting SSS
> >> behind legacy controllers).
> >>
> >>>
> >>> What about those of us who use OpenFiler and build their own storage
> >>> solutions? We won't be able to provide solutions based on these SSDs
> >>> because the kernel support is crap?
> >>
> >> It's sub-optimal, written to make the best of a bad design, limiting
> >> performance of good designs, but not crap.
> >>
> >>>
> >>> I may have clients wanting to mix between SAS/SATA & SSD to load their
> >>> main database on the SSDs, but now it seems pointless since the
> >>> performance isn't gonna be that great :/
> >>
> >> You can still get much greater performance from SSS designed
> >> correctly.  Just don't do SSD's.
> >>
> >> Chris
> >>>
> >>> On Tue, Nov 10, 2009 at 6:39 PM, Chris Worley <worleys@gmail.com> wrote:
> >>>> On Tue, Nov 10, 2009 at 2:42 AM, Kasper Sandberg <postmaster@metanurb.dk> wrote:
> >>>>> On Mon, 2009-11-09 at 09:59 -0700, Chris Worley wrote:
> >>>>>> On Mon, Nov 9, 2009 at 9:42 AM, Majed B. <majedb@gmail.com> wrote:
> >>>>>> > Well, SATA uses SCSI emulation so I guess that's no problem, right?
> >>>>>>
> >>>>>> The only problem is SSD's put Solid State Storage (SSS) behind
> >>>>>> SATA/SAS controllers... while compatible w/ old disk technology, it
> >>>>>> severely limits performance (i.e. none of these SSD drives do even
> >>>>>> 300MB/s... while SSS drives do 800MB/s).  While the initial 2.6.27
> >>>>> No, around 280MB/s... and obviously they dont do more, because of the
> >>>>> simple limitation of the sata controllers.. this also means they dont
> >>>>> need to do as many channels as other devices..
> >>>>
> >>>> I'm not sure if you're agreeing or disagreeing here...
> >>>> 280MB/s<300MB/s, due to the "compatibility" based design of SSD's,
> >>>> while SSS, w/o a legacy controller, can do 800MB/s out of a single
> >>>> drive.
> >>>>
> >>>>>> drivers and ext4 "discard" worked very well with forward-thinking SSS
> >>>>>> not encumbered by old controller technology... but, SSD's were not
> >>>>>> able to handle it well:
> >>>>>>
> >>>>>> http://lwn.net/Articles/347511/
> >>>>>>
> >>>>>> So it looks like "design by committee" Linux is well behind Windows 7,
> >>>>> And how exactly does windows 7 handle this so much better?
> >>>>
> >>>> TRIM is in W7; NTFS support.  No Linux distro does.  And by the time
> >>>> "design by committee" gets through with it,we shouldn't have bothered.
> >>>>
> >>>>>> while Linux contemplates slowing new technology down to optimize for
> >>>>>> ill-designed SSD's.
> >>>>> It does?
> >>>>
> >>>> Those that speak loudest in the kernel development (and contribute the
> >>>> most) work for companies like Intel that promote the slower,
> >>>> controller-based, SSD's.
> >>>>
> >>>> Chris
> >>>>>>
> >>>>>> Be glad "thumb drives" didn't try to be floppy-drive-compatible!!!
> >>>>>>
> >>>>>> Chris
> >>>>>> >
> >>>>>> > On Mon, Nov 9, 2009 at 7:37 PM, Chris Worley <worleys@gmail.com> wrote:
> >>>>>> >> On Sun, Nov 8, 2009 at 6:13 PM, Majed B. <majedb@gmail.com> wrote:
> >>>>>> >>> The firmware which introduced the TRIM command was deemed buggy and
> >>>>>> >>> has been pulled out.
> >>>>>> >>>
> >>>>>> >>> Are there any filesystems that are TRIM-aware?
> >>>>>> >>
> >>>>>> >> Ext4 (at that level in the kernel, it's referred to as "discard", it's
> >>>>>> >> not TRIM until it's issued as a SCSI command).
> >>>>>> >>
> >>>>>> >> Chris
> >>>>>> >>>
> >>>>>> >>> On Sun, Nov 8, 2009 at 8:57 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> >>>>>> >>>> For those of us playing with use of SSD for journals on ext[34], this does
> >>>>>> >>>> have implications for RAID performance.
> >>>>>> >>>>
> >>>>>> >>>> http://hardware.slashdot.org/story/09/10/27/1427209/Intel-Updates-SSDs-Supports-TRIM-Faster-Writes
> >>>>>> >>>>
> >>>>>> >>>> --
> >>>>>> >>>> Bill Davidsen <davidsen@tmr.com>
> >>>>>> >>>>  Unintended results are the well-earned reward for incompetence.
> >>>>>> >>>>
> >>>>>> >>>>
> >>>>>> >>>> --
> >>>>>> >>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >>>>>> >>>> the body of a message to majordomo@vger.kernel.org
> >>>>>> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>>> >>>>
> >>>>>> >>>
> >>>>>> >>>
> >>>>>> >>>
> >>>>>> >>> --
> >>>>>> >>>       Majed B.
> >>>>>> >>> --
> >>>>>> >>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >>>>>> >>> the body of a message to majordomo@vger.kernel.org
> >>>>>> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>>> >>>
> >>>>>> >>
> >>>>>> >
> >>>>>> >
> >>>>>> >
> >>>>>> > --
> >>>>>> >       Majed B.
> >>>>>> >
> >>>>>> --
> >>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >>>>>> the body of a message to majordomo@vger.kernel.org
> >>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>>
> >>>>>
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


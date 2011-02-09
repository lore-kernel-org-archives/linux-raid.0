From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 0/6] Reshape fixes (expansion)
Date: Wed, 9 Feb 2011 07:31:11 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D178B36531@irsmsx503.ger.corp.intel.com>
References: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
 <20110209141057.7682d10d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209141057.7682d10d@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, February 09, 2011 4:11 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 0/6] Reshape fixes (expansion)
> 
> On Tue, 08 Feb 2011 14:30:28 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > The following series adds some fixes for reshape (expansion).
> >
> > A while ago mdadm unit tests (suits 12 and 13) works correctly, now
> I've found problems.
> > I've learned that containers created for raid5 and raid0 has
> different number of blocks in mdstat.
> > I've put mdstat partial output to patch description:  UT FIX: imsm
> container can have different blocks number
> > I'm not 100% sure that this is fix (for changed behavior), not
> workaround for container creation problem.
> > This fix is first of fixes (3) that enables reshape (12, 13) UT.
> > If you find this more as workaround, this patch is good point for
> discussion what change is correct.
> >
> > Patches:
> >       FIX: compare blocks on all data disks
> >       FIX: Compare the same units
> > makes changes for blocks computing verification. After those 2 more
> patches UT (12, 13) works.
> > Please let me know what you are thinking about them. It is possible
> that this is not final patch also,
> > but I've tried to find out what this condition should do, and change
> code to archive it (IMHO).
> >
> > Rest of patches addresses other issues, I can observe during
> expansion.
> >
> > BR
> > Adam
> >
> > ---
> >
> > Adam Kwolek (6):
> >       FIX: md runs recovery instead reshape for growing single disk
> raid0 array
> Applied.
> 
> >       FIX: Container can be left frozen
> Applied.
> 
> >       FIX: compare blocks on all data disks
> >       FIX: Compare the same units
> No, I don't like these.
> The point here is to compare the amount of data to be backed up with
> the
> size of one of the spare devices, because in some cases the data will
> be
> backed up to a spare device.
> If the size of the data to be backed up is bigger than half the size of
> a
> spare device, then it doesn't really fit and something is wrong.
> Normally the amount of data to be backed up is much much smaller than
> the
> size of any device.
> 
> Maybe we just need to make the test use larger devices or smaller chunk
> size,
> or similar.

Thank you for explanation. I'll prepare changes to UT.

BR
Adam

> 
> 
> >       UT FIX: imsm container can have different blocks number
> Applied (the block numbers here are completely meaningless, so ignoring
> them
> is good).
> >       imsm: FIX: Wrong output string format
> Applied.
> 
> All pushed out to devel-3.2
> 
> Thanks.
> 
> NeilBrown


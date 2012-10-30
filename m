From: Curt Blank <curt@curtronics.com>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Tue, 30 Oct 2012 13:30:13 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no>
 <508FE44A.3040507@curtronics.com> <508FF85F.1030308@hesbynett.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508FF85F.1030308@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 30 Oct 2012, David Brown wrote:

> On 30/10/2012 15:29, Curtis J Blank wrote:
> > On 10/30/12 04:49, David Brown wrote:
> > > On 28/10/2012 19:59, Curtis J Blank wrote:
> > > > I've got two new SSD's that I want to set up as RAID1 and use strictly
> > > > for the OS and MySQL DB's partitioned accordingly.
> > > >
> > > > I'll be using the 3.4.6 kernel for now in openSuSE 12.2 with ext4. So
> > > > after a lot of Google'n and reading it is my understanding that discard
> > > > is not sent to the devices via the raid drivers. I am aware of Shaohua
> > > > Li's patches to make it work but am not inclined to use them due to
> > > > openSuSE's Online Update replacing the kernel. I'm not against patching
> > > > and gen'ing a kernel, that used to be SOP, but just don't want deal with
> > > > that overhead. Of course unless I really need to.
> > > >
> > > > So I've read, and if I understand things correctly, I can use LVM and
> > > > RAID1 and the the discard commands will be sent to the devices. Is that
> > > > correct and currently the only way or is/are there other ways?
> > > >
> > > > I've also read that a lot of people are saying TRIM isn't needed because
> > > > the SSD's garbage collection is so good now TRIM isn't needed. But I
> > > > don't see how that could work because the SSD's don't have access to the
> > > > file system so they don't know which pages in the blocks are marked
> > > > unused to do any consolidation and erasing. And using TRIM is suggested
> > > > in a OCZ document I read and who's drives these are. Unless, the SDD
> > > > when it has to change a page moves the whole block then erases the old
> > > > block? But without TRIM in could be moving invalid data too because it
> > > > doesn't know that and that to me sure doesn't sound efficient and this
> > > > operation would be a perfect time to get rid of the invalid data if it
> > > > did know.
> > > >
> > >
> > > TRIM is not necessary.
> > >
> > > In some situations, TRIM can improve speed - in other cases, it can make
> > > the system significantly slower.  And it is only ever a help until the
> > > disk is getting fairly full.
> > >
> > > Before deciding about TRIM, it is important to understand what it does,
> > > and how it works.  TRIM lets the filesystem tell the SSD that a
> > > particular logical disk block is no longer in use.  The SSD can then
> > > find the physical flash block associated with that logical block, and
> > > mark it for garbage collection.
> > >
> > > If TRIM had been specified /properly/ for SATA (as it is for SCSI/SAS),
> > > then it would have been quite useful.  But it has two huge failings -
> > > there is no specification as to what the host will get if it tries to
> > > read the trimmed logical block (this is what makes it terrible for RAID
> > > systems), and it causes a pipeline flush and stall (which is what makes
> > > TRIM so slow).  The pipeline flushing and stalling will cause particular
> > > problems if you have a lot of metadata changes or small reads and writes
> > > in parallel - the sort of accesses you get with database servers.  So
> > > enabling TRIM will make databases significantly slower.
> > >
> > > And what do you lose if you /don't/ enable TRIM?  When a filesystem
> > > deletes a file, it knows the logical blocks are free, but the SSD keeps
> > > them around.  When the filesystem re-uses them for new data, the SSD
> > > then knows that the old physical blocks can be garbage-collected and
> > > re-used.  So all you are really doing by not using TRIM is delaying the
> > > collection of unneeded blocks.  As long as the SSD has plenty of spare
> > > blocks (and this is one of the reasons why any half-decent SSD has
> > > over-provisioning), TRIM gains you nothing at all here.  (If you have a
> > > very old SSD, or a very small one, or a very cheap one, then you will
> > > have poor over-provisioning and poor garbage collection - TRIM might
> > > then improve the SSD speed as long as the disk is mostly empty.)
> > >
> > > It is possible that blocks that could have been TRIMMED will get
> > > unnecessarily copied as part of a wear-levelling pass - but the effect
> > > of this is going to be completely negligible on the SSD's lifetime.
> > >
> > >
> > > So TRIM complicates RAID, limits your flexibility for how to set up your
> > > disks and arrays, and slows down your metadata transactions and small
> > > accesses.
> > >
> > >
> > > TRIM /did/ have a useful role for early SSDs - in particular, it
> > > improved the artificial benchmarks used by testers and reviewers.  So it
> > > has ended up being seen as a "must have" feature for both the SSD
> > > itself, and the software and filesystems accessing them.
> > >
> > >
> >
> > Thanks for the explanation, makes a lot of sense, has me leaning towards
> > not using TRIM.
> >
> > But your explanation focused on blocks, leaving out pages. Does TRIM
> > info sent to the device only do that on the block level or does it do it
> > at the page level? I was thinking that if it did it at the page level
> > the SSD's garbage collection would consolidate blocks by removing unused
> > pages (akin to defragmenting) then erasing those pages thus making them
> > ready to be written.
> >
> 
> I was not using "block" in a particularly strict of formal way.  There are a
> number of different levels of structure involved here, including "logical
> blocks", "sectors", "allocation units", "erase blocks", "write pages", etc.  I
> am simply talking about "lumps of data", rather than any specific structure.
> 
> As far as the computer is concerned, it deals with "sector numbers" of 512
> byte or 4K sectors.  It is up to the SSD to map these logical numbers to
> physical pages within flash erase blocks.  The PC has no way of knowing
> whether a given set of logical sectors are mapped to pages within the same
> erase block or different ones.
> 
> You are right that the SSD's garbage collection routines will sometimes
> collect together the used pages of an erase block, and copy them over to
> another erase block, so that the first erase block can be recycled.  But this
> is done independently of the TRIM, and is part of the normal garbage
> collection function.

Right, and without TRIM to tell the SSD which page(s) are invalid the 
garbage collection will never be able to do that so the garbage 
collection will be carrying around and preserving invalid page(s) when 
ever it does do something. Assuming there are invalid pages in the blocks 
it is acting on. That to me seems inefficient and for that reason says 
TRIM should be used? 

And makes me think if not what good is garage collection if it's not 
concatenating blocks to only contain valid pages and also then erasing 
invalid blocks so then the pages can be used when needed? In this 
scenario it then appears the only good garbage collection can do is for 
wear leveling.

As far as I understand TRIM, among other things, it allows the SSD to 
combine the invalid pages into a block so the block can be erased thus 
making the pages ready to be written indiviually and avoiding the 
read-erase-modify-write of the block when a page changes, i.e. write 
amplification. Even if it does a read-modify-write to a new block then 
acks the write and does the erase after in the background it's still 
overhead in the read-modify-write i.e. read a whole block, modify a page, 
write a whole block, instead of just being able to write a page.

Am I on the right page? :-)

> 
> mvh.,
> 
> David
> 
> 

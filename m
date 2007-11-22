From: Neil Brown <neilb@suse.de>
Subject: Re: raid6 check/repair
Date: Thu, 22 Nov 2007 14:55:56 +1100
Message-ID: <18244.64972.172685.796502@notabene.brown>
References: <474431BF.30103@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thiemo Nagel on Wednesday November 21
Sender: linux-raid-owner@vger.kernel.org
To: thiemo.nagel@ph.tum.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 21, thiemo.nagel@ph.tum.de wrote:
> Dear Neal,
> 
> >> I have been looking a bit at the check/repair functionality in the
> >> raid6 personality.
> >> 
> >> It seems that if an inconsistent stripe is found during repair, md
> >> does not try to determine which block is corrupt (using e.g. the
> >> method in section 4 of HPA's raid6 paper), but just recomputes the
> >> parity blocks - i.e. the same way as inconsistent raid5 stripes are
> >> handled.
> >> 
> >> Correct?
> > 
> > Correct!
> > 
> > The mostly likely cause of parity being incorrect is if a write to
> > data + P + Q was interrupted when one or two of those had been
> > written, but the other had not.
> > 
> > No matter which was or was not written, correctly P and Q will produce
> > a 'correct' result, and it is simple.  I really don't see any
> > justification for being more clever.
> 
> My opinion about that is quite different.  Speaking just for myself:
> 
> a) When I put my data on a RAID running on Linux, I'd expect the 
> software to do everything which is possible to protect and when 
> necessary to restore data integrity.  (This expectation was one of the 
> reasons why I chose software RAID with Linux.)

Yes, of course.  "possible" is an import aspect of this.

> 
> b) As a consequence of a):  When I'm using a RAID level that has extra 
> redundancy, I'd expect Linux to make use of that extra redundancy during 
> a 'repair'.  (Otherwise I'd consider repair a misnomer and rather call 
> it 'recalc parity'.)

The extra redundancy in RAID6 is there to enable you to survive two
drive failure.  Nothing more.

While it is possible to use the RAID6 P+Q information to deduce which
data block is wrong if it is known that either 0 or 1 datablocks is
wrong, it is *not* possible to deduce which block or blocks are wrong
if it is possible that more than 1 data block is wrong.
As it is quite possible for a write to be aborted in the middle
(during unexpected power down) with an unknown number of blocks in a
given stripe updated but others not, we do not know how many blocks
might be "wrong" so we cannot try to recover some wrong block.  Doing
so would quite possibly corrupt a block that is not wrong.

The "repair" process "repairs" the parity (redundancy information).
It does not repair the data.  It cannot.

The only possible scenario that md/raid recognises for the parity
information being wrong is the case of an unexpected shutdown in the
middle of a stripe write, where some blocks have been written and some
have not.
Further (for raid 4/5/6), it only supports this case when your array
is not degraded.  If you have a degraded array, then an unexpected
shutdown is potentially fatal to your data (the chances of it actually
being fatal is actually quite small, but the potential is still there).
There is nothing RAID can do about this.  It is not designed to
protect against power failure.  It is designed to protect again drive
failure.  It does that quite well.

If you have wrong data appearing on your device for some other reason,
then you have a serious hardware problem and RAID cannot help you.

The best approach to dealing with data on drives getting spontaneously
corrupted is for the filesystem to perform strong checksums on the
data block, and store the checksums in the indexing information.  This
provides detection, not recovery of course.

> 
> c) Why should 'repair' be implemented in a way that only works in most 
> cases when there exists a solution that works in all cases?  (After all, 
> possibilities for corruption are many, e.g. bad RAM, bad cables, chipset 
> bugs, driver bugs, last but not least human mistake.  From all these 
> errors I'd like to be able to recover gracefully without putting the 
> array at risk by removing and readding a component device.)

As I said above - there is no solution that works in all cases.  If
more that one block is corrupt, and you don't know which ones, then
you lose and there is now way around that.
RAID is not designed to protect again bad RAM, bad cables, chipset
bugs drivers bugs etc.  It is only designed to protect against drive
failure, where the drive failure is apparent.  i.e. a read must return
either the same data that was last written, or a failure indication.
Anything else is beyond the design parameters for RAID.
It might be possible to design a data storage system that was
resilient to these sorts of errors.  It would be much more
sophisticated than RAID though.

NeilBrown


> 
> Bottom line:  So far I was talking about *my* expectations, is it 
> reasonable to assume that it is shared by others?  Are there any 
> arguments that I'm not aware of speaking against an improved 
> implementation of 'repair'?
> 
> BTW:  I just checked, it's the same for RAID 1:  When I intentionally 
> corrupt a sector in the first device of a set of 16, 'repair' copies the 
> corrupted data to the 15 remaining devices instead of restoring the 
> correct sector from one of the other fifteen devices to the first.
> 
> Thank you for your time.
> 

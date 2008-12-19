From: Redeeman <redeeman@metanurb.dk>
Subject: Re: detection/correction of corruption with raid6
Date: Fri, 19 Dec 2008 06:38:36 +0100
Message-ID: <1229665116.22331.131.camel@localhost>
References: <1229464713.6159.16.camel@localhost.localdomain>
	 <1229466317.22331.71.camel@localhost>
	 <1229550771.13544.20.camel@localhost.localdomain>
	 <18763.9611.939807.824130@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18763.9611.939807.824130@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2008-12-19 at 15:39 +1100, Neil Brown wrote:
> On Wednesday December 17, piergiorgio.sartor@nexgo.de wrote:
> > On Tue, 2008-12-16 at 23:25 +0100, Redeeman wrote:
> > [...]
> > > > Why a RAID system might have inconsistencies?
> > > > Why do we have a "check" command at all, to run weekly or monthly?
> > > As previously stated in discussion, while most bitflips etc does not
> > > happen on disk(apparently), they do happen, whether its in ram, pci,
> > > controller etc...
> > 
> > Ah! You spoiled it! :-)
> > 
> > Actually I was waiting for an answer from Neil Brown.
> > 
> > Because I'm under the impression that if it is not the HD,
> > it does not count... See below...
> 
> Suppose we agree that bit flips don't happen (undetected) on drive
> media.  But that bit flips can happen elsewhere (memory.  IO Buss
> etc).
> 
> And then suppose we discover that a bit-flip has happened.  What does
> that tell us?
> Maybe it tells us that our hardware is dodgey.  So it cannot be
> trusted to reliably do anything we tell it.  So maybe we shouldn't
> tell it to do anything. ??
> 
> And when we find a corruption, we clear cannot know if it is corrupt
> on disk (a previous write went bad) or just in memory (e.g. a recent
> read was bad).
> In the latter case, writing anything to disk is probably the wrong
> thing to do.  In the former case it might be a good thing to do - if
> we can be fairly sure that the error happens very rarely.
> And of course we cannot know if it was due to a bad read or a bad
> write.  So the safe course is to not write anything to disk.
> 
> Where does that leave us?
> 
> About the only thing that makes sense is to always read all the blocks
> in a stripe, and to perform a consistency test before responding to
> any read request.  If an inconsistency is found, we log what we know,
> and only return data if we have some reason to believe something is
> still valid (e.g. a majority vote for raid1).
> 
> And for raid5/6, a write would require:
>   read whole stripe
>   check consistency
>   copy in new data
>   update parity
>   write out changed blocks
> 
> This is going to be a substantial slowdown.
> 
> And does it really increase your data security?  or is it like putting
> a lock on your front door but not on your back door?
> 
> I guess it would provide some protection against low-frequency errors
> in the controller/cable/drive.
> 
> But given the high cost and the fairly low value, I wonder how many
> people would really use it....

I was suggesting that we only go through all the hoops on user request..
e.g. the addition of "resync_majorityvote" or something..

I can see the wisdom in just doing normal read/writes as now, for speed,
and only do the additional logic on request.

> 
> > 
> > Final point. More or less one year ago the same topic popped up,
> > with similar discussion.
> > At the end of the thread someone was asking if patches are
> > accepted in order to implement this feature.
> > I could not find any answer to that question in the archive.
> > 
> > What is the idea? Are patches accepted? Rejected by default?
> 
> By default, patches are reviewed and discussed.  If they then get
> revised and tested and appear to be sensible and useful they will
> probably get accepted eventually.
> 
> A change of this magnitude would almost certainly need to go through
> several iterations of revision and have substantial testing before
> being accepted.
> 
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


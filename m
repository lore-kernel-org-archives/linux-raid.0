From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 00/16] bad block list management for md and RAID1
Date: Tue, 29 Jun 2010 15:06:35 +1000
Message-ID: <20100629150635.7b1629a2@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
	<hvd5iq$u83$1@dough.gmane.org>
	<20100618132313.040cd303@notabene.brown>
	<4C1BABC4.3020008@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C1BABC4.3020008@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Brett Russ <bruss@netezza.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 18 Jun 2010 13:24:20 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> Neil Brown wrote:
> > On Thu, 17 Jun 2010 08:48:07 -0400
> > Brett Russ <bruss@netezza.com> wrote:
> >
> >   
> >> On 06/06/2010 08:07 PM, NeilBrown wrote:
> >>     
> >>> The goal of these patches is to add a 'bad block list' to each device
> >>> and use it to allow us to fail single blocks rather than whole
> >>> devices.
> >>>       
> >> Hi Neil,
> >>
> >> This is a worthwhile addition, I think.  However, one concern we have is 
> >> there appears to be no distinction between media errors (i.e. bad 
> >> blocks) and other SCSI errors.  One situation we commonly see in the 
> >> enterprise is non-media SCSI errors due to i.e. path failure.  We've 
> >> tested dm multipath as a solution for that but it has its own problems, 
> >> primarily performance due to its apparent decomposition of large 
> >> contiguous I/Os into smaller I/Os and we're investigating that.  Until 
> >> that is fixed, we have patched md to retry failed writes (md already has 
> >> a mechanism for failed reads).  Commonly these retries will succeed as 
> >> many of the path failures we've seen have been transient (i.e. a SAS 
> >> expander undergoes a reset).  Today in the vanilla md code that would 
> >> cause a drive failure.  In this patch, it would identify a range of 
> >> blocks as bad.  Presumably later they might be revalidated and removed 
> >> from the bad block list if the original error(s) were in fact transient, 
> >> but in the meantime we lose that member from any reads.
> >>     
> >
> > Hi Brett,
> >   thanks for your thoughts.
> >
> >  No, md doesn't differentiate between different types of errors.  There are
> >  two reasons for this.
> >  1/ I don't think it gets told what sort of error there was.  The bi_end_io
> >   function is passed an error code, but I don't think that can be used to
> >   differentiate between e.g. media and transport errors.  Maybe that has
> >   changed since I last looked....
> >
> >  2/ I don't think it would help.
> >   md currently treats all errors as media errors.  i.e. it assumes just that
> >   block is bad.  If it can deal with that (and bad-block-lists expand the
> >   options of dealing with it) it does.  If it cannot, it just rejects the
> >   device.
> >   If the error were actually a transport error, it would be very likely to
> >   quickly lead to an error that it could not deal with (e.g. updating
> >   metadata) and would have to reject the whole device.  And that action is
> >   the only thing that it makes sense for md to do in the face of a transport
> >   error.
> >   Such an error says that we cannot reliable talk to the device, so md should
> >   stop trying.
> >
> >  It is simply not appropriate for md to re-try on failure just as it is not
> >  appropriate for md to implement any timeouts.  Both these actions imply some
> >  knowledge of the characteristics of the underlying device, and md simply
> >  does not have that knowledge.
> >
> >   
> Do you not reconstruct a block when possible and write it to the failed 
> device? Isn't that an assumption that block relocation will result and 
> imply some knowledge of the underlying device? I'm not saying that you 
> should implement timeout, although if a write intent bitmap is present a 
> retry failed writes every N minutes certainly seems possible. I am 
> saying that there appears to be some implied assumption now, so that's 
> pretty squishy high morel ground.

I've been caught out!

I wonder if I can recover just a little bit of my dignity....

My 'model' for a block device is that it contain a set of linearly addressed
storage locations such that if you write data to a location and then some
time later read from that location you will either get the original data
(with high probability) or an error.

Given that model, it is not unreasonable to write data to a location that has
fail in the hope that a read from that location later will not fail.

The read balancing in RAID1 assumes that co-located reads are likely to be
more efficient than widely disparate reads, but it isn't a very crucial
assumption.  RAID10 assumes that if there is a systematic performance
difference across the address space, performance is likely to be better
nearer the start.

Resync/recovery makes some very vague assumption about overall throughput in
the default resync-max/min speeds, but they are very vague and easily tuned.

I think there is a fairly significant step between those assumption (which
are pretty squishy) and any assumption about a timeout.

> 
> Particularly if that error code to bi_end_io has some information to 
> guide you. And if it doesn't, it certainly could be added to driver 
> requirements, and would be likely to help with decision making in dm and 
> other users as well.
> 
> >  If you have a device where temporary path failures are possible, then it is
> >  up to the driver to deal with that possibility.
> >  For example, I believe the 'dasd' driver (which is for some sort of fibre
> >  connected drives on an IBM mainframe) normally treats cable problems as a
> >  transient error and retries  indefinitely until they are repaired, or until
> >  the sysadmin says otherwise.  This seems a reasonable approach.
> >
> >  The only situation where it might make sense for md to retry is if it could
> >  retry in a 'different' way (trying the same thing again and expecting a
> >  different result is not entirely rational after all...).
> >  e.g. md/raid1 could issue reads with the FASTFAIL flag which - for dasd at
> >  least - says to not retry transport errors indefinitely.  After an error
> >  from that read it would be sensible not to reject the device but just direct
> >  the read to a different device.  If all devices failed with FASTFAIL, then
> >  try again without FASTFAIL - then treat such a failure as hard.
> >
> >  That might be nice, but the last time I tried it different drivers treated
> >  FASTFAIL quite differently.  e.g. my SATA devices would fairly often fail
> >  FASTFAIL requests even when they were otherwise working perfectly.
> >  I don't think that FASTFAIL is/was very well specified:  'fast' is a
> >  relative term after all.
> >
> >  I note that there are now 3 different FAILFAST flags (DEV, TRANSPORT, and
> >  DRIVER).  Maybe they have more useful implementations so maybe it is time to
> >  revisit this issue again.
> >
> >  However it remains that if no FAILFAST flags are present, then it is up to
> >  the driver to do any retries that might be appropriate - md cannot be
> >  involved in retries at that level.
> >
> >   
> I have mixed feelings on that, I agree in a well defined layered model, 
> but since the driver has no reconstructed data to offer on a rewrite, 
> the most I think it can do is to pass useful timeout status back to the 
> caller. The rewrite and the device fail are at a higher level, in dm or 
> md, so the decision needs to be there, with useful information passed up.
> > 

I see FAILFAST as explicitly saying "I have an alternate strategy, don't
worry about failure".  A problem is that it doesn't indicate the cost of
the alternate, so the low level driver cannot really deduce from it how
much retrying is appropriate.

Thinking a bit more about this, I probably could get md to use a straight
forward FAILFAST for reads when the array is not degraded.  If that fails
on all devices, we retry without failfast, then do the fix-bad-block
approach if needed.  That should work no matter how trigger-happy FAILFAST
was.  How if it was too fast that might kill performance, but that might
not be my problem.

I could probably use it for writes if I had working bad-block list, but I
wouldn't use it for writing out the bad-block-list, so that wouldn't
address the OP problem.

Thanks,
NeilBrown

  
> >> As an aside, it would be handy to have mechanisms exposed to userspace 
> >> (via mdadm) to display, test, and possibly override the memory of these 
> >> bad blocks such that in these instances where md has (possibly 
> >> incorrectly) forced a range of blocks unavailable on a member that we 
> >> can recover data if the automated recovery doesn't succeed.
> >>     
> >
> > Yes, the bad block list is entirely exposed to user-space via sysfs.
> > Removing entries from the list directly is not currently supported (except
> > for debugging purposes).  To remove a bad block you just need to arrange a
> > successful write to the device which can be done with the 'check' feature.
> > Adding and examining bad blocks is easy.
> >
> >   
> >> Do you have thoughts or plans to behave differently based on the type of 
> >> error?  I believe today the SCSI layer only provides pass/fail, is that 
> >> correct?  If so, plumbing would need to be added to make the upper layer 
> >> aware of the nature of the failure.  It seems that the bad block 
> >> management in md should only take effect for media errors and that there 
> >> should be more intelligent handling of other types of errors.  We would 
> >> be happy to help in this area if it aligns with your/the community's 
> >> longer term view of things.
> >>     
> >
> > I've probably answered this question above, but to summarise:
> >  I think there could be some place for responding differently to different
> >  types of errors, but it would only be to respond more harshly than we
> >  currently do.
> >   
> 
> More harshly? Most hot swap bays do not support physical ejection. ;-)
> 
> >  I think that any differentiation should come by md making different sorts of
> >  requests (e.g. with or without FAILFAST), and possibly retrying such
> >  requests in a more forceful way, or after other successes have shown that it
> >  might be appropriate.
> >
> > Thanks,
> > NeilBrown
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >   
> 
> 


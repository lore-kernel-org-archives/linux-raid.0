From: Neil Brown <neilb@suse.de>
Subject: Re: array_state_store: 'inactive' versus 'clean' race
Date: Wed, 29 Apr 2009 11:14:26 +1000
Message-ID: <18935.43506.654641.312777@notabene.brown>
References: <1240881843.30002.42.camel@dwillia2-linux.ch.intel.com>
	<18934.33566.354244.217291@notabene.brown>
	<49F74560.7030702@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday April 28
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Danecki, Jacek" <jacek.danecki@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday April 28, dan.j.williams@intel.com wrote:
> Neil Brown wrote:
> > So I'm leaning towards:
> >   - a kernel change so that you can only set 'inactive' if the
> >     array is already clean or readonly.
> >     i.e. if (mddev->ro || mddev->in_sync)
> >     which possible is the same as simply
> >          if (mddev->in_sync)
> >   - an mdadm change so that is doesn't just set 'inactive'
> >     but rather
> >          sysfs_set_str(mdi, NULL, "array_state", "clean");
> > 	 ping_monitor(mdi->text_version);
> > 	 sysfs_set_str(mdi, NULL, "array_state", "inactive")
> 
> I recall that when implementing WaitClean there was a reason not to 
> write 'clean' from mdadm... /me looks in the logs.  Yes, from commit 
> 0dd3ba30:
> 
> "--wait-clean: shorten timeout
> 
> Set the safemode timeout to a small value to get the array marked clean 
> as soon as possible.  We don't write 'clean' directly as it may cause 
> mdmon to miss a 'write-pending' event."
> 
> So we do not want a thread to hang because we missed its write-pending 
> event, or will it receive an error after the device has been torn down?

I don't see that writing 'clean' can cause a 'write-pending' state to
be missed.
If the array is in 'write-pending', it is because some thread is in
md_write_start waiting for MD_CHANGE_CLEAN to be cleared.  So
->writes_pending is elevated.  So an attempt to write 'clean' will
result in -EBUSY.

???

> 
> >   - make sure that if mdmon sees the array as 'clean', it will
> >     update it's metadata etc so that it feels no further urge
> >     to mark the array clean.
> > 
> > Also, we need to fix the WARNING, which I think means moving
> > 		list_for_each_entry(rdev, &mddev->disks, same_set)
> > 			if (rdev->raid_disk >= 0) {
> > 				char nm[20];
> > 				sprintf(nm, "rd%d", rdev->raid_disk);
> > 				sysfs_remove_link(&mddev->kobj, nm);
> > 			}
> 
> It would also involve a flush_scheduled_work() somewhere to make sure 
> the md_redundancy_group has been deleted.  But it occurs to me that 
> do_md_run() should still be failing in the case where userspace gets the 
> ordering of 'inactive' wrong...
> 

Uhmm..... I think we should split the removal of md_redundancy_group
out in to a separate delayed_work.  But yes, we need to deal with that
somehow.


> > 
> > in do_md_stop up in to the
> > 		case 0: /* disassemble */
> > 		case 2: /* stop */
> > 
> > section.
> > 
> > My one concern about this conclusion is that it seems to sidestep the
> > core problem rather than address it.
> > The core problem is that setting the state to 'clean' means very
> > different thing depending on which side you come from, so an app which
> > writes 'clean' might get more than it bargained for.  All I'm doing is
> > making that confusion avoidable rather than impossible....
> > 
> > I guess I could invent a syntax:
> >  writing "a->b" to array_state sets the state to 'b' but only if it
> >  was already in 'a'.
> > But that feels needlessly complex.
> > 
> > So:  do you agree with my leaning?  or my concern?  or both or neither?
> 
> First let me say that I really appreciate when you do these 
> implementation contingency brain dumps, it really helps to get all the 
> cards on the table (something I would do well to emulate).
> 
> I agree with your concern and I am currently more in line with the idea 
> that the confusion should be impossible rather than avoidable.  I now 
> think it is a bug that the 'inactive' state has two meanings.  A new 
> state like 'shutdown' or 'defunct' would imply that 'clear' is the only 
> valid next state, all other writes return an error.
> 
> So, it is not quite as ugly as randomly preventing some 
> 'inactive->clean' transitions in that userspace can see why its attempt 
> to write 'clean' is returning -EINVAL.
> 
> Thoughts?

I don't like the idea of a trap-door where once you get to 'shutdown'
the only way out is 'clear'.  But I could possibly live with a state
like 'shutdown' which can transition to either 'clear' or 'inactive',
but not directly to 'clean'.   I cannot think of an immediate use for
the 'shutdown'->'inactive' transition, but I wouldn't want to exclude
it.

But I really think the 'problem' is more around 'clean' then it is
around 'inactive'.
I think I would like writing 'clean' never to start the array.
If we want to start the array in the 'clean' state, then write
something else.  I think we can just write 'active'.  That will
actually leave the array in a 'clean' state I think.  I'd need to
check that...

So now I think we just arrange that 'clean' returns -EINVAL if 
mddev->pers == NULL.
We never currently write 'clean' to start an array.  We either use
RUN_ARRAY, or mdmon writes either read_auto or active.

So that is safe.

So we need to:

 - remove the rd%d links earlier
 - remove the redundancy group earlier
 - disable starting an array by writing 'clean'.

I think I've convinced myself.  Have I convinced you?

NeilBrown

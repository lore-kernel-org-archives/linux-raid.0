From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: array_state_store: 'inactive' versus 'clean' race
Date: Tue, 28 Apr 2009 11:05:20 -0700
Message-ID: <49F74560.7030702@intel.com>
References: <1240881843.30002.42.camel@dwillia2-linux.ch.intel.com> <18934.33566.354244.217291@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18934.33566.354244.217291@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Danecki, Jacek" <jacek.danecki@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> So I'm leaning towards:
>   - a kernel change so that you can only set 'inactive' if the
>     array is already clean or readonly.
>     i.e. if (mddev->ro || mddev->in_sync)
>     which possible is the same as simply
>          if (mddev->in_sync)
>   - an mdadm change so that is doesn't just set 'inactive'
>     but rather
>          sysfs_set_str(mdi, NULL, "array_state", "clean");
> 	 ping_monitor(mdi->text_version);
> 	 sysfs_set_str(mdi, NULL, "array_state", "inactive")

I recall that when implementing WaitClean there was a reason not to 
write 'clean' from mdadm... /me looks in the logs.  Yes, from commit 
0dd3ba30:

"--wait-clean: shorten timeout

Set the safemode timeout to a small value to get the array marked clean 
as soon as possible.  We don't write 'clean' directly as it may cause 
mdmon to miss a 'write-pending' event."

So we do not want a thread to hang because we missed its write-pending 
event, or will it receive an error after the device has been torn down?

>   - make sure that if mdmon sees the array as 'clean', it will
>     update it's metadata etc so that it feels no further urge
>     to mark the array clean.
> 
> Also, we need to fix the WARNING, which I think means moving
> 		list_for_each_entry(rdev, &mddev->disks, same_set)
> 			if (rdev->raid_disk >= 0) {
> 				char nm[20];
> 				sprintf(nm, "rd%d", rdev->raid_disk);
> 				sysfs_remove_link(&mddev->kobj, nm);
> 			}

It would also involve a flush_scheduled_work() somewhere to make sure 
the md_redundancy_group has been deleted.  But it occurs to me that 
do_md_run() should still be failing in the case where userspace gets the 
ordering of 'inactive' wrong...

> 
> in do_md_stop up in to the
> 		case 0: /* disassemble */
> 		case 2: /* stop */
> 
> section.
> 
> My one concern about this conclusion is that it seems to sidestep the
> core problem rather than address it.
> The core problem is that setting the state to 'clean' means very
> different thing depending on which side you come from, so an app which
> writes 'clean' might get more than it bargained for.  All I'm doing is
> making that confusion avoidable rather than impossible....
> 
> I guess I could invent a syntax:
>  writing "a->b" to array_state sets the state to 'b' but only if it
>  was already in 'a'.
> But that feels needlessly complex.
> 
> So:  do you agree with my leaning?  or my concern?  or both or neither?

First let me say that I really appreciate when you do these 
implementation contingency brain dumps, it really helps to get all the 
cards on the table (something I would do well to emulate).

I agree with your concern and I am currently more in line with the idea 
that the confusion should be impossible rather than avoidable.  I now 
think it is a bug that the 'inactive' state has two meanings.  A new 
state like 'shutdown' or 'defunct' would imply that 'clear' is the only 
valid next state, all other writes return an error.

So, it is not quite as ugly as randomly preventing some 
'inactive->clean' transitions in that userspace can see why its attempt 
to write 'clean' is returning -EINVAL.

Thoughts?

Thanks,
Dan

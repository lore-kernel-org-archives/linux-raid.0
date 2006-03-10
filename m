From: Sean Puttergill <puttergi@yahoo.ca>
Subject: Re: Auto-assembling arrays using mdadm
Date: Fri, 10 Mar 2006 04:34:58 -0500 (EST)
Message-ID: <20060310093459.67755.qmail@web35304.mail.mud.yahoo.com>
References: <17425.3736.352007.884424@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17425.3736.352007.884424@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: dean gaudet <dean@arctic.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I definitely wish to do this, that's why I'm asking. 
I assume your statement refers to the general
usefulness of what I am asking for.

As to why I wish to implement this functionality, well
you can tell that I am not targetting this at your
average user's PC.  Not to be too secretive, but think
along the lines of something more appliance like. 
Amongst the requirements that I have for the system
that I am constructing, I must deal with installing
RAID sets that come from other boxes.  I need to be
able to automatically start up existing RAID arrays on
drive sets that have migrated over without needing to
have any a priori knowledge of the RAID arrays that
might exist on the drives.

In any case, your suggestion of a new flag to output
unique device names from mdadm --examine (using UUID
of array) sounds like an acceptable solution.  Please
consider adding it.

I assume that using "--auto=md" when assembling will
currently not take care of minor number conflicts in
the config file?


Thanks,
Sean

--- Neil Brown <neilb@suse.de> wrote:

> On Thursday March 9, puttergi@yahoo.ca wrote:
> 
> It is not clear to me that this is something that
> you would ever want
> to do, just as you would not want an automatic
> process to mount every
> filesystem that it finds on any disk drive. (I agree
> with dean here).
> 
> Maybe if you explained why you wanted to do this, a
> more focussed
> response could be provided.
> 
> 
> > That did the trick, except you must do:
> > 
> > mdadm --examine --scan --config=tmp.mdadm.conf
> > >>tmp.mdadm.conf
> > 
> > instead of:
> > 
> > mdadm --detail --scan --config=tmp.mdadm.conf
> > >>tmp.mdadm.conf
> > 
> > I assume that this method would have the same
> problems
> > with conflicting minor number.  Will have to add
> an
> > intermediate step to process the tmp.mdadm.conf
> file
> > to uniquify the RAID array device names (i.e.
> remove
> > duplicate /dev/md0, etc.).
> > 
> > 
> > Thanks for the tip.  I personally think mdadm
> should
> > be modified to do this all in one step (including
> > dealing with minor number conflicts).
> 
> This is unlikely to happen.
> 
> It is, however, possible that "mdadm --examine
> --scan" could grow an option
> whereby the device names are given as
>   /dev/md/UUID:OF:THE:ARRAY:THAT:WAS:FOUND
> 
> This, toogether with giving 'auto=mdp' could avoid
> and issues with
> minor number conflicts.  Then:
>   echo DEV partitions > /etc/mdadm.conf
>   mdadm -Es --new-flag >> /etc/mdadm.conf
>   mdadm -As --auto-mdp
> would assemble all arrays, which is what you claim
> to want.
> 
> NeilBrown
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 

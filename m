From: keld@keldix.com
Subject: Re: [md PATCH 15/23] md/raid10 - support resizing some RAID10 arrays.
Date: Wed, 14 Mar 2012 13:37:46 +0100
Message-ID: <20120314123746.GA11117@www5.open-std.org>
References: <20120314043555.7978.75486.stgit@notabene.brown> <20120314044040.7978.69754.stgit@notabene.brown> <20120314061746.GA28196@www5.open-std.org> <20120314172712.3aa9310a@notabene.brown> <4F604E10.20605@westcontrol.com> <20120314193215.267f2d83@notabene.brown> <4F6070EF.5060604@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F6070EF.5060604@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 14, 2012 at 11:20:31AM +0100, David Brown wrote:
> On 14/03/2012 09:32, NeilBrown wrote:
> >On Wed, 14 Mar 2012 08:51:44 +0100 David Brown<david@westcontrol.com>  
> >wrote:
> >
> >>On 14/03/2012 07:27, NeilBrown wrote:
> >>>On Wed, 14 Mar 2012 07:17:46 +0100 keld@keldix.com wrote:
> >>>
> >>>>Hi Neil
> >>>>
> >>>>What is the problem with adding space to the 'far' layout?
> >>>>
> >>>>I would think you could just create the new array part 1 from the
> >>>>old array part 2, and then sync the new array part 2 with the new
> >>>>array part 1. (in the case of a far=2 array, for n>2 similar
> >>>>constructs would apply).
> >>>
> >>>If I understand your proposal correctly, you would lose redundancy
> >>>during the process, which is not acceptable.
> >>>
> >>
> >>That's how I understood the suggestion too.  And in some cases, that
> >>might be a good choice for the user - if they have good backups, they
> >>might be happy to risk such a re-shape.  Of course, they would have to
> >>use the "--yes-I-really-understand-the-risks" flag to mdadm, but other
> >>than that it should be pretty simple to implement.
> >
> >Patches welcome :-)
> >
> >(well, actually not - I really don't like the idea.  But my point is that
> >these things turn out to be somewhat more complicated than they appear at
> >first).
> >
> 
> I haven't written any code for md raid, but I've looked at enough to 
> know that you have to tread carefully - especially as people expect a 
> particularly high level of code correctness in this area.  "Pretty 
> simple to implement" is a relative term!
> 
> I can imagine use cases where it would be better to have an unsafe 
> resize than no resize - and maybe also cases where a fast unsafe resize 
> is better than a slow safe resize.  But I can also imagine people 
> getting upset when they find they have used the wrong one, and I can 
> also see that implementing one "fast but unsafe" feature could easy be 
> the start of a slippery slope.
> 
> >>
> >>For a safe re-shape of raid10, you would need to move the "far" copy
> >>backwards to the right spot on the growing disk (or forwards if you are
> >>shrinking the array).  It could certainly be done safely, and would be
> >>very useful for users, but it is not quite as simple as an unsafe re-size.
> >
> >Reshaping a raid10-far to use a different amount of the device would
> >certainly be possibly, but is far from trivial.
> >One interesting question is how to record all the intermediate states in 
> >the
> >metadata.
> >
> 
> I had only been thinking of the data itself, not the metadata.
> 
> When doing the reshape, you would start off with some free space at the 
> end of the device (assuming you are growing the raid).  You copy a block 
> of data from near the end of the far copy to its new place in the free 
> space.  Then you can update the metadata to track that change.  While 
> you are doing the metadata update, both the original part of the far 
> copy, and the new part are valid, so you should be safe if you get a 
> crash during the update.  Once the metadata has been updated, you've got 
> some new free space ready to move the next block.  I don't /think/ you'd 
> need to track much new metadata - just a "progress so far" record.
> 
> Of course, any changes made to the data and filesystems while this is in 
> progress might cause more complications...
> 
> 
> 
> One particular situation that might be easier as a special case, and 
> would be common in practice, would be when growing a raid10,far to 
> devices that are at least twice the size.  If you pretend that the 
> existing raid10,f device sits on top of a newly created, bigger raid10,f 
> device, then standard raid10,far synchronisation code would copy over 
> everything to the right place in the bigger disks - even if the data 
> changes underway.  This artificial big raid10,f would have its metadata 
> in memory only - there is no need to save anything, since you still have 
> the normal original raid10 copy for safety.  Once the new big raid is 
> fully synchronised, you write its metadata over the original raid10 
> metadata.
> 
> 
> I'm just throwing around ideas here.  If they are of help or inspiration 
> to anyone, that's great - if not, that's okay too.
> 
> mvh.,
> 
> David
> 
> 
> 
> 
> >NeilBrown
> >
> >
> >
> >>
> >>mvh.,
> >>
> >>David
> >>
> >>
> >>>If I don't understand properly - please explain in a bit more
> >>>detail.

Well, my knowledge of the kernel code is quite limited, and I originally did not know of your
aim at keeping it safe. Anyway for keeping it safe, I then have some ideas, for raid10,f

Assuming a grow, you could copy within the same raid0 part, that is: you could just make a raid0 grow.
And make a raid0 grow for each of the raid0 parts in the raid10,f array.

Some details: initially you could copy the first blocks to an unused area of one of the new disks.
This would be to get started. Once you have gotten clear of the problem with writing over
data that you have just read then you just need to copy and keep track of where you are,
block number read and block number written. No need to keep other copies. And the ordinary read/writes
will go to the disk blocks according to the old/new blocks divide. For metadata, I dont know what
more you need to keep track of.  For efficiency I would use quite large buffers, say 2 to 8 MB stripes.

Best regards
keld

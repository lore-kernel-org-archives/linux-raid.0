From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 00/24] Clustered MD RAID1
Date: Tue, 10 Feb 2015 11:00:31 -0600
Message-ID: <54DA392F.1050506@suse.de>
References: <20141218161456.GA29504@shrek.lan> <20150206133952.173f1975@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150206133952.173f1975@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

>
>
> hi Goldwyn,
>   thanks for these - and sorry for the long delay.   Lots of leave over
>   southern summer, and the lots of email etc to deal with.
>
> This patch set is very close and I am tempted to just apply it and then
> fix things up with subsequent patches.  In order to allow that, could you
> please:
>    - rebase against current upstream
>    - fix the checkpatch.pl errors and warnings.
>      The "WARNING: line over 80 characters" are often a judgement call
>      so I'm not particularly worried about those.  Most, if not all, of
>      the others should be followed just to have consistent layout.

Done.

>
> Then I'll queue them up for 3.21, providing I don't find anything that would
> hurt non-cluster usage ....
>   On that topic: why initialise rv to -EINVAL in "metadata_update sends
>   message...".  That looks wrong.

Yes, this is fixed.

>
> I noticed that a number of times a patch will revert something that a
> previous patch added.  It would be much nicer to fold these changes back into
> the original patch.  Often this is just extra blank lines, but occasionally
> variable names are changed (md -> mddev).  It should be given the final name
> when introduced.  Every chunk in every patch should be directly relevant to
> that patch.

I have cross-checked this and I did not find anything with respect to 
variable names. I did some cleanup with respect to the code though.

There is one instance where I have used a variable: cluster_setup_done 
and then removed it. I think this is required to understand the patch 
and a smooth transition to subsequent patches. However, if you want me 
to aggressively remove that part, I should be able to do that.

>
> Some other issues, that could possibly be fixed up afterwards:
>
>   - Is a clustername 64 bytes or 63 bytes?  I would have thought 64,
>     but the use of strlcpy make is 63 plus a nul.  Is that really what is
>     wanted?

Yes, it is 64 bytes. I haven't fixed this as yet.

>
>   - Based on https://lkml.org/lkml/2012/10/23/580 it might be good to add
>     "default n" to Kconfig, and possible add a WARN() if anyone tries to use
>     the code.

Done. Added pr_warn while loading the module.

>
>   - I'm a bit concerned about the behaviour on node failure.
>     When a node fails, two things must happen w.r.t the bits in that node's
>     bitmap.
>     1/ The corresponding regions of the array need to be resynced.  You do have
>        code to do this.
>     2/ Other nodes must avoid read-balancing on those regions until the
>        resync has completed.
>
>     You do have code for this second bit, but it looks wrong.  It avoids
>     read-balancing if ->area_resyncing().  That isn't sufficient.
>     The "area_resyncing" is always (I assume) a relatively small region of
>     the array which will be completely resynced quite quickly.  It must be
>     because writes are blocked to this area.  However the region in which
>     we must disable re-balancing can be much larger.  It covers *all* bits
>     that are set in any unsynced bitmap.  So it isn't just the area that is
>     currently being synced, but all areas that will be synced.

What are unsynced bitmaps? Are they bitmaps which are associated with an 
active node or dirty bitmaps with dead nodes? If it is the former, I 
agree this is not enough. If it is latter, all nodes maintain a linked 
list of all the nodes which are currently performing resync (probably 
because of multiple nodes died simultaneously). One node performs the 
recovery (aka bitmap resync) of exactly one "dead" node at a time. 
area_resyncing goes through all the nodes which are performing resync.

>
>   - I think md_reload_sb() might be too simple.  It probably should check that
>     nothing serious has changed.  The "mddev->raid_disks = 0" look suspicious.
>     I'll have to think about this a bit more.

Yes, I get that feeling as well. However, I am not sure how to perform 
an exact comparison to understand what has changed. Perhaps it needs a 
new flag?

>
> That's all I can see for now.  I'll have another look once I have it all in my tree.
>

I have put all the changes in my git:
https://github.com/goldwynr/linux
The branch cluster-md is against the latest upstream. I also performed a 
small sanity test to check everything is working properly.

Let me know if you would want me to repost the entire patchset to the 
mailing list.


-- 
Goldwyn

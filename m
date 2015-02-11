From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 00/24] Clustered MD RAID1
Date: Wed, 11 Feb 2015 11:25:01 -0600
Message-ID: <54DB906D.8050205@suse.de>
References: <20141218161456.GA29504@shrek.lan>	<20150206133952.173f1975@notabene.brown>	<54DA392F.1050506@suse.de> <20150211151709.510005d2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150211151709.510005d2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On 02/10/2015 10:17 PM, NeilBrown wrote:
> On Tue, 10 Feb 2015 11:00:31 -0600 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
>> Hi Neil,
>>
>>>
>>>
>>> hi Goldwyn,
>>>    thanks for these - and sorry for the long delay.   Lots of leave over
>>>    southern summer, and the lots of email etc to deal with.
>>>
>>> This patch set is very close and I am tempted to just apply it and then
>>> fix things up with subsequent patches.  In order to allow that, could you
>>> please:
>>>     - rebase against current upstream
>>>     - fix the checkpatch.pl errors and warnings.
>>>       The "WARNING: line over 80 characters" are often a judgement call
>>>       so I'm not particularly worried about those.  Most, if not all, of
>>>       the others should be followed just to have consistent layout.
>>
>> Done.
>
> ERROR: code indent should use tabs where possible
>
>    when you use spaces, they show up in red for me!!
> Ditto for
> WARNING: please, no space before tabs
>
> WARNING: quoted string split across lines
>     It really is best to fix those, even though it makes the line long.
>     When grepping to find out where a message comes from, it is very annoying
>     if the grep fails because the line was split.
>
> WARNING: Missing a blank line after declarations
>     Worth fixing I think.
>
> WARNING: printk() should include KERN_ facility level
>     Definitely should be fixed, maybe make it pr_warn()??
>

Ok, my review was not good. I have incorporated all of these and put 
them in the same branch. Sorry for the trouble.

>   "Introduce md_cluster_info" moves 'bast' to a new location in
>   dlm_lock_resource for no apparent reason.
>   Also 'leave()' has a parameter which is changed from 'md' to 'mddev',
>   as does 'join'.
>
>   "Add node recovery callbacks" adds a comment to the 'nodes' field of 'struct
>   mddev'.  Why not add the comment when the field is added?
>   Oh, and it mis-spells "unmber".
>
>
>   In "Gather on-going resync information of other nodes" you have:
>
>   static struct md_cluster_operations cluster_ops = {
>          .join   = join,
>          .leave  = leave,
> -       .slot_number = slot_number
> +       .slot_number = slot_number,
> +       .resync_info_update = resync_info_update
>   };
>
>
> It is really best to put a comma at the end of each entry, even the last.
> Then the patch would have been:
>
>   static struct md_cluster_operations cluster_ops = {
>          .join   = join,
>          .leave  = leave,
>          .slot_number = slot_number,
> +       .resync_info_update = resync_info_update,
>   };
>
> which is much nicer to read.  You finally get this right in
>    "Suspend writes in RAID1 if within range" :-)

Ok, I have fixed them in all the patches.

>>>
>>>    - I'm a bit concerned about the behaviour on node failure.
>>>      When a node fails, two things must happen w.r.t the bits in that node's
>>>      bitmap.
>>>      1/ The corresponding regions of the array need to be resynced.  You do have
>>>         code to do this.
>>>      2/ Other nodes must avoid read-balancing on those regions until the
>>>         resync has completed.
>>>
>>>      You do have code for this second bit, but it looks wrong.  It avoids
>>>      read-balancing if ->area_resyncing().  That isn't sufficient.
>>>      The "area_resyncing" is always (I assume) a relatively small region of
>>>      the array which will be completely resynced quite quickly.  It must be
>>>      because writes are blocked to this area.  However the region in which
>>>      we must disable re-balancing can be much larger.  It covers *all* bits
>>>      that are set in any unsynced bitmap.  So it isn't just the area that is
>>>      currently being synced, but all areas that will be synced.
>>
>> What are unsynced bitmaps? Are they bitmaps which are associated with an
>> active node or dirty bitmaps with dead nodes? If it is the former, I
>> agree this is not enough. If it is latter, all nodes maintain a linked
>> list of all the nodes which are currently performing resync (probably
>> because of multiple nodes died simultaneously). One node performs the
>> recovery (aka bitmap resync) of exactly one "dead" node at a time.
>> area_resyncing goes through all the nodes which are performing resync.
>
> The later - bitmaps associated with a dead node.
> Bitmaps associated with an active node contain transient information, and the
> filesystem will ensure that it never reads from somewhere that someone else
> might be writing (or if it does, it will know that the data cannot be
> trusted).
>
> I looked at the code again, and discovered that I had the problem backwards.
> But there is still a problem.
>
> when any node is resyncing, your code blocks writes for the entire span of the
> array from where-ever the resync is up to, to the end of the device.
> So a write to a location near the end of the  device will hang until all
> resyncs finish.  This could be a much longer time than you would like writes
> to hang for.
>
> I think that the resyncing host should only report that it is resyncing a
> relatively small range of the array, maybe 100Meg.  Maybe 1G.
> Then that would only block access to that small part of the array, which
> should clear in just a few seconds at most.
>
> This information on the range being synced is not enough to limit
> read-balancing.
> I imagined that *every* node would read the bitmap for a failed node, and
> would use that information to limit read-balancing.  There are some
> complexities in this though.
>
>
> So the current code isn't "wrong" exactly, but it think it could cause sever
> delays in some (unusual) circumstances.


I thought about this as well and this is what I think we should do for a 
node failure:

Attempt a PW lock (DLM_LKF_NOQUEUE) on the failed nodes bitmap. If 
successful:
	a. Read the bitmap.
	b. Update the bitmap LVB with the resync details.
	c. Send the RESYNCING message
	d. Perform the resync and update the LVB as we proceed. (This means we 
will have to write another resync function independent of md_do_sync)

area_resyncing:
	a. Check the resyncing node list. If not found, or is out of range, 
return 0.
	b. If an entry exists with overlapping range of I/O, take a CR lock on 
bitmap-<nodenum>.
	c. Read the LVB for limits and update limits in the resyncing node list.
	d. If read/write range is not within new range details, unlock CR and 
return 0
	e. If read/write is within range, read the bitmap and check for 
interfering bitmaps. If not interfering return 0 else return 1. Perhaps 
we could reserve the bitmap.

Using step c,d may make it a wee bit faster without the need to going to 
the disk.

The problem I see in this approach is cascading failures. What should we 
do if the node performing the resync for a recently failed node also 
fails? How do we detect that the failed node was performing a resync for 
another node? One option is we could add that information in the 
RESYNCING message. Can you think of something better?

The way it is being done now is that we aggressively (no NOQUEUE) take 
the bitmap lock and the resyncing node copies the bits into its own 
bitmap and clears the failed bitmap before releasing the bitmap lock.

Finally, should we put some sort of versioning in the messages for 
rolling upgrades? (One node is on a higher kernel version with respect 
to the rest of the nodes)

-- 
Goldwyn

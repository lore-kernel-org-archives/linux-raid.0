From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID creation resync behaviors
Date: Thu, 4 May 2017 17:02:05 +0100
Message-ID: <590B507D.6050609@youngman.org.uk>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
 <fe3c30e4-b0dd-639e-7db7-344aa93ce198@hesbynett.no>
 <20170504015454.d4obiuume6e3yrdv@kernel.org> <590ADA3F.8070909@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <590ADA3F.8070909@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

On 04/05/17 08:37, David Brown wrote:
> On 04/05/17 03:54, Shaohua Li wrote:
>> > On Wed, May 03, 2017 at 11:06:01PM +0200, David Brown wrote:
>>> >> On 03/05/17 22:27, Shaohua Li wrote:
>>>> >>> Hi,
>>>> >>>
>>>> >>> Currently we have different resync behaviors in array creation.
>>>> >>>
>>>> >>> - raid1: copy data from disk 0 to disk 1 (overwrite)
>>>> >>> - raid10: read both disks, compare and write if there is difference (compare-write)
>>>> >>> - raid4/5: read first n-1 disks, calculate parity and then write parity to the last disk (overwrite)
>>>> >>> - raid6: read all disks, calculate parity and compare, and write if there is difference (compare-write)
>>>> >>>
>>>> >>> Write whole disk is very unfriendly for SSD, because it reduces lifetime. And
>>>> >>> if user already does a trim before creation, the unncessary write could make
>>>> >>> SSD slower in the future. Could we prefer compare-write to overwrite if mdadm
>>>> >>> detects the disks are SSD? Surely sometimes compare-write is slower than
>>>> >>> overwrite, so maybe add new option in mdadm. An option to let mdadm trim SSD
>>>> >>> before creation sounds reasonable too.
>>>> >>>
>>> >>
>>> >> When doing the first sync, md tracks how far its sync has got, keeping a
>>> >> record in the metadata in case it has to be restarted (such as due to a
>>> >> reboot while syncing).  Why not simply /not/ sync stripes until you first
>>> >> write to them?  It may be that a counter of synced stripes is not enough,
>>> >> and you need a bitmap (like the write intent bitmap), but it would reduce
>>> >> the creation sync time to 0 and avoid any writes at all.
>> > 
>> > For raid 4/5/6, this means we always must do a full stripe write for any normal
>> > write if it hits a range not synced. This would harm the performance of the
>> > norma write.
> Agreed.  The unused sectors could be set to 0, rather than read from the
> disks - that would reduce the latency and be friendly to high-end SSDs
> with compression (zero blocks compress quite well!).
> 
>> > For raid1/10, this sounds more appealing. But since each bit in
>> > the bitmap will stand for a range. If only part of the range is written by
>> > normal IO, we have two choices. sync the range immediately and clear the bit,
>> > this sync will impact normal IO. Don't do the sync immediately, but since the
>> > bit is set (which means the range isn't synced), read IO can only access the
>> > first disk, which is harmful too.
>> > 
> This could be done in a more sophisticated manner.  (Yes, I appreciate
> that "sophisticated" or "complex" are a serious disadvantage - I'm just
> throwing up ideas that could be considered.)
> 
> Divide the array into "sync blocks", each covering a range of stripes,
> with a bitmap of three states - unused, partially synced, fully synced.
>  All blocks start off unused.  If a write is made to a previously unused
> block, that block becomes partially synced, and the write has to be done
> as a full stripe write.  For a partially synced block, keep a list of
> ranges of synced stripes (a list will normally be smaller than a bitmap
> here).  Whenever there are partially synced blocks in the array, have a
> low priority process (like the normal array creation sync process, or
> rebuild processes) sync the stripes until the block is finished as a
> fully synced block.
> 
> That should let you delay the time-consuming and write intensive
> creation sync until you actually need to sync the blocks, without /too/
> much overhead in metadata or in delays when using the disk.

I was thinking along those lines. You mentioned earlier what I would
think of as a "high water mark" - or "how far have we used the array".
The only snag I can think of there is if you start writing in the middle
of the array so your idea of blocks sounds a lot better.

The other thing - this would probably be a synonym of "--assume-clean"
but create a flag "--new-array". This would have to be an opt-in - it
tells mdadm that whatever is on the disk is garbage, and when it does
sync it can safely just stream zeroes to the disk - no reads or parity
checks required ... :-) (This idea might need a few tweaks :-)

Cheers,
Wol

From: Chris Schanzle <mdadm@cas.homelinux.org>
Subject: Re: Correct RAID options
Date: Wed, 20 Aug 2014 01:58:34 -0400
Message-ID: <53F4390A.9060807@cas.homelinux.org>
References: <027801cfbbdc$d33970f0$79ac52d0$@savage.za.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <027801cfbbdc$d33970f0$79ac52d0$@savage.za.org>
Sender: linux-raid-owner@vger.kernel.org
To: savage@savage.za.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/19/2014 02:38 PM, Chris Knipe wrote:
> All the servers
> store millions of small (< 2mb) files, in a structured directory structure
> to keep the amount of files per directory in check.

How many millions?
If you ever have to xfs_repair, the RAM requirements get pretty substantial with many files.  Shouldn't be a problem with 64GB servers, but not long ago with 4-8GB boxes, this was an issue.  Be sure to test and monitor with 'top'.


 >Bigger blocks does mean wasting more space though if the files written are smaller and can't necessarily fill up an entire block, right?

No, it means you have to read more "junk" to rewrite the whole stripe (think read:modify:write).  [Perhaps you are thinking of filesystem block size affecting "internal fragmentation".]


 >load averages shoot up to over 80 due to IO wait from time to time,

Just a friendly reminder that your processors are not "busy" with that high load, just you have many processes WAITING on disk I/O. Many people incorrectly equate load average with CPU utilization.


 >Files are generally between 250kb and 750kb, a small percentage are a
 >bit larger to the 1.5mb range, and I can almost guarantee that not one
 >single file will exceed the 5mb range.

With so many of your files being similar sized, a 1MB stripe size should be optimal for a parallel random read/write usage.


When archiving, your disk waits are probably caused by disk seeking.  If you can cache more (hopefully *all*!) inode/dnodes, you will reduce disk seeking tremendously by not having to seek for metadata (possibly requiring multiple seeks for each file read), instead just seeking to the actual file data and reading a whole stripe greatly reduces disk head thrashing and waits.  I know it is counter-intuitive, but the last thing you want your file server to cache is file data (unless the same file data is repeatedly read).  Metadata is king.  [I'm still waiting for a filesystem that supports storing metadata on a separate device, like RAID1 SSD.]

Try tuning /proc/sys/vm/vfs_cache_pressure to low values, preferably 0 to (theoretically) never flush inode/dnode data (though in practice, it still can drop inode data to cache file data).  Watch /proc/meminfo Slab (mostly inode/dnodes) grow in balance to Cached (file data).  With small (4GB) systems, I have seen kernel hangs under memory pressure from heavy disk writing. To help with this, tell the kernel to start asynchronously flushing dirty file data earlier by reducing /proc/sys/vm/dirty_background_ratio down to say, 5 or 2 (% of RAM).  Set /proc/sys/vm/dirty_ratio (% of RAM) where processes get blocked to flush dirty data to disk) to a realistic value so as to not let the dirty data cache wipe out your Slab, but still handle bursts of writes without putting processes into a blocked 
 disk wait state.  Use "time du -shx" to load the Slab with all your inode/dnode data.  Repeat.  Compare those times and monitor with 'iostat -x' to see how much disk I/O it takes (if none, 
it will be only be seconds, even for millions of files, rather than 10s of minutes).

You never mentioned how much RAM your processes take, but be sure to leave room for those as well when coming up with more appropriate dirty_ratio value.  Swapping out infrequently used pages from long-running processes is not necessarily a bad thing (especially if swap is on other spindles) and tuning /proc/sys/vm/swappiness *up* a bit can encourage the kernel to do just that.


With RAM being *relatively* inexpensive, if you use it effectively, it can greatly reduce your disk seeking and thus, waiting.


Of course, be sure to consider file system mount options to reduce seeking/writing:  mount with noatime, nobarrier.  And for ext3/4, consider using "tune2fs -o journal_data_writeback".  Be sure to understand what you're giving up in exchange for what you're getting.

Crazy as it may be, this is interesting stuff to me.  Feel free to drop me a line (on or off list) if you try this and if it helps (or hurts) or you have other ideas.

Regards,
Chris Schanzle



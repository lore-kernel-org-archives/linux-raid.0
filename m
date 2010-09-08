From: Neil Brown <neilb@suse.de>
Subject: Re: 3-way mirrors
Date: Thu, 9 Sep 2010 09:04:51 +1000
Message-ID: <20100909090451.7c92240b@notabene>
References: <20100908080155.2ed9300e@notabene>
	<20100908145232.9468.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100908145232.9468.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8 Sep 2010 10:52:32 -0400
"George Spelvin" <linux@horizon.com> wrote:

> > The relevant bit of code is in the MD_RECOVERY_REQUESTED branch of
> > sync_request_write() in drivers/md/raid1.c
> > Look for "memcmp".
> 
> Okay, so the data is in r1_bio->bios[i]->bi_io_vec[j].bv_page,
> for 0 <= i < mddev->raid_disks, and 0 <= j < vcnt (the number
> of 4K pages in the chunk).
> 
> Okay, so the first for() loop sets primary to the lowest disk
> number that was completely readable (.bi_end_io == end_sync_read
> && test_bit(BIO_UPTODATE).
> 
> Then the second loop compares all the data to the primary's data
> and, if it doesn't match, re-initializes the mirror's sbio to
> write it back.
> 
> I could probably figure this out with a lot of RTFSing, but if you
> don't mind me asking:
> - What does it mean if r1_bio->bios[i]->bi_end_io != end_sync_read.
>   Does that case only avoid testing the primary again, or are there
>   other cases where it might be true.  If there are, why not count
>   them as a mismatch?

bi_end_io is set up in sync_request().
A non-NULL value mean that a 'nr_pending' reference is held on the device.
If that value is end_sync_read, then a read was attempted.  If it is
end_sync_write, then no read was attempted as we would not expect the data to
be valid (typically during a rebuild).

So:
 NULL -> device is failed or doesn't exist or otherwise should be ignored
        e.g. during recovery we read from one device, write to one, and
        ignore the rest.
 end_sync_write -> device is working but is not in-sync.  Probably doesn't
        happen for check/repair cycles.
 end_sync_read -> we read this block so we need to test the content.


> - What does it mean if !test_bit(BIO_UPTODATE, &sbio->bi_flags)?

The read request failed.

> - How does the need to write back a particular disk get communicated
>   from the sbio setup code to the "schedule writes" section?

It is the other way around.  We signal "don't write this block" by setting
bi_end_io to NULL.
The default is to write to every working disk that isn't the first once we
read from and that isn't being ignored (this reflects that fact that the code
originally just did resync and recovery, and check/repair was added later).

> 
> (On a tangential note, why the heck are bi_flags and bi_rw "unsigned long"
> rather than "u32"?  You'd have to change "if test_bit(BIO_UPTODATE" to
> "if bio_flagged(sbio, BIO_UPTODATE."... untested patch appended.)

Hysterical Raisins?  You would need to take that up with Jens Axboe.


> 
> > You possibly want to factor out that code into a separate function before
> > trying to add any 'voting' code.
> 
> Indeed, the first thing I'd like to do is add some much more detailed
> logging.  What part of the chunk is mismatched?  One sector, one page,
> or the whole chunk?  Are just a few bits flipped, or is it a gross
> mismatch?  Which disks are mismatched?

Sounds good.  Keep it brief and easy to parse.  Probably for each time
memcmp fails for a requested pass, print one line that identifies the
2 devices, the sector/size of the block, the first and last byte that are
different, and the first 16 bytes of the differing range from each device ???


> 
> > This is controlled by raid10_add_disk in drivers/md/raid10.c.  I would
> > happily accept a patch which made a more balanced choice about where to add
> > the new disk.
> 
> Thank you very much for the encouragement!  The tricky cases are when
> the number of drives is not a multiple of the number of data copies.
> If I have -n3 and 7 drives, there are many possible subsets of 3 that will
> operate.  Suppose I have U__U_U_.  What order should drives 4..7 be added?

You don't need to make the code perfect, just better.
If you only change the order for adding spares in the simple/common case,
that would be enough improvement to be very worth while.

> 
> (That's something of a rhetorical question; I expect to figure out the
> answer myself, although you're welcome to chime in if you have any ideas.
> I'm thinking of some kind of score where I consider the n/gcd(n,k) stripe
> start positions and rank possible solutions based on the minimum redundancy
> level and the number of stripes at that level.  The question is, is there
> ever a case where the locations I'd like to add *two* disks differ from the
> location I'd like to add one?  If there were, it would be nasty.)
> 
> 

Thanks,
NeilBrown



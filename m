From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] DM RAID: Fix for ineffective "sync" directive
Date: Wed, 5 Sep 2012 09:32:16 -0500
Message-ID: <D4625EDF-9059-4716-A3B2-CEC8418047F4@redhat.com>
References: <1345735914.25206.8.camel@f16> <20120905114426.1ce3c898@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120905114426.1ce3c898@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Sep 4, 2012, at 8:44 PM, NeilBrown wrote:

> On Thu, 23 Aug 2012 10:31:54 -0500 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> Neil,
>> 
>> There are two ways I see to fix the problem of the "sync" table argument
>> not causing the array to re-sync.  We could set mddev->events to
>> UINT_MAX and force an mddev/bitmap event mismatch - causing the bitmap
>> code to set BITMAP_STALE itself.  Otherwise, we can do as I have below
>> and set BITMAP_STALE ourselves.  The real difference is whether this is
>> done before or after md_run().  The first solution can be done before
>> md_run(); the second cannot because the bitmap is allocated during
>> md_run().  Either solution works and correctly sets the bitmap to stale
>> before bitmap_load() is called.  So, rather than having to think about
>> issues that come with setting events to UINT_MAX, I chose to set the
>> bitmap stale after md_run().
> 
> I'm not at all sure this is the right way to look at the issue.
> 
> The only reason that we have 'sync' and 'nosync' table args is because
> originally we weren't storing any metadata on disk.  The 'in-sync?' state of
> the array is important metadata, so it needed to be given to md via a table
> option.
> 
> If you have a bitmap, then you are storing this information in metadata, so
> including it as a table option is redundant and - as you noticed - ignored.
> 
> If you want to assert that the data in the bitmap is incorrect, then I think
> the best approach is to change it so that it is correct.
> i.e. if you want to assert that an array is not in-sync and should be fully
> 'synced', then the right thing to do is to write lots of '1's to the bitmap
> before trying to assemble the array.
> 
> However I'm not violently against the patch - though I would be against
> fiddling with event_count. It does seem unpleasantly asymmetric though.
> The 'sync' option says 'assume all bits in the bitmap are set', but the
> 'nosync' option doesn't say 'assume all bits in the bitmap are clear'.
> 
> Is simply writing to the bitmap when you want to force some behaviour an
> option, or do you really really want "sync" to mean "please ignore the
> bitmap"?  (or maybe an "ignorebitmap" option is what we want??).

For me, the 'sync' and 'nosync' args are not just a vestige of when we didn't have metadata; but also a form of continuity with dm-raid1.  The 'sync' option has - for device-mapper - always been a way to reset the bitmap and force a resync.

I don't particularly care for forcing userspace to understand how the kernel is handling the metadata (i.e. forcing it to know where and what to write WRT the bitmap).  However, another way of tackling this problem is simply to wipe the metadata areas.  I do not think there is any information that must be carried over from the superblock if our desire is to simply resync.  (Although, there are exceptions to /when/ this action should occur - like not when a reshape is happening.)

Wiping the metadata areas involves a number of additional steps for LVM, but this is not the kernel's problem per se.  Wiping the metadata areas is also the way LVM resyncs dm-raid1 arrays right now, which is a bit strange to me. The only (admittedly weak) arguments for adding this patch is 1) "sync" should work if it is an allowed argument and 2) it seems a better way of clearing the bitmap than wiping all the metadata while allowing for more error checking.

 brassow


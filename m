From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: Write-Intent Bitmaps and disk caches
Date: Tue, 8 Apr 2008 22:44:55 -0400
Message-ID: <170fa0d20804081944i4fcd51eck166bd8b5c2fa3724@mail.gmail.com>
References: <47FBD28B.6060209@nrel.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47FBD28B.6060209@nrel.colostate.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ty! Boyack <ty@nrel.colostate.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 8, 2008 at 4:16 PM, Ty! Boyack <ty@nrel.colostate.edu> wrote:
> I'm a little confused on the write-intent bitmaps and how they interact with
> the disk caches - I would appreciate any clarification here.
>
>  The way I understand it, if a device fails in a raid set, the bitmap will
> track regions that have changed since the failed device left the array.  If
> the device is added back in, the re-sync time is much shorter since only
> some blocks have to be re-sync'ed.
>
>  But in this case it's possible that blocks A, B, and C were written to the
> device, and the failure was detected on block C.  Thus blocks A and B would
> be probably held in the device's cache (hard drive cache, or this problem
> gets worse if working with disk arrays as devices, since they have much
> larger caches).  When the device was re-added, block C would presumably be
> re-synced as requested by the bitmap, but would A and B be lost forever
> because they fell out of the cache on the drive?
>
>  Does the bitmap, or something else, take this into account?  Or will this
> eventually lead to an inconsistent read or data corruption down the road?
> Or am I just out waving my paranoid flag today?

In your example problem both the in-memory bitmap and on-disk bitmaps
would be updated to have the dirty bit associated with block C set.
When the failed member is re-added to the array the block C will get
resynced and the associated dirty bit cleared in all bitmaps.

I'm not seeing why you have concern for blocks A and B; if the writes
completed to all members that means each individual drive marked the
associated block requests uptodate in the block device drivers beneath
Linux MD.

The MD write-intent bitmap doesn't have anything to do with the
hardware cache of each individual raid member.  Blocks A and B
wouldn't get dropped unless you have writeback cache enabled on the
drives (without battery backup) and they suffer a power loss.

Mike

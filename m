From: Andrei Warkentin <awarkentin@vmware.com>
Subject: Re: [RFC] MD: Allow restarting an interrupted incremental recovery.
Date: Mon, 17 Oct 2011 10:26:44 -0700 (PDT)
Message-ID: <992889476.11312.1318872404724.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
References: <20111017142039.5a07b12f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111017142039.5a07b12f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrei Warkentin <andreiw@vmware.com>, linux-raid@vger.kernel.org, "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
List-Id: linux-raid.ids

Hi Neil,

----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
> Cc: "Andrei Warkentin" <andreiw@vmware.com>, linux-raid@vger.kernel.org
> Sent: Sunday, October 16, 2011 11:20:39 PM
> Subject: Re: [RFC] MD: Allow restarting an interrupted incremental recovery.
> 
> On Thu, 13 Oct 2011 21:18:43 -0400 "Andrei E. Warkentin"
> <andrey.warkentin@gmail.com> wrote:
> 
> > 2011/10/12 Andrei Warkentin <andreiw@vmware.com>:
> > > If an incremental recovery was interrupted, a subsequent
> > > re-add will result in a full recovery, even though an
> > > incremental should be possible (seen with raid1).
> > >
> > > Solve this problem by not updating the superblock on the
> > > recovering device until array is not degraded any longer.
> > >
> > > Cc: Neil Brown <neilb@suse.de>
> > > Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
> > 
> > FWIW it appears to me that this idea seems to work well, for the
> > following reasons:
> > 
> > 1) The recovering sb is not touched until the array is not degraded
> > (only for incremental sync).
> > 2) The events_cleared count isn't updated in the active bitmap sb
> > until array is not degraded. This implies that if the incremental
> > was
> > interrupted, recovering_sb->events is NOT less than
> > active_bitmap->events_cleared).
> > 3) The bitmaps (and sb) are updated on all drives at all times as
> > it
> > were before.
> > 
> > How I tested it:
> > 1) Create RAID1 array with bitmap.
> > 2) Degrade array by removing a drive.
> > 3) Write a bunch of data (Gigs...)
> > 4) Re-add removed drive - an incremental recovery is started.
> > 5) Interrupt the incremental.
> > 6) Write some more data.
> > 7) MD5sum the data.
> > 8) Re-add removed drive - and incremental recovery is restarted (I
> > verified it starts at sec 0, just like you mentioned it should be,
> > to
> > avoid consistency issues). Verified that, indeed, only changed
> > blocks
> > (as noted by write-intent) are synced.
> > 10)  Remove other half.
> > 11) MD5sum data - hashes match.
> > 
> > Without this fix, you would of course have to deal with a full
> > resync
> > after the interrupted incremental.
> > 
> > Is there anything you think I'm missing here?
> > 
> > A
> 
> Not much, it looks good, and your testing is of course a good sign.
> 
> My only thought is whether we really need the new InIncremental flag.
> You set it exactly when saved_raid_disk is set, and clear it exactly
> when
> saved_raid_disk is cleared (set to -1).
> So maybe we can just used saved_raid_disk.

You're right, I looked at the code paths again (for non-bitmapped disks), and there is
no reason not to leverage saved_raid_disk. It should be safe (i.e. not missing necessary sb fluesh) 
for non-bitmapped disks - a disk resuming recovery (from rec_offset) will never have In_sync, and raid_saved_disk
will not be set. For multipath this is irrelevant as well.

> If you look at it that way, you might notice that saved_raid_disk is
> also set
> in slot_store, so probably InIncremental should be set there.  So
> that might
> be the one thing you missed.
>

Actually, maybe you can clarify something a bit about that code? The part where
slot != -1 and mddev->pers != NULL looks a lot like the add_new_disk path - except:

After pers->hot_add_disk:
1) rdev In_sync isn't cleared
2) Array isn't checked for degraded state and MD_RECOVERY_RECOVER isn't conditionally set.
3) MD_RECOVERY_NEEDED isn't set.
4) mddev->thread is't woken up.

Is this because if an array was degraded AND there were extra spares, they would already be
assigned to the array?
 
> Could you respin the patch without adding InIncremental, and testing
>   rdev->saved_raid_disk >= 0
> instead, check if you agree that should work, and perform a similar
> test?
> (Is that asking too much?).
> 

Absolutely! Thanks again!

A

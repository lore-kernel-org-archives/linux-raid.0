From: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Subject: Re: [RFC] MD: Allow restarting an interrupted incremental recovery.
Date: Thu, 13 Oct 2011 21:18:43 -0400
Message-ID: <CANz0V+4-qWrc0HfRB5BD8jYFstSmRBr36YwZw5f9t5wwYggYaA@mail.gmail.com>
References: <CANz0V+7ZGKvyznbU_5d2cQm2XL=Wf9B8+HwZZ9KeZSfuawtyOg@mail.gmail.com>
	<1318460733-886-1-git-send-email-andreiw@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1318460733-886-1-git-send-email-andreiw@vmware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Warkentin <andreiw@vmware.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

2011/10/12 Andrei Warkentin <andreiw@vmware.com>:
> If an incremental recovery was interrupted, a subsequent
> re-add will result in a full recovery, even though an
> incremental should be possible (seen with raid1).
>
> Solve this problem by not updating the superblock on the
> recovering device until array is not degraded any longer.
>
> Cc: Neil Brown <neilb@suse.de>
> Signed-off-by: Andrei Warkentin <andreiw@vmware.com>

FWIW it appears to me that this idea seems to work well, for the
following reasons:

1) The recovering sb is not touched until the array is not degraded
(only for incremental sync).
2) The events_cleared count isn't updated in the active bitmap sb
until array is not degraded. This implies that if the incremental was
interrupted, recovering_sb->events is NOT less than
active_bitmap->events_cleared).
3) The bitmaps (and sb) are updated on all drives at all times as it
were before.

How I tested it:
1) Create RAID1 array with bitmap.
2) Degrade array by removing a drive.
3) Write a bunch of data (Gigs...)
4) Re-add removed drive - an incremental recovery is started.
5) Interrupt the incremental.
6) Write some more data.
7) MD5sum the data.
8) Re-add removed drive - and incremental recovery is restarted (I
verified it starts at sec 0, just like you mentioned it should be, to
avoid consistency issues). Verified that, indeed, only changed blocks
(as noted by write-intent) are synced.
10)  Remove other half.
11) MD5sum data - hashes match.

Without this fix, you would of course have to deal with a full resync
after the interrupted incremental.

Is there anything you think I'm missing here?

A

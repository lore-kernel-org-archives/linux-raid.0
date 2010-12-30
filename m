From: Neil Brown <neilb@suse.de>
Subject: Re: New raid level suggestion.
Date: Thu, 30 Dec 2010 21:01:49 +1100
Message-ID: <20101230210149.761fa210@notabene.brown>
References: <20101230082356.GC2986@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101230082356.GC2986@bitwizard.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 30 Dec 2010 09:23:56 +0100 Rogier Wolff <R.E.Wolff@BitWizard.nl>
wrote:

> 
> Hi,
> 
> A friend has a webserver. He has 4 drive bays and due to previous
> problems he's not content to have 3 or 4 drives in a raid5
> configuration, but he wants a "hot spare" so that when it takes him a
> week to find a new drive and some time to drive to the hosting
> company, he isn't susceptible to a second drive crashing in the
> meantime.
> 
> So in principle he'll build a 3-drive RAID5 with a hot spare.... 
> 
> Now we've been told that raid5 performs badly for the workload that is
> expected. It would be much better to run the system in RAID10. However
> if he'd switch to RAID10, after a single drive failure he has a window
> of about a week where he has a 33% chance of a second drive failure
> being "fatal".
> 
> So I was thinking.... He's resigned himself to a configuration where
> he pays for 4x the disk space and only gets 2x the available space.
> 
> So he could run his array in RAID10 mode, however when a drive fails, 
> a fallback to raid5 would be in order. In this case, after the resync 
> a single-drive-failure tolerance is again obtained. 
> 
> In practise scaling down to raid5 is not easy/possible. RAID4 however
> should be doable.
> 
> In fact this can almost be implemented entirely in userspace. Just
> remove the mirror drive from the underlying raid0, and reinitialize as
> raid4. If you do this correctly the data will still be there....
> 
> Although doing this with an active filesystem running on these drives
> is probably impossible due to "device is in use" error messages.... 
> 
> So: Has anybody tried this before?
> Can this be implemented without kernel support?
> Anybody feel like implementing this?
> 
> 	Roger. 
> 

The kernel already supports this, though only with very recent kernels.
I'm not 100% sure about mdadm support, but if it isn't there yet, it probably
will be soon.

You can convert a RAID10 to a RAID0.  You probably have to remove two devices
first, so there are just two working devices - no redundancy.

  mdadm --grow /dev/md0 --level=0

Then you can convert the RAID0 to RAID4

  mdadm --grow /dev/md0 --level=4

Then add the good device back in

  mdadm /dev/md0 --add /dev/sdXX

This should all work, though you should certainly test it before you depend
on it at all.

NeilBrown


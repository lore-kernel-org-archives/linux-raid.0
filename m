From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: wake up personality thread after array state update
Date: Thu, 27 Oct 2016 15:02:35 -0700
Message-ID: <20161027220235.o64c3ei454l2y4xi@kernel.org>
References: <1477408028-3694-1-git-send-email-tomasz.majchrzak@intel.com>
 <20161026191455.wja223ageiwfnqiu@kernel.org>
 <20161027085206.GA11138@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161027085206.GA11138@proton.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

On Thu, Oct 27, 2016 at 10:52:06AM +0200, Tomasz Majchrzak wrote:
> On Wed, Oct 26, 2016 at 12:14:55PM -0700, Shaohua Li wrote:
> > On Tue, Oct 25, 2016 at 05:07:08PM +0200, Tomasz Majchrzak wrote:
> > > When raid1/raid10 array fails to write to one of the drives, the request
> > > is added to bio_end_io_list and finished by personality thread. The
> > > thread doesn't handle it as long as MD_CHANGE_PENDING flag is set. In
> > > case of external metadata this flag is cleared, however the thread is
> > > not woken up. It causes request to be blocked for few seconds (until
> > > another action on the array wakes up the thread) or to get stuck
> > > indefinitely.
> > > 
> > > Wake up personality thread once MD_CHANGE_PENDING has been cleared.
> > > Moving 'restart_array' call after the flag is cleared it not a solution
> > > because in read-write mode the call doesn't wake up the thread.
> > 
> > The patch looks good. However can you elaborate how userspace handles the case?
> > I'd like to understand what the user interface should be to support external
> > metadata array.
> 
> 1. Kernel encounters new bad block that needs to be acknowledged.
> 
> 	sysfs array state == "write-pending" (as MD_CHANGE_PENDING set)
> 	sysfs rdev state == "blocked" (as unacked_exists + external_bbl set)
> 
> 2. mdmon wakes up as there is an update to sysfs array state and unacknowledged
> bad blocks list.
> 
> 3. mdmon checks the state of each disk. If any is 'blocked' and there is a
> support for bad blocks in metadata, it reads unacknowledged bad block list and
> records new bad blocks in metadata. If successful, it acknowledges bad blocks by
> writing to sysfs bad block file. If all bad blocks have been acknowledged, it
> schedules disk unblock.
> 
> As soon as kernel marks all bad blocks as acknowledged, it will clear
> unacked_exists flag.
> 
> 4. mdmon checks 'faulty' flag for each disk. If it is set, the disk is removed
> from array and unblock is scheduled.
> 
> 5. mdmon requests to unblock the array by writing '-blocked' to sysfs disk
> state.
> 
> Requests awaiting for bad block confirmation are woken up in kernel.

Why this step? 3 step writes bad block file, which already wakeup threads
waiting for bad block confirmation.

> 6. mdmon writes 'active' to sysfs array state.
> 
> MD_CHANGE_PENDING flag is cleared by this step but personality thread is not
> woken up. The patch resolves this problem.
> 
> I hope it answers your question.

This is clear, thanks! I applied this patch.

Thanks,
Shaohua

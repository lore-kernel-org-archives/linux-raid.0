From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] MD:  Do not increment resync_mismatches unless MD_RECOVERY_REQUESTED
Date: Mon, 22 Apr 2013 11:26:16 -0500
Message-ID: <2BD5F32D-4C11-4DA6-A38B-DFA030D78489@redhat.com>
References: <1366402161.18514.1.camel@f16> <20130422103626.4cdcefae@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130422103626.4cdcefae@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Apr 21, 2013, at 7:36 PM, NeilBrown wrote:

> On Fri, 19 Apr 2013 15:09:21 -0500 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> MD:  Do not increment resync_mismatches unless MD_RECOVERY_REQUESTED
>> 
>> resync_mismatches is used to display the number of differences that
>> have been found or repaired during a scrubbing operation.  It is not
>> meant to count anything during resync or repair operations.  (How
>> much sense does it make to find resync_mismatches populated after an
>> initial synchronization of the array?  After cleaning-up an unclean
>> shutdown?  After [re]integrating a device into an existing array?)
>> The incrementing of the variable must be restricted to when the user
>> initiates a scrubbing operation (i.e. "check" or "repair").
> 
> How do you know what it is "meant" to do? :-)

Yes, I suppose I did infer the meaning, but I don't think it's too much of a stretch - especially given the commit message where 'resync_mismatches' was introduced.
commit 9d88883e68f404d5581bd391713ceef470ea53a9
Author: NeilBrown <neilb@suse.de>
Date:   Tue Nov 8 21:39:26 2005 -0800

    [PATCH] md: teach raid5 the difference between 'check' and 'repair'.
    
    With this, raid5 can be asked to check parity without repairing it.  It also
    keeps a count of the number of incorrect parity blocks found (mismatches) an
    reports them through sysfs.
    
    Signed-off-by: Neil Brown <neilb@suse.de>
    Cc: Greg KH <greg@kroah.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Also, it seems that 'mismatches' is only ever talked about in reference to scrubbing operations.  (Although it does say in 'man 4 md', "This  is  set to zero when a scrub starts and is incremented whenever a sector is found that is a mismatch.", which could imply that 'mismatches' might be non-zero before a scrub operation starts.)  There is no indication anywhere that I can find what it would mean to have a non-zero 'mismatches' absent a scrub operation - perhaps we just assume "uninitialized".

However, if it has come to mean something more since then or provides any sort of useful information, then I can see your point.  I find the behavior to be problematic.  A user creates an array and sometimes the value is non-zero - that could be alarming, causing the user to think the array needs immediate "repair".

Anyway, I suppose I am simply bloviating if your mind is made up.  I can make due with the idea below of recording the "last_sync_action".  I'm thinking of recording the MD_RECOVERY_* flags that would define the type of sync_action - would you rather have a 'char *'?  If we kept the flags, I wonder if we could also use that to define acceptable sync_action transitions...  We don't, for example, particularly want "resync" -> "idle" -> "check" -> "idle" -> "resync" - especially if checkpoints are being made throughout.

> While it might not be particularly useful, I see no point in hiding
> information, and no desire to change what mismatch_cnt reports.
> 
> It may well be useful to somehow report what the real meaning for
> mismatch_cnt is.  i.e. to report what the last sync_action was.
> Then any use-space tool that reported mismatch_cnt, could adjust according to
> whether the last operation was check/repair or resync/recovery/reshape. etc.
> 
> So if you were to provide a patch which adds "last_sync_action" or similar,
> I'd certainly consider that.

 brassow
From: Neil Brown <neilb@suse.de>
Subject: Re: 3-way mirrors
Date: Wed, 8 Sep 2010 08:01:55 +1000
Message-ID: <20100908080155.2ed9300e@notabene>
References: <20100907141904.3696.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100907141904.3696.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7 Sep 2010 10:19:04 -0400
"George Spelvin" <linux@horizon.com> wrote:

> After some frustration with RAID-5 finding mismatches and not being
> able to figure out which drive has the problem, I'm setting up a rather
> intricate 5-way mirrored (x 2-way striped) system.
> 
> The intention is that 3 copies will be on line at any time (dropping to
> 2 in case of disk failure), while copies 4 and 5 will be kept off-site.
> Occasionally one will come in, be re-synced, and then removed again.
> (The file system can be quiesced briefly to permit a clean split.)
> 
> Anyway, one nice property of a 2-drive redundancy (3+-way mirror or
> RAID-6) is error detection: in case of a mismatch, it's possible to
> finger the offending drive.
> 
> My understanding of the current code is that it just copies one mirror
> (the first readable?) to the others.  Does someone have a patch to vote
> on the data?  If not, can someone point me at the relevant bit of code
> and orient me enough that I can create it?
> 

The relevant bit of code is in the MD_RECOVERY_REQUESTED branch of
sync_request_write() in drivers/md/raid1.c
Look for "memcmp".

This code runs when you "echo repair > /sys/block/mdXXX/md/sync_action

It has already read all blocks and now compares them to see if they are the
same.  If not it copies the first to any that are different.

You possibly want to factor out that code into a separate function before
tryin to add any 'voting' code.


> (The other thing I'd love is a more advanced sync_action that can accept a
> block number found by "check" as a parameter to "repair" so I don't have
> to wait while the array is re-scanned.  Um... I suppose this depends on
> a local patch I have that logs the sector numbers of mismatches.)

This is already possible via the sync_min and sync_max sysfs files.
Write a number of sectors to sync_max and a lower number to sync_min.
Then write 'repair' to 'sync_action'.
When sync_completed reaches sync_max, the repair will pause.
You can then let it continue by writing a larger number to sync_max, or tell
it to finish by writing 'idle' to 'sync_action'.

If you have patches that you think are generally useful, feel free to submit
them to me for consideration for upstream inclusion.


> 
> 
> Another thing I'm a bit worried about is the kernel's tendency to
> add drives in the lowest-numbered open slot in a RAID.  When used in
> multiply-mirrored RAID-10, this tends to fill up the first stripe hallf
> before starting on the second.

This is controlled by raid10_add_disk in drivers/md/raid10.c.  I would
happily accept a patch which made a more balanced choice about where to add
the new disk.

> 
> I'm worried that someone not paying attention will --add rather than
> --re-add the off-site backup drives and create mirrors 4 and 5 of
> the first stripe half, thus producing an incomplete backup.

It is already on my to-do list for mdadm-3.2 to reject a --add that looks
like it should be a --re-add.  You will need --force to make it a spare, or
--zero it first.


> 
> Any suggestions on how to mitigate this risk?  And if it happens,
> how do I recover?  Is there a way to force a drive to be added
> as 9/10, even if 5/10 is currently empty?

1/ hack at mdadm or wait for mdadm-3.2, or feed people more coffee:-)
2/ You probably cannot recover with any amount of certainty.
3/ That is entirely a kernel decision - 'fix' the kernel.

NeilBrown


> 
> 
> Thank you very much!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


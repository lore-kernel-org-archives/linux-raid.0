From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Sat, 04 Jan 2014 21:32:19 -0500
Message-ID: <52C8C433.5030403@turmel.org>
References: <1388829881.16265.20.camel@vessel> <52C835C9.3050707@turmel.org> <1388873143.7641.20.camel@vessel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1388873143.7641.20.camel@vessel>
Sender: linux-raid-owner@vger.kernel.org
To: Fabian Knorr <knorrfab@fim.uni-passau.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/04/2014 05:05 PM, Fabian Knorr wrote:
> Hi, Phil,
> 
> thank you very much for your reply.
> 
>> Side note: If you have a live spare available for a raid5, there's no
>> good reason not to reshape to a raid6, and very good reasons to do so.
> 
> I was worried that RAID6 would incur a significant load on the CPU,
> especially if one disk fails. The system is a single-core Intel Atom.

It does add more load, especially when degraded.  I guess it depends on
your usage pattern.  I would try it before I gave up on the idea.

>> Device names are not guaranteed to remain identical from one boot to
>> another.  And often won't be if a removable device is plugged in at that
>> time.  The linux MD driver keeps identity data in the superblock that
>> makes the actual device names immaterial.
>>
>> It is really important that we get a "map" of device names to drive
>> serial numbers, and adjust all future operations to ensure we are
>> working with the correct names.  An excerpt from "ls -l
>> /dev/disk/by-id/" would do.  And you need to verify it after every boot
>> until this crisis is resolved.
> 
> See the attachment "partitions". I grep'ed for raid partitions.
> 
>> 1) raid.status appears to be from *after* your --add attempts.  That
>> means anything in those reports from those devices is useless.  So we
>> will have to figure out what that data was.
> 
> Could it be that --add only changed the superblock of one disk,
> namely /dev/sdb in file from my first e-mail?

/dev/sda actually.

>> 2) You attempted to recreate the array.  If you left out
>> "--assume-clean", your data is toast.  Please show the precise command
>> line you used in your re-create attempt.  Also generate a fresh
>> "raid.status" for the current situation.
> 
> The only commands I used were --add /dev/sdb, --run, --assemble --scan,
> --assemble --scan --force and --stop. I didn't try to re-create it, at
> least not now. Also, the timestamp from raid.status (2011) is incorrect,
> the array was re-created from scratch in the summer of 2012. I can't
> tell why disks other than /dev/sdb1 have an invalid superblock.

This is very good news.  In fact, I think --assemble --force can still
be made to work....

>> 3) The array seems to think it's member devices were /dev/sda through
>> /dev/sdh (not in that order).  Your "raid.status" has /dev/sd[abcefghi],
>> suggesting a rescue usb or some such is /dev/sdd. 
> 
> Yes, that's correct.

Very good.

>> 4) Please describe the structure of the *content* of the array, so we
>> can suggest strategies to *safely* recognize when our future attempts to
>> --create --assume-clean have succeeded.  LVM?  Partitioned?  One big
>> filesystem?
> 
> I'm using the array as a physical volume for LVM.

Ok.

Try this:

mdadm --stop /dev/md0

mdadm -Afv /dev/md0 /dev/sd[bcefghi]1

It leaves out /dev/sda, which appears to have been the spare in the
original setup.

If MD is happy after that, use fsck -n on your logical volumes to verify
your FS integrity, and/or see the extent of the damage (little or none,
I think).

If that works, you can --add /dev/sda1 again, and it will become the
spare again.

If it doesn't work, show everything printed by "mdadm -Afv" above.

HTH,

Phil

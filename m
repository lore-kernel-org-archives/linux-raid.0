From: Phil Turmel <philip@turmel.org>
Subject: Re: recovering RAID5 from multiple disk failures
Date: Sat, 02 Feb 2013 08:44:46 -0500
Message-ID: <510D184E.4070106@turmel.org>
References: <kegcd6$6dl$1@ger.gmane.org> <510BC173.7070002@turmel.org> <kej2t8$vk8$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kej2t8$vk8$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Ritzert <ksciplot@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/2013 08:04 AM, Michael Ritzert wrote:
> Hi Phil,
> 
> In article <510BC173.7070002@turmel.org> you wrote:
>>> So the situation is: I have a four-disk RAID5 with two active disks, and
>>> two that dropped out at different times.
>>
>> Please show the errors from dmesg.
> 
> I don't think I can provide that. The RAID ran in a QNAP system, and if
> there is a log at all, it's on this disk...
> During the copy process, it was all media errors, however.
> 
>> And show "smartctl -x" for the drives that failed.
> 
> See below.
> 
> [...]
>> Also show "mdadm -E" for all of the member devices.  This data is an
>> absolute *must* before any major surgery on an array.
> 
> also below.
> 
>>> My first attempt would be to try
>>> mdadm --create --metadata=0.9 --chunk=64 --assume-clean, etc.
>>>
>>> Is there a chance for this to succeed? Or do you have better suggestions?
>>
>> "--create" is a *terrible* first step.  "mdadm --assemble --force" is
>> the right tool for this job.
> 
> I forgot to mention: I tried that, and stopped it, after I saw the first
> thing it did was to start a rebuild of the array. I couldn't figure out
> which disk it was trying to rebuild, but whichever of the two dropped out
> disks it was, I can't see how it could reconstruct the data once it reaches
> the point of the errors on the disk it uses in the reconstruction.
> (So "first" above should really say more verbose "first after the new copies
> are finished".)

Ok.

> mdadm --assemble --assume-clean sounded like the most logical combination of
> options, but was rejected.

Now it is appropriate, but I'm concerned about mapping drives to device
names in your setup (plugging and unplugging to get these reports?).
Please map drive serial numbers to device names with all drives plugged
in.  "lsdrv"[1] or an extract from /dev/disk/by-id/.

> Unfortunately, the data on the disk is not simply a filesystem where bad
> blocks mean a few unreadable files, but a filesystem with a number of files
> on it that represent a volume exported by iSCSI, on which there is an
> encrypted partition with a filesystem. So I'm not too sure, if any of these
> indirections badly multiplies the effect of a single bad sector, and I'm
> trying to reach 100% good, if possible.

Ugly.  Yes, there's a bit of multiplication.  Not sure how to quantify it.

>>> If all recovery that involves assembling the array fails: Is is possible
>>> to manually assemble the data?
>>> I'm thinking in the direction of: take the first 64k from disk1, then 64k
>>> from disk2, etc.? This would probably take years to complete, but the data
>>> is of really big importance to me (which is why I put it on a RAID in the
>>> first place...).
>>
>> Your scenario sounds like the common timeout mismatch catastrophe, which
>> is why I asked for "smartctl -x".  If that is the case, MD won't be able
>> to do the reconstructions that it should when encounting read errors.
> 
> You mean the "timeout of the disk is longer than RAID's patience" problem?
> I have no idea, if the old disks suffered from it, I used Samsung HD204UI
> which were certified by QNAP. The copies are now WD NAS edition disks,
> which have a lower timeout.

I've never heard it called a "patience" problem, but that's apt.  Your
drives are raid-capable, but they aren't safe out of the box.  From your
smartctl reports:

> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled

You *must* issue "smartctl -l scterc,70,70 /dev/sdX" for each of these
drives *every* time they are powered on.  Based on the event counts in
your superblocks, I'd say disk1 was kicked out long ago due to a normal
URE (hundreds of hours ago) and the array has been degraded ever since.
 Totally useless way to run a raid.  When you started your urgent backup
effort, you found more UREs, in a time/quantity combination that kicked
out another (disk3).

> Recently, I also started copying all data to Amazon Glacier, for 100%-epsilon
> reliable storage, but this upload simply took longer than the disks lasted
> (=less than 30 days spinning! very disappointing).

All of your drives are in perfect condition (no relocations at all).
Meaning that all of your troubles are due to timeout mismatch, lack of
scrubbing (or timeout error on the first scrub), and lack of backups.
Aim your disappointment elsewhere.

"mdadm --create .... missing /dev/sd[XYZ]" is your next step (leaving
out disk1) after you fix your drive timeouts.  Match parameters exactly,
of course.  Then add disk1 and let it rebuild.  If that doesn't succeed,
you will need to use dd_rescue on disks 2-4 to clean up their remaining
UREs, then repeat the "--create ... missing".

You won't achieve 100% good, as the URE locations on disk 2-4 cannot be
recovered from disk1 (too old, almost certainly).

I'll be offline for several hours.  Good luck (or ask for more help from
others).

Phil

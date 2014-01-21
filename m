From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Manually reconstruct a RAID10 from adaptec 3805
Date: Tue, 21 Jan 2014 17:14:14 -0600
Message-ID: <52DEFF46.1040606@hardwarefreak.com>
References: <CAE6VuKFnEjPsq=aeQXU4Jfn_3kD1TE19gRGk3YGdUXGTdgN+xg@mail.gmail.com>	<52DE1EA0.8060403@hardwarefreak.com> <CAE6VuKExccbVz4xdGKAX7G5RtWOq-FtMy6xLvfSaMAjJBBHGZg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE6VuKExccbVz4xdGKAX7G5RtWOq-FtMy6xLvfSaMAjJBBHGZg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Raul Dias <raul@dias.com.br>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Omitted list CC on reply.

On 1/21/2014 1:47 AM, Raul Dias wrote:
> Unfortunally, I dont have physical access to the machine.
> 
> The controller was substituted from 3805 to 5805.
> However, the following message were generated:

Did the controller swap *cause* the problem?  Or did the tech swap the
controllers in an attempt to solve the problem?

> """
> Two independent halves of same logical device present.
> Turn off system, remove disk(s) constitute one of this halves and try again.
> """
> 
> No much info googling for this message (or sense).
> As a RAID 10, of course there are 2 halves.
> 
> Under this warning, is it safe to force it to be online?

You probably can't because the 5805 apparently doesn't yet know the RAID
configuration of your disks.

Making an educated guess here, your 3805 died.  The tech grabbed a 5805,
who knows from where, maybe new, maybe used, and just slapped it in the
machine, buttoned it up, and turned it back on.

When you swap controllers like this, you must clear any RAID
configuration stored in the replacement card's onboard flash, then tell
the card BIOS to scan all attached drives for a configuration.  All
drives in your array have a copy of the RAID metadata at the end of the
drives.  The controller will find this metadata and present the
configuration to you.  If that process works correctly, you simply save
that config to flash.  Your array should be functional again.

Read the Adaptec documentation.

> I have the feelling that the host technician who performanced the
> controller switch, might have switched the disk cable order too.

This issue was solved over 15 years ago when metadata was added to the
drives.  Cable connection, backplane slot order-- none of these make a
difference.  If the controller finds the metadata, it then knows each
drive's physical and logical position in the array.

> If so, would that explain the message/warning?
> Is the array bond to the disk cable connection (instead of an internal
> label, like fstab e.g.)?
> 
> So, I guess the best course would be to make images and try to
> reconstruct (unstrip) the partition.

No.  The best course of action is to call Adaptec Support.  Tell them
exactly what has happened, and they should be able to walk you through
this to get the RAID10 array up and running again.

If the situation is what it seems to be, again, simply clearing the
flash configuration on the 5805 and reading the metadata from the disks
should fix your problem.  Unless of course you have a bad backplane, and
the original 3805 wasn't actually bad.  Cross that bridge when you get
there.

> I probably can eliminate the mirror part of the array, but still 4
> disks to guess the stripping order to reorganize.

You're attacking this from the wrong angle.  You're trying to work
around the vendor RAID card instead of working within it.  Work within
it and you should be back up in no time.

Swapping controllers is a common situation and should be a seamless
process.  This is precisely why all the RAID card vendors added metadata
to the drives.  Swap cards, read metadata, reboot, go.  Back in the
medieval days of RAID cards one had to recreate the configuration by
hand in the card BIOS, using notes taken when the array was originally
created.  What if you're the 3rd guy and the 1st guy's notes are gone?
Metadata.


> 2014/1/21 Stan Hoeppner <stan@hardwarefreak.com>:
>> On 1/20/2014 2:01 PM, Raul Dias wrote:
>>> Hello,
>>>
>>> I have a failled RAID 10 in a remote server.  The controller show all
>>> drives as "offline"
>>> In order to recover it, I will try to reconstruct the fs from disk images.
>>>
>>> Does anyone have a clue on how adaptec layouts its raid10 disks?
>>>
>>> So far, all information I have is this:
>>> http://www.unixwiz.net/techtips/recovering-failed-raid.html
>>>
>>> However, it is from 2008 and a raid1 only.
>>> Can anyone point me in the right direction?
>>
>> Apparently you've performed many additional troubleshooting steps but
>> omitted them here.  The path you suggest is only taken when a RAID
>> controller has failed and a same brand replacement unit is not possible.
>>
>> Simply having all drives kicked offline doesn't mean the controller has
>> failed.  Usually it means all drives lost power, or there is a problem
>> with the backplane.
>>
>> Please describe what happened before the drives went offline.  Did the
>> server crash?  Lose power?  Or did all 4,6,8 drives mysteriously just go
>> offline?  How many drives in this RAID10 array?
>>
>> The first thing you should do in such a circumstance is boot the machine
>> and enter the RAID BIOS, then manually force all the drives online, then
>> perform a health check (whatever Adaptec calls this) of the array.  If
>> everything passes, boot up the machine.
>>
>> If any or all of the drives are booted offline again, you need to
>> inspect the hardware, specifically the power feed to the backplane, the
>> backplane itself, and the PSU.
>>
>> Trying to manually reconstruct the data from the drives is an absolute
>> last resort, when the controller is verified to have failed, and a
>> replacement isn't available.
>>
>> --
>> Stan
>>

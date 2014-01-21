From: Raul Dias <raul@dias.com.br>
Subject: Re: Manually reconstruct a RAID10 from adaptec 3805
Date: Tue, 21 Jan 2014 06:29:39 -0200
Message-ID: <CAE6VuKFYmbou2nPaVQE-xa3uq=QHznT0VvOEDrmA6PeU8ghOxQ@mail.gmail.com>
References: <CAE6VuKFnEjPsq=aeQXU4Jfn_3kD1TE19gRGk3YGdUXGTdgN+xg@mail.gmail.com>
	<52DE1EA0.8060403@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52DE1EA0.8060403@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Unfortunally, I dont have physical access to the machine.

The controller was substituted from 3805 to 5805.
However, the following message were generated:

"""
Two independent halves of same logical device present.
Turn off system, remove disk(s) constitute one of this halves and try again.
"""

No much info googling for this message (or sense).
As a RAID 10, of course there are 2 halves.

Under this warning, is it safe to force it to be online?

I have the feelling that the host technician who performanced the
controller switch, might have switched the disk cable order too.
If so, would that explain the message/warning?
Is the array bond to the disk cable connection (instead of an internal
label, like fstab e.g.)?

So, I guess the best course would be to make images and try to
reconstruct (unstrip) the partition.

I probably can eliminate the mirror part of the array, but still 4
disks to guess the stripping order to reorganize.

2014/1/21 Stan Hoeppner <stan@hardwarefreak.com>:
> On 1/20/2014 2:01 PM, Raul Dias wrote:
>> Hello,
>>
>> I have a failled RAID 10 in a remote server.  The controller show all
>> drives as "offline"
>> In order to recover it, I will try to reconstruct the fs from disk images.
>>
>> Does anyone have a clue on how adaptec layouts its raid10 disks?
>>
>> So far, all information I have is this:
>> http://www.unixwiz.net/techtips/recovering-failed-raid.html
>>
>> However, it is from 2008 and a raid1 only.
>> Can anyone point me in the right direction?
>
> Apparently you've performed many additional troubleshooting steps but
> omitted them here.  The path you suggest is only taken when a RAID
> controller has failed and a same brand replacement unit is not possible.
>
> Simply having all drives kicked offline doesn't mean the controller has
> failed.  Usually it means all drives lost power, or there is a problem
> with the backplane.
>
> Please describe what happened before the drives went offline.  Did the
> server crash?  Lose power?  Or did all 4,6,8 drives mysteriously just go
> offline?  How many drives in this RAID10 array?
>
> The first thing you should do in such a circumstance is boot the machine
> and enter the RAID BIOS, then manually force all the drives online, then
> perform a health check (whatever Adaptec calls this) of the array.  If
> everything passes, boot up the machine.
>
> If any or all of the drives are booted offline again, you need to
> inspect the hardware, specifically the power feed to the backplane, the
> backplane itself, and the PSU.
>
> Trying to manually reconstruct the data from the drives is an absolute
> last resort, when the controller is verified to have failed, and a
> replacement isn't available.
>
> --
> Stan
>

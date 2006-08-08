From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: modifying degraded raid 1 then re-adding other members is bad
Date: Tue, 08 Aug 2006 15:19:08 +0400
Message-ID: <44D8732C.2060207@tls.msk.ru>
References: <or8xlztvn8.fsf@redhat.com> <17624.29070.246605.213021@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17624.29070.246605.213021@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Alexandre Oliva <aoliva@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday August 8, aoliva@redhat.com wrote:
>> Assume I have a fully-functional raid 1 between two disks, one
>> hot-pluggable and the other fixed.
>>
>> If I unplug the hot-pluggable disk and reboot, the array will come up
>> degraded, as intended.
>>
>> If I then modify a lot of the data in the raid device (say it's my
>> root fs and I'm running daily Fedora development updates :-), which
>> modifies only the fixed disk, and then plug the hot-pluggable disk in
>> and re-add its members, it appears that it comes up without resyncing
>> and, well, major filesystem corruption ensues.
>>
>> Is this a known issue, or should I try to gather more info about it?
> 
> Looks a lot like
>    http://bugzilla.kernel.org/show_bug.cgi?id=6965
> 
> Attached are two patches.  One against -mm and one against -linus.
> 
> They are below.
> 
> Please confirm if the appropriate one help.
> 
> NeilBrown
> 
> (-mm)
> 
> Avoid backward event updates in md superblock when degraded.
> 
> If we
>   - shut down a clean array,
>   - restart with one (or more) drive(s) missing
>   - make some changes
>   - pause, so that they array gets marked 'clean',
> the event count on the superblock of included drives
> will be the same as that of the removed drives.
> So adding the removed drive back in will cause it
> to be included with no resync.
> 
> To avoid this, we only update the eventcount backwards when the array
> is not degraded.  In this case there can (should) be no non-connected
> drives that we can get confused with, and this is the particular case
> where updating-backwards is valuable.

Why we're updating it BACKWARD in the first place?

Also, why, when we adding something to the array, the event counter is
checked -- should it resync regardless?

Thanks.

/mjt

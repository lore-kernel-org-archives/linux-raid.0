From: David Brown <david.brown@hesbynett.no>
Subject: Re: Direct disk access on IBM Server
Date: Sat, 23 Apr 2011 16:42:27 +0200
Message-ID: <iouogj$h43$1@dough.gmane.org>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com> <iomfkq$qqr$1@dough.gmane.org> <4DAEC627.3030904@grumpydevil.homelinux.org> <iomj0a$e5m$1@dough.gmane.org> <4DAFCDB0.9070609@hardwarefreak.com> <iop4s2$cjp$1@dough.gmane.org> <BANLkTi=CLD=Cd0Ngj1hXqQtz3Cb6ir4yRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=CLD=Cd0Ngj1hXqQtz3Cb6ir4yRg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/04/11 16:05, Majed B. wrote:
> Hello,
>
> I've setup a bunch of software RAID boxes and I've had my main one
> running at a friend's place with about 16 disks and 9TB of data.
>
> One time 2 disks had bad sectors and things took a bad turn. It was a
> RAID5 array, so I had to salvage everything I could rather than losing
> everything we had there (no backups). It took me about 3 weeks of
> working daily for about 6 hours a day in cloning disks, recovering
> files and validating checksums. It was not fun at all.
>

There's good reason for recommending raid6 for such large arrays!

I really hope Neil (or someone else) gets the chance to implement the 
features in the md roadmap - once md supports bad block lists, bad 
blocks on a disk will no longer mean the whole disk is removed.  So in 
situations like yours, unless you have bad sectors at the same place on 
two drives, all your data will be intact - and the huge majority will 
still be redundant, giving you time to do a simple disk replacement.

> If you have critical data, I'd suggest you add a battery and an
> sd-card/flash card to your hardware RAID array. At least if the power
> goes off, whatever is in the cache will be written to the card and
> later on to the disks when power is restored.
>
> A UPS will not help you if your power supply decides to commit seppuku.
>

That's true, of course.  But protecting data is always a matter of 
minimising the risks and consequences of the more likely failures.  My 
power supply /could/ fail, but I don't see it as a likely case.  With a 
good UPS and some redundancy in the disks, by far the most likely cause 
of failure is human error (someone deleting the wrong file, for 
instance).  Still, I will be checking the price of a backup battery for 
the server.

> If you keep daily backups, or any form of backups, go ahead with
> software RAID and keep yourself free from vendor lock.
>

I do have daily backups - raid doesn't prevent /all/ data loss!

mvh.,

David


> Regards,
>
> On Thu, Apr 21, 2011 at 2:36 PM, David Brown<david.brown@hesbynett.no>  wrote:
>> On 21/04/11 08:24, Stan Hoeppner wrote:
>>>
>>> David Brown put forth on 4/20/2011 7:21 AM:
>>>
>>>> It's true that boot loaders and software raid can be an awkward
>>>> combination.
>>>
>>> ...
>>>>
>>>> Yes, it's a few extra steps.



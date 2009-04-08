From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Recreate raid 10 array
Date: Wed, 08 Apr 2009 17:47:51 -0400
Message-ID: <49DD1B87.2050804@tmr.com>
References: <49DA5CE6.7030902@gmx.net> <87prfpdm8y.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87prfpdm8y.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: LCID Fire <lcid-fire@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> LCID Fire <lcid-fire@gmx.net> writes:
>
>   
>> On my raid10 array (4 drives) I've had 2 drives (the same model) which
>> got disconnected by the kernel (almost at the same time). It seems
>> like both were one raid1 part so one half of the raid0 is missing.
>> Afterwards I tried to readd the drives again (my bad) so now I'm stuck
>> with 1 half of the raid0 part being present and valid and the other (2
>> drives) marked as spare.
>> The thing I'd like to do is:
>> - Take 2 new drives (different manufacturers)
>> - Clone one of the valid and one of the spare drives to the new drives
>> - Try to reassemble the array.
>> Problem is - is this even possible?
>> How do I tell mdadm to not care about the spare state?
>> Does the kernel write bogus data to the still valid drives if the
>> other 2 fail?
>>
>> Would be great if someone could enlighten me ;)
>>
>> P.S.: Does someone know how to easily report the different sata errors
>> which the kernel encounters?
>>     
>
> mdadm --create --assume-clean -l 10 -n 4 /dev/mdX /dev/copied_disk_1 /dev/copied_disk2 missing missing
>
> You need to match the create parameters exactly with the ones you
> initially used (near/offset/farcopies? stripe size? ...) and the order
> of devices is relevant so you might have to shuffle the disk
> arguments. So just try different orders till the result can be mounted
> or fscked. With the wrong options the mount/fsck could screw up the
> data but then you copy the disk again for the next try. It should be
> reasonably obvious when mount/fsck goes wrong as it should find tons
> of errors. Mostly I would expect mount/fsck to just fail with the
> wrong mdadm args though.
>   

May I say that this makes a great case for saving the contents of some 
files to a safe place when the system is up and running right.? Maybe 
all of /etc, and at least a "tree /sys" and /proc/mdstat would be 
useful, preferably on something readable like a CD or USB flash drive, 
so you have a chance of reading it if you can't boot.

Of course a rescue flash drive is pretty useful as well, so that's 
probably the way to go.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.



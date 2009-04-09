From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Recreate raid 10 array
Date: Thu, 09 Apr 2009 18:38:20 -0400
Message-ID: <49DE78DC.8080700@tmr.com>
References: <49DA5CE6.7030902@gmx.net> <87prfpdm8y.fsf@frosties.localdomain>	 <49DD1B87.2050804@tmr.com> <1239227842.18515.8.camel@cichlid.com> <49DD21C6.4060200@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49DD21C6.4060200@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: LCID Fire <lcid-fire@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

LCID Fire wrote:
> First off the good news: I'm currently running on my raid10 again - 
> with only little data loss.
>
> Andrew Burgess wrote:
>> On Wed, 2009-04-08 at 17:47 -0400, Bill Davidsen wrote:
>>> Goswin von Brederlow wrote:
>>>> mdadm --create --assume-clean -l 10 -n 4 /dev/mdX 
>>>> /dev/copied_disk_1 /dev/copied_disk2 missing missing
>>>>
>>>> You need to match the create parameters exactly with the ones you
>>>> initially used (near/offset/farcopies? stripe size? ...) and the order
>>>> of devices is relevant so you might have to shuffle the disk
>>>> arguments. So just try different orders till the result can be mounted
>>>> or fscked. With the wrong options the mount/fsck could screw up the
>>>> data but then you copy the disk again for the next try. It should be
>>>> reasonably obvious when mount/fsck goes wrong as it should find tons
>>>> of errors. Mostly I would expect mount/fsck to just fail with the
>>>> wrong mdadm args though.
>>
>> Most fscks can be told to run read-only so they won't write to the
>> device and also interactive so they ask before writing so you should be
>> able to avoid recopying. The ext3 journal recovery violates at least one
>> of these IIRC (or used to) so if it's ext3 find an option to tell it to
>> ignore the journal.
> Too late. The journal recovery did complain quite a bit and I didn't 
> know better than to have it fix the things it liked to fix.
> As a result it shows the problem with many apps using sqlite these 
> days - it's not very good when the database file is corrupted.
>
>>> May I say that this makes a great case for saving the contents of 
>>> some files to a safe place when the system is up and running right.? 
>>> Maybe all of /etc, and at least a "tree /sys" and /proc/mdstat would 
>>> be useful, preferably on something readable like a CD or USB flash 
>>> drive, so you have a chance of reading it if you can't boot.
>>>
>>> Of course a rescue flash drive is pretty useful as well, so that's 
>>> probably the way to go.
> Quite frankly I don't really care about / - as long as my /home is 
> safe - because I can setup my machine again - but losing my work means 
> losing far more time.
>
>> It also seems like mdadm could be enhanced to figure stuff like this out
>> given intact device superblocks (I suggest --wild-ass-guess as the
>> option name)
> That would be great (not that I'm eager to run into that again).
>
> As a note I did a binary comparison between the raid1 stuff and got 
> quite shocked. The corrupted one had around 1.000.000 byte difference 
> - something I would expect - but even the valid mirror had around 
> 20.0000 bytes difference - which I can't explain to myself this easily.

My personal explanation for mismatch on raid1 swap is this: because 
software raid isn't real raid, you don't get a mirror by writing the 
same page once only to two different drives by sending the data to the 
controller and letting that happen. What you get is the kernel sending 
the same page to two drives without locking the page so it can't change 
as it's being written. That's a gross over-simplification, but I think 
it addresses the heart of the matter. To prevent that would require a 
flag which causes COW until the page had been moved to the controller 
for the last time.

The alternate I've seen proposed is that somewhere between writing 
copies the page is deallocated so the second (or Nth for more than two 
way mirror) write is abandoned.

In any case this appears to be because the page in memory changes 
between write and/or not all writes are mirrored.

The interesting thing is that some systems seem to have lots of 
mishatches and some almost always none.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.



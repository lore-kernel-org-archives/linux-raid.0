From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: replacing drives
Date: Wed, 08 May 2013 16:19:33 +0200
Message-ID: <518A5EF5.5090808@supsi.ch>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk> <5183E592.6020409@supsi.ch> <20130507075340.GA25772@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130507075340.GA25772@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin Hill wrote:
> On Fri May 03, 2013 at 06:28:02PM +0200, Roberto Nunnari wrote:
> 
>> Robin Hill wrote:
>>> The safest option would be:
>>>  - add in the new disks
>>>  - partition to at least the same size as your existing partitions (they
>>>    can be larger)
>>>  - add the new partitions into the arrays (they'll go in as spares)
>>>  - grow the arrays to 4 members (this avoids any loss of redundancy)
>>>  - wait for the resync to complete
>>>  - install grub/lilo/syslinux to the new disks
>>>  - fail and remove the old disk partitions from the arrays
>>>  - shrink the arrays back down to 2 members
>>>  - remove the old disks
>>>
>>> Then, if you're keeping the same number of partitions but increasing the
>>> size:
>> Ok.. got here.
>>
>>>  - grow the arrays to fill the partitions
>>>  - grow the filesystems to fill the arrays
>> Now the scary part.. so.. here I believe I should give the following 
>> commands:
>>
>> mdadm --grow /dev/md0 --size=max
>> mdadm --grow /dev/md1 --size=max
>> mdadm --grow /dev/md2 --size=max
>>
> Yep, that's right. Make sure they've actually grown to the correct size
> before you progress though - I have had one occasion where using
> --size=max actually ended up shrinking the array and I had to manually
> work out the size to use in order to recover. That was using an older
> version of mdadm though, and I've not seen it happen since.
> 
>> and after that
>>
>> fsck /dev/md0
>> fsck /dev/md1
>> fsck /dev/md2
>>
> You'll need 'fsck -f' here to force it to run.

humm.. as /dev/md0 is mounted on / I probably should boot from a cd, and 
run fsck and resize2fs from there.. maybe using UUIDs, right?


> 
>> and
>>
>> resize2fs /dev/md0
>> resize2fs /dev/md1
>> resize2fs /dev/md2
>>
>> Correct?
>>
> That should be it, yes.

Thank you.
Robi

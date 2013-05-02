From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: replacing drives
Date: Thu, 02 May 2013 17:00:42 +0200
Message-ID: <51827F9A.6080408@supsi.ch>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk> <518270A6.4090706@supsi.ch> <20130502145411.GA18405@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130502145411.GA18405@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin Hill wrote:
> On Thu May 02, 2013 at 03:56:54PM +0200, Roberto Nunnari wrote:
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
>> Ok.. got here.
>>
>>
>>>  - fail and remove the old disk partitions from the arrays
>> Now.. I may need some guidance for the next steps.. please correct me if 
>> I'm wrong..
>>
>> to fail the old disk partition from the arrays I should:
>> mdadm -f /dev/md0 /dev/sda1
>> mdadm -f /dev/md1 /dev/sda2
>> mdadm -f /dev/md2 /dev/sda3
>> mdadm -f /dev/md0 /dev/sdc1
>> mdadm -f /dev/md1 /dev/sdc2
>> mdadm -f /dev/md2 /dev/sdc3
>>
>> and to remove the old disk partition from the arrays I should:
>> mdadm -r /dev/md0 /dev/sda1
>> mdadm -r /dev/md1 /dev/sda2
>> mdadm -r /dev/md2 /dev/sda3
>> mdadm -r /dev/md0 /dev/sdc1
>> mdadm -r /dev/md1 /dev/sdc2
>> mdadm -r /dev/md2 /dev/sdc3
>>
>> correct?
>>
> Assuming sda & sdc are your old drives, yes (they were sda & sdb in your
> original mail, but possibly they've been reordered if you've rebooted
> with the new drives in).

yes.. they've been reordered.

Any checks I should run here, or can I relay on error messages 
evenctually printed on screen when the commands are run?

Thanks.
Robi

> 
>>>  - shrink the arrays back down to 2 members
>> to shrink the arrays back down to two members:
>> mdadm --grow --raid-devices=2 /dev/md0
>> mdadm --grow --raid-devices=2 /dev/md1
>> mdadm --grow --raid-devices=2 /dev/md2
>>
>> correct?
>>
> Yes, that's all correct.
> 
> Cheers,
>     Robin


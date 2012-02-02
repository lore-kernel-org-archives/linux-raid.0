From: Asdo <asdo@shiftmail.org>
Subject: Re: Some md/mdadm bugs
Date: Thu, 02 Feb 2012 23:58:33 +0100
Message-ID: <4F2B1519.5010500@shiftmail.org>
References: <4F2ADF45.4040103@shiftmail.org>
 <20120203081717.195bfec8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20120203081717.195bfec8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil
thanks for the reply

version is:
mdadm - v3.1.4 - 31st August 2010
so it's indeed before 3.1.5
That's what is in Ubuntu latest stable 11.10, they are lagging behind

I'll break the quotes to add a few comments --->

On 02/02/12 22:17, NeilBrown wrote:
> .....
>> I am wondering (and this would be very serious) what happens if a new
>> drives is inserted and it takes the /dev/sda identifier!? Would MD start
>> writing or do any operation THERE!?
> Wouldn't happen.  As long as md hold onto the shell of the old sda nothing
> else will get the name 'sda'.

Great!
indeed this was what I *suspected* based on the fact newly added drives 
got higher identifiers. It's good to hear it from a safe source though.

>> And here goes also a feature request:
>>
>> if a device is detached from the system, (echo 1>  device/delete or
>> removing via hardware hot-swap + AHCI) MD should detect this situation
>> and mark the device (and all its partitions) as failed in all arrays, or
>> even remove the device completely from the RAID.
> This needs to be done via a udev rule.
> That is why --remove understands names like "sda6" (no /dev).
>
> Then a device is removed, udev processes the remove notification.
> The rule
>
> ACTION=="remove", RUN+="/sbin/mdadm -If $name"
>
> in /etc/udev/rules.d/something.rules
>
> will make that happen.

Oh great!

Will use that.

--incremental --fail ! I would never have thought of combining those.

>
>> In my case I have verified that MD did not realize the device was
>> removed from the system, and only much later when an I/O was issued to
>> the disk, it would mark the device as failed in the RAID.
>>
>> After the above is implemented, it could be an idea to actually allow a
>> new disk to take the place of a failed disk automatically if that would
>> be a "re-add" (probably the same failed disk is being reinserted by the
>> operator) and this even if the array is running, and especially if there
>> is a bitmap.
> It should so that, providing you have a udev rule like:
> ACTION=="add", RUN+="/sbin/mdadm -I $tempnode"

I think I have this rule.
But it doesn't work even via commandline if the array is running as I 
wrote below --->

> You can even get it to add other devices as spares with e.g.
>    policy action=force-spare
>
> though you almost certainly don't want that general a policy.  You would
> want to restrict that to certain ports (device paths).

sure, I understand

>> Now it doesn't happen:
>> When I reinserted the disk, udev triggered the --incremental, to
>> reinsert the device, but mdadm refused to do anything because the old
>> slot was still occupied with a failed+detached device. I manually
>> removed the device from the raid then I ran --incremental, but mdadm
>> still refused to re-add the device to the RAID because the array was
>> running. I think that if it is a re-add, and especially if the bitmap is
>> active, I can't think of a situation in which the user would *not* want
>> to do an incremental re-add even if the array is running.
> Hmmm.. that doesn't seem right.  What version of mdadm are you running?

3.1.4

> Maybe a newer one would get this right.
I need to try...
I think I need that.

> Thanks for the reports.
thank you for your reply.

Asdo

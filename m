From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: Creating an md with 3TB drives.
Date: Wed, 28 Sep 2011 17:09:00 +0200
Message-ID: <4E83388C.9010308@yazzy.org>
References: <4E82D53F.3050409@yazzy.org> <20110928182302.39cfd4b0@notabene.brown> <4E82DB7D.4050104@yazzy.org> <j5umop$6sr$1@dough.gmane.org>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j5umop$6sr$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/28/11 10:43 AM, David Brown wrote:
> On 28/09/2011 10:31, Marcin M. Jessa wrote:
>> On 9/28/11 10:23 AM, NeilBrown wrote:
>> [...]
>>
>>>>
>>>> Then I used fdisk to change the partition type to Linux raid auto
>>>
>>> You can do that if you like but it will have no effect. The "raid auto"
>>> partition type only means anything on MBR partitions. You don't need
>>> to, so
>>> don't bother.
>>
>> Thanks Neil.
>> Not using fdisk worked like a charm.
>>
>
> Using fdisk probably resulted in the disks going over to MBR rather than
> GPT, and thus you have a 2TB limit.
>
> By the way, you should probably try the parted again and fix the
> alignment issue (rather than just "ignoring" it) - it will make a /big/
> difference.

In terms of speed?
This RAID array is temporarily just so I can back up/restore my broken 
5x2TB RAID6 but it would be interesting to know what to do.
I was running
  # parted -a optimal /dev/sdd
which was suppose to fix that warning but it didn't.


-- 

Marcin M. Jessa

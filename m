From: David Brown <david@westcontrol.com>
Subject: Re: Creating an md with 3TB drives.
Date: Thu, 29 Sep 2011 13:18:46 +0200
Message-ID: <j61kal$ie8$1@dough.gmane.org>
References: <4E82D53F.3050409@yazzy.org> <20110928182302.39cfd4b0@notabene.brown> <4E82DB7D.4050104@yazzy.org> <j5umop$6sr$1@dough.gmane.org> <4E83388C.9010308@yazzy.org> <j61cpu$ugr$1@dough.gmane.org> <4E843917.9020606@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E843917.9020606@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/09/2011 11:23, Marcin M. Jessa wrote:
> On 9/29/11 11:09 AM, David Brown wrote:
>> On 28/09/2011 17:09, Marcin M. Jessa wrote:
>>> On 9/28/11 10:43 AM, David Brown wrote:
>>>> On 28/09/2011 10:31, Marcin M. Jessa wrote:
>>>>> On 9/28/11 10:23 AM, NeilBrown wrote:
>>>>> [...]
>>>>>
>>>>>>>
>>>>>>> Then I used fdisk to change the partition type to Linux raid auto
>>>>>>
>>>>>> You can do that if you like but it will have no effect. The "raid
>>>>>> auto"
>>>>>> partition type only means anything on MBR partitions. You don't need
>>>>>> to, so
>>>>>> don't bother.
>>>>>
>>>>> Thanks Neil.
>>>>> Not using fdisk worked like a charm.
>>>>>
>>>>
>>>> Using fdisk probably resulted in the disks going over to MBR rather
>>>> than
>>>> GPT, and thus you have a 2TB limit.
>>>>
>>>> By the way, you should probably try the parted again and fix the
>>>> alignment issue (rather than just "ignoring" it) - it will make a /big/
>>>> difference.
>>>
>>> In terms of speed?
>>> This RAID array is temporarily just so I can back up/restore my broken
>>> 5x2TB RAID6 but it would be interesting to know what to do.
>>> I was running
>>> # parted -a optimal /dev/sdd
>>> which was suppose to fix that warning but it didn't.
>>>
>>
>> Yes, I was thinking in terms of speed. I haven't gone beyond 2 TB disks
>> with MBR myself, so I can't comment on whether your partitions really
>> are misaligned, or if it is just an incorrect warning. But if these
>> disks are like most 2 TB disks with 4K sectors but which lie and claim
>> to have 512 byte sectors (for compatibility with ancient and inferior
>> OS'es), then partition misalignment will be major performance hit. It's
>> worth double-checking that you've got it right here, before you go to
>> far with the array.
>
> These are 3TB Hitachi drives and Hitachi kept 512 byte sectors:
> http://www.hitachigst.com/internal-drives/desktop/deskstar/deskstar-7k3000
>

I did not know such drives existed - I thought all 2TB+ drives were 4K 
sector size.  If these drives really have 512 byte sectors, then 
alignment will not be an issue.




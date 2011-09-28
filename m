From: David Brown <david@westcontrol.com>
Subject: Re: Creating an md with 3TB drives.
Date: Wed, 28 Sep 2011 10:43:47 +0200
Message-ID: <j5umop$6sr$1@dough.gmane.org>
References: <4E82D53F.3050409@yazzy.org> <20110928182302.39cfd4b0@notabene.brown> <4E82DB7D.4050104@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E82DB7D.4050104@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/09/2011 10:31, Marcin M. Jessa wrote:
> On 9/28/11 10:23 AM, NeilBrown wrote:
> [...]
>
>>>
>>> Then I used fdisk to change the partition type to Linux raid auto
>>
>> You can do that if you like but it will have no effect. The "raid auto"
>> partition type only means anything on MBR partitions. You don't need
>> to, so
>> don't bother.
>
> Thanks Neil.
> Not using fdisk worked like a charm.
>

Using fdisk probably resulted in the disks going over to MBR rather than 
GPT, and thus you have a 2TB limit.

By the way, you should probably try the parted again and fix the 
alignment issue (rather than just "ignoring" it) - it will make a /big/ 
difference.




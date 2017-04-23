From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 22:25:21 +0800
Message-ID: <4ea76cf6-2ca5-56af-e806-ffd4f8cdda62@fnarfbargle.com>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
 <760766b7-1801-0b2a-6ef1-2da910d976f0@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <760766b7-1801-0b2a-6ef1-2da910d976f0@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 23/04/17 22:09, Patrik Dahlström wrote:
>
> On 04/23/2017 04:06 PM, Brad Campbell wrote:
>> On 23/04/17 17:47, Patrik Dahlström wrote:
>>> Hello,
>>>
>>> Here's the story:
>>>
>>> I started with a 5x6 TB raid5 array. I added another 6 TB drive and
>>> started to grow the array. However, one of my SATA cables were bad and
>>> the reshape gave me lots of I/O errors.
>>>
>>> Instead of fixing the SATA cable issue directly, I shutdown the server
>>> and swapped places of 2 drives. My reasoning was that putting the new
>>> drive in a good slot would reduce the I/O errors. Bad move, I know. I
>>> tried a few commands but was not able to continue the reshape.
>>>
>> Nobody seems to have mentioned the reshape issue. What sort of reshape
>> were you running? How far into the reshape did it get? Do you have any
>> logs of the errors (which might at least indicate whereabouts in the
>> array things were before you pushed it over the edge)?
> These were the grow commands I ran:
> mdadm --add /dev/md1 /dev/sdf
> mdadm --grow --raid-devices=6 /dev/md1
>
> It got to roughly 15-17 % before I decided that the I/O errors were more
> scary than stopping the reshape.
>
You might be very lucky. If my reading of the code is correct (and my 
memory is any good), simply adding a disk to a raid5 on a recent enough 
kernel should make the resync go backwards. So it should have started at 
the end and worked towards the start. This would mean the majority of 
your data should be on your 5 original disks.

If this is the case, then permuting the array with 6 disks is going to 
fail always as 1/5th of every stripe will be bogus. Doing it with the 
original 5 disks may ultimately yield something in the order of 85% of 
your data if your estimate of 15-17% is correct.

No harm testing it with some overlays anyway. Someone more familiar with 
the code will correct me if I'm wrong.

Regards,
Brad

-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.


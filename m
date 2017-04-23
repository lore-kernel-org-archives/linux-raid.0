From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 16:09:36 +0200
Message-ID: <760766b7-1801-0b2a-6ef1-2da910d976f0@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/23/2017 04:06 PM, Brad Campbell wrote:
> On 23/04/17 17:47, Patrik Dahlström wrote:
>> Hello,
>>
>> Here's the story:
>>
>> I started with a 5x6 TB raid5 array. I added another 6 TB drive and
>> started to grow the array. However, one of my SATA cables were bad and
>> the reshape gave me lots of I/O errors.
>>
>> Instead of fixing the SATA cable issue directly, I shutdown the server
>> and swapped places of 2 drives. My reasoning was that putting the new
>> drive in a good slot would reduce the I/O errors. Bad move, I know. I
>> tried a few commands but was not able to continue the reshape.
>>
> 
> Nobody seems to have mentioned the reshape issue. What sort of reshape
> were you running? How far into the reshape did it get? Do you have any
> logs of the errors (which might at least indicate whereabouts in the
> array things were before you pushed it over the edge)?
These were the grow commands I ran:
mdadm --add /dev/md1 /dev/sdf
mdadm --grow --raid-devices=6 /dev/md1

It got to roughly 15-17 % before I decided that the I/O errors were more
scary than stopping the reshape.
> 
> 
> What you'll have is one part of the array in one configuration, the
> remaining part in another and no record of where that split begins.
Like I said, ~15-17 % into the reshape.
> 
> Regards,
> Brad

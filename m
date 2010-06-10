From: MRK <mrk@shiftmail.org>
Subject: Re: It is possible to put write cache on ssd?
Date: Thu, 10 Jun 2010 14:08:38 +0200
Message-ID: <4C10D5C6.5060507@shiftmail.org>
References: <loom.20100604T102522-67@post.gmane.org> <4C0D44FC.8020908@tmr.com>
 <loom.20100608T092726-796@post.gmane.org>
 <AANLkTikfDks6aTLal8dJLXhMlGxHtMtZ-L_r0r8IQQ4U@mail.gmail.com>
 <4C0F75B8.7020306@shiftmail.org>
 <AANLkTimMBOtusTb2GQjziBEt5XoFEBEmZmQfhWsB6Xig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTimMBOtusTb2GQjziBEt5XoFEBEmZmQfhWsB6Xig@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aryeh Gregor <Simetrical+list@gmail.com>
Cc: CoolCold <coolthecold@gmail.com>, Mario <mgiammarco@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/09/2010 06:21 PM, Aryeh Gregor wrote:
> On Wed, Jun 9, 2010 at 7:06 AM, MRK<mrk@shiftmail.org>  wrote:
>    
>> Same problem with write-mostly/write-behind I think. I don't know how long
>> is the queue that holds data already committed to the SSD and not yet
>> committed to the HDD but it can't be too long. I'm reading the "man md"
>> right now and it's not extremely clear on this. I have the impression the
>> queue between the two it's either the /sys/block/hdddevice/queue/nr_requests
>> or it uses the write-intent bitmap (if set). In case of the nr_requests,
>> it's gonna be very short so the SSD can give you quick bursts but continuous
>> performance will be that of the HDD.
>>      
> I tried this once and posted some bonnie++ results:
>
> https://kerneltrap.org/mailarchive/linux-raid/2010/1/31/6742263
>    

Thanks for your tests. The write-mostly array seems to go roughly as 
fast as the SSD itself if I interpret your tests correctly (have you 
really saturated the write-behind queue?). An HDD-only test would have 
been interesting though (with SSDs failed and removed).

Secondly:
I now realize that the write-behind distance is settable (man mdadm see 
--write-behind= ). However there is written it needs the write intent 
bitmap to work. This makes me think that it is not really safe upon SSD 
failure. Is the data in the write-behind queue also saved in RAM or does 
it exist only in the SSD device (pointed to by the bitmap)? In the 
second case, if the SSD dies, the HDD will likely be corrupt, it's not 
really like having a RAID. In the first case, I don't understand why it 
should need the write intent bitmap active.



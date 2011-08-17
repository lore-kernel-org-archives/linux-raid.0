From: Asdo <asdo@shiftmail.org>
Subject: Re: First raid1 sector gets zeroed at first reboot
Date: Wed, 17 Aug 2011 18:45:26 +0200
Message-ID: <4E4BF026.8030006@shiftmail.org>
References: <4E4AABF6.2070800@shiftmail.org> <4E4BC586.10109@anonymous.org.uk>
 <4E4BC96D.1020802@shiftmail.org> <4E4BD186.4070604@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4E4BD186.4070604@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/17/11 16:34, John Robinson wrote:
> On 17/08/2011 15:00, Asdo wrote:
>> No you are confusing it with metadata 1.1 .
>> Metadata 1.0 has the data at the end like 0.9 .
>
> No I'm afraid it's you that's confused. Metadata 1.0 has the 
> *metadata* at the end, like 0.9, so it has the data i.e. filesystem 
> area at the beginning. Take a look with mdadm -D, the data offset is 
> zero.
>
> This is why partitions with 0.9 or 1.0 metadata in RAID-1 can be used 
> individually to boot from because the partitions look identical to 
> ones that just have filesystems on them.

That's correct, the same thing I meant.

Then I had misinterpreted you:
> The first sector of a md RAID with metadata 1.0 is in its data area, 
> so there's no way md is writing to this area itself, it's almost 
> certainly the filesystem that's writing it. 
This is an interesting observation then. ("no way" is a bit extreme 
though) You are right in the sense that it might have been the 
filesystem that is doing something at the first remount, and not MD. I 
can't be sure it's MD anymore. Still, this is wrong, why should the 
filesystem wipe its own boot sector?
It's ext3 btw. If no one pops up with an explanation here on linux-raid 
I will also ask there.

I still stand that what I am doing is correct. I am using the partition 
boot sector properly
http://en.wikipedia.org/wiki/Volume_boot_record

Thank you

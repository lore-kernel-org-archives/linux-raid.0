From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: First raid1 sector gets zeroed at first reboot
Date: Wed, 17 Aug 2011 15:34:46 +0100
Message-ID: <4E4BD186.4070604@anonymous.org.uk>
References: <4E4AABF6.2070800@shiftmail.org> <4E4BC586.10109@anonymous.org.uk> <4E4BC96D.1020802@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E4BC96D.1020802@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/08/2011 15:00, Asdo wrote:
> On 08/17/11 15:43, John Robinson wrote:
>>
>> The first sector of a md RAID with metadata 1.0 is in its data area,
>> so there's no way md is writing to this area itself, it's almost
>> certainly the filesystem that's writing it.
>>
>> I think installing grub on a md partition is a bad idea. You can use
>> metadata 1.2 to have the first 4K left free, but grub may write its
>> stage 1.5 code to the first 31.5K of a device (whole drive or partition).
>>
>
> No you are confusing it with metadata 1.1 .
> Metadata 1.0 has the data at the end like 0.9 .

No I'm afraid it's you that's confused. Metadata 1.0 has the *metadata* 
at the end, like 0.9, so it has the data i.e. filesystem area at the 
beginning. Take a look with mdadm -D, the data offset is zero.

This is why partitions with 0.9 or 1.0 metadata in RAID-1 can be used 
individually to boot from because the partitions look identical to ones 
that just have filesystems on them.

Cheers,

John.

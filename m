From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 up, but one drive removed, one says spare building, what
 now?
Date: Fri, 10 Nov 2017 08:01:21 -0500
Message-ID: <34b72bc9-9a72-3143-bd1e-d00f90493d04@turmel.org>
References: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
 <5A058E25.1020608@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A058E25.1020608@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Jun-Kai Teoh <kai.teoh@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Jun-Kai,

On 11/10/2017 06:31 AM, Wols Lists wrote:
> On 10/11/17 03:09, Jun-Kai Teoh wrote:
>> Hi all,
>>
>> I managed to get my RAID drive back up, content looks like it's still
>> there, but it's not resyncing or reshaping and my parity drive was
>> removed (I did it when I tried to get it back up).

If you can see your content (mounted read-only, I hope), backup up
everything, in order from most critical to least critical.

>> So what should I do now? I'm afraid of doing anything else at this point.

Well, you need to provide more information.  At least the mdadm -E
reports for all of the member devices.  Including the "parity" device
you removed.  (Parity is spread among all devices in a normal raid5
layout, so you may be suffering from a misunderstanding.)

>> /dev/md126:
>>         Version : 1.2
>>   Creation Time : Thu Jun 30 07:57:36 2016
>>      Raid Level : raid5
>>      Array Size : 23441323008 (22355.39 GiB 24003.91 GB)
>>   Used Dev Size : 3906887168 (3725.90 GiB 4000.65 GB)
>>    Raid Devices : 8
>>   Total Devices : 7
>>     Persistence : Superblock is persistent
>>
>>   Intent Bitmap : Internal
>>
>>     Update Time : Thu Nov  9 18:57:18 2017
>>           State : clean, FAILED
>>  Active Devices : 6
>> Working Devices : 7
>>  Failed Devices : 0
>>   Spare Devices : 1
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>   Delta Devices : 1, (7->8)
                        ^^^^^^

Somewhere in your efforts, you must have used mdadm --grow.  That was
bad, and the reason for my suggestion above.

Please review your bash history and reconstruct what steps you took in
your efforts to revive your array.  An extract of relevant dmesg text
from that time period may be helpful, too.

It would help if you summarized how you got into this jam in the first
place.

[trim /]

> Okay. I was hoping someone else would chime in, but I'd say this looks
> well promising. You have seven drives of eight so you have no redundancy :-(
> 
> You say your data is still there - does that mean you've mounted it, and
> it looks okay?
> 
> sde is rebuilding, which means the array is sorting itself out.

It's not progressing, because of the reshape.

> You need that eighth drive. If a fsck says you have no (or almost no)
> filesystem corruption, and you have a known-good drive, add it in. The
> array will then sort itself out.

No, backups are first.

> I would NOT recommend mounting it read-write until it comes back and
> says "eight drives of eight working".

Concur.

Phil

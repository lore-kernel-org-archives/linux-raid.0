From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: How to backup of large md raid volumes?
Date: Sat, 20 May 2017 19:00:35 +0100
Message-ID: <59208443.7080404@youngman.org.uk>
References: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
 <28a4540b-c5ac-bd8d-c030-6d718a02fdfc@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28a4540b-c5ac-bd8d-c030-6d718a02fdfc@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/05/17 06:49, Reindl Harald wrote:
> 
> 
> Am 18.05.2017 um 23:37 schrieb Ram Ramesh:
>> Any one have a method to backup large volumes like md raid6 (16TB)?
>> Since the backup will not fit in one disk (in many cases and mine too)
>> I am wondering, if there is a known/easy technique to backup using
>> multiple usb hard drives. I googed and found a few fancy backup
>> utils/systems like Amanda etc. They are overkill for me. I am choosing
>> not to back up simply because of the complexity of setup as the data
>> in my RAID volume is NOT precious and can be replaced with a week of
>> effort.
>>
>> If any one can think of some thing simple, please point me to it and I
>> will do the reading to figure out
> 
> https://www.amazon.com/16TB-Desktop-External-Drive-WDBLWE0160JCH-NESN/dp/B01B6BN1CU
> 
> 
> 499$ is not that much for a 16 TB external backup disk and whn you
> format it with BTRFS and enable compression you most likely have a lot
> fo space and your backup finally is just a single rsync command

My only reaction to that is it's not a 16TB disk. It's a 16TB raid-0
array. We had a similar setup ages ago (when 500GB was huge) with a
500GB external USB drive. One of the 250GB drives failed and the entire
array was lost.

I'd be inclined to try and get an e-SATA or USB-3 dock, and just back up
on to independent 8TB drives. Mind you, at £70 for a 3TB Barracuda, $500
for 16TB of disk doesn't sound pricey at all ...

One thing to watch out for, it sounds like the OP has mostly music and
videos, so compression is likely to INCREASE the disk space required...

Cheers,
Wol


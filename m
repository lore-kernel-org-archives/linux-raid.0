From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: New setup: partitions or raw devices
Date: Sat, 2 Dec 2017 00:44:33 +0100
Message-ID: <1d3830e8-9e5e-681c-d556-1b8b6524dda2@thelounge.net>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
 <CAJH6TXjbAFjP66HN54kiUffd=zt0HUgyQmcvsU-mYpJRUaQafw@mail.gmail.com>
 <e62ea493-3fae-5c3e-5578-f426dc3d254e@thelounge.net>
 <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
 <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
 <253c22a2-8f77-2737-b3b4-6beef107c28c@youngman.org.uk>
 <14078b47-29dd-6c07-f680-77ac9445be32@thelounge.net>
 <87tvxazahs.fsf@esperi.org.uk>
 <e44e21ec-a2b3-8441-5ad3-190b4c0a8670@thelounge.net>
 <5A218EDB.6030909@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A218EDB.6030909@youngman.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>
Cc: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 01.12.2017 um 18:18 schrieb Wols Lists:
> On 01/12/17 16:27, Reindl Harald wrote:
>>
>>
>> Am 01.12.2017 um 17:19 schrieb Nix:
>>> That's not actually answering the question that was asked, y'know. If
>>> you're against RAID 5 because the parity writes wear the drives out, you
>>> should be much more strongly against RAID 10 for the same reason
>>
>> RAID10 is simple mirroring of stripes
>>
> And?

why should mirroring on a different disk wear more?

> The more I think about it, the more I come to the conclusion that
> raid-10 is a bad idea for (a) minimising writes (and wear), and (b) for
> safeguarding your data.

why?

> Yes it does have advantages, and yes I plan to put a raid-10 array on my
> new system, but if reducing wear or protecting data are your priorities,
> raid-10 is the wrong choice
wrong!

rebuilds are much faster then with RAID5 or even RAID6 which is worst 
and so the degraded timeslot is smaller, a RAID10 *can* survive two 
faile disks while a RAID5 is for sure dead

RAID10 is practically a RAID1 with the performance enhancement of RAID0 
and if the linux kernel would support "writemostly" on RAID10 as it does 
with RAID1 it would be the perfect choice for a hybrid RAID for 
workloads which are mostly read-bound and so combine all worlds (RAID0 
at read from only the two SSD stripes, redundancy like RAID1 and only 
the need of 2 SSD's and two HDD's for redundancy)

RAID5 has *zero* benefits against RAID10 except costs while RAID6 is 
terrible for performance and wear out of disks

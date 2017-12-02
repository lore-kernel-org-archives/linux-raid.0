From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: New setup: partitions or raw devices
Date: Sat, 2 Dec 2017 22:41:19 +0100
Message-ID: <d5416532-58f7-addc-5b90-21cc3cc311c0@thelounge.net>
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
 <1d3830e8-9e5e-681c-d556-1b8b6524dda2@thelounge.net>
 <87po7xw9lh.fsf@esperi.org.uk>
 <7b1c8f3c-08dd-771f-eab3-b75c11f3ea35@thelounge.net>
 <87o9ngkgv8.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87o9ngkgv8.fsf@esperi.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Wols Lists <antlists@youngman.org.uk>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 02.12.2017 um 21:35 schrieb Nix:
> On 2 Dec 2017, Reindl Harald outgrape:
> 
>> Am 02.12.2017 um 14:19 schrieb Nix:
>>> If RAID-5 and RAID-6 had no benefits at all over RAID-10 it is unlikely
>>> they would still be in wide use. They are, even for new installations,
>>> because they truly do offer benefits for some use cases. They may not
>>> for yours, but that doesn't mean they don't for anyone
>>
>> yes, when you need far more than 8 TB...
> 
> I can't figure out whether you're castigating people who need more than
> 8TiB, castigating people who need less, applauding people who need more
> than 8TiB, applauding people who need less, saying that people who need
> more than 8TiB should use RAID 10, saying that people who need more
> should use RAID 6, or *what*. All I can tell is that you want to be as
> unpleasant as possible while saying it. (I suspect this ambiguity is
> intentional, so that no matter what people assume you meant, you can
> flame them for not interpreting it the other way.)

i don't castigating anybody - it's simply always about price, size, 
performance and redundancy level and since disk sizes and their prices 
as well as technology changes there is no definite answer - but 
*currently* up to 8 TB storage is doable with *any* raid level without 
spend many thousands of money

for storgae sizes up to 8 TB *these days* you get away with 4 disks 
which are not that expensive, if you need 100 TB the overhead of needed 
disks will simply kill you in context of price

and for performance you have practically the same "problems" to solve, 
small-to-middle arrays with SSD and RAID10 are possible, for middle 
large arrays you can reach similar performance with RAID10 and HHD by 
just use more drives

> But then that's not surprising because you've morphed again to try to
> escape from people's killfiles. Back you go into mine, *yet again*

i could not care less about you - seriously

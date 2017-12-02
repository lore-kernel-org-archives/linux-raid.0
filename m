From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: New setup: partitions or raw devices
Date: Sat, 2 Dec 2017 15:01:13 +0100
Message-ID: <7b1c8f3c-08dd-771f-eab3-b75c11f3ea35@thelounge.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87po7xw9lh.fsf@esperi.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Wols Lists <antlists@youngman.org.uk>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 02.12.2017 um 14:19 schrieb Nix:
> On 1 Dec 2017, Reindl Harald said:
> 
>> RAID5 has *zero* benefits against RAID10 except costs while RAID6 is
>> terrible for performance and wear out of disks
> 
> You still haven't explained why RAID-6 wears out disks more than RAID-10
> does.

what about common sense?
double parity anyone?

a write goes at least to 3 disks of the array instead two in case of a 4 
meber RAID10

> RAID-5 has one huge benefit over RAID-10: more accessible storage for a
> given number of disks, and, given that power is not free, that means
> lower running costs as well, as well as lower noise, lower vibration,
> lower maintenance costs (since having more disks does mean you have to
> replace disks more often, even if the chance of losing data when one
> fails is reduced by RAID).

the more accessible storage is the only real one

> If RAID-5 and RAID-6 had no benefits at all over RAID-10 it is unlikely
> they would still be in wide use. They are, even for new installations,
> because they truly do offer benefits for some use cases. They may not
> for yours, but that doesn't mean they don't for anyone

yes, when you need far more than 8 TB...

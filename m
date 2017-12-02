From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: New setup: partitions or raw devices
Date: Sat, 2 Dec 2017 14:56:04 +0100
Message-ID: <441328f8-c4fc-cd21-81ff-95af768ed5cf@thelounge.net>
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
 <6066a947-2a4e-d8d5-239d-dccb80e39ac0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6066a947-2a4e-d8d5-239d-dccb80e39ac0@gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 02.12.2017 um 14:14 schrieb Gandalf Corvotempesta:
> Il 02/12/2017 00:44, Reindl Harald ha scritto:
>> a RAID10 can survive two faile disks while a RAID5 is for sure dead
> Absolutely not.
> This is a common misconception.
> RAID-10 can survive two failed disks IF AND ONLY IF these disks are on 
> different mirrors.

i know that - thats the difference between "will" and "can"

> I had multiple (more than 4) RAID-10s totally lost due to double failure 
> in the same mirror.
> Each disk in a mirror will get the same write pattern, thus, you'll risk 
> a double failure for any
> firmware bugs or similiar. With SSDs this risk is higher, because you 
> wear out both members
> in the same way at the same time

when you are not an idiot the mirror is not the same disk or not the 
same age, guess why i replaced first two of the HDD's with SSD's and 
somewhere next year i plan to replace the remaining two too

and for 4 disk RAID10 with HDD's i use typicaly 4 different disks at all 
from as many vendors as possible (the machine in the office is from a 
time where you had 4 real vendors)

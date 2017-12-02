From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: New setup: partitions or raw devices
Date: Sat, 2 Dec 2017 14:14:07 +0100
Message-ID: <6066a947-2a4e-d8d5-239d-dccb80e39ac0@gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1d3830e8-9e5e-681c-d556-1b8b6524dda2@thelounge.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il 02/12/2017 00:44, Reindl Harald ha scritto:
> a RAID10 can survive two faile disks while a RAID5 is for sure dead
Absolutely not.
This is a common misconception.
RAID-10 can survive two failed disks IF AND ONLY IF these disks are on 
different mirrors.

I had multiple (more than 4) RAID-10s totally lost due to double failure 
in the same mirror.
Each disk in a mirror will get the same write pattern, thus, you'll risk 
a double failure for any
firmware bugs or similiar. With SSDs this risk is higher, because you 
wear out both members
in the same way at the same time.
If the controller kicks out two adiacent disks, you'll loose everything
(this is happened to me: fully synced RAID10: disk0 was kicked out by 
the controller, RAID
survived and after a couple of minutes, disk0 was automatically 
reactivated and started a rebuild.
during the rebuild, disk1 was kicked out. RAID lost: disk0 out-of-sync 
and disk1 kicked out)

RAID-6 is *much* more safe than RAID-1/RAID-10 as it can survive ANY TWO 
disks failure,
you will loose data on the third failure.

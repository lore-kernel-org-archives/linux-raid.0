From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: New setup: partitions or raw devices
Date: Sat, 2 Dec 2017 19:39:21 +0100
Message-ID: <a68195a6-3b6d-d1c1-7e26-ff045c03cbd2@thelounge.net>
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
 <16db34f1-34a7-bf48-9800-6f9891d1e933@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16db34f1-34a7-bf48-9800-6f9891d1e933@turmel.org>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 02.12.2017 um 18:12 schrieb Phil Turmel:
>> RAID-6 is *much* more safe than RAID-1/RAID-10 as it can survive ANY TWO
>> disks failure,
>> you will loose data on the third failure.
> 
> You (Reindl) are crazy to argue about can-vs-will on a raid10,n2 layout.
> You're crazy to rely on any single mirror layout for data you care
> about.  It is a disaster waiting to happen (during rebuild) in exactly
> the same way raid5 is vulnerable during rebuild.  But raid10,n3 is just
> as safe as raid6

besides that this above is not a quote of me nor makes this quote sense

no, i take all the benefits RAID10 has *anyways* and when you have the 
mirrors on different drives.... but that's only *one* minor point for RAID10

probability is always a valid point when you have to make technical 
decisions be it how long needs my UPS typically give me power based on 
typical power outages, and yes the first one could be longer as anyone 
you have ever seen and you still lost

i explained a lot of other benefits of RAID10 so i have no idea why you 
hang on one nuance - the most importatnt is that i can clone a fukcing 
machine by just put half of the drives in a differnt one and start 
rebuild on both machines after that

the whole porblem of that thread in fact his dumb "but you are talking 
about SSD" - yes damned - i talk about how i would setup a machine *now* 
and how i would have done it many years ago with the knowledge of today 
while the 40 GB overprovisioning won't matter for storage size but be 
good for the disks (and no i don't need another one whining that it#s 
not enough because that's nonsense - there is no definite enough - no 
overprovisioning won't make it better at all)


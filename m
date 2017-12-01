From: Nix <nix@esperi.org.uk>
Subject: Re: New setup: partitions or raw devices
Date: Fri, 01 Dec 2017 22:22:00 +0000
Message-ID: <878temxf5j.fsf@esperi.org.uk>
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
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A218EDB.6030909@youngman.org.uk> (Wols Lists's message of "Fri,
        1 Dec 2017 17:18:19 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Reindl Harald <h.reindl@thelounge.net>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1 Dec 2017, Wols Lists stated:
> Yes it does have advantages, and yes I plan to put a raid-10 array on my
> new system, but if reducing wear or protecting data are your priorities,
> raid-10 is the wrong choice.

It depends on the access patterns. It's no worse at safeguarding data
than RAID-5 and can be better (some, but not all, combinations of
multiple disk failures will lead to no data loss, something which would
otherwise require RAID-6). It's faster at reads and much faster at
random writes. The cost: possibly quite a lot more spinning rust for the
amount of available storage. (For me, power-consumption considerations
led me to stick with RAID, though I've gone to RAID-6.)

-- 
NULL && (void)

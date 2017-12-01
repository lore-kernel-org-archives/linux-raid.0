From: Nix <nix@esperi.org.uk>
Subject: Re: New setup: partitions or raw devices
Date: Fri, 01 Dec 2017 16:19:43 +0000
Message-ID: <87tvxazahs.fsf@esperi.org.uk>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
        <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
        <CAJH6TXjbAFjP66HN54kiUffd=zt0HUgyQmcvsU-mYpJRUaQafw@mail.gmail.com>
        <e62ea493-3fae-5c3e-5578-f426dc3d254e@thelounge.net>
        <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
        <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
        <253c22a2-8f77-2737-b3b4-6beef107c28c@youngman.org.uk>
        <14078b47-29dd-6c07-f680-77ac9445be32@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14078b47-29dd-6c07-f680-77ac9445be32@thelounge.net> (Reindl
        Harald's message of "Wed, 29 Nov 2017 23:27:53 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Wol's lists <antlists@youngman.org.uk>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29 Nov 2017, Reindl Harald said:

> Am 29.11.2017 um 23:20 schrieb Wol's lists:
>> On 29/11/17 20:02, Reindl Harald wrote:
>>> why not RAID5/6? besides https://www.askdbmgt.com/why-raid5-should-be-avoided-at-all-costs.html the parity data are additional
>>> writes wearing out the drives
>>
>> So, if I have a four-drive raid 5, for every 3 blocks of data I write I write 1 parity block. But with raid 1 or 10, for every 3
>> blocks of data I write, I write *3* "parity" blocks!
>>
>> What was that about "the additional writes wearing out the drives" then?
>>
>> (Yes, I get the write amplification thing - but if you are writing a lot of data, then raid 5 needs far *fewer* writes.)
>
> RAID10 has a lot of other benefits:

That's not actually answering the question that was asked, y'know. If
you're against RAID 5 because the parity writes wear the drives out, you
should be much more strongly against RAID 10 for the same reason.

-- 
NULL && (void)

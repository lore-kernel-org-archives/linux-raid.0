From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 22:20:00 +0000
Message-ID: <253c22a2-8f77-2737-b3b4-6beef107c28c@youngman.org.uk>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
 <CAJH6TXjbAFjP66HN54kiUffd=zt0HUgyQmcvsU-mYpJRUaQafw@mail.gmail.com>
 <e62ea493-3fae-5c3e-5578-f426dc3d254e@thelounge.net>
 <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
 <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/11/17 20:02, Reindl Harald wrote:
> why not RAID5/6? besides 
> https://www.askdbmgt.com/why-raid5-should-be-avoided-at-all-costs.html 
> the parity data are additional writes wearing out the drives

So, if I have a four-drive raid 5, for every 3 blocks of data I write I 
write 1 parity block. But with raid 1 or 10, for every 3 blocks of data 
I write, I write *3* "parity" blocks!

What was that about "the additional writes wearing out the drives" then?

(Yes, I get the write amplification thing - but if you are writing a lot 
of data, then raid 5 needs far *fewer* writes.)

Cheers,
Wol

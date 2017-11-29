From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 23:34:17 +0100
Message-ID: <46648c36-3a63-1524-995d-786620dc716e@thelounge.net>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
 <CAJH6TXjbAFjP66HN54kiUffd=zt0HUgyQmcvsU-mYpJRUaQafw@mail.gmail.com>
 <e62ea493-3fae-5c3e-5578-f426dc3d254e@thelounge.net>
 <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
 <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
 <CAJH6TXhVb2EFJm6jWUcW_6cLfegna-ft7rvm++EECSY2aRTP1A@mail.gmail.com>
 <34e548a3-111a-909f-9683-8eae3efafdcc@thelounge.net>
 <CAJH6TXh2RH6WwWa-11bZqEtDiOwXTv5yhjFUciP4zyb-YY49TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXh2RH6WwWa-11bZqEtDiOwXTv5yhjFUciP4zyb-YY49TA@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 29.11.2017 um 23:25 schrieb Gandalf Corvotempesta:
> 2017-11-29 23:10 GMT+01:00 Reindl Harald <h.reindl@thelounge.net>:
>> [0:0:0:0]    disk    ATA      Samsung SSD 850  2B6Q  /dev/sda
>> [1:0:0:0]    disk    ATA      Samsung SSD 850  2B6Q  /dev/sdb
> 
> these are consumer SSDs

so what

> Even the "PRO" is consumer and a 2TB is priced about 800 USD

in doubt - so what too - nothing you buy every day and in case of a 
RAID10 i put out the drives holding the OS and data and move them to the 
next machine, change the MAC of the internal NIC in the config and i am 
done (the other network cards and the wireless card are move too)

> Look at one of Intel DC SSD, the S3610 1.6TB is about 1500 USD. Twice
> the price, 40% less capacity

and do you really need them?
for what usecase?

performance?

well, the RAID10 versus RAID1 with two nearly double priced achieves the 
same or at least nothing different you could notice in real world usage 
and if one dies that's what RAID is for (the I is for inexpensive) and a 
few years later you get a "consumer SSD" with the same size probably 
much cheaper while a ton of tests prove that the consumer SSD's suck a 
lot of writes over a long time too

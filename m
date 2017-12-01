From: Nix <nix@esperi.org.uk>
Subject: Re: New setup: partitions or raw devices
Date: Fri, 01 Dec 2017 16:18:32 +0000
Message-ID: <87y3mmzajr.fsf@esperi.org.uk>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
        <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
        <CAJH6TXjbAFjP66HN54kiUffd=zt0HUgyQmcvsU-mYpJRUaQafw@mail.gmail.com>
        <e62ea493-3fae-5c3e-5578-f426dc3d254e@thelounge.net>
        <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
        <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
        <CAJH6TXhVb2EFJm6jWUcW_6cLfegna-ft7rvm++EECSY2aRTP1A@mail.gmail.com>
        <34e548a3-111a-909f-9683-8eae3efafdcc@thelounge.net>
        <CAJH6TXh2RH6WwWa-11bZqEtDiOwXTv5yhjFUciP4zyb-YY49TA@mail.gmail.com>
        <46648c36-3a63-1524-995d-786620dc716e@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46648c36-3a63-1524-995d-786620dc716e@thelounge.net> (Reindl
        Harald's message of "Wed, 29 Nov 2017 23:34:17 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29 Nov 2017, Reindl Harald said:

> Am 29.11.2017 um 23:25 schrieb Gandalf Corvotempesta:
>> Look at one of Intel DC SSD, the S3610 1.6TB is about 1500 USD. Twice
>> the price, 40% less capacity
>
> and do you really need them?
> for what usecase?

Not bricking or corrupting themselves when the power goes out.

Intel DC SSDs are the only SSDs I have *ever* heard of surviving such
tests.

(btw, if you really are overprovisioning SSDS by hand, 2--5% is not
remotely enough. 10% is not really enough. I'd go for 15--20%.

-- 
NULL && (void)

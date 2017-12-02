From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: New setup: partitions or raw devices
Date: Sat, 2 Dec 2017 14:01:56 +0100
Message-ID: <de890073-cfa0-ed99-15aa-da7bb5dd5170@gmail.com>
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
 <87y3mmzajr.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3mmzajr.fsf@esperi.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Reindl Harald <h.reindl@thelounge.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il 01/12/2017 17:18, Nix ha scritto:
>
> Not bricking or corrupting themselves when the power goes out.
>
> Intel DC SSDs are the only SSDs I have *ever* heard of surviving such
> tests.

Exactly.
And additionally, enterprise SSDs are far more reliable than consumer SSDs,
in a RAID-1, where both disks will get the same identical write pattern, 
the risk
for a double failure at the same time is high.

And if you have to proactively replace an SSD before it fails,
then your are not using "inexpesive" disks anymore.

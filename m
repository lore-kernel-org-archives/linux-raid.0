From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 23:02:57 +0100
Message-ID: <CAJH6TXhVb2EFJm6jWUcW_6cLfegna-ft7rvm++EECSY2aRTP1A@mail.gmail.com>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net> <CAJH6TXjbAFjP66HN54kiUffd=zt0HUgyQmcvsU-mYpJRUaQafw@mail.gmail.com>
 <e62ea493-3fae-5c3e-5578-f426dc3d254e@thelounge.net> <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
 <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2017-11-29 21:02 GMT+01:00 Reindl Harald <h.reindl@thelounge.net>:
> in case of 2 TB disks it's 40 GB per disk

Yes

> because 100 MB IMHO don't help that much for SSD overprovisioning and given
> how it may extend the lifetime versus the price and you don't have your
> disks typically filled completly

I'm talking about multi-tera disks, I don't think i'll ever (in the
near future) replace them
with SSDs....

> in a 4 drive RAID10 it's 80 GB missing useable disk space for
> overprovisioning out of around 3.6 TB (1000 versus 1024) while you have a
> lightning fast array which should last as long as possible without replace
> terrible expensive drives

Yes, but you are talking about SSD...
Here I have many HDD....

> why not RAID5/6? besides
> https://www.askdbmgt.com/why-raid5-should-be-avoided-at-all-costs.html the
> parity data are additional writes wearing out the drives

I think exactly the opposite.
I will never ever run anything with redundancy level lower than 2.
I'm totally againt RAID10, after i've loose (4 times!) the whole RAID due to
double failure on the same mirror.

Now, I'm only using RAID-6 on very small arrays (6 disks maximum)
If I need more space, I'll create a RAID-60

My newer server with SSD are running with 4 SSD in RAID-6 (or RAID-Z2,
it depends)

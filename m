From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Disk Monitoring
Date: Thu, 29 Jun 2017 12:37:02 +0200
Message-ID: <167de591-7d06-dfa7-f7e6-01a2ee4fd0e5@thelounge.net>
References: <20170628131917.BF1911235B6@gemini.denx.de>
 <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <38899f11-c6d2-cab7-eb25-093cfa802b40@thelounge.net>
 <CAJH6TXi8L-x7NiyAqG+22xosqAJ39LB0e_N6b-9PiMrhA2jnjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXi8L-x7NiyAqG+22xosqAJ39LB0e_N6b-9PiMrhA2jnjg@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 29.06.2017 um 12:14 schrieb Gandalf Corvotempesta:
> 2017-06-29 12:10 GMT+02:00 Reindl Harald <h.reindl@thelounge.net>:
>> there is nothing like "unused part of the array" since the linux-raid-layer
>> knows nothing about the filesystem on top and hence a raid-check (scrub)
>> reads every block as said hardware controller
> 
> Yes, this during a scrub.
> Without a scrub, kernel know nothing about an unused part of the array.
> 
> Let's assume a unreadable sector is found during a scrub. What
> happens? mdadm kick-out the disk from the array? It tried to
> reallocate the failed sector somewhere keeping the disk up and running
> (and thus, resolving the URE that would prevent a successful resync?)

it tries to re-write the data block (depending if repair is enabled)

normally the disk firmware itself is aware of that event and realloctes 
a spare block so the rewrite just suceeds until the disk runs out of 
spare sectors

but well, even if it just kicks out the disk soon enough you can replace 
it, the array rebuilds and nothing happened - without smart-check/scrub 
sooner or later it's detected due rebuild after a disk failed and the 
array is gone

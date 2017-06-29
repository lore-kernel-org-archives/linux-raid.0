From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Disk Monitoring
Date: Thu, 29 Jun 2017 12:14:04 +0200
Message-ID: <CAJH6TXi8L-x7NiyAqG+22xosqAJ39LB0e_N6b-9PiMrhA2jnjg@mail.gmail.com>
References: <20170628131917.BF1911235B6@gemini.denx.de> <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <38899f11-c6d2-cab7-eb25-093cfa802b40@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <38899f11-c6d2-cab7-eb25-093cfa802b40@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-06-29 12:10 GMT+02:00 Reindl Harald <h.reindl@thelounge.net>:
> there is nothing like "unused part of the array" since the linux-raid-layer
> knows nothing about the filesystem on top and hence a raid-check (scrub)
> reads every block as said hardware controller

Yes, this during a scrub.
Without a scrub, kernel know nothing about an unused part of the array.

Let's assume a unreadable sector is found during a scrub. What
happens? mdadm kick-out the disk from the array? It tried to
reallocate the failed sector somewhere keeping the disk up and running
(and thus, resolving the URE that would prevent a successful resync?)

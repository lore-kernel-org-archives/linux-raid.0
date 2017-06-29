From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Disk Monitoring
Date: Thu, 29 Jun 2017 15:28:57 +0100
Message-ID: <59550EA9.9070506@youngman.org.uk>
References: <20170628131917.BF1911235B6@gemini.denx.de>
 <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <38899f11-c6d2-cab7-eb25-093cfa802b40@thelounge.net>
 <CAJH6TXi8L-x7NiyAqG+22xosqAJ39LB0e_N6b-9PiMrhA2jnjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXi8L-x7NiyAqG+22xosqAJ39LB0e_N6b-9PiMrhA2jnjg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/06/17 11:14, Gandalf Corvotempesta wrote:
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

As I said, read up on disk failure modes. If mdadm finds an unreadable
sector, it does a full stripe read, recalculates the unreadable sector,
and writes it back.

If the read failed because the magnetism has decayed, this will reset it
and everything will be hunky-dory again.

If the read failed because the magnetic layer is failing, it will
trigger a relocate (which SMART should pick up) and alarm bells should
start ringing. It might be benign, the magnetic properties of the layer
might be failing such that that bit can no longer record properly, or it
could be that the layer itself is starting to fail, at which point you
are heading for platter failure, a head crash, and serious pain.

Cheers,
Wol


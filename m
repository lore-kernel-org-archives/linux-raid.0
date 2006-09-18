From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: USB disks for RAID storage (was Re: Please help me save my data)
Date: Mon, 18 Sep 2006 10:43:17 +0200
Message-ID: <62b0912f0609180143y7fb3f9d6m7024c41edb709bcd@mail.gmail.com>
References: <59430.213.136.43.252.1157976989.squirrel@webmail.adocca.com>
	 <b53b67d20609110610v5d4a63a9ube77d918b0406484@mail.gmail.com>
	 <87odtfe5l7.fsf_-_@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87odtfe5l7.fsf_-_@rimspace.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Martin Kihlgren writes:
> And no, nothing hangs except the disk access to the device
> in question when a disk fails.

Sounds good!  +1 for USB...

> My Seagate disks DO generate too much heat if I stack them on top
> of each other, which their form factor suggests they would accept.

Starts to take up a lot of space if you need to lay them out like that.

(Just for reference, I've had external USB thingys fail with just two
 drives stacked.  They both failed.)

> My RAID5 + LVM + dm_crypt + XFS setup allows for a very extendable
> system.

That does give you a cool feature set :-).

With LVM and dm_crypt in there it does sound like you're running with
beta quality software to my ears, however.  If it works, great.

> And as long as I treat the entire disk set as one device, the
> bandwidth will not be an issue since I will never demand more
> bandwidth from the entire array than from a single USB drive
> anyway.

Fair enough.
It would be cool to get the extra bandwidth though.

One solution is to use external SATA ("eSATA") enclosures
instead of USB enclosures.  That would both raise bandwidth, and
fix the transaction latency issue mentioned by Daniel Pittman.

There's a couple of single-disk enclosures out there that allows
to connect disks via either eSATA or USB2.  None of them seems to
come with cooling, though :-/.

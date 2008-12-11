From: Michael Brancato <mike@mikebrancato.com>
Subject: Re: status of raid 4/5 disk reduce
Date: Thu, 11 Dec 2008 10:27:22 -0500
Message-ID: <6E7F7089-9630-4A54-8E92-65B399E92D4B@mikebrancato.com>
References: <493D8A95.2020700@mikebrancato.com> <493EDF02.5090500@redwax.co.uk>  <A20315AE59B5C34585629E258D76A97C02F476F7@34093-C3-EVS3.exchange.rackspace.com>  <20081209215149.GA21523@cthulhu.home.robinhill.me.uk> <7d86ddb90812091515m1e0ee2f9w95a86ca2b56a98fe@mail.gmail.com> <493FB2AC.7000902@redwax.co.uk> <494059A4.8050702@mikebrancato.com> <A20315AE59B5C34585629E258D76A97C02FA1D78@34093-C3-EVS3.exchange.rackspace.com> <4940FCCA.1060703@anonymous.org.uk> <alpine.DEB.1.10.0812111544480.7856@uplift.swm.pp.se>
Mime-Version: 1.0 (iPhone Mail 5G77)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812111544480.7856@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Dec 11, 2008, at 9:46 AM, Mikael Abrahamsson <swmike@swm.pp.se>  
wrote:

> On Thu, 11 Dec 2008, John Robinson wrote:
>
>> But my 1U server only physically has room for 4 drives. It doesn't  
>> matter how many extra controllers I buy, I can't attach more drives.
>
> You can use a temporary external eSATA enclosure, pvmove the data if  
> you're using LVM, then take downtime when you exchange your new  
> drives into the internal drive bays (or you could even move them one  
> by one by hotremoving one drive from the eSATA enclosure into the  
> internal drive bays.

What about on a Friday, one of his drives fails, but he doesn't have  
spare hardware? If he has enough freespace he can shrink the FS and  
array size, then reshape from 4 to 3 drives to regain parity for  
protection over the weekend.

If degrading an array multiple times to support expansion by replacing  
one drive at a time is acceptable practice, why is degrading once for  
array contraction frowned upon?


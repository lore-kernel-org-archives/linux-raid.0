From: David Greaves <david@dgreaves.com>
Subject: Re: How to avoid complete rebuild of RAID 6 array (6/8 active devices)
Date: Mon, 14 Jul 2008 17:14:44 +0100
Message-ID: <487B7B74.3010903@dgreaves.com>
References: <41931C59-9A91-47A6-A81C-EC14001DA95B@gmail.com>	<20080625161357.GH23944@skl-net.de>	<18532.50062.63173.620773@notabene.brown> <48680586.609@tmr.com> <g5fam0$8oe$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <g5fam0$8oe$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias Urlichs wrote:
> On Sun, 29 Jun 2008 17:58:30 -0400, Bill Davidsen wrote:
> 
>> Of course build an array out of drives so unstable that you can't safelt
>> *run* a check is another topic.
> 
> It's a topic that needs to be addressed sooner or later, however.
> 
> Let's face it, drives do develop bad spots.
> 
> Tossing a perfectly good drive because 0.0000064% of the data cannot be
> read is wasteful (assuming a 64-kByte area of an 1-terabyte disk).

I've found that once a disk starts to go bad there is a very strong tendency for
it to continue to deteriorate.

So I don't replace disks because they have a bad sector; I replace them because
I suspect they will fail more as time goes by.

Sure, some don't - I don't want to take that chance.

David


From: "John Stoffel" <john@stoffel.org>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Mon, 4 Feb 2008 11:49:21 -0500
Message-ID: <18343.16913.671817.87174@stoffel.org>
References: <479EAF42.6010604@pobox.com>
	<18334.46306.611615.493031@notabene.brown>
	<479F07E1.7060408@pobox.com>
	<479F0AAB.3090702@rabbit.us>
	<479F331F.7080902@msgid.tls.msk.ru>
	<479F3C74.1050605@rabbit.us>
	<479F4CFC.5060305@pobox.com>
	<47A05971.1020507@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A05971.1020507@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Moshe Yudkowsky <moshe@pobox.com>, Neil Brown <neilb@suse.de>, Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>
List-Id: linux-raid.ids


David> On 26 Oct 2007, Neil Brown wrote:
>> On Thursday October 25, david@dgreaves.com wrote:
>>> I also suspect that a *lot* of people will assume that the highest superblock
>>> version is the best and should be used for new installs etc.
>> 
>> Grumble... why can't people expect what I want them to expect?


David> Moshe Yudkowsky wrote:
>> I expect it's because I used 1.2 superblocks (why
>> not use the latest, I said, foolishly...) and therefore the RAID10 --

David> Aha - an 'in the wild' example of why we should deprecate '0.9
David> 1.0 1.1, 1.2' and rename the superblocks to data-version +
David> on-disk-location :)

As the person who started this entire thread ages ago about the *poor*
naming convetion used for RAID Superblocks, I have to agree.

I'd much rather see 1.near, 1.far, 1.both or something like that added
in.

Heck, we don't have to remove the support for the old 1.0, 1.1, 1.2
names either, just make the default be something more user friendly.

C'mon, how many of you are programmed to believe that 1.2 is better
than 1.0?  But when they're not different, just just different
placements, then it's confusing.

John

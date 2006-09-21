From: linux@horizon.com
Subject: Re: scrub was Re: RAID5 Problem - $1000 reward for help
Date: 21 Sep 2006 16:20:08 -0400
Message-ID: <20060921202008.4872.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Does this test stress the discs a lot, like a resync?
>> How long does it take?
>> Can I use it on a mounted array?

> I'd like to add to this question -- does 'check' action on a RAID5 array
> verify the accuracy of parity data, blindly read back all data, or only
> verify readability of data blocks?

The former: it reads all data and verifies the parity.

It's a bit hard to see buried in drivers/md/raid5.c:handle_stripe5(),
which is more than a little intricate.  If you search for
MD_RECOVERY_CHECK in there, you can see where it rewrites the newly
added disk if syncing or just notes the problem if checking.

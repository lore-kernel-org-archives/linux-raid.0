From: "3tcdgwg3" <3tcdgwg3@prodigy.net>
Subject: Re: How safe is software RAID compared to how safe hardware RAID is!?
Date: Tue, 18 Nov 2003 16:23:54 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <012e01c3ae33$6cde29d0$cc07a8c0@neptune>
References: <16314.40792.616508.878124@notabene.cse.unsw.edu.au><PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com> <16314.44161.438158.27514@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>, James R Bamford <jim@jimtreats.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>
>  Some people find that their IDE controller works fine until they try
>  to use RAID1.  RAID1 hits multiple discs concurrently a lot, and some
>  (few, specific) ide controllers don't appear to cope.  You probably
>  would not get that with hardware raid.  You can with software raid
>  because it is a "whole-system" thing.
>
>

Did I do anything wrong?

I didn't see RAID 1 hits multiple drives concurrently, specially for
reading.

I set up RAID 5, RAID 1 and single disk partitions on x86 machine,
kernel 2.4-18.

For 800 MB breading, RAID 5 take 2/3 of time used by single disk,
but RAID 1 take 1.1 of time used by single disk.

Thanks.


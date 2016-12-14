From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH] Use disk sector size value to set offset for reading GPT
Date: Wed, 14 Dec 2016 18:38:44 +0000
Message-ID: <585191B4.9020902@youngman.org.uk>
References: <1481195595-13140-1-git-send-email-mariusz.dabrowski@intel.com>
 <5850241B.8030007@youngman.org.uk>
 <cd102c85-a9d5-25a9-bf2c-706310b53cc6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cd102c85-a9d5-25a9-bf2c-706310b53cc6@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>, linux-raid@vger.kernel.org
Cc: jes.sorensen@redhat.com
List-Id: linux-raid.ids

On 14/12/16 11:04, Mariusz Dabrowski wrote:
> Hi,
> this patch affects only reading GPT from disk. It fixes minor issue when
> there
> were no warning from mdadm when user was trying to create 1-disk RAID 0
> with
> external metadata on disk with some partitions and given array size was
> smaller
> than total size of all partitions on this disk (mdadm failed to read GPT
> because it was using wrong offset).
> 
In both instances I'm thinking of, iirc, a user pulled a working array
from one machine, tried to assemble it in another, then went back to the
original machine and the GPT had disappeared.

I'm clutching a bit at straws, but when the same bug bites more than one
user, you think something must be behind it. And as you can tell from
the scenario I describe, nothing *should* have been writing to disk, yet
the disk got corrupted.

> I couldn't reproduce those incidents so I can't tell that this patch
> fixes the
> root cause of this issue.

It'll have to stay on the "mysterious" list then :-)
> 
> Regards,
> Mariusz

Cheers,
Wol


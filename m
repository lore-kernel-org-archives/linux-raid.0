From: David Rees <drees76@gmail.com>
Subject: Re: Thoughts on using SSD
Date: Thu, 26 Mar 2009 17:51:47 -0700
Message-ID: <72dbd3150903261751r911114ak16b2f9cd0d1da191@mail.gmail.com>
References: <49CC0B0D.5000904@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49CC0B0D.5000904@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 26, 2009 at 4:09 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> If I were to create a small raid device, raid1, made of the 4GB Ssd and 4GB
> of SATA space, if I made the SATA write-mostly and write-behind, and put the
> journal for my raid arrays (and bitmaps?) that seems likely to provide a
> significant performance gain in small storage.
>
> Am I missing anything here? Is there an obvious drawback I'm missing?

Yeah, the fact that it doesn't seem to be possible to take advantage
of the write-behind feature? :-p

Besides fsync, I think it may have something to do with barriers.  As
in, when you flush a barrier, that causes entire cache to get flushed
to disk, including your write-behind disk.

Hopefully Neil can chime in here.  I found this thread from a while
back which seemed relevant, but I haven't been able to digest the
whole thing yet: http://lkml.org/lkml/2007/5/25/71

-Dave

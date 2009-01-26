From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: [PATCH 0/2] md: More block -> sector conversions.
Date: Mon, 26 Jan 2009 16:31:12 +0100
Message-ID: <497DD740.8080306@rabbit.us>
References: <1232982852-32747-1-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1232982852-32747-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andre Noll wrote:
> These two patches against Neil's for-next tree make the internal
> representaions of mddev->size and rdev->size sector-based.
> checkpatch.pl is happy with both patches, and the patched kernel
> passes all tests of the mdadm test suite on my i386 UP box.
> 
> Please review.
> 
> BTW: This completes the block -> sector conversion of the md code base
> because all remaining block-based quantities are either user-visible
> (via sysfs) or describe on-disk formats (version 0.90 superblocks)
> and hence can not be changed without breaking user space.
> 
> Andre
> 

Hi Andre,

Is it possible that the following issue is related to your earlier
patches: http://marc.info/?l=linux-raid&m=123202024116493&w=2

Thanks

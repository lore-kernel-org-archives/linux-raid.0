From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Metadata > 0.90 and auto-assemble
Date: Sun, 22 Feb 2015 14:19:36 -0800
Message-ID: <CAK2H+ee=vJi4vv84bBubrZ8cmyEYJjdCO=e==KE-MkPtm3ngcA@mail.gmail.com>
References: <54EA25D3.8020300@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54EA25D3.8020300@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Kinard <kumba@gentoo.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Feb 22, 2015 at 10:54 AM, Joshua Kinard <kumba@gentoo.org> wrote:
> Hi,
>
> I tried a while back to use the newer metadata formats on my mdadm RAID5 on a
> few machines, and discovered that the kernel auto-assembly will only work with
> v0.90 metadata, not 1.0 or greater.  Is there a solid reason for this?  Based
> one what I can find regarding the differences in the metadata formats, and
> looking at the existing md code, it seems this is largely just because no one
> has had the time or motivation to change the code to support auto-assembly on
> the newer metdata formats.
>
> I am told that the "correct" solution is to embed a small initramfs to bring
> the RAID arrays online instead, before the real rootfs is loaded.  I'd like to
> avoid this if possible, as I haven't had to use an initramfs for normal booting
> in the past, as long as I stay on metadata 0.90.  So I thought I'd ask what the
> official stance is on this.
>
> Thanks!,
>
> --
> Joshua Kinard
> Gentoo/MIPS
> kumba@gentoo.org
> 4096R/D25D95E3 2011-03-28
>

I cannot speak to any of the reasons to support it or not but I'm a Gentoo
guy since late 2002 who avoided the initramfs for the longest time. I
finally bit the bullet and learned how to build it into my kernels so there are
no extra files and except for a recent problem with Gentoo devs making
changes to busybox defaults it's worked very well. The nice thing about
building it into the kernel is that old kernels continue to work perfectly as
best I can tell.

Anyway, from my perspective it was worth learning. I'm just a user type,
not a dev of any type.

Cheers,
Mark

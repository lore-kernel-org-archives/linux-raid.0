From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: how to use mkfs.ext3 "stride=" on LVM on RAID correctly?
Date: Thu, 28 Feb 2008 07:48:04 -0600
Message-ID: <cccedfc60802280548m1ecb41d0w111618d7ff1e3d98@mail.gmail.com>
References: <47C68101.4020406@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47C68101.4020406@wpkg.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Linux-Raid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, LKML <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Feb 28, 2008 at 3:38 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> Lately, I had a serious performance problem on a 1.2 TB ext3 filesystem
>  placed on LVM, which was placed on Linux RAID-5.
>
>  Luckily, it was possible to alleviate much of this problem by removing
>  internal bitmap from RAID-5 and by using anticipatory IO scheduler.
>
>
>  As suggested earlier by Theodore Tso in "very poor ext3 write
>  performance on big filesystems" thread on linux-fsdevel list, I should
>  have used "mke2fs -E stride option to make sure all of the bitmaps
>  don't get concentrated on one hard drive spindle".
>
>
>  Although the fine mkfs.ext3 manual gives some basic information on how
>  to do it if you place the whole filesystem on a RAID array, it is not
>  clear to me how it should be done correctly if I want to create a ext3
>  filesystem on LVM on RAID-5.
>
>  Any helpful hints?

I can't help with the stride stuff, as I use LVM and that makes the
stride stuff utterly useless anyway. However, a suggestion I have for
you which I found helped a great deal was to place the bitmap on some
/other/ device's filesystem (I used a /etc/bitmaps/). Obviously, don't
put it on a FS which is part of the raid, I typically divide each
device into 2 or more raids, but only if I don't have enough devices
for /system/ and /data/ -style pools.

-- 
Jon

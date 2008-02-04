From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: using update-initramfs: how to get new mdadm.conf into the /boot?
 Or is it XFS?
Date: Mon, 04 Feb 2008 15:53:13 -0600
Message-ID: <47A78949.7020803@pobox.com>
References: <47A77CC0.10807@pobox.com> <20080204210903.GD3959@baikonur.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080204210903.GD3959@baikonur.stro.at>
Sender: linux-raid-owner@vger.kernel.org
To: maximilian attems <max@stro.at>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

maximilian attems wrote:

> error 15 is an *grub* error.
> 
> grub is known for it's dislike of xfs, so with this whole setup use ext3
> rerun grub-install and you should be fine.

I should mention that something *did* change. When attempting to use 
XFS, grub would give me a note about "18 partitions used" (I forget the 
exact language). This was different than I'd remembered; when I switched 
back to using reiserfs, grub reports using 19 partitions.

So there's something definitely interesting about XFS and booting.

As an additional note, if I use the grub boot-time commands to edit root 
to read, e.g., root=/dev/sda2 or root=/dev/sdb2, I get the same Error 15 
error message.

It may be that grub is complaining about grub and resiserfs, but I 
suspect that it has a true complain about the file system and what's on 
the partitions.

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "If, after hearing my songs, just one human being is inspired to
   say something nasty to a friend, it will all have been worthwhile."
     			-- Tom Lehrer

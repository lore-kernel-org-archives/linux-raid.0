From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: block size issue when re-syncing RAID1 with ext2fs on top
Date: Tue, 17 Jan 2006 08:39:51 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0601170836430.18597@praktifix.dwd.de>
References: <20060116175549.ALLYOURBASEAREBELONGTOUS.M23957@bla.fasel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060116175549.ALLYOURBASEAREBELONGTOUS.M23957@bla.fasel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfram Schlich <lists@wolfram.schlich.org>
Cc: ext2-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 16 Jan 2006, Wolfram Schlich wrote:

> Hi,
>
> I'm experiencing a problem on a 2.2.16C37_III driven Cobalt RaQ4
> after I add a new 2nd disk to a RAID1.
>
> I'm uncertain whether this is a RAID, ext2fs or even a hardware
> issue, that's why I'm writing both to ext2-devel and linux-raid.
>
> Setup:
> - /dev/md1(hd[ab]1): ext2: /
> - /dev/md3(hd[ab]3): ext2: /var
> - /dev/md4(hd[ab]4): ext2: /home
> - /dev/md6(hd[ab]6): swap: -
>
2.2.x with raid on swap had serious problems. If the swap disk resync
you must have swap disabled. Swap on raid was only a problem during
resync, otherwise it worked fine.

Holger


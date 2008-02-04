From: maximilian attems <max@stro.at>
Subject: Re: using update-initramfs: how to get new mdadm.conf into the /boot? Or is it XFS?
Date: Mon, 4 Feb 2008 22:09:03 +0100
Message-ID: <20080204210903.GD3959@baikonur.stro.at>
References: <47A77CC0.10807@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47A77CC0.10807@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 04, 2008 at 02:59:44PM -0600, Moshe Yudkowsky wrote:
> Problem: on reboot, the I get an error message:
> 
> root (hd0,1)  (Moshe comment: as expected)
> Filesystem type is xfs, partition type 0xfd (Moshe comment: as expected)
> kernel /boot/vmliuz-etc.-amd64 root=/dev/md/boot ro
> 
> Error 15: File not found
> 

error 15 is an *grub* error.

grub is known for it's dislike of xfs, so with this whole setup use ext3
rerun grub-install and you should be fine.

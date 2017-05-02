From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Big-endian RAID5 recovery problem
Date: Tue, 2 May 2017 13:59:34 +0500
Message-ID: <20170502135934.59548e17@natsu>
References: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Thompson <athompso@athompso.net>
Cc: MUUG Roundtable <roundtable@muug.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 01 May 2017 16:39:07 -0500
Adam Thompson <athompso@athompso.net> wrote:

> I can't find any modern big-endian Linux systems... looks like all the 
> ARM distros run in little-endian mode.

Here are QEMU images for debian-mips (should be big-endian, as opposed to
debian-mipsel): https://people.debian.org/~aurel32/qemu/mips/

Of course it will run purely in software, but most likely more than fast enough
to copy away the data.

Not entirely sure that particular emulated MIPS system support more than 4
drives), but it appears that a starting point could be (man qemu-system):

           Instead of -hda, -hdb, -hdc, -hdd, you can use:

                   qemu-system-i386 -drive file=file,index=0,media=disk
                   qemu-system-i386 -drive file=file,index=1,media=disk
                   qemu-system-i386 -drive file=file,index=2,media=disk
                   qemu-system-i386 -drive file=file,index=3,media=disk

with indexes 0..5, as you need the boot disk, all 4 drives, and one more as
the backup destination.

May or may not be the best way, but IMO beats trying to hex-edit the
superblock right away.

-- 
With respect,
Roman

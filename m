From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Deleting mdadm RAID arrays
Date: Tue, 05 Feb 2008 16:52:18 +0300
Message-ID: <47A86A12.2090405@msgid.tls.msk.ru>
References: <200802051142.19625.admin@domeny.pl> <20080205132717.238c4312@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080205132717.238c4312@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Marcin Krol said:     (by the date of Tue, 5 Feb 2008 11:42:19 +0100)
> 
>> 2. How can I delete that damn array so it doesn't hang my server up in a loop?
> 
> dd if=/dev/zero of=/dev/sdb1 bs=1M count=10

This works provided the superblocks are at the beginning of the
component devices.  Which is not the case by default (0.90
superblocks, at the end of components), or with 1.0 superblocks.

  mdadm --zero-superblock /dev/sdb1

is the way to go here.

> I'm not using mdadm.conf at all. Everything is stored in the
> superblock of the device. So if you don't erase it - info about raid
> array will be still automatically found.

That's wrong, as you need at least something to identify the array
components.  UUID is the most reliable and commonly used.  You
assemble the arrays as

  mdadm --assemble /dev/md1 --uuid=123456789

or something like that anyway.  If not, your arrays may not start
properly in case you shuffled disks (e.g replaced a bad one), or
your disks were renumbered after a kernel or other hardware change
and so on.  The most convient place to store that info is mdadm.conf.
Here, it looks just like:

DEVICE partitions
ARRAY /dev/md1 UUID=4ee58096:e5bc04ac:b02137be:3792981a
ARRAY /dev/md2 UUID=b4dec03f:24ec8947:1742227c:761aa4cb

By default mdadm offers additional information which helps to
diagnose possible problems, namely:

ARRAY /dev/md5 level=raid5 num-devices=4 UUID=6dc4e503:85540e55:d935dea5:d63df51b

This new info isn't necessary for mdadm to work (but UUID is),
yet it comes handy sometimes.

/mjt

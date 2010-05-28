From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: My Thecus RAID-0 filesystem unmountable with mdadm. Please help.
Date: Thu, 27 May 2010 18:32:11 -0700
Message-ID: <AANLkTik-6jdBkYGE9z8i4lBgt2MERWz_N5CnTgAlmCcT@mail.gmail.com>
References: <AANLkTimDAbGPqen2dW7wtpxMjSup0IK8kcdNEnskibw-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimDAbGPqen2dW7wtpxMjSup0IK8kcdNEnskibw-@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Reniau <david.reniau@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was suggesting the hexdump utility to determine several things:

1) Which disk contained the extfs magic header (thus the first disk in
almost all cases)
2) Where the start of that header was, which would /typically/ begin
after 1kb of padding (it's there for other things to use in some
cases).
3) If created properly, the extfs header /may/ give you a suggested
stripe/chunk size.

As an example...

http://www.virtualblueness.net/Ext2fs-overview/Ext2fs-overview-0.1-12.html
http://www.monstrmoose.com/repository/Halo_Tools/Etc/WinHex_15.1/Ext%20Superblock.tpl

(0x400 == 1024)

Looking at the blocks, in the standard output the 'magic signature'
should be in the 4th row, starting halfway across, which it is for
even ext4 filesystems.  Typically, but not always, there is
zero-filled padding around this area; as denoted by the line of 0s and
then the * indicating that the last line repeats until the next
address.

hexdump -Cn2048 /dev/mapper/lin-lucid--root_crypt
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000400  90 97 05 00 ff 56 16 00  f3 1d 01 00 a3 4b 04 00  |.....V.......K..|
00000410  2f 95 02 00 00 00 00 00  02 00 00 00 02 00 00 00  |/...............|
00000420  00 80 00 00 00 80 00 00  d0 1f 00 00 ec 1e e6 4b  |...............K|
00000430  32 d3 e0 4b 11 00 1f 00  53 ef

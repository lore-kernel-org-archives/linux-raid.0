From: "Eric Wood" <eric@interplas.com>
Subject: Re: does ext3 trample on mkraid superblocks and visa-versa?
Date: Thu, 11 Sep 2003 13:33:15 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <039101c3788a$c8269ea0$9100000a@intgrp.com>
References: <107a01c376fe$a29bdc00$9100000a@intgrp.com> <03dd01c377d1$a28c9be0$9100000a@intgrp.com> <Pine.LNX.4.53.0309101442180.1812@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm still trying to find out if I *must* remove the ext3 journal (tune2fs -O
^has_journal /dev/hdaN) before going through the RAID setup.  I'm guess it
would be trivial to convert back anyway, as I don't see any documentation
stating the mkraid (or resize2fs, or mdadm) doesn't clobber the ext3
journals.  Then again ext3 simple keeps it's journal in a .journal file or a
hidden inode file as opposed the far end block - so the conversion back to
ext2 doesn't seem to be neccessary.

Whew... thanks for the info. I'm learning!  Sounds like some insight from
Stephen Tweedie or Theodore Ts'o is needed.
-eric wood

dean gaudet wrote:
> the "easiest" way to do this is probably as follows (from a bootable
> rescue CD, i don't think you want to attempt this live):
>
> - resize2fs the filesystem (via the /dev/hdaN or whatever partition
>   device) to be 1MB smaller (be careful to use the right
>   "blocks" here -- resize2fs blocks are the same size as the
>   filesystem blocks, so most likely 4096 bytes, but could be 1024
>   bytes in some cases... tune2fs -l is your friend.)


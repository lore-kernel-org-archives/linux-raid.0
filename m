From: "Eric Wood" <eric@interplas.com>
Subject: does ext3 trample on mkraid superblocks and visa-versa?
Date: Wed, 10 Sep 2003 15:27:55 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <03dd01c377d1$a28c9be0$9100000a@intgrp.com>
References: <107a01c376fe$a29bdc00$9100000a@intgrp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I wanted to reword my previous email a little different to hopefully get a
response on this issue.

If I want to mirror an existing ext3 filesystem, then I would
"mkraid --really-force /dev/md0".  Then /dev/hda1 would copy over to
/dev/hdc1 because /dev/hda1 is raid-disk 0  and /dev/hdc1 is raid-disk 1.
If I had cross up this priority number in the raidtab file, then mkraid
would have copied /dev/hdc1 over top of /dev/hda1 which would be a boo-boo.

Now as I understand it, mkraid adds a superblock at the far-end block of the
partition (whether or not that block is within the filesystem.  It looks
like ext2 needs to be, but does ext3 need to be fsck'd and resized to
protect this block?  Or does ext3 automatically see a raid superblock there
and help protect it without fck'ing and resizing.  Or do you have to
tune2fs -o ^nojournal the filesystem back into an ext2 system because ext3,
journal block, mkraid, and raid superblocks step on each other's toes?

-Eric Wood

Eric Wood wrote:
> http://unthought.net/Software-RAID.HOWTO/Software-RAID.HOWTO-4.html#ss4.14
> 4. Sect. 4.14.14.  Do I first have to convert from ext3 back to ext2?
> Since I use ext3 does this step still apply or does mkraid add the
> second superblock in an acceptable manor for ext3?  Do I still have
> to resize2fs the md devices?


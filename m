From: "John Robinson" <john.robinson@anonymous.org.uk>
Subject: Re: Converting ext3 to RAID1 ...
Date: Tue, 25 Aug 2009 02:42:48 +0100 (BST)
Message-ID: <54326.86.132.166.70.1251164568.squirrel@www.yuiop.co.uk>
References: <b7b14cbb0908241424i50bdcf59p35a63e4496b108ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b7b14cbb0908241424i50bdcf59p35a63e4496b108ca@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 24 August, 2009 10:24 pm, Clinton Lee Taylor wrote:
> Greetings ...
>
> I asked this question about two weeks ago
>
> http://www.issociate.de/board/post/498227/Ext3_convert_to_RAID1_....html
>
>   and have had not response, so I am going to try and re-phrase and
> hope that somebody can confirm my test case. Thanks.
>
> Wanting to convert an already created and populated ext3 filesystem.
>
> I unmounted the filesystem, ran e2fsck -f /dev/sdb1 to check that the
> current filesystem had no errors.
> Then ran mdadm --create /dev/md0 --level=1 -n 1 /dev/sdb1 --force to
> create the RAID1 device, answered yes to the question.

This rang alarm bells for me, so I checked your link above, and apparently
you shrunk the filesystem before doing this. If you shrink the filesystem,
and use a metadata version that puts the metadata at the end - as you did
by default in this case using version 0.90 - then your method is fine and
quite safe. If you don't shrink the filesystem, which you didn't mention
here, you'd be asking for a world of pain.

Another surer method (making no assumptions about metadata version) when
you've two identically-sized partitions, the original and the new mirror,
is to mdadm --create /dev/mdX --level=1 -n 1 /dev/secondpartition ; mkfs
-t Y /dev/mdX ; mount -t Y /dev/mdX /scratch ; mount -o remount,ro /path ;
cp -a /path/* /scratch ; umount /scratch ; sed -i~ -e
's?/dev/originalpartition?/dev/mdX?' /etc/fstab ; umount /path ; mount
/path ; mdadm -add /dev/mdX /dev/originalpartition

That's slightly more like what the wiki article suggests, but still not
enough for your root filesystem or booting; they're being properly
exhaustive on converting from a 1-drive system to a 2-drive RAIDed one,
making sure you've no assumptions (apart from it being CentOS 5), it works
for your root filesystem and makes sure you end up with both drives
bootable.

Cheers,

John.


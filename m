From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 03 Mar 2004 10:36:15 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4045FB6F.7D934181@SteelEye.com>
References: message from Chris Evans on Wednesday March 3 <4045A154.12266.4B21C5B@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Chris Evans <chris1@psyctc.org>
Cc: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Evans wrote:

> a) confirm or deny my hunch that the ext2/ext3 issue is normal?

A reasonable hunch, but no, it is not normal for an ext3 root fs to show
up as ext2 in /proc/mounts:

# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / ext3 rw 0 0
/proc /proc proc rw 0 0
[snip]

Perhaps you don't have ext3 support built in to the kernel? If not,
you'll need an initrd to boot your root fs as ext3.


As far as the active inodes on /dev/hdb1, one thing you might try is:

fuser -vm /dev/hdb1

If there's a process accessing /dev/hdb1, it will be listed.

--
Paul

From: Juri Haberland <list-linux.raid@spoiled.org>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Thu, 4 Mar 2004 18:56:10 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <news2mail-c27u4a$cch$1@cartman.spoiled.org>
References: <4045A154.12266.4B21C5B@localhost> <4045FB6F.7D934181@SteelEye.com>
Reply-To: Juri Haberland <juri@koschikode.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements <Paul.Clements@steeleye.com> wrote:
> Chris Evans wrote:
> 
>> a) confirm or deny my hunch that the ext2/ext3 issue is normal?
> 
> A reasonable hunch, but no, it is not normal for an ext3 root fs to show
> up as ext2 in /proc/mounts:
> 
> # cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/root / ext3 rw 0 0
> /proc /proc proc rw 0 0
> [snip]

No, it is normal. It happens, when /etc/fstab still contains ext2 as fs-type
for the root-fs. I don't recall the exact reason, but it has something
to do with the fact that the mount command normally updates /etc/mtab
when a filesystem is mounted. As the root-fs is first mounted read-only,
mount cannot update /etc/mtab. When the root-fs gets remounted
read-write, mount updates /etc/mtab, but (I think) has at that stage no
clue of what filesystem type the root-fs is and therefore uses the entry
from /etc/fstab. For an authorative answer search the mailing list archive
from the ext3 mailing list.

Regards,
Juri

-- 
Juri Haberland  <juri@koschikode.com> 


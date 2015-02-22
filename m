From: Joshua Kinard <kumba@gentoo.org>
Subject: Metadata > 0.90 and auto-assemble
Date: Sun, 22 Feb 2015 13:54:11 -0500
Message-ID: <54EA25D3.8020300@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I tried a while back to use the newer metadata formats on my mdadm RAID5 on a
few machines, and discovered that the kernel auto-assembly will only work with
v0.90 metadata, not 1.0 or greater.  Is there a solid reason for this?  Based
one what I can find regarding the differences in the metadata formats, and
looking at the existing md code, it seems this is largely just because no one
has had the time or motivation to change the code to support auto-assembly on
the newer metdata formats.

I am told that the "correct" solution is to embed a small initramfs to bring
the RAID arrays online instead, before the real rootfs is loaded.  I'd like to
avoid this if possible, as I haven't had to use an initramfs for normal booting
in the past, as long as I stay on metadata 0.90.  So I thought I'd ask what the
official stance is on this.

Thanks!,

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
4096R/D25D95E3 2011-03-28

"The past tempts us, the present confuses us, the future frightens us.  And our
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic

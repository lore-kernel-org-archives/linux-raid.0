From: Masaki Chikama <masaki-c@is.aist-nara.ac.jp>
Subject: kernel upgrade problem on alpha arch.
Date: Tue, 29 Oct 2002 20:11:58 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210291111.UAA02221@dec120.aist-nara.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.

I had two raid problem when upgrade kernel from 2.2(2.2.19aa1, which
includes raid patch) to 2.4(2.4.20pre11) on alpha architecture.

The one is the raid superblock incompatibility. This is the same problem
when Neil Brown added --sparc2.2 option to mdadm. I found it by
Google and downloaded mdadm-1.0.1, then I broke superblock ;-) .
Please release mdadm-1.0.2 soon that fix the --sparc2.2 option
problem mentioned in the flowing mail.

http://marc.theaimsgroup.com/?l=linux-raid&m=102198306132665&w=2

After I recovered the superblock, I got another problem. It is the
checksum of superblock incompatibility between mdadm and kernel.

The checksum routine of raid superblock in kernel is
linux/driver/md/md.c            check_disk_sb ->
                                calc_sb_csum  ->
linux/arch/alpha/lib/checksum.c csum_partial  ->
                                do_csum
and it generates BAD_CSUM warning against mdadam's generating csum.

It may be a compiler problem.
$ gcc -v
Reading specs from /usr/lib/gcc-lib/alpha-redhat-linux/2.96/specs
gcc version 2.96 20000731 (Red Hat Linux 7.1 2.96-85)

I can successfully recovered the raid partition. But I hope
these problem are solved.

Best Regards.

(I'm not on the list, so please Cc: if you replay)
-----------------------------------
CHIKAMA Masaki @ NAIST
E-Mail: masaki-c@is.aist-nara.ac.jp

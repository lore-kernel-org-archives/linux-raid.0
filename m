From: Cry <cry_regarder@yahoo.com>
Subject: Re: Two Drive Failure on RAID-5
Date: Thu, 22 May 2008 00:05:22 +0000 (UTC)
Message-ID: <loom.20080522T000506-188@post.gmane.org>
References: <loom.20080519T224713-779@post.gmane.org> <4832966A.3010707@dgreaves.com> <loom.20080521T140522-597@post.gmane.org> <483482E2.60300@dgreaves.com> <09ed01c8bb83$ec3f7230$9300a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janos Haar <janos.haar <at> netcenter.hu> writes:

> Cry i only have this idea:
> dd_rescue -v -m 128k -r /dev/source -S 128k superblock.bin
> losetup /dev/loop0 superblock.bin
> mdadm --build -l linear --raid-devices=2 /dev/md1 /dev/sdg1 /dev/loop0

Janos,

The correct information should already be in /dev/sdg1 since I copied the entire
/dev/sda there (probably overwrote stuff in /dev/sdg2 since /dev/sda was 160K
bigger than /dev/sdg1).

This means I the superblock should already be there at the start of /dev/sdg1.
so the steps above should result in two superblocks being stacked back to back?

should I use an losetup offset into /dev/sdg1 to get to the real data and bypass
the MBR copied in from /dev/sda?  I am a bit confuse don how these things are
laid out.

Where on the disk does the information printed from mdadm -E /dev/sda and mdadm
-E /dev/sdg1 come from?

Thanks!

Cry



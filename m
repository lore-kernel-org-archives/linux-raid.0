From: <robin-lists@robinbowes.com>
Subject: RE: AW: Stupid Question?
Date: Tue, 25 May 2004 00:11:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S264409AbUEXXLR/20040524231117Z+335@vger.kernel.org>
References: <16562.32290.124423.951804@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16562.32290.124423.951804@cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> I often RAID1 a pair of whole devices, partition them into
> root/swap/rest and boot off them (this is using md partitioning code
> which isn't in 2.4, but is in 2.6).  There is a problem here that lilo
> thinks it knows all about md arrays.  However I figured out how to
> trick it into not realising they are md arrays and it works fine (I
> create a symlink from /dev/MD* -> /dev/md* and only tell lilo about
> /dev/MD*).

Neil,

Would you care to elaborate?

I'm about to build a box with 6 x 250GB SATA disks and am currently
designing the partitioning scheme.

Could I potentially put in a small IDE disk onto which to install just
enough system to boot and mount a RAID5 array built from the 6 whole disks?

Presumably you then partition the RAID array, create the filesystems and
mount the partitions as you would a single disk?

Thanks,

R.


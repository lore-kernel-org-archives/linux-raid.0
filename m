From: CaT <cat@zip.com.au>
Subject: 2+ raid sets, sata and a missing hd question
Date: Wed, 15 Feb 2006 13:45:21 +1100
Message-ID: <20060215024521.GD8282@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Lets say I have the following setup:

RAID 1 (as md1, md2, md3, md4, md5 for eg)
sda, sdb

RAID 5 (as md6)
sdc, sdd, sde, sdf, sdg

Seeing as how SATA drives can move around if one removes one from a set
(ie given sda, sdb, sdc, if sdb was removed sdc drops to sdb) would md6
come back up without problems if I were to remove either sda or sdb.

All md partitions are of type fd (Linux raid autodetect).

Thanks. :)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby

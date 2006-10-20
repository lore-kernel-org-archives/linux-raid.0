From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 4] md: Introduction - bugfix patches for md.
Date: Fri, 20 Oct 2006 13:25:23 +1000
Message-ID: <20061020120612.29297.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

Following are 4 bugfix patches for md.
The first is suitable for 2.6.18.2.  All are suitable for 2.6.19.

Thanks,
NeilBrown


 [PATCH 001 of 4] md: Fix calculation of ->degraded for multipath and raid10
 [PATCH 002 of 4] md: Add another COMPAT_IOCTL for md.
 [PATCH 003 of 4] md: Endian annotation for v1 superblock access.
 [PATCH 004 of 4] md: Endian annotations for the bitmap superblock

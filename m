From: Jan Engelhardt <jengelh@medozas.de>
Subject: RE: Mechanism to safely force repair of single md stripe w/o hurting
 data integrity of file system
Date: Mon, 26 May 2008 13:17:32 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805261316400.19084@fbirervta.pbzchgretzou.qr>
References: <200805172026.m4HKQwh06910@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200805172026.m4HKQwh06910@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'David Lethe' <david@santools.com>, 'LinuxRaid' <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


On Saturday 2008-05-17 22:26, Guy Watkins wrote:
>
>I thought this would cause md to read all blocks in an array:
>echo repair > /sys/block/md0/md/sync_action
>
>And rewrite any blocks that can't be read.
>
>In the old days, md would kick out a disk on a read error.  When you added
>it back, md would rewrite everything on that disk, which corrected read
>errors.

With a read bitmap (`mdadm -G /dev/mdX -b internal`, or during -C),
it should resync less after an unwarranted kick.

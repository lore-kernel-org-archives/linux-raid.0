From: travis+ml-linux-raid@subspacefield.org
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 1 Sep 2016 19:18:07 -0700
Message-ID: <20160902021807.GS32250@subspacefield.org>
References: <20160823050947.GL32250@subspacefield.org>
 <CAJCQCtSY=D-ASQ22km8GJjfju4jUgJSOBTAH5+XveCZq1BvT7w@mail.gmail.com>
 <20160825062501.GN32250@subspacefield.org>
 <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
 <20160826025012.GO32250@subspacefield.org>
 <CAJCQCtRwF1XCNQRxibFGZ0SVQ8=RKo1birv5ZWZBvZGpuu0ndQ@mail.gmail.com>
 <20160826035850.GQ32250@subspacefield.org>
 <20160826040619.GR32250@subspacefield.org>
 <CAJCQCtQLLJEoovBtks0ft9XArHwwZTMqBGobW5WavsQydbqSBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJCQCtQLLJEoovBtks0ft9XArHwwZTMqBGobW5WavsQydbqSBQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 25, 2016 at 10:25:35PM -0600, Chris Murphy wrote:
> Well that file does seem stale, because those partitions aren't
> actually part of LVM. They're members of an mdadm array. I don't know
> where LVM comes into this because we don't have the complete layout.

md127 = /dev/sd{b,c,d,e}1
LUKS on that
PV/VG/LV on that.

/dev/sda5 is also a LUKS partition with LVM on it for root.

I wonder if it's possible that whatever restored a GPT also restored a
LVM header, and somehow that picked it up?

Anyway, after doing bitwise backups of disks, I did a create
--assume-clean with --level=raid0 and the thing seems fine.

# fsck /dev/V_hostname/L_bu
fsck from util-linux 2.20.1
e2fsck 1.42 (29-Nov-2011)
/dev/mapper/V_hostname-L_bu contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #67095 (65535, counted=0).
Fix<y>? yes

Free blocks count wrong (496207637, counted=496207638).
Fix<y>? yes

And that was pretty much it.
-- 
http://www.subspacefield.org/~travis/ | if spammer then john@subspacefield.org
"Computer crime, the glamor crime of the 1970s, will become in the
1980s one of the greatest sources of preventable business loss."
John M. Carroll, "Computer Security", first edition cover flap, 1977

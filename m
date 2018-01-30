From: David Brown <david.brown@hesbynett.no>
Subject: Multi-layer raid status
Date: Tue, 30 Jan 2018 16:30:22 +0100
Message-ID: <5A708F8E.2040604@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Does anyone know the current state of multi-layer raid (in the Linux md
layer) for recovery?

I am thinking of a setup like this (hypothetical example - it is not a
real setup):

md0 = sda + sdb, raid1
md1 = sdc + sdd, raid1
md2 = sde + sdf, raid1
md3 = sdg + sdh, raid1

md4 = md0 + md1 + md2 + md3, raid5


If you have an error reading a sector in sda, the raid1 pair finds the
mirror copy on sdb, re-writes the data to sda (which re-locates the bad
sector) and passes the good data on to the raid5 layer.  Everyone is
happy, and the error is corrected quickly.

Rebuilds are fast as single disk copies.


However, if you have an error reading a sector in sda /and/ when reading
the mirror copy in sdb, then the raid1 pair has no data to give to the
raid5 layer.  The raid5 layer will then read the rest of the stripe and
calculate the missing data.  I presume it will then re-write the
calculated data to md0, which will in turn write it to sda and sdb, and
all will be well again.


But what about rebuilds?  A rebuild or recovery of the raid1 layer is
not triggered by a read from the raid5 level - it will be handled at the
raid1 level.  If sda is replaced, then the raid1 level will build it by
copying from sdb.  If a read error is encountered while copying, is
there any way for the recovery code to know that it can get the missing
data by asking the raid5 level?  Is it possible to mark the matching sda
sector as bad, so that a future raid5 read (such as from a scrub) will
see that md0 stripe as bad, and re-write it?





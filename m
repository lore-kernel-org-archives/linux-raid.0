From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 11:48:05 -0700
Message-ID: <21000728-017E-4D06-B3B6-5A296BBC0A2F@colorremedies.com>
References: <14319197.21.1353936449959.JavaMail.root@zimbra> <50B48BAA.8060903@hesbynett.no>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B48BAA.8060903@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 27, 2012, at 2:45 AM, David Brown <david.brown@hesbynett.no> wrote:

> My first thought when reading the paper in question is that it doesn't really add much that is actually useful.  md does not need checksums - it already has a more powerful system for error detection and correction through the parity blocks.  If you want more checksumming than raid5 gives you, then use raid6.

parity != checksum

Reading a data block in, computing a checksum and comparing it to a previously written checksum for that same data block, is much less expensive than the choices you have with parity. Reading a data block in, computing parity, reading previously written parity, comparing the two; or, reading data block, and using parity to reconstruct data, and comparing the two data streams.

Further in the case of raid5 single parity, it's ambiguous whether a bit error is attributable to parity or the data. Which is wrong? You don't actually know. With raid6 dual parity, there is no ambiguity if both sets of parity are used to reconstruct data and are compared to each other rather than one being blindly trusted, or more cheaply is to reconstruct the data once from either set of parity, compute a checksum and compare to the written checksum.

So there is still a role for checksums, the question is whether this is better or equally managed at a file system level vs an md level. The checksumming with RAID applications today are file system level in ZFS and btrfs (and maybe ReFS).

Chris Murphy


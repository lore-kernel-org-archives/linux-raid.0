From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 12:36:34 -0700
Message-ID: <DF6D0FEA-6098-49AC-938E-7E8C42AF5B73@colorremedies.com>
References: <14319197.21.1353936449959.JavaMail.root@zimbra> <50B48BAA.8060903@hesbynett.no> <21000728-017E-4D06-B3B6-5A296BBC0A2F@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21000728-017E-4D06-B3B6-5A296BBC0A2F@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 27, 2012, at 11:48 AM, Chris Murphy <lists@colorremedies.com> wrote:

> Further in the case of raid5 single parity, it's ambiguous whether a bit error is attributable to parity or the data. Which is wrong? You don't actually know. With raid6 dual parity, there is no ambiguity if both sets of parity are used to reconstruct data and are compared to each other rather than one being blindly trusted, or more cheaply is to reconstruct the data once from either set of parity, compute a checksum and compare to the written checksum.

Also a parity only solution, is in effect a RAID 6+ (dual+ parity) solution. RAID5 and lower are left out. And since RAID 10 and RAID 1+linear are scalable and parity solutions aren't, I think that a solution that works for them from the outset needs consideration.


Chris Murphy


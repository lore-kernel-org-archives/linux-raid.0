From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: SMP and 3ware cards and 2.6 kernel
Date: Sun, 30 May 2004 14:39:39 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405301437260.14297-100000@sweetums.bluetronic.net>
References: <dc.bd52705.2deb46cf@aol.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dc.bd52705.2deb46cf@aol.com>
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 30 May 2004 AndyLiebman@aol.com wrote:
>I have a Supermicro X5DPE-G2 motherboard, a single Xeon 3.06 Ghz processor, 2
>GB RAM. I have eight 250 GB Maxtor SATA drives assembled into one 2 TB
>Hardware RAID-5 array.

If the MB supports "spread spectrum" (it'll be in one of the BIOS chipset
menus), turn it off.  I've seen it cause too many PCI/memory issues to
be of any value.  if has nothing to do with machine speed; it's an RF
emissions thing.

--Ricky



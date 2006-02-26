From: Moses Leslie <moses@flyingcroc.net>
Subject: Re: silent corruption with RAID1
Date: Sun, 26 Feb 2006 09:39:21 -0800 (PST)
Message-ID: <20060226013501.H4550@fincher.users.accretive-networks.net>
References: <20060225182714.F4550@fincher.users.accretive-networks.net>
 <20060226082209.GH7030@skl-net.de> <20060226005533.K4550@fincher.users.accretive-networks.net>
 <20060226090552.GI7030@skl-net.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060226090552.GI7030@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 26 Feb 2006, Andre Noll wrote:

> > Are there any workarounds?  It seems odd that raid1 would be the only
> > thing that has a problem.
>
> You could add your drive to the blacklist just to see if that makes any
> difference.

Unfortunately, it didn't make any difference.  After adding in the drive
IDs, they're identified correctly:

ata1(0): applying Seagate errata fix
ata2(0): applying Seagate errata fix

but I still get the corruption on md1 (sda1 + sdb1 in raid 1) but not on
either sda1 or sdb1 when the raid is shut down and the partitions are used
individually.

As a new test I made two raid1s, sda1+sda2 and sdb1+sdb2, and did the same
tests with both of them at once and there was no corruption.

Moses


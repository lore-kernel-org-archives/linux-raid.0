From: Lajber Zoltan <lajbi@lajli.gau.hu>
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports Raid
 Level Migration and Online Capacity Expansion
Date: Fri, 23 Dec 2005 00:02:24 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0512222359390.13179@lajli.gau.hu>
References: <200512221707.jBMH7PCS028943@cichlid.com>
 <17323.2382.350576.347316@smtp.charter.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17323.2382.350576.347316@smtp.charter.net>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Andrew Burgess <aab@cichlid.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Dec 2005, John Stoffel wrote:

> I've been tempted by XFS at times, but I worry, esp since alot of
> other people who are core developers don't care for XFS as much.  But
> maybe I'll move that way for my next system.

We use xfs since 2.6.x in production. Typical config for us:
/ in raid1, ext3
swap in raid1
lvm2 for the remaining with XFS above it.

The lvm2 array raid1 or raid5. If raid1, the / and swap have hot spare
partitions.

The main reason for this is that you can't have boot block in XFS.

Bye,
-=Lajbi=----------------------------------------------------------------
 LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
 Most of the time, if you think you are in trouble, crank that throttle!

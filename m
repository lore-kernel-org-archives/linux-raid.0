From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: How to handle >16TB devices on 32 bit hosts ??
Date: Sat, 18 Jul 2009 19:54:50 -0500
Message-ID: <20090719005450717.VSFW5000@cdptpa-omta04.mail.rr.com>
References: <20090718142156.GC2682@basil.fritz.box>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090718142156.GC2682@basil.fritz.box>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> There are regular reports of xfs_repair failing on 32bit,
> even on volumes far smaller than 16TB.

	But is that due to the 32 bit system directly, or to the fact XFS
requires a huge amount of memory for fsck or repair?  xfs_fxck would not
complete on one of my systems with 2G of RAM and 10G of swap, because it ran
out of memory after filling up the entire swap space.  I replaced the 10G
swap with a 750G swap and it completed just fine.


From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on software raid 5
Date: Mon, 30 Jul 2007 21:39:39 +0200
Message-ID: <E1IFb5f-00006O-00@dorka.pomaz.szeredi.hu>
References: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan> <200707302207.02672.a1426z@gawab.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <200707302207.02672.a1426z@gawab.com> (message from Al Boldi on
	Mon, 30 Jul 2007 22:07:02 +0300)
Sender: linux-fsdevel-owner@vger.kernel.org
To: a1426z@gawab.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Extrapolating these %cpu number makes ZFS the fastest.
> 
> Are you sure these numbers are correct?

Note, that %cpu numbers for fuse filesystems are inherently skewed,
because the CPU usage of the filesystem process itself is not taken
into account.

So the numbers are not all that good, but according to the zfs-fuse
author it hasn't been optimized yet, so they may improve.

Miklos

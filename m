From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Kernel panic, FS corruption  Was: Re: Call for RAID-6 users
Date: Thu, 5 Aug 2004 23:54:30 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <ceuhbm$rgs$1@terminus.zytor.com>
References: <cds76e$ee7$1@terminus.zytor.com> <200407310228.27969.maarten@ultratux.net> <200408011503.20452.maarten@ultratux.net> <20040801180536.GA3897@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <20040801180536.GA3897@jim.sh>
By author:    Jim Paris <jim@jtan.com>
In newsgroup: linux.dev.raid
>
> > I eventually got a kernel panic when copying large amounts of data to a 
> > [degraded] raid6 array, which this time was the full 600 GB size.
> > Don't know if it is helpful to anyone but info below:
> 
> The panic is from reiserfs, and it's occuring because the FS is
> getting corrupted due to the raid6 problems.
> 

It's still very odd to me that so far the only thing that triggers
this kind of problems is reiserfs.  Either reiserfs just has a really
odd series of access patterns, or it is relying on behaviour which
isn't actually guaranteed.  I suspect the former, but it's still odd.

	-hpa

From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: how to which to bigger disk (md can do it?)
Date: Mon, 17 Nov 2003 20:51:07 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16312.39435.330127.598268@notabene.cse.unsw.edu.au>
References: <3FB75992.3020608@bnap.hu>
	<20031117092922.GD30745@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Monday November 17
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 17, bluca@comedia.it wrote:
> 
> Really weird idea: please do not do it on real data.
> You will probably shoot yourself doing this
> - Switch the disks one by one.
> - When you are over create a new raid5 over the existing one (keeping the
> same settings for stripe size and parity algo)
> - Resize the filesystem.
> 

Not so weird - it is exactly what I was going to suggest.
Providing you get the chunk size, parity algoithm and device order
right, and use "--force" to make sure mdadm doesn't re-arrange the
devices on on it should work perfectly.

Somewhere low-down on my todo list for raid is allowing this to be
done on-line (mdadm /dev/md0 --size=max).  It is right along side
allowing the number of live devices in a raid1 to be changed 
(mdadm /dev/md1 --devices=3) and adding devices to a linear array 
(mdadm /dev/md2 --add /dev/sdd).

NeilBrown

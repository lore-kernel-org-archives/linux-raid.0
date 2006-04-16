From: Neil Brown <neilb@suse.de>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Mon, 17 Apr 2006 08:39:45 +1000
Message-ID: <17474.51121.178492.61143@cse.unsw.edu.au>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Sunday April 16
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday April 16, molle.bestefich@gmail.com wrote:
> A system with 6 disks, it was UUUUUU a moment ago, after read errors
> on a file now looks like:
> 
> /proc/mdstat:
>   md1 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[6](F) sda1[7](F)
>       level 5, 64k chunk, algorithm 2 [6/4] [__UUUU]
> 
> uname:
>   linux 2.6.11-gentoo-r4
> 
> What's the recommended approach?
> 
> Compile 2.6.16.5 and mdadm 2.4.1, install both, reboot, then use mdadm
> assemble --force (after automatic mount probably fails)?

You shouldn't need to upgrade kernel or mdadm (though you didn't
report the version of mdadm, so I cannot be sure, and upgrading won't
hurt). 

But yet, use --assemble --force and be aware that there could be data
corruption (without knowing the history it is hard to say how
likely).  An 'fsck' at least would be recommended.

NeilBrown

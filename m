From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm memory leak?
Date: Wed, 6 Jul 2005 07:23:33 +1000
Message-ID: <17098.64085.334793.282803@cse.unsw.edu.au>
References: <42CA0B7E.4040109@shlrm.org>
	<17098.4949.378512.822529@cse.unsw.edu.au>
	<20050705105229.7aisufvrk8so0ook@shlrm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Kowis on Tuesday July 5
Sender: linux-raid-owner@vger.kernel.org
To: David Kowis <dkowis@shlrm.org>
Cc: linux-raid@vger.kernel.org, Eric Sandall <eric@sandall.us>
List-Id: linux-raid.ids

On Tuesday July 5, dkowis@shlrm.org wrote:
> Quoting Neil Brown <neilb@cse.unsw.edu.au>:
> 
> > Hmmm.
> > There is an md related memory leak in 2.6.12, but I don't think it is
> > there in 2.6.11.anything.
> >
> > If 'ps' doesn't show anything, the next place to look is
> > /proc/slabinfo (which 'slabtop' might display for you).
> Slabtop:
> Active / Total Objects (% used)    : 217562 / 225483 (96.5%)
> Active / Total Slabs (% used)      : 3972 / 3972 (100.0%)
> Active / Total Caches (% used)     : 78 / 139 (56.1%)
> Active / Total Size (% used)       : 14328.78K / 15891.08K (90.2%)
> Minimum / Average / Maximum Object : 0.01K / 0.07K / 128.00K
> 
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 152098 151909  99%    0.02K    673      226      2692K fasync_cache
> 24867  24846  99%    0.05K    307       81      1228K buffer_head
> 12432   8306  66%    0.27K    888       14      3552K radix_tree_node
>   7308   6876  94%    0.13K    252       29      1008K dentry_cache
>   6303   5885  93%    0.36K    573       11      2292K reiser_inode_cache

So you have about 16 megabytes used by the slab cache, none of the big
users 'md' related. 
16M doesn't sound like a big deal, so I suspect this isn't the source
of the leak. 
 From a separate Email I see:
> # ipcs -m
------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status
0x00000000 65536      root      600        33554432   11         dest
0x0052e2c1 98305      postgres  600        10330112   11

that you have 43M is shared-memory, which is more that the slab is
using but still barely 6% of your total memory.

> Mem:    773984k total,   765556k used,     8428k free,    65812k buffers
> Swap:  2755136k total,        0k used,  2755136k free,   526632k cached

The fact that swap isn't being touched at all suggests that you aren't
currently running low on memory.
The fact the free is low doesn't directly indicate a problem.  Linux
uses free memory to cache files.  It will discard then from the cache
if it needs more memory.
The fact that the OOM killer is hiting obviously is a problem.  Maybe
you need to report this on linux-kernel was an OOM problem.

NeilBrown



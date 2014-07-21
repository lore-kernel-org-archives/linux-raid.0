From: Kenny Root <kenny@the-b.org>
Subject: Re: Possible leak during reshaping layout
Date: Mon, 21 Jul 2014 08:16:43 -0700
Message-ID: <20140721151643.GA18084@batman-mbp.internally.la.gs>
References: <20140720052700.GB1838@batman-mbp.internally.la.gs>
 <20140721172651.1fcacfe7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140721172651.1fcacfe7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 21, 2014 at 05:26:51PM +1000, NeilBrown wrote:
> On Sat, 19 Jul 2014 22:27:00 -0700 Kenny Root <kenny@the-b.org> wrote:
> 
> > I may have stumbled into a kernel memory leak during reshaping of a RAID 10
> > from offset to near layout:
...
> >       OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> >     60511744 60511219  29%    0.25K 2183366       32  17466928K kmalloc-256
> >     193408  82391  42%    0.06K   3022       64     12088K kmalloc-64
> >     154880 129949  83%    0.03K   1210      128      4840K kmalloc-32
> >     154624 152783  98%    0.01K    302      512      1208K kmalloc-8
> >     144160 143412  99%    0.02K    848      170      3392K fsnotify_event_holder
> >     125103  34053  27%    0.08K   2453       51      9812K selinux_inode_security
> > 
> 
> This very suspicious.
> As you might imagine, it is not possible for a slab to use more memory than
> is physically available.
> It claims there are 60511219 active objects out of a total of 60511744.
> I calculate that as 99.9999132%, but it suggests 29%.
> 
> If there were 32 OBJ/SLAB, then the slabs must be 8K.  This is possible, but
> they are 4K on my machine, and all the other slabs you listed are too.
> 
> I've tried a similar reshape on 3.16-rc3 and there is no similar leak.
> 
> The only patch since 3.13 that could possibly be relevant is
> 
> commit cc13b1d1500656a20e41960668f3392dda9fa6e2
> Author: NeilBrown <neilb@suse.de>
> Date:   Mon May 5 13:34:37 2014 +1000
> 
>     md/raid10: call wait_barrier() for each request submitted.
> 
> That might fix a leak.  However the leak it might fix was introduced in
> 3.14-rc1:
>     commit 20d0189b1012a37d2533a87fb451f7852f2418d1
>         block: Introduce new bio_split()
> 
> So unless Fedora backported one of those but not the other I don't see how
> this can be caused by RAID10.
> 
> What does /proc/slabinfo contain?  Maybe "slabtop" is presenting it poorly.

I had to restart the machine shortly after this, because it became
pretty unresponsive. However, it still has about a gigabyte of memory
hanging around after the reshape finished:

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
5184320 5183608  99%    0.25K 162010       32   1296080K kmalloc-256

Here are the kmallocs from slabinfo the same time:

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
...
kmalloc-8192         152    152   8192    4    8 : tunables    0    0    0 : slabdata     38     38      0
kmalloc-4096         830    832   4096    8    8 : tunables    0    0    0 : slabdata    104    104      0
kmalloc-2048        1078   1184   2048   16    8 : tunables    0    0    0 : slabdata     74     74      0
kmalloc-1024        2704   2752   1024   32    8 : tunables    0    0    0 : slabdata     86     86      0
kmalloc-512         4176   4288    512   32    4 : tunables    0    0    0 : slabdata    134    134      0
kmalloc-256       5183621 5184320    256   32    2 : tunables    0    0    0 : slabdata 162010 162010      0
kmalloc-192        13157  13356    192   21    1 : tunables    0    0    0 : slabdata    636    636      0
kmalloc-128        11576  11712    128   32    1 : tunables    0    0    0 : slabdata    366    366      0
kmalloc-96         12558  12558     96   42    1 : tunables    0    0    0 : slabdata    299    299      0
kmalloc-64         99344 100672     64   64    1 : tunables    0    0    0 : slabdata   1573   1573      0
kmalloc-32        132317 135040     32  128    1 : tunables    0    0    0 : slabdata   1055   1055      0
kmalloc-16         61696  61696     16  256    1 : tunables    0    0    0 : slabdata    241    241      0
kmalloc-8          88064  88064      8  512    1 : tunables    0    0    0 : slabdata    172    172      0

I did try to run ftrace during the reshape to see where the allocations
were being made. One allocation callsite was in bio_alloc_bioset and the
other appeared to be beyond the range of my Symbols.map.

I'll try to reproduce it in a VM with the Fedora kernel and then the
vanilla kernel to see if it's a problem with Fedora first.

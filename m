From: Tyler <pml@dtbb.net>
Subject: Re: mdadm memory leak?
Date: Fri, 08 Jul 2005 16:15:39 -0700
Message-ID: <42CF091B.7030402@dtbb.net>
References: <42CA0B7E.4040109@shlrm.org>	<17098.4949.378512.822529@cse.unsw.edu.au>	<20050705105229.7aisufvrk8so0ook@shlrm.org> <17098.64085.334793.282803@cse.unsw.edu.au> <42CEF85F.5060409@shlrm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42CEF85F.5060409@shlrm.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Kowis <dkowis@shlrm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Kowis wrote:

>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>
>
>Neil Brown wrote:
>  
>
>>> OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>>>152098 151909  99%    0.02K    673      226      2692K fasync_cache
>>>24867  24846  99%    0.05K    307       81      1228K buffer_head
>>>12432   8306  66%    0.27K    888       14      3552K radix_tree_node
>>> 7308   6876  94%    0.13K    252       29      1008K dentry_cache
>>> 6303   5885  93%    0.36K    573       11      2292K reiser_inode_cache
>>>      
>>>
>>So you have about 16 megabytes used by the slab cache, none of the big
>>users 'md' related. 
>>16M doesn't sound like a big deal, so I suspect this isn't the source
>>of the leak. 
>> From a separate Email I see:
>>
>>    
>>
>>>Mem:    773984k total,   765556k used,     8428k free,    65812k buffers
>>>Swap:  2755136k total,        0k used,  2755136k free,   526632k cached
>>>      
>>>
>>The fact that swap isn't being touched at all suggests that you aren't
>>currently running low on memory.
>>The fact the free is low doesn't directly indicate a problem.  Linux
>>uses free memory to cache files.  It will discard then from the cache
>>if it needs more memory.
>>The fact that the OOM killer is hiting obviously is a problem.  Maybe
>>you need to report this on linux-kernel was an OOM problem.
>>
>>    
>>
>I've let my computer run for a while longer, and it's eaten more memory than before. I'll paste the relevant parts. I'm not sure this is a
>kernel thing, since I didn't have this problem before setting up a mirrored RAID array using mdadm.
>
>  
>
David, unless you have mdadm running in monitor mode, its not "actively" 
in memory.. the MD driver is in the kernel, and in memory.  Mdadm is 
simply a tool, just as fsck.ext2 or such.. its not active until you run 
it, and leaves memory when it finishes its one task.  (Someone correct 
me if I'm wrong please....).

Tyler.

>from slabtop:
> Active / Total Objects (% used)    : 80755 / 86856 (93.0%)
> Active / Total Slabs (% used)      : 2974 / 2975 (100.0%)
> Active / Total Caches (% used)     : 76 / 140 (54.3%)
> Active / Total Size (% used)       : 11445.72K / 12330.93K (92.8%)
> Minimum / Average / Maximum Object : 0.01K / 0.14K / 128.00K
>
>  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 44469  44441  99%    0.05K    549       81      2196K buffer_head
>  8946   8192  91%    0.27K    639       14      2556K radix_tree_node
>  6960   4720  67%    0.13K    240       29       960K dentry_cache
>  3510   3510 100%    0.09K     78       45       312K vm_area_struct
>  3179   2522  79%    0.36K    289       11      1156K reiser_inode_cache
>  3050   2477  81%    0.06K     50       61       200K size-64
>  2782   2713  97%    0.04K     26      107       104K sysfs_dir_cache
>  2405   2378  98%    0.29K    185       13       740K inode_cache
>  2142   2142 100%    0.03K     18      119        72K size-32
>  1860   1817  97%    0.12K     60       31       240K size-128
>   875    875 100%    0.16K     35       25       140K filp
>
>from free:
>             total       used       free     shared    buffers     cached
>Mem:        773900     765416       8484          0      75680     450004
>- -/+ buffers/cache:     239732     534168
>Swap:      2755136     118568    2636568
>
>
>Something's digesting memory and not giving it back.
>I'm now running 2.6.12.1 instead of 2.6.11.12 in the hopes that something was fixed, but no.
>
>Thanks,
>- --
>David Kowis
>
>ISO Team Lead - www.sourcemage.org
>SourceMage GNU/Linux
>
>One login to rule them all, one login to find them. One login to bring them all, and in the web bind them.
>-----BEGIN PGP SIGNATURE-----
>Version: GnuPG v1.4.1 (MingW32)
>
>iD8DBQFCzvhftgErhgxHMHsRAthSAJ0bSkP2xuhIeXYcuXx0P46ENdom2ACgmhB1
>J0A5DfZu5vxwlKT2Dar55J8=
>=pmX1
>-----END PGP SIGNATURE-----
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>


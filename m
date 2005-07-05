From: Eric Sandall <eric@sandall.us>
Subject: Re: mdadm memory leak?
Date: Tue, 5 Jul 2005 08:36:49 -0700 (PDT)
Message-ID: <Pine.LNX.4.63.0507050831130.15691@cerberus>
References: <42CA0B7E.4040109@shlrm.org> <17098.4949.378512.822529@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17098.4949.378512.822529@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: David Kowis <dkowis@shlrm.org>, linux-raid@vger.kernel.org, Eric Sandall <eric@sandall.us>
List-Id: linux-raid.ids

On Tue, 5 Jul 2005, Neil Brown wrote:
> On Monday July 4, dkowis@shlrm.org wrote:
>> I'm not entirely sure if this is mdadm's fault, but I cannot find anything else that would cause the problem, since mdadm is the only new
>> thing and I'm pretty sure it's not 2.6.11.12's fault. Anyways, on to my issue:
>> I'm running samba, apache2, mysql, postgresql, and a few other things. I've got an Athlon-XP 1700+ with 768Mb RAM. Right after startup I've
>> got about 600Mb of free memory, and as time progresses, and I use samba for things (playing an MP3,) my amount of free memory declines
>> rather rapidly. It hovers around 8Mb of free ram, with no swap usage. The computer has bogged down bad enough that oom-killer has had to
>> kill just about everything. ps and top don't show anything eating up all my memory. I'm very impressed with mdadm and I'd like to keep using
>> it, but i'd also like to have a bit of free memory on my computer. I'm using an XFS file system on a 200Gb mirrored RAID array, two drives,
>> on seperate IDE channels (seperate cables.)
>> Thanks for your time,
>
> Hmmm.
> There is an md related memory leak in 2.6.12, but I don't think it is
> there in 2.6.11.anything.

I also have this problem, but am using 2.6.10-as7 (also reiserfs on
the raid-1 array). This machine has 1Gb RAM, but has roughly 2-40Mb
free at any time after running for a day (I can leave the machine up
as long as I want, but all processes run slow as they now have to do a
lot of swapping). The kernel was compiled with gcc 3.4.4 and glibc
2.3.5 with NPTL (if that matters).

> If 'ps' doesn't show anything, the next place to look is
> /proc/slabinfo (which 'slabtop' might display for you).

  Active / Total Objects (% used)    : 12080357 / 12132001 (99.6%)
  Active / Total Slabs (% used)      : 176776 / 176776 (100.0%)
  Active / Total Caches (% used)     : 66 / 101 (65.3%)
  Active / Total Size (% used)       : 668099.80K / 671784.20K (99.5%)
  Minimum / Average / Maximum Object : 0.01K / 0.05K / 128.00K

   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME 
6013634 6013300  99%    0.02K  26609      226    106436K biovec-1
6013306 6013297  99%    0.09K 146666       41    586664K bio
  35625  16267  45%    0.05K    475       75      1900K buffer_head
  17446   6289  36%    0.06K    286       61      1144K size-64
  10829   3488  32%    0.03K     91      119       364K size-32
   8613   5222  60%    0.13K    297       29      1188K dentry_cache
   7490   6923  92%    0.27K    535       14      2140K radix_tree_node
   6486   3436  52%    0.08K    138       47       552K vm_area_struct
   3195   2092  65%    0.25K    213       15       852K ip_dst_cache
   2573   1888  73%    0.12K     83       31       332K size-128
   2442    890  36%    0.01K      6      407        24K anon_vma
   1425    886  62%    0.16K     57       25       228K filp
   1419   1317  92%    0.35K    129       11       516K
reiser_inode_cache
    798    651  81%    0.28K     57       14       228K inode_cache
    420    240  57%    0.19K     21       20        84K
skbuff_head_cache
    420    365  86%    0.37K     42       10       168K
shmem_inode_cache
    359    359 100%    4.00K    359        1      1436K size-4096
    338    262  77%    0.29K     26       13       104K
proc_inode_cache
    305    256  83%    0.06K      5       61        20K biovec-4
    260    256  98%    0.19K     13       20        52K biovec-16
    260    256  98%    0.75K     52        5       208K biovec-64
    260    256  98%    1.50K     52        5       416K biovec-128
    256    256 100%    3.00K    128        2      1024K biovec-(256)
    244     35  14%    0.06K      4       61        16K inet_peer_cache
    238     56  23%    0.03K      2      119         8K fs_cache
    226     24  10%    0.02K      1      226         4K tcp_bind_bucket
    226     13   5%    0.02K      1      226         4K ip_fib_alias
    216    189  87%    0.50K     27        8       108K size-512
    205     77  37%    0.09K      5       41        20K key_jar
    196    181  92%    2.00K     98        2       392K size-2048
    187     76  40%    0.34K     17       11        68K ip_conntrack
    183     21  11%    0.06K      3       61        12K as_arq
...

> What does 'cat /proc/slabinfo' show?

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <batchcount> <limit> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
ip_conntrack_expect      0      0    128   31    1 : tunables  120   60    0 : slabdata      0      0      0
ip_conntrack          40    187    352   11    1 : tunables   54   27    0 : slabdata     17     17      0
ip_fib_alias          13    226     16  226    1 : tunables  120   60    0 : slabdata      1      1      0
ip_fib_hash           13    119     32  119    1 : tunables  120   60    0 : slabdata      1      1      0
rpc_buffers            8      8   2048    2    1 : tunables   24   12    0 : slabdata      4      4      0
rpc_tasks              8     25    160   25    1 : tunables  120   60    0 : slabdata      1      1      0
rpc_inode_cache        0      0    384   10    1 : tunables   54   27    0 : slabdata      0      0      0
unix_sock             17     20    384   10    1 : tunables   54   27    0 : slabdata      2      2      0
tcp_tw_bucket          0      0     96   41    1 : tunables  120   60    0 : slabdata      0      0      0
tcp_bind_bucket       24    226     16  226    1 : tunables  120   60    0 : slabdata      1      1      0
tcp_open_request       0      0     64   61    1 : tunables  120   60    0 : slabdata      0      0      0
inet_peer_cache       35    244     64   61    1 : tunables  120   60    0 : slabdata      4      4      0
secpath_cache          0      0    128   31    1 : tunables  120   60    0 : slabdata      0      0      0
xfrm_dst_cache         0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
ip_dst_cache        2085   3195    256   15    1 : tunables  120   60    0 : slabdata    213    213      0
arp_cache              8     31    128   31    1 : tunables  120   60    0 : slabdata      1      1      0
raw_sock               3      8    480    8    1 : tunables   54   27    0 : slabdata      1      1      0
udp_sock              20     24    480    8    1 : tunables   54   27    0 : slabdata      3      3      0
tcp_sock              26     40   1024    4    1 : tunables   54   27    0 : slabdata     10     10      0
flow_cache             0      0     96   41    1 : tunables  120   60    0 : slabdata      0      0      0
dm_tio                 0      0     16  226    1 : tunables  120   60    0 : slabdata      0      0      0
dm_io                  0      0     16  226    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_ioc_pool           0      0     24  156    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_pool               0      0    104   38    1 : tunables  120   60    0 : slabdata      0      0      0
crq_pool               0      0     56   70    1 : tunables  120   60    0 : slabdata      0      0      0
deadline_drq           0      0     52   75    1 : tunables  120   60    0 : slabdata      0      0      0
as_arq                26     61     64   61    1 : tunables  120   60    0 : slabdata      1      1      0
reiser_inode_cache   1300   1419    360   11    1 : tunables   54   27    0 : slabdata    129    129      0
dnotify_cache          0      0     20  185    1 : tunables  120   60    0 : slabdata      0      0      0
eventpoll_pwq          0      0     36  107    1 : tunables  120   60    0 : slabdata      0      0      0
eventpoll_epi          0      0     96   41    1 : tunables  120   60    0 : slabdata      0      0      0
kioctx                 0      0    160   25    1 : tunables  120   60    0 : slabdata      0      0      0
kiocb                  0      0    128   31    1 : tunables  120   60    0 : slabdata      0      0      0
fasync_cache           0      0     16  226    1 : tunables  120   60    0 : slabdata      0      0      0
shmem_inode_cache    380    420    376   10    1 : tunables   54   27    0 : slabdata     42     42      0
posix_timers_cache      0      0     96   41    1 : tunables  120   60    0 : slabdata      0      0      0
uid_cache              8     61     64   61    1 : tunables  120   60    0 : slabdata      1      1      0
blkdev_ioc            64    156     24  156    1 : tunables  120   60    0 : slabdata      1      1      0
blkdev_queue           7     11    352   11    1 : tunables   54   27    0 : slabdata      1      1      0
blkdev_requests       18     27    148   27    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-(256)         256    256   3072    2    2 : tunables   24   12    0 : slabdata    128    128      0
biovec-128           256    260   1536    5    2 : tunables   24   12    0 : slabdata     52     52      0
biovec-64            256    260    768    5    1 : tunables   54   27    0 : slabdata     52     52      0
biovec-16            256    260    192   20    1 : tunables  120   60    0 : slabdata     13     13      0
biovec-4             258    305     64   61    1 : tunables  120   60    0 : slabdata      5      5      0
biovec-1          6013296 6013634     16  226    1 : tunables  120   60    0 : slabdata  26609  26609      0
bio               6013291 6013306     96   41    1 : tunables  120   60    0 : slabdata 146666 146666      0
file_lock_cache       30     45     88   45    1 : tunables  120   60    0 : slabdata      1      1      0
sock_inode_cache      72    144    320   12    1 : tunables   54   27    0 : slabdata     12     12      0
skbuff_head_cache    240    420    192   20    1 : tunables  120   60    0 : slabdata     21     21      0
sock                   4     12    320   12    1 : tunables   54   27    0 : slabdata      1      1      0
key_jar               78    205     96   41    1 : tunables  120   60    0 : slabdata      5      5      0
proc_inode_cache     262    338    300   13    1 : tunables   54   27    0 : slabdata     26     26      0
sigqueue               5     27    148   27    1 : tunables  120   60    0 : slabdata      1      1      0
radix_tree_node     6895   7490    276   14    1 : tunables   54   27    0 : slabdata    535    535      0
bdev_cache             7     10    384   10    1 : tunables   54   27    0 : slabdata      1      1      0
mnt_cache             23     41     96   41    1 : tunables  120   60    0 : slabdata      1      1      0
inode_cache          652    798    284   14    1 : tunables   54   27    0 : slabdata     57     57      0
dentry_cache        5162   8613    136   29    1 : tunables  120   60    0 : slabdata    297    297      0
filp                 886   1425    160   25    1 : tunables  120   60    0 : slabdata     57     57      0
names_cache           17     17   4096    1    1 : tunables   24   12    0 : slabdata     17     17      0
idr_layer_cache       64     87    136   29    1 : tunables  120   60    0 : slabdata      3      3      0
buffer_head        16142  35625     52   75    1 : tunables  120   60    0 : slabdata    475    475      0
mm_struct             83     84    544    7    1 : tunables   54   27    0 : slabdata     12     12      0
vm_area_struct      3436   6486     84   47    1 : tunables  120   60    0 : slabdata    138    138      0
fs_cache              57    238     32  119    1 : tunables  120   60    0 : slabdata      2      2      0
files_cache           56    117    416    9    1 : tunables   54   27    0 : slabdata     13     13      0
signal_cache          73    135    256   15    1 : tunables  120   60    0 : slabdata      9      9      0
sighand_cache         70     87   1312    3    1 : tunables   24   12    0 : slabdata     29     29      0
task_struct           92     96   1264    3    1 : tunables   24   12    0 : slabdata     32     32      0
anon_vma             890   2442      8  407    1 : tunables  120   60    0 : slabdata      6      6      0
pgd                   57     57   4096    1    1 : tunables   24   12    0 : slabdata     57     57      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             1      1  32768    1    8 : tunables    8    4    0 : slabdata      1      1      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384            11     11  16384    1    4 : tunables    8    4    0 : slabdata     11     11      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192              1      1   8192    1    2 : tunables    8    4    0 : slabdata      1      1      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    0 : slabdata      0      0      0
size-4096            355    355   4096    1    1 : tunables   24   12    0 : slabdata    355    355      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    0 : slabdata      0      0      0
size-2048            186    190   2048    2    1 : tunables   24   12    0 : slabdata     95     95      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    0 : slabdata      0      0      0
size-1024            148    148   1024    4    1 : tunables   54   27    0 : slabdata     37     37      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    0 : slabdata      0      0      0
size-512             189    216    512    8    1 : tunables   54   27    0 : slabdata     27     27      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
size-256              96    105    256   15    1 : tunables  120   60    0 : slabdata      7      7      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
size-192             100    100    192   20    1 : tunables  120   60    0 : slabdata      5      5      0
size-128(DMA)          0      0    128   31    1 : tunables  120   60    0 : slabdata      0      0      0
size-128            1948   2573    128   31    1 : tunables  120   60    0 : slabdata     83     83      0
size-64(DMA)           0      0     64   61    1 : tunables  120   60    0 : slabdata      0      0      0
size-64             6289  17446     64   61    1 : tunables  120   60    0 : slabdata    286    286      0
size-32(DMA)           0      0     32  119    1 : tunables  120   60    0 : slabdata      0      0      0
size-32             3488  10829     32  119    1 : tunables  120   60    0 : slabdata     91     91      0
kmem_cache           124    124    128   31    1 : tunables  120   60    0 : slabdata      4      4      0

-sandalle

-- 
Eric Sandall                     |  Source Mage GNU/Linux Developer
eric@sandall.us                  |  http://www.sourcemage.org/
http://eric.sandall.us/          |  SysAdmin @ Inst. Shock Physics @ WSU
http://counter.li.org/  #196285  |  http://www.shock.wsu.edu/

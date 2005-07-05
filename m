From: David Kowis <dkowis@shlrm.org>
Subject: Re: mdadm memory leak?
Date: Tue, 05 Jul 2005 16:41:06 -0500
Message-ID: <42CAFE72.1090800@shlrm.org>
References: <42CA0B7E.4040109@shlrm.org>	<17098.4949.378512.822529@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010209060908070000050600"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17098.4949.378512.822529@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, Eric Sandall <eric@sandall.us>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010209060908070000050600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Neil Brown <neilb@cse.unsw.edu.au>:

> Hmmm.
> There is an md related memory leak in 2.6.12, but I don't think it is
> there in 2.6.11.anything.
>
> If 'ps' doesn't show anything, the next place to look is
> /proc/slabinfo (which 'slabtop' might display for you).
Slabtop:
Active / Total Objects (% used)    : 217562 / 225483 (96.5%)
Active / Total Slabs (% used)      : 3972 / 3972 (100.0%)
Active / Total Caches (% used)     : 78 / 139 (56.1%)
Active / Total Size (% used)       : 14328.78K / 15891.08K (90.2%)
Minimum / Average / Maximum Object : 0.01K / 0.07K / 128.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
152098 151909  99%    0.02K    673      226      2692K fasync_cache
24867  24846  99%    0.05K    307       81      1228K buffer_head
12432   8306  66%    0.27K    888       14      3552K radix_tree_node
  7308   6876  94%    0.13K    252       29      1008K dentry_cache
  6303   5885  93%    0.36K    573       11      2292K reiser_inode_cache
  3690   3684  99%    0.09K     82       45       328K vm_area_struct
  2675   2645  98%    0.04K     25      107       100K sysfs_dir_cache
  2405   2360  98%    0.29K    185       13       740K inode_cache
  2142   2082  97%    0.03K     18      119        72K size-32
  2074   1503  72%    0.06K     34       61       136K size-64
  1891   1842  97%    0.12K     61       31       244K size-128
   814    523  64%    0.01K      2      407         8K anon_vma
   750    749  99%    0.16K     30       25       120K filp
   452    300  66%    0.02K      2      226         8K biovec-1
   305    281  92%    0.06K      5       61        20K bio
   305    256  83%    0.06K      5       61        20K biovec-4
   260    256  98%    0.19K     13       20        52K biovec-16
   260    256  98%    0.75K     52        5       208K biovec-64
   260    256  98%    1.50K     52        5       416K biovec-128
   256    256 100%    3.00K    128        2      1024K biovec-(256)
   247    242  97%    0.30K     19       13        76K proc_inode_cache
   226      9   3%    0.02K      1      226         4K ip_fib_alias
   226     16   7%    0.02K      1      226         4K tcp_bind_bucket
   200     71  35%    0.19K     10       20        40K skbuff_head_cache
   184    176  95%    0.50K     23        8        92K size-512
   156     53  33%    0.02K      1      156         4K blkdev_ioc
   155    155 100%    0.12K      5       31        20K kmem_cache
   124    119  95%    1.00K     31        4       124K size-1024
   120    120 100%    0.25K      8       15        32K size-256
   119     59  49%    0.03K      1      119         4K fs_cache
   119      9   7%    0.03K      1      119         4K ip_fib_hash
   119      8   6%    0.03K      1      119         4K fib6_nodes
   108    108 100%    4.00K    108        1       432K size-4096
    99     89  89%    1.25K     33        3       132K task_struct
    92     92 100%    2.00K     46        2       184K size-2048
    90     80  88%    0.25K      6       15        24K signal_cache
    89     89 100%    8.00K     89        1       712K size-8192
    88     80  90%    0.34K      8       11        32K sock_inode_cache
    87     77  88%    1.28K     29        3       116K sighand_cache
    87     86  98%    0.13K      3       29        12K idr_layer_cache
    80     63  78%    0.19K      4       20        16K size-192
    72     59  81%    0.41K      8        9        32K files_cache
    70     59  84%    0.56K     10        7        40K mm_struct
    65     24  36%    0.06K      1       65         4K as_arq
    62     32  51%    0.12K      2       31         8K sgpool-8
    61      7  11%    0.06K      1       61         4K uid_cache
    61      1   1%    0.06K      1       61         4K inet_peer_cache
    59     59 100%    4.00K     59        1       236K pgd

>
> What does 'cat /proc/slabinfo' show?
I've attached my /proc/slabinfo.

Thanks :)
David
- --
One login to rule them all, one login to find them. One login to bring
them all,
and in the web bind them.

- ----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (MingW32)

iD8DBQFCyv5ytgErhgxHMHsRAr8QAKCHHKplEpHR+fF8bDoit7cNpWGkrgCaA83d
a2iF8PJ5QGfMZ+BRLLMEUlw=
=9Bqi
-----END PGP SIGNATURE-----

--------------010209060908070000050600
Content-Type: text/plain;
 name="slabinfo.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slabinfo.txt"

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
rpc_buffers            8      8   2048    2    1 : tunables   24   12    0 : slabdata      4      4      0
rpc_tasks              8     20    192   20    1 : tunables  120   60    0 : slabdata      1      1      0
rpc_inode_cache        0      0    416    9    1 : tunables   54   27    0 : slabdata      0      0      0
fib6_nodes             8    119     32  119    1 : tunables  120   60    0 : slabdata      1      1      0
ip6_dst_cache          7     18    224   18    1 : tunables  120   60    0 : slabdata      1      1      0
ndisc_cache            2     25    160   25    1 : tunables  120   60    0 : slabdata      1      1      0
rawv6_sock             3      6    640    6    1 : tunables   54   27    0 : slabdata      1      1      0
udpv6_sock             1      6    608    6    1 : tunables   54   27    0 : slabdata      1      1      0
tcpv6_sock             7      7   1120    7    2 : tunables   24   12    0 : slabdata      1      1      0
unix_sock             33     40    384   10    1 : tunables   54   27    0 : slabdata      4      4      0
ip_conntrack_expect      0      0     84   47    1 : tunables  120   60    0 : slabdata      0      0      0
ip_conntrack          13     19    212   19    1 : tunables  120   60    0 : slabdata      1      1      0
tcp_tw_bucket          2     31    128   31    1 : tunables  120   60    0 : slabdata      1      1      0
tcp_bind_bucket       17    226     16  226    1 : tunables  120   60    0 : slabdata      1      1      0
tcp_open_request       0      0     96   41    1 : tunables  120   60    0 : slabdata      0      0      0
inet_peer_cache        1     61     64   61    1 : tunables  120   60    0 : slabdata      1      1      0
ip_fib_alias           9    226     16  226    1 : tunables  120   60    0 : slabdata      1      1      0
ip_fib_hash            9    119     32  119    1 : tunables  120   60    0 : slabdata      1      1      0
ip_dst_cache          11     30    256   15    1 : tunables  120   60    0 : slabdata      2      2      0
arp_cache              3     31    128   31    1 : tunables  120   60    0 : slabdata      1      1      0
raw_sock               2      8    480    8    1 : tunables   54   27    0 : slabdata      1      1      0
udp_sock              16     16    480    8    1 : tunables   54   27    0 : slabdata      2      2      0
tcp_sock              12     12   1024    4    1 : tunables   54   27    0 : slabdata      3      3      0
flow_cache             0      0     96   41    1 : tunables  120   60    0 : slabdata      0      0      0
uhci_urb_priv          0      0     44   88    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_ioc_pool           0      0     24  156    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_pool               0      0    104   38    1 : tunables  120   60    0 : slabdata      0      0      0
crq_pool               0      0     52   75    1 : tunables  120   60    0 : slabdata      0      0      0
deadline_drq           0      0     48   81    1 : tunables  120   60    0 : slabdata      0      0      0
as_arq                24    130     60   65    1 : tunables  120   60    0 : slabdata      2      2      0
mqueue_inode_cache      1      8    480    8    1 : tunables   54   27    0 : slabdata      1      1      0
xfs_chashlist          0      0     20  185    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_ili                0      0    140   28    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_ifork              0      0     56   70    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_efi_item           0      0    260   15    1 : tunables   54   27    0 : slabdata      0      0      0
xfs_efd_item           0      0    260   15    1 : tunables   54   27    0 : slabdata      0      0      0
xfs_buf_item           0      0    148   27    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_dabuf              0      0     16  226    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_da_state           0      0    336   12    1 : tunables   54   27    0 : slabdata      0      0      0
xfs_trans              0      0    592   13    2 : tunables   54   27    0 : slabdata      0      0      0
xfs_inode              0      0    352   11    1 : tunables   54   27    0 : slabdata      0      0      0
xfs_btree_cur          0      0    132   30    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_bmap_free_item      0      0     12  290    1 : tunables  120   60    0 : slabdata      0      0      0
xfs_buf_t              0      0    224   18    1 : tunables  120   60    0 : slabdata      0      0      0
linvfs_icache          0      0    320   12    1 : tunables   54   27    0 : slabdata      0      0      0
udf_inode_cache        0      0    348   11    1 : tunables   54   27    0 : slabdata      0      0      0
nfs_write_data        36     36    448    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_read_data         32     36    448    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_inode_cache        0      0    544    7    1 : tunables   54   27    0 : slabdata      0      0      0
nfs_page               0      0     64   61    1 : tunables  120   60    0 : slabdata      0      0      0
isofs_inode_cache      0      0    320   12    1 : tunables   54   27    0 : slabdata      0      0      0
fat_inode_cache        0      0    348   11    1 : tunables   54   27    0 : slabdata      0      0      0
fat_cache              0      0     20  185    1 : tunables  120   60    0 : slabdata      0      0      0
ext2_inode_cache       0      0    400   10    1 : tunables   54   27    0 : slabdata      0      0      0
journal_handle         0      0     20  185    1 : tunables  120   60    0 : slabdata      0      0      0
journal_head           0      0     48   81    1 : tunables  120   60    0 : slabdata      0      0      0
revoke_table           0      0     12  290    1 : tunables  120   60    0 : slabdata      0      0      0
revoke_record          0      0     16  226    1 : tunables  120   60    0 : slabdata      0      0      0
ext3_inode_cache       0      0    472    8    1 : tunables   54   27    0 : slabdata      0      0      0
ext3_xattr             0      0     44   88    1 : tunables  120   60    0 : slabdata      0      0      0
reiser_inode_cache   5617   6303    368   11    1 : tunables   54   27    0 : slabdata    573    573      0
dnotify_cache          0      0     20  185    1 : tunables  120   60    0 : slabdata      0      0      0
eventpoll_pwq          0      0     36  107    1 : tunables  120   60    0 : slabdata      0      0      0
eventpoll_epi          0      0     96   41    1 : tunables  120   60    0 : slabdata      0      0      0
kioctx                 0      0    160   25    1 : tunables  120   60    0 : slabdata      0      0      0
kiocb                  0      0    128   31    1 : tunables  120   60    0 : slabdata      0      0      0
fasync_cache      151909 152098     16  226    1 : tunables  120   60    0 : slabdata    673    673      0
shmem_inode_cache      7     10    384   10    1 : tunables   54   27    0 : slabdata      1      1      0
posix_timers_cache      0      0     96   41    1 : tunables  120   60    0 : slabdata      0      0      0
uid_cache              7     61     64   61    1 : tunables  120   60    0 : slabdata      1      1      0
sgpool-128            32     32   2048    2    1 : tunables   24   12    0 : slabdata     16     16      0
sgpool-64             32     32   1024    4    1 : tunables   54   27    0 : slabdata      8      8      0
sgpool-32             32     32    512    8    1 : tunables   54   27    0 : slabdata      4      4      0
sgpool-16             32     45    256   15    1 : tunables  120   60    0 : slabdata      3      3      0
sgpool-8              32     62    128   31    1 : tunables  120   60    0 : slabdata      2      2      0
blkdev_ioc            68    156     24  156    1 : tunables  120   60    0 : slabdata      1      1      0
blkdev_queue          14     22    360   11    1 : tunables   54   27    0 : slabdata      2      2      0
blkdev_requests       24     56    140   28    1 : tunables  120   60    0 : slabdata      2      2      0
biovec-(256)         256    256   3072    2    2 : tunables   24   12    0 : slabdata    128    128      0
biovec-128           256    260   1536    5    2 : tunables   24   12    0 : slabdata     52     52      0
biovec-64            256    260    768    5    1 : tunables   54   27    0 : slabdata     52     52      0
biovec-16            256    260    192   20    1 : tunables  120   60    0 : slabdata     13     13      0
biovec-4             256    305     64   61    1 : tunables  120   60    0 : slabdata      5      5      0
biovec-1             258    452     16  226    1 : tunables  120   60    0 : slabdata      2      2      0
bio                  261    305     64   61    1 : tunables  120   60    0 : slabdata      5      5      0
file_lock_cache       12     45     88   45    1 : tunables  120   60    0 : slabdata      1      1      0
sock_inode_cache      81     88    352   11    1 : tunables   54   27    0 : slabdata      8      8      0
skbuff_head_cache     72    200    192   20    1 : tunables  120   60    0 : slabdata     10     10      0
sock                   5     12    320   12    1 : tunables   54   27    0 : slabdata      1      1      0
proc_inode_cache     247    247    308   13    1 : tunables   54   27    0 : slabdata     19     19      0
sigqueue              27     27    148   27    1 : tunables  120   60    0 : slabdata      1      1      0
radix_tree_node     8272  12432    276   14    1 : tunables   54   27    0 : slabdata    888    888      0
bdev_cache            10     18    416    9    1 : tunables   54   27    0 : slabdata      2      2      0
sysfs_dir_cache     2645   2675     36  107    1 : tunables  120   60    0 : slabdata     25     25      0
mnt_cache             20     41     96   41    1 : tunables  120   60    0 : slabdata      1      1      0
inode_cache         2360   2405    292   13    1 : tunables   54   27    0 : slabdata    185    185      0
dentry_cache        6443   7308    136   29    1 : tunables  120   60    0 : slabdata    252    252      0
filp                 750    750    160   25    1 : tunables  120   60    0 : slabdata     30     30      0
names_cache            1      1   4096    1    1 : tunables   24   12    0 : slabdata      1      1      0
idr_layer_cache       86     87    136   29    1 : tunables  120   60    0 : slabdata      3      3      0
buffer_head        24543  24543     48   81    1 : tunables  120   60    0 : slabdata    303    303      0
mm_struct             70     70    576    7    1 : tunables   54   27    0 : slabdata     10     10      0
vm_area_struct      3645   3645     88   45    1 : tunables  120   60    0 : slabdata     81     81      0
fs_cache              74    119     32  119    1 : tunables  120   60    0 : slabdata      1      1      0
files_cache           72     72    416    9    1 : tunables   54   27    0 : slabdata      8      8      0
signal_cache          90     90    256   15    1 : tunables  120   60    0 : slabdata      6      6      0
sighand_cache         87     87   1312    3    1 : tunables   24   12    0 : slabdata     29     29      0
task_struct           99     99   1280    3    1 : tunables   24   12    0 : slabdata     33     33      0
anon_vma             573    814      8  407    1 : tunables  120   60    0 : slabdata      2      2      0
pgd                   60     60   4096    1    1 : tunables   24   12    0 : slabdata     60     60      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384             0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192             89     89   8192    1    2 : tunables    8    4    0 : slabdata     89     89      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    0 : slabdata      0      0      0
size-4096            109    109   4096    1    1 : tunables   24   12    0 : slabdata    109    109      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    0 : slabdata      0      0      0
size-2048             95     96   2048    2    1 : tunables   24   12    0 : slabdata     48     48      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    0 : slabdata      0      0      0
size-1024            118    124   1024    4    1 : tunables   54   27    0 : slabdata     31     31      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    0 : slabdata      0      0      0
size-512             184    184    512    8    1 : tunables   54   27    0 : slabdata     23     23      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
size-256             120    120    256   15    1 : tunables  120   60    0 : slabdata      8      8      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
size-192              79     80    192   20    1 : tunables  120   60    0 : slabdata      4      4      0
size-128(DMA)          0      0    128   31    1 : tunables  120   60    0 : slabdata      0      0      0
size-128            1812   1891    128   31    1 : tunables  120   60    0 : slabdata     61     61      0
size-64(DMA)           0      0     64   61    1 : tunables  120   60    0 : slabdata      0      0      0
size-64             1501   2074     64   61    1 : tunables  120   60    0 : slabdata     34     34      0
size-32(DMA)           0      0     32  119    1 : tunables  120   60    0 : slabdata      0      0      0
size-32             2082   2142     32  119    1 : tunables  120   60    0 : slabdata     18     18      0
kmem_cache           155    155    128   31    1 : tunables  120   60    0 : slabdata      5      5      0

--------------010209060908070000050600--

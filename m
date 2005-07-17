From: Eric Sandall <eric@sandall.us>
Subject: Re: mdadm memory leak?
Date: Sat, 16 Jul 2005 21:52:57 -0700 (PDT)
Message-ID: <Pine.LNX.4.63.0507162150530.12074@cerberus>
References: <42CA0B7E.4040109@shlrm.org> <17098.4949.378512.822529@cse.unsw.edu.au>
 <Pine.LNX.4.63.0507050831130.15691@cerberus> <17098.63205.207499.40820@cse.unsw.edu.au>
 <Pine.LNX.4.63.0507051458380.7296@cerberus> <17099.13342.229652.667901@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17099.13342.229652.667901@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Eric Sandall <eric@sandall.us>, David Kowis <dkowis@shlrm.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Wed, 6 Jul 2005, Neil Brown wrote:
> It was against ... 2.6.12-mm1 or similar I think.  Looks like the bug
> didn't get to main-line until just before the fix, which it good.
>
> 2.6.10-as7 seems to have a different though related bug.
> It contains the patch:
> http://www.acm.cs.rpi.edu/~dilinger/patches/2.6.10/as7/linux-2.6.10-as7/051-md_sync_page_io_max_vecs.patch
>
> which contains:
> diff -Nru a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c	2005-01-22 00:16:02 -08:00
> +++ b/drivers/md/md.c	2005-01-22 00:16:02 -08:00
> @@ -332,29 +332,26 @@
> static int sync_page_io(struct block_device *bdev, sector_t sector, int size,
> 		   struct page *page, int rw)
> {
> -	struct bio bio;
> -	struct bio_vec vec;
> +	struct bio *bio = bio_alloc(GFP_KERNEL, 1);
> 	struct completion event;
> +	int ret;
> +
> +	bio_get(bio);
> ....
> +	bio_put(bio);
> +	return ret;
> }
>
> bio_alloc sets the refcount to 1.
> bio_get increments it to 2.
> bio_put sets it back to 1.  But it never reaches zero.
>
> You want to get rid of that bio_get near the top of sync_page_io.

Applying this fix I still 'seem' to run out of memory with `top`, but
bio and biovec are no longer insane:

$ slabtop
Active / Total Objects (% used)    : 77209 / 156871 (49.2%)
Active / Total Slabs (% used)      : 5203 / 5211 (99.8%)
Active / Total Caches (% used)     : 66 / 101 (65.3%)
Active / Total Size (% used)       : 11391.00K / 20616.61K (55.3%)
Minimum / Average / Maximum Object : 0.01K / 0.13K / 128.00K
  65400  38946  59%    0.05K    872       75      3488K buffer_head
  31476   7412  23%    0.06K    516       61      2064K size-64
  14546   9797  67%    0.27K   1039       14      4156K radix_tree_node
  13717   4024  29%    0.13K    473       29      1892K dentry_cache
  11363   2691  23%    0.35K   1033       11      4132K
reiser_inode_cache
   4522   3005  66%    0.03K     38      119       152K size-32
   3713   2605  70%    0.08K     79       47       316K vm_area_struct
   1953   1953 100%    0.12K     63       31       252K size-128
   1221    650  53%    0.01K      3      407        12K anon_vma
    925    710  76%    0.16K     37       25       148K filp
    784    645  82%    0.28K     56       14       224K inode_cache
    546    216  39%    0.29K     42       13       168K
proc_inode_cache
    460    280  60%    0.19K     23       20        92K
skbuff_head_cache
    452    263  58%    0.02K      2      226         8K biovec-1
    410    302  73%    0.09K     10       41        40K bio
    350    330  94%    0.37K     35       10       140K
shmem_inode_cache
    305    256  83%    0.06K      5       61        20K biovec-4
    280    257  91%    0.75K     56        5       224K biovec-64
    260    257  98%    0.19K     13       20        52K biovec-16
    260    256  98%    1.50K     52        5       416K biovec-128
    256    256 100%    3.00K    128        2      1024K biovec-(256)
    254    187  73%    2.00K    127        2       508K size-2048
    226     24  10%    0.02K      1      226         4K tcp_bind_bucket
...

Thanks for the fix!

(tested on a 2.6.10-as7 kernel)

- -sandalle

- --
Eric Sandall                     |  Source Mage GNU/Linux Developer
eric@sandall.us                  |  http://www.sourcemage.org/
http://eric.sandall.us/          |  SysAdmin @ Inst. Shock Physics @ WSU
http://counter.li.org/  #196285  |  http://www.shock.wsu.edu/
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC2eQrHXt9dKjv3WERAiS/AJ9lvx+pUiDcpLe1HR5D669iQERSzACaA3UN
tvg0ENq/c4qx/z8G5d27nWk=
=82kA
-----END PGP SIGNATURE-----

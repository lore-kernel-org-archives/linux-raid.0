From: Eric Sandall <eric@sandall.us>
Subject: Re: mdadm memory leak?
Date: Sat, 9 Jul 2005 13:11:10 -0700 (PDT)
Message-ID: <Pine.LNX.4.63.0507091309380.486@cerberus>
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
> On Tuesday July 5, eric@sandall.us wrote:
>> Which kernel is that against? It doesn't apply against my 2.6.10-as7
>> nor David Kowis' 2.6.12.1 and 2.6.11.12 kernel source trees
>> (I don't even have the super_written function the patch is referring
>> to)?
>
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

I've patched[0] my kernel with that and recompiled it, but haven't
rebooted into it yet as I have some processes running that I don't
want to kill until they've finished.

Should be good to go tomorrow, then I'll report back, thanks. :)

- -sandalle

[0] Removing only the bio_get(bio);, not applying the entire patch.

- --
Eric Sandall                     |  Source Mage GNU/Linux Developer
eric@sandall.us                  |  http://www.sourcemage.org/
http://eric.sandall.us/          |  SysAdmin @ Inst. Shock Physics @ WSU
http://counter.li.org/  #196285  |  http://www.shock.wsu.edu/
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC0C9hHXt9dKjv3WERAqgFAJ9UsWg7gtm2aUv/rLtPnjsBrV6A7QCgww1F
r7s0Th0J5LMLXIkfdyv5G/8=
=tMC0
-----END PGP SIGNATURE-----

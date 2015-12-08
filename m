From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] raid5-cache: use a mempool for the metadata block
Date: Wed, 09 Dec 2015 10:27:25 +1100
Message-ID: <878u54r06a.fsf@notabene.neil.brown.name>
References: <1449072638-15409-1-git-send-email-hch@lst.de> <1449072638-15409-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449072638-15409-3-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 03 2015, Christoph Hellwig wrote:

> +
>  error:
>  	md_unregister_thread(&log->reclaim_thread);
>  reclaim_thread:
> +	mempool_destroy(log->meta_pool);
> +out_mempool:
>  	bioset_free(log->bs);
>  io_bs:

These cascading goto labels always bother me.
As mempool_destroy accepts NULL, we don't need "out_mempool", we can
just "goto reclaim_thread", or even "goto error" as md_unregsiter_thread
copes with NULL too.
If we use:
    if (log->bs)
    	bioset_free(log->bs);

or modified bioset_free, we could just have a single 'error' label...

But that is just cosmetic.  I like the patch once we agree on value for
R5L_POOL_SIZE.

Thanks,
NeilBrown


>  	kmem_cache_destroy(log->io_kc);
> @@ -1192,6 +1201,7 @@ io_kc:
>  void r5l_exit_log(struct r5l_log *log)
>  {
>  	md_unregister_thread(&log->reclaim_thread);
> +	mempool_destroy(log->meta_pool);
>  	bioset_free(log->bs);
>  	kmem_cache_destroy(log->io_kc);
>  	kfree(log);
> --=20
> 1.9.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZ2ddAAoJEDnsnt1WYoG5+/4QALVV12s241MN2606TmJKpUFk
yOuC+83Mgrk+uqZZwYeTkKmAL/5WaOGQeh0mhRBMcJrq9nts6rzP6CN6cN7zrord
60Eih7+g7uf4CiIjtd6R052jDwH+qfrz+qDBoIUgxWMdMoZF/3PJ073lZQjsmOPa
BwveNxTN0+lq9oDadPFrpj9I418BScBtpO3sNdgHoRFoC2QsiyO6rrRxVJF+PQUp
2a6upWJGcuUbGbxBHhTKM0AjVe2wwiCh5/TYN32JD6rhOTJVK32L8I3u6aN+tvtw
d2upwe+XTo2kf8ieLTA/7gptsg8z3fPrN2oThknCrTbxk6QEjEeW8n03OsvcDjAm
NvP99wGOOeX86tTuBVUsr5tlcmvSFQcsWKGCQFZ/ihSnBw74QjCfBhqDQaJXQi4t
UcMos7pLVcN63TQHPAGACyggMipLFh9vZWjmYxcx3ppQTEdIioQ8OoB8GZb/WwV8
NFOTRZaoNzpH3B9lEAmK62x6SJVp+JCxrroEDn+EGFQHfPVmER0BGwCoyvylxQXE
X55QbB4m3jUA3K5ggaDb4E6bAEGI6E/rSRtN6xymqRW9Wx3InuUD9N2NkGEKRz+p
pvKdRn3MhUvwMY53aUvhIGzlnxtHfTZ+fdCzcdffjABZKErSFPFxTbtVhbBa8BTG
RpHTgT/VPIdYhETF/ynj
=/mzf
-----END PGP SIGNATURE-----
--=-=-=--

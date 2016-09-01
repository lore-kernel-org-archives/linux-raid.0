From: NeilBrown <neilb@suse.com>
Subject: Re: md-cluster Module Requirement
Date: Thu, 01 Sep 2016 20:51:52 +1000
Message-ID: <877favdh9z.fsf@notabene.neil.brown.name>
References: <CAHkw+Lf82YEZ3qm9KJ_b_2pUiNFh=nDeEBXYV5PdgtEUtij8eg@mail.gmail.com> <57C79011.9090404@suse.com> <87h9a0cgkw.fsf@notabene.neil.brown.name> <57C7F534.3040400@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57C7F534.3040400@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Marc Smith <marc.smith@mcc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Sep 01 2016, Guoqing Jiang wrote:

>
> Thanks, how about below changes?
>
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7619,20 +7619,19 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);
>
>   int md_setup_cluster(struct mddev *mddev, int nodes)
>   {
> -       int err;
> -
> -       err = request_module("md-cluster");
> -       if (err) {
> -               pr_err("md-cluster module not found.\n");
> -               return -ENOENT;
> -       }
> -
>          spin_lock(&pers_lock);
> -       if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
> -               spin_unlock(&pers_lock);
> -               return -ENOENT;
> +       if (!md_cluster_ops) {
> +               /* load module and ensure it won't be unloaded */
> +               if (!request_module("md-cluster") &&

Calling request_module() under a spin_lock is not OK.  request_module()
needs to wait while the module is loaded.

Just call request_module, ignore the error, then take the spinlock and
see if the module is registered.

NeilBrown

> +                   !try_module_get(md_cluster_mod)) {
> +                       pr_err("md-cluster module found.\n");
> +                       spin_unlock(&pers_lock);
> +               } else {
> +                       pr_err("md-cluster module not found.\n");
> +                       spin_unlock(&pers_lock);
> +                       return -ENODEV;
> +               }
>          }
> -       spin_unlock(&pers_lock);
>
>          return md_cluster_ops->join(mddev, nodes);
>   }
>
>>>> I looked at linux-next and it appears this code is the same; is there
>>>> a test we can do before attempting to load the module in the case that
>>>> its built-in, or is there some other requirement that md-cluster needs
>>>> to be built as a module?
>>> Yes, we need some additional modules corosync/pacemaker and dlm,
>> That doesn't explain the error message though.
>
> You are right, I should read carefully :(
>
>> If MD_CLUSTER is built in, then DLM must be too.
>
> Sure,  then only need to ensure cluster is configured right.
>
> Best Regards,
> Guoqing

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJXyAhIAAoJEDnsnt1WYoG5TlcQAIQ1KY7VviYRaDo1oh/ie8fA
C+q8ikCCLt6VbpSTdhZUb4aPe6ZUV0EOfg76aowWj34VH110wY5AHyg2GJjYncf+
uOzA6jDewzIZEiv7N9n04W9krbB27CQJrgBvttY6blYYB1v4A5NGJcI29ohUsx0i
1usUfiIXf5B1iwKlB2WuKZu0qIYQmi8ytUCU4Au7RSL4gT2eBaPUN8MLNdnCHXus
XkEw/Vf3SivDbE7I4JmNtPjrn1fs1F3frDtL0RHOStFdziAPrE6rlKJcKTEAUicO
h/uf37442L3VqPCYlmubqpd7ggL9eI17v/wtPR6/pMoh86t9iEhdqkPwOnbjv+EC
M2Xb2uHPnZMoYglHvmC1xEr7tazeIoSQyK8i9/u/53KktiNLBsHEu/Axr1rdI9tb
ykvfP077Q/ayKqCd2oviAyG3H4YvdQqhUdqjiFhVyCNFaN0Xnbnf26BMR9h6aGdq
QDdCdpeKxUS8Pl+yqR181MI44OK8kKUGzeWzcq6ZHU0XN8hHLBbahHKv0PV9DMv6
QA0685j3JUbJYtR2sG2vFUd23p/GwyWvFSauaTJVhCJTJ79odGZZ18sPaQDDGCkl
Nyx/m3ZKYG90/KOgRvpl9DaSfRJpjVZ4bEg8TApIUqVcLX78N7rTdtoepwvFpTSG
nNfTixzHqj7ZHLxe8s6U
=r8Wh
-----END PGP SIGNATURE-----
--=-=-=--

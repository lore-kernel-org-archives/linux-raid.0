From: NeilBrown <neilb@suse.de>
Subject: Re: [md:for-next 15/15] drivers/md/md.c:7582:6: warning: passing
 argument 2 of 'constant_test_bit' from incompatible pointer type
Date: Tue, 20 Nov 2012 11:21:05 +1100
Message-ID: <20121120112105.23f15b54@notabene.brown>
References: <50aac8b2.i4eO3rNuSChi5+J9%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jK9A_+L1crFe9BZmH1cifYX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50aac8b2.i4eO3rNuSChi5+J9%fengguang.wu@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: majianpeng <majianpeng@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jK9A_+L1crFe9BZmH1cifYX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Nov 2012 08:02:58 +0800 kbuild test robot <fengguang.wu@intel.co=
m>
wrote:

> tree:   git://neil.brown.name/md for-next
> head:   ef59c0770a46e77abba72994170ffe121e56a362
> commit: ef59c0770a46e77abba72994170ffe121e56a362 [15/15] md: Use ->curr_r=
esync as last completed request when cleanly aborting resync.
> config: i386-randconfig-x070 (attached as .config)
>=20
> All warnings:
>=20
> drivers/md/md.c: In function 'md_do_sync':
> drivers/md/md.c:7582:6: warning: passing argument 2 of 'constant_test_bit=
' from incompatible pointer type [enabled by default]
> In file included from include/linux/bitops.h:22:0,
>                  from include/linux/kernel.h:10,
>                  from include/linux/sched.h:15,
>                  from include/linux/kthread.h:5,
>                  from drivers/md/md.c:35:
> arch/x86/include/asm/bitops.h:318:28: note: expected 'const volatile long=
 unsigned int *' but argument is of type 'sector_t *'
> drivers/md/md.c:7582:6: warning: passing argument 2 of 'variable_test_bit=
' from incompatible pointer type [enabled by default]
> In file included from include/linux/bitops.h:22:0,
>                  from include/linux/kernel.h:10,
>                  from include/linux/sched.h:15,
>                  from include/linux/kthread.h:5,
>                  from drivers/md/md.c:35:
> arch/x86/include/asm/bitops.h:324:19: note: expected 'const volatile long=
 unsigned int *' but argument is of type 'sector_t *'
>=20
> vim +7582 +/constant_test_bit drivers/md/md.c
>=20
> ^1da177e Linus Torvalds 2005-04-16  7566  	 */
> ^1da177e Linus Torvalds 2005-04-16  7567   out:
> 7c2c57c9 majianpeng     2012-07-03  7568  	blk_finish_plug(&plug);
> ^1da177e Linus Torvalds 2005-04-16  7569  	wait_event(mddev->recovery_wai=
t, !atomic_read(&mddev->recovery_active));
> ^1da177e Linus Torvalds 2005-04-16  7570 =20
> ^1da177e Linus Torvalds 2005-04-16  7571  	/* tell personality that we ar=
e finished */
> 57afd89f NeilBrown      2005-06-21  7572  	mddev->pers->sync_request(mdde=
v, max_sectors, &skipped, 1);
> ^1da177e Linus Torvalds 2005-04-16  7573 =20
> dfc70645 NeilBrown      2008-05-23  7574  	if (!test_bit(MD_RECOVERY_CHEC=
K, &mddev->recovery) &&
> 5fd6c1dc NeilBrown      2006-06-26  7575  	    mddev->curr_resync > 2) {
> 5fd6c1dc NeilBrown      2006-06-26  7576  		if (test_bit(MD_RECOVERY_SYNC=
, &mddev->recovery)) {
> 5fd6c1dc NeilBrown      2006-06-26  7577  			if (test_bit(MD_RECOVERY_INT=
R, &mddev->recovery)) {
> 5fd6c1dc NeilBrown      2006-06-26  7578  				if (mddev->curr_resync >=3D=
 mddev->recovery_cp) {
> 5fd6c1dc NeilBrown      2006-06-26  7579  					printk(KERN_INFO
> 61df9d91 NeilBrown      2006-10-03  7580  					       "md: checkpointing =
%s of %s.\n",
> 61df9d91 NeilBrown      2006-10-03  7581  					       desc, mdname(mddev)=
);
> ef59c077 majianpeng     2012-11-19 @7582  					if (test_bit(MD_RECOVERY_E=
RROR,
> ef59c077 majianpeng     2012-11-19  7583  						&mddev->recovery_cp))
> ef59c077 majianpeng     2012-11-19  7584  						mddev->recovery_cp =3D
> ef59c077 majianpeng     2012-11-19  7585  							mddev->curr_resync_compl=
eted;


Thanks again!  I've fixed it by merging the following.

NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 13eb270..7816ab6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7580,7 +7580,7 @@ void md_do_sync(struct md_thread *thread)
 					       "md: checkpointing %s of %s.\n",
 					       desc, mdname(mddev));
 					if (test_bit(MD_RECOVERY_ERROR,
-						&mddev->recovery_cp))
+						&mddev->recovery))
 						mddev->recovery_cp =3D
 							mddev->curr_resync_completed;
 					else

--Sig_/jK9A_+L1crFe9BZmH1cifYX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKrM8Tnsnt1WYoG5AQLSzw/7BESPjXSt9MYV2yv/efCCZRjE2aJQJVHE
ElS/Sw3rbyS7b5KnFKJCCY2Ug+7qlN+krfAdOO9TSx6ax3oTDqjntnJJFePUceS4
yWkyntwV+7+H/UNe6FkPnbekTV7XGlWUv0tMpBpceJ9tlkp2ImKiBgb0hVwEKjMK
AltU6X55kTQN9v9qge9sxE5qbt4/mKikTDn+FZXJVD6JYALG+Zp2GZ7AobmmhYjM
YcqdfKMmYwUE0vatSnFaOVl954ikGVcTeN5P7c6NU8blGd+wV5GywOMzw4+Jaas7
q2aHdMc1nZ26rPlkBC2KItK5lo6tr0ABfvBtljyZGrBAnoVw+YJSXtPqvNoeJ8oj
jVW/CQX3TzOILVa+hJ/2crm/yET6AK5QMi7uXdnYR4sRm34CjQmX7gZG2eKQWPyg
gvkXv9eEtBnS7Edgn3NGILVKfY17fQMF+QAMjjDa94+CSqqjbM3q6rb6qON7sqFQ
jY7vnuiUTRw02TWI4HhhjLbXB+XaNMvWloy8lbKXlPGc02JATuyl1d8ky+K908/f
ZhK1nfItknA5rnLaUfogkyQrpEG9pyBOqPr6BEz8FwiFoDugAlpVSX0/UlWXk6fd
EZefu74MSbPoQ+gIrC5RxymsA4UpJigrUjOcHD7m4uGSoE+CYt4dxhKUZYaSnjXC
srEO1fQNXrQ=
=11kd
-----END PGP SIGNATURE-----

--Sig_/jK9A_+L1crFe9BZmH1cifYX--

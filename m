From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: Using slow_path to release stripe when
 mmdev->threand is null
Date: Thu, 7 Nov 2013 16:43:11 +1100
Message-ID: <20131107164311.5edfe48d@notabene.brown>
References: <201311070958386657802@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/a003De59XNTt/1j=iwogB.8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201311070958386657802@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/a003De59XNTt/1j=iwogB.8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Nov 2013 09:58:42 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Starting a failed raid5,kernel print those messages:
> [    7.085934] md/raid:md127: not enough operational devices (3/4 failed)
> [    7.085941] RAID conf printout:
> [    7.085942]  --- level:5 rd:4 wd:1
> [    7.085944]  disk 0, o:1, dev:sdb
> [    7.085948]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> [    7.085950] BUG raid5-md127 (Not tainted): Objects remaining in raid5-=
md127 on kmem_cache_close()
> [    7.085951]
> -------------------------------------------------------------------------=
----
> [    7.085951]
> [    7.085952] Disabling lock debugging due to kernel taint
> [    7.085955] INFO: Slab 0xffffea0002e44800 objects=3D24 used=3D16 fp=3D=
0xffff8800b9127698 flags=3D0x100000000004080
> [    7.085958] CPU: 0 PID: 2176 Comm: mdadm Tainted: G    B 3.12.0+ #2
> [    7.085959] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./To be filled by O.E.M., BIOS 080015  11/09/2011
> [    7.085961]  ffff88013aa38600 ffff8800b8f71b58 ffffffff81704891 ffff88=
00b9127698
> [    7.085963]  ffffea0002e44800 ffff8800b8f71c48 ffffffff8113c7c7 207374=
63656a624f
> [    7.085966]  6e696e69616d6572 696172206e692067 373231646d2d3564 6d656d=
6b206e6f20
> [    7.085968] Call Trace:
> [    7.085974]  [<ffffffff81704891>] dump_stack+0x49/0x60
> [    7.085977]  [<ffffffff8113c7c7>] slab_err+0x97/0xb0
> [    7.085980]  [<ffffffff8113ee90>] ? slab_cpuup_callback+0xd0/0xd0
> [    7.085982]  [<ffffffff8113eeeb>] ? flush_cpu_slab+0x5b/0x70
> [    7.085984]  [<ffffffff8113fc64>] ? __kmalloc+0xf4/0x170
> [    7.085986]  [<ffffffff811421cb>]
> list_slab_objects.clone.0+0x5b/0x160
> [    7.085988]  [<ffffffff811429cb>] __kmem_cache_shutdown+0xdb/0x1b0
> [    7.085992]  [<ffffffff8111853d>] kmem_cache_destroy+0x5d/0x100
> [    7.085996]  [<ffffffffa008dd1d>] free_conf+0x5d/0x120 [raid456]
> [    7.085999]  [<ffffffffa0090cf9>] run+0x8d9/0xa71 [raid456]
> [    7.086015]  [<ffffffff81516a97>] md_run+0x377/0x8b0
> [    7.086023]  [<ffffffff81516fe9>] do_md_run+0x19/0xc0
> [    7.086025]  [<ffffffff815172d8>] array_state_store+0x248/0x260
> [    7.086027]  [<ffffffff815102ef>] md_attr_store+0xdf/0x120
> [    7.086031]  [<ffffffff811b73ed>] sysfs_write_file+0xdd/0x160
> [    7.086033]  [<ffffffff81146f58>] vfs_write+0xc8/0x170
> [    7.086036]  [<ffffffff8114753a>] SyS_write+0x5a/0xa0
> [    7.086038]  [<ffffffff817105e2>] system_call_fastpath+0x16/0x1b
> [    7.086040] INFO: Object 0xffff8800b9120000 @offset=3D0
> [    7.086042] INFO: Object 0xffff8800b9120528 @offset=3D1320
> [    7.086043] INFO: Object 0xffff8800b9120a50 @offset=3D2640
> [    7.086044] INFO: Object 0xffff8800b9120f78 @offset=3D3960
> [    7.086045] INFO: Object 0xffff8800b91214a0 @offset=3D5280
> [    7.086046] INFO: Object 0xffff8800b91219c8 @offset=3D6600
> [    7.086048] INFO: Object 0xffff8800b9121ef0 @offset=3D7920
> [    7.086049] INFO: Object 0xffff8800b9122418 @offset=3D9240
> [    7.086050] INFO: Object 0xffff8800b9122940 @offset=3D10560
> [    7.086051] INFO: Object 0xffff8800b9122e68 @offset=3D11880
> [    7.086052] INFO: Object 0xffff8800b9123390 @offset=3D13200
> [    7.086054] INFO: Object 0xffff8800b91238b8 @offset=3D14520
> [    7.086055] INFO: Object 0xffff8800b9123de0 @offset=3D15840
> [    7.086057] INFO: Object 0xffff8800b9124308 @offset=3D17160
> [    7.086058] INFO: Object 0xffff8800b9124830 @offset=3D18480
> [    7.086059] INFO: Object 0xffff8800b9124d58 @offset=3D19800
> [    7.086061] kmem_cache_destroy raid5-md127: Slab cache still has bjects
> [    7.086063] CPU: 0 PID: 2176 Comm: mdadm Tainted: G    B 3.12.0+ #2
> [    7.086064] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./To be filled by O.E.M., BIOS 080015  11/09/2011
> [    7.086065]  ffff8800b92eaa00 ffff8800b8f71cd8 ffffffff81704891 000000=
0000015740
> [    7.086068]  ffff88013aa38600 ffff8800b8f71cf8 ffffffff811185dd 000000=
0000000000
> [    7.086070]  ffff8800b92eaa00 ffff8800b8f71d28 ffffffffa008dd1d ffff88=
013a16d800
> [    7.086072] Call Trace:
> [    7.086074]  [<ffffffff81704891>] dump_stack+0x49/0x60
> [    7.086077]  [<ffffffff811185dd>] kmem_cache_destroy+0xfd/0x100
> [    7.086080]  [<ffffffffa008dd1d>] free_conf+0x5d/0x120 [raid456]
> [    7.086082]  [<ffffffffa0090cf9>] run+0x8d9/0xa71 [raid456]
> [    7.086085]  [<ffffffff81516a97>] md_run+0x377/0x8b0
> [    7.086087]  [<ffffffff81516fe9>] do_md_run+0x19/0xc0
> [    7.086089]  [<ffffffff815172d8>] array_state_store+0x248/0x260
> [    7.086091]  [<ffffffff815102ef>] md_attr_store+0xdf/0x120
> [    7.086094]  [<ffffffff811b73ed>] sysfs_write_file+0xdd/0x160
> [    7.086096]  [<ffffffff81146f58>] vfs_write+0xc8/0x170
> [    7.086098]  [<ffffffff8114753a>] SyS_write+0x5a/0xa0
> [    7.086100]  [<ffffffff817105e2>] system_call_fastpath+0x16/0x1b
> [    7.086104] md/raid:md127: failed to run raid set.
> [    7.086105] md: pers->run() failed ...
>=20
> This is because when called release_stripe() in grow_one_stripe(), the
> mddev->thread is null.So it will omit one wakeup this thread to release
> stripe.
> For this condition, using slow_path to release stripe.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f8b9068..e93eb7b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -340,7 +340,11 @@ static void release_stripe(struct stripe_head *sh)
>  	unsigned long flags;
>  	bool wakeup;
> =20
> -	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
> +	/*
> +	 * Before creating mmdev->thread,this func willbe called.
> +	 */
> +	if (unlikely(!conf->mddev->thread) ||
> +		test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
>  		goto slow_path;
>  	wakeup =3D llist_add(&sh->release_list, &conf->released_stripes);
>  	if (wakeup)



applied, thanks.

NeilBrown

--Sig_/a003De59XNTt/1j=iwogB.8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnsobznsnt1WYoG5AQJMpw//XixmIUjce46RnEe0FhHhxrQH0T04sXqf
ZAf3OtN4Q0DJvYBvh34d7byZFJDrBr9BOXB4GuOAkqUt9A6yght/lfcv7NKPfRqv
zZ9h1LncTungF0Nzed64viZs9wcR6kbJpKZmyFztUORl5LVizyRxQoS9dHnJVSvo
ku2X7TR8sayQfQjELqWGWUag9cEBMnuxQLYRq/J6Pbgk5SF8DSk1e2eBOx5YthGc
26CJtZfIXU1WP2LgZCLhF+EnRtZtc52egsWRDBMezMqr584pYgMNXDjQCTJT5Oe1
CtPkXRO6tstyk25VHy9ClHYvk3YO+d4xknKtGBcHmYfx4t6lIeE9nMJmqlCcXRZL
HMi4CIb8ZewdehtKUNA7yyDY7zQMxQmlTMMsBdkQQhXgNsaiozYWiFIAQhlVMQI5
n4xj9fuSO56rF87sX5+fg2eGk9wnx2DC+iVlbMWmElvA3PTZxHAHxRmL5KnARUtz
bxlVzXjb2z4JEDYhK0if6M57qTQPWNrpHf+iZejx52LY3Qh4J9M6xsaZMlVr0RF1
R8xNyl+XcMdNiaqpSGVsDEsNlBQaDMIONylGOEOh/ebEGdQEHSr0IVWo+AD1JUYc
qw2fe81tl3wQ1Bb3+vxgU0wURzURzHhkLtIabd54FlJgjKBRkZ1h2qDgch/lM0VI
jgcVllS4sHg=
=/VP2
-----END PGP SIGNATURE-----

--Sig_/a003De59XNTt/1j=iwogB.8--

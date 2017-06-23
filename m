From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] md: oops sync_page_io+0x38/0x180
Date: Sat, 24 Jun 2017 09:28:24 +1000
Message-ID: <874lv61dyf.fsf@notabene.neil.brown.name>
References: <20170623104744.GA5830@ming.t460p> <20170623111601.GB5830@ming.t460p> <20170623162410.ngf5o2o36axmc67p@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170623162410.ngf5o2o36axmc67p@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Ming Lei <ming.lei@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 23 2017, Shaohua Li wrote:

> On Fri, Jun 23, 2017 at 07:16:02PM +0800, Ming Lei wrote:
>> On Fri, Jun 23, 2017 at 06:47:44PM +0800, Ming Lei wrote:
>> > Hi,
>> >=20
>> > When I boot a VM, the following kernel oops is triggerd:
>> >=20
>> > [    4.850206] BUG: unable to handle kernel NULL pointer dereference a=
t 00000000000006a0
>> > [    4.851131] IP: sync_page_io+0x38/0x180
>> > [    4.851445] PGD 2759bc067
>> > [    4.851446] P4D 2759bc067
>> > [    4.851621] PUD 277838067
>> > [    4.851835] PMD 0
>> >=20
>> > [    4.852152] Oops: 0000 [#1] PREEMPT SMP
>> > [    4.852494] Dumping ftrace buffer:
>> > [    4.852758]    (ftrace buffer empty)
>> > [    4.853062] Modules linked in: nd_pmem psmouse serio_raw ahci libah=
ci floppy nvme nvme_core ib_iser rdma_cm iw_cm ib_cm ib_core configfs iscsi=
_tcp libiscsi_tcp libiscsi scsi_transport_iscsi null_blk configs autofs4
>> > [    4.855190] CPU: 3 PID: 661 Comm: mdadm Not tainted 4.12.0-rc6.quie=
sce-v3-next-20170623-09867-ga73468728fd8 #248
>> > [    4.856310] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIO=
S rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
>> > [    4.857458] task: ffffa33bf749b340 task.stack: ffffa667812e8000
>> > [    4.857992] RIP: 0010:sync_page_io+0x38/0x180
>> > [    4.858349] RSP: 0018:ffffa667812ebb18 EFLAGS: 00010297
>> > [    4.858804] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffd4=
3fc9da2100
>> > [    4.859465] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffa3=
3bf740d800
>> > [    4.860137] RBP: ffffa667812ebb50 R08: 0000000000000000 R09: 000000=
0000000000
>> > [    4.860774] R10: 0000000023386c39 R11: 0000000000000000 R12: ffffa3=
3bf740d800
>> > [    4.861817] R13: 0000000000000000 R14: 0000000000000000 R15: 000000=
0000000001
>> > [    4.863150] FS:  00007f0aa0304700(0000) GS:ffffa33bfac00000(0000) k=
nlGS:0000000000000000
>> > [    4.864412] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > [    4.865001] CR2: 00000000000006a0 CR3: 0000000276883000 CR4: 000000=
00003406e0
>> > [    4.865663] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000=
0000000000
>> > [    4.866332] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000=
0000000400
>> > [    4.867025] Call Trace:
>> > [    4.867178]  read_disk_sb.constprop.66+0x72/0xc0
>> > [    4.867572]  super_1_load+0xb7/0x7a0
>> > [    4.867897]  ? blkdev_get_by_dev+0x58/0x70
>> > [    4.868222]  ? lock_rdev+0x6c/0xb0
>> > [    4.868476]  md_import_device+0x187/0x230
>> > [    4.868851]  ? check_preemption_disabled+0x35/0x120
>> > [    4.869266]  add_new_disk+0xc2/0x760
>> > [    4.869541]  md_ioctl+0x1fc7/0x23a0
>> > [    4.869824]  ? __might_fault+0x67/0xd0
>> > [    4.870109]  ? autostart_arrays+0x710/0x710
>> > [    4.870451]  blkdev_ioctl+0x5b8/0xbd0
>> > [    4.870750]  block_ioctl+0x61/0x80
>> > [    4.871003]  ? blkdev_fallocate+0x240/0x240
>> > [    4.871371]  do_vfs_ioctl+0xb0/0x890
>> > [    4.871640]  ? check_preemption_disabled+0x35/0x120
>> > [    4.872061]  ? entry_SYSCALL_64_fastpath+0x5/0xc2
>> > [    4.872463]  ? __this_cpu_preempt_check+0x1c/0x20
>> > [    4.872867]  ? __fget_light+0x56/0xb0
>> > [    4.873148]  ? security_file_ioctl+0x62/0x80
>> > [    4.873498]  SyS_ioctl+0x94/0xc0
>> > [    4.873735]  entry_SYSCALL_64_fastpath+0x23/0xc2
>> > [    4.874121] RIP: 0033:0x7f0a9fe26687
>> > [    4.874391] RSP: 002b:00007ffca16ec628 EFLAGS: 00000246 ORIG_RAX: 0=
000000000000010
>> > [    4.875105] RAX: ffffffffffffffda RBX: 00007ffca16efa6b RCX: 00007f=
0a9fe26687
>> > [    4.875779] RDX: 00007ffca16eca38 RSI: 0000000040140921 RDI: 000000=
0000000004
>> > [    4.876544] RBP: ffffffffa35cbbcc R08: 0000000000200000 R09: 000000=
0000000014
>> > [    4.877253] R10: 0000000000000361 R11: 0000000000000246 R12: ffffa6=
67812ebf88
>> > [    4.877968] R13: 0000000000000004 R14: 00007ffca16ec8cd R15: 000000=
0001db35b0
>> > [    4.878657]  ? __this_cpu_preempt_check+0x1c/0x20
>> > [    4.879341] Code: 41 55 41 54 49 89 fc 53 49 89 f5 45 89 ce 48 83 e=
c 10 89 55 d0 48 89 4d c8 44 89 45 d4 44 8b 7d 10 e8 7d 63 91 ff 49 8b 44 2=
4 18 <48> 8b 98 a0 06 00 00 48 85 db 0f 84 12 01 00 00 e8 63 63 91 ff
>> > [    4.885691] RIP: sync_page_io+0x38/0x180 RSP: ffffa667812ebb18
>> > [    4.886208] CR2: 00000000000006a0
>> > [    4.886441] ---[ end trace 5e7fbbf3076a4aab ]---
>>=20
>> Looks this oops is caused by the following patch:
>>=20
>> 	5a85071c2cbc md: use a separate bio_set for synchronous IO.
>>=20
>> Once it is reverted, my VM boots successfully without this oops.
>
> Thanks for the report, this should fix it:
>
>
> commit 7f053a6a745557b3f3ad63e9d28ba85c3c0b1563
> Author: Shaohua Li <shli@fb.com>
> Date:   Fri Jun 23 09:19:49 2017 -0700
>
>     MD: fix a null dereference
>=20=20=20=20=20
>     rdev->mddev could be null in start time.
>=20=20=20=20=20
>     Reported-by: Ming Lei <ming.lei@redhat.com>
>     Fix: 5a85071c2cbc(md: use a separate bio_set for synchronous IO.)
>     Cc: NeilBrown <neilb@suse.com>
>     Signed-off-by: Shaohua Li <shli@fb.com>
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 65ad837aeb54..092b48f8095e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -205,7 +205,7 @@ EXPORT_SYMBOL_GPL(bio_alloc_mddev);
>=20=20
>  static struct bio *md_bio_alloc_sync(struct mddev *mddev)
>  {
> -	if (!mddev->sync_set)
> +	if (!mddev || !mddev->sync_set)
>  		return bio_alloc(GFP_NOIO, 1);
>=20=20
>  	return bio_alloc_bioset(GFP_NOIO, 1, mddev->sync_set);


Yes,  Thanks.
I remember removing that test :-(  My thinking was exactly backwards.
We really don't need that test in the *old* bio_alloc_mddev() now, but
I removed it from the *new* md_bio_alloc_sync() instead.
Probably simplest to just leave it in bio_alloc_mddev(). It doesn't
hurt.

Sorry...
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllNpBoACgkQOeye3VZi
gbm3FA/9HaY4J1nnq9RASqZnnaA0rD8ySRd6ifNbqoZBgmsEd8kfPgNQltRZb8G0
duucRhsXM5CvA9fqeRJR8QvHcXhbwDY/gXfXdyHd73kdC0kMquio+tWei0elCg1j
6n7djo/2NJSmSkxKfny+7WGMc0Yymq5lHZ3t9aLsLWiki3HsvYWLJF3SnNXtqRH+
D1PHNFvSAD/KrWvuZKduPZpl28XdwqyekYSjOwHqz5gjziVD8gNx6tQdf16bX4+B
pr3zEJzSMQ8d7X2OPHNVIl6lcDubx1GrqiCMjRdg4pJY4frh8ToeT76NJGzwtL34
CBcy/tLhGFSiUKFYEWza5QgxHuJr70oZ4zQbp00CBMlTwISXY1fY99mjkoDKku3k
TJP3KNpptoTCRWf2JSuNmvY+E1WsWTyrjpkgZvR5tlSuVXiiNgQOzG5/i1KliMi7
pU/3xjQHJZix6cArYXfo4ouNvDrlmN8pdCDVqigs3SIBguMWZTcKr6QQcs7XveH/
EqkptlUyGWnLqgbYJRPpz/2P+YLcfinP4BgfNAhWCMTpwDq3jQ5aq7EbPEDVXnxo
RMKQief6ARu4q4ONoUiKeR1IOLhZDvHGu4mhdSIydlJLy9yX0XqT9nw10d38dDFa
irap+LsS2BG4bWxNwetBnECHTe9L+lBwOxJq5u9YunznIuxILT8=
=CtiO
-----END PGP SIGNATURE-----
--=-=-=--

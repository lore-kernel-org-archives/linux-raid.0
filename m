From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 lockups post ca64cae96037de16e4af92678814f5d4bf0c1c65
Date: Wed, 13 Mar 2013 10:35:13 +1100
Message-ID: <20130313103513.350f24f7@notabene.brown>
References: <wrfj1ubvi88x.fsf@redhat.com>
	<20130305080010.6285b435@notabene.brown>
	<wrfjlia2fd6h.fsf@redhat.com>
	<20130306131804.0b39752a@notabene.brown>
	<wrfj4ngog9h0.fsf@redhat.com>
	<20130312093231.72c54735@notabene.brown>
	<20130312123224.62018981@notabene.brown>
	<wrfjobeo91fb.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jb=DSn3WJx87LRkHnjPH1Xc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjobeo91fb.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, Eryu Guan <eguan@redhat.com>
List-Id: linux-raid.ids

--Sig_/jb=DSn3WJx87LRkHnjPH1Xc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Mar 2013 14:45:44 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> NeilBrown <neilb@suse.de> writes:
> > On Tue, 12 Mar 2013 09:32:31 +1100 NeilBrown <neilb@suse.de> wrote:
> >
> >> On Wed, 06 Mar 2013 10:31:55 +0100 Jes Sorensen <Jes.Sorensen@redhat.c=
om>
> >> wrote:
> >>=20
> >
> >> >=20
> >> > I am attaching the test script I am running too. It was written by E=
ryu
> >> > Guan.
> >>=20
> >> Thanks for that.  I've tried using it but haven't managed to trigger a=
 BUG
> >> yet.  What size are the loop files?  I mostly use fairly small ones, b=
ut
> >> maybe it needs to be bigger to trigger the problem.
> >
> > Shortly after I wrote that I got a bug-on!  It hasn't happened again th=
ough.
> >
> > This was using code without that latest patch I sent.  The bug was
> > 		BUG_ON(s->uptodate !=3D disks);
> >
> > in the check_state_compute_result case of handle_parity_checks5() which=
 is
> > probably the same cause as your most recent BUG.
> >
> > I've revised my thinking a bit and am now running with this patch which=
 I
> > think should fix a problem that probably caused the symptoms we have se=
en.
> >
> > If you could run your tests for a while too and is whether it will stil=
l crash
> > for you, I'd really appreciate it.
>=20
> Hi Neil,
>=20
> Sorry I can't verify the line numbers of my old test since I managed to
> mess up my git tree in the process :(
>=20
> However running with this new patch I have just hit another but
> different case. Looks like a deadlock.

You test setup is clearly different from mine.  I've been running all night
without a single hiccup.

>=20
> This is basically running ca64cae96037de16e4af92678814f5d4bf0c1c65 with
> your patch applied on top, and nothing else.
>=20
> If you want me to try a more uptodate Linus tree, please let me know.
>=20
> Cheers,
> Jes
>=20
>=20
> [17635.205927] INFO: task mkfs.ext4:20060 blocked for more than 120 secon=
ds.
> [17635.213543] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [17635.222291] mkfs.ext4       D ffff880236814100     0 20060  20026 0x00=
000080
> [17635.230199]  ffff8801bc8bbb98 0000000000000082 ffff88022f0be540 ffff88=
01bc8bbfd8
> [17635.238518]  ffff8801bc8bbfd8 ffff8801bc8bbfd8 ffff88022d47b2a0 ffff88=
022f0be540
> [17635.246837]  ffff8801cea1f430 000000000001d5f0 ffff8801c7f4f430 ffff88=
022169a400
> [17635.255161] Call Trace:
> [17635.257891]  [<ffffffff81614f79>] schedule+0x29/0x70
> [17635.263433]  [<ffffffffa0386ada>] make_request+0x6da/0x6f0 [raid456]
> [17635.270525]  [<ffffffff81084210>] ? wake_up_bit+0x40/0x40
> [17635.276560]  [<ffffffff814a6633>] md_make_request+0xc3/0x200
> [17635.282884]  [<ffffffff81134655>] ? mempool_alloc_slab+0x15/0x20
> [17635.289586]  [<ffffffff812c70d2>] generic_make_request+0xc2/0x110
> [17635.296393]  [<ffffffff812c7199>] submit_bio+0x79/0x160
> [17635.302232]  [<ffffffff811ca625>] ? bio_alloc_bioset+0x65/0x120
> [17635.308844]  [<ffffffff812ce234>] blkdev_issue_discard+0x184/0x240
> [17635.315748]  [<ffffffff812cef76>] blkdev_ioctl+0x3b6/0x810
> [17635.321877]  [<ffffffff811cb971>] block_ioctl+0x41/0x50
> [17635.327714]  [<ffffffff811a6aa9>] do_vfs_ioctl+0x99/0x580
> [17635.333745]  [<ffffffff8128a19a>] ? inode_has_perm.isra.30.constprop.6=
0+0x2a/0x30
> [17635.342103]  [<ffffffff8128b6d7>] ? file_has_perm+0x97/0xb0
> [17635.348329]  [<ffffffff811a7021>] sys_ioctl+0x91/0xb0
> [17635.353972]  [<ffffffff810de9dc>] ? __audit_syscall_exit+0x3ec/0x450
> [17635.361070]  [<ffffffff8161e759>] system_call_fastpath+0x16/0x1b

There is a small race in the exclusion between discard and recovery.
This patch on top should fix it (I hope).
Thanks for testing.

NeilBrown

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c216dd3..636d492 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4246,14 +4246,14 @@ static void make_discard_request(struct mddev *mdde=
v, struct bio *bi)
 		sh =3D get_active_stripe(conf, logical_sector, 0, 0, 0);
 		prepare_to_wait(&conf->wait_for_overlap, &w,
 				TASK_UNINTERRUPTIBLE);
-		spin_lock_irq(&sh->stripe_lock);
+		set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
 		if (test_bit(STRIPE_SYNCING, &sh->state)) {
-			set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
-			spin_unlock_irq(&sh->stripe_lock);
 			release_stripe(sh);
 			schedule();
 			goto again;
 		}
+		clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
+		spin_lock_irq(&sh->stripe_lock);
 		for (d =3D 0; d < conf->raid_disks; d++) {
 			if (d =3D=3D sh->pd_idx || d =3D=3D sh->qd_idx)
 				continue;

--Sig_/jb=DSn3WJx87LRkHnjPH1Xc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUT+7sTnsnt1WYoG5AQJcEA//aazEgaosCaXa1qISF0MiQuSDDUZ9k2QG
MWAIl7a+5sntbfoy6RI4T4zYvO4o+O+vmy4bhNyqxwVjfwFGL9uYViuDqWGFxcuJ
XInQD3dF3NHkIsz3uMLsp4U4SvfLT9zNl4Bk8rGx8t5sjRPYwdSSjf5c98F2lDbG
EyFySVXBfX5/8mzQJ5lHBB6hZFW9ppRhfJxsM0vsMwMrIc9zDEKItLjn2T5TvimY
NwKFahsfGqKjX51bsKAWb5pSoXtc9/QslcKqoLGJ5bG+K9y4hhrUBEshqDjVdQ8n
NgUnLR1efUTs/5poUVN70ZK/8QmAlxVi2u/WSAYtQtl0mGNscEwNG+U1nJEnKYdX
7RajPqnl/7K/62hw5Ws5dAxSLR75mSGhSclkptLmD27+8J5Uzeu+bkZ+lpC4bTk+
TJxTW5BvtAF4Qe9S7GsZLdwTbNeNrv6oQcYGICkjYQaOlfGEPurvyIx2N7AKIiMH
ghwADhwGFst/GepPN6TmvpAdlYp8p7jAVra7A3w3gU+VNT2+LtjmUOrE446+awgD
WUN8ufUEiMN50p9gk+QwwyAXlj1Lq8ULKdeumi0lCaOx76RA52cnru2e2+tiQq0a
lGQjopO1NxdQIHrNXrwwG26ccur1MPx6dq/m4T8lRpLfLaAHJDF/wdFbdgloYpvc
FbHMs1PpzE4=
=WJyO
-----END PGP SIGNATURE-----

--Sig_/jb=DSn3WJx87LRkHnjPH1Xc--

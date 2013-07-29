From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid5: raid5d livelocks after drive failure during resync
Date: Mon, 29 Jul 2013 15:25:22 +1000
Message-ID: <20130729152522.63c35e5c@notabene.brown>
References: <CAGRgLy7GoknqbUSYFk82FnuNVBkvznqZZF7+FK1L3kPq7_C6wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N.Vm2MMvwXpbVp6.2/4rs_g"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7GoknqbUSYFk82FnuNVBkvznqZZF7+FK1L3kPq7_C6wQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, yair@zadarastorage.com, Shyam Kaushik <shyam@zadarastorage.com>, vladimir@zadarastorage.com
List-Id: linux-raid.ids

--Sig_/N.Vm2MMvwXpbVp6.2/4rs_g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jul 2013 13:59:29 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> we have a 3-drive raid5, that was resyncing, but then one drive
> failed. As a result, now raid5 is livelocked on 100% cpu, and the
> failed drive is not ejected from the array.
> Kernel is ubuntu-precise 3.2.0-25 40 plus following patches applied manua=
lly:
>=20
> commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
> Author: Shaohua Li <shli <at> kernel.org>
> Date:   Tue Jul 3 15:57:19 2012 +1000
>     raid5: delayed stripe fix
>=20
> and
>=20
> commit a7854487cd7128a30a7f4f5259de9f67d5efb95f
> Author: Alexander Lyakas <alex.bolshoy@gmail.com>
> Date:   Thu Oct 11 13:50:12 2012 +1100
>     md: When RAID5 is dirty, force reconstruct-write instead of
> read-modify-write.
>=20
> /proc/mdstat shows:
>=20
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md2 : active raid5 dm-5[0] dm-7[2](F) dm-6[1]
>       7809200128 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/2] [=
UU_]
>         resync=3DPENDING
>       bitmap: 29/30 pages [116KB], 65536KB chunk
>=20
> >From the patches applied to that kernel above our version, the
> following seems somewhat relevant:
>=20
> cc1ceee md/raid5: In ops_run_io, inc nr_pending before calling
> md_wait_for_blocked_rdev
>=20
> but in our case badblocks are disabled.
> (original conversation is in http://www.spinics.net/lists/raid/msg39191.h=
tml).
>=20
> Here are some stacks that we captured and appropriate places in the code:
>=20
> [] __cond_resched+0x2a/0x40
> [] handle_stripe+0x400/0x1d80 [raid456]
> [] raid5d+0x463/0x650 [raid456]
> [] md_thread+0x10e/0x140
> [] kthread+0x8c/0xa0
> [] kernel_thread_helper+0x4/0x10
> [] 0xffffffffffffffff
> 0x59e0 is in handle_stripe
> (/mnt/work/alex/Ubuntu-3.2.0-25.40/drivers/md/raid5.c:495).
> 490             struct r5conf *conf =3D sh->raid_conf;
> 491             int i, disks =3D sh->disks;
> 492
> 493             might_sleep();
> 494
> 495             for (i =3D disks; i--; ) {
> 496                     int rw;
> 497                     struct bio *bi;
> 498                     struct md_rdev *rdev;
> 499                     if (test_and_clear_bit(R5_Wantwrite,
> &sh->dev[i].flags)) {
>=20
> [] __cond_resched+0x2a/0x40
> [] raid5d+0x470/0x650 [raid456]
> [] md_thread+0x10e/0x140
> [] kthread+0x8c/0xa0
> [] kernel_thread_helper+0x4/0x10
> [] 0xffffffffffffffff
> 0x8d80 is in raid5d (/mnt/work/alex/Ubuntu-3.2.0-25.40/drivers/md/raid5.c=
:4306).
> 4301                    handled++;
> 4302                    handle_stripe(sh);
> 4303                    release_stripe(sh);
> 4304                    cond_resched();
> 4305
> 4306                    if (mddev->flags & ~(1<<MD_CHANGE_PENDING))
> 4307                            md_check_recovery(mddev);
> 4308
> 4309                    spin_lock_irq(&conf->device_lock);
> 4310            }
>=20
> [] md_wakeup_thread+0x28/0x30
> [] __release_stripe+0x101/0x1d0 [raid456]
> [] release_stripe+0x4d/0x60 [raid456]
> [] raid5d+0x46b/0x650 [raid456]
> [] md_thread+0x10e/0x140
> [] kthread+0x8c/0xa0
> [] kernel_thread_helper+0x4/0x10
> 0x1be1 is in __release_stripe
> (/mnt/work/alex/Ubuntu-3.2.0-25.40/drivers/md/raid5.c:227).
> 222                                     if (conf->retry_read_aligned)
> 223
> md_wakeup_thread(conf->mddev->thread);
> 224                             }
> 225                     }
> 226             }
> 227     }
> 228
> 229     static void release_stripe(struct stripe_head *sh)
> 230     {
> 231             struct r5conf *conf =3D sh->raid_conf;
>=20
> [] __cond_resched+0x2a/0x40
> [] handle_stripe+0x5dc/0x1d80 [raid456]
> [] raid5d+0x463/0x650 [raid456]
> [] md_thread+0x10e/0x140
> [] kthread+0x8c/0xa0
> [] kernel_thread_helper+0x4/0x10
> [] 0xffffffffffffffff
> 0x5bbc is in handle_stripe
> (/usr/src/linux-headers-3.2.0-25-generic/arch/x86/include/asm/bitops.h:12=
1).
> 116      * clear_bit() is atomic and implies release semantics before the=
 memory
> 117      * operation. It can be used for an unlock.
> 118      */
> 119     static inline void clear_bit_unlock(unsigned nr, volatile
> unsigned long *addr)
> 120     {
> 121             barrier();
> 122             clear_bit(nr, addr);
> 123     }
> 124
> 125     static inline void __clear_bit(int nr, volatile unsigned long *ad=
dr)
>=20
> [] __cond_resched+0x2a/0x40
> [] handle_stripe+0xde/0x1d80 [raid456]
> [] raid5d+0x463/0x650 [raid456]
> [] md_thread+0x10e/0x140
> [] kthread+0x8c/0xa0
> [] kernel_thread_helper+0x4/0x10
> 0x56be is in handle_stripe (include/linux/spinlock.h:310).
> 305             raw_spin_lock_nest_lock(spinlock_check(lock),
> nest_lock);       \
> 306     } while (0)
> 307
> 308     static inline void spin_lock_irq(spinlock_t *lock)
> 309     {
> 310             raw_spin_lock_irq(&lock->rlock);
> 311     }
> 312
> 313     #define spin_lock_irqsave(lock, flags)                          \
> 314     do {
>=20
> [] md_wakeup_thread+0x28/0x30
> [] __release_stripe+0x101/0x1d0 [raid456]
> [] release_stripe+0x42/0x60 [raid456]
> [] raid5d+0x46b/0x650 [raid456]
> [] md_thread+0x10e/0x140
> [] kthread+0x8c/0xa0
> [] kernel_thread_helper+0x4/0x10
> 0x1cf2 is in release_stripe (include/linux/spinlock.h:340).
> 335             raw_spin_unlock_irq(&lock->rlock);
> 336     }
> 337
> 338     static inline void spin_unlock_irqrestore(spinlock_t *lock,
> unsigned long flags)
> 339     {
> 340             raw_spin_unlock_irqrestore(&lock->rlock, flags);
> 341     }
> 342
> 343     static inline int spin_trylock_bh(spinlock_t *lock)
> 344     {
>=20
> Can you pls advise what might be the issue?
>=20
> Thanks,
> Alex.


sorry, but nothing occurs to me that might be the cause.

NeilBrown

--Sig_/N.Vm2MMvwXpbVp6.2/4rs_g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfX8wznsnt1WYoG5AQKIqA/8CyoRFJtsl6kSSnayKkf1G4+sPEtyQ+WL
ex1rer02as8W9t92q1Y9zpbBNecWWBaOLo+XBDfZCROk5fzvAIgWsXNlWcGpO5K7
ET1NdmZlbSe0WoeKdTbh/x4SkJcPGsYug3RelYPkolc/kE/e2dOK1QRxP4i5P7fh
fIQKXpskpKdpT5FFfgtvQMB2YdO3Vbk8vBXu3WLkmBgdJy4cKxbFv36/5fFSpHTj
96tYRKeGBWQTmCtKZ1JjkChpF0esmarrf3oNu0pTNRt9eVjkPyXAkK0HGfhbonC3
Me5dfDR97fBBMo27evhBWgj/WX4BhgHk0U63WO70LY8taSUtGVSEmk3rZN2YbFSK
iMUsn8+7vQeUT8db/Wv5Nt/UoAbk5fwGB9/IXkhxVOs0ho6xenuM2vM+u2Lu5zfc
F8RwWeDxHMZBEzn0bmMzOqW+/9y7Bhhiafv2XgGLK1GBNawYezDt20+wjgDDINu/
wmwp39cLSvspXe2oOdG+At+hmTSndPENcbbhw1js/+TpRqPqdxxcviXslqcznUtX
gbjGJMdpFxPBfflPw6vwkjOOv6THFBu3EnVjnfk/JtUWfH++RyL6mkVAd1g3R4Z0
UKfaXsFAo1rf/CMsvUTXVgycIrvpYISg9bg/uCOW2aQu3TWTvoYZ4bTjFg0bUkUh
UCIxzHQjkzU=
=DhHV
-----END PGP SIGNATURE-----

--Sig_/N.Vm2MMvwXpbVp6.2/4rs_g--

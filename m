From: NeilBrown <neilb@suse.de>
Subject: Re: Failed drive in raid6 while doing data-check
Date: Tue, 5 Jun 2012 13:35:04 +1000
Message-ID: <20120605133504.4a760a05@notabene.brown>
References: <1338744674.28212.293.camel@oxygen.netxsys.com>
	<20120604135619.402f4316@notabene.brown>
	<1338815946.28212.307.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CzO6H+6woKj_lcCgtRFUhwW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338815946.28212.307.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CzO6H+6woKj_lcCgtRFUhwW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jun 2012 09:19:06 -0400 Krzysztof Adamski <k@adamski.org> wrote:

> On Mon, 2012-06-04 at 13:56 +1000, NeilBrown wrote:
> > On Sun, 03 Jun 2012 13:31:14 -0400 Krzysztof Adamski <k@adamski.org> wr=
ote:
> >=20
> > > The monthly data check found a bad drive in my raid6 array. This is w=
hat
> > > started to show up in the log:
> > > Jun  3 12:02:53 rogen kernel: [9908355.355940] sd 2:0:1:0: attempting=
 task abort! scmd(ffff8801547c6a00)
> > > Jun  3 12:02:53 rogen kernel: [9908355.355953] sd 2:0:1:0: [sdb] CDB:=
 Read(10): 28 00 e4 5c ed 38 00 00 08 00
> > > Jun  3 12:02:53 rogen kernel: [9908355.355983] scsi target2:0:1: hand=
le(0x0009), sas_address(0x4433221100000000), phy(0)
> > > Jun  3 12:02:53 rogen kernel: [9908355.355992] scsi target2:0:1: encl=
osure_logical_id(0x500605b003f7aa10), slot(3)
> > > Jun  3 12:02:56 rogen kernel: [9908359.141194] sd 2:0:1:0: task abort=
: SUCCESS scmd(ffff8801547c6a00)
> > > Jun  3 12:02:56 rogen kernel: [9908359.141206] sd 2:0:1:0: attempting=
 task abort! scmd(ffff8803aea45400)
> > > Jun  3 12:02:56 rogen kernel: [9908359.141216] sd 2:0:1:0: [sdb] CDB:=
 Read(10): 28 00 e4 5c ed 40 00 00 08 00
> > >=20
> > > But now it has changed to this:
> > > Jun  3 12:04:44 rogen kernel: [9908466.716281] sd 2:0:1:0: [sdb] Unha=
ndled error code
> > > Jun  3 12:04:44 rogen kernel: [9908466.716287] sd 2:0:1:0: [sdb]  Res=
ult: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
> > > Jun  3 12:04:44 rogen kernel: [9908466.716296] sd 2:0:1:0: [sdb] CDB:=
 Read(10): 28 00 e4 5c ee 38 00 00 08 00
> > > Jun  3 12:04:44 rogen kernel: [9908466.716319] end_request: I/O error=
, dev sdb, sector 3831295544
> > > Jun  3 12:04:44 rogen kernel: [9908466.716616] sd 2:0:1:0: [sdb]  Res=
ult: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
> > > Jun  3 12:04:44 rogen kernel: [9908466.717200] mpt2sas0: removing han=
dle(0x0009), sas_addr(0x4433221100000000)
> > > Jun  3 12:04:44 rogen kernel: [9908466.917090] md/raid:md7: Disk fail=
ure on sdb2, disabling device.
> > > Jun  3 12:04:44 rogen kernel: [9908466.917091] md/raid:md7: Operation=
 continuing on 11 devices.
> > > Jun  3 12:07:41 rogen kernel: [9908643.882541] INFO: task md7_resync:=
28497 blocked for more than 120 seconds.
> > > Jun  3 12:07:41 rogen kernel: [9908643.882552] "echo 0 > /proc/sys/ke=
rnel/hung_task_timeout_secs" disables this message.
> > > Jun  3 12:07:41 rogen kernel: [9908643.882556] md7_resync      D ffff=
8800b508aa20     0 28497      2 0x00000000
> > > Jun  3 12:07:41 rogen kernel: [9908643.882560]  ffff8802ab877b80 0000=
000000000046 ffff8803ffbfa340 0000000000000046
> > > Jun  3 12:07:41 rogen kernel: [9908643.882564]  ffff8802ab876010 ffff=
8800b508a6a0 00000000001d29c0 ffff8802ab877fd8
> > > Jun  3 12:07:41 rogen kernel: [9908643.882566]  ffff8802ab877fd8 0000=
0000001d29c0 ffff880070448000 ffff8800b508a6a0
> > > Jun  3 12:07:41 rogen kernel: [9908643.882569] Call Trace:
> > > Jun  3 12:07:41 rogen kernel: [9908643.882577]  [<ffffffff81339704>] =
schedule+0x55/0x57
> > > Jun  3 12:07:41 rogen kernel: [9908643.882599]  [<ffffffffa01da26b>] =
bitmap_cond_end_sync+0xbc/0x152 [md_mod]
> > > Jun  3 12:07:41 rogen kernel: [9908643.882602]  [<ffffffff8106190d>] =
? wake_up_bit+0x25/0x25
> > > Jun  3 12:07:41 rogen kernel: [9908643.882607]  [<ffffffffa022f7a7>] =
sync_request+0x22e/0x2ef [raid456]
> > > Jun  3 12:07:41 rogen kernel: [9908643.882613]  [<ffffffffa01d1ebc>] =
? is_mddev_idle+0x106/0x118 [md_mod]
> > > Jun  3 12:07:41 rogen kernel: [9908643.882618]  [<ffffffffa01d2689>] =
md_do_sync+0x7bb/0xbce [md_mod]
> > > Jun  3 12:07:41 rogen kernel: [9908643.882624]  [<ffffffffa01d2cbe>] =
md_thread+0xff/0x11d [md_mod]
> > > Jun  3 12:07:41 rogen kernel: [9908643.882629]  [<ffffffffa01d2bbf>] =
? md_rdev_init+0x8d/0x8d [md_mod]
> > > Jun  3 12:07:41 rogen kernel: [9908643.882631]  [<ffffffff81061499>] =
kthread+0x9b/0xa3
> > > Jun  3 12:07:41 rogen kernel: [9908643.882634]  [<ffffffff81342ca4>] =
kernel_thread_helper+0x4/0x10
> > > Jun  3 12:07:41 rogen kernel: [9908643.882637]  [<ffffffff810613fe>] =
? __init_kthread_worker+0x56/0x56
> > > Jun  3 12:07:41 rogen kernel: [9908643.882639]  [<ffffffff81342ca0>] =
? gs_change+0x13/0x13
> > > Jun  3 12:07:41 rogen kernel: [9908643.882641] INFO: lockdep is turne=
d off.
> > >=20
> > > The cat /proc/mdstat is:
> > > Personalities : [raid1] [raid6] [raid5] [raid4]
> > > md7 : active raid6 sdd2[0] sdab2[11] sdaa2[10] sdz2[9] sdy2[8] sde2[7=
] sdh2[6] sdf2[5] sdg2[4] sdb2[3](F) sdc2[2] sda2[1]
> > >       29283121600 blocks super 1.2 level 6, 32k chunk, algorithm 2 [1=
2/11] [UUU_UUUUUUUU]
> > >       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.......]  check =3D 65=
.3% (1913765076/2928312160) finish=3D44345.9min speed=3D381K/sec
> > >       bitmap: 1/22 pages [4KB], 65536KB chunk
> > >=20
> > > I don't really want to wait 30 days for this to finish, what is corre=
ct
> > > thing to do before I replace the failed drive?
> > >
> >=20
> > If it is still hanging, then I suspect a reboot is your only way forwar=
d.
> > This should not affect the data on the array.
>=20
> Nothing more is being written to the log, but there is no progress:
>=20
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md7 : active raid6 sdd2[0] sdab2[11] sdaa2[10] sdz2[9] sdy2[8] sde2[7] sd=
h2[6] sdf2[5] sdg2[4] sdb2[3](F) sdc2[2] sda2[1]
>       29283121600 blocks super 1.2 level 6, 32k chunk, algorithm 2 [12/11=
] [UUU_UUUUUUUU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.......]  check =3D 65.3% =
(1913765076/2928312160) finish=3D660982.5min speed=3D25K/sec
>       bitmap: 4/22 pages [16KB], 65536KB chunk
>=20
>=20
> > What kernel are you running?  I'll see if I can find the cause.
>=20
> Self compiled:
> # cat /proc/version=20
> Linux version 3.0.18-KAA (root@rogen) (gcc version 4.4.5 (Debian 4.4.5-8)=
 ) #1 SMP Fri Jan 27 18:35:11 EST 2012
>=20
> I can provide any other info that is needed.

Thanks.
I have a theory about what might be causing it, but I cannot duplicated the
problem.  I think you were quite "unlucky" to hit it.

If I'm right you might be able to kick the 'check' back into life by reading
from the area of the array that is currently being synced. i.e. about=20
19137650760K into the array.

dd skip=3D19137650000 bs=3D1024 count=3D2000 if=3D/dev/md7 of=3D/dev/null

might do it.

The thread that is doing the 'check' is blocked in bitmap_cond_sync_end,
waiting for all pending check requests to complete.  It only does this every
5 seconds or so, so oncs in hundreds of requests.  (It doesn't really need =
to
for 'check', only for 'sync', but it does anyway).

But for some reason one request isn't completing.  That should mean that
STRIPE_INSYNC is not yet set on a 'struct stripe_head'.

I'm guessing that it has processed by handle_parity_checks6, noticed in the
check_state_check_result  case that s->failed is non-zero, and so set=20
sh->check_state to check_state_compute_result, but then nothing caused
the stripe to go around the loop again.  The code there should probably
set STRIPE_HANDLE.. Maybe.

If the dead disk provides data to that stripe, rather than parity, then the
read should set STRIPE_HANDLE and the handling of the stripe can progress.

It might not work, but it is worth a try.  What should happen is that the
check will immediately abort.  If it doesn't you probably need to schedule a
reboot ... if you haven't already.

NeilBrown

--Sig_/CzO6H+6woKj_lcCgtRFUhwW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT81+aDnsnt1WYoG5AQLUqg/9HZNjzQMpGJdf8msE9yPTcfve9fuOp+JT
0syfSX8JwKrunpMNDVC6NcFJV1pOTdBKO0/iSi5XwDXrD8sIs2qHuW/jkTPx9vqm
wtrupoBuz4JrE+oONPad3Pz4GuALj9cGBHaV+yjTLP2tnogdpI69lXbzRx9GU+H5
0P0czaaJXhsSqPb5sf/vZx4Kv3Cx3SPgXIlT3z2y86F2vsnaHiNj8TIT14J761YI
e++D5a9hwC/quwaekqvsdfGlbvfYc1XZYtkgYw6NH7mGpRZ8BQ4vhzKZ8rtCflH/
7W9IuSbD7t7BfKIN/vP9o3bkJ18o1MqhCi/u0vFYDNYtxmQzMR1SCA0KFeOBcthZ
fAN6P8pP6M3DDcKxOMMRPWnajTV64M7u59mZTAR81+TLevdnp6DjyMy8oslSHEMf
65fBs6UAaeY5nAd6VtEmwJwxbzP/Hat3cp4EzV0SmZD8tUArODJYF9wQxnM6J28j
qD6ts+kLAREH5BV6wIIXEVxGMjBZ1bbaMAzUL45XkAJlA43PwLRKHkU4wll7UHlh
s9lBQuZjJvkqizEqI3rctJ307/NNXtKib37AxExq51oStv8jIZBluyUUrDvtSwu6
YFTAVGH+FeBMBoUA0HDO5+w/Q6WAto38oYo2gSTkjgJ/Gi0BqWEeBgznSsAyhyKH
RLGf1j/LaX4=
=tde3
-----END PGP SIGNATURE-----

--Sig_/CzO6H+6woKj_lcCgtRFUhwW--

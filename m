From: NeilBrown <neilb@suse.de>
Subject: Re: Failed drive in raid6 while doing data-check
Date: Wed, 6 Jun 2012 11:22:31 +1000
Message-ID: <20120606112231.6b8301f2@notabene.brown>
References: <1338744674.28212.293.camel@oxygen.netxsys.com>
	<20120604135619.402f4316@notabene.brown>
	<1338815946.28212.307.camel@oxygen.netxsys.com>
	<20120605133504.4a760a05@notabene.brown>
	<1338914882.28212.365.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kJyh7=B5JLht18xRCkm5n08"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338914882.28212.365.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kJyh7=B5JLht18xRCkm5n08
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Jun 2012 12:48:02 -0400 Krzysztof Adamski <k@adamski.org> wrote:

> On Tue, 2012-06-05 at 13:35 +1000, NeilBrown wrote:
> > On Mon, 04 Jun 2012 09:19:06 -0400 Krzysztof Adamski <k@adamski.org> wr=
ote:
> >=20
> > > On Mon, 2012-06-04 at 13:56 +1000, NeilBrown wrote:
> > > > On Sun, 03 Jun 2012 13:31:14 -0400 Krzysztof Adamski <k@adamski.org=
> wrote:
> > > >=20
> > > > > The monthly data check found a bad drive in my raid6 array. This =
is what
> > > > > started to show up in the log:
> > > > > Jun  3 12:02:53 rogen kernel: [9908355.355940] sd 2:0:1:0: attemp=
ting task abort! scmd(ffff8801547c6a00)
> > > > > Jun  3 12:02:53 rogen kernel: [9908355.355953] sd 2:0:1:0: [sdb] =
CDB: Read(10): 28 00 e4 5c ed 38 00 00 08 00
> > > > > Jun  3 12:02:53 rogen kernel: [9908355.355983] scsi target2:0:1: =
handle(0x0009), sas_address(0x4433221100000000), phy(0)
> > > > > Jun  3 12:02:53 rogen kernel: [9908355.355992] scsi target2:0:1: =
enclosure_logical_id(0x500605b003f7aa10), slot(3)
> > > > > Jun  3 12:02:56 rogen kernel: [9908359.141194] sd 2:0:1:0: task a=
bort: SUCCESS scmd(ffff8801547c6a00)
> > > > > Jun  3 12:02:56 rogen kernel: [9908359.141206] sd 2:0:1:0: attemp=
ting task abort! scmd(ffff8803aea45400)
> > > > > Jun  3 12:02:56 rogen kernel: [9908359.141216] sd 2:0:1:0: [sdb] =
CDB: Read(10): 28 00 e4 5c ed 40 00 00 08 00
> > > > >=20
> > > > > But now it has changed to this:
> > > > > Jun  3 12:04:44 rogen kernel: [9908466.716281] sd 2:0:1:0: [sdb] =
Unhandled error code
> > > > > Jun  3 12:04:44 rogen kernel: [9908466.716287] sd 2:0:1:0: [sdb] =
 Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
> > > > > Jun  3 12:04:44 rogen kernel: [9908466.716296] sd 2:0:1:0: [sdb] =
CDB: Read(10): 28 00 e4 5c ee 38 00 00 08 00
> > > > > Jun  3 12:04:44 rogen kernel: [9908466.716319] end_request: I/O e=
rror, dev sdb, sector 3831295544
> > > > > Jun  3 12:04:44 rogen kernel: [9908466.716616] sd 2:0:1:0: [sdb] =
 Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
> > > > > Jun  3 12:04:44 rogen kernel: [9908466.717200] mpt2sas0: removing=
 handle(0x0009), sas_addr(0x4433221100000000)
> > > > > Jun  3 12:04:44 rogen kernel: [9908466.917090] md/raid:md7: Disk =
failure on sdb2, disabling device.
> > > > > Jun  3 12:04:44 rogen kernel: [9908466.917091] md/raid:md7: Opera=
tion continuing on 11 devices.
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882541] INFO: task md7_res=
ync:28497 blocked for more than 120 seconds.
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882552] "echo 0 > /proc/sy=
s/kernel/hung_task_timeout_secs" disables this message.
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882556] md7_resync      D =
ffff8800b508aa20     0 28497      2 0x00000000
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882560]  ffff8802ab877b80 =
0000000000000046 ffff8803ffbfa340 0000000000000046
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882564]  ffff8802ab876010 =
ffff8800b508a6a0 00000000001d29c0 ffff8802ab877fd8
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882566]  ffff8802ab877fd8 =
00000000001d29c0 ffff880070448000 ffff8800b508a6a0
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882569] Call Trace:
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882577]  [<ffffffff8133970=
4>] schedule+0x55/0x57
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882599]  [<ffffffffa01da26=
b>] bitmap_cond_end_sync+0xbc/0x152 [md_mod]
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882602]  [<ffffffff8106190=
d>] ? wake_up_bit+0x25/0x25
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882607]  [<ffffffffa022f7a=
7>] sync_request+0x22e/0x2ef [raid456]
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882613]  [<ffffffffa01d1eb=
c>] ? is_mddev_idle+0x106/0x118 [md_mod]
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882618]  [<ffffffffa01d268=
9>] md_do_sync+0x7bb/0xbce [md_mod]
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882624]  [<ffffffffa01d2cb=
e>] md_thread+0xff/0x11d [md_mod]
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882629]  [<ffffffffa01d2bb=
f>] ? md_rdev_init+0x8d/0x8d [md_mod]
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882631]  [<ffffffff8106149=
9>] kthread+0x9b/0xa3
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882634]  [<ffffffff81342ca=
4>] kernel_thread_helper+0x4/0x10
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882637]  [<ffffffff810613f=
e>] ? __init_kthread_worker+0x56/0x56
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882639]  [<ffffffff81342ca=
0>] ? gs_change+0x13/0x13
> > > > > Jun  3 12:07:41 rogen kernel: [9908643.882641] INFO: lockdep is t=
urned off.
> > > > >=20
> > > > > The cat /proc/mdstat is:
> > > > > Personalities : [raid1] [raid6] [raid5] [raid4]
> > > > > md7 : active raid6 sdd2[0] sdab2[11] sdaa2[10] sdz2[9] sdy2[8] sd=
e2[7] sdh2[6] sdf2[5] sdg2[4] sdb2[3](F) sdc2[2] sda2[1]
> > > > >       29283121600 blocks super 1.2 level 6, 32k chunk, algorithm =
2 [12/11] [UUU_UUUUUUUU]
> > > > >       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.......]  check =
=3D 65.3% (1913765076/2928312160) finish=3D44345.9min speed=3D381K/sec
> > > > >       bitmap: 1/22 pages [4KB], 65536KB chunk
> > > > >=20
> > > > > I don't really want to wait 30 days for this to finish, what is c=
orrect
> > > > > thing to do before I replace the failed drive?
> > > > >
> > > >=20
> > > > If it is still hanging, then I suspect a reboot is your only way fo=
rward.
> > > > This should not affect the data on the array.
> > >=20
> > > Nothing more is being written to the log, but there is no progress:
> > >=20
> > > Personalities : [raid1] [raid6] [raid5] [raid4]
> > > md7 : active raid6 sdd2[0] sdab2[11] sdaa2[10] sdz2[9] sdy2[8] sde2[7=
] sdh2[6] sdf2[5] sdg2[4] sdb2[3](F) sdc2[2] sda2[1]
> > >       29283121600 blocks super 1.2 level 6, 32k chunk, algorithm 2 [1=
2/11] [UUU_UUUUUUUU]
> > >       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.......]  check =3D 65=
.3% (1913765076/2928312160) finish=3D660982.5min speed=3D25K/sec
> > >       bitmap: 4/22 pages [16KB], 65536KB chunk
> > >=20
> > >=20
> > > > What kernel are you running?  I'll see if I can find the cause.
> > >=20
> > > Self compiled:
> > > # cat /proc/version=20
> > > Linux version 3.0.18-KAA (root@rogen) (gcc version 4.4.5 (Debian 4.4.=
5-8) ) #1 SMP Fri Jan 27 18:35:11 EST 2012
> > >=20
> > > I can provide any other info that is needed.
> >=20
> > Thanks.
> > I have a theory about what might be causing it, but I cannot duplicated=
 the
> > problem.  I think you were quite "unlucky" to hit it.
> >=20
> > If I'm right you might be able to kick the 'check' back into life by re=
ading
> > from the area of the array that is currently being synced. i.e. about=20
> > 19137650760K into the array.
> >=20
> > dd skip=3D19137650000 bs=3D1024 count=3D2000 if=3D/dev/md7 of=3D/dev/nu=
ll
> >=20
> > might do it.
> >=20
> > The thread that is doing the 'check' is blocked in bitmap_cond_sync_end,
> > waiting for all pending check requests to complete.  It only does this =
every
> > 5 seconds or so, so oncs in hundreds of requests.  (It doesn't really n=
eed to
> > for 'check', only for 'sync', but it does anyway).
> >=20
> > But for some reason one request isn't completing.  That should mean that
> > STRIPE_INSYNC is not yet set on a 'struct stripe_head'.
> >=20
> > I'm guessing that it has processed by handle_parity_checks6, noticed in=
 the
> > check_state_check_result  case that s->failed is non-zero, and so set=20
> > sh->check_state to check_state_compute_result, but then nothing caused
> > the stripe to go around the loop again.  The code there should probably
> > set STRIPE_HANDLE.. Maybe.
> >=20
> > If the dead disk provides data to that stripe, rather than parity, then=
 the
> > read should set STRIPE_HANDLE and the handling of the stripe can progre=
ss.
> >=20
> > It might not work, but it is worth a try.  What should happen is that t=
he
> > check will immediately abort.  If it doesn't you probably need to sched=
ule a
> > reboot ... if you haven't already.
>=20
> I had to do a reboot already.
>=20
> The drive was wedged for same reason, activity light solid, soft reboot
> (shutdown -r now) didn't wake it up, the card bios didn't see it. I
> pulled and reinserted it for it to be recognized by the LSI card.

Maybe that was the problem.  If md had sent a request to the drive and not
received any reply, (success or failure) it would keep waiting until it got
one.

>=20
> I added it to the array and the rebuild took few minutes (thanks for the
> bitmap). I forced a recheck and after 12 hours everything is good.

:-)

>=20
> This was not the first time where I saw this kind of stop in the check
> when one drive stops working in this machine, but with different adaptor
> card and different drives. I will try what you suggested if it happens
> again.=20

I looked at the code again and realised I was missing something and it
couldn't possibly lock up where I thought it might.  So while that experime=
nt
won't hurt, it is very unlikely to help.


>=20
> Now I wonder if I should have just pulled/reinserted the drive to see
> what would have happened.

Yes, that would be interesting.

Thanks,
NeilBrown

--Sig_/kJyh7=B5JLht18xRCkm5n08
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT86w1znsnt1WYoG5AQIhyQ//YGyLZYg5rIb+x+VkOCHVeYz1sH2Lux5F
uLeImiOAvAqR9FCG2UsrkIVKIb1IoLJUTIz1FJ3ZWnv1fMwpwItyFxXDxt0Fp3DS
MXgyWf6mua4WdnoYfOD10kEP7l0o8b1BjH7t61zm5B+N5cuVZ1iRiaUUbIRcQeJ3
PuNdt2O0tlc2TaoL78pZJaqkzWRyP4hrkxCbTixcKbBhe3C0Dbp/a6Hpq9eSHg+v
gE++ZxfsejgD0nTw0hXFSdoa8inmEPokKvrGcHYJxazSkB/v9a2ESWrs17y3PYg9
rz6H1FfLJv4aFsXsc9VhZteKNAmG+oYnMmAPbm5CBts8lSB64fjb4SuICkyuMxWk
QXOevWh2XfMTLcTksCC9C5etZhm4qitvzlhbvfB+wOazy1FfeWsJCmOioEIbCyHL
Ryb/wEdy6VZAiS/cQXGc+DQh/PqD7gs8RzveaxtYgFxdch/sTgt7Q+N4pW6wTMEJ
vnacuzMwIqEaU28JhK2ocMcCMoeukx9+Q1V5eChE4yjcNxTtoxUsPxnf75tA3UFg
FfrQKbLQySGqIW0Ip/SibVPvRGSRk0LVeoYNusWTrHNvz41kpli23wZwJM0wITO3
9tK53VmcS1xPtK/0PIIh4aMfrhE8YYeN5B5F6y3DdSjEowHF/ZgSty3ZUrupN0YY
y+PFYrA8Oqw=
=sGZF
-----END PGP SIGNATURE-----

--Sig_/kJyh7=B5JLht18xRCkm5n08--

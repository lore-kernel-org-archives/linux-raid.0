From: NeilBrown <neilb@suse.de>
Subject: Re: Failed drive in raid6 while doing data-check
Date: Mon, 4 Jun 2012 13:56:19 +1000
Message-ID: <20120604135619.402f4316@notabene.brown>
References: <1338744674.28212.293.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GSnkBq8+xPB+/7+rX9zl+nz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338744674.28212.293.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GSnkBq8+xPB+/7+rX9zl+nz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 03 Jun 2012 13:31:14 -0400 Krzysztof Adamski <k@adamski.org> wrote:

> The monthly data check found a bad drive in my raid6 array. This is what
> started to show up in the log:
> Jun  3 12:02:53 rogen kernel: [9908355.355940] sd 2:0:1:0: attempting tas=
k abort! scmd(ffff8801547c6a00)
> Jun  3 12:02:53 rogen kernel: [9908355.355953] sd 2:0:1:0: [sdb] CDB: Rea=
d(10): 28 00 e4 5c ed 38 00 00 08 00
> Jun  3 12:02:53 rogen kernel: [9908355.355983] scsi target2:0:1: handle(0=
x0009), sas_address(0x4433221100000000), phy(0)
> Jun  3 12:02:53 rogen kernel: [9908355.355992] scsi target2:0:1: enclosur=
e_logical_id(0x500605b003f7aa10), slot(3)
> Jun  3 12:02:56 rogen kernel: [9908359.141194] sd 2:0:1:0: task abort: SU=
CCESS scmd(ffff8801547c6a00)
> Jun  3 12:02:56 rogen kernel: [9908359.141206] sd 2:0:1:0: attempting tas=
k abort! scmd(ffff8803aea45400)
> Jun  3 12:02:56 rogen kernel: [9908359.141216] sd 2:0:1:0: [sdb] CDB: Rea=
d(10): 28 00 e4 5c ed 40 00 00 08 00
>=20
> But now it has changed to this:
> Jun  3 12:04:44 rogen kernel: [9908466.716281] sd 2:0:1:0: [sdb] Unhandle=
d error code
> Jun  3 12:04:44 rogen kernel: [9908466.716287] sd 2:0:1:0: [sdb]  Result:=
 hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
> Jun  3 12:04:44 rogen kernel: [9908466.716296] sd 2:0:1:0: [sdb] CDB: Rea=
d(10): 28 00 e4 5c ee 38 00 00 08 00
> Jun  3 12:04:44 rogen kernel: [9908466.716319] end_request: I/O error, de=
v sdb, sector 3831295544
> Jun  3 12:04:44 rogen kernel: [9908466.716616] sd 2:0:1:0: [sdb]  Result:=
 hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
> Jun  3 12:04:44 rogen kernel: [9908466.717200] mpt2sas0: removing handle(=
0x0009), sas_addr(0x4433221100000000)
> Jun  3 12:04:44 rogen kernel: [9908466.917090] md/raid:md7: Disk failure =
on sdb2, disabling device.
> Jun  3 12:04:44 rogen kernel: [9908466.917091] md/raid:md7: Operation con=
tinuing on 11 devices.
> Jun  3 12:07:41 rogen kernel: [9908643.882541] INFO: task md7_resync:2849=
7 blocked for more than 120 seconds.
> Jun  3 12:07:41 rogen kernel: [9908643.882552] "echo 0 > /proc/sys/kernel=
/hung_task_timeout_secs" disables this message.
> Jun  3 12:07:41 rogen kernel: [9908643.882556] md7_resync      D ffff8800=
b508aa20     0 28497      2 0x00000000
> Jun  3 12:07:41 rogen kernel: [9908643.882560]  ffff8802ab877b80 00000000=
00000046 ffff8803ffbfa340 0000000000000046
> Jun  3 12:07:41 rogen kernel: [9908643.882564]  ffff8802ab876010 ffff8800=
b508a6a0 00000000001d29c0 ffff8802ab877fd8
> Jun  3 12:07:41 rogen kernel: [9908643.882566]  ffff8802ab877fd8 00000000=
001d29c0 ffff880070448000 ffff8800b508a6a0
> Jun  3 12:07:41 rogen kernel: [9908643.882569] Call Trace:
> Jun  3 12:07:41 rogen kernel: [9908643.882577]  [<ffffffff81339704>] sche=
dule+0x55/0x57
> Jun  3 12:07:41 rogen kernel: [9908643.882599]  [<ffffffffa01da26b>] bitm=
ap_cond_end_sync+0xbc/0x152 [md_mod]
> Jun  3 12:07:41 rogen kernel: [9908643.882602]  [<ffffffff8106190d>] ? wa=
ke_up_bit+0x25/0x25
> Jun  3 12:07:41 rogen kernel: [9908643.882607]  [<ffffffffa022f7a7>] sync=
_request+0x22e/0x2ef [raid456]
> Jun  3 12:07:41 rogen kernel: [9908643.882613]  [<ffffffffa01d1ebc>] ? is=
_mddev_idle+0x106/0x118 [md_mod]
> Jun  3 12:07:41 rogen kernel: [9908643.882618]  [<ffffffffa01d2689>] md_d=
o_sync+0x7bb/0xbce [md_mod]
> Jun  3 12:07:41 rogen kernel: [9908643.882624]  [<ffffffffa01d2cbe>] md_t=
hread+0xff/0x11d [md_mod]
> Jun  3 12:07:41 rogen kernel: [9908643.882629]  [<ffffffffa01d2bbf>] ? md=
_rdev_init+0x8d/0x8d [md_mod]
> Jun  3 12:07:41 rogen kernel: [9908643.882631]  [<ffffffff81061499>] kthr=
ead+0x9b/0xa3
> Jun  3 12:07:41 rogen kernel: [9908643.882634]  [<ffffffff81342ca4>] kern=
el_thread_helper+0x4/0x10
> Jun  3 12:07:41 rogen kernel: [9908643.882637]  [<ffffffff810613fe>] ? __=
init_kthread_worker+0x56/0x56
> Jun  3 12:07:41 rogen kernel: [9908643.882639]  [<ffffffff81342ca0>] ? gs=
_change+0x13/0x13
> Jun  3 12:07:41 rogen kernel: [9908643.882641] INFO: lockdep is turned of=
f.
>=20
> The cat /proc/mdstat is:
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md7 : active raid6 sdd2[0] sdab2[11] sdaa2[10] sdz2[9] sdy2[8] sde2[7] sd=
h2[6] sdf2[5] sdg2[4] sdb2[3](F) sdc2[2] sda2[1]
>       29283121600 blocks super 1.2 level 6, 32k chunk, algorithm 2 [12/11=
] [UUU_UUUUUUUU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.......]  check =3D 65.3% =
(1913765076/2928312160) finish=3D44345.9min speed=3D381K/sec
>       bitmap: 1/22 pages [4KB], 65536KB chunk
>=20
> I don't really want to wait 30 days for this to finish, what is correct
> thing to do before I replace the failed drive?
>

If it is still hanging, then I suspect a reboot is your only way forward.
This should not affect the data on the array.

What kernel are you running?  I'll see if I can find the cause.

NeilBrown

--Sig_/GSnkBq8+xPB+/7+rX9zl+nz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8wx4znsnt1WYoG5AQJzNhAAnDrbny90hjowbYZmfwvp19s4h6L8Z1Ui
IQn6S5KpywiyW1b6a4BlpYLwy+Xjdpk4LksjMY9k0opXmRaE4ecky/LOJQZwckO4
YtFNteTk/e7nuoLHrFdYpQsJOSlub7UDyReSD7asK8O2Z2vYqsaYlm7fWiN8hZag
WXUOMlVHsGwbnbAxyk4K4Qq0Cd14WNHJyivDomaACVdLrPsgSVg8UTv/1juzQ491
GPizJZnRVRDhVW8AItngyKeULKoQ2sfM0VT04R3jhBlVMKvU739+8b9aVkysf/Kx
IrIf2Iql28K2kCeyB1+xamqWpWXGjGQwEkwTQJiUQ1u1uj3jUSr8ZNAPiZICf2hf
5NtMQOwWNXQPpxwk/T+kffhUoDc+SWoNYB3+FnY+FV+/1JyhL8VK5bfwucveu1xB
Arw4Iafi+NX0cjxk4Sk4nl7y6aP7pkZFAXtmBRiwq/upLP76ZJmSi2dQunnjwlV/
PcEZsmFrSBS+JlGA+qG+yTGhavDujNBv4FxvQWlFFNz1X6ZGScWMk/ymSBWN18/P
V9tHAKuN7e2bHXpsaqo5cXRIyLibYeVcyBRHkbSU2umXNiLnGS8u99Vl6qizfcgZ
0S4LLZSHAeQdRU5b6GdbxdVt+c0oLNr9DLYVKwagBh9TirFp9M5wIrIrnfTTjkBB
xOibFBy8lGQ=
=WPKm
-----END PGP SIGNATURE-----

--Sig_/GSnkBq8+xPB+/7+rX9zl+nz--

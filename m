From: NeilBrown <neilb@suse.de>
Subject: Re: failed reshape!
Date: Mon, 12 Dec 2011 14:39:20 +1100
Message-ID: <20111212143920.76a9c189@notabene.brown>
References: <CAExWWQhjV5PH6AEd59MhHUchLHD0b75rDwA2956DTLk0k_VG-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TOfwCK62YT4sotrg=Y5NFty"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAExWWQhjV5PH6AEd59MhHUchLHD0b75rDwA2956DTLk0k_VG-A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Gavin Peters (=?UTF-8?B?6JOL5paH5b285b635pav?=)" <gavin@ytz.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/TOfwCK62YT4sotrg=Y5NFty
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 9 Dec 2011 08:53:42 -0500 Gavin  Peters (=E8=93=8B=E6=96=87=E5=BD=
=BC=E5=BE=B7=E6=96=AF) <gavin@ytz.ca>
wrote:

> I tried to reshape today, a raid6 array from seven devices up to
> eight. =C2=A0I ran mdadm 3.2.2, something like
>=20
> # mdadm /dev/md2 --grow -n 8 --layout=3Dpreserve
>=20
> and then, blammo!
>=20
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094708] RAID5 conf printo=
ut:
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094712] =C2=A0--- rd:8 wd=
:8
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094714] =C2=A0disk 0, o:1=
, dev:sdc6
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094715] =C2=A0disk 1, o:1=
, dev:sdf6
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094717] =C2=A0disk 2, o:1=
, dev:sda6
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094718] =C2=A0disk 3, o:1=
, dev:sdd6
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094719] =C2=A0disk 4, o:1=
, dev:sdb6
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094720] =C2=A0disk 5, o:1=
, dev:sde6
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094721] =C2=A0disk 6, o:1=
, dev:sdg6
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094722] =C2=A0disk 7, o:1=
, dev:sdh6
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094876] md: reshape of RA=
ID array md2
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094886] md: minimum _guar=
anteed_
> =C2=A0speed: 40000 KB/sec/disk.
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094892] md: using maximum
> available idle IO bandwidth (but not more than 200000 KB/sec) for
> reshape.
> Dec =C2=A08 22:30:10 avclub kernel: [ =C2=A0527.094912] md: using 128k wi=
ndow,
> over a total of 1371476928 blocks.
> Dec =C2=A08 22:30:11 avclub mdadm[2959]: RebuildStarted event detected on
> md device /dev/md2
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515359] general protection
> fault: 0000 [#1] SMP
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515370] last sysfs file:
> /sys/devices/virtual/block/md2/md/sync_speed
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515376] CPU 5
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515381] Modules linked in:
> binfmt_misc nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc
> snd_usb_audio snd_usb_lib snd_hda_codec_atihdmi fbcon tileblit font
> bitblit softcursor
> =C2=A0vga16fb vgastate snd_hda_codec_via snd_hda_intel snd_pcm_oss
> snd_hda_codec snd_mixer_
> oss snd_hwdep snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
> snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device radeon
> ttm asus_atk0110 drm_kms_helper ppdev snd drm i2c_algo_bit parport_pc
> edac_core edac_mce_amd gspca_zc3xx gspca_main videodev v4l1_compat
> v4l2_compat_ioctl32 soundcore snd_page_alloc i2c_piix4 shpchp lp
> parport tcp_vegas raid10 raid456 async_pq async_xor xor async_memcpy
> usbhid async_raid6_recov hid raid6_pq async_tx raid1 raid0 pata_atiixp
> r8169 mii multipath ahci linear [last unloaded: kvm]
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515500] Pid: 528, comm:
> md2_raid6 Not tainted 2.6.32-32-generic #62-Ubuntu System Product Name
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515507] RIP:
> 0010:[<ffffffff812be15b>] =C2=A0[<ffffffff812be15b>] memcpy_c+0xb/0x20
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515526] RSP:
> 0018:ffff880408985c18 =C2=A0EFLAGS: 00010246
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515531] RAX: db7388000000=
0000
> RBX: ffff880408984000 RCX: 0000000000000200
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515537] RDX: 000000000000=
0000
> RSI: ffff880369717000 RDI: db73880000000000
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515543] RBP: ffff88040898=
5c80
> R08: 0000000000001000 R09: ffff880408985ca0
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515548] R10: 000000000000=
0000
> R11: 0000000000000000 R12: ffff880408985ca0
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515553] R13: ffff88036974=
1290
> R14: 0000000000000000 R15: 0000000000000000
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515560] FS:
> 00007f465923d7a0(0000) GS:ffff880028340000(0000)
> knlGS:00000000f6990760
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515566] CS: =C2=A00010 DS=
: 0018 ES:
> 0018 CR0: 000000008005003b
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515571] CR2: 00007fe6aaf9=
2000
> CR3: 00000003c3a5e000 CR4: 00000000000006e0
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515576] DR0: 000000000000=
0000
> DR1: 0000000000000000 DR2: 0000000000000000
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515582] DR3: 000000000000=
0000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515589] Process md2_raid6=
 (pid:
> 528, threadinfo ffff880408984000, task ffff88040b210000)
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515593] Stack:
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515596] =C2=A0ffffffffa00=
4a0e7
> ffff880408985c50 0000000000000000 0000000000000000
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515604] <0> ffffea000bf10=
d08
> 0000000000000000 0000000000001000 ffff880408985c80
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515614] <0> 0000000000000=
000
> ffff8803696a6930 ffff880369741290 ffff880408985d70
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515624] Call Trace:
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515639] =C2=A0[<ffffffffa=
004a0e7>] ?
> async_memcpy+0xe7/0x25c [async_memcpy]
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515654] =C2=A0[<ffffffffa=
00aaabb>]
> handle_stripe_expansion+0x14b/0x1e0 [raid456]
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515668] =C2=A0[<ffffffffa=
00ab113>]
> handle_stripe6+0x5c3/0xb40 [raid456]
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515680] =C2=A0[<ffffffffa=
00a794c>] ?
> __release_stripe+0xcc/0x1c0 [raid456]
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515692] =C2=A0[<ffffffffa=
00ac055>]
> handle_stripe+0x25/0x30 [raid456]
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515703] =C2=A0[<ffffffffa=
00ac452>]
> raid5d+0x202/0x320 [raid456]
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515716] =C2=A0[<ffffffff8=
15416b9>] ?
> _spin_unlock_irqrestore+0x19/0x30
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515725] =C2=A0[<ffffffff8=
141704c>]
> md_thread+0x5c/0x130
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515735] =C2=A0[<ffffffff8=
1084cb0>] ?
> autoremove_wake_function+0x0/0x40
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515743] =C2=A0[<ffffffff8=
1416ff0>] ?
> md_thread+0x0/0x130
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515750] =C2=A0[<ffffffff8=
1084936>]
> kthread+0x96/0xa0
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515758] =C2=A0[<ffffffff8=
10131ea>]
> child_rip+0xa/0x20
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515766] =C2=A0[<ffffffff8=
10848a0>] ?
> kthread+0x0/0xa0
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515772] =C2=A0[<ffffffff8=
10131e0>] ?
> child_rip+0x0/0x20
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515776] Code: 81 ea d8 1f=
 00 00
> 48 3b 42 20 73 07 48 8b 50 f9 31 c0 c3 31 d2 48 c7 c0 f2 ff ff ff c3
> 90 90 90 48 89 f8 89 d1 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 66
> 66 66 66 2e 0f 1f 84 00 00 00 00 00
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515842] RIP
> [<ffffffff812be15b>] memcpy_c+0xb/0x20
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515850] =C2=A0RSP <ffff88=
0408985c18>
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515857] ---[ end trace
> 5146b1cc8ebe8dc1 ]---
> Dec =C2=A08 22:30:11 avclub kernel: [ =C2=A0527.515865] note: md2_raid6[5=
28]
> exited with preempt_count 2
> Dec =C2=A08 22:32:52 avclub kernel: Kernel logging (proc) stopped.
>=20
> I believe that last line shows me giving up. =C2=A0I am sad.
> Thankfully, after rebooting into single user mode, I was able to mdadm
> --assemble the array, and it appears to be working.  Boy that was a
> rush!
> $ uname -aLinux avclub 2.6.32-32-generic #62-Ubuntu SMP Wed Apr 20
> 21:52:38 UTC 2011 x86_64 GNU/Linux
> Let me know if I can provide any other information.
>=20

Thanks for the report.

It seems that as part of the reshape, md is trying to copy to an invalid
memory address.
It copies from 0xffff880369717000 (RSI) to 0xdb73880000000000 (rdi).
The latter is clearly invalid.

I have no idea how this might be happening. My best guess is that 'ddidx' in
handle_stripe_expansion is getting a bad value but I cannot see how that
would happen.

If you have reasonable backups you could  try again and see if it still fai=
ls.
Maybe it was a one-off.

Not sure what else to suggest.  It might be fixed in a newer kernel, or it
might not...

NeilBrown



--Sig_/TOfwCK62YT4sotrg=Y5NFty
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuV3aDnsnt1WYoG5AQL6GQ/6AmaWRyBbtP8WDflBTy676muckk7hadGG
h0Kzb/JOHnEh27an0VQRBbZ/IXN2YzoG4miuWri0iAZ0BbJ4fXd/OLD8EO0lQ6M8
5AOETdtC1XWjzo7rz93Mr/wWeJEo7Sxi0nIpIWVEhWQJb0L/hW9UHQb6arkU8K1T
/upbeQxa0y4yBb9+iHMad/U8Z0ldriuRXS/Bec6Jj7HRlYuntfsibjQKB5Jd6OcO
cBfcH01cgM7aZ3uxZxvupKwWLUrlaEpQ9zsRn+yvs0raaPoGyKvqKmpL1X77ZJxa
ALsZEQ9Y88fBrtCVJ9JIUMudWB9+5hBMnapNSHFGVEdkgbY061yVy/2liDZzbcbL
mIWREqwomQ/0S8G3Gz+iV2Hd5eJ1wNxwrZ3rkAZDXdrAvAcqT6WL4ERBuk06Ohhg
nl/i03hqlfRabj+Oc37HJ3cn8ZFO2QW+JAu0mg8ejy6rIJhpH3D7HKbTCZRT1Hjq
emdcmKe0CMOSg0s+/xHvH8x9gNCOVLnvm/1CSWh8TEV9wqvunN1jDqoVUJWmflR4
ye5T1ph/vaU71s3PFv6KRV/FpbwD3aAErfU12/Suuu3pVspSdQnrPbyAOrvwcVpf
3WPMSdgAfk8GkSqmST6/a7jaQlfe56GLPav9DrXL1fKnNyGjFvdQU/J/0/XrMjf2
vpljEM4cu6g=
=/hJm
-----END PGP SIGNATURE-----

--Sig_/TOfwCK62YT4sotrg=Y5NFty--

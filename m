From: Sebastian Reichel <sre@ring0.de>
Subject: Re: mdadm hangs during raid5 grow
Date: Sun, 8 Jan 2017 21:50:44 +0100
Message-ID: <20170108205043.p4sclviu2eghzxag@earth>
References: <20170104064210.4exlw2rdbe2fcal2@earth>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eexjtasse2m5asl6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170104064210.4exlw2rdbe2fcal2@earth>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--eexjtasse2m5asl6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 04, 2017 at 07:42:11AM +0100, Sebastian Reichel wrote:
> I have a problem with hanging mdadm reshape task at 100% CPU load
> (kernel thread "md2_raid5"). Any operation on the raid (i.e. mdadm
> -S) is also hanging.  Rebooting worked, but after triggering the
> reshape (mdadm --readwrite /dev/md2) I get the same behaviour.
>=20
> dmesg has this stacktrace:
>=20
> [ 1813.500745] INFO: task md2_resync:3377 blocked for more than 120 secon=
ds.
> [ 1813.500778]       Not tainted 4.8.0-2-amd64 #1
> [ 1813.500795] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [ 1813.500822] md2_resync      D ffff93207bc98180     0  3377      2 0x00=
000000
> [ 1813.500827]  ffff93206f46d000 ffff93207642a1c0 0000000000000246 ffff93=
2059607bf0
> [ 1813.500829]  ffff932059608000 ffff93206effc400 ffff93206effc688 ffff93=
2059607d24
> [ 1813.500830]  ffff932059607bf0 ffff93206e0a3000 ffffffffbc7eb6d1 ffff93=
206e0a3000
> [ 1813.500832] Call Trace:
> [ 1813.500841]  [<ffffffffbc7eb6d1>] ? schedule+0x31/0x80
> [ 1813.500847]  [<ffffffffc0356924>] ? reshape_request+0x7b4/0x910 [raid4=
56]
> [ 1813.500851]  [<ffffffffbc2bce80>] ? wake_atomic_t_function+0x60/0x60
> [ 1813.500854]  [<ffffffffc0356da3>] ? raid5_sync_request+0x323/0x3a0 [ra=
id456]
> [ 1813.500862]  [<ffffffffc0271b50>] ? is_mddev_idle+0x98/0xf3 [md_mod]
> [ 1813.500866]  [<ffffffffc02649a9>] ? md_do_sync+0x959/0xed0 [md_mod]
> [ 1813.500868]  [<ffffffffbc2bce80>] ? wake_atomic_t_function+0x60/0x60
> [ 1813.500872]  [<ffffffffc0261363>] ? md_thread+0x133/0x140 [md_mod]
> [ 1813.500873]  [<ffffffffbc7eb1c9>] ? __schedule+0x289/0x760
> [ 1813.500877]  [<ffffffffc0261230>] ? find_pers+0x70/0x70 [md_mod]
> [ 1813.500879]  [<ffffffffbc29aecd>] ? kthread+0xcd/0xf0
> [ 1813.500881]  [<ffffffffbc7efcaf>] ? ret_from_fork+0x1f/0x40
> [ 1813.500883]  [<ffffffffbc29ae00>] ? kthread_create_on_node+0x190/0x190
>=20
> Is this a known bug / some patch available?

I also tried 4.9.0-rc8, which was easily available without trying to
find a working kernel config for the system and the error persists.
I have some more information:

mars# gdb /usr/lib/debug/lib/modules/4.9.0-rc8-amd64/kernel/drivers/md/raid=
456.ko
(gdb) info line *reshape_request+0x6dd
Line 5481 of "./drivers/md/raid5.c" starts at address 0xe8e4 <reshape_reque=
st+1748> and ends at 0xe8fd <reshape_request+1773>.

=3D> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dr=
ivers/md/raid5.c?h=3Dv4.9-rc8#n5481
=3D> wait_event(conf->wait_for_overlap, atomic_read(&conf->reshape_stripes)=
 =3D=3D 0 || test_bit(MD_RECOVERY_INTR, &mddev->recovery));

Also if I enable debug messages in raid5.c I get this from from
[md2_raid5], which is running at 100% cpu on one of the cores (Note
regarding the failed state: I'm pretty sure the disks are ok and I
can use the raid, if I mount it read-only).

# echo "file raid5.c +p" > /sys/kernel/debug/dynamic_debug/control
# dmesg | grep-random-sample
[41658.396897] locked=3D1 uptodate=3D4 to_read=3D0 to_write=3D0 failed=3D2 =
failed_num=3D2,1
[41658.396904] check 3: state 0x13 read           (null) write           (n=
ull) written           (null)
[41658.397113] check 0: state 0x811 read           (null) write           (=
null) written           (null)
[41658.397139] check 0: state 0x811 read           (null) write           (=
null) written           (null)
[41658.397163] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.397192] handling stripe 20206728, state=3D0x1401 cnt=3D1, pd_idx=3D2=
, qd_idx=3D-1
, check:0, reconstruct:6
[41658.397222] schedule_reconstruction: stripe 20206728 locked: 2 ops_reque=
st: 10
[41658.397251] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.397277] ops_complete_reconstruct: stripe 20206736
[41658.397296] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.397328] check 0: state 0x811 read           (null) write           (=
null) written           (null)
[41658.397351] check 3: state 0x13 read           (null) write           (n=
ull) written           (null)
[41658.397368] locked=3D1 uptodate=3D4 to_read=3D0 to_write=3D0 failed=3D2 =
failed_num=3D2,1
[41658.397387] ops_complete_reconstruct: stripe 20206112
[41658.397395] __get_priority_stripe: handle: busy hold: empty full_writes:=
 0 bypass_count: 0
[41658.397417] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.397476] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.397560] check 2: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.397592] check 3: state 0x13 read           (null) write           (n=
ull) written           (null)
[41658.397606] __get_priority_stripe: handle: busy hold: empty full_writes:=
 0 bypass_count: 0
[41658.397614] handling stripe 20206792, state=3D0x1401 cnt=3D1, pd_idx=3D2=
, qd_idx=3D-1
, check:0, reconstruct:6
[41658.397621] schedule_reconstruction: stripe 20206792 locked: 2 ops_reque=
st: 10
[41658.397630] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.397638] ops_complete_reconstruct: stripe 20206800
[41658.397840] locked=3D1 uptodate=3D4 to_read=3D0 to_write=3D0 failed=3D2 =
failed_num=3D2,1
[41658.397863] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.397869] ops_complete_reconstruct: stripe 20206976
[41658.397874] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.397883] ops_complete_reconstruct: stripe 20206984
[41658.397890] check 0: state 0x13 read           (null) write           (n=
ull) written           (null)
[41658.397899] check 3: state 0x811 read           (null) write           (=
null) written           (null)
[41658.397907] schedule_reconstruction: stripe 20207000 locked: 2 ops_reque=
st: 10
[41658.397952] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.398030] check 2: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.398079] check 1: state 0x203 read           (null) write           (=
null) written           (null)
[41658.398105] check 2: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.398118] check 3: state 0x811 read           (null) write           (=
null) written           (null)
[41658.398124] locked=3D1 uptodate=3D4 to_read=3D0 to_write=3D0 failed=3D2 =
failed_num=3D2,1
[41658.398130] check 3: state 0x811 read           (null) write           (=
null) written           (null)
[41658.398136] schedule_reconstruction: stripe 20206904 locked: 2 ops_reque=
st: 10
[41658.398145] check 3: state 0x811 read           (null) write           (=
null) written           (null)
[41658.398162] __get_priority_stripe: handle: busy hold: empty full_writes:=
 0 bypass_count: 0
[41658.398226] check 2: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.398294] ops_run_reconstruct5: stripe 20206936
[41658.398308] check 0: state 0x811 read           (null) write           (=
null) written           (null)
[41658.398318] check 1: state 0x203 read           (null) write           (=
null) written           (null)
[41658.398342] check 2: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.398367] __get_priority_stripe: handle: busy hold: empty full_writes:=
 0 bypass_count: 0
[41658.398389] ops_complete_reconstruct: stripe 20206184
[41658.398415] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.398469] locked=3D1 uptodate=3D4 to_read=3D0 to_write=3D0 failed=3D2 =
failed_num=3D2,1
[41658.398494] check 3: state 0x811 read           (null) write           (=
null) written           (null)
[41658.398519] schedule_reconstruction: stripe 20206216 locked: 2 ops_reque=
st: 10
[41658.398542] check 2: state 0x203 read           (null) write           (=
null) written           (null)
[41658.398554] ops_run_reconstruct5: stripe 20206224
[41658.398560] check 2: state 0x203 read           (null) write           (=
null) written           (null)
[41658.398582] ops_run_reconstruct5: stripe 20206240
[41658.398600] check 2: state 0x203 read           (null) write           (=
null) written           (null)
[41658.398627] check 3: state 0x811 read           (null) write           (=
null) written           (null)
[41658.398659] check 3: state 0x811 read           (null) write           (=
null) written           (null)
[41658.398733] ops_run_reconstruct5: stripe 20206288
[41658.398754] check 2: state 0x203 read           (null) write           (=
null) written           (null)
[41658.398785] ops_complete_reconstruct: stripe 20206296
[41658.398792] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.398799] ops_complete_reconstruct: stripe 20206304
[41658.398807] __get_priority_stripe: handle: busy hold: empty full_writes:=
 0 bypass_count: 0
[41658.398813] handling stripe 20206312, state=3D0x1401 cnt=3D1, pd_idx=3D2=
, qd_idx=3D-1
, check:0, reconstruct:6
[41658.398845] check 0: state 0x13 read           (null) write           (n=
ull) written           (null)
[41658.398870] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.398901] check 3: state 0x811 read           (null) write           (=
null) written           (null)
[41658.398990] __get_priority_stripe: handle: busy hold: empty full_writes:=
 0 bypass_count: 0
[41658.399008] __get_priority_stripe: handle: busy hold: empty full_writes:=
 0 bypass_count: 0
[41658.399035] check 2: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.399039] schedule_reconstruction: stripe 20206040 locked: 2 ops_reque=
st: 10
[41658.399048] check 1: state 0x203 read           (null) write           (=
null) written           (null)
[41658.399057] ops_complete_reconstruct: stripe 20206336
[41658.399063] check 1: state 0x203 read           (null) write           (=
null) written           (null)
[41658.399090] check 1: state 0x203 read           (null) write           (=
null) written           (null)
[41658.399117] check 1: state 0xa01 read           (null) write           (=
null) written           (null)
[41658.399142] __get_priority_stripe: handle: busy hold: empty full_writes:=
 0 bypass_count: 0
[41658.399220] check 3: state 0x13 read           (null) write           (n=
ull) written           (null)

Also I have an idea about the problem: Usually I added zero'd disks
to mdadm. This time I only zero'd out the first few MB, so that mdadm
does not complain about the header and thought it would take care of
the rest. Is it safe to remove the new disk, zero it out and re-add
it?

-- Sebastian

--eexjtasse2m5asl6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlhypiEACgkQ2O7X88g7
+pq7cA//We5232wKususlgu0EwxG+lEfrKh0Uk37CLt+zRswphTUCYvX6SdDnkjG
txBhlwa7DALgM3zYm7CEho2f+jmNybox7VcpZpN6s0chuIGL2z1cWOCLdU8Fi5Ut
j+02CaajpJhxIisrTeHNlaaNMa3zid3TDtOqg5dS84A/S8RQYXlkjrbz3NwxHzde
83GmIcpuLeu+q2H0CedGNn6L9yPE5YNtl+6LGX/LS8EbtDCg6HPghZVs+vLs1iUX
blCpsPHHtk91O2e+Jcb0cvQfX+lFwaQECVUDrFM6foQeW3/mgztIHIRgjaNOPmFm
jjCDTeBpSqKMR34nsJf3yaSra0zIKVJ+D9zaSGN3RswdFE9uRKQhkvRogMcC8p+e
zWwngdlZ6AV2LLatQyEN9NOaPrA0tjXS1C3Y4lsgleDRSr/KG9SkHysOi27X4Sm7
Dx8hbHUqeAiTY2U4bVkHBdAeOAx+Mv2aRTFHVvlI2pQcItT5fwwLffXYbSAGRFEu
W28ufve2C3U3B0XfiMdzC42KRnaDU6ghLNHnat7KlsAOTzOMVAaKp8IFLEdAeI4t
lIZjPJUp/or9VKYdgzcfsP1VA/3Y5O4FGsIu7v4XXjn/tuS47h2p9sVoPEWgq64s
N3yBq3liHU41+sCVDQn5Gd1OFN6+bIpsQH6WbEHrIl/9GVwiQsk=
=ukFZ
-----END PGP SIGNATURE-----

--eexjtasse2m5asl6--

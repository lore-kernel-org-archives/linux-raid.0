From: NeilBrown <neilb@suse.de>
Subject: Re: md_raid5 using 100% CPU and hang with status resync=PENDING, if
 a drive is removed during initialization
Date: Tue, 3 Feb 2015 09:30:40 +1100
Message-ID: <20150203093040.569aa5e1@notabene.brown>
References: <CD8664C5675EDF49A5E76D7DB099D7B32611BB56@VENUS1.in.megatrends.com>
	<20141231164800.GL19091@reaktio.net>
	<CD8664C5675EDF49A5E76D7DB099D7B326130D6E@VENUS1.in.megatrends.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ZE.edWThztZ24S57QDtErHx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CD8664C5675EDF49A5E76D7DB099D7B326130D6E@VENUS1.in.megatrends.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manibalan P <pmanibalan@amiindia.co.in>
Cc: Pasi =?UTF-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ZE.edWThztZ24S57QDtErHx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Feb 2015 07:10:14 +0000 Manibalan P <pmanibalan@amiindia.co.in>
wrote:

> Dear All,
> 	Any updates on this issue.

Probably the same as:

  http://marc.info/?l=3Dlinux-raid&m=3D142283560704091&w=3D2

which follows on from
  http://marc.info/?t=3D142221642300001&r=3D1&w=3D2
and
  http://marc.info/?t=3D142172432500001&r=3D1&w=3D2

NeilBrown


> Thanks,
> Manibalan.
>=20
> -----Original Message-----
> From: Manibalan P=20
> Sent: Wednesday, January 14, 2015 3:55 PM
> To: 'Pasi K=C3=A4rkk=C3=A4inen'
> Cc: 'neilb@suse.de'; 'linux-raid'
> Subject: RE: md_raid5 using 100% CPU and hang with status resync=3DPENDIN=
G, if a drive is removed during initialization
>=20
> Dear Pasi,
> Could you able to find something on this issue.
>=20
> Thanks,
> Manibalan.
>=20
> -----Original Message-----
> From: Manibalan P
> Sent: Friday, January 2, 2015 12:08 PM
> To: 'Pasi K=C3=A4rkk=C3=A4inen'
> Cc: neilb@suse.de; linux-raid
> Subject: RE: md_raid5 using 100% CPU and hang with status resync=3DPENDIN=
G, if a drive is removed during initialization
>=20
> Dear Pasi,
>=20
> I have add the bug in https://bugzilla.redhat.com/show_bug.cgi?id=3D11780=
80
>=20
> Thanks,
> Manibalan.
>=20
> -----Original Message-----
> From: Pasi K=C3=A4rkk=C3=A4inen [mailto:pasik@iki.fi]
> Sent: Wednesday, December 31, 2014 10:18 PM
> To: Manibalan P
> Cc: neilb@suse.de; linux-raid
> Subject: Re: md_raid5 using 100% CPU and hang with status resync=3DPENDIN=
G, if a drive is removed during initialization
>=20
> On Tue, Dec 30, 2014 at 11:06:47AM +0000, Manibalan P wrote:
> > Dear Neil,
> >
>=20
> Hello,
> =20
> > Few this for you kind attention,
> > 1. I tried the same test with FC11 (2.6.32 kernel before MD code=20
> > change). And the issue is not there 2. But with Centos 6.4 (2.6.32 kern=
el after MD code change). I am getting this issue.. and also even with the =
latest kernel, able to reproduce the issue.
> >=20
> > Also, a bug has been raise with RHEL regarding this issue. Please find =
the bug link "https://access.redhat.com/support/cases/#/case/01320319"
> >=20
>=20
> That support case URL can only be accessed by you and Redhat. Do you happ=
en to have a public bugzilla link?=20
>=20
>=20
> Thanks,
>=20
> -- Pasi
>=20
> > Thanks,
> > Manibalan.
> >=20
> > -----Original Message-----
> > From: Manibalan P
> > Sent: Wednesday, December 24, 2014 12:15 PM
> > To: neilb@suse.de; 'linux-raid'
> > Cc: 'NeilBrown'
> > Subject: RE: md_raid5 using 100% CPU and hang with status=20
> > resync=3DPENDING, if a drive is removed during initialization
> >=20
> >=20
> > Dear Neil,
> >=20
> > Few this for you kind attention,
> > 1. I tried the same tesst with FC11 (2.6 kernel before MD code change).=
 And the issue is not there 2. But with Centos 6.4 (2.6 after MD code chang=
e). I am getting this issue.. and also even with the latest kernel, able to=
 reproduce the issue.
> >=20
> > Thanks,
> > Manibalan.
> >=20
> > -----Original Message-----
> > From: Manibalan P
> > Sent: Thursday, December 18, 2014 11:38 AM
> > To: 'linux-raid'
> > Cc: 'NeilBrown'; Vijayarankan Muthirisavengopal; Dinakaran N
> > Subject: RE: md_raid5 using 100% CPU and hang with status=20
> > resync=3DPENDING, if a drive is removed during initialization
> >=20
> > Dear neil,
> >=20
> > I also compiled the latest 3.18 kernel on CentOS 6.4 with GIT MD pull p=
atches form 3.19, that also ran in to the same issue after removing a drive=
 during resync.
> >=20
> > Dec 17 19:07:32 ITX002590129362 kernel: Linux version 3.18.0 (root@myce=
ntos6) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC) ) #1 SMP Wed De=
c 17 15:59:09 EST 2014 Dec 17 19:07:32 ITX002590129362 kernel: Command line=
: ro root=3D/dev/md255 rd_NO_LVM rd_NO_DM rhgb quiet md_mod.start_ro=3D1 nm=
i_watchdog=3D1 md_mod.start_dirty_degraded=3D1 ??? Dec 17 19:10:15 ITX00259=
0129362 kernel: md: bind<sda6> Dec 17 19:10:15 ITX002590129362 kernel: md: =
bind<sdb6> Dec 17 19:10:15 ITX002590129362 kernel: md: bind<sdc6> Dec 17 19=
:10:15 ITX002590129362 kernel: md: bind<sdh6> Dec 17 19:10:15 ITX0025901293=
62 kernel: md: bind<sdi6> Dec 17 19:10:15 ITX002590129362 kernel: md: bind<=
sdj6> Dec 17 19:10:15 ITX002590129362 kernel: async_tx: api initialized (as=
ync) Dec 17 19:10:15 ITX002590129362 kernel: xor: measuring software checks=
um speed
> > Dec 17 19:10:15 ITX002590129362 kernel:   prefetch64-sse: 10048.000 MB/=
sec
> > Dec 17 19:10:15 ITX002590129362 kernel:   generic_sse:  8824.000 MB/sec
> > Dec 17 19:10:15 ITX002590129362 kernel: xor: using function: prefetch64=
-sse (10048.000 MB/sec)
> > Dec 17 19:10:15 ITX002590129362 kernel: raid6: sse2x1    5921 MB/s
> > Dec 17 19:10:15 ITX002590129362 kernel: raid6: sse2x2    6933 MB/s
> > Dec 17 19:10:15 ITX002590129362 kernel: raid6: sse2x4    7476 MB/s
> > Dec 17 19:10:15 ITX002590129362 kernel: raid6: using algorithm sse2x4
> > (7476 MB/s) Dec 17 19:10:15 ITX002590129362 kernel: raid6: using
> > ssse3x2 recovery algorithm Dec 17 19:10:15 ITX002590129362 kernel: md:=
=20
> > raid6 personality registered for level 6 Dec 17 19:10:15
> > ITX002590129362 kernel: md: raid5 personality registered for level 5=20
> > Dec 17 19:10:15 ITX002590129362 kernel: md: raid4 personality=20
> > registered for level 4 Dec 17 19:10:15 ITX002590129362 kernel:
> > md/raid:md0: not clean -- starting background reconstruction Dec 17
> > 19:10:15 ITX002590129362 kernel: md/raid:md0: device sdj6 operational=20
> > as raid disk 5 Dec 17 19:10:15 ITX002590129362 kernel: md/raid:md0:
> > device sdi6 operational as raid disk 4 Dec 17 19:10:15 ITX002590129362
> > kernel: md/raid:md0: device sdh6 operational as raid disk 3 Dec 17
> > 19:10:15 ITX002590129362 kernel: md/raid:md0: device sdc6 operational=20
> > as raid disk 2 Dec 17 19:10:15 ITX002590129362 kernel: md/raid:md0:
> > device sdb6 operational as raid disk 1 Dec 17 19:10:15 ITX002590129362
> > kernel: md/ra
> > id:md0: device sda6 operational as raid disk 0 Dec 17 19:10:15 ITX00259=
0129362 kernel: md/raid:md0: allocated 0kB Dec 17 19:10:15 ITX002590129362 =
kernel: md/raid:md0: raid level 5 active with 6 out of 6 devices, algorithm=
 2 Dec 17 19:10:15 ITX002590129362 kernel: md0: detected capacity change fr=
om 0 to 2361059573760 Dec 17 19:10:15 ITX002590129362 kernel: md0: unknown =
partition table Dec 17 19:10:35 ITX002590129362 kernel: md: md0 switched to=
 read-write mode.
> > Dec 17 19:10:35 ITX002590129362 kernel: md: resync of RAID array md0 De=
c 17 19:10:35 ITX002590129362 kernel: md: minimum _guaranteed_  speed: 1000=
0 KB/sec/disk.
> > Dec 17 19:10:35 ITX002590129362 kernel: md: using maximum available idl=
e IO bandwidth (but not more than 30000 KB/sec) for resync.
> > Dec 17 19:10:35 ITX002590129362 kernel: md: using 128k window, over a t=
otal of 461144448k.
> > ???
> > Started IOs using fio tool.
> >=20
> > ./fio --name=3Dmd0 --filename=3D/dev/md0 --thread --numjobs=3D10 --dire=
ct=3D1=20
> > --group_reporting --unlink=3D0 --loops=3D1 --offset=3D0 --randrepeat=3D=
1=20
> > --norandommap --scramble_buffers=3D1 --stonewall --ioengine=3Dlibaio=20
> > --rw=3Drandwrite --bs=3D8704 --iodepth=3D4000 --runtime=3D3000
> > --blockalign=3D512
> >=20
> > ???
> > Removed a drive form the system..
> >=20
> > Dec 17 19:13:23 ITX002590129362 kernel: mpt2sas0: log_info(0x31120101):=
 originator(PL), code(0x12), sub_code(0x0101) Dec 17 19:13:23 ITX0025901293=
62 kernel: mpt2sas0: log_info(0x31120101): originator(PL), code(0x12), sub_=
code(0x0101) Dec 17 19:13:23 ITX002590129362 kernel: mpt2sas0: log_info(0x3=
1120101): originator(PL), code(0x12), sub_code(0x0101) Dec 17 19:13:23 ITX0=
02590129362 kernel: mpt2sas0: log_info(0x31120101): originator(PL), code(0x=
12), sub_code(0x0101) ..
> > Dec 17 19:13:23 ITX002590129362 kernel: sd 0:0:7:0: [sdh] Dec 17 19:13:=
23 ITX002590129362 kernel: Result: hostbyte=3DDID_TRANSPORT_DISRUPTED drive=
rbyte=3DDRIVER_OK Dec 17 19:13:23 ITX002590129362 kernel: sd 0:0:7:0: [sdh]=
 CDB:
> > Dec 17 19:13:23 ITX002590129362 kernel: Read(10): 28 00 02 69 03 70 00 =
00 10 00 Dec 17 19:13:23 ITX002590129362 kernel: blk_update_request: I/O er=
ror, dev sdh, sector 40436592 Dec 17 19:13:23 ITX002590129362 kernel: sd 0:=
0:7:0: [sdh] Dec 17 19:13:23 ITX002590129362 kernel: Result: hostbyte=3DDID=
_TRANSPORT_DISRUPTED driverbyte=3DDRIVER_OK Dec 17 19:13:23 ITX002590129362=
 kernel: sd 0:0:7:0: [sdh] CDB:
> > Dec 17 19:13:23 ITX002590129362 kernel: Read(10): 28 00 0c 51 b3 d0 00 =
00 18 00 Dec 17 19:13:23 ITX002590129362 kernel: blk_update_request: I/O er=
ror, dev sdh, sector 206681040 Dec 17 19:13:23 ITX002590129362 kernel: sd 0=
:0:7:0: [sdh] Dec 17 19:13:23 ITX002590129362 kernel: Result: hostbyte=3DDI=
D_TRANSPORT_DISRUPTED driverbyte=3DDRIVER_OK Dec 17 19:13:23 ITX00259012936=
2 kernel: sd 0:0:7:0: [sdh] CDB:
> > Dec 17 19:13:23 ITX002590129362 kernel: Read(10): 28 00 0c 3a f3 40 00 =
00 18 00 Dec 17 19:13:23 ITX002590129362 kernel: blk_update_request: I/O er=
ror, dev sdh, sector 205189952 Dec 17 19:13:23 ITX002590129362 kernel: sd 0=
:0:7:0: [sdh] Dec 17 19:13:23 ITX002590129362 kernel: Result: hostbyte=3DDI=
D_TRANSPORT_DISRUPTED driverbyte=3DDRIVER_OK ??? Dec 17 19:13:25 ITX0025901=
29362 kernel: sd 0:0:7:0: [sdh] CDB:
> > Dec 17 19:13:25 ITX002590129362 kernel: Read(10): 28 00 26 8d eb 00 00 =
00 08 00 Dec 17 19:13:25 ITX002590129362 kernel: sd 0:0:7:0: [sdh] Dec 17 1=
9:13:25 ITX002590129362 kernel: Result: hostbyte=3DDID_NO_CONNECT driverbyt=
e=3DDRIVER_OK Dec 17 19:13:25 ITX002590129362 kernel: sd 0:0:7:0: [sdh] CDB:
> > Dec 17 19:13:25 ITX002590129362 kernel: Read(10): 28 00 26 8d eb f0 00 =
00 10 00 Dec 17 19:13:25 ITX002590129362 aghswap: devpath [0:0:7:0] action =
[remove] devtype [scsi_disk] Dec 17 19:13:25 ITX002590129362 aghswap: MHSA:=
 Sent event 0 0 7 0 remove scsi_disk Dec 17 19:13:25 ITX002590129362 kernel=
: mpt2sas0: removing handle(0x0011), sas_addr(0x500605ba0101e305) Dec 17 19=
:13:25 ITX002590129362 kernel: md/raid:md0: Disk failure on sdh6, disabling=
 device.
> > Dec 17 19:13:25 ITX002590129362 kernel: md/raid:md0: Operation continui=
ng on 5 devices.
> > Dec 17 19:13:25 ITX002590129362 kernel: md: md0: resync interrupted.
> > Dec 17 19:13:25 ITX002590129362 kernel: md: checkpointing resync of md0.
> > ..
> > Log messages after enabling debufgs on raid5.c, it is getting repeated =
continuously.
> >=20
> > __get_priority_stripe: handle: busy hold: empty full_writes: 0
> > bypass_count: 0
> > __get_priority_stripe: handle: busy hold: empty full_writes: 0
> > bypass_count: 0
> > __get_priority_stripe: handle: busy hold: empty full_writes: 0
> > bypass_count: 0
> > __get_priority_stripe: handle: busy hold: empty full_writes: 0
> > bypass_count: 0
> > __get_priority_stripe: handle: busy hold: empty full_writes: 0 bypass_c=
ount: 0 handling stripe 273480328, state=3D0x2041 cnt=3D1, pd_idx=3D5, qd_i=
dx=3D-1 , check:0, reconstruct:0
> > check 5: state 0x10 read           (null) write           (null) writte=
n           (null)
> > check 4: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 3: state 0x0 read           (null) write           (null) written=
           (null)
> > check 2: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 1: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 0: state 0x18 read           (null) write ffff8808029b6b00 writte=
n           (null)
> > locked=3D0 uptodate=3D3 to_read=3D0 to_write=3D1 failed=3D1 failed_num=
=3D3,-1 force RCW max_degraded=3D1, recovery_cp=3D7036944 sh->sector=3D2734=
80328 for sector 273480328, rmw=3D2 rcw=3D1 handling stripe 65238568, state=
=3D0x2041 cnt=3D1, pd_idx=3D5, qd_idx=3D-1 , check:0, reconstruct:0
> > check 5: state 0x10 read           (null) write           (null) writte=
n           (null)
> > check 4: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 3: state 0x0 read           (null) write           (null) written=
           (null)
> > check 2: state 0x18 read           (null) write ffff88081a956b00 writte=
n           (null)
> > check 1: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 0: state 0x11 read           (null) write           (null) writte=
n           (null)
> > locked=3D0 uptodate=3D3 to_read=3D0 to_write=3D1 failed=3D1 failed_num=
=3D3,-1 force RCW max_degraded=3D1, recovery_cp=3D7036944 sh->sector=3D6523=
8568 for sector 65238568, rmw=3D2 rcw=3D1 handling stripe 713868672, state=
=3D0x2041 cnt=3D1, pd_idx=3D4, qd_idx=3D-1 , check:0, reconstruct:0
> > check 5: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 4: state 0x10 read           (null) write           (null) writte=
n           (null)
> > check 3: state 0x0 read           (null) write           (null) written=
           (null)
> > check 2: state 0x18 read           (null) write ffff88081f020100 writte=
n           (null)
> > check 1: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 0: state 0x11 read           (null) write           (null) writte=
n           (null)
> > locked=3D0 uptodate=3D3 to_read=3D0 to_write=3D1 failed=3D1 failed_num=
=3D3,-1 force RCW max_degraded=3D1, recovery_cp=3D7036944 sh->sector=3D7138=
68672 for sector 713868672, rmw=3D2 rcw=3D1 handling stripe 729622496, stat=
e=3D0x2041 cnt=3D1, pd_idx=3D2, qd_idx=3D-1 , check:0, reconstruct:0
> > check 5: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 4: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 3: state 0x0 read           (null) write           (null) written=
           (null)
> > check 2: state 0x10 read           (null) write           (null) writte=
n           (null)
> > check 1: state 0x18 read           (null) write ffff88081b9bae00 writte=
n           (null)
> > check 0: state 0x11 read           (null) write           (null) writte=
n           (null)
> > locked=3D0 uptodate=3D3 to_read=3D0 to_write=3D1 failed=3D1 failed_num=
=3D3,-1 force RCW max_degraded=3D1, recovery_cp=3D7036944 sh->sector=3D7296=
22496 for sector 729622496, rmw=3D2 rcw=3D1 handling stripe 729622504, stat=
e=3D0x2041 cnt=3D1, pd_idx=3D2, qd_idx=3D-1 , check:0, reconstruct:0
> > check 5: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 4: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 3: state 0x0 read           (null) write           (null) written=
           (null)
> > check 2: state 0x10 read           (null) write           (null) writte=
n           (null)
> > check 1: state 0x18 read           (null) write ffff88081b9bae00 writte=
n           (null)
> > check 0: state 0x11 read           (null) write           (null) writte=
n           (null)
> > locked=3D0 uptodate=3D3 to_read=3D0 to_write=3D1 failed=3D1 failed_num=
=3D3,-1 force RCW max_degraded=3D1, recovery_cp=3D7036944 sh->sector=3D7296=
22504 for sector 729622504, rmw=3D2 rcw=3D1 handling stripe 245773680, stat=
e=3D0x2041 cnt=3D1, pd_idx=3D0, qd_idx=3D-1 , check:0, reconstruct:0
> > check 5: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 4: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 3: state 0x0 read           (null) write           (null) written=
           (null)
> > check 2: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 1: state 0x18 read           (null) write ffff88081cab7a00 writte=
n           (null)
> > check 0: state 0x10 read           (null) write           (null) writte=
n           (null)
> > locked=3D0 uptodate=3D3 to_read=3D0 to_write=3D1 failed=3D1 failed_num=
=3D3,-1 force RCW max_degraded=3D1, recovery_cp=3D7036944 sh->sector=3D2457=
73680 for sector 245773680, rmw=3D2 rcw=3D1 handling stripe 867965560, stat=
e=3D0x2041 cnt=3D1, pd_idx=3D1, qd_idx=3D-1 , check:0, reconstruct:0
> > check 5: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 4: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 3: state 0x0 read           (null) write           (null) written=
           (null)
> > check 2: state 0x18 read           (null) write ffff880802b2bf00 writte=
n           (null)
> > check 1: state 0x10 read           (null) write           (null) writte=
n           (null)
> > check 0: state 0x11 read           (null) write           (null) writte=
n           (null)
> > locked=3D0 uptodate=3D3 to_read=3D0 to_write=3D1 failed=3D1 failed_num=
=3D3,-1 force RCW max_degraded=3D1, recovery_cp=3D7036944 sh->sector=3D8679=
65560 for sector 867965560, rmw=3D2 rcw=3D1 handling stripe 550162280, stat=
e=3D0x2041 cnt=3D1, pd_idx=3D2, qd_idx=3D-1 , check:0, reconstruct:0
> > check 5: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 4: state 0x18 read           (null) write ffff880802b08800 writte=
n           (null)
> > check 3: state 0x0 read           (null) write           (null) written=
           (null)
> > check 2: state 0x10 read           (null) write           (null) writte=
n           (null)
> > check 1: state 0x11 read           (null) write           (null) writte=
n           (null)
> > check 0: state 0x11 read           (null) write           (null) writte=
n           (null)
> > locked=3D0 uptodate=3D3 to_read=3D0 to_write=3D1 failed=3D1 failed_num=
=3D3,-1=20
> > force RCW max_degraded=3D1, recovery_cp=3D7036944 sh->sector=3D55016228=
0 for=20
> > sector 550162280, rmw=3D2 rcw=3D1
> >=20
> >=20
> > Thanks,
> > Manibalan
> >=20
> >=20
> > -----Original Message-----
> > From: Manibalan P
> > Sent: Wednesday, December 17, 2014 12:11 PM
> > To: 'linux-raid'
> > Cc: 'NeilBrown'; Vijayarankan Muthirisavengopal; Dinakaran N
> > Subject: RE: md_raid5 using 100% CPU and hang with status=20
> > resync=3DPENDING, if a drive is removed during initialization
> >=20
> > Dear Neil,
> >=20
> > The same Issue is reproducible in the latest upstream kernel also.
> >=20
> > Tested in "3.17.6" latest stable upstream kernel and find the same issu=
e.
> >=20
> > [root@root ~]# modinfo raid456
> > filename:       /lib/modules/3.17.6/kernel/drivers/md/raid456.ko
> > alias:          raid6
> > alias:          raid5
> > alias:          md-level-6
> > alias:          md-raid6
> > alias:          md-personality-8
> > alias:          md-level-4
> > alias:          md-level-5
> > alias:          md-raid4
> > alias:          md-raid5
> > alias:          md-personality-4
> > description:    RAID4/5/6 (striping with parity) personality for MD
> > license:        GPL
> > srcversion:     0EEF680023FDC7410F7989A
> > depends:        async_raid6_recov,async_pq,async_tx,async_memcpy,async_=
xor
> > intree:         Y
> > vermagic:       3.17.6 SMP mod_unload modversions
> > parm:           devices_handle_discard_safely:Set to Y if all devices i=
n each array reliably return zeroes on reads from discarded regions (bool)
> >=20
> > Thanks,
> > Manibalan.
> >=20
> > -----Original Message-----
> > From: Manibalan P
> > Sent: Wednesday, December 17, 2014 12:01 PM
> > To: 'linux-raid'
> > Cc: 'NeilBrown'
> > Subject: RE: md_raid5 using 100% CPU and hang with status=20
> > resync=3DPENDING, if a drive is removed during initialization
> >=20
> > Dear Neil,
> >=20
> > We are facing IO struck issue with raid5  in the following scenario.=20
> > (please see the attachment for the complete information) In RAID5=20
> > array, if a drive is removed while initialization and the same time if=
=20
> > IO is happening to that md. Then IO is getting struck, and md_raid5=20
> > thread is using 100 % of CPU. Also the md state showing as=20
> > resync=3DPENDING
> >=20
> > Kernel :  Issue found in the following kernels RHEL 6.5
> > (2.6.32-431.el6.x86_64) CentOS 7 (kernel-3.10.0-123.13.1.el7.x86_64)
> >=20
> > Steps to Reproduce the issue:
> >=20
> > 1. Created a raid 5 md with 4 drives using the below mdadm command.
> > mdadm -C /dev/md0 -c 64 -l 5 -f -n 4 -e 1.2 /dev/sdb6 /dev/sdc6
> > /dev/sdd6 /dev/sde6
> >=20
> > 2. Make the md writable
> > mdadm ???readwrite /dev/md0
> >=20
> > 3. Now md will start initialization
> >=20
> > 4. Run FIO Tool, the the below said configuration /usr/bin/fio
> > --name=3Dmd0 --filename=3D/dev/md0 --thread --numjobs=3D10 --direct=3D1=
=20
> > --group_reporting --unlink=3D0 --loops=3D1 --offset=3D0 --randrepeat=3D=
1=20
> > --norandommap --scramble_buffers=3D1 --stonewall --ioengine=3Dlibaio=20
> > --rw=3Drandwrite --bs=3D8704 --iodepth=3D4000 --runtime=3D3000
> > --blockalign=3D512
> >=20
> > 4. During MD initialzing, remove a drive(either using MDADM set=20
> > faulty/remove or remove manually)
> >=20
> > 5. Now the IO will struck, and cat /proc/mdstat shows states with=20
> > resync=3DPENDING
> > ----------------------------------------------------------------------
> > ----------------------- top - output show, md_raid5 using 100% cpu
> >=20
> > top - 17:55:06 up  1:09,  3 users,  load average: 11.98, 8.53, 3.99
> > PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> > 2690 root      20   0     0    0    0 R 100.0  0.0   6:44.41 md0_raid5
> > ----------------------------------------------------------------------
> > -----------------------
> > dmesg - show the stack trace
> >=20
> > INFO: task fio:2715 blocked for more than 120 seconds.
> > Not tainted 2.6.32-431.el6.x86_64 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > fio           D 000000000000000a     0  2715   2654 0x00000080
> > ffff88043b623598 0000000000000082 0000000000000000 ffffffff81058d53
> > ffff88043b623548 ffff880230e49cc0 ffff8802389aa228 ffff88043b2ad1b8
> > ffff88043b40b098 ffff88043b623fd8 000000000000fbc8 ffff88043b40b098 Cal=
l Trace:
> > [<ffffffff81058d53>] ? __wake_up+0x53/0x70 [<ffffffffa0304146>]
> > get_active_stripe+0x236/0x830 [raid456] [<ffffffff81065df0>] ?=20
> > default_wake_function+0x0/0x20 [<ffffffff8109b5ce>] ?=20
> > prepare_to_wait+0x4e/0x80 [<ffffffffa0308e15>]=20
> > make_request+0x1b5/0xc6c [raid456] [<ffffffff8109b2a0>] ?
> > autoremove_wake_function+0x0/0x40 [<ffffffff8140fa39>] ?=20
> > md_wakeup_thread+0x39/0x70 [<ffffffff81415b41>]
> > md_make_request+0xe1/0x230 [<ffffffffa0308f66>] ?=20
> > make_request+0x306/0xc6c [raid456] [<ffffffff81266c50>]
> > generic_make_request+0x240/0x5a0 [<ffffffff811220e5>] ?=20
> > mempool_alloc_slab+0x15/0x20 [<ffffffff81122283>] ?=20
> > mempool_alloc+0x63/0x140 [<ffffffff81267020>] submit_bio+0x70/0x120=20
> > [<ffffffff811c767a>] do_direct_IO+0x7ca/0xfa0 [<ffffffff811c8196>]
> > __blockdev_direct_IO_newtrunc+0x346/0x1270
> > [<ffffffff811c4330>] ? blkdev_get_block+0x0/0x20 [<ffffffff811c9137>]
> > __blockdev_direct_IO+0x77/0xe0 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff811c53b7>]
> > blkdev_direct_IO+0x57/0x60 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff81120552>]
> > generic_file_direct_write+0xc2/0x190
> > [<ffffffff81121e71>] __generic_file_aio_write+0x3a1/0x490
> > [<ffffffff811d64c0>] ? aio_read_evt+0xa0/0x170 [<ffffffff811c490c>]
> > blkdev_aio_write+0x3c/0xa0 [<ffffffff811c48d0>] ?=20
> > blkdev_aio_write+0x0/0xa0 [<ffffffff811d4f64>]
> > aio_rw_vect_retry+0x84/0x200 [<ffffffff811d6924>]
> > aio_run_iocb+0x64/0x170 [<ffffffff811d7d51>] do_io_submit+0x291/0x920=20
> > [<ffffffff811d83f0>] sys_io_submit+0x10/0x20 [<ffffffff8100b072>]=20
> > system_call_fastpath+0x16/0x1b
> > INFO: task fio:2717 blocked for more than 120 seconds.
> > Not tainted 2.6.32-431.el6.x86_64 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > fio           D 0000000000000004     0  2717   2654 0x00000080
> > ffff880439e97698 0000000000000082 ffff880439e97628 ffffffff81058d53
> > ffff880439e97648 ffff880230e49cc0 ffff8802389aa228 ffff88043b2ad1b8
> > ffff88043b0adab8 ffff880439e97fd8 000000000000fbc8 ffff88043b0adab8 Cal=
l Trace:
> > [<ffffffff81058d53>] ? __wake_up+0x53/0x70 [<ffffffffa030334b>] ?=20
> > md_raid5_unplug_device+0x7b/0x100 [raid456] [<ffffffffa0304146>]
> > get_active_stripe+0x236/0x830 [raid456] [<ffffffff81065df0>] ?=20
> > default_wake_function+0x0/0x20 [<ffffffff8109b5ce>] ?=20
> > prepare_to_wait+0x4e/0x80 [<ffffffffa0308e15>]=20
> > make_request+0x1b5/0xc6c [raid456] [<ffffffff8109b2a0>] ?
> > autoremove_wake_function+0x0/0x40 [<ffffffff811220e5>] ?=20
> > mempool_alloc_slab+0x15/0x20 [<ffffffff81415b41>]
> > md_make_request+0xe1/0x230 [<ffffffff811c32f0>] ?=20
> > __bio_add_page+0x110/0x230 [<ffffffff81266c50>]
> > generic_make_request+0x240/0x5a0 [<ffffffff811c742c>] ?=20
> > do_direct_IO+0x57c/0xfa0 [<ffffffff81267020>] submit_bio+0x70/0x120=20
> > [<ffffffff811c8e50>] __blockdev_direct_IO_newtrunc+0x1000/0x1270
> > [<ffffffff811c4330>] ? blkdev_get_block+0x0/0x20 [<ffffffff811c9137>]
> > __blockdev_direct_IO+0x77/0xe0 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff811c53b7>]
> > blkdev_direct_IO+0x57/0x60 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff81120552>]
> > generic_file_direct_write+0xc2/0x190
> > [<ffffffff81121e71>] __generic_file_aio_write+0x3a1/0x490
> > [<ffffffff811d64c0>] ? aio_read_evt+0xa0/0x170 [<ffffffff811c490c>]
> > blkdev_aio_write+0x3c/0xa0 [<ffffffff811c48d0>] ?=20
> > blkdev_aio_write+0x0/0xa0 [<ffffffff811d4f64>]
> > aio_rw_vect_retry+0x84/0x200 [<ffffffff811d6924>]
> > aio_run_iocb+0x64/0x170 [<ffffffff811d7d51>] do_io_submit+0x291/0x920=20
> > [<ffffffff811d83f0>] sys_io_submit+0x10/0x20 [<ffffffff8100b072>]=20
> > system_call_fastpath+0x16/0x1b
> > INFO: task fio:2718 blocked for more than 120 seconds.
> > Not tainted 2.6.32-431.el6.x86_64 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > fio           D 0000000000000005     0  2718   2654 0x00000080
> > ffff88043bc13698 0000000000000082 ffff88043bc13628 ffffffff81058d53
> > ffff88043bc13648 ffff880230e49cc0 ffff8802389aa228 ffff88043b2ad1b8
> > ffff88043b0ad058 ffff88043bc13fd8 000000000000fbc8 ffff88043b0ad058 Cal=
l Trace:
> > [<ffffffff81058d53>] ? __wake_up+0x53/0x70 [<ffffffffa030334b>] ?=20
> > md_raid5_unplug_device+0x7b/0x100 [raid456] [<ffffffffa0304146>]
> > get_active_stripe+0x236/0x830 [raid456] [<ffffffff81065df0>] ?=20
> > default_wake_function+0x0/0x20 [<ffffffff8109b5ce>] ?=20
> > prepare_to_wait+0x4e/0x80 [<ffffffffa0308e15>]=20
> > make_request+0x1b5/0xc6c [raid456] [<ffffffff8109b2a0>] ?
> > autoremove_wake_function+0x0/0x40 [<ffffffff811220e5>] ?=20
> > mempool_alloc_slab+0x15/0x20 [<ffffffff81415b41>]
> > md_make_request+0xe1/0x230 [<ffffffff811c3fd2>] ?=20
> > bvec_alloc_bs+0x62/0x110 [<ffffffff811c32f0>] ?=20
> > __bio_add_page+0x110/0x230 [<ffffffff81266c50>]
> > generic_make_request+0x240/0x5a0 [<ffffffff811c742c>] ?=20
> > do_direct_IO+0x57c/0xfa0 [<ffffffff81267020>] submit_bio+0x70/0x120=20
> > [<ffffffff811c8e50>] __blockdev_direct_IO_newtrunc+0x1000/0x1270
> > [<ffffffff811c4330>] ? blkdev_get_block+0x0/0x20 [<ffffffff811c9137>]
> > __blockdev_direct_IO+0x77/0xe0 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff811c53b7>]
> > blkdev_direct_IO+0x57/0x60 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff81120552>]
> > generic_file_direct_write+0xc2/0x190
> > [<ffffffff81121e71>] __generic_file_aio_write+0x3a1/0x490
> > [<ffffffff811d64c0>] ? aio_read_evt+0xa0/0x170 [<ffffffff811c490c>]
> > blkdev_aio_write+0x3c/0xa0 [<ffffffff811c48d0>] ?=20
> > blkdev_aio_write+0x0/0xa0 [<ffffffff811d4f64>]
> > aio_rw_vect_retry+0x84/0x200 [<ffffffff811d6924>]
> > aio_run_iocb+0x64/0x170 [<ffffffff811d7d51>] do_io_submit+0x291/0x920=20
> > [<ffffffff811d83f0>] sys_io_submit+0x10/0x20 [<ffffffff8100b072>]=20
> > system_call_fastpath+0x16/0x1b
> > INFO: task fio:2719 blocked for more than 120 seconds.
> > Not tainted 2.6.32-431.el6.x86_64 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > fio           D 0000000000000001     0  2719   2654 0x00000080
> > ffff880439ebb698 0000000000000082 ffff880439ebb628 ffffffff81058d53
> > ffff880439ebb648 ffff880230e49cc0 ffff8802389aa228 ffff88043b2ad1b8
> > ffff88043b0ac5f8 ffff880439ebbfd8 000000000000fbc8 ffff88043b0ac5f8 Cal=
l Trace:
> > [<ffffffff81058d53>] ? __wake_up+0x53/0x70 [<ffffffffa030334b>] ?=20
> > md_raid5_unplug_device+0x7b/0x100 [raid456] [<ffffffffa0304146>]
> > get_active_stripe+0x236/0x830 [raid456] [<ffffffff81065df0>] ?=20
> > default_wake_function+0x0/0x20 [<ffffffff8109b5ce>] ?=20
> > prepare_to_wait+0x4e/0x80 [<ffffffffa0308e15>]=20
> > make_request+0x1b5/0xc6c [raid456] [<ffffffff8109b2a0>] ?
> > autoremove_wake_function+0x0/0x40 [<ffffffff811220e5>] ?=20
> > mempool_alloc_slab+0x15/0x20 [<ffffffff81415b41>]
> > md_make_request+0xe1/0x230 [<ffffffff811c3fd2>] ?=20
> > bvec_alloc_bs+0x62/0x110 [<ffffffff811c32f0>] ?=20
> > __bio_add_page+0x110/0x230 [<ffffffff81266c50>]
> > generic_make_request+0x240/0x5a0 [<ffffffff811c742c>] ?=20
> > do_direct_IO+0x57c/0xfa0 [<ffffffff81267020>] submit_bio+0x70/0x120=20
> > [<ffffffff811c8acd>] __blockdev_direct_IO_newtrunc+0xc7d/0x1270
> > [<ffffffff811c4330>] ? blkdev_get_block+0x0/0x20 [<ffffffff811c9137>]
> > __blockdev_direct_IO+0x77/0xe0 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff811c53b7>]
> > blkdev_direct_IO+0x57/0x60 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff81120552>]
> > generic_file_direct_write+0xc2/0x190
> > [<ffffffff81121e71>] __generic_file_aio_write+0x3a1/0x490
> > [<ffffffff811d64c0>] ? aio_read_evt+0xa0/0x170 [<ffffffff811c490c>]
> > blkdev_aio_write+0x3c/0xa0 [<ffffffff811c48d0>] ?=20
> > blkdev_aio_write+0x0/0xa0 [<ffffffff811d4f64>]
> > aio_rw_vect_retry+0x84/0x200 [<ffffffff811d6924>]
> > aio_run_iocb+0x64/0x170 [<ffffffff811d7d51>] do_io_submit+0x291/0x920=20
> > [<ffffffff811d83f0>] sys_io_submit+0x10/0x20 [<ffffffff8100b072>]=20
> > system_call_fastpath+0x16/0x1b
> > INFO: task fio:2720 blocked for more than 120 seconds.
> > Not tainted 2.6.32-431.el6.x86_64 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > fio           D 0000000000000008     0  2720   2654 0x00000080
> > ffff88043b8cf698 0000000000000082 ffff88043b8cf628 ffffffff81058d53
> > ffff88043b8cf648 ffff880230e49cc0 ffff8802389aa228 ffff88043b2ad1b8
> > ffff880439e89af8 ffff88043b8cffd8 000000000000fbc8 ffff880439e89af8 Cal=
l Trace:
> > [<ffffffff81058d53>] ? __wake_up+0x53/0x70 [<ffffffffa030334b>] ?=20
> > md_raid5_unplug_device+0x7b/0x100 [raid456] [<ffffffffa0304146>]
> > get_active_stripe+0x236/0x830 [raid456] [<ffffffff81065df0>] ?=20
> > default_wake_function+0x0/0x20 [<ffffffff8109b5ce>] ?=20
> > prepare_to_wait+0x4e/0x80 [<ffffffffa0308e15>]=20
> > make_request+0x1b5/0xc6c [raid456] [<ffffffff8109b2a0>] ?
> > autoremove_wake_function+0x0/0x40 [<ffffffff811220e5>] ?=20
> > mempool_alloc_slab+0x15/0x20 [<ffffffff81415b41>]
> > md_make_request+0xe1/0x230 [<ffffffff811c3fd2>] ?=20
> > bvec_alloc_bs+0x62/0x110 [<ffffffff811c32f0>] ?=20
> > __bio_add_page+0x110/0x230 [<ffffffff81266c50>]
> > generic_make_request+0x240/0x5a0 [<ffffffff811c742c>] ?=20
> > do_direct_IO+0x57c/0xfa0 [<ffffffff81267020>] submit_bio+0x70/0x120=20
> > [<ffffffff811c8acd>] __blockdev_direct_IO_newtrunc+0xc7d/0x1270
> > [<ffffffff811c4330>] ? blkdev_get_block+0x0/0x20 [<ffffffff811c9137>]
> > __blockdev_direct_IO+0x77/0xe0 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff811c53b7>]
> > blkdev_direct_IO+0x57/0x60 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff81120552>]
> > generic_file_direct_write+0xc2/0x190
> > [<ffffffff81121e71>] __generic_file_aio_write+0x3a1/0x490
> > [<ffffffff811d64c0>] ? aio_read_evt+0xa0/0x170 [<ffffffff811c490c>]
> > blkdev_aio_write+0x3c/0xa0 [<ffffffff811c48d0>] ?=20
> > blkdev_aio_write+0x0/0xa0 [<ffffffff811d4f64>]
> > aio_rw_vect_retry+0x84/0x200 [<ffffffff811d6924>]
> > aio_run_iocb+0x64/0x170 [<ffffffff811d7d51>] do_io_submit+0x291/0x920=20
> > [<ffffffff811d83f0>] sys_io_submit+0x10/0x20 [<ffffffff8100b072>]=20
> > system_call_fastpath+0x16/0x1b
> > INFO: task fio:2721 blocked for more than 120 seconds.
> > Not tainted 2.6.32-431.el6.x86_64 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > fio           D 0000000000000000     0  2721   2654 0x00000080
> > ffff88043b047698 0000000000000082 ffff88043b047628 ffffffff81058d53
> > ffff88043b047648 ffff880230e49cc0 ffff8802389aa228 ffff88043b2ad1b8
> > ffff880439e89098 ffff88043b047fd8 000000000000fbc8 ffff880439e89098 Cal=
l Trace:
> > [<ffffffff81058d53>] ? __wake_up+0x53/0x70 [<ffffffffa030334b>] ?=20
> > md_raid5_unplug_device+0x7b/0x100 [raid456] [<ffffffffa0304146>]
> > get_active_stripe+0x236/0x830 [raid456] [<ffffffff81065df0>] ?=20
> > default_wake_function+0x0/0x20 [<ffffffff8109b5ce>] ?=20
> > prepare_to_wait+0x4e/0x80 [<ffffffffa0308e15>]=20
> > make_request+0x1b5/0xc6c [raid456] [<ffffffff8109b2a0>] ?
> > autoremove_wake_function+0x0/0x40 [<ffffffff811220e5>] ?=20
> > mempool_alloc_slab+0x15/0x20 [<ffffffff81415b41>]
> > md_make_request+0xe1/0x230 [<ffffffff811c3fd2>] ?=20
> > bvec_alloc_bs+0x62/0x110 [<ffffffff811c32f0>] ?=20
> > __bio_add_page+0x110/0x230 [<ffffffff81266c50>]
> > generic_make_request+0x240/0x5a0 [<ffffffff811c742c>] ?=20
> > do_direct_IO+0x57c/0xfa0 [<ffffffff81267020>] submit_bio+0x70/0x120=20
> > [<ffffffff811c8acd>] __blockdev_direct_IO_newtrunc+0xc7d/0x1270
> > [<ffffffff811c4330>] ? blkdev_get_block+0x0/0x20 [<ffffffff811c9137>]
> > __blockdev_direct_IO+0x77/0xe0 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff811c53b7>]
> > blkdev_direct_IO+0x57/0x60 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff81120552>]
> > generic_file_direct_write+0xc2/0x190
> > [<ffffffff81121e71>] __generic_file_aio_write+0x3a1/0x490
> > [<ffffffff811d64c0>] ? aio_read_evt+0xa0/0x170 [<ffffffff811c490c>]
> > blkdev_aio_write+0x3c/0xa0 [<ffffffff811c48d0>] ?=20
> > blkdev_aio_write+0x0/0xa0 [<ffffffff811d4f64>]
> > aio_rw_vect_retry+0x84/0x200 [<ffffffff811d6924>]
> > aio_run_iocb+0x64/0x170 [<ffffffff811d7d51>] do_io_submit+0x291/0x920=20
> > [<ffffffff811d83f0>] sys_io_submit+0x10/0x20 [<ffffffff8100b072>]=20
> > system_call_fastpath+0x16/0x1b
> > INFO: task fio:2722 blocked for more than 120 seconds.
> > Not tainted 2.6.32-431.el6.x86_64 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > fio           D 0000000000000000     0  2722   2654 0x00000080
> > ffff880439ea3698 0000000000000082 ffff880439ea3628 ffffffff81058d53
> > ffff880439ea3648 ffff880230e49cc0 ffff8802389aa228 ffff88043b2ad1b8
> > ffff880439e88638 ffff880439ea3fd8 000000000000fbc8 ffff880439e88638 Cal=
l Trace:
> > [<ffffffff81058d53>] ? __wake_up+0x53/0x70 [<ffffffffa030334b>] ?=20
> > md_raid5_unplug_device+0x7b/0x100 [raid456] [<ffffffffa0304146>]
> > get_active_stripe+0x236/0x830 [raid456] [<ffffffff81065df0>] ?=20
> > default_wake_function+0x0/0x20 [<ffffffff8109b5ce>] ?=20
> > prepare_to_wait+0x4e/0x80 [<ffffffffa0308e15>]=20
> > make_request+0x1b5/0xc6c [raid456] [<ffffffff8109b2a0>] ?
> > autoremove_wake_function+0x0/0x40 [<ffffffff811220e5>] ?=20
> > mempool_alloc_slab+0x15/0x20 [<ffffffff81415b41>]
> > md_make_request+0xe1/0x230 [<ffffffff811c3fd2>] ?=20
> > bvec_alloc_bs+0x62/0x110 [<ffffffff811c32f0>] ?=20
> > __bio_add_page+0x110/0x230 [<ffffffff81266c50>]
> > generic_make_request+0x240/0x5a0 [<ffffffff811c742c>] ?=20
> > do_direct_IO+0x57c/0xfa0 [<ffffffff81267020>] submit_bio+0x70/0x120=20
> > [<ffffffff811c8acd>] __blockdev_direct_IO_newtrunc+0xc7d/0x1270
> > [<ffffffff811c4330>] ? blkdev_get_block+0x0/0x20 [<ffffffff811c9137>]
> > __blockdev_direct_IO+0x77/0xe0 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff811c53b7>]
> > blkdev_direct_IO+0x57/0x60 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff81120552>]
> > generic_file_direct_write+0xc2/0x190
> > [<ffffffff81121e71>] __generic_file_aio_write+0x3a1/0x490
> > [<ffffffff811d64c0>] ? aio_read_evt+0xa0/0x170 [<ffffffff811c490c>]
> > blkdev_aio_write+0x3c/0xa0 [<ffffffff811c48d0>] ?=20
> > blkdev_aio_write+0x0/0xa0 [<ffffffff811d4f64>]
> > aio_rw_vect_retry+0x84/0x200 [<ffffffff811d6924>]
> > aio_run_iocb+0x64/0x170 [<ffffffff811d7d51>] do_io_submit+0x291/0x920=20
> > [<ffffffff811d83f0>] sys_io_submit+0x10/0x20 [<ffffffff8100b072>]=20
> > system_call_fastpath+0x16/0x1b
> > INFO: task fio:2723 blocked for more than 120 seconds.
> > Not tainted 2.6.32-431.el6.x86_64 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > fio           D 0000000000000006     0  2723   2654 0x00000080
> > ffff88043bf5f698 0000000000000082 ffff88043bf5f628 ffffffff81058d53
> > ffff88043bf5f648 ffff880230e49cc0 ffff8802389aa228 ffff88043b2ad1b8
> > ffff88043a183ab8 ffff88043bf5ffd8 000000000000fbc8 ffff88043a183ab8 Cal=
l Trace:
> > [<ffffffff81058d53>] ? __wake_up+0x53/0x70 [<ffffffffa030334b>] ?=20
> > md_raid5_unplug_device+0x7b/0x100 [raid456] [<ffffffffa0304146>]
> > get_active_stripe+0x236/0x830 [raid456] [<ffffffff81065df0>] ?=20
> > default_wake_function+0x0/0x20 [<ffffffff8109b5ce>] ?=20
> > prepare_to_wait+0x4e/0x80 [<ffffffffa0308e15>]=20
> > make_request+0x1b5/0xc6c [raid456] [<ffffffff8109b2a0>] ?
> > autoremove_wake_function+0x0/0x40 [<ffffffff811220e5>] ?=20
> > mempool_alloc_slab+0x15/0x20 [<ffffffff81415b41>]
> > md_make_request+0xe1/0x230 [<ffffffff811c3fd2>] ?=20
> > bvec_alloc_bs+0x62/0x110 [<ffffffff811c32f0>] ?=20
> > __bio_add_page+0x110/0x230 [<ffffffff81266c50>]
> > generic_make_request+0x240/0x5a0 [<ffffffff811c742c>] ?=20
> > do_direct_IO+0x57c/0xfa0 [<ffffffff81267020>] submit_bio+0x70/0x120=20
> > [<ffffffff811c8acd>] __blockdev_direct_IO_newtrunc+0xc7d/0x1270
> > [<ffffffff811c4330>] ? blkdev_get_block+0x0/0x20 [<ffffffff811c9137>]
> > __blockdev_direct_IO+0x77/0xe0 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff811c53b7>]
> > blkdev_direct_IO+0x57/0x60 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff81120552>]
> > generic_file_direct_write+0xc2/0x190
> > [<ffffffff81121e71>] __generic_file_aio_write+0x3a1/0x490
> > [<ffffffff811d64c0>] ? aio_read_evt+0xa0/0x170 [<ffffffff811c490c>]
> > blkdev_aio_write+0x3c/0xa0 [<ffffffff811c48d0>] ?=20
> > blkdev_aio_write+0x0/0xa0 [<ffffffff811d4f64>]
> > aio_rw_vect_retry+0x84/0x200 [<ffffffff811d6924>]
> > aio_run_iocb+0x64/0x170 [<ffffffff811d7d51>] do_io_submit+0x291/0x920=20
> > [<ffffffff811d83f0>] sys_io_submit+0x10/0x20 [<ffffffff8100b072>]=20
> > system_call_fastpath+0x16/0x1b
> > INFO: task fio:2724 blocked for more than 120 seconds.
> > Not tainted 2.6.32-431.el6.x86_64 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > fio           D 000000000000000b     0  2724   2654 0x00000080
> > ffff88043be05698 0000000000000082 ffff88043be05628 ffffffff81058d53
> > ffff88043be05648 ffff880230e49cc0 ffff8802389aa228 ffff88043b2ad1b8
> > ffff88043a183058 ffff88043be05fd8 000000000000fbc8 ffff88043a183058 Cal=
l Trace:
> > [<ffffffff81058d53>] ? __wake_up+0x53/0x70 [<ffffffffa030334b>] ?=20
> > md_raid5_unplug_device+0x7b/0x100 [raid456] [<ffffffffa0304146>]
> > get_active_stripe+0x236/0x830 [raid456] [<ffffffff81065df0>] ?=20
> > default_wake_function+0x0/0x20 [<ffffffff8109b5ce>] ?=20
> > prepare_to_wait+0x4e/0x80 [<ffffffffa0308e15>]=20
> > make_request+0x1b5/0xc6c [raid456] [<ffffffff8109b2a0>] ?
> > autoremove_wake_function+0x0/0x40 [<ffffffff811220e5>] ?=20
> > mempool_alloc_slab+0x15/0x20 [<ffffffff81415b41>]
> > md_make_request+0xe1/0x230 [<ffffffff811c3fd2>] ?=20
> > bvec_alloc_bs+0x62/0x110 [<ffffffff811c32f0>] ?=20
> > __bio_add_page+0x110/0x230 [<ffffffff81266c50>]
> > generic_make_request+0x240/0x5a0 [<ffffffff811c742c>] ?=20
> > do_direct_IO+0x57c/0xfa0 [<ffffffff81267020>] submit_bio+0x70/0x120=20
> > [<ffffffff811c8acd>] __blockdev_direct_IO_newtrunc+0xc7d/0x1270
> > [<ffffffff811c4330>] ? blkdev_get_block+0x0/0x20 [<ffffffff811c9137>]
> > __blockdev_direct_IO+0x77/0xe0 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff811c53b7>]
> > blkdev_direct_IO+0x57/0x60 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff81120552>]
> > generic_file_direct_write+0xc2/0x190
> > [<ffffffff81121e71>] __generic_file_aio_write+0x3a1/0x490
> > [<ffffffff811d64c0>] ? aio_read_evt+0xa0/0x170 [<ffffffff811c490c>]
> > blkdev_aio_write+0x3c/0xa0 [<ffffffff811c48d0>] ?=20
> > blkdev_aio_write+0x0/0xa0 [<ffffffff811d4f64>]
> > aio_rw_vect_retry+0x84/0x200 [<ffffffff811d6924>]
> > aio_run_iocb+0x64/0x170 [<ffffffff811d7d51>] do_io_submit+0x291/0x920=20
> > [<ffffffff811d83f0>] sys_io_submit+0x10/0x20 [<ffffffff8100b072>]=20
> > system_call_fastpath+0x16/0x1b
> > INFO: task fio:2725 blocked for more than 120 seconds.
> > Not tainted 2.6.32-431.el6.x86_64 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > fio           D 0000000000000003     0  2725   2654 0x00000080
> > ffff88043be07698 0000000000000082 ffff88043be07628 ffffffff81058d53
> > ffff88043be07648 ffff880230e49cc0 ffff8802389aa228 ffff88043b2ad1b8
> > ffff88043a1825f8 ffff88043be07fd8 000000000000fbc8 ffff88043a1825f8 Cal=
l Trace:
> > [<ffffffff81058d53>] ? __wake_up+0x53/0x70 [<ffffffffa030334b>] ?=20
> > md_raid5_unplug_device+0x7b/0x100 [raid456] [<ffffffffa0304146>]
> > get_active_stripe+0x236/0x830 [raid456] [<ffffffff81065df0>] ?=20
> > default_wake_function+0x0/0x20 [<ffffffff8109b5ce>] ?=20
> > prepare_to_wait+0x4e/0x80 [<ffffffffa0308e15>]=20
> > make_request+0x1b5/0xc6c [raid456] [<ffffffff8109b2a0>] ?
> > autoremove_wake_function+0x0/0x40 [<ffffffff811220e5>] ?=20
> > mempool_alloc_slab+0x15/0x20 [<ffffffff81415b41>]
> > md_make_request+0xe1/0x230 [<ffffffff811c3fd2>] ?=20
> > bvec_alloc_bs+0x62/0x110 [<ffffffff811c32f0>] ?=20
> > __bio_add_page+0x110/0x230 [<ffffffff81266c50>]
> > generic_make_request+0x240/0x5a0 [<ffffffff811c742c>] ?=20
> > do_direct_IO+0x57c/0xfa0 [<ffffffff81267020>] submit_bio+0x70/0x120=20
> > [<ffffffff811c8acd>] __blockdev_direct_IO_newtrunc+0xc7d/0x1270
> > [<ffffffff811c4330>] ? blkdev_get_block+0x0/0x20 [<ffffffff811c9137>]
> > __blockdev_direct_IO+0x77/0xe0 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff811c53b7>]
> > blkdev_direct_IO+0x57/0x60 [<ffffffff811c4330>] ?=20
> > blkdev_get_block+0x0/0x20 [<ffffffff81120552>]
> > generic_file_direct_write+0xc2/0x190
> > [<ffffffff81121e71>] __generic_file_aio_write+0x3a1/0x490
> > [<ffffffff811d64c0>] ? aio_read_evt+0xa0/0x170 [<ffffffff811c490c>]
> > blkdev_aio_write+0x3c/0xa0 [<ffffffff811c48d0>] ?=20
> > blkdev_aio_write+0x0/0xa0 [<ffffffff811d4f64>]
> > aio_rw_vect_retry+0x84/0x200 [<ffffffff811d6924>]
> > aio_run_iocb+0x64/0x170 [<ffffffff811d7d51>] do_io_submit+0x291/0x920=20
> > [<ffffffff811d83f0>] sys_io_submit+0x10/0x20 [<ffffffff8100b072>]=20
> > system_call_fastpath+0x16/0x1b
> >=20
> > [root@root ~]# cat /proc/2690/stack
> > [<ffffffff810686da>] __cond_resched+0x2a/0x40 [<ffffffffa030361c>]
> > ops_run_io+0x2c/0x920 [raid456] [<ffffffffa03052cc>]
> > handle_stripe+0x9cc/0x2980 [raid456] [<ffffffffa03078a4>]
> > raid5d+0x624/0x850 [raid456] [<ffffffff81416f05>]
> > md_thread+0x115/0x150 [<ffffffff8109aef6>] kthread+0x96/0xa0=20
> > [<ffffffff8100c20a>] child_rip+0xa/0x20 [<ffffffffffffffff>]=20
> > 0xffffffffffffffff
> >=20
> > [root@root ~]# cat /proc/2690/stat
> > 2690 (md0_raid5) R 2 0 0 0 -1 2149613632 0 0 0 0 0 68495 0 0 20 0 1 0
> > 350990 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483391 256 0 0 0 17
> > 2 0 0 6855 0 0 [root@root ~]# cat /proc/2690/statm
> > 0 0 0 0 0 0 0
> > [root@root ~]# cat /proc/2690/stat
> > stat    statm   status
> > [root@root ~]# cat /proc/2690/status
> > Name:   md0_raid5
> > State:  R (running)
> > Tgid:   2690
> > Pid:    2690
> > PPid:   2
> > TracerPid:      0
> > Uid:    0       0       0       0
> > Gid:    0       0       0       0
> > Utrace: 0
> > FDSize: 64
> > Groups:
> > Threads:        1
> > SigQ:   2/128402
> > SigPnd: 0000000000000000
> > ShdPnd: 0000000000000000
> > SigBlk: 0000000000000000
> > SigIgn: fffffffffffffeff
> > SigCgt: 0000000000000100
> > CapInh: 0000000000000000
> > CapPrm: ffffffffffffffff
> > CapEff: fffffffffffffeff
> > CapBnd: ffffffffffffffff
> > Cpus_allowed:   ffffff
> > Cpus_allowed_list:      0-23
> > Mems_allowed:   00000000,00000000,00000000,00000000,00000000,00000000,0=
0000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,0000=
0000,00000003
> > Mems_allowed_list:      0-1
> > voluntary_ctxt_switches:        5411612
> > nonvoluntary_ctxt_switches:     257032
> >=20
> >=20
> > Thanks,
> > Manibalan.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/ZE.edWThztZ24S57QDtErHx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVM/6kDnsnt1WYoG5AQKAzA//WqE2kQLTqFCuLKV/7UTsrK7QbFlqI4Ez
1hI3tQ7OXr0R4aAnIYSPWt7Bk5mWpJiziAorW9zjtcI8FVF926b60Td+/Fnj8UJI
vgZpArWmxh/ZSewQfx/fMJRYbs63WdGreBFuYoABJqGvOTzbwM1z6jYUS9WtO6CH
tJ80Vncw6NA8/3yB6K6cg82MhF6J+HLPkomVDlY350Y6eyDTRl0kmgljzimlDBOG
okcRjFTeeD01Qsfd4w1RpJanNoiSAGmwnbididEPD3q+7mFUiLcp9tjaM+CSXdos
rDHXgl8rbOnOOugCxrGMZ/KmmAxtz4roLFJ7hzLCMDnZnA1gCt/7uAsg8GLpEqii
RZASaW6n3K1yzNG0bXfD88RaUDkVBtHA7hyCjazkDO5LtF7hN/g8/ebxQnhwRUDc
1LcvcD9JQdYWF+4doft7UMia+JQdSv4BWqre7SRdLzdHFzr2PIs8VLWgpyo+IV9R
Rl/CI486A941iDI9b7PZHOJzgENtoJUf15XOgzygBvm5Yx2vukeewNlfNI7TU8Zz
uvASPzwxG+XNJkFCsD57RjrcomyyaE5iU1UpLwXDrQzUBaH14x4JR8ov8hSL3B3H
3NOJ2I5LC8hLzuXYL992Dl0TaK/Ixw+kWMDHP9hcP28qDdtYfZbX7HqaCDBzn+iM
DTXxlzNaYP4=
=7gb6
-----END PGP SIGNATURE-----

--Sig_/ZE.edWThztZ24S57QDtErHx--

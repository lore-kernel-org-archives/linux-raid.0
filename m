From: Torsten Landschoff <torsten@debian.org>
Subject: OOPS with raid1
Date: Thu, 8 May 2003 17:22:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030508152237.GB26189@stargate.galaxy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi *,

I wonder if nobody has noticed this before but there seems to be at
least one serious bug in the raid1 code. I only noticed because I
simulated a disk failure to check if the raid is working.=20

I don't have a log of the original failure on a production system but it
is reproducible for me quite simple:

pulsar:~# uname -a
Linux pulsar 2.4.20-686-smp #1 SMP Mon Jan 13 23:06:41 EST 2003 i686

(that's the kernel as shipped in Debian unstable's
kernel-image-2.4.20-686-smp)

pulsar:~# mdadm --create /dev/md0 -l 1 -n 2 /dev/ram0 /dev/ram1
md: bind<[dev 01:00],1>
md0: WARNING: [dev 01:01] appears to be on the same physical disk as [dev 0=
1:00]. True
     protection against single-disk failure might be compromised.
md: bind<[dev 01:01],2>
md: [dev 01:01]'s event counter: 00000000
md: [dev 01:00]'s event counter: 00000000
md: md0: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing anyway.
md: raid1 personality registered as nr 3
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
raid1: device [dev 01:01] operational as mirror 1
raid1: device [dev 01:00] operational as mirror 0
raid1: raid set md0 not clean; reconstructing mirrors
raid1: raid set md0 active with 2 out of 2 mirrors
md: updating md0 RAID superblock on device
md: [dev 01:01] [events: 00000001]<6>(write) [dev 01:01]'s sb offset: 4032
md: [dev 01:00] [events: 00000001]<6>(write) [dev 01:00]'s sb offset: 4032
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000 KB/s=
ec) for reconstruction.
md: using 124k window, over a total of 4032 blocks.
mdadm: array /dev/md0 started.

pulsar:~# mdadm -f /dev/md0 /dev/ram1
raid1: Disk failure on [dev 01:01], disabling device.
(that's the kernel as shipped in Debian unstable's kernel-image-2.4.20-686-=
smp)

peration continuing on 1 devices
md: updating md0 RAID superblock on device
md: [dev 01:01] [events: 00000002]<6>(write) [dev 01:01]'s sb offset: 4032
md: recovery thread got woken up ...
md0: no spare disk to reconstruct array! -- continuing in degraded mode
CPU:    1
EIP:    0010:[<d8921383>]    Not tainted
EFLAGS: 00010246
eax: c1a70380   ebx: 00000101   ecx: 00000400   edx: 00001000
esi: 00000000   edi: cc06f000   ebp: cec5ff60   esp: cee73f44
ds: 0018   es: 0018   ss: 0018
Process raid1d (pid: 1219, stackpage=3Dcee73000)
Stack: cec5ff60 d56101a0 d1e7a660 d1e7a674 00000000 c1a70380 d8921653 cec5f=
f60
       d892617f 00000002 d1e7a660 cee72000 d56103a0 00000001 00000064 00000=
000
       d8a468bd d1e7a660 cee72000 cee72000 d56103a0 00000001 00000001 00000=
004
Call Trace:    [<d8921653>] [<d892617f>] [<d8a468bd>] [<d8924259>] [<c01071=
64>]

Code: f3 a5 8b 44 24 14 8b 54 24 10 f0 0f ab 50 18 8b 44 24 14 e8
 mdadm: set /dev/ram1 faulty in /dev/md0

Relevant excerpt from syslog:

May  8 17:12:28 pulsar kernel: Unable to handle kernel NULL pointer derefer=
ence at virtual address 00000000
May  8 17:12:28 pulsar kernel:  printing eip:
May  8 17:12:28 pulsar kernel: d8921383
May  8 17:12:28 pulsar kernel: *pde =3D 00000000
May  8 17:12:28 pulsar kernel: Oops: 0000
May  8 17:12:28 pulsar kernel: CPU:    1
May  8 17:12:28 pulsar kernel: EIP:    0010:[input:__insmod_input_O/lib/mod=
ules/2.4.20-686-smp/kernel/drivers/+-60541/96]    Not tainted
May  8 17:12:28 pulsar kernel: EFLAGS: 00010246
May  8 17:12:28 pulsar kernel: md: recovery thread finished ...
May  8 17:12:28 pulsar kernel: eax: c1a70380   ebx: 00000101   ecx: 0000040=
0   edx: 00001000
May  8 17:12:28 pulsar kernel: esi: 00000000   edi: cc06f000   ebp: cec5ff6=
0   esp: cee73f44
May  8 17:12:28 pulsar kernel: ds: 0018   es: 0018   ss: 0018
May  8 17:12:28 pulsar kernel: Process raid1d (pid: 1219, stackpage=3Dcee73=
000)
May  8 17:12:28 pulsar kernel: Stack: cec5ff60 d56101a0 d1e7a660 d1e7a674 0=
0000000 c1a70380 d8921653 cec5ff60=20
May  8 17:12:28 pulsar kernel:        d892617f 00000002 d1e7a660 cee72000 d=
56103a0 00000001 00000064 00000000=20
May  8 17:12:28 pulsar kernel:        d8a468bd d1e7a660 cee72000 cee72000 d=
56103a0 00000001 00000001 00000004=20
May  8 17:12:28 pulsar kernel: Call Trace:    [input:__insmod_input_O/lib/m=
odules/2.4.20-686-smp/kernel/drivers/+-59821/96] [input:__insmod_input_O/li=
b/modules/2.4.20-686-smp/kernel/drivers/+-40577/96] [awe_wave:__insmod_awe_=
wave_S.data_L9840+1456189/224684141] [input:__insmod_input_O/lib/modules/2.=
4.20-686-smp/kernel/drivers/+-48551/96] [kernel_thread+40/56]
May  8 17:12:28 pulsar kernel:=20
May  8 17:12:28 pulsar kernel: Code: f3 a5 8b 44 24 14 8b 54 24 10 f0 0f ab=
 50 18 8b 44 24 14 e8=20


For reference: On the production server I got a similar entry:

May  5 15:54:13 linuxserv kernel: raid1: Disk failure on sdb1, disabling de=
vice.=20
May  5 15:54:13 linuxserv kernel: ^IOperation continuing on 1 devices
May  5 15:54:13 linuxserv kernel: md: updating md0 RAID superblock on device
May  5 15:54:13 linuxserv kernel: md: sdb1 [events: 0000001b]<6>(write) sdb=
1's sb offset: 497856
May  5 15:54:13 linuxserv kernel: Unable to handle kernel NULL pointer dere=
ference at virtual address 00000000
May  5 15:54:13 linuxserv kernel:  printing eip:
May  5 15:54:13 linuxserv kernel: c01c0fb3
May  5 15:54:13 linuxserv kernel: *pde =3D 00000000
May  5 15:54:13 linuxserv kernel: ops: 0000
May  5 15:54:13 linuxserv kernel: nfsd lockd sunrpc xfs serial loop ide-dis=
k ide-probe-mod ide-mod lvm-mod 3c59x =20
May  5 15:54:13 linuxserv kernel: CPU:    1
May  5 15:54:13 linuxserv kernel: EIP:    0010:[write_disk_sb+375/472]    N=
ot tainted
May  5 15:54:13 linuxserv kernel: EFLAGS: 00010246
May  5 15:54:13 linuxserv kernel: eax: c20d6920   ebx: 00000811   ecx: 0000=
0400   edx: 00001000
May  5 15:54:13 linuxserv kernel: esi: 00000000   edi: c45e3000   ebp: dfff=
6ca0   esp: dfb15f44
May  5 15:54:13 linuxserv kernel: ds: 0018   es: 0018   ss: 0018
May  5 15:54:13 linuxserv kernel: Process raid1d (pid: 11, stackpage=3Ddfb1=
5000)
May  5 15:54:13 linuxserv kernel: Stack: dfff6ca0 dfff6d20 dfb18ea0 dfb18eb=
4 00000000 c20d6920 c01c1283 dfff6ca0=20
May  5 15:54:13 linuxserv kernel:        c022fcff 0000001b dfb18ea0 dfb1400=
0 dfd18620 00000001 00000064 00000000=20
May  5 15:54:13 linuxserv kernel:        c01b909d dfb18ea0 dfb14000 dfb1400=
0 dfd18620 00000001 00000002 00000025=20
May  5 15:54:13 linuxserv kernel: Call Trace: [md_update_sb+359/460]  [raid=
1d+29/1112]  [md_thread+345/444]  [kernel_thread+40/56]=20
May  5 15:54:13 linuxserv kernel: Code: f3 a5 8b 44 24 14 8b 54 24 10 f0 0f=
 ab 50 18 8b 44 24 14 e8=20
May  5 15:54:13 linuxserv kernel:  <6>md: recovery thread got woken up ...
May  5 15:54:13 linuxserv kernel: md0: no spare disk to reconstruct array! =
-- continuing in degraded mode


I just wonder what happened to the call trace over here.=20

Now doing

pulsar:~# mdadm --manage -r /dev/md0 /dev/ram1

works as expected, but reconstructing the raid does not work. Probably
this is just a result of the null pointer dereference earlier on, but
anyway:

pulsar:~# mdadm --manage -a /dev/md0 /dev/ram1

seems to work, but:

pulsar:~# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 [dev 01:01][2] [dev 01:00][0]
      4032 blocks [2/1] [U_]
      [>....................]  recovery =3D  0.0% (0/4032) finish=3D43.0min=
 speed=3D0K/sec
unused devices: <none>

Greetings

	Torsten

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+unY9dQgHtVUb5EcRAom2AJwImFbVa1rxv+CyW1Ynti7Cy+TFWgCeIlIv
WjQ40eoxnWlopIf/1FwEM3o=
=hdMT
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--

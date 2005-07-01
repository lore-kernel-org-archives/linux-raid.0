From: Ming Zhang <mingz@ele.uri.edu>
Subject: RE: raid0 low performance
Date: Fri, 01 Jul 2005 09:54:33 -0400
Message-ID: <1120226073.5501.13.camel@localhost.localdomain>
References: <200507011255.j61CtXp10224@www.watkins-home.com>
	 <1120223833.5507.40.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W0t0v8JYrZn7t34iNfhp"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120223833.5507.40.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-W0t0v8JYrZn7t34iNfhp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2005-07-01 at 09:17 -0400, Ming Zhang wrote:
> On Fri, 2005-07-01 at 08:55 -0400, Guy wrote:
> so i guess the card or bus has problem. i will check bus speed soon.
>=20

here is lspci

# ./lspci
00:00.0 Class 0600: 8086:2578 (rev 02)
00:03.0 Class 0604: 8086:257b (rev 02)
00:1c.0 Class 0604: 8086:25ae (rev 02)
00:1d.0 Class 0c03: 8086:25a9 (rev 02)
00:1d.1 Class 0c03: 8086:25aa (rev 02)
00:1d.4 Class 0880: 8086:25ab (rev 02)
00:1d.5 Class 0800: 8086:25ac (rev 02)
00:1d.7 Class 0c03: 8086:25ad (rev 02)
00:1e.0 Class 0604: 8086:244e (rev 0a)
00:1f.0 Class 0601: 8086:25a1 (rev 02)
00:1f.1 Class 0101: 8086:25a2 (rev 02)
00:1f.2 Class 0101: 8086:25a3 (rev 02)
00:1f.3 Class 0c05: 8086:25a4 (rev 02)
01:01.0 Class 0200: 8086:1075
02:01.0 Class 0100: 11ab:5081 (rev 03)
02:03.0 Class 0100: 9005:00c0 (rev 01)
02:03.1 Class 0100: 9005:00c0 (rev 01)
02:04.0 Class 0104: 11ab:5041
03:09.0 Class 0300: 1002:4752 (rev 27)
03:0a.0 Class 0200: 8086:1076

i checked the 11ab is marvell. so 02:01.0 and 02:04.0 are 4 port marvel
and 8 port marvel.

ps, what is this 02:01.0 means?=20

# ./lspci -t
-[00]-+-00.0
      +-03.0-[01]----01.0
      +-1c.0-[02]--+-01.0
      |            +-03.0
      |            +-03.1
      |            \-04.0
      +-1d.0
      +-1d.1
      +-1d.4
      +-1d.5
      +-1d.7
      +-1e.0-[03]--+-09.0
      |            \-0a.0
      +-1f.0
      +-1f.1
      +-1f.2
      \-1f.3

here why 01.0 appear 2 times and 1 share with the 04.0?


here the verbose output. seem they are 66MHZ and they can do 133. :P

# ./lspci -vv -d 11ab:
02:01.0 Class 0100: 11ab:5081 (rev 03)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 08
        Interrupt: pin A routed to IRQ 24
        Region 0: Memory at fa000000 (64-bit, non-prefetchable)
[size=3D512K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk+ DSI- D1- D2- AuxCurrent=3D0mA PME
(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [50] Message Signalled Interrupts: 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=3D0 OST=3D3
                Status: Bus=3D0 Dev=3D0 Func=3D0 64bit- 133MHz- SCD- USC-,
DC=3Dsimple, DMMRBC=3D0, DMOST=3D0, DMCRS=3D0, RSCEM-

02:04.0 Class 0104: 11ab:5041
        Subsystem: 15d9:5180
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 08
        Interrupt: pin A routed to IRQ 27
        Region 0: Memory at fa080000 (64-bit, non-prefetchable)
[size=3D512K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk+ DSI- D1- D2- AuxCurrent=3D0mA PME
(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [50] Message Signalled Interrupts: 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=3D0 OST=3D3
                Status: Bus=3D0 Dev=3D0 Func=3D0 64bit- 133MHz- SCD- USC-,
DC=3Dsimple, DMMRBC=3D0, DMOST=3D0, DMCRS=3D0, RSCEM-

ming


--=-W0t0v8JYrZn7t34iNfhp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCxUsZSYbkL5BnVYoRAtzCAJ0aOgHOzco4HCGTaaeF8F6hoFnbzgCfXiV7
oJVldGhVFi2CsE6P8swyjK4=
=EFLv
-----END PGP SIGNATURE-----

--=-W0t0v8JYrZn7t34iNfhp--


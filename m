From: "Paul" <paul@kbs.net.au>
Subject: working sata raid - which controller?
Date: Thu, 12 Aug 2004 15:55:19 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <025b01c48030$f2d8da60$cf01a8c0@internal.kbs.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Guys,

We are purchasing a new test server and I need to know which controllers are
sata raid based and are hardware raid and not software raid. We currently
use promise fast trak tx4's and have found in linux there is no mirroring
support and it does not actively mirror data between the two disks.

00:09.0 RAID bus controller: Promise Technology, Inc.: Unknown device 3319
(rev 02)
        Subsystem: Promise Technology, Inc.: Unknown device 3319
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

There is a function in win32 land you can run to "synch" the drives but we
can't find an equivalent in linux and would prefer hardware. Cost is not a
problem.

Thanks


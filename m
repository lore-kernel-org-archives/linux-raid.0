From: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Re[2]: Promise SATA TX4 300 + 3TB disks?
Date: Sun, 7 Oct 2012 19:37:26 +0200
Message-ID: <123539095.20121007193726@oudeis.org>
References: <818058745.20121005012826@oudeis.org>
 <20121005123653.0a5398e0@natsu> <506E9E77.1080002@hardwarefreak.com>
 <20121005145011.673f4974@natsu> <719665592.20121005153321@oudeis.org>
 <506F8FEC.7040402@hardwarefreak.com>
Reply-To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <506F8FEC.7040402@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


SH> As John mentioned the TX4 BIOS/firmware shouldn't be an issue.  This is
SH> a 48bit LBA controller and theoretically can access a single disk drive
SH> of up to 144PB in size.
this is the information I was hoping for ;-) sounds good.

SH> This is the cause of the 2TB drive size limit you read about all over
SH> the web.  If you have a 64bit kernel with an LBA48 controller (most are)
SH> then this shouldn't be an issue, as all 48 LBA bits are addressable by a
SH> 64bit kernel.  With a 64bit kernel, if the TX4 doesn't give you all 3TB
SH> per drive, then there's a driver or firmware bug present.

both systems are running CentOS5 with a recent 64bit kernel, so this
shouldn't be a problem.

SH> Assuming the hot swap bays in the chassis are indeed SATA/SAS and not
SH> SCSI/SCA, then your best, least expensive, solution is the SuperMicro
SH> AOC-SAT2-MV8 64-bit PCI-X133MHz:

ordered one on ebay yesterday, really looking forward to receiving it
:)

SH> You provided no details of the chassis or backplane(s) or I could tell
SH> you which, if any, reverse breakout cables you need.  If the
SH> backplane(s) have 8 cable connectors you're golden.  If they have
SH> 2xSFF8087 connections then you'll need two reverse breakout cables.

this second-hand server was originally equipped with an U320 scsi
backplane which I removed. by this the hotswap capability is lost,
the drives will be directly connected to the AOC-SAT2-MV8 controller,
I can live with that. nonetheless it would be nice to have a SATA
backplane, but by googling I couldn't find one that fits into this
chassis (blue/white AVANTEK).

tnx.

--
rainer


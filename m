From: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Re[2]: Promise SATA TX4 300 + 3TB disks?
Date: Fri, 5 Oct 2012 15:33:21 +0200
Message-ID: <719665592.20121005153321@oudeis.org>
References: <818058745.20121005012826@oudeis.org>
 <20121005123653.0a5398e0@natsu> <506E9E77.1080002@hardwarefreak.com>
 <20121005145011.673f4974@natsu>
Reply-To: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121005145011.673f4974@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

roman, stan,

thanks for your input. I should have added some more information:

the mainboard is an intel D510MO which has "only" one PCI slot and 2
SATA ports. one port runs a 60GB SSD (system), the 2nd one a 3TB WD
drive for temporary data.
http://www.intel.com/content/www/us/en/motherboards/desktop-motherboards/desktop-board-di510mo.html

the 4x 1.5TB drives are connected to the promise TX4 300 in the only
PCI slot.

lspci:
00:1f.2 SATA controller: Intel Corporation N10/ICH7 Family SATA Controller [AHCI mode] (rev 01)
according to the kernel wiki PMP is not supported by the ICH7 chipset.

the 2nd application is an old avantek server with a tyan S2882-D
mainboard and 8 drive bays which I want to fill with old drives for
backup purposes. the 4port onboard SATA controller doesn't even
recognize 750GB drives (hangs at startup).
http://www.tyan.com/archive/products/html/thunderk8sdpro.html

performance is not an issue in both cases. both are more or less just
for storage, no time critical applications.

--
rainer

------------------------------------------------------------------------------
Unix gives you just enough rope to hang yourself -- and then a couple of more 
feet, just to be sure.
(Eric Allman)
------------------------------------------------------------------------------


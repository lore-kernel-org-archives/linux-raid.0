From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Promise SATA TX4 300 + 3TB disks?
Date: Thu, 04 Oct 2012 21:26:39 -0500
Message-ID: <506E455F.5000503@hardwarefreak.com>
References: <818058745.20121005012826@oudeis.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <818058745.20121005012826@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/4/2012 6:28 PM, Rainer F=FCgenstein wrote:

> I'd like to replace the 4x 1.5TB WD drives in my atom-based NAS-like
> server with 4x 3TB ones - the SATA controller is a Promise TX4 300.
> will this controller be able to handle 3TB disks? (not eager to find
> out the hard way).

The drive compat list on their site is dated 2005.  The largest drive
listed is less than 1TB.  The firmware for d/l is the initial
firmware--no updates.  Educated guess says the card won't support 3TB
drives.  Contact Promise support to verify.

> If not, which (inexpensive) PCI SATA controllers would you recommend?

I wouldn't.  If your mobo SATA chip supports PMP get a 5x1 PMP.  Check
the kernel.org SATA chip list for PMP capability:
https://ata.wiki.kernel.org/index.php/SATA_hardware_features

http://www.addonics.com/products/ad5sapm.php
1 host port, 5 drive ports, 3Gb/s SATAII

$62 from the manufacturer, probably found a little cheaper if you look
around.

If your mobo SATA chip is SATAII/III you'll get up to 600MB/s duplex
throughput via this PMP to the drives.  PCI-32/33 is limited to 132MB/s=
,
~4 times less throughput.

No additional drivers are required for the PMP.  You only need those fo=
r
the mobo SATA chip/port to which the PMP is connected.

Note:  if you plan to boot from this 4x3TB array then PMP is not for
you.  HBAs will apparently only boot from the device connected to drive
port #1 on the PMP.  Thus if that drive fails you may not be able to
boot from another drive in the array without manually swapping
connectors.  Swapping cables may affect device naming/ordering, possibl=
y
causing problems with array assembly.

If you use wisely use a separate boot disk/SSD on another mobo SATA por=
t
then this isn't an issue.

If your mobo SATA chip doesn't support PMP, let me know and I'll dig up
an appropriate inexpensive 4 port PCI SATA HBA for you.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

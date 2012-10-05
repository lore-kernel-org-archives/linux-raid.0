From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Promise SATA TX4 300 + 3TB disks?
Date: Fri, 05 Oct 2012 03:46:47 -0500
Message-ID: <506E9E77.1080002@hardwarefreak.com>
References: <818058745.20121005012826@oudeis.org> <20121005123653.0a5398e0@natsu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121005123653.0a5398e0@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>, Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/5/2012 1:36 AM, Roman Mamedov wrote:

> I would not recommend a PMP, with it your 5 disks will be limited to one SATA
> port's bandwidth, which will not give you good performance.

Roman is simply wrong here.  The PMP will give far better performance in
the OP's case than a 4 port PCI 32/33 HBA.

With 4 disks the SiI 3826 PMP will provide 2.27x-4.5x better throughput
per drive than a 4 port PCI 32/33 card.

FYI:

PCI bus, 32 bit, 33MHz		132MB/s total bandwidth
SATAII singe channel		600MB/s duplex, 300MB/s unidirectional

4 port PCI 32/33 card 		 33MB/s per drive maximum
PMP using 4 drive ports		150MB/s per drive maximum
				 75MB/s per drive unidirectional

You failed to take the system bus connection of the SATA chip into
account.  A single SATAII channel is 2.27x faster than the PCI bus.
Southbridge integrated SATA controllers typically have upstream
bandwidth of 2GB-8GB/s depending on the chipset.  Motherboard mounted
discrete secondary SATA controllers that provide 2-4 additional internal
or eSATA ports connect upstream via a PCIe x1 1.0/2.0 interface, good
for 250 or 500MB/s unidirectional, 500MB/s or 1GB/s duplex, ~2-8 times
faster than PCI 32/33.

This is why nobody uses PCI HBAs, unless they have no other option.  A
single 3TB rust drive can stream at ~150MB/s, slightly faster than the
PCI bus can accept the data.  Recent SSDs can push 500MB/s, 4x faster
than the PCI bus.

This is precisely why I recommended the PMP solution over a 4 port PCI
32/33 HBA.

-- 
Stan


From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: Consensus on controllers?
Date: Wed, 22 Oct 2003 10:11:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310221011.18327.dusty@strike.wu-wien.ac.at>
References: <1066782075.31741.6.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1066782075.31741.6.camel@south.rosestar.lan>
Content-Disposition: inline
To: Bob Hillegas <bobhillegas@houston.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 22 October 2003 02:21, Bob Hillegas wrote:
> Assuming I'm installing a software raid, is there any consensus on which
> controller is best suited to that duty?
>
> Best scsi and best IDE.

What you first have to take in mind is that the PCI bus can be a bottleneck. 
The 32bit/33Mhz PCI bus can manage 133MB/s (without overhead). If you e.g. 
connect two fast IDE-Harddisks, like the WD-Raptor (which has max. ~ 60MB/s 
read performance) and do a RAID0, then  you would theoretically achieve 
120MB/s - if you pipe this out to a 100MBit NW, you get around 130MB/s. I'd 
say this is already too much for the PCI bus as there is around 30% overhead 
included. 
There are two workarounds to this problem:

- Use 64-bit PCI Hardware (expensive)
- Use onboard Controller that are directly connected to the Southbridge - but 
notice: Not all onboard controllers are directly connected, many are simply 
connected to the 32-bit/33Mhz PCI bus.

Moreover the controllers vary with the CPU Load. I only know that e.g. the 
SATA RAID controller from Silcon Image (sil3112A) has a low CPU load but 
AFAIK the sil3112 is a simple PCI device.

An example of an IDE-Onboard controller that is connected to the Southbridge 
is the Intel ICH5(R) southbridge that is implemented in the 875/865 intel 
chipsets.

Moreover you have to find out if these IC's are properly supported with Linux.

Sorry - with SCSI I have not much knowledge.

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7


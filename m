From: Jeff Garzik <jeff@garzik.org>
Subject: Re: What do these SATA errors mean / kernel 2.6.25.6 (DRDY ERR/ICRC
 ABRT)
Date: Wed, 11 Jun 2008 22:50:31 -0400
Message-ID: <48508EF7.9070309@garzik.org>
References: <alpine.DEB.1.10.0806110608080.7726@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755414AbYFLCuq@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0806110608080.7726@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Never had a single error so far, powered down my host, powered it back up,
> and now with kernel 2.6.25.6:

http://ata.wiki.kernel.org/index.php/Libata_error_messages

In particular, timeouts may be solved by acpi=off or 'noapic' or
pci=nomsi or pci=biosirq.


> Does/the kernel handle the ATA v8 protocol properly?
> ATA Version is:   8

Yes.  ATA is always back-compatible.

	Jeff

From: Andrew Walrond <andrew@walrond.org>
Subject: Re: Software RAID5, promise IDE and system freeze...
Date: Mon, 30 Aug 2004 10:49:20 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408301049.20960.andrew@walrond.org>
References: <4132E76F.7090209@cg.cs.tu-bs.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4132E76F.7090209@cg.cs.tu-bs.de>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 30 Aug 2004 09:38, Lars Schimmer wrote:
> System used: Debian sarge, fresh install from friday, raidtools2 and
> kerne 2.4.27
>
> Does ANYONE have any hints?

I had a very similar problem, solved by disabling ACPI. It was interrupt 
routing related.

So, is ACPI compiled into your kernel?
If so, try booting with acpi=nopci or acpi=off
(I think thats correct; check in Documentation/kernel-parameters.txt)

(Most ACPI problems are due to old/buggy bios. If you enable ACPI, always 
flash latest bios from your mobo's website.)

Or it might be something completely different :)

Andrew Walrond

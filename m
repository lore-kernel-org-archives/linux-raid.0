From: Drew <drew.kay@gmail.com>
Subject: Re: HW Raid Question
Date: Thu, 1 Oct 2009 09:31:47 -0700
Message-ID: <c268e4660910010931m5ab356f4j8c0144892d8dd57b@mail.gmail.com>
References: <c268e4660909272103r3831e129m68c11899b11be222@mail.gmail.com>
	<70ed7c3e0909272339j2beb3de1rf3a925d207be1d8c@mail.gmail.com>
	<c268e4660909280807q1bfb805eu4ec7804901ea1fb6@mail.gmail.com>
	<240e377b0909290815q67cb2388w788be78adc84b1fe@mail.gmail.com>
	<c268e4660909290844h6a1c8640yd110b75a9f85d89b@mail.gmail.com>
	<240e377b0910010013jfc2e891r6a461d555f95c79e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <240e377b0910010013jfc2e891r6a461d555f95c79e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikhail Yakshin <greycat@altlinux.org>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Can you post results of lspci -vv for these controllers, please?

I'd love to except that they're both running windows right now, and
are Domain Controllers so can't be brought down to check.

The closest info I can give you from Windows is the following:

PCI\VEN_9005&DEV_0250&SUBSYS_02791014&REV_02
PCI\VEN_9005&DEV_0250&SUBSYS_02791014
PCI\VEN_9005&DEV_0250&CC_010400
PCI\VEN_9005&DEV_0250&CC_0104

I do know for sure they are rebranded Adaptec units as both the 7k &
6M controllers have Adaptec branded batteries attached to them and in
the case of the 6M have the Adaptec logo silkscreened on the card.
Both the 6M & 7k controllers, show the same vendor & device id's. From
tracing this back to the pci id database these are IBM rebranded
adaptec controllers. Linux uses the ips driver to handle these.

I was testing the machine w/ 6M back in July with CentOS but I didn't
see anything in the RAID bios that indicated it could. I also wasn't
really using the HW RAID (except for the boot drive) during testing as
I prefer to use mdadm where possible over HW RAID.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

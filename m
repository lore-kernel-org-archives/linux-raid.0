From: Andrew Walrond <andrew@walrond.org>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Fri, 4 Feb 2005 09:04:38 +0000
Message-ID: <200502040904.38264.andrew@walrond.org>
References: <200502031743.j13Hha910546@www.watkins-home.com> <42026860.1000409@zytor.com> <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Gordon,

On Thursday 03 February 2005 19:36, Gordon Henderson wrote:
>
> However, I then got production hardware - Tyan Thunder K8W twin Opteron
> board, 4-port SATA on-oboard, 2x2-port SATA in PCI slots (all SII chipset)
> and it all went pear-shaped from there. The system locks solid whenever I
> try to use the disks off the PCI SATA controllers doing anything much more
> than run fdisk on them.  (It just stops, no oops, cursor stops flashing on
> the display, it needs a hard-reset to get it going again) I've tried PCI
> slot positions, fiddling with mobo jumpers, BIOS options, and so on.  I
> can make it work for varying degrees of "work", however blood is currently
> flowing over the edge and gathering in a pool at my feet. Even getting it
> to boot off the SATA drives was a challenge in itself (which still isn't
> solved to my satisfaction)
>
> Anyone using Tyan Thunder K8W motherboards???
>

I'm using K8W's here with a combo od raid0/1 on on-board SATA, and its been 
rock solid for months (2.6.10). Looks like your problems are all with the PCI 
cards, but I can't help there. Since you are using vanilla 2.6.10, Jeff 
Garzik (SATA maintainer) should be interested/helpful on LKML if you want to 
pursue this.

What was the booting problem? I have no problems  here in that regard.

> I now know, there is a K8S (server?) version of that mobo, but at the time
> it was all orderd, I wasn't aware of it - my thoughts are there there is
> some sort of PCI/PCI-X problem with either the motherboard or the chipset,
> and in all probability the K8S mobo will have the same chipsset and same
> problems anyway...

Right; very similar, no AGP but additional on-board scsi.

>
> Right now, (to test the PCI SATA cards in PCI-X slots), I have 4 x
> dual-port SATA cards in a Dell PCI-X mobo connected to the 8 drives in
> their box via 900mm SATA cables, and it's all running quite nicely.  Read
> performance on a RAID-0 array was 230MB/sec, write 300MB/sec (!?!), it
> falls to 110MB/sec write and 140MB/sec read for RAID-6...) (Processor here
> is a single Xeon 2.4GHz)

I wonder if it's the onboard/pci combination that causes the problem on K8W...

BTW There is a new K8W just out; pci express replaces agp and I think it 
supports dual core opterons (when they appear) so check it out before you 
place any big orders for the old one :)

Andrew Walrond

From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: getting a linux boot loader (preferably grub) installed on an
 intel imsm raid
Date: Thu, 19 Aug 2010 15:44:57 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D504669C5AB2@azsmsx504.amr.corp.intel.com>
References: <4C6CB965.7000905@gmail.com>
 <D010E79907AF0D4E90B603DE907837D504666ADB3D@azsmsx504.amr.corp.intel.com>
 <4C6D78BF.1060603@gmail.com>
 <D010E79907AF0D4E90B603DE907837D504666ADCD3@azsmsx504.amr.corp.intel.com>
 <4C6DB04A.4060702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6DB04A.4060702@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "K. Posern" <quickhelp@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: K. Posern [mailto:quickhelp@gmail.com]
> Sent: Thursday, August 19, 2010 3:30 PM
> To: Jiang, Dave
> Cc: linux-raid@vger.kernel.org
> Subject: Re: getting a linux boot loader (preferably grub) installed on
> an intel imsm raid
>          *** For grub2: The default way to install it: grub-install
> /dev/md126 (= imsm volume) just returns 3 error messages.
>       Even though the bzr version of grub2 does support mdadm.imsm
> raids
> with metada version >=1.2, it does /not/ support mdadm raids which are
> partitioned.
> So I would need to put /dev/md126 into device.map (as the OROM of the
> intel fakeraid will assemble the raid-0 for grub to access it as a
> normal drive) and I need to install grub2 on the RAID-0 Volume
> /dev/md126! ... But how?
>      As I am quiet new to grub2 it would be very helpful to get an idea
> of what of the (many) tools to use and if possible with what
> parameters.
>      Plus I wonder if with grub2 there will be problems because grub2
> will try to assemble the RAID itsself.
> 
>          *** For grub: I did quite some installations but all my trials
> to install grub to /dev/md126 (= imsm Volume) did always end in an
> Error
> 22 on "setup (hd0)" in the grub shell. <<< If grub would be your
> recommendation I can post the details!

I will have to create a setup and see how that works with grub. I guess the better question would also be how do distros like SUSE or Fedora/RHEL perform this as they use grub as well....

> 
> > Also technically the imsm RAID is not fakeraid because it uses MDRAID
> instead of special driver to "fake" RAID in Linux. It's just Linux
> software RAID with OROM support.
> I am not sure about the /official/ definition of the term "fakeraid". I
> would have said that because you can create/delete the RAID within the
> OROM (so without any Operating System (e.g. Software-RAID Program
> involved) --> "Fakeraid".
> 
> Actually: Is there any hardware support within the:
>    00:1f.2 RAID bus controller: Intel Corporation Mobile 82801 SATA
> RAID
> Controller (rev. 05)
> Like an xor chip that is used to outsource some of the work under
> windows, but not under linux (because as you stated: as under linux
> there is no special driver, but linux uses mdadm to access to access
> the
> container and the volume)?
> If yes, are there any plans to develop a driver to outsource the xors
> to
> the RAID chip for Linux?

Yes. But you will need the Xeon class CPUs (C55xx and C35xx I think?) that has the IOAT DMA (CBDMA) engines to do this. If you have the IOAT DMA engines that has XOR caps, Linux can use the DMA engine to do XOR or PQ offloading. See drivers/dma/ioat/

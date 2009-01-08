From: "adam radford" <aradford@gmail.com>
Subject: Re: [Benchmarks] How do I set the memory invalidate bit for a 3ware 9550SXU-12 controller?
Date: Thu, 8 Jan 2009 14:52:28 -0800
Message-ID: <b1bc6a000901081452j3cce22dfy82a160cbcab0c5ed@mail.gmail.com>
References: <alpine.DEB.1.10.0901080846430.29454@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901080846430.29454@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide-arrays@lists.math.uh.edu
List-Id: linux-raid.ids

On Thu, Jan 8, 2009 at 6:20 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> System = RHEL5 x86_64
> Kernel = 2.6.18-53.1.13.el5

> Invalidate' (lspci now shows that the 3Ware controller 9550 is in 'MemWINV+'
> instead of 'MemWINV-' mode), maybe enhancing write throughput. The 9650 is
> in 'MemWINV-' mode. This seems somewhat frequent with SuperMicro mainboards,

The 3ware 9650SE is PCIe based, and memory-write-invalidate
does not apply.  See the following link from "PCI Express System
Architecture":

http://books.google.com/books?id=sBtKutWpVh8C&pg=PA787&lpg=PA787&dq=PCIe+memory+write+invalidate&source=web&ots=fZE68z97DP&sig=qWnb8nTRBrQL2g8DwZwLpiFWE4c

> How do I change MemWINV+ to MemWINV- using setpci?
>

Why would you want to turn this bit off?

> Does anyone know how to set it via setpci?

You mean unset it (as per your above request)?

You shouldn't use 'setpci' to just artibrarily set and unset the
memwinv bit.  For this bit to work correctly, the PCI device
must have its cache line size set correctly.  The kernel call
pci_try_set_mwi() does this by calling pci_set_cachline_size().   The
3ware driver in kernels 2.6.25 and higher makes this call to attempt
to turn on MWI support for motherboards that to not automatically have
it enabled.

You should not be trying to turn this bit off as it most likely will not help
your performance by doing so.

-Adam

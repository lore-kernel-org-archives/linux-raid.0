From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sata badness in 2.6.20-rc1? [Was: Re: md patches in -mm]
Date: Sat, 16 Dec 2006 00:38:02 +0100
Message-ID: <200612160038.03149.rjw@sisk.pl>
References: <20061204203410.6152efec.akpm@osdl.org> <200612152322.26375.rjw@sisk.pl> <45832095.9000503@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45832095.9000503@garzik.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@osdl.org>, Neil Brown <neilb@suse.de>, Jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>
List-Id: linux-raid.ids

On Friday, 15 December 2006 23:24, Jeff Garzik wrote:
> Rafael J. Wysocki wrote:
> > On Friday, 15 December 2006 22:39, Andrew Morton wrote:
> >> On Fri, 15 Dec 2006 13:05:52 -0800
> >> Andrew Morton <akpm@osdl.org> wrote:
> >>
> >>> Jeff, I shall send all the sata patches which I have at you one single time
> >>> and I shall then drop the lot.  So please don't flub them.
> >>>
> >>> I'll then do a rc1-mm2 without them.
> >> hm, this is looking like a lot of work for not much gain.  Rafael, are
> >> you able to do a quick chop and tell us whether these:
> >>
> >> pci-move-pci_vdevice-from-libata-to-core.patch
> >> pata_cs5530-suspend-resume-support-tweak.patch
> >> ata-fix-platform_device_register_simple-error-check.patch
> >> initializer-entry-defined-twice-in-pata_rz1000.patch
> >> pata_via-suspend-resume-support-fix.patch
> >> sata_nv-add-suspend-resume-support.patch
> >> libata-simulate-report-luns-for-atapi-devices.patch
> >> user-of-the-jiffies-rounding-patch-ata-subsystem.patch
> >> libata-fix-oops-with-sparsemem.patch
> >> sata_nv-fix-kfree-ordering-in-remove.patch
> >> libata-dont-initialize-sg-in-ata_exec_internal-if-dma_none-take-2.patch
> >> pci-quirks-fix-the-festering-mess-that-claims-to-handle-ide-quirks-ide-fix.patch
> >>
> >> are innocent?
> > 
> > Yes, they are.
> 
> We all really appreciate your patience :)  This is good feedback.
> 
> To narrow down some more, does applying 2.6.20-rc1 + the attached patch 
> work?  (ignoring -mm tree altogether)

Yes, it does.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

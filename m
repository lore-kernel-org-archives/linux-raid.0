From: P Orrifolius <porrifolius@gmail.com>
Subject: LSI 9211 (SAS2008) BIOS problems, invalid PCI slot
Date: Mon, 16 Sep 2013 12:07:21 +1200
Message-ID: <CAC38o7Q4R_qXdtfBv86cNkEq6bp-6GrtqYat2m=WW47Tc5D6aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I have an LSI 9211-8i controller which is running the IR firmware.  My
intention is to flash it with the IT firmware and use it for an md
RAID array.

However I don't think it is playing nicely with my motherboard BIOS.


On first installing it, with no drives attached, the LSI BIOS runs and
then the motherboard BIOS goes through an AHCI drive detection phase.
After detecting the drives (2xHD 1xOptical, connected to SATA ports on
MB) the boot hung and required a hard reset.

The LSI MPT2BIOS version is 7.29.0.0 and the controller firmware is 15.0.0.0-IR.
The motherboard is a Gigabyte GA-MA78G-DS3H (revision 1) running the F3 BIOS.

I can enter the LSI configuration utility during the controller boot
process and I see that it has a PCI slot of 'ff' which, according to
the utility, indicates an invalid PCI slot.


I've updated to the latest motherboard BIOS (F9) and now the boot
process follows the same sequence but continues after the AHCI
detection and eventually brings up linux.  However the controller
still reports a PCI slot of 'ff'.

I can see it in linux but if I have a drive connected I don't see it
in the boot configuration utility (not sure if I should) and I don't
see it as a /dev/sd? device (not sure if this is where I should find
it).  So I suspect it's not really working.

Here is the output from lspci -v:

02:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic
SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
        Subsystem: LSI Logic / Symbios Logic Device 3020
        Flags: bus master, fast devsel, latency 0, IRQ 18
        I/O ports at de00 [size=256]
        Memory at fdcfc000 (64-bit, non-prefetchable) [size=16K]
        Memory at fdc80000 (64-bit, non-prefetchable) [size=256K]
        [virtual] Expansion ROM at fdb00000 [disabled] [size=512K]
        Capabilities: [50] Power Management version 3
        Capabilities: [68] Express Endpoint, MSI 00
        Capabilities: [d0] Vital Product Data
        Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [c0] MSI-X: Enable+ Count=15 Masked-
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [138] Power Budgeting <?>
        Capabilities: [150] Single Root I/O Virtualization (SR-IOV)
        Capabilities: [190] Alternative Routing-ID Interpretation (ARI)
        Kernel driver in use: mpt2sas
        Kernel modules: mpt2sas


Anybody run into this or have any advice?  Is this really a problem?

I'm reluctant to risk bricking it during a firmware flash if it truly
is misbehaving.


Thanks.

From: "Mikhail Yakshin" <greycat.na.kor@gmail.com>
Subject: [ANNOUNCE] Einarc - universal RAID management/monitoring tool - v1.3
Date: Tue, 16 Dec 2008 04:07:13 +0300
Message-ID: <240e377b0812151707g4c90cd20jc404f86aaabe69a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

After a half-year development cycle, I'd like to introduce a release
of Einarc v1.3.

Einarc is a universal storage RAID command line interface and an API
that provides management for various hardware/software RAID devices,
uniting them all in a single paradigm. Einarc works as a translator
that makes it possible for a user to control all these devices using
simple terms like "physical disc", "logical disc", "adapter", etc.,
while transparently converting these requests to proprietary RAID
paradigms.

It's mostly useful for hardware RAIDs, so practicing system
administrators may skip downloading and dealing with proprietary CLIs
themselves and use unified Einarc's interface. It can be also useful
for simplified software RAID management (as a wrapper for mdadm).

Version 1.3 new features are:

    * Support for 3ware / AMCC controllers by Andras Horvath.
    * Full read/write support of Linux software RAIDs.
    * Updated all proprietary utilities URLs, pumped up version
numbers, fixed wrapper regular expressions to support new versions of
CLIs.
    * Added new calculated fields in adapter_info: PCI
product/subproduct and vendor/subvendor IDs. These allow precise
identification of PCI devices related to adapters shown by Einarc.
    * Fuller BBU support for Adaptec adapters.
    * Multiple stability and build fixes (Makefile now supports
parallel execution with "make -j").

As for version 1.3, Einarc supports the following RAIDs management modules:

    * adaptec_aaccli - supports older Adaptec SCSI RAID controllers.ntrollers.
    * amcc - supports all AMCC/3ware controllers.
    * areca - supports all Areca SATA RAID controllers.
    * lsi_megacli - supports newer LSI MegaRAID SAS/SATA RAID
controllers, as well as rebranded copies of these controllers from
Dell, HP and Intel, as well as all on-board or daughterboard products
based on LSI SAS 1078 chipset.
    * lsi_megarc - support older LSI MegaRAID SCSI/SATA RAID
controllers, as well as rebranded copies of these controllers from
Dell, HP and Intel, as well as all on-board or daughterboard products
based on LSI MegaRAID 160/320 or 150/300 chipset.
    * lsi_mpt - Fusion/MPT, now branded as LSI MPT design of HBAs.
    * software - Linux software RAID device (md).

Einarc can be downloaded at http://www.inquisitor.ru/doc/einarc, being
a part of Inquisitor Linux stress testing and benchmarking platform,
where it's extensively used to test disc arrays.

As always, I would be very glad to hear any comments on these release,
bug reports, feature requests, etc.

-- 
WBR, Mikhail Yakshin

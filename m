From: Mikhail Yakshin <greycat.na.kor@gmail.com>
Subject: ANNOUNCE: Einarc 2.0 - hardware RAID management frontend CLI/API
Date: Thu, 17 Oct 2013 14:36:32 +0400
Message-ID: <CANp_HXc0YY1CpNmcxafJyS0sPoYOBETHzh1gseiL9nyX+NyQEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

After almost 3 years without releases, I'm finally pleased to announce
new major version of Einarc - 2.0.

Einarc is a unified frontend to manage all the storage/RAID devices
attached to a Linux system, including proprietary ones. Einarc works
as a universal translator to/from proprietary CLIs and software
implementations, such as mdadm, uniting them all in single paradigm.

* New features:

** Dedicated hotspare support ("hotspare add", "hotspare delete" methods)
** Getting physical disc SMART attributes in unified form ("physical smart")
** Adapter restart method to reset an adapter, stop all arrays and
reinitialize them ("adapter restart")
** Listing logical discs now also shows their /dev entries, if possible
** Getting WWN and enclosure ID for physical drives (attributes "wwn"
and "enclosure" for "physical" object, software only)
** Getting adapter's expanders ID and model (method "expanders" for
"adapter" object)
** Log dumping support ("log dump", for lsi_megacli only)
** Enabling/disabling WriteCache support for logical and physical
discs ("writecache" attribute for "physical" and "logical" object,
software only)
** Disabling powersaving support for logical and physical discs
("powersaving" attribute for "physical" and "logical" object, software
only)
** BBU support (arcconf)

* Support for new adapters / chipsets, improved RAID autodetection:

** Adaptec 2405, Adaptec 51645, Adaptec 5405Z, Adaptec 5445Z, Adaptec
5805Z, Adaptec 6405, Adaptec 6805, Adaptec 6805Q
** Intel RS2BL040, Intel RS2BL080, Intel RS2WC040
** LSI 53C896/897-based, LSI MegaRAID SAS 9240-4i, LSI MegaRAID SAS
9260, LSI SRCSASLS4I
** SuperMicro SMC2108

* User friendliness:

** command line interface now hints what objects are available
** most objects and methods can be abbreviated akin to UNIX commands
(i.e. "physical list" => "pd ls", "logical hotspare delete" => "ld hs
rm", etc)
** adapter type and number specification can be omitted if there's
only one adapter in the system
** more user-friendly error messages
** output is "humanized" by default if we use real tty for output
** added man pages: einarc(8), einarc-install(8),
raid-wizard-clear(8), raid-wizard-passthrough(8),
raid-wizard-optimal(8)
** prevent lsi_megacli from littering its log files around by default

* Bumped versions of proprietary CLI utilities:

** Areca 1.9.0_120503
** LSI MegaRC 1.11
** LSI MegaCLI 8.07.07
** 3Ware 9.5.0.1
** ArcConf 1.1.20324

* Compatibility issues:

** Ruby 1.9 compatibility, 1.8 should be still supported
** dash compatibility, bash is no longer required
** Workarounds for proprietary CLI calls that require Linux kernel
2.6.x explicitly to work on kernel 3.x
** Support for more than 26 logical discs (i.e. names like "sdaa"
beyond "sda"-"sdz")
** Dropped HAL support: querying now uses udev, procfs and sysfs
** Explicitly disallowed software-RAID-on-top-of-hardware-RAID, added
switch to disallow software-RAID-on-USB-mass-storage

* Infrastructure and API changes:

** Added testing framework using mock-up adapters CLI output, added
tests for lsi_megacli and lsi_megarc
** All output is done to `@outstream` by default (which can be
overridden), not `$stdout`
** Subversion -> Git transition, Git maintenance support

* Multiple bugfixes and minor improvements

As usual, Einarc is available from it's homepage or from github:

http://www.inquisitor.ru/doc/einarc/
http://github.com/inq-team/einarc/

Download link:
https://github.com/inq-team/einarc/releases/tag/v2.0

-- 
WBR, Mikhail Yakshin

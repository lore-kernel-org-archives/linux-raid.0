From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: *** Announcement: dmraid 1.0.0-rc3 ***
Date: Wed, 18 Aug 2004 21:06:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040818190610.GA6275@redhat.com>
Reply-To: mauelshagen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


               *** Announcement: dmraid 1.0.0-rc3 ***

dmraid 1.0.0-rc3 is available at
http://people.redhat.com:/~heinzm/sw/dmraid/ in source, source rpm and i386 rpm.

dmraid (Device-Mapper Raid tool) discovers, [de]activates and displays
properties of software RAID sets (ie. ATARAID) and contained DOS
partitions using the device-mapper runtime of the 2.6 kernel.

The following ATARAID types are supported on Linux 2.6:

Highpoint HPT37X
Highpoint HPT45X
Intel Software RAID
Promise FastTrack
Silicon Image Medley

This ATARAID type is only basically supported in this version (I need
better metadata format specs; please help):
LSI Logic MegaRAID

Please provide insight to support those metadata formats completely.

Thanks.

See files README and CHANGELOG, which come with the source tarball for
prerequisites to run this software, further instructions on installing
and using dmraid!

CHANGELOG is contained below for your convenience as well.


Call for testers:
-----------------

I need testers with the above ATARAID types, to check that the mapping
created by this tool is correct (see options "-t -ay") and access to the ATARAID
data is proper.

You can activate your ATARAID sets without danger of overwriting
your metadata, because dmraid accesses it read-only unless you use
option -E with -r in order to erase ATARAID metadata (see 'man dmraid')!

This is a release candidate version so you want to have backups of your valuable
data *and* you want to test accessing your data read-only first in order to
make sure that the mapping is correct before you go for read-write access.


The author is reachable at <Mauelshagen@RedHat.com>.

For test results, mapping information, discussions, questions, patches,
enhancement requests and the like, please subscribe and mail
to <ataraid@redhat.com>.

--

Regards,
Heinz    -- The LVM Guy --


CHANGELOG:
---------

Changelog from dmraid 1.0.0-rc2 to 1.0.0-rc3		2004.08.18

FIXES:
------
o HPT37X mapping on first disk of set
o dietlibc sscanf() use prevented activation
o le*_to_cpu() for certain glibc environments (Luca Berra)
o sysfs discovery (Luca Berra)
o permissions to write on binary, which is needed
  by newer strip versions (Luca Berra)
o SCSI serial number string length bug
o valgrinded memory leaks
o updated design document
o comments

FEATURES:
---------
o added basic support for activation of LSI Logic MegaRAID/MegaIDE;
  more reengineering of the metadata needed!
o root check using certain options (eg, activation of RAID sets)
o implemented locking abstraction
o implemented writing device metadata offsets with "-r[D/E]"
  for ease of manual restore
o file based locking to avoid parallel tool runs competing
  with each other for the same resources
o streamlined library context
o implemented access functions for library context
o streamlined RAID set consistency checks
o implemented log function and removed macros to shrink binary size further
o removed superfluous disk geometry code
o cleaned up metadata.c collapsing free_*() functions
o slimmed down minimal binary (configure option DMRAID_MINI
  for early boot environment)

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
                                                  56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

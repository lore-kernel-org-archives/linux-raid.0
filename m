From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: *** Announcement: dmraid 1.0.0-rc4 ***
Date: Tue, 7 Sep 2004 16:15:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040907141531.GA13867@redhat.com>
Reply-To: mauelshagen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


               *** Announcement: dmraid 1.0.0-rc4 ***

dmraid 1.0.0-rc4 is available at
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

In case you have a different ATARAID solution from those listed above,
please feel free to contact me about supporting it in dmraid.

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


Changelog from dmraid 1.0.0-rc3 to 1.0.0-rc4		2004.09.07

FIXES:
------
o get_dm_serial fix for trailing blanks
o infinite loop bug in makefile
o unified RAID #defines
o RAID disk erase size
o avoided unnecessary read in isw_read()
o segfault in build_set() on RAID set group failure
o activation of partitions on Intel Software RAID
o allow display if tables for active RAID sets (-t -ay)
o discovering no RAID disks shouldn't return an error
o free_set would have segfaulted on virgin RAID set structures
o deep DOS partition chains (Paul Moore)
o "dmraid -sa" displayed group RAID set with Intel Software RAID
  when it shouldn't
o return RAID super set pointer from hpt45x_group() and sil_group()
  rether than sub set pointer


FEATURES:
---------

o added offset output to all native metadata logs
o started defining metadata format handler event method needed for
  write updates to native metadata (eg, for mirror failure)
o [de]activation of a single raid sets below a group one (isw)
o support for multiple -c options (see "man dmraid"):
  "dmraid -b -c{0,2}"
  "dmraid -r -c{0,2}"
  "dmraid -s -c{0,3}"

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
                                                  56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

From: "Gordon Mohr (@ Bitzi)" <gojomo@bitzi.com>
Subject: madadm man page ambiguities: '--size' units, superblock affordance
Date: Sat, 01 Oct 2005 14:21:20 -0700
Message-ID: <433EFDD0.3010307@bitzi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My 'mdadm' (v1.6.0) man page includes:

#       -z, --size=
#              Amount  (in  Kibibytes)  of  space  to  use  from each drive in
#              RAID1/4/5/6.  This must be a multiple of the  chunk  size,  and
#              must leave about 128Kb of space at the end of the drive for the
#              RAID superblock.  If this is not specified (as it  normally  is
#              not) the smallest drive (or partition) sets the size, though if
#              there is a variance among the drives  of  greater  than  1%,  a
#              warning is issued.

There are several problems when trying to interpret the phrase "This must be a
multiple of the chunk  size,  and must leave about 128Kb of space at the end of
the drive for the RAID superblock."

(1) Someone resizing an array may not know the chunk size, and it's unclear
if assuming the default of 64 is OK, or dangerous. (My experiments show that
'mdadm' will accept a size value that is not a multiple of 64, and will update
the array size as shown by --detail to this non-multiple size, at least for
RAID1. Does this risk disaster?)

(2) "Kb" is technically the abbrieviation of "kilobits", not "kibibytes". I'm
assuming "128Kb" means "128 kibibytes" from the preceding context. I suggest
avoiding the abbrieviation entirely to avoid confusion.

(3) To "leave" space is ambiguous in what it means for the value specified.
Should the we take the amount of space needed for our filesystem and add 128K
to get the 'size' value to specify? Or specify exactly what's needed for
the filesystem, and be aware that RAID will actually use 128K more on
the consitutent devices than what was specified? (I *think* the second is
meant, but I'm not sure.)

(4) The imprecise "about 128Kb" raises the question: is more than 128K
sometimes needed? If I "leave" exactly 128K, is that a recipe for eventual
disaster when someday the superblock goes over this allotment?

Any clarifications appreciated. Thanks!

- Gordon @ Bitzi

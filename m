From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: [RFC] dmraid design 1.0.3
Date: Fri, 28 May 2004 17:28:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040528152810.GM16912@redhat.com>
Reply-To: mauelshagen@redhat.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="kvUQC+jR9YzypDnK"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: heinzm@redhat.com
List-Id: linux-raid.ids


--kvUQC+jR9YzypDnK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Attached is an RFC on the design of my dmraid tool/lib which read-only
supports (discover, activate, deactivate, display properties, ...)
various RAID devices (eg, ATARAID) in Linux 2.6 using the generic
device-mapper runtime.

Read-write support of such devices is subject to future extensions.

FYI: Implementation takes advantage of Søren Schmidt's work in freebsd
     and Carl-Daniel Hailfinger's on raiddetect; thanks guys :)

Any helpful comments appreciated. (please cc me, i'm not subscribed)

Code to comment on will follow ASAP.

Regards,
Heinz   -- The LVM Guy --

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
                                                  56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

--kvUQC+jR9YzypDnK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmraid_design-1.0.3.txt"


dmraid tool design document v1.0.3		Heinz Mauelshagen 2004.05.26
----------------------------------------------------------------------------

The dmraid tool supports RAID devices (RD) such as ATARAID with
device-mapper (dm) in Linux 2.6 avoiding the need to install a
vendor specific (binary) driver to access them.

It supports multiple on-disk RAID metadata formats and is open for
extension with new ones.

First drop aims to support RDs read-only and doesn't support
*updates* of the ondisk metadata (eg, to record disk failures).
See future enhancements at the end.


Functional requirements:
------------------------

1. dmraid must be able to read multiple vendor specific ondisk
   RAID metadata formats:

   o ATARAID
     - Highpoint 37x/45x
     - LSI Logic MegaRaid
     - Silicon Image
     - Promise FastTrak

2. dmraid shall be open to future extensions by other ondisk RAID formats:
   o Intel ICHraid (ATARAID solution on mainboard)
   o SNIA DDF
     http://www.snia.org/tech_activities/ddftwg/DDFTrial-UseDraft_0_45.pdf

3. dmraid shall generate the necessary dm table(s) defining
   the needed mappings to address the particular data.

4. Device discovery, activation, deactivation and property display
   shall be supported.

5. Spanning of disks, RAID0, RAID1 and RAID10 shall be supported
   (in order to be able to support SNIA DDF, higher raid levels need
    implementing in form of respective dm targets; eg, RAID5);
   Some vendors do have support for RAID5 already which is outside the scope
   of dmraid because of the lag of a RAID5 target in device-mapper!


Feature set definition:
-----------------------

Feature set summarizes as: Discover, Activate, Deactivate, Display.


o Discover (1-n RD)

  1 scan active disk devices identifying RD

  2 try to find an RD signature and if recognized add the device to the list
    of RDs found


o Activate (1-n RD)

  This shall be achieved by abstracting the internal metadata describing
  the RAID layout and translating the vendor specific representation
  into such abstracted form.

  1 group devices into sets conforming to their respective layout
    (SPAN, RAID0, RAID1, RAID10).
  
  2 generate dm mapping tables for a/those set(s).
  
  3 create multiple/a dm device(s) for each set to activate and 
    load the generated table(s) into the device.


o Deactivate (1-n RD)

  1 remove the dm device(s) making up an RD; can be a hierachy of devices
    (eg, RAID10: RAID1 on top of n RAID0 devices).


o Display (1-n RD)

  1 display RAID properties of the device
    (eg, display information kept with RAID sets such as size and type)



Technical specification:
------------------------

o RAID metadata format handler

  Tool calls the following function to register a vendor specific
  format handler; in case of success, a new instance with methods is
  accessible to the high level metadata handling functions (see below):

  - int register_format(struct dmraid_format *dmraid_format);

    x returns !0 on successfull format handler registration

    x returns 0 on failure.

  - Format handler methods:

    x struct dmraid_dev *(read)(struct disk_info* disk_info);

      - returns 'struct dmraid_dev *' describing the RD (eg, offset, length)

      - returns NULL on error

    x struct dmraid_set (*add)(struct dmraid_dev *dmraid_dev)

      - returns pointer to RAID set structure on success

      - returns NULL on error

    x int (*check)(struct dmraid_set *dmraid_set)

      - returns !0 in case raid set is consitent

      - returns 0 on inconsistency


o Discover

  1 retrieve block device information from sysfs for all disk
    devices by scanning /SYSFS_MOUNTPOINT/block/[sh]d*;
    keep information about the device path, size and the disk geometry which
    is the base to find the RAID signature on the device in a linked list
    of type 'struct disk_info *'.
    (FIXME: bogus Linux 2.6 disk geometry reported)

  2 walk the list and try to read RAID signature off the device trying vendor
    specific read methods (eg, Highpoint...) in turn; library exposes interface
    to register format handlers for vendor specific RAID formats in order
    to be open for future extensions (see register_format() above).

    Tool calls the following high level function which hides
    the iteration through all the registered format handler methods:

    x struct dmraid_dev *dmraid_read(char disk_info *disk_info);

      - returns 'struct dmraid_dev *' in case of an RAID device hit;
        'struct dmraid_dev *' contains information such as the data area start
        and length, the name of the RAID device and its status
	(operational etc.), the sequence # of the device in the set and
	the layout (eg, SPAN, RAID0, ...) with layout specifics
	(eg, stride size in case of RAID); shall be linkable
	to an ordered list which makes up the RAID set

      - returns NULL if no RAID disk device discovered


o Activate 1

    x struct dmraid_set *dmraid_add(struct dmraid_dev* dmraid);

      - returns pointer to the RAID set structure on success;
	RAID device got added to an existing set or a new set got
        created on the fly
    
      - returns NULL on error

    x struct dmraid_set *get_set(void);

      - get a RAID set off the list of created sets using an iterator;
	set is defined as an ordered linked list of the devices making
	up the set; in case of RAID10 a 2 level set hierarchy is used.

      - returns NULL in case list is empty

    x void rewind_set(void);

      - rewind the list iterator;
	next call to get_set() will return the first set on the list


o Activate 2+3

  - for non-RAID1 devices which have an invalid set check result
  - create the ASCII dm mapping table by iterating through the list
    of RD in a particular set, retrieving the layout (SPAN, ...)
    the device path, the offset into the device and the length to map
    and the stripe size in case of RAID
  - create a unique device_name
  - call device-mapper library to create the mapped device and load
    the mapping table

    x int activate_set(struct dmraid_set *dmraid_set);

      - returns 1 in case of successfull RAID set activation

      - returns 0 on error


o Deactivate

  - check if the RAID set is actiove and call device-mapper library to
    remove the mapped device (recursively in case of a mapped-device hierarchy)


o Display

  - list all block devices found
  - list all (in)active RD
  - display properties of a particular/all RD devices
    (eg, members of the set by block device name and offset/length mapped
     to those...)


Code directory tree:
--------------------

dmraid ---/tools
	+-/include
	+-/lib ---/activate
	|	|-/format ---/ataraid
	|	|-/device
	|	|-/display
	|	|-/misc
	|	|-/mm
	|	|-/log
	|	+-/metadata
	+-/man
	

Future enhancements:
--------------------

o write support to update ondisk metadata
  - to initialize RAID disks
  - to record disk failures

o support to log state (eg, sector failures) in ondisk logs

o status daemon to keep track of RAID set sanity
  (eg, disk failure, hot spare rebuild, ...) and
  frontend with CLI

o do we need to support partitions on RAID sets ?


Open questions:
---------------

o do we need to prioritize on device-mapper targets for higher RAID levels
  (in particular we'ld need RAID5 to support some ATARAID formats) ?

--kvUQC+jR9YzypDnK--

From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Mon, 18 Nov 2013 15:13:58 -0800
Message-ID: <CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528A7721.8080604@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sure - Here is the isw issue we can reproduce below (both versions
output is included):

Comparison of results using mdadm 3.2.6 (OK) vs mdadm 3.3 (not OK)
under otherwise identical conditions
from our boot disk, when trying to assemble an imsm RAID0 array (two
entire 500g drives /dev/sdb /dev/sdc).

The boot disk uses kernel 3.11.7, and udev 175 from the Debian Wheezy
udev package, including
their rules file (64-md-raid.rules).

Note: In this case at least, we get 2 different results when running
mdadm 3.3 under the same
conditions (some kind of race condtion?). The 2 sets of results are
under the headings "output1"
and "output2" below. For output2, the array is succesfully assembled
(uses /dev/sdb and /dev/sdc),
while output1 uses /dev/sdb and /dev/sdc2, and fails to assemble it.


contents of mdadm.conf (when attempting to assemble array):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, using
# wildcards if desired.
DEVICE partitions containers

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

ARRAY metadata=imsm UUID=0ee9661b:d0ee3f07:e2f3b890:f658562d
ARRAY /dev/md/RAID0 container=0ee9661b:d0ee3f07:e2f3b890:f658562d
member=0 UUID=540c3a88:7717daff:ccaf97eb:7961ac32


script that starts mdadm on boot (after udev started):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#! /bin/bash

if [ ! -e /proc/mdstat ]; then
    echo "Software RAID drivers not loaded"
    exit 0
fi

if [ ! -e /etc/mdadm/mdadm.conf-default ]; then
    echo "Default config file not found in /etc/mdadm"
    exit 0
else
    cp /etc/mdadm/mdadm.conf-default /etc/mdadm/mdadm.conf
fi

mdadm --examine --scan >> /etc/mdadm/mdadm.conf
mdadm --assemble --scan --no-degraded
echo


output of 'mdadm --examine --scan' (same for both):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ARRAY metadata=imsm UUID=0ee9661b:d0ee3f07:e2f3b890:f658562d
ARRAY /dev/md/RAID0 container=0ee9661b:d0ee3f07:e2f3b890:f658562d
member=0 UUID=540c3a88:7717daff:ccaf97eb:7961ac32


output of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.2.6):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/sdd4
mdadm: no RAID superblock on /dev/sdd3
mdadm: no RAID superblock on /dev/sdd2
mdadm: no RAID superblock on /dev/sdd1
mdadm: no RAID superblock on /dev/sdd
mdadm: cannot open device /dev/sr1: No medium found
mdadm: no RAID superblock on /dev/sdc2
mdadm: no RAID superblock on /dev/sdc1
mdadm: no RAID superblock on /dev/sda11
mdadm: no RAID superblock on /dev/sda10
mdadm: no RAID superblock on /dev/sda9
mdadm: no RAID superblock on /dev/sda8
mdadm: no RAID superblock on /dev/sda7
mdadm: no RAID superblock on /dev/sda6
mdadm: no RAID superblock on /dev/sda5
mdadm: no RAID superblock on /dev/sda4
mdadm: no RAID superblock on /dev/sda3
mdadm: no RAID superblock on /dev/sda2
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda
mdadm: cannot open device /dev/sr0: No medium found
mdadm: /dev/sdc is identified as a member of /dev/md/imsm0, slot -1.
mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot -1.
mdadm: added /dev/sdb to /dev/md/imsm0 as -1
mdadm: added /dev/sdc to /dev/md/imsm0 as -1
mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
mdadm: looking for devices for /dev/md/RAID0
mdadm: looking in container /dev/md127
mdadm: found match on member /md127/0 in /dev/md127
mdadm: Started /dev/md/RAID0 with 2 devices

output of 'dmesg | grep md:' and 'ls -l /dev/sdc*' - mdadm 3.2.6:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
md: md127 stopped.
md: bind<sdb>
md: bind<sdc>
md: md126 stopped.
md: bind<sdb>
md: bind<sdc>
md: RAID0 configuration for md126 - 1 zone
md: zone0=[sdc/sdb]
brw-rw---T    1 root     disk        8,  32 Nov 18 14:59 /dev/sdc
brw-rw---T    1 root     disk        8,  33 Nov 18 09:59 /dev/sdc1
brw-rw---T    1 root     disk        8,  34 Nov 18 09:59 /dev/sdc2

output1 of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.3 -
note using /dev/sdc2, not /dev/sdc):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/sdd4
mdadm: no RAID superblock on /dev/sdd3
mdadm: no RAID superblock on /dev/sdd2
mdadm: no RAID superblock on /dev/sdd1
mdadm: no RAID superblock on /dev/sdd
mdadm: cannot open device /dev/sr1: No medium found
mdadm: cannot open device /dev/sr0: No medium found
mdadm: no RAID superblock on /dev/sda11
mdadm: no RAID superblock on /dev/sda10
mdadm: no RAID superblock on /dev/sda9
mdadm: no RAID superblock on /dev/sda8
mdadm: no RAID superblock on /dev/sda7
mdadm: no RAID superblock on /dev/sda6
mdadm: no RAID superblock on /dev/sda5
mdadm: no RAID superblock on /dev/sda4
mdadm: no RAID superblock on /dev/sda3
mdadm: no RAID superblock on /dev/sda2
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda
mdadm: no RAID superblock on /dev/sdc1
mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot -1.
mdadm: /dev/sdc2 is identified as a member of /dev/md/imsm0, slot -1.
mdadm: /dev/sdc is identified as a member of /dev/md/imsm0, slot -1.
mdadm: added /dev/sdc2 to /dev/md/imsm0 as -1
mdadm: failed to add /dev/sdc to /dev/md/imsm0: Device or resource busy
mdadm: added /dev/sdb to /dev/md/imsm0 as -1
mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
mdadm: looking for devices for /dev/md/RAID0
mdadm: looking in container /dev/md/imsm0
mdadm: found match on member /md127/0 in /dev/md/imsm0
mdadm: Started /dev/md/RAID0 with 2 devices

output1 of 'dmesg | grep md:' and 'ls -l /dev/sdc*' - mdadm 3.3:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
md: md127 stopped.
md: bind<sdc2>
md: could not open unknown-block(8,32).
md: bind<sdb>
md: md126 stopped.
md: bind<sdb>
md: bind<sdc2>
md: RAID0 configuration for md126 - 1 zone
md: zone0=[sdc2/sdb]
brw-rw---T    1 root     disk        8,  32 Nov 18 15:02 /dev/sdc
brw-rw---T    1 root     disk        8,  33 Nov 18 10:02 /dev/sdc1
brw-rw---T    1 root     disk        8,  34 Nov 18 15:02 /dev/sdc2

output2 of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.3 -
note using /dev/sdc this time):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/sdd4
mdadm: no RAID superblock on /dev/sdd3
mdadm: no RAID superblock on /dev/sdd2
mdadm: no RAID superblock on /dev/sdd1
mdadm: no RAID superblock on /dev/sdd
mdadm: cannot open device /dev/sr1: No medium found
mdadm: cannot open device /dev/sr0: No medium found
mdadm: no RAID superblock on /dev/sdc1
mdadm: no RAID superblock on /dev/sda11
mdadm: no RAID superblock on /dev/sda10
mdadm: no RAID superblock on /dev/sda9
mdadm: no RAID superblock on /dev/sda8
mdadm: no RAID superblock on /dev/sda7
mdadm: no RAID superblock on /dev/sda6
mdadm: no RAID superblock on /dev/sda5
mdadm: no RAID superblock on /dev/sda4
mdadm: no RAID superblock on /dev/sda3
mdadm: no RAID superblock on /dev/sda2
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sdc2 is identified as a member of /dev/md/imsm0, slot -1.
mdadm: /dev/sdc is identified as a member of /dev/md/imsm0, slot -1.
mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot -1.
mdadm: added /dev/sdc to /dev/md/imsm0 as -1
mdadm: added /dev/sdb to /dev/md/imsm0 as -1
mdadm: failed to add /dev/sdc2 to /dev/md/imsm0: Device or resource busy
mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
mdadm: looking for devices for /dev/md/RAID0
mdadm: looking in container /dev/md/imsm0
mdadm: found match on member /md127/0 in /dev/md/imsm0
mdadm: Started /dev/md/RAID0 with 2 devices

output2 of 'dmesg | grep md:' and 'ls -l /dev/sdc*' - mdadm 3.3:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
md: md127 stopped.
md: bind<sdc>
md: bind<sdb>
md: could not open unknown-block(8,34).
md: md126 stopped.
md: bind<sdb>
md: bind<sdc>
md: RAID0 configuration for md126 - 1 zone
md: zone0=[sdc/sdb]
brw-rw---T    1 root     disk        8,  32 Nov 18 14:52 /dev/sdc
brw-rw---T    1 root     disk        8,  33 Nov 18 09:52 /dev/sdc1
brw-rw---T    1 root     disk        8,  34 Nov 18 14:52 /dev/sdc2


On Mon, Nov 18, 2013 at 12:22 PM, Martin Wilck <mwilck@arcor.de> wrote:
> On 11/18/2013 07:26 PM, David F. wrote:
>> Hi,
>>
>> we updated our linux disk with mdadm 3.3 from 3.2.6 and customers are
>> finding their RAID is no longer detected.  It's only been a couple
>> weeks and based on the number of customers, we know there is an issue.
>>  We're having those with problems workaround by having them load
>> dmraid instead for now.
>>
>> We also did tests locally and finding intermittent problems with
>> RAID-0 on ISW - sometimes 3.3 doesn't identify both drives as RAID
>> members.  3.2.6 works 100% of the time.
>>
>> Also with DDF RAID - cisco server for example not detecting RAID5 -
>> C220M3_LFF_SpecSheet.pdf. I believe they are using the LSI MegaRaid
>> since DMRAID reports that.
>
> Could you please provide mdadm -E and possibly mdadm --dump output of
> the disks that aren't detected? How does RAID discovery work on your
> systems? Are you using standard udev rules or something special? How
> does your mdadm.conf look like?
>
> Regards
> Martin
>
>
>>
>> Are these problems known - we wouldn't mind moving to the latest
>> version if your pretty sure it fixes it, otherwise we're going to have
>> to revert to 3.2.6?
>>
>> TIA!!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

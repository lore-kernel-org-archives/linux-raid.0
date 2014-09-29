From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: dmadm question
Date: Mon, 29 Sep 2014 10:38:03 -0700
Message-ID: <CAA9_cmc_YXg1=uVCm1wQ999ZMOihEv6HB-AO0FL8aiTwvFCQag@mail.gmail.com>
References: <661E720A-B65C-4C24-B6A4-A4439596DEB9@lukeodom.com>
	<20140915103154.59bc7293@notabene.brown>
	<56516488c20b6b78729f14731fe8aecf.squirrel@webmail.lukeodom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56516488c20b6b78729f14731fe8aecf.squirrel@webmail.lukeodom.com>
Sender: linux-raid-owner@vger.kernel.org
To: luke@lukeodom.com
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Hmm, I wonder if this is a regression.  The last time I saw this
problem I introduced commit:

commit b276dd33c74a51598e37fc72e6fb8f5ebd6620f2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Aug 25 19:14:24 2011 -0700

    imsm: fix reserved sectors for spares

    Different OROMs reserve different amounts of space for the migratio=
n area.
    When activating a spare minimize the reserved space otherwise a val=
id spare
    can be prevented from joining an array with a migration area smalle=
r than
    IMSM_RESERVED_SECTORS.

    This may result in an array that cannot be reshaped, but that is le=
ss
    surprising than not being able to rebuild a degraded array.
    imsm_reserved_sectors() already reports the minimal value which add=
s to
    the confusion when trying rebuild an array because mdadm -E indicat=
es
    that the device has enough space.

    Cc: Anna Czarnowska <anna.czarnowska@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

=2E..but I notice now the logic was replaced with:

commit b81221b74eba9fd7f670a8d3d4bfbda43ec91993
Author: Czarnowska, Anna <anna.czarnowska@intel.com>
Date:   Mon Sep 19 12:57:48 2011 +0000

    imsm: Calculate reservation for a spare based on active disks in co=
ntainer

    New function to calculate minimum reservation to expect from a spar=
e
    is introduced.

    The required amount of space at the end of the disk depends on what=
 we
    plan to do with the spare and what array we want to use it in.
    For creating new subarray in an empty container the full reservatio=
n of
    MPB_SECTOR_COUNT + IMSM_RESERVED_SECTORS is required.

    For recovery or OLCE on a volume using new metadata format at least
    MPB_SECTOR_CNT + NUM_BLOCKS_DIRTY_STRIPE_REGION is required.
    The additional space for migration optimization included in
    IMSM_RESERVED_SECTORS is not necessary and is not reserved by some =
oroms.

    MPB_SECTOR_CNT alone is not sufficient as it does not include the
    reservation at the end of subarray.

    However if the real reservation on active disks is smaller than thi=
s
    (when the array uses old metadata format) we should use the real va=
lue.
    This will allow OLCE and recovery to start on the spare even if the=
 volume
    doesn't have the reservation we normally use for new volumes.

    Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

=2E..which raises the absolute minimum reserved sectors to a number >
MPB_SECTOR_CNT.

My thought is that we should always favor spare replacement over
features like reshape, and dirty-stripe-log.  Commit b81221b74eba
appears to favor the latter.



On Mon, Sep 15, 2014 at 7:07 AM, Luke Odom <luke@lukeodom.com> wrote:
> Drive is exact same model as old one. Output of requested commands:
>
> # mdadm --manage /dev/md127 --remove /dev/sdb
> mdadm: hot removed /dev/sdb from /dev/md127
> # mdadm --zero /dev/sdb
> # mdadm --manage /dev/md127 --add /dev/sdb
> mdadm: added /dev/sdb
> # ps aux | grep mdmon
> root      1937  0.0  0.1  10492 10484 ?        SLsl 14:04   0:00 mdmo=
n md127
> root      2055  0.0  0.0   2420   928 pts/0    S+   14:06   0:00 grep=
 mdmon
>
> md: unbind<sdb>
> md: export_rdev(sdb)
> md: bind<sdb>
>
>
>
> On Sun, September 14, 2014 5:31 pm, NeilBrown wrote:
>> On 12 Sep 2014 18:49:54 -0700 Luke Odom <luke@lukeodom.com> wrote:
>>
>>>   I had a raid1 subarray running within an imsm container. One of t=
he
>>> drives died so I replaced it. I can get the new drive into the imsm
>>> container but I can=E2=80=99t add it to the raid1 array within that
>>> container. I=E2=80=99ve read the man page and can=E2=80=99t see to =
figure it out.
>>> Any help would be greatly appreciated. Using mdadm 3.2.5 on debian
>>> squeeze.
>>
>> This  should just happen automatically.  As soon as you add the devi=
ce to
>> the
>> container, mdmon notices and adds it to the raid1.
>>
>> However it appears not to have happened...
>>
>> I assume the new drive is exactly the same size as the old drive?
>> Try removing the new device from md127, run "mdadm --zero" on it, th=
en add
>> it
>> back again.
>> Do any messages appear in the kernel logs when you do that?
>>
>> Is "mdmon md127" running?
>>
>> NeilBrown
>>
>>
>>>
>>>
>>>
>>>
>>> root@ds6790:~# cat /proc/mdstat
>>> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>>> md126 : active raid1 sda[0]
>>>       976759808 blocks super external:/md127/0 [2/1] [U_]
>>>
>>>
>>>
>>>
>>> md127 : inactive sdb[0](S) sda[1](S)
>>>       4901 blocks super external:imsm
>>>
>>>
>>>
>>>
>>> unused devices: <none>
>>>
>>>
>>>
>>>
>>>
>>>
>>> root@ds6790:~# mdadm --detail /dev/md126
>>> /dev/md126:
>>>       Container : /dev/md127, member 0
>>>      Raid Level : raid1
>>>      Array Size : 976759808 (931.51 GiB 1000.20 GB)
>>>   Used Dev Size : 976759940 (931.51 GiB 1000.20 GB)
>>>    Raid Devices : 2
>>>   Total Devices : 1
>>>
>>>
>>>
>>>
>>>           State : active, degraded
>>>  Active Devices : 1
>>> Working Devices : 1
>>>  Failed Devices : 0
>>>   Spare Devices : 0
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>            UUID : 1be60edf:5c16b945:86434b6b:2714fddb
>>>     Number   Major   Minor   RaidDevice State
>>>        0       8        0        0      active sync
>>> /dev/sda
>>>        1       0        0        1      removed
>>>
>>>
>>>
>>>
>>>
>>>
>>> root@ds6790:~# mdadm --examine /dev/md127
>>> /dev/md127:
>>>           Magic : Intel Raid ISM Cfg Sig.
>>>         Version : 1.1.00
>>>     Orig Family : 6e37aa48
>>>          Family : 6e37aa48
>>>      Generation : 00640a43
>>>      Attributes : All supported
>>>            UUID : ac27ba68:f8a3618d:3810d44f:25031c07
>>>        Checksum : 513ef1f6 correct
>>>     MPB Sectors : 1
>>>           Disks : 2
>>>    RAID Devices : 1
>>>
>>>
>>>
>>>
>>>   Disk00 Serial : 9XG3RTL0
>>>           State : active
>>>              Id : 00000002
>>>     Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
>>>
>>>
>>>
>>>
>>> [Volume0]:
>>>            UUID : 1be60edf:5c16b945:86434b6b:2714fddb
>>>      RAID Level : 1
>>>         Members : 2
>>>           Slots : [U_]
>>>     Failed disk : 1
>>>       This Slot : 0
>>>      Array Size : 1953519616 (931.51 GiB 1000.20 GB)
>>>    Per Dev Size : 1953519880 (931.51 GiB 1000.20 GB)
>>>   Sector Offset : 0
>>>     Num Stripes : 7630936
>>>      Chunk Size : 64 KiB
>>>        Reserved : 0
>>>   Migrate State : idle
>>>       Map State : degraded
>>>     Dirty State : dirty
>>>
>>>
>>>
>>>
>>>   Disk01 Serial : XG3RWMF
>>>           State : failed
>>>              Id : ffffffff
>>>     Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
>>>
>>>
>>>
>>>
>>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

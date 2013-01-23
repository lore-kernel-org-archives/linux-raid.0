From: John Gehring <john.gehring@gmail.com>
Subject: Re: mdadm - assemble error - 'not enough to start the array while not clean'
Date: Wed, 23 Jan 2013 11:50:50 -0700
Message-ID: <CALwOXv+iX5DLcn2DERRfFLSncqMYhD_M6KYUsRT55LmUVjZdYg@mail.gmail.com>
References: <CALwOXvLW=fQjBmsHZy9WzqkXJj8pDDX=nOU=GF=8mqMK_H3XJQ@mail.gmail.com>
	<CALwOXv+uOgpnh3kPSZOShnzsK=J+g5P5aGOZToUVTA_N_fdrdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALwOXv+uOgpnh3kPSZOShnzsK=J+g5P5aGOZToUVTA_N_fdrdg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I think I'm getting closer to understanding the issue, but still have
some questions about the various states of the raid array. Ultimately,
the 'assemble' command is resulting in the un-started state (not
enough to start the array while not clean) because the array state
does not include the 'clean' condition. What I've noticed is that
after removing a device and prior to adding a device back to the
array, the array state is: 'clean, degraded, resyncing'. But after a
device is added back to the array, the state moves to: 'active,
degraded, resyncing' (no longer clean!). At this point, if the array
is stopped and then re-assembled, the array will not start.

Is there a good explanation for why the 'clean' state does not exist
after adding a device back to the array?

Thanks.


After removing a device from the array:
------------------------------------------------------------------------------------------------------
mdadm-3.2.6$ sudo mdadm -D /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Wed Jan 23 11:06:45 2013
     Raid Level : raid6
     Array Size : 1503744 (1468.75 MiB 1539.83 MB)
  Used Dev Size : 250624 (244.79 MiB 256.64 MB)
   Raid Devices : 8
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Wed Jan 23 11:07:06 2013
          State : clean, degraded, resyncing
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

  Resync Status : 26% complete

           Name : JLG-NexGenStorage:1  (local to host JLG-NexGenStorage)
           UUID : 0100e727:8d91a5d9:67f0be9e:26be5623
         Events : 8

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       0        0        4      removed
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       7       8      128        7      active sync   /dev/sdi



After adding a device back to the array:
------------------------------------------------------------------------------------------------------

mdadm-3.2.6$ sudo mdadm -D /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Wed Jan 23 11:06:45 2013
     Raid Level : raid6
     Array Size : 1503744 (1468.75 MiB 1539.83 MB)
  Used Dev Size : 250624 (244.79 MiB 256.64 MB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Wed Jan 23 11:07:27 2013
          State : active, degraded, resyncing
 Active Devices : 7
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 256K

  Resync Status : 52% complete

           Name : JLG-NexGenStorage:1  (local to host JLG-NexGenStorage)
           UUID : 0100e727:8d91a5d9:67f0be9e:26be5623
         Events : 14

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       0        0        4      removed
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       7       8      128        7      active sync   /dev/sdi

       8       8       80        -      spare   /dev/sdf

On Fri, Jan 18, 2013 at 6:37 PM, John Gehring <john.gehring@gmail.com> wrote:
> I executed the assemble command with the verbose option and saw this:
>
> ~$ sudo mdadm --verbose --assemble /dev/md1
> --uuid=0100e727:8d91a5d9:67f0be9e:26be5623
> mdadm: looking for devices for /dev/md1
> mdadm: no RAID superblock on /dev/sda5
> mdadm: no RAID superblock on /dev/sda2
> mdadm: no RAID superblock on /dev/sda1
> mdadm: no RAID superblock on /dev/sda
> mdadm: /dev/sdf is identified as a member of /dev/md1, slot -1.
> mdadm: /dev/sdm is identified as a member of /dev/md1, slot 7.
> mdadm: /dev/sdh is identified as a member of /dev/md1, slot 6.
> mdadm: /dev/sdg is identified as a member of /dev/md1, slot 5.
> mdadm: /dev/sde is identified as a member of /dev/md1, slot 3.
> mdadm: /dev/sdd is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdc is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sdb is identified as a member of /dev/md1, slot 0.
> mdadm: added /dev/sdc to /dev/md1 as 1
> mdadm: added /dev/sdd to /dev/md1 as 2
> mdadm: added /dev/sde to /dev/md1 as 3
> mdadm: no uptodate device for slot 4 of /dev/md1
> mdadm: added /dev/sdg to /dev/md1 as 5
> mdadm: added /dev/sdh to /dev/md1 as 6
> mdadm: added /dev/sdm to /dev/md1 as 7
> mdadm: failed to add /dev/sdf to /dev/md1: Device or resource busy
> mdadm: added /dev/sdb to /dev/md1 as 0
> mdadm: /dev/md1 assembled from 7 drives - not enough to start the
> array while not clean - consider --force.
>
> This made me think that the zero-superblock command was not clearing
> out data as well as I expected. (BTW, I re-ran the test and ran the
> zero-superblock multiple times to get the 'mdadm: Unrecognised md
> component device - /dev/sdf' response, but still ended up with the
> assemble error.) Given that it looked to mdadm like the device still
> had belonged to the raid array, I dd'd zero's into the device between
> steps 8 and 9 (after running the zero-superblock command; probably
> redundant) and this seems to have done the trick. If I zero out the
> device (and I'm sure I can actually zero out more specific parts
> related to the superblock area), then the final assemble command works
> as desired.
>
> Still wouldn't mind hearing back about why this fails when I only take
> the steps outlined in the message above.
>
> Thanks.
>
> On Thu, Jan 17, 2013 at 7:43 PM, John Gehring <john.gehring@gmail.com> wrote:
>> I am receiving the following error when trying to assemble a raid set:
>>
>> mdadm: /dev/md1 assembled from 7 drives - not enough to start the
>> array while not clean - consider --force.
>>
>> My machine environment and the steps are listed below. I'm happy to
>> provide additional information.
>>
>> I have used the following steps to reliably reproduce the problem:
>>
>> 1 - echo "AUTO -all" >> /etc/mdadm.conf     : Do this in order to
>> prevent auto assembly in a later step.
>>
>> 2 - mdadm --create /dev/md1 --level=6 --chunk=256 --raid-devices=8
>> --uuid=0100e727:8d91a5d9:67f0be9e:26be5623 /dev/sdb /dev/sdc /dev/sdd
>> /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdm
>>    -  I originally detected this problem on a system with a 16 drive
>> LSI sas back plane, but found I could create a similar 8-device array
>> with a couple of 4-port USB hubs.
>>
>> 3 - Pull a drive from the raid set. This should be done prior to raid
>> finishing the resync process. If you're using > 1 G USB devices, there
>> should be ample time.
>>    - sudo bash -c "/bin/echo -n 1 > /sys/block/sdf/device/delete"
>>
>> 4 - Inspect the raid status to be sure that the device is now marked as faulty.
>>    - mdadm -D /dev/md1
>>
>> 5 - Remove the 'faulty' device from the raid set. Note that upon
>> inspection of the raid data in the last step, you can see that the
>> device name of the faulty device is not given.
>>    - mdadm --manage /dev/md1 --remove faulty
>>
>> 6 - Stop the raid device.
>>    - mdadm -S /dev/md1
>>
>> 7 - Rediscover the 'pulled' USB device. Note that I'm doing a virtual
>> pull and insert of the USB device because I don't have to run the risk
>> of bumping/reseating other USB devices on the same HUB.
>>    - sudo bash -c "/bin/echo -n \"- - -\" > /sys/class/scsi_host/host23/scan"
>>    - This step can be a little tricky because there are a good number
>> of hostx devices in the /sys/class/scsi_host directory. You have to
>> know how they are mapped or keep trying the command with different
>> hostx dirs specified until your USB device shows back up in the /dev/
>> directory.
>>
>> 8 - 'zero' the superblock on the newly discovered device.
>>    - mdadm --zero-superblock /dev/sdf
>>
>> 9 - Try to assemble the raid set.
>>   - mdadm --assemble /dev/md1 --uuid=0100e727:8d91a5d9:67f0be9e:26be5623
>>
>> results in =>  mdadm: /dev/md1 assembled from 7 drives - not enough to
>> start the array while not clean - consider --force.
>>
>> Using the --force switch works, but I'm not confident that the
>> integrity of the raid array has been maintained.
>>
>> My system:
>>
>> HP EliteBook 8740w
>> ~$ cat /etc/issue
>> Ubuntu 11.04 \n \l
>>
>> ~$ uname -a
>> Linux JLG 2.6.38-16-generic #67-Ubuntu SMP Thu Sep 6 17:58:38 UTC 2012
>> x86_64 x86_64 x86_64 GNU/Linux
>>
>> ~$ mdadm --version
>> mdadm - v3.2.6 - 25th October 2012
>>
>> ~$ modinfo raid456
>> filename:       /lib/modules/2.6.38-16-generic/kernel/drivers/md/raid456.ko
>> alias:          raid6
>> alias:          raid5
>> alias:          md-level-6
>> alias:          md-raid6
>> alias:          md-personality-8
>> alias:          md-level-4
>> alias:          md-level-5
>> alias:          md-raid4
>> alias:          md-raid5
>> alias:          md-personality-4
>> description:    RAID4/5/6 (striping with parity) personality for MD
>> license:        GPL
>> srcversion:     2A567A4740BF3F0C5D13267
>> depends:        async_raid6_recov,async_pq,async_tx,async_memcpy,async_xor
>> vermagic:       2.6.38-16-generic SMP mod_unload modversions
>>
>> The raid set when it's happy:
>>
>> mdadm-3.2.6$ sudo mdadm -D /dev/md1
>> /dev/md1:
>>         Version : 1.2
>>   Creation Time : Thu Jan 17 19:34:51 2013
>>      Raid Level : raid6
>>      Array Size : 1503744 (1468.75 MiB 1539.83 MB)
>>   Used Dev Size : 250624 (244.79 MiB 256.64 MB)
>>    Raid Devices : 8
>>   Total Devices : 8
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Thu Jan 17 19:35:02 2013
>>           State : active, resyncing
>>  Active Devices : 8
>> Working Devices : 8
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 256K
>>
>>   Resync Status : 13% complete
>>
>>            Name : JLG:1  (local to host JLG)
>>            UUID : 0100e727:8d91a5d9:67f0be9e:26be5623
>>          Events : 3
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       16        0      active sync   /dev/sdb
>>        1       8       32        1      active sync   /dev/sdc
>>        2       8       48        2      active sync   /dev/sdd
>>        3       8       64        3      active sync   /dev/sde
>>        4       8       80        4      active sync   /dev/sdf
>>        5       8       96        5      active sync   /dev/sdg
>>        6       8      112        6      active sync   /dev/sdh
>>        7       8      192        7      active sync   /dev/sdm
>>
>>
>> Thank you to anyone who's taking the time to look at this.
>>
>> Cheers,
>>
>> John Gehring

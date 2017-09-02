From: David Mitchell <mr.david.mitchell@gmail.com>
Subject: Re: Superblock Missing
Date: Sat, 2 Sep 2017 11:43:49 -0400
Message-ID: <CAANkkpK6jeFKr-Tz2Fzq-CTey0GJRmERy0W+DBHMVJct2JYfUQ@mail.gmail.com>
References: <CAANkkp+3WwZvKu60LkU_0VpxZvZuNrrE=qDt=4DPc80AO+sgEg@mail.gmail.com>
 <20170902014333.GA26507@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170902014333.GA26507@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andreas, thank you for your response.

Sorry I'm still confused.   While the array seems alive, the
filesystem seems to be missing?

I'm unable to mount the filesystem.


As a troubleshooting step I recoverjpeg and it did find a bunch of files.

#recoverjpeg -s 1m /dev/md0


# dumpe2fs /dev/md0
dumpe2fs 1.42.13 (17-May-2015)
dumpe2fs: Bad magic number in super-block while trying to open /dev/md0
Couldn't find valid filesystem superblock.



------------------
# mount /dev/md0 /mnt/raid/
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

----------------
dmesg:
[307811.909930] EXT4-fs (md0): VFS: Can't find ext4 filesystem




---------------

# mdadm --detail /dev/md*
/dev/md0:
        Version : 1.2
  Creation Time : Sat Aug 26 16:21:20 2017
     Raid Level : raid5
     Array Size : 7801143296 (7439.75 GiB 7988.37 GB)
  Used Dev Size : 3900571648 (3719.88 GiB 3994.19 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Aug 31 22:21:32 2017
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : virtual:0  (local to host virtual)
           UUID : 964fd303:748b8f0e:58f384ce:3fde97cc
         Events : 6261

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       3       8       65        2      active sync   /dev/sde1
/dev/md127:
        Version :
     Raid Level : raid0
  Total Devices : 0

          State : inactive

    Number   Major   Minor   RaidDevice


-----------------------------------------------------------------------


Sincerely,

David Mitchell


On Fri, Sep 1, 2017 at 9:43 PM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> On Fri, Sep 01, 2017 at 08:52:23PM -0400, David Mitchell wrote:
>> # mdadm --examine /dev/md0
>> mdadm: No md superblock detected on /dev/md0.
>
> Everyone will assume user error at this point.
> /dev/md0 is not supposed to have a mdadm superblock to examine.
> It has a filesystem or LUKS or LVM header or whatever it is you do.
>
> For --examine you have to provide one or more member devices.
>
> You can do mdadm --detail /dev/md* or mdadm --examine /dev/sd*.
>
>> Requested from "When Things Go Wrong"
>>
>> -------------------------------------
>> # mdadm --examine /dev/sd[cde]1
>> /dev/sdc1:
>>           Magic : a92b4efc
>>         Version : 1.2
>
> Oh look. There it is. Your superblock...
>
> Other than that I see no problems. Your Load Cycle Counts are high
> and for WD there are tools to finetune that behaviour but it's
> unclear whether that's actually a real problem.
>
>> SMART Extended Self-test Log Version: 1 (1 sectors)
>> Num  Test_Description    Status                  Remaining
>> LifeTime(hours)  LBA_of_first_error
>> # 1  Short offline       Completed without error       00%         0         -
>
> Consider running smart tests more regularly.
>
> Regards
> Andreas Klauer

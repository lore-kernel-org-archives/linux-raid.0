From: Mark Knecht <markknecht@gmail.com>
Subject: Re: High mismatch count on root device - how to best handle?
Date: Mon, 25 Apr 2011 18:30:54 -0700
Message-ID: <BANLkTikwv-PRcwknZkMsPY6T+N0p=-uC4w@mail.gmail.com>
References: <BANLkTikLN6P52tknwD0+D-+2iDUp3sF1fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikLN6P52tknwD0+D-+2iDUp3sF1fA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 25, 2011 at 3:32 PM, Mark Knecht <markknecht@gmail.com> wro=
te:
> I did a drive check today, first time in months, and found I have a
> high mismatch count on my RAID1 root device. What's the best way to
> handle getting this cleaned up?
>
> 1) I'm running some smartctl tests as I write this.
>
> 2) Do I just do an
>
> echo repair
>
> to md126 or do I have to boot a rescue CD before I do that?
>
> If you need more info please let me know.
>
> Thanks,
> Mark
>
> c2stable ~ # cat /sys/block/md3/md/mismatch_cnt
> 0
> c2stable ~ # cat /sys/block/md6/md/mismatch_cnt
> 0
> c2stable ~ # cat /sys/block/md7/md/mismatch_cnt
> 0
> c2stable ~ # cat /sys/block/md126/md/mismatch_cnt
> 222336
> c2stable ~ # df
> Filesystem =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1K-blocks =C2=A0 =C2=A0=
 =C2=A0Used Available Use% Mounted on
> /dev/md126 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A051612920 =C2=A026=
159408 =C2=A022831712 =C2=A054% /
> udev =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 10240 =C2=A0 =C2=A0 =C2=A0 432 =C2=A0 =C2=A0 =C2=A09808 =C2=A0 5% /=
dev
> /dev/md7 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 389183252 14497918=
4 224434676 =C2=A040% /VirtualMachines
> shm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A06151452 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 6151452 =C2=A0 0% /dev/=
shm
> c2stable ~ # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md6 : active raid1 sdc6[2] sda6[0] sdb6[1]
> =C2=A0 =C2=A0 =C2=A0247416933 blocks super 1.1 [3/3] [UUU]
>
> md7 : active raid6 sdc7[2] sda7[0] sdb7[1] sdd2[3] sde2[4]
> =C2=A0 =C2=A0 =C2=A0395387904 blocks super 1.2 level 6, 16k chunk, al=
gorithm 2 [5/5] [UUUUU]
>
> md3 : active raid6 sdc3[2] sda3[0] sdb3[1] sdd3[3] sde3[4]
> =C2=A0 =C2=A0 =C2=A0157305168 blocks super 1.2 level 6, 16k chunk, al=
gorithm 2 [5/5] [UUUUU]
>
> md126 : active raid1 sdc5[2] sda5[0] sdb5[1]
> =C2=A0 =C2=A0 =C2=A052436032 blocks [3/3] [UUU]
>
> unused devices: <none>
> c2stable ~ #
>

The smartctl tests that I ran (long) completed without error on all 5
drives in the system:

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      2887   =
      -
# 2  Extended offline    Completed without error       00%      2046   =
      -


So, if I understand correctly the next step I'd do would be something l=
ike

echo repair >/sys/block/md126/md/sync_action

but I'm unclear about the need to do this when mdadm seems to think
the RAID is clean:

c2stable ~ # mdadm -D /dev/md126
/dev/md126:
        Version : 0.90
  Creation Time : Tue Apr 13 09:02:34 2010
     Raid Level : raid1
     Array Size : 52436032 (50.01 GiB 53.69 GB)
  Used Dev Size : 52436032 (50.01 GiB 53.69 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 126
    Persistence : Superblock is persistent

    Update Time : Mon Apr 25 18:29:39 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           UUID : edb0ed65:6e87b20e:dc0d88ba:780ef6a3
         Events : 0.248880

    Number   Major   Minor   RaidDevice State
       0       8        5        0      active sync   /dev/sda5
       1       8       21        1      active sync   /dev/sdb5
       2       8       37        2      active sync   /dev/sdc5
c2stable ~ #

Thanks in advance.

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

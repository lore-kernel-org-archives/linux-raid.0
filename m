From: Dush <tomdush@gmail.com>
Subject: Re: All drive in Raid 5 are in 'spare' mode
Date: Mon, 16 Feb 2015 19:38:42 +0000
Message-ID: <CAL7hTOfhWiCmKVVCtpmHuB-OJkZjQsuaKZMN8oFKAArh=NuSHQ@mail.gmail.com>
References: <CAL7hTOctZ4tAoPSbO3iFEohRyXuvcY4=6yQj8U-FpoAhV6sT0w@mail.gmail.com>
 <54DC04C1.4010107@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DC04C1.4010107@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil,

Thanks for your answer!

Unfortunately, I think I just loosed a disk (sde)... I don't see it
anymore in /dev , I have in dmesg:
d
[   12.280021] ata7: softreset failed (1st FIS failed)
[   22.280019] ata7: softreset failed (1st FIS failed)
[   57.280015] ata7: softreset failed (1st FIS failed)
[   57.280222] ata7: limiting SATA link speed to 1.5 Gbps
[   62.453345] ata7: softreset failed (device not ready)
[   62.453558] ata7: reset failed, giving up

And my reports look like this now:

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md126 : inactive sdb3[3](S) sdd3[1](S) sdc3[0](S)
     1447416000 blocks

md127 : active (auto-read-only) raid5 sdd2[1] sdb2[3] sdc2[0]
     16530624 blocks level 5, 64k chunk, algorithm 2 [4/3] [UU_U]

unused devices: <none>

# mdadm --examine /dev/sd[b-e]3
/dev/sdb3:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 3327f442:a00b59b2:1397f3c2:236c0edf
 Creation Time : Tue Jan 27 13:03:52 2009
    Raid Level : raid5
 Used Dev Size : 482472000 (460.12 GiB 494.05 GB)
    Array Size : 1447416000 (1380.36 GiB 1482.15 GB)
  Raid Devices : 4
 Total Devices : 4
Preferred Minor : 126

   Update Time : Wed Jan 21 20:55:48 2015
         State : active
Active Devices : 3
Working Devices : 4
Failed Devices : 1
 Spare Devices : 1
      Checksum : 6e656c69 - correct
        Events : 49656

        Layout : left-symmetric
    Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
this     3       8       19        3      active sync   /dev/sdb3

  0     0       8       35        0      active sync   /dev/sdc3
  1     1       8       67        1      active sync
  2     2       0        0        2      faulty removed
  3     3       8       19        3      active sync   /dev/sdb3
  4     4       8       51        4      spare   /dev/sdd3
/dev/sdc3:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 3327f442:a00b59b2:1397f3c2:236c0edf
 Creation Time : Tue Jan 27 13:03:52 2009
    Raid Level : raid5
 Used Dev Size : 482472000 (460.12 GiB 494.05 GB)
    Array Size : 1447416000 (1380.36 GiB 1482.15 GB)
  Raid Devices : 4
 Total Devices : 4
Preferred Minor : 126

   Update Time : Wed Jan 21 23:34:52 2015
         State : clean
Active Devices : 2
Working Devices : 3
Failed Devices : 2
 Spare Devices : 1
      Checksum : 6e6653d5 - correct
        Events : 49666

        Layout : left-symmetric
    Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
this     0       8       35        0      active sync   /dev/sdc3

  0     0       8       35        0      active sync   /dev/sdc3
  1     1       8       67        1      active sync
  2     2       0        0        2      faulty removed
  3     3       0        0        3      faulty removed
  4     4       8       51        4      spare   /dev/sdd3
/dev/sdd3:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 3327f442:a00b59b2:1397f3c2:236c0edf
 Creation Time : Tue Jan 27 13:03:52 2009
    Raid Level : raid5
 Used Dev Size : 482472000 (460.12 GiB 494.05 GB)
    Array Size : 1447416000 (1380.36 GiB 1482.15 GB)
  Raid Devices : 4
 Total Devices : 4
Preferred Minor : 126

   Update Time : Wed Jan 21 23:34:52 2015
         State : clean
Active Devices : 2
Working Devices : 3
Failed Devices : 2
 Spare Devices : 1
      Checksum : 6e6653f7 - correct
        Events : 49666

        Layout : left-symmetric
    Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
this     1       8       67        1      active sync

  0     0       8       35        0      active sync   /dev/sdc3
  1     1       8       67        1      active sync
  2     2       0        0        2      faulty removed
  3     3       0        0        3      faulty removed
  4     4       8       51        4      spare   /dev/sdd3



You was right, I already tried to start the raid and it succeed to do
it with 3 drives: b, c and e. Then I added the d because I thought it
was de-synchronized.
Now I think my drive e was out of this raid for a while and I started
to had trouble because d started to had some issues.

Is it possible to force raid to start with b, c and d (forcing d to be
'normal')? Time for me to copy everything to another drive...


Thanks,
Dush

On 12 February 2015 at 01:41, Phil Turmel <philip@turmel.org> wrote:
> Hi Dush,
>
> On 02/11/2015 02:56 PM, Dush wrote:
>> Hi,
>>
>> I have a RAID 5 composed by 4x 500Go hdd but for some days, it's 'inactive'.
>>
>> I'm not raid expert and I prefer asking before doing an unrecoverable mistake...
>>
>> Is it possible to fix this raid (md126)?
>> Is it possible to recover data on it?
>
> Probably.  Very good report, btw.
>
>> Do I have a disk to change or it's "just" a desynchronization between disks?
>
> One disk is now truly a spare (/dev/sdd3), which suggests you already
> tried to '--add' it and didn't get anywhere.
>
> Step one:  collect some forensics for later.  syslog or dmesg containing
> your failure events.  Can be trimmed to just device and md stuff.
> "smartctl -x /dev/sdX" for each drive involved in the arrays.
>
> Then, we'll try the simple stuff.
>
> Make sure the array is stopped with:
>
> mdadm --stop /dev/md126
>
> Then, force assemble it without sdd:
>
> mdadm --assemble --force --verbose --run /dev/md126 /dev/sd[bce]3
>
> If that works, mount it and catch a backup of critical files.
>
> Then add your /dev/sdd3 back to the array and let it rebuild:
>
> mdadm --add /dev/md126 /dev/sdd3
>
> It may not make it through the rebuild if you have the common timeout
> mismatch problem.[1]  Show the dmesg and smartctl data (pasted inline is
> preferred) and we'll see.
>
> Phil
>
> Recent typical case:
> [1] http://marc.info/?l=linux-raid&m=142353387024935&w=1
>

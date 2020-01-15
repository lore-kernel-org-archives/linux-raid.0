From: Marco Heiming <myx00r@gmail.com>
Subject: Re: Raid 5 cannot be re-assembled after disk was removed
Date: Wed, 15 Jan 2020 08:31:01 +0100
Message-ID: <CAEWf3EA4rG_Xa-xvDNTMuQLQhOh1RuDaogttfAZ1_CWvBb0zfQ@mail.gmail.com>
References: <CAEWf3EDf-CwMz660RjRAtL==fa-Xc2XVpbrJL_Xqw24ZTZ18Zg@mail.gmail.com>
 <20200108122538.GB16146@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200108122538.GB16146@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you so far Andreas.

I was able to re-assemble the array with the defective disk (sdd in
this case) and the old spare (sde).
It was rebuilding over night and now it looks like this:

mdadm --detail -v /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Wed Jan  7 18:14:37 2015
        Raid Level : raid5
        Array Size : 8790405120 (8383.18 GiB 9001.37 GB)
     Used Dev Size : 2930135040 (2794.39 GiB 3000.46 GB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Thu Jan  9 19:37:16 2020
             State : clean
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

  Layout : left-symmetric
  Chunk Size : 512K

Consistency Policy : bitmap

              Name : NAS:0  (local to host NAS)
              UUID : 7b0eee59:07f87155:bdad1d0e:6e3cbad6
            Events : 280445

    Number   Major   Minor   RaidDevice State
       4       8       64        0      active sync   /dev/sde
       1       8       16        1      active sync   /dev/sdb
       3       8       32        2      active sync   /dev/sdc
       0       8       48        3      active sync   /dev/sdd

I was able to mount the array in read-only and it looks like the data
is fine; i also ran a btrfs check in read-only mode and it found no
errors.
So far so good :)

Although disk sdd is still reporting an increasing read error rate via SMART:
smartctl -a /dev/sdd | grep "Raw_Read_Error_Rate"
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       764
therefore i need to replace this disk in the next days.

Thank you so far for your help.


Am Mi., 8. Jan. 2020 um 13:25 Uhr schrieb Andreas Klauer
<Andreas.Klauer@metamorpher.de>:
>
> On Wed, Jan 08, 2020 at 10:31:28AM +0100, Marco Heiming wrote:
> >        0       8        0        -      spare   /dev/sda
>
> Your spare was /dev/sda
>
> > mdadm --examine /dev/sd[b-z]
>
> Here you deliberately examine sdb-z, so what happened to sda?
>
> You mentioned drive letters changed, but is it really not there anymore?
>
> If you don't know which drives you synced in the array then who does...?
>
> Regards
> Andreas Klauer

From: antlists <antlists@youngman.org.uk>
Subject: Re: rsync input/output errors during resyncing of RAID10 e-sata,
 share changed to read-only
Date: Sat, 13 Jun 2020 19:17:32 +0100
Message-ID: <c731ea93-84ad-49ef-f434-8efdeb77ba0f@youngman.org.uk>
References: <CAFHi+KRt9TZmu6GWer0wEQug-ZJGBm7kGSkCWs2==8V_Ge_31g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFHi+KRt9TZmu6GWer0wEQug-ZJGBm7kGSkCWs2==8V_Ge_31g@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kudyba <rkudyba@fordham.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/06/2020 21:58, Robert Kudyba wrote:

Sorry for not getting back quick again, life gets in the way :-)

>> Is this a Barracuda? ummmm :-(
> 
>> Are you running that script that fixes timeouts?
> 
> I am now:
> /dev/sda  is  bad Device Model:     ST2000DM001-1ER164
> /dev/sdb  is  bad
> /dev/sdc  is good Device Model:     ST31500341AS
> /dev/sdd  is  bad
> /dev/sde  is  bad
> /dev/sdf  is good Device Model:     ST31500341AS
> 
>> When you get things sorted, you need to check all the SMARTs.
> 
> Now I'm seeing this in the logs:
> Jun  9 15:51:31 ourserver kernel: md: recovery of RAID array md0
> Jun  9 15:51:31 ourserver kernel: md/raid10:md0: insufficient working
> devices for recovery.
> Jun  9 15:51:31 ourserver kernel: md: md0: recovery interrupted.
> Jun  9 15:51:31 ourserver kernel: md: super_written gets error=10
> Jun  9 15:53:23 ourserver kernel: program smartctl is using a
> deprecated SCSI ioctl, please convert it to SG_IO
> 
> And trying to fail /dev/sdb results in:
> mdadm --manage /dev/md0 --fail /dev/sdb1
> mdadm: set device faulty failed for /dev/sdb1:  Device or resource busy
> 
> Resync is now showing 0%:
> mdadm --detail /dev/md0
> /dev/md0:
>             Version : 1.2
>       Creation Time : Fri Mar 13 16:46:35 2020
>          Raid Level : raid10
>          Array Size : 2930010928 (2794.28 GiB 3000.33 GB)
>       Used Dev Size : 1465005464 (1397.14 GiB 1500.17 GB)
>        Raid Devices : 4
>       Total Devices : 4
>         Persistence : Superblock is persistent
> 
>         Update Time : Tue Jun  9 15:49:41 2020
>               State : clean, degraded, recovering
>      Active Devices : 3
>     Working Devices : 4
>      Failed Devices : 0
>       Spare Devices : 1
> 
>              Layout : near=2
>          Chunk Size : 8K
> 
> Consistency Policy : resync
> 
>      Rebuild Status : 0% complete
> 
>                Name : ourserver:0  (local to host ourserver)
>                UUID : 88b9fcb6:52d0f235:849bd9d6:c079cfc8
>              Events : 1081374
> 
>      Number   Major   Minor   RaidDevice State
>         0       8       81        0      active sync set-A   /dev/sdf1
>         4       8       33        1      active sync set-B   /dev/sdc1
>         3       8       17        2      active sync set-A   /dev/sdb1
>         5       8        1        2      spare rebuilding   /dev/sda1
>         -       0        0        3      removed
> 
> cat /proc/mdstat
> Personalities : [raid10]
> md0 : active raid10 sda1[5](S)(R) sdf1[0] sdb1[3] sdc1[4]
>        2930010928 blocks super 1.2 8K chunks 2 near-copies [4/3] [UUU_]
> 
> How do I promote the spare drive and fail /dev/sdb?
> 
You don't want to do that, not right now ...

It's resyncing sda from sdc, and you're probably better off waiting 
until that's complete. Note also that sda is the spare, so using that to 
replace sdb will rather mess things up ...

If the resync is hung at 0%, I think there's an option you can use to 
restart it. Don't forget you need to do an mdadm --stop between attempts 
to do anything.

If all else fails, I'd replace sda with a proper raid drive, then, 
PROVIDED THE EVENT COUNTS ARE ALL THE SAME, force-assemble sdf, sdc and 
sdb, then add the new drive in and let it rebuild. Then look at 
replacing the other drives.

For replacement drives, your choices at the moment seem to be Seagate 
Ironwolves, Toshiba N300s, or WD Red Pro. DO NOT TOUCH WD REDS.

Cheers,
Wol

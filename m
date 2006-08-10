From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: drive is a spare, but I want to make it active - how?
Date: Thu, 10 Aug 2006 15:53:07 +0200
Message-ID: <44DB3A43.4020506@wpkg.org>
References: <44DB1D27.4010508@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44DB1D27.4010508@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Chmielewski wrote:
> I created RAID-10 on 4 drives, and I'm testing it a bit.
> 
> I removed one drive, and then added it again.
> 
> mdadm --detail says:
> 
>         Version : 01.00.03
>   Creation Time : Thu Aug 10 10:15:18 2006
>      Raid Level : raid10
>      Array Size : 779264640 (743.16 GiB 797.97 GB)
>     Device Size : 779264640 (371.58 GiB 398.98 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 11
>     Persistence : Superblock is persistent
> 
>     Update Time : Thu Aug 10 13:14:44 2006
>           State : active, degraded, resyncing
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 1
> 
>          Layout : near=2, far=1
>      Chunk Size : 64K
> 
>  Rebuild Status : 39% complete
> 
>            Name : 11
>            UUID : 3f0bf25c:614339d1:31c006be:e823b74d
>          Events : 13
> 
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
>        3       8       50        3      active sync   /dev/sdd2
> 
>        4       8        2        -      spare   /dev/sda2
> 
> 
> So, I have 4 working devices, which include 3 active devices and one 
> spare device.
> 
> As I remember, with RAID-1, when I added a spare with "mdadm /dev/mdX -a 
> /dev/sdY", I would see a message "hot added /dev/sdY", and state "spare 
> rebuilding" in "mdadm --detail" output.
> 
> Right now I don't see the spare is being rebuilt? Spare HDD LED doesn't 
> blink either, so it would indicate that it's doing nothing.
> 
> Why? Is it because the rebuild status is not complete?

All right, it got "spare rebuilding" state after all other drives were 
rebuilt.


-- 
Tomasz Chmielewski
http://wpkg.org


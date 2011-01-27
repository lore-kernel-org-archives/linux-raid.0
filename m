From: NeilBrown <neilb@suse.de>
Subject: Re: mdXX: bitmap superblock UUID mismatch
Date: Fri, 28 Jan 2011 07:53:46 +1100
Message-ID: <20110128075346.4276e2d1@notabene.brown>
References: <AANLkTik83a9aEmywdcMEvpGwVMt_i=pS0dmg2s_o=EYG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik83a9aEmywdcMEvpGwVMt_i=pS0dmg2s_o=EYG@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Reynald Borer <reynald.borer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 26 Jan 2011 21:58:25 +0100 Reynald Borer <reynald.borer@gmail.com>
wrote:

> Hello guys,
> 
> I have been using md raids for quite a long time now and it always
> worked fine, until recently when I upgraded some hardware on my
> workstation. Unfortunately the hardware I changed proved itself to be
> very unstable, and I encountered a lot of hard lockups of the system
> while running. Those lockups recently made one of my raid 1 array
> fails with the infamous error message "mdXX: bitmap superblock UUID
> mismatch".
> 
> Here is what I have found in the kernel logs when I try to activate
> the given raid group:
> -----------------
> md/raid1:md126: active with 2 out of 2 mirrors
> md126: bitmap superblock UUID mismatch
> md126: bitmap file superblock:
>          magic: 6d746962
>        version: 4
>           uuid: 37102258.af9c1930.b8397fb8.eba356af
                           ^ this is an 'a'

>         events: 199168
> events cleared: 199166
>          state: 00000000
>      chunksize: 524288 B
>   daemon sleep: 5s
>      sync size: 248075584 KB
> max write behind: 0
> md126: failed to create bitmap (-22)
> -----------------
> 
> 
> Such error messages are displayed each time I try to run the raid
> group. Content of /proc/mdstat is:
> -----------------
> md126 : inactive sdb6[0] sda6[1]
>       496151168 blocks
> -----------------
> 
> 
> If I try to examine both disks with mdadm -E it shows some checksum
> mismatch for both partitions:
> -----------------
> root@bob # mdadm -E /dev/sda6
> /dev/sda6:
>           Magic : a92b4efc
>         Version : 0.90.03
>            UUID : 37102258:bf9c1930:b8397fb8:eba356af
                             ^ this is a 'b'

So you certainly do have some sick hardware!!!

I suggest that you find some hardware that you can trust,
mount one of the two devices ( (sdb6 or sda6) ignoring the raid stuff,
and copy data off to the device that you trust.

Then start again.

NeilBrown


>   Creation Time : Mon Aug  7 21:06:47 2006
>      Raid Level : raid1
>   Used Dev Size : 248075584 (236.58 GiB 254.03 GB)
>      Array Size : 248075584 (236.58 GiB 254.03 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 6
> 
>     Update Time : Wed Jan 12 00:12:44 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : e4883f8e - expected e4883e8e
>          Events : 199168
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     1       8       38        1      active sync
> 
>    0     0       8       70        0      active sync
>    1     1       8       38        1      active sync
> root@bob # mdadm -E /dev/sdb6
> /dev/sdb6:
>           Magic : a92b4efc
>         Version : 0.90.03
>            UUID : 37102258:bf9c1930:b8397fb8:eba356af
>   Creation Time : Mon Aug  7 21:06:47 2006
>      Raid Level : raid1
>   Used Dev Size : 248075584 (236.58 GiB 254.03 GB)
>      Array Size : 248075584 (236.58 GiB 254.03 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 6
> 
>     Update Time : Wed Jan 12 00:12:44 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : e4883fac - expected e4883eac
>          Events : 199168
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8       70        0      active sync
> 
>    0     0       8       70        0      active sync
>    1     1       8       38        1      active sync
> -----------------
> 
> 
> Any idea how I could try to save my raid group?
> 
> Thanks in advance for your help.
> 
> Best Regards,
> Reynald
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


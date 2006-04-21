From: Mike Hardy <mhardy@h3c.com>
Subject: Re: data recovery on raid5
Date: Fri, 21 Apr 2006 16:38:47 -0700
Message-ID: <44496D07.4070009@h3c.com>
References: <8867c2a014b34d9c11ce162c4f5860af@coraid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8867c2a014b34d9c11ce162c4f5860af@coraid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Hopkins <sah@coraid.com>
Cc: linux-raid@vger.kernel.org, jrs@abhost.net, support@coraid.com
List-Id: linux-raid.ids


Recreate the array from the constituent drives in the order you mention,
with 'missing' in place of the first drive that failed?

It won't resync because it has a missing drive.

If you created it correctly, the data will be there

If you didn't create it correctly, you can keep trying permutations of
4-disk arrays with one missing until you see your data, and you should
find it.

-Mike

Sam Hopkins wrote:
> Hello,
> 
> I have a client with a failed raid5 that is in desperate need of the
> data that's on the raid.  The attached file holds the mdadm -E
> superblocks that are hopefully the keys to the puzzle.  Linux-raid
> folks, if you can give any help here it would be much appreciated.
> 
> # mdadm -V
> mdadm - v1.7.0 - 11 August 2004
> # uname -a
> Linux hazel 2.6.13-gentoo-r5 #1 SMP Sat Jan 21 13:24:15 PST 2006 i686 Intel(R) Pentium(R) 4 CPU 2.40GHz GenuineIntel GNU/Linux
> 
> Here's my take:
> 
> Logfiles show that last night drive /dev/etherd/e0.4 failed and around
> noon today /dev/etherd/e0.0 failed.  This jibes with the superblock
> dates and info.
> 
> My assessment is that since the last known good configuration was
> 0 <missing>
> 1 /dev/etherd/e0.0
> 2 /dev/etherd/e0.2
> 3 /dev/etherd/e0.3
> 
> then we should shoot for this.  I couldn't figure out how to get there
> using mdadm -A since /dev/etherd/e0.0 isn't in sync with e0.2 or e0.3.
> If anyone can suggest a way to get this back using -A, please chime in.
> 
> The alternative is to recreate the array with this configuration hoping
> the data blocks will all line up properly so the filesystem can be mounted
> and data retrieved.  It looks like the following command is the right
> way to do this, but not being an expert I (and the client) would like
> someone else to verify the sanity of this approach.
> 
> Will
> 
> mdadm -C /dev/md0 -n 4 -l 5 missing /dev/etherd/e0.[023]
> 
> do what we want?
> 
> Linux-raid folks, please reply-to-all as we're probably all not on
> the list.
> 
> Thanks for your help,
> 
> Sam
> 
> 
> ------------------------------------------------------------------------
> 
> /dev/etherd/e0.0:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 8fe1fe85:eeb90460:c525faab:cdaab792
>   Creation Time : Mon Jan  3 03:16:48 2005
>      Raid Level : raid5
>     Device Size : 195360896 (186.31 GiB 200.05 GB)
>    Raid Devices : 4
>   Total Devices : 5
> Preferred Minor : 0
> 
>     Update Time : Fri Apr 21 12:45:07 2006
>           State : clean
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 1
>        Checksum : 4cc955da - correct
>          Events : 0.3488315
> 
>          Layout : left-asymmetric
>      Chunk Size : 32K
> 
>       Number   Major   Minor   RaidDevice State
> this     1     152        0        1      active sync   /dev/etherd/e0.0
> 
>    0     0       0        0        0      removed
>    1     1     152        0        1      active sync   /dev/etherd/e0.0
>    2     2     152       32        2      active sync   /dev/etherd/e0.2
>    3     3     152       48        3      active sync   /dev/etherd/e0.3
>    4     4     152       16        0      spare   /dev/etherd/e0.1
> /dev/etherd/e0.2:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 8fe1fe85:eeb90460:c525faab:cdaab792
>   Creation Time : Mon Jan  3 03:16:48 2005
>      Raid Level : raid5
>     Device Size : 195360896 (186.31 GiB 200.05 GB)
>    Raid Devices : 4
>   Total Devices : 5
> Preferred Minor : 0
> 
>     Update Time : Fri Apr 21 14:03:12 2006
>           State : clean
>  Active Devices : 2
> Working Devices : 3
>  Failed Devices : 3
>   Spare Devices : 1
>        Checksum : 4cc991e9 - correct
>          Events : 0.3493633
> 
>          Layout : left-asymmetric
>      Chunk Size : 32K
> 
>       Number   Major   Minor   RaidDevice State
> this     2     152       32        2      active sync   /dev/etherd/e0.2
> 
>    0     0       0        0        0      removed
>    1     1       0        0        1      faulty removed
>    2     2     152       32        2      active sync   /dev/etherd/e0.2
>    3     3     152       48        3      active sync   /dev/etherd/e0.3
>    4     4     152       16        4      spare   /dev/etherd/e0.1
> /dev/etherd/e0.3:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 8fe1fe85:eeb90460:c525faab:cdaab792
>   Creation Time : Mon Jan  3 03:16:48 2005
>      Raid Level : raid5
>     Device Size : 195360896 (186.31 GiB 200.05 GB)
>    Raid Devices : 4
>   Total Devices : 5
> Preferred Minor : 0
> 
>     Update Time : Fri Apr 21 14:03:12 2006
>           State : clean
>  Active Devices : 2
> Working Devices : 3
>  Failed Devices : 3
>   Spare Devices : 1
>        Checksum : 4cc991fb - correct
>          Events : 0.3493633
> 
>          Layout : left-asymmetric
>      Chunk Size : 32K
> 
>       Number   Major   Minor   RaidDevice State
> this     3     152       48        3      active sync   /dev/etherd/e0.3
> 
>    0     0       0        0        0      removed
>    1     1       0        0        1      faulty removed
>    2     2     152       32        2      active sync   /dev/etherd/e0.2
>    3     3     152       48        3      active sync   /dev/etherd/e0.3
>    4     4     152       16        4      spare   /dev/etherd/e0.1
> /dev/etherd/e0.4:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 8fe1fe85:eeb90460:c525faab:cdaab792
>   Creation Time : Mon Jan  3 03:16:48 2005
>      Raid Level : raid5
>     Device Size : 195360896 (186.31 GiB 200.05 GB)
>    Raid Devices : 4
>   Total Devices : 5
> Preferred Minor : 0
> 
>     Update Time : Thu Apr 20 21:07:50 2006
>           State : clean
>  Active Devices : 4
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 1
>        Checksum : 4cc84d59 - correct
>          Events : 0.3482550
> 
>          Layout : left-asymmetric
>      Chunk Size : 32K
> 
>       Number   Major   Minor   RaidDevice State
> this     0     152       64        0      active sync   /dev/etherd/e0.4
> 
>    0     0     152       64        0      active sync   /dev/etherd/e0.4
>    1     1     152        0        1      active sync   /dev/etherd/e0.0
>    2     2     152       32        2      active sync   /dev/etherd/e0.2
>    3     3     152       48        3      active sync   /dev/etherd/e0.3
>    4     4     152       16        4      spare   /dev/etherd/e0.1

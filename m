From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Raid1 where Event Count off my 1 cannot assemble --force
Date: Mon, 09 Dec 2013 11:52:18 +1100
Message-ID: <52A51442.1000903@websitemanagers.com.au>
References: <52A44778.8040502@suddenlinkmail.com> <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se> <52A4B311.6040204@suddenlinkmail.com> <52A51122.3030604@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A51122.3030604@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/12/13 11:38, David C. Rankin wrote:
> On 12/08/2013 11:57 AM, David C. Rankin wrote:
>> On 12/08/2013 04:57 AM, Mikael Abrahamsson wrote:
>>> On Sun, 8 Dec 2013, David C. Rankin wrote:
>>>
>>>> Guys,
>>>>
>>>>   I have an older box that is a fax server where the Event Count for /dev/md1 is
>>>> off by 1, but the array cannot be reassembled with --assemble --force /dev/dm1
>>>> /dev/sda5 /dev/sdb5.
> Here is additional information with --verbose given:

Have you tried this:

mdadm --verbose --assemble /dev/md1 /dev/sdb5
mdadm --manage /dev/md1 --run

Being raid1, you should be able to use only a single device....


BTW, chances to recover your data should be exceptional, as long as you 
don't do anything too silly. You should even be able to mount the device 
directly (read-only):
mount -o ro /dev/sdb5 /mnt

(Depending on the content is a filesystem).
Then you can just backup the data, create a new array, and restore the 
data. Depending on data and size this might even be a better option...


>    Here is the --detail and --examine information for the drives for completeness:
>
> nemtemp:~ # mdadm --detail /dev/md1
> /dev/md1:
>          Version : 01.00.03
>    Creation Time : Thu Aug 21 06:43:22 2008
>       Raid Level : raid1
>    Used Dev Size : 20972752 (20.00 GiB 21.48 GB)
>     Raid Devices : 2
>    Total Devices : 2
> Preferred Minor : 1
>      Persistence : Superblock is persistent
>
>      Update Time : Tue Nov 19 15:28:38 2013
>            State : active, Not Started
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 0
>
>             Name : 1
>             UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
>           Events : 148
>
>      Number   Major   Minor   RaidDevice State
>         0       8        5        0      active sync   /dev/sda5
>         1       8       21        1      active sync   /dev/sdb5
>
> nemtemp:/ # mdadm -E /dev/sda5
> /dev/sda5:
>            Magic : a92b4efc
>          Version : 1.0
>      Feature Map : 0x1
>       Array UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
>             Name : 1
>    Creation Time : Thu Aug 21 06:43:22 2008
>       Raid Level : raid1
>     Raid Devices : 2
>
>   Avail Dev Size : 41945504 (20.00 GiB 21.48 GB)
>       Array Size : 41945504 (20.00 GiB 21.48 GB)
>     Super Offset : 41945632 sectors
>            State : clean
>      Device UUID : e0c1c580:db4d853e:6fac1c8f:fb5399d7
>
> Internal Bitmap : -81 sectors from superblock
>      Update Time : Tue Nov 19 15:28:38 2013
>         Checksum : d37d1086 - correct
>           Events : 148
>
>
>      Array Slot : 0 (0, 1)
>     Array State : Uu
>
> nemtemp:/ # mdadm -E /dev/sdb5
> /dev/sdb5:
>            Magic : a92b4efc
>          Version : 1.0
>      Feature Map : 0x1
>       Array UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
>             Name : 1
>    Creation Time : Thu Aug 21 06:43:22 2008
>       Raid Level : raid1
>     Raid Devices : 2
>
>   Avail Dev Size : 41945504 (20.00 GiB 21.48 GB)
>       Array Size : 41945504 (20.00 GiB 21.48 GB)
>     Super Offset : 41945632 sectors
>            State : active
>      Device UUID : 6edfa3f8:c8c4316d:66c19315:5eda0911
>
> Internal Bitmap : -81 sectors from superblock
>      Update Time : Tue Nov 19 15:28:38 2013
>         Checksum : 39ef40a5 - correct
>           Events : 149
>
>
>      Array Slot : 1 (0, 1)
>     Array State : uU

BTW, the bitmap location looks.... strange...



Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au

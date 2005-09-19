From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: assembly aborted, superblock is missing. (need help!)
Date: Mon, 19 Sep 2005 17:27:17 -0500
Message-ID: <432F3B45.1010304@us.ibm.com>
References: <6d5bedd8050915131148b8108a@mail.gmail.com> <200509162258.37730.a1426z@gawab.com> <432D3024.3080302@dtbb.net> <200509181426.33327.a1426z@gawab.com> <008801c5bc54$b9fd57f0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008801c5bc54$b9fd57f0$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Janos,

The problem with disappearing MD superblock must be investigated. :(

It is safe to re-create the raid0 array:
mdadm -C /dev/md31 -l 0 -c 32 -n 4 /dev/md1 /dev/md2 /dev/md3 /dev/md4

--
Regards,
Mike Tran

JaniD++ wrote:

>Hello list!
>
>I have try to switch from 2.6.13 to 14-rc1, but this kernel breaks my
>device!
>
>The problem:
># mdadm -A -R -f  /dev/md31 /dev/md1 /dev/md2 /dev/md3 /dev/md4
>mdadm: no RAID superblock on /dev/md1
>mdadm: /dev/md1 has no superblock - assembly aborted
>
>
>md31 is a 8TB raid0 device.
>
>the 2. dev:
># mdadm -E /dev/md2
>/dev/md2:
>          Magic : a92b4efc
>        Version : 00.90.02
>           UUID : 9a99d340:ab8f6bfc:bc8d42ed:79ce440e
>  Creation Time : Sun Jul 17 19:50:11 2005
>     Raid Level : raid0
>    Device Size : 1953583232 (1863.08 GiB 2000.47 GB)
>   Raid Devices : 4
>  Total Devices : 4
>Preferred Minor : 31
>
>    Update Time : Sun Jul 17 19:50:11 2005
>          State : active
> Active Devices : 4
>Working Devices : 4
> Failed Devices : 0
>  Spare Devices : 0
>       Checksum : 1fd71b51 - correct
>         Events : 0.2
>
>     Chunk Size : 32K
>
>      Number   Major   Minor   RaidDevice State
>this     1       9        2        1      active sync   /dev/md2
>
>   0     0       9        1        0      active sync   /dev/md1
>   1     1       9        2        1      active sync   /dev/md2
>   2     2       9        3        2      active sync   /dev/md3
>   3     3       9        4        3      active sync   /dev/md4
>
>the 3. dev:
>
># mdadm -E /dev/md3
>/dev/md3:
>          Magic : a92b4efc
>        Version : 00.90.02
>           UUID : 9a99d340:ab8f6bfc:bc8d42ed:79ce440e
>  Creation Time : Sun Jul 17 19:50:11 2005
>     Raid Level : raid0
>    Device Size : 1953583232 (1863.08 GiB 2000.47 GB)
>   Raid Devices : 4
>  Total Devices : 4
>Preferred Minor : 31
>
>    Update Time : Sun Jul 17 19:50:11 2005
>          State : active
> Active Devices : 4
>Working Devices : 4
> Failed Devices : 0
>  Spare Devices : 0
>       Checksum : 1fd71b54 - correct
>         Events : 0.2
>
>     Chunk Size : 32K
>
>      Number   Major   Minor   RaidDevice State
>this     2       9        3        2      active sync   /dev/md3
>
>   0     0       9        1        0      active sync   /dev/md1
>   1     1       9        2        1      active sync   /dev/md2
>   2     2       9        3        2      active sync   /dev/md3
>   3     3       9        4        3      active sync   /dev/md4
>
>
>
>the 4.dev:
>
># mdadm -E /dev/md4
>/dev/md4:
>          Magic : a92b4efc
>        Version : 00.90.02
>           UUID : 9a99d340:ab8f6bfc:bc8d42ed:79ce440e
>  Creation Time : Sun Jul 17 19:50:11 2005
>     Raid Level : raid0
>    Device Size : 1953583232 (1863.08 GiB 2000.47 GB)
>   Raid Devices : 4
>  Total Devices : 4
>Preferred Minor : 31
>
>    Update Time : Sun Jul 17 19:50:11 2005
>          State : active
> Active Devices : 4
>Working Devices : 4
> Failed Devices : 0
>  Spare Devices : 0
>       Checksum : 1fd71b57 - correct
>         Events : 0.2
>
>     Chunk Size : 32K
>
>      Number   Major   Minor   RaidDevice State
>this     3       9        4        3      active sync   /dev/md4
>
>   0     0       9        1        0      active sync   /dev/md1
>   1     1       9        2        1      active sync   /dev/md2
>   2     2       9        3        2      active sync   /dev/md3
>   3     3       9        4        3      active sync   /dev/md4
>
>
>but the md1 (the first dev) is this:
># mdadm -E /dev/md1
>mdadm: No super block found on /dev/md1 (Expected magic a92b4efc, got
>56dfa32e)
>
>
>How can I fix this?
>Can somebody help?
>
>Thanks
>Janos
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>



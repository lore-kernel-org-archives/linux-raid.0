From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: journal disk become the first of --detail list after fail/remove
 one disk
Date: Thu, 4 Aug 2016 21:34:49 +1000
Message-ID: <8ca13969-9e4f-b01e-6456-68a23512836f@websitemanagers.com.au>
References: <1933083404.11265226.1470307932889.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1933083404.11265226.1470307932889.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yi Zhang <yizhan@redhat.com>, linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, shli@fb.com, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids



On 4/08/2016 20:52, Yi Zhang wrote:
> # mdadm -D /dev/md0
> /dev/md0:
>          Version : 1.2
>    Creation Time : Thu Aug  4 18:42:19 2016
>       Raid Level : raid4
>       Array Size : 3139584 (2.99 GiB 3.21 GB)
>    Used Dev Size : 523264 (511.00 MiB 535.82 MB)
>     Raid Devices : 7
>    Total Devices : 7
>      Persistence : Superblock is persistent
>
>    Intent Bitmap : Internal
>
>      Update Time : Thu Aug  4 18:43:22 2016
>            State : clean, degraded
>   Active Devices : 6
> Working Devices : 7
>   Failed Devices : 0
>    Spare Devices : 1
>
>       Chunk Size : 512K
>
>             Name : dhcp-12-125.nay.redhat.com:0  (local to host dhcp-12-125.nay.redhat.com)
>             UUID : 29a267c2:04e91998:639e6eef:64ddbab0
>           Events : 23
>
>      Number   Major   Minor   RaidDevice State
>         7       7        0        -      journal   /dev/loop0
>         1       7        2        1      active sync   /dev/loop2
>         2       7        3        2      active sync   /dev/loop3
>         3       7        4        3      active sync   /dev/loop4
>         4       7        5        4      active sync   /dev/loop5
>         5       7        6        5      active sync   /dev/loop6
>         8       7        7        6      active sync   /dev/loop7
>

I'm not really sure about the journal/your report, but also why does the 
above show 1 spare device? I would expect spare should mean that there 
is a device available to take over automatically if one of the active 
devices becomes faulty, but that doesn't seem to be the case. Should a 
journal device be counted as Active & Working (or faulty) instead of Spare?

Regards,
Adam

From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: accidently pulled to many devices, raid6 wont start.
Date: Thu, 05 Dec 2013 17:00:06 +0100
Message-ID: <52A0A306.9070401@fastmail.fm>
References: <BLU0-SMTP16236357B62A13D8FFAC14198D70@phx.gbl>	 <52A08162.3080706@fastmail.fm>	 <BLU0-SMTP2081DE3677BA1FD887C35BC98D70@phx.gbl>	 <52A08E50.30609@fastmail.fm> <BLU0-SMTP3325A7BDB48F7600841601398D70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP3325A7BDB48F7600841601398D70@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/05/2013 04:48 PM, Wilson Jonathan wrote:
> Still the same problem, lists non partitioned space, unknown, unknown,
> un partitioned.
>
> I wonder if the problem is because i'm not re-creating it with bitmap
> file, which is listed as starting 8 sectors from superblock, so with it
> not being there the partition table is being read from this space and
> not further along the space.

The bitmap is supposed to be in the gap between data and superblock.

>
> Infact, looking at the re-created superblock there is a change...
>
> /dev/sde6:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 1c413162:25c7b4af:7b305603:1ce49fed
>             Name : BorgCUBE:5  (local to host BorgCUBE)
>    Creation Time : Thu Dec  5 00:28:11 2013
>       Raid Level : raid6
>     Raid Devices : 6
>
>   Avail Dev Size : 1833309583 (874.19 GiB 938.65 GB)
>       Array Size : 3666617344 (3496.76 GiB 3754.62 GB)
>    Used Dev Size : 1833308672 (874.19 GiB 938.65 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : de841586:f82b22ed:1a234ae7:57fbb36a
>
>      Update Time : Thu Dec  5 00:28:11 2013
>         Checksum : 9dcbeec1 - correct
>           Events : 0
>
>           Layout : left-symmetric
>       Chunk Size : 64K
>
> The "data offset" is 262144 where as the sdc (original) is 2048

Seems to be a new mdadm version with different default values. Another 
reason not to use '--create' unless there is really no other way. Try to 
add --data-offset=1M.


Cheers,
Bernd


PS: Btw, for assemble the order of devices doesn't matter, the kernel 
know the correct order from their superblocks...

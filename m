From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: WD nas broke can't accessmy files on RAID 1
Date: Sat, 21 Oct 2017 15:17:45 +0100
Message-ID: <001ecd43-c770-4abe-5ded-57377c843d5d@youngman.org.uk>
References: <CAKNaYNuY8gNn+u4uMK8U+AnnYMmH8GNPDJGWTG1SNrQpDG4kjA@mail.gmail.com>
 <bfbf59c2-c750-f87b-5167-37c84086bb75@youngman.org.uk>
 <CAKNaYNtK+-1JXmLQk0zcX1HrAiczVAoFCKTmJQuG5FexxwRGPg@mail.gmail.com>
 <CAKNaYNusb-iQN3V4an8Hs_s+gD4m_n4yC1o2=VxY081-T+SHNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKNaYNusb-iQN3V4an8Hs_s+gD4m_n4yC1o2=VxY081-T+SHNQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Francesco Tomadin <inamaru94@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/10/17 14:17, Francesco Tomadin wrote:
> Okay with some troubles, I managed to understand something.
> What I did after installing mbadm is using the command sudo fdisk -l
> After that i got a bunch of data, but I guess this is what I needed to know.
> 
It's getting me a little confused too - I tend to be a "first responder" 
and pick up the easy stuff, complicated stuff waits for people who've 
done far more digging than I have :-)

This actually looks like it'll be a dead easy recovery, but there's too 
many little "gotchas" for me to want to do more than explain what's 
happened, and let someone else fix it.

> Disk /dev/sdc: 3.7 TiB, 4000787030016 bytes, 7814037168 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 33553920 bytes
> Disklabel type: gpt
> Disk identifier: 560070A2-CB61-4416-BC11-E4F7C2E28388
> 
> Device          Start        End    Sectors  Size Type
> /dev/sdc1        2048    4196351    4194304    2G Linux swap
> /dev/sdc2     6293504 7811938303 7805644800  3.7T Microsoft basic data
> /dev/sdc3  7811938304 7814037134    2098831    1G Microsoft basic data
> /dev/sdc4     4196352    6293503    2097152    1G Microsoft basic data
> 
Okay. Does this mean your NAS had four 4TB drives in it?

You said one drive was in JBOD mode. Did you set it up this way, or is 
this how it ended up after the failure? It looks to me as though this 
drive failed, was kicked out of the array, and that's why you can access 
it in JBOD. Any chance of you running "smartctl -x" on it? I strongly 
suspect that will come back with "SCT/ERC not supported" :-( If it does 
that's great news for recovering your array, but maybe bad news for your 
wallet :-)
> 
> After this I tried to run --examine:
> 
> ubuntu@ubuntu:~$ sudo mdadm --examine /dev/sdc
> /dev/sdc:
>     MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> 
> ubuntu@ubuntu:~$ sudo mdadm --examine /dev/sdc1
> /dev/sdc1:
>            Magic : a92b4efc
>          Version : 0.90.00
>             UUID : 2da381ee:0105a2ee:40130e04:e0c90235
>    Creation Time : Fri Oct 20 16:57:14 2017
>       Raid Level : raid1
>    Used Dev Size : 2097088 (2048.28 MiB 2147.42 MB)
>       Array Size : 2097088 (2048.28 MiB 2147.42 MB)
>     Raid Devices : 4
>    Total Devices : 3
> Preferred Minor : 0
> 
>      Update Time : Fri Oct 20 16:57:32 2017
>            State : clean
> Internal Bitmap : present
>   Active Devices : 3
> Working Devices : 3
>   Failed Devices : 1
>    Spare Devices : 0
>         Checksum : aca4dbd2 - correct
>           Events : 6
> 
> 
>        Number   Major   Minor   RaidDevice State
> this     1       8       33        1      active sync   /dev/sdc1
> 
>     0     0       8       17        0      active sync
>     1     1       8       33        1      active sync   /dev/sdc1
>     2     2       8        1        2      active sync   /dev/sda1
>     3     3       0        0        3      faulty removed
> 
> 
> ubuntu@ubuntu:~$ sudo mdadm --examine /dev/sdc2
> /dev/sdc2:
>            Magic : a92b4efc
>          Version : 1.0
>      Feature Map : 0x1
>       Array UUID : 4bc3cfef:db0ae9ef:2bceeae9:ac2bbee2
>             Name : 1
>    Creation Time : Mon Nov  7 13:04:44 2016
>       Raid Level : raid1
>     Raid Devices : 2
> 
>   Avail Dev Size : 7805644528 (3722.02 GiB 3996.49 GB)
>       Array Size : 3902822264 (3722.02 GiB 3996.49 GB)
>     Super Offset : 7805644784 sectors
>     Unused Space : before=0 sectors, after=256 sectors
>            State : clean
>      Device UUID : d23ca413:64d7dec5:d938d9d6:b11d2d26
> 
> Internal Bitmap : 2 sectors from superblock
>      Update Time : Fri Oct 20 08:43:02 2017
>         Checksum : 5124c394 - correct
>           Events : 3
> 
> 
>     Device Role : Active device 1
>     Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
> 
Okay. I'm puzzled. sdc1, the "linux swap" array, is clearly broken. 
Hopefully, this is what's causing the whole thing to fall over, because 
if we lose the contents of that we couldn't care less.

sdc2, which I'm guessing is your data, looks healthy. Get the NAS 
working properly, and that will just come straight back.

As I say, try and get a "smartctl -x", but at this point I'll bow out 
and let somebody who knows more than I do take over. But it does look 
VERY promising.

Cheers,
Wol


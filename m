From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Fri, 15 Feb 2013 22:10:55 +1100
Message-ID: <511E17BF.5030301@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <51157141.90205@hardwarefreak.com> <9ABA2459-DB04-40CA-996E-D02FEE43291B@colorremedies.com> <511D8AEF.8040202@websitemanagers.com.au> <80A5C958-6E76-49BD-9CDC-3E8705B401C5@colorremedies.com> <511DB326.1090406@websitemanagers.com.au> <C0297DA6-F16C-4527-A129-050C3BD6121D@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C0297DA6-F16C-4527-A129-050C3BD6121D@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>, "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>
List-Id: linux-raid.ids

On 15/02/13 16:14, Chris Murphy wrote:
> 
> On Feb 14, 2013, at 9:01 PM, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:
> 
>> Would it be a sequence like this:
>> fdisk /dev/sdb
>> d <- delete the existing partition
>> u <- change units
>> n <- new partition
>> p <- primary
>> 1 <- partition 1
>> 64 <- start sector 64
>> xxx <- end size of partition
>>
>> Will that make it right?
> 
> Yes.

OK, so I've started this process, with some unexpected results...
First, this is how the partition looks now:
Disk /dev/sdb: 480 GB, 480101368320 bytes
255 heads, 63 sectors/track, 58369 cylinders, total 937697985 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              64   931770000   465893001   fd  Lnx RAID auto
Warning: Partition 1 does not end on cylinder boundary.

I'm not sure why I get that warning, or if it should worry me... I
suppose I can always extend it a bit bigger if there is any problem with
this?

Initially, I made sure the secondary san was in sync with DRBD, and all
users were logged off the system. I was getting a max of around 50MB/sec
from the RAID resync.

So I shutdown all the windows machines, and this went up to a max of
150MB/sec.

Finally, I stopped DRBD on both the secondary and the primary, so now
the RAID device is completely unused, and it is topping out at 213M/sec...

Personalities : [raid6] [raid5] [raid4]
md1 : active raid5 sdb1[6] sdc1[0] sde1[4] sdf1[5] sdd1[3]
      1863535104 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/4]
[U_UUU]
      [=============>.......]  recovery = 68.4% (318672880/465883776)
finish=12.3min speed=198212K/sec
      bitmap: 3/4 pages [12KB], 65536KB chunk


It was topping out at 200, but I adjusted
/proc/sys/dev/raid/speed_limit_max to 400000

top shows this:
top - 22:06:41 up 1 day, 17:22,  3 users,  load average: 1.08, 1.07, 1.06
Tasks: 177 total,   2 running, 175 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.1%us,  0.7%sy,  0.0%ni, 99.1%id,  0.0%wa,  0.0%hi,  0.1%si,
0.0%st
Mem:   7903292k total,  1370132k used,  6533160k free,   131796k buffers
Swap:  3939320k total,        0k used,  3939320k free,   939728k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND


  425 root      20   0     0    0    0 S   26  0.0  20:27.27 md1_raid5


26236 root      20   0     0    0    0 R   17  0.0   4:22.30 md1_resync


   27 root      20   0     0    0    0 S    0  0.0   7:17.68 events/0



also vmstat 5 shows this...
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 2  0      0 6532916 131820 939744    0    0   410   121   32    6  0  0
99  0
 0  0      0 6533512 131824 939744    0    0     0    13 28280 28796  0
 1 99  0
 1  0      0 6533300 131832 939744    0    0     0    13 25842 26591  0
 1 99  0
 1  0      0 6533864 131836 939748    0    0     0     8 30910 31189  0
 1 99  0

So it seems CPU is idle, but I'm curious why I don't see somewhat higher
write speeds... I thought I should see something close to 300 or
400MB/sec, or was I just plain wrong?

Just a reminder, these are the Intel 320 series 480G SSD's.

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

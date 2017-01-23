From: Jake Yao <jgyao1@gmail.com>
Subject: Re: performance of raid5 on fast devices
Date: Mon, 23 Jan 2017 17:20:42 -0500
Message-ID: <CA+Dh761AoRa3g3O4hztTACe5M1sbNRz3_hQQKgikupxLNLVQ8g@mail.gmail.com>
References: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
 <20170117101043.78e80bdc@natsu> <CA+Dh763Ttvnt9CSEUZ0QwPOLCaZq6VVXmj4OoheR7WTO6o4Pbw@mail.gmail.com>
 <27fb7a94-27d0-b319-30b8-daf4dab97415@redhat.com> <CA+Dh761U6J6UKsGBD8dLfBR0bQHjK5T3tj3tTv889BAQWncxfw@mail.gmail.com>
 <a7cf3ce7-688d-819c-60ab-a9b53e14d869@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a7cf3ce7-688d-819c-60ab-a9b53e14d869@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I run tests with multiple IO threads, but it looks like it does not
affect the overall performance.

In this run with 8 io threads,

[global]
ioengine=3Dlibaio
iodepth=3D64
bs=3D192k
direct=3D1
thread=3D1
time_based=3D1
runtime=3D20
numjobs=3D8
loops=3D1
group_reporting=3D1
rwmixread=3D70
rwmixwrite=3D30
exitall
#
# end of global
#
[nvme_md_write]
rw=3Dwrite
filename=3D/dev/md127
runtime=3D20

[nvme_drv_write]
rw=3Dwrite
filename=3D/dev/nvme1n1p2
runtime=3D20

I got following for nvme based raid5 and single drive:

md thrd-cnt 0: write: io=3D27992MB, bw=3D1397.5MB/s, iops=3D7452, runt=3D 2=
0031msec
md thrd-cnt 1: write: io=3D43065MB, bw=3D2148.6MB/s, iops=3D11458, runt=3D =
20044msec
md thrd-cnt 2: write: io=3D43209MB, bw=3D2155.9MB/s, iops=3D11497, runt=3D =
20043msec
md thrd-cnt 3: write: io=3D43163MB, bw=3D2153.9MB/s, iops=3D11487, runt=3D =
20040msec
md thrd-cnt 4: write: io=3D43316MB, bw=3D2163.2MB/s, iops=3D11536, runt=3D =
20024msec
md thrd-cnt 5: write: io=3D43390MB, bw=3D2164.7MB/s, iops=3D11544, runt=3D =
20045msec
md thrd-cnt 6: write: io=3D43295MB, bw=3D2160.2MB/s, iops=3D11521, runt=3D =
20042msec
single drive: write: io=3D36004MB, bw=3D1795.4MB/s, iops=3D9575, runt=3D 20=
054msec

It also does not show little effect on ssd based raid5 and single
drive. Same fio config as above, just changing the corresponding
device filenames. The result is following:

md thrd-cnt 0: write: io=3D13646MB, bw=3D696242KB/s, iops=3D3626, runt=3D 2=
0070msec
md thrd-cnt 1: write: io=3D24519MB, bw=3D1221.5MB/s, iops=3D6514, runt=3D 2=
0074msec
md thrd-cnt 2: write: io=3D24780MB, bw=3D1234.9MB/s, iops=3D6585, runt=3D 2=
0068msec
md thrd-cnt 3: write: io=3D24890MB, bw=3D1240.2MB/s, iops=3D6613, runt=3D 2=
0072msec
md thrd-cnt 4: write: io=3D24937MB, bw=3D1242.5MB/s, iops=3D6626, runt=3D 2=
0071msec
md thrd-cnt 5: write: io=3D24948MB, bw=3D1242.9MB/s, iops=3D6628, runt=3D 2=
0073msec
md thrd-cnt 6: write: io=3D24701MB, bw=3D1230.1MB/s, iops=3D6564, runt=3D 2=
0068msec
single drive: write: io=3D8389.4MB, bw=3D428184KB/s, iops=3D2230, runt=3D 2=
0063msec

In the ssd case, raid5 array is 3x better than a single drive.

On Fri, Jan 20, 2017 at 9:58 AM, Coly Li <colyli@suse.de> wrote:
> On 2017/1/19 =E4=B8=8A=E5=8D=883:25, Jake Yao wrote:
>> It is interesting. I do not see the similar behavior with the change
>> of group_thread_cnt.
>>
>> The raid5 I have is following:
>>
>> md125 : active raid5 nvme0n1p1[0] nvme2n1p1[2] nvme1n1p1[1] nvme3n1p1[4]
>>       943325184 blocks super 1.2 level 5, 32k chunk, algorithm 2 [4/4] [=
UUUU]
>>       bitmap: 0/3 pages [0KB], 65536KB chunk
>>
>> /dev/md125:
>>         Version : 1.2
>>   Creation Time : Thu Dec 15 20:11:46 2016
>>      Raid Level : raid5
>>      Array Size : 943325184 (899.63 GiB 965.96 GB)
>>   Used Dev Size : 314441728 (299.88 GiB 321.99 GB)
>>    Raid Devices : 4
>>   Total Devices : 4
>>     Persistence : Superblock is persistent
>>
>>   Intent Bitmap : Internal
>>
>>     Update Time : Wed Jan 18 16:24:52 2017
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 32K
>>
>>            Name : localhost:nvme  (local to host localhost)
>>            UUID : 477a94af:79f5a10a:0d513dc6:7f5e670d
>>          Events : 108
>>
>>     Number   Major   Minor   RaidDevice State
>>        0     259        6        0      active sync   /dev/nvme0n1p1
>>        1     259        8        1      active sync   /dev/nvme1n1p1
>>        2     259        9        2      active sync   /dev/nvme2n1p1
>>        4     259        1        3      active sync   /dev/nvme3n1p1
>>
>> The fio config is:
>>
>> [global]
>> ioengine=3Dlibaio
>> iodepth=3D64
>> bs=3D96K
>> direct=3D1
>> thread=3D1
>> time_based=3D1
>> runtime=3D20
>> numjobs=3D1
>
> You only have 1 I/O thread, bottle neck is here. Have a try with numjobs=
=3D8.
>
>> loops=3D1
>> group_reporting=3D1
>> exitall
> [snip]
>
> Coly

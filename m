From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: major performance drop on raid5 due to context switches caused
 by small max_hw_sectors [partially resolved]
Date: Sun, 22 Apr 2007 04:47:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0704220446530.10830@p34.internal.lan>
References: <200704202306.14880.dap@mail.index.hu> <200704212132.13775.dap@mail.index.hu>
 <Pine.LNX.4.64.0704212017110.25079@p34.internal.lan> <200704220242.42285.dap@mail.index.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200704220242.42285.dap@mail.index.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Pallai Roland <dap@mail.index.hu>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Sun, 22 Apr 2007, Pallai Roland wrote:

>
> On Sunday 22 April 2007 02:18:09 Justin Piszcz wrote:
>> On Sat, 21 Apr 2007, Pallai Roland wrote:
>>>
>>> RAID5, chunk size 128k:
>>>
>>> # mdadm -C -n8 -l5 -c128 -z 12000000 /dev/md/0 /dev/sd[ijklmnop]
>>> (waiting for sync, then mount, mkfs, etc)
>>> # blockdev --setra 4096 /dev/md/0
>>> # ./readtest &
>>> procs -----------memory---------- ---swap-- -----io---- --system--
>>> ----cpu---- r  b   swpd   free   buff  cache   si   so    bi    bo   in
>>>  cs us sy id wa 91 10      0 432908      0 436572    0    0 99788    40
>>> 2925 50358  2 36  0 63 0 11      0 444184      0 435992    0    0 89996
>>>  32 4252 49303  1 31  0 68 45 11      0 446924      0 441024    0    0
>>> 88584     0 5748 58197  0 30  2 67 - context switch storm, only 10 of 100
>>> processes are working, lot of thrashed readahead pages. I'm sure you can
>>> reproduce with 64Kb max_sectors_kb and 2.6.20.x on *any* 8 disk-wide
>>> RAID5 array if chunk size > max_sectors_kb: for i in `seq 1 100`; do dd
>>> of=$i if=/dev/zero bs=64k 2>/dev/null; done for i in `seq 1 100`; do dd
>>> if=$i of=/dev/zero bs=64k 2>/dev/null & done
>>>
>>>
>>> RAID5, chunk size 64k (equal to max_hw_sectors):
>>>
>>> # mdadm -C -n8 -l5 -c64 -z 12000000 /dev/md/0 /dev/sd[ijklmnop]
>>> (waiting for sync, then mount, mkfs, etc)
>>> # blockdev --setra 4096 /dev/md/0
>>> # ./readtest &
>>> procs -----------memory---------- ---swap-- -----io---- --system--
>>> ----cpu---- r  b   swpd   free   buff  cache   si   so    bi    bo   in
>>>  cs us sy id wa 1 99      0 309260      0 653000    0    0 309620     0
>>> 4521  2897  0 17  0 82 1 99      0 156436      0 721452    0    0 258072
>>>    0 4640  3168  0 14  0 86 0 100     0 244088      0 599888    0    0
>>> 258856     0 4703  3986  1 17  0 82 - YES! It's MUCH better now! :)
>>>
>>>
>>> All in all, I use 64Kb chunk now and I'm happy, but I think it's
>>> definitely a software bug. The sata_mv driver also doesn't give bigger
>>> max_sectors_kb on Marvell chips, so it's a performance killer for every
>>> Marvell user if they're using 128k or bigger chunks on RAID5. A warning
>>> should be printed by the kernel at least if it's not a bug, just a
>>> limitation.
>>>
>>>
>>
>> How did you run your read test?
>>
>> $ sudo dd if=/dev/md3 of=/dev/null
>> Password:
>> 18868881+0 records in
>> 18868880+0 records out
>> 9660866560 bytes (9.7 GB) copied, 36.661 seconds, 264 MB/s
>>
>> procs -----------memory---------- ---swap-- -----io---- -system--
>> ----cpu---- r  b   swpd   free   buff  cache   si   so    bi    bo   in
>> cs us sy id wa 2  0      0 3007612 251068  86372    0    0 243732     0
>> 3109  541 15 38 47  0 1  0      0 3007724 282444  86344    0    0 260636
>>  0 3152  619 14 38 48  0 1  0      0 3007472 282600  86400    0    0 262188
>>     0 3153  339 15 38 48  0 1  0      0 3007432 282792  86360    0    0
>> 262160    67 3197 1066 14 38 47  0
>>
>> However--
>>
>> $ sudo dd if=/dev/md3 of=/dev/null bs=8M
>> 763+0 records in
>> 762+0 records out
>> 6392119296 bytes (6.4 GB) copied, 14.0555 seconds, 455 MB/s
>>
>> procs -----------memory---------- ---swap-- -----io---- -system--
>> ----cpu---- 0  1      0 2999592 282408  86388    0    0 434208     0 4556
>> 1514  0 43 43 15 1  0      0 2999892 262928  86552    0    0 439816    68
>> 4568 2412  0 43 43 14 1  1      0 2999952 281832  86532    0    0 444992
>>  0 4604 1486  0 43 43 14 1  1      0 2999708 282148  86456    0    0 458752
>>     0 4642 1694  0 45 42 13
>
> I did run 100 parallel reader process (dd) top of XFS file system, try this:
> for i in `seq 1 100`; do dd of=$i if=/dev/zero bs=64k 2>/dev/null; done
> for i in `seq 1 100`; do dd if=$i of=/dev/zero bs=64k 2>/dev/null & done
>
> and don't forget to set max_sectors_kb below chunk size (eg. 64/128Kb)
> /sys/block# for i in sd*; do echo 64 >$i/queue/max_sectors_kb; done
>
> I also set 2048/4096 readahead sectors with blockdev --setra
>
> You need 50-100 reader processes for this issue, I think so. My kernel version
> is 2.6.20.3
>
>
> --
> d
>

In one xterm:
for i in `seq 1 100`; do dd of=$i if=/dev/zero bs=64k 2>/dev/null; done

In another:
for i in `seq 1 100`; do dd if=/dev/md3 of=$i.out bs=64k & done

Results:
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  1 79    104  54908 169772 3096180    0    0   340 120944 3062 9220  0 37  0 63
  9 72    104  70588 155356 3095512    0    0   812 238550 3506 6692  1 80  0 20
  7 72    104  75352 154252 3092896    0    0  4172 73020 3262 1952  0 31  0 69
13 89    104  70036 157160 3092988    0    0  5224 410088 3754 6068  1 66  0 34
  1 10    104  66232 157160 3096784    0    0   128 10668 2834 1227  0 11  0 89
  0 83    104  69608 156008 3094468    0    0     0 227888 3017 1843  0 43  0 57
35 91    104  72556 153832 3094608    0    0     0 148968 3141 4651  0 45  0 55
  0 84    104  71332 152300 3097304    0    0     4 192556 3345 5716  1 45  0 55
  4 79    104  76288 150324 3096168    0    0   200 63940 3201 1518  0 34  0 66
  2 84    104  18796 210492 3093256    0    0 86360 276956 3500 4899  1 67  0 33
  1 89    104  21208 207296 3093372    0    0   148 219696 3473 3774  0 41  0 59
86 22    104  15236 210080 3097008    0    0  4968 91508 3313 9608  0 34  4 62
  0 81    104  17048 208536 3096756    0    0  2304 148384 3066  929  0 31  0 69
28 60    104  25696 204100 3093156    0    0   136 159520 3394 6210  0 41  0 59
  7 57    104  21788 207620 3095812    0    0 15808 64888 2880 3992  1 44  0 56
  0 85    104  23952 206576 3092812    0    0 24304 383716 4067 3535  0 66  0 34
  3 81    104  22468 204888 3096768    0    0   620 164092 3160 5136  0 37  0 63


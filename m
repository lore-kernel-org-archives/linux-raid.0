From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: possible bug - bitmap dirty pages status
Date: Wed, 31 Aug 2011 13:56:29 +0100
Message-ID: <4E5E2F7D.1010306@anonymous.org.uk>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com> <CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com> <CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@us.sios.com>
Cc: CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/08/2011 13:30, Paul Clements wrote:
> On Wed, Aug 31, 2011 at 5:05 AM, CoolCold<coolthecold@gmail.com>  wrote:
>
>>> root@gamma2:~# cat /proc/mdstat
>>> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>>> md3 : active raid1 sdc3[1] sdb3[0]
>>>       1443552640 blocks [2/2] [UU]
>>>       bitmap: 16/22 pages [64KB], 32768KB chunk
>
>> More details now:
>> Array still has 16/22 dirty pages:
>
>> root@gamma2:~# mdadm --examine-bitmap /dev/sdc3
>
>>        Sync Size : 1443552640 (1376.68 GiB 1478.20 GB)
>>           Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
>
> But only 189 bits dirty. This means the bits are just distributed
> across the disk (which is why you have 16/22 pages dirty).
>
> Any activity on the disk? 189 bits could easily be explained by a
> small amount of background disk activity on a disk that big.

That makes sense to me. I have:

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1]
md1 : active raid6 sde2[4] sdd2[3] sdc2[2] sdb2[1] sda2[0]
       2929966080 blocks level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]
       bitmap: 2/4 pages [8KB], 131072KB chunk

Oh no! Half my array is dirty! But then:

# mdadm --examine-bitmap /dev/sdb2
         Filename : /dev/sdb2
            Magic : 6d746962
          Version : 4
             UUID : d8c57a89:166ee722:23adec48:1574b5fc
           Events : 1338800
   Events Cleared : 1338800
            State : OK
        Chunksize : 128 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 976655360 (931.41 GiB 1000.10 GB)
           Bitmap : 7452 bits (chunks), 7 dirty (0.1%)

Not so bad after all.

On the other hand, repeatedly checking /proc/mdstat shows different 
numbers of pages being dirty, and --examine-bitmap shows different 
numbers of bits being dirty each time, whereas CoolCold managed 16 pages 
repeatedly and 189 bits being dirty twice in a row. CoolCold, please can 
you test --examine-bitmap again several times at least 5 seconds apart?

Cheers,

John.


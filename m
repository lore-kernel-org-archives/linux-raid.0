From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 22:45:12 +0200
Message-ID: <CA+4vN7wVM9tAx3HYOut68H7nvb0UkX07x4=ScCddZS8eQ4+TMw@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+sTkh6rA_yoeM3Fw1s47sgEsJRWG7vbtXH9QaPWbwG6Mvt7fQ@mail.gmail.com>
 <CA+4vN7zTmKPuyseOO9QhSKO3vjeLpt8pQ76W-MwZg1-YCz+vLA@mail.gmail.com> <4FCE147E.9080900@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FCE147E.9080900@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 5, 2012 at 4:15 PM, Stan Hoeppner <stan@hardwarefreak.com> =
wrote:
> On 6/5/2012 2:47 AM, Ole Tange wrote:
>
>> =A0 time parallel -j0 dd if=3D{} of=3D/dev/null bs=3D1000k count=3D1=
k ::: /dev/sd?
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0^^^^^^^^
> Block size, bs, should always be a multiple of the page size lest
> throughput will suffer. =A0The Linux page size on x86 CPUs is 4096 by=
tes.
> =A0Using bs values that are not multiples of page size will usually g=
ive
> less than optimal results due to unaligned memory accesses.

The above command was used to measure the raw read performance from
all physical drives, i. e. the 2000 MB/s. If your hypothesis is
correct then I should be able to push the 2000 MB/s even higher by
using a smaller blocksize.

To see if you were right (i.e. that the block size has any impact
whatsoever) I tried:

  time parallel -j0 dd if=3D{} of=3D/dev/null bs=3D4k count=3D250k ::: =
/dev/sd?

I tested 100 times of 4k block and 1000k block and found the min,
median, and max:

seq 100 | parallel -j1 -I ,, --arg-sep ,, -N0  'echo 3 >
/proc/sys/vm/drop_caches;'/usr/bin/time -f%e  parallel -j0 dd if=3D{}
of=3D/dev/null bs=3D4k count=3D250k ::: /dev/sd? 2>&1 |grep -v o > out-=
4k

seq 100 | parallel -j1 -I ,, --arg-sep ,, -N0  'echo 3 >
/proc/sys/vm/drop_caches;'/usr/bin/time -f%e  parallel -j0 dd if=3D{}
of=3D/dev/null bs=3D1000k count=3D1k ::: /dev/sd? 2>&1 |grep -v o >
out-1000k

$ echo "1000 * " `ls /dev/sd? | wc -l ` / `sort out-4k | tail -n 1` | b=
c -l
$ echo "1000 * " `ls /dev/sd? | wc -l ` / `sort out-4k | head -n 50 |
tail -n 1` | bc -l
$ echo "1000 * " `ls /dev/sd? | wc -l ` / `sort -r out-4k  | tail -n 1`=
 | bc -l

System 1 (4 kb blocks): Min: 1416.61 MB/s Median: 1899.82 MB/s Max: 203=
8.92 MB/s
System 2 (4 kb blocks): Min: 1636.24 MB/s Median: 1850.53 MB/s Max: 203=
9.21 MB/s
System 3 (4 kb blocks): Min: 1123.43 MB/s Median: 1373.13 MB/s Max: 146=
4.96 MB/s

$ echo "1000 * " `ls /dev/sd? | wc -l ` / `sort out-1000k | tail -n 1` =
| bc -l
$ echo "1000 * " `ls /dev/sd? | wc -l ` / `sort out-1000k | head -n 50
| tail -n 1` | bc -l
$ echo "1000 * " `ls /dev/sd? | wc -l ` / `sort -r out-1000k  | tail
-n 1` | bc -l

System 1 (1000 kb blocks): Min: 1389.76 MB/s Median: 1909.72 MB/s Max:
2044.60 MB/s
System 2 (1000 kb blocks): Min: 1593.13 MB/s Median: 1799.30 MB/s Max:
1975.68 MB/s
System 3 (1000 kb blocks): Min: 1072.26 MB/s Median: 1345.02 MB/s Max:
1459.39 MB/s

If you compare the numbers between the 2 block sizes you can see that
the ranges and medians are almost identical. Is this the kind of
suffering of throughput you expected by not using the same block size?
Because I would find that this suffering is hardly worth mentioning -
it could just as well be due to variation.

> Additionally, you will typically see optimum throughput using bs valu=
es
> of between 4096 and 16384 bytes. =A0Below and above that throughput
> typically falls. =A0Test each page size multiple from 4096 to 32768 t=
o
> confirm on your system.

Are you aware that the 'dd' part of the script is for setting up the
loop back devices? That part is not timed at all, so if that part took
twice as long it would not change the validity of the test at all.

> Also, using large block sizes causes dd to buffer large amounts of da=
ta
> into memory as each physical IO is only 4096 bytes. =A0Thus dd doesn'=
t
> actually start writing to disk until each block is buffered into RAM,=
 in
> this case just under 1MB. =A0This reduces efficiency by quite a bit v=
s the
> 4096 byte block size which allows streaming directly from dd without =
the
> buffering.

Are you aware that the test takes place in RAM, and not on magnetic med=
ia?

>> The 900 MB/s was based on my old controller. I re-measured using my
>> new controller and get closer to 2000 MB/s in raw (non-RAID)
>> performance, which is close to the theoretical maximum for that
>> controller (2400 MB/s). This indicated that hardware is not a
>> bottleneck.
>>
>>>> When I set the disks up as a 24 disk software RAID6 I get 400 MB/s
>>>> write and 600 MB/s read. It seems to be due to checksuming, as I h=
ave
>>>> a single process (md0_raid6) taking up 100% of one CPU.
>
> The dd block size will likely be even more critical when dealing with
> parity arrays, as non page size blocks will cause problems with strip=
e
> aligned writes.

Again: The dd is not done on the array. It is done on the separate
devices to measure maximal hardware performance and to setup the loop
back devices in RAM, respectively.

Did you run the test script? What where your numbers? Did md0_raid6
take up 100% CPU of 1 core during the copy?


/Ole
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

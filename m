From: Doug Dumitru <doug@easyco.com>
Subject: Re: Raid5 performance issue
Date: Fri, 23 Dec 2016 11:24:13 -0800
Message-ID: <CAFx4rwQY3zF3cz-WV+L72mtmJodrYjO-kP1MUhC4YeX=zLJWmA@mail.gmail.com>
References: <H0000071000db2da.1482500583.sx.f1-outsourcing.eu*@MHS>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <H0000071000db2da.1482500583.sx.f1-outsourcing.eu*@MHS>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Roos <M.Roos@f1-outsourcing.eu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mr. Roos,

It is very hard to get an array "to speed" without hitting it at very
high queue depths.  In this area, spinning disks and SSDs actually
behave quite differently.

With hard drives, I suspect your single disk tests are taking
advantage of the disks' on-controller cache and is doing read-ahead
and thus streaming.  With the array in place, you are probably doing
512K reads (check the array chunk size) so the disks will see bursts
of 512K reads with big gaps.  The gaps are large enough that the
rotation has gone too far and the caching makes you wait a rotation.
This is just a guess.

You can test this hypothesis by doing the test with block sizes that
are exact stripe size (or multiples thereof).  Check
/sys/block/md?/md/optimial_io_size.  This should be ( number of drives
- number of parity drives - number of spares ) * chunk size.  This
might be a really large number, so the block stack will cut the
requests up anyway (there is a 1M limit for struct bio in most
layers), but with HDDs the scheduler should have time to do some
magic.

You might actually do better on this test with smaller chunk sizes.
Then again, this test is far from representative of a production
workload, so tuning for it might be folly.

Doug Dumitru



On Fri, Dec 23, 2016 at 5:43 AM, Marc Roos <M.Roos@f1-outsourcing.eu> wrote:
>
> I have grown a raid5 over the years with drives and resized partitions,
> now I have upgraded to centos7 (from centos5). And I have the impression
> the speed is not what it used to be.
>
> Can this be because of some missalignment? How can this be verified?
>
>
> If I monitor the individual disks with dstat it reads the raid drives at
> very low speeds
>
> dd if=/dev/md21 of=/dev/null bs=1M count=1500 iflag=direct
> 1500+0 records in
> 1500+0 records out
> 1572864000 bytes (1.6 GB) copied, 19.5879 s, 80.3 MB/s
>
>
>    0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :
>   0     0
>    0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :
>   0     0
>    0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :
>   0     0
>  256k    0 : 320k    0 : 320k    0 : 192k    0 : 256k    0 : 320k    0 :
> 256k    0
> 4672k    0 :4672k    0 :4672k    0 :4800k    0 :4672k    0 :4672k    0
> :4736k    0
>   11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :
>  11M    0
>   10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :
>  10M    0
>   10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :
>  10M    0
>   13M    0 :  13M    0 :  13M    0 :  13M    0 :  13M    0 :  13M    0 :
>  13M    0
>   10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :
>  10M    0
>   11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :
>  11M    0
>   19M    0 :  19M    0 :  19M    0 :  19M    0 :  19M    0 :  19M    0 :
>  19M    0
> 9984k    0 :9792k    0 :9792k    0 :9792k    0 :9984k    0 :9984k    0
> :9856k    0
>   13M    0 :  13M    0 :  13M    0 :  13M    0 :  13M    0 :  13M    0 :
>  13M    0
>   11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :
>  11M    0
>   12M    0 :  12M    0 :  12M    0 :  12M    0 :  12M    0 :  12M    0 :
>  12M    0
> 7872k    0 :7744k    0 :7808k    0 :7744k    0 :7936k    0 :7744k    0
> :7744k    0
>   11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :
>  11M    0
>   19M    0 :  19M    0 :  19M    0 :  19M    0 :  19M    0 :  19M    0 :
>  19M    0
> 7488k    0 :7360k    0 :7296k    0 :7360k    0 :7296k    0 :7296k    0
> :7296k    0
>   10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :
>  10M    0
>   14M    0 :  14M    0 :  14M    0 :  14M    0 :  14M    0 :  14M    0 :
>  14M    0
> 9472k    0 :9536k    0 :9536k    0 :9536k    0 :9472k    0 :9536k    0
> :9472k    0
>    0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :
>   0     0
>
> When I test the individual disks with
>
> for disk in sdm sdl sdi sde sdk sdf sdd;do `dd if=/dev/$disk
> of=/dev/null bs=1M count=1500 iflag=direct &`  ;done
>
> [root@san2 ~]# 1500+0 records in
> 1500+0 records out
> 1572864000 bytes (1.6 GB) copied, 8.96022 s, 176 MB/s
> 1500+0 records in
> 1500+0 records out
> 1572864000 bytes (1.6 GB) copied, 9.59289 s, 164 MB/s
> 1500+0 records in
> 1500+0 records out
> 1572864000 bytes (1.6 GB) copied, 10.0863 s, 156 MB/s
> 1500+0 records in
> 1500+0 records out
> 1572864000 bytes (1.6 GB) copied, 10.5833 s, 149 MB/s
> 1500+0 records in
> 1500+0 records out
> 1572864000 bytes (1.6 GB) copied, 10.6084 s, 148 MB/s
> 1500+0 records in
> 1500+0 records out
> 1572864000 bytes (1.6 GB) copied, 11.0205 s, 143 MB/s
> 1500+0 records in
> 1500+0 records out
> 1572864000 bytes (1.6 GB) copied, 11.3199 s, 139 MB/s
>
>
>
>   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :
>  0     0
>    0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :
>   0     0
> 4096k    0 :5120k    0 :  32M    0 : 512k    0 :  29M    0 :  35M    0
> :5120k    0
>   62M    0 :  51M    0 : 157M    0 : 145M    0 : 144M    0 : 153M    0 :
>  38M    0
>  153M    0 : 148M    0 : 158M    0 : 174M    0 : 135M    0 : 151M    0 :
> 150M    0
>  152M    0 : 144M    0 : 154M    0 : 179M    0 : 150M    0 : 146M    0 :
> 149M    0
>  149M    0 : 147M    0 : 155M    0 : 186M    0 : 148M    0 : 155M    0 :
> 157M    0
>  156M    0 : 128M    0 : 154M    0 : 188M    0 : 136M    0 : 153M    0 :
> 155M    0
>  159M    0 : 136M    0 : 157M    0 : 206M    0 : 147M    0 : 155M    0 :
> 151M    0
>  153M    0 : 147M    0 : 162M    0 : 153M    0 : 144M    0 : 127M    0 :
> 147M    0
>  153M    0 : 138M    0 : 159M    0 : 153M    0 : 134M    0 : 145M    0 :
> 146M    0
>  147M    0 : 144M    0 : 154M    0 : 116M    0 : 144M    0 : 153M    0 :
> 143M    0
>  154M    0 : 150M    0 :  60M    0 :   0     0 : 141M    0 : 131M    0 :
> 153M    0
>   61M    0 : 147M    0 :   0     0 :   0     0 :  51M    0 :   0     0 :
> 109M    0
>    0     0 :  17M    0 :   0     0 :   0     0 :   0     0 :   0     0 :
>   0     0
>
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -.
> F1 Outsourcing Development Sp. z o.o.
> Poland
>
> t:  +48 (0)124466845
> f:  +48 (0)124466843
> e:  marc@f1-outsourcing.eu
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Doug Dumitru
EasyCo LLC

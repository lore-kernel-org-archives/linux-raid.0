From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Raid-5 long write wait while reading
Date: Fri, 8 Jun 2007 08:49:28 +0300
Message-ID: <5b170a7d0706072249i4dbdcb13h826aba07cf31333e@mail.gmail.com>
References: <4653306B.4090500@jager.no> <4658CB8A.8080503@jager.no>
	 <465AFCC6.8040006@tmr.com> <466207E3.60307@jager.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <466207E3.60307@jager.no>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: tj <lists@jager.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/3/07, tj <lists@jager.no> wrote:
> >> I just noticed something else. A couple of slow readers where running
> >> on my raid-5 array. Then i started a copy from another local disk to
> >> the array. Then i got the extremely long wait. I noticed something in
> >> iostat:
> >>
> >> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
> >>           3.90    0.00   48.05   31.93    0.00   16.12
> >>
> >> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> >> ....
> >> sdg               0.80        25.55         0.00        128          0
> >> sdh             154.89       632.34         0.00       3168          0
> >> sdi               0.20        12.77         0.00         64          0
> >> sdj               0.40        25.55         0.00        128          0
> >> sdk               0.40        25.55         0.00        128          0
> >> sdl               0.80        25.55         0.00        128          0
> >> sdm               0.80        25.55         0.00        128          0
> >> sdn               0.60        23.95         0.00        120          0
> >> md0             199.20       796.81         0.00       3992          0
> >>
> I don't use ext3 i use ReiserFS. ( It seemed like a good idea at the
> time. ) It's mounted with  -o  noatime.

I've seen similar read patterns on reiserfs-raid5. I have a 6 disk set
with chunk size of 64, and it seems reiserfs's tree is only located on
2 of the disks. It appears reiserfs stores the tree in blocks
dispersed along the entire disk with some interval, and that's not
always optimal for raid.

Another thing you should look into is stripe cache trashing. On
certain kernel versions all raid5 operations go through stripe cache,
which results in a lot of memory copy operations and might present a
bottleneck if there's a lot of random access. If writes occupy the
entire cache, there's no free slots for reads to go through. I might
be wrong here, though, as this is just a guess.

- tuomas

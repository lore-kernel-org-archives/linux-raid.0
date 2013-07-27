From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: raid10 centos5 vs. centos6 300% worse random write performance
Date: Sat, 27 Jul 2013 15:01:51 -0600
Message-ID: <CALFpzo71sjK6Cd=jZ_iQG8rRk5TatGsJ5FznD75ayTm1A5kH-g@mail.gmail.com>
References: <loom.20130725T120703-146@post.gmane.org>
	<alpine.DEB.2.00.1307251338050.8891@uplift.swm.pp.se>
	<loom.20130727T221553-552@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130727T221553-552@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wes <wt75@gazeta.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Seekmark is very simple. It opens a block device with O_RDWR and
O_SYNC, divides the disk into block_size chunks, spawns a bunch of
threads, and each one chooses a random block, seeks there, writes,
then chooses another, seeks there, writes, etc.  There shouldn't be
any write barrier issue, since there's no filesystem involved. You can
also point it at a file on a filesystem and it will do the same with
that file, the O_SYNC *should* flush on every write.

There could be IO scheduler differences between the kernels.

On Sat, Jul 27, 2013 at 2:22 PM, Wes <wt75@gazeta.pl> wrote:
> Mikael Abrahamsson <swmike <at> swm.pp.se> writes:
>
>> Does seekmark use barriers to assure that data has actually been written?
>> In that case it could be that 2.6.18 has different behaviour from 2.6.32
>> when it comes to barriers and that explains the speed difference.
>>
>
>
>
> Mikael, looks like you were right.
>
> Aside from seekmark I was also testing with random dd to not relay on single
> measurment tool.
>
> I run found out it is not only related to raid but to block devices in
> general. I run 'hdparm -W0 /dev/sda' on cetos5 and got the same poor
> behavior of centos6.
>
> Anyway I cannot still find a way to enable drive write cache on centos6.
> hdparm reports it is enabled but results are the same (poor) no matter
> if after 'hdparm -W0 /dev/sda' or 'hdparm -W1 /dev/sda' so now I am guessing
> write cache must be blocked somewhere in the kernel.
>
> I still cannot find a way to enable write cache in centos 6.
> Booting with 'barriers=off' kernel parameter and 'barrier=0' in fstab does
> not help.
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: =?ISO-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>
Subject: Re: Used Dev Size is wrong
Date: Sun, 25 Oct 2009 19:19:19 +0200
Message-ID: <6c4602af0910251019p40116312jf010c3584b817596@mail.gmail.com>
References: <4AE4832F.7010602@bartk.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE4832F.7010602@bartk.us>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Kus <me@bartk.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

2009/10/25 Bart Kus <me@bartk.us>:
> # mdadm --detail /dev/md4
> /dev/md4:
>       Version : 1.02
>  Creation Time : Sun Aug 10 23:41:49 2008
>    Raid Level : raid6
>    Array Size : 15628094464 (14904.11 GiB 16003.17 GB)
>  Used Dev Size : 3907023616 (3726.03 GiB 4000.79 GB)
> ...
> # mdadm --examine /dev/sdc1
> /dev/sdc1:
> ...
> Avail Dev Size : 3907023730 (1863.01 GiB 2000.40 GB)
>    Array Size : 31256188928 (14904.11 GiB 16003.17 GB)
>  Used Dev Size : 3907023616 (1863.01 GiB 2000.40 GB)

Mostly likely cause is mdadm bug. Please let us know what's mdadm
version, but I'd suggest getting the newest one, and just seeing if
the output is correct. If I recall correctly, it's a bug related to a
sector<->bytes change in output generating code. Not dangerous. It was
brought to list's attention a while ago, I suppose it might've been in
2.6.7? From what I have installed here right now .4 and .9 are okay,
and .7 is just wrong.

And, as an aside comment, I think that some values of --detail,
--examine and cat /proc/mdstat are not always what you'd expect during
ongoing reshape. So if anything else is inconsistent right now, you
might want to wait.

Cheers,
Mike

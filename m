From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 23:17:04 +0200
Message-ID: <CA+4vN7wVbiHHR=B=QyvSqA+Y9ohiYMZ3xYDokJ+MY0h-AkatxA@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+sTkh4fd+oZqagpHkGv5Kw+nkDyhunXfJm0tu0rqvuxVZBOyQ@mail.gmail.com>
 <CA+4vN7xH10qS-=OSS_3z3B3EohKHjk8-GBVvVfPj01TH-0pe3w@mail.gmail.com>
 <CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com> <20430.1303.6379.122789@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20430.1303.6379.122789@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 5, 2012 at 3:09 PM, Peter Grandi <pg@lxra2.for.sabi.co.uk> =
wrote:
> [ ... ]
>
>>> Good call. But the resync is done before the mkfs.xfs is finished, =
so
>>> the time of the copying is not affected by resync.
>>>
>>> I re-tested with --assume-clean and as expected it has no impact.
>
>> =A0 =A0Wanna try CONFIG_MULTICORE_RAID456? :-)
>
> That would be intreresting, but the original post reports over
> 6GB/s for pure checksumming, and around 400MB/s actual transfer
> rate. In theory there is no need here for multihreading. There
> may something else going on :-).

I have the feeling that some of you have not experienced md0_raid6
taking up 100% CPU of a single core. If you have not, please run the
test on http://oletange.blogspot.dk/2012/05/software-raid-performance-o=
n-24-disks.html

The test requires 10 GB RAM, atleast 2 CPU cores, and takes less than
3 minutes to run.

See if you can reproduce the CPU usage, and post your results along
with the reported checksumming speed reported by the kernel.


/Ole
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

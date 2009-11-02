From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Mon, 2 Nov 2009 09:03:23 -0600
Message-ID: <cccedfc60911020703s3188ebcsac867922f937bb39@mail.gmail.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	<4AEEF29C.10309@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AEEF29C.10309@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 2, 2009 at 8:54 AM, Bill Davidsen <davidsen@tmr.com> wrote:
> Jon Nelson wrote:
>>
>> I have a 4 disk raid6. The disks are individually capable of (at
>> least) 75MB/s on average.
>> The raid6 looks like this:
>>
>> md0 : active raid6 sda4[0] sdc4[5] sdd4[4] sdb4[6]
>> =A0 =A0 =A0613409536 blocks super 1.1 level 6, 64k chunk, algorithm =
2 [4/4]
>> [UUUU]
>>
>> The raid serves basically as an lvm physical volume.
>>
>> While rsyncing a file from an ext3 filesystem to a jfs filesystem, I
>> am observing speeds in the 10-15MB/s range.
>> That seems really really slow.
>>
>>
>
> It is really slow, recent kernels seem to be unsuitable for use as la=
rge
> file servers, as the performance is, as you described it, "unbelievab=
ly
> bad."

Yeah. I'm hoping that the 2.6.31.XX stable kernel series gets some of
these improvements, the .27 series has been not the most stable for me
either.  2.6.27.25 was the last rock-solid of the .27 series for me.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

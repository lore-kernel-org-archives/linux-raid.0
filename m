From: Bart Kus <me@bartk.us>
Subject: Re: Used Dev Size is wrong
Date: Sun, 25 Oct 2009 10:42:09 -0700
Message-ID: <4AE48DF1.6000001@bartk.us>
References: <4AE4832F.7010602@bartk.us> <6c4602af0910251019p40116312jf010c3584b817596@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c4602af0910251019p40116312jf010c3584b817596@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBQcnp5xYJ1c2tp?= <mikylie@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Micha=C5=82 Przy=C5=82uski wrote:
> Hello,
>
> 2009/10/25 Bart Kus <me@bartk.us>:
>  =20
>> # mdadm --detail /dev/md4
>> /dev/md4:
>>       Version : 1.02
>>  Creation Time : Sun Aug 10 23:41:49 2008
>>    Raid Level : raid6
>>    Array Size : 15628094464 (14904.11 GiB 16003.17 GB)
>>  Used Dev Size : 3907023616 (3726.03 GiB 4000.79 GB)
>> ...
>> # mdadm --examine /dev/sdc1
>> /dev/sdc1:
>> ...
>> Avail Dev Size : 3907023730 (1863.01 GiB 2000.40 GB)
>>    Array Size : 31256188928 (14904.11 GiB 16003.17 GB)
>>  Used Dev Size : 3907023616 (1863.01 GiB 2000.40 GB)
>>    =20
>
> Mostly likely cause is mdadm bug. Please let us know what's mdadm
> version, but I'd suggest getting the newest one, and just seeing if
> the output is correct. If I recall correctly, it's a bug related to a
> sector<->bytes change in output generating code. Not dangerous. It wa=
s
> brought to list's attention a while ago, I suppose it might've been i=
n
> 2.6.7? From what I have installed here right now .4 and .9 are okay,
> and .7 is just wrong.
>
> And, as an aside comment, I think that some values of --detail,
> --examine and cat /proc/mdstat are not always what you'd expect durin=
g
> ongoing reshape. So if anything else is inconsistent right now, you
> might want to wait.
>
> Cheers,
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20
Excellent!  I'm running mdadm 2.6.8.  I compiled 2.6.9 in /tmp/ and whe=
n=20
using that binary, it does show the correct size.  When Gentoo decides=20
to upgrade, this little problem should fix itself.

Thanks!

--Bart

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: mdadm / RAID, a few questions
Date: Fri, 29 Oct 2010 21:35:16 +0100
Message-ID: <AANLkTimW0UdHCPtVQ_THJDOCu36W0QimQosWoSQUS7tk@mail.gmail.com>
References: <AANLkTi=QRfQhNy5jDdtq2FsjENZk-ihNas=D4QrS2XMd@mail.gmail.com>
	<4CCB2CF5.9010402@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CCB2CF5.9010402@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29 October 2010 21:22, John Robinson <john.robinson@anonymous.org.uk=
> wrote:
> On 29/10/2010 15:18, Mathias Bur=C3=A9n wrote:
>>
>> Hi,
>>
>> I've a few questions in relation to mdadm and performance. System
>> details follow below:
>>
>> Intel Atom 330 @ 1.6Ghz (dualcore, HT), 4GB RAM
>
> [...]
>>
>> Question 1: I saw that in Linux 2.6.36 (perhaps earlier versions as
>> well) you have the kernel config option CONFIG_MULTICORE_RAID456. I
>> tried enabling it, booted to 2.6.36 from 2.6.35, and rebuilding of t=
he
>> array continued where it left off before reboot. However, the
>> performance was abysmal.. around 16MB/s compared to 70MB/s without t=
he
>> option turned on. Is this a bug, or is it because the Atom has no
>> grunt to speak of?
>
> No, the performance of MULTICORE_RAID456 is abysmal on any CPU. It's =
an
> experimental implementation that doesn't work terribly well. If you'r=
e
> interested in developing, by all means help, but if not, turn it off.
>
>> Question 2: The array is now recovering since I've grown it to 6 fro=
m 4
>> devices:
>> $ cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 sdf1[0] sde1[5] sdg1[6] sdc1[3] sdd1[4] sdb1[1]
>> =C2=A0 =C2=A0 =C2=A0 5851054080 blocks super 1.2 level 5, 128k chunk=
, algorithm 2
>> [6/6] [UUUUUU]
>> =C2=A0 =C2=A0 =C2=A0 [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.........] =C2=
=A0reshape =3D 57.7% (1126387328/1950351360)
>> finish=3D718.0min speed=3D19125K/sec
>>
>> unused devices:<none>
>>
>> Is there a way to speed it up? /proc/sys/dev/raid/speed_limit_min is
>> 100000 (100k), /proc/sys/dev/raid/speed_limit_max is 1000000 (1000k)=
=2E
>
> No, that's probably about right on something as weak as an Atom. Let =
it run.
>
>> Question 3: Before I created this RAID5 array I did a quick RAID0 te=
st
>> array just for fun, using 2 full devices (not partitions). Now I hav=
e
>> this:
>
> [...]
>
> Sorry, I don't know the answer to this. I suspect it's to do with sup=
erblock
> versions, but I don't know - I'm sorry that's not helpful.
>
> Cheers,
>
> John.
>
>

Hi,

Thanks for the answers. I got the speed up to around 36 MBps by
disabling NCQ and changing some cache values, so there's only 36
minutes left or so now. I would love to help develop the
multicore_raid456, but I'm not a coder. Patches welcome though!

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

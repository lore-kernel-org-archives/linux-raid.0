From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
Date: Tue, 20 Mar 2012 23:24:36 -0300
Message-ID: <CABYL=TpzjJcg=P7Jtwcg3Pdido1H0_p13DC64o14b=4+_+dQ1Q@mail.gmail.com>
References: <20120316073213.656519005@fusionio.com>
	<alpine.LRH.2.02.1203181824590.24824@diagnostix.dwd.de>
	<CANejiEWeaF44Rbgt5jhf_bnafF4yoTTZAYsqoD2+greJ07c-_A@mail.gmail.com>
	<alpine.LRH.2.02.1203200839120.29880@diagnostix.dwd.de>
	<CANejiEVWbP53QVKZQBS2xKtaqdX6jdW_mjZxJ9q5=cxKNk6_dg@mail.gmail.com>
	<CANejiEUDmDzGirBZRwKh5MTHvXX308JTHmmH_U0JfnPJkpvHJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANejiEUDmDzGirBZRwKh5MTHvXX308JTHmmH_U0JfnPJkpvHJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, neilb@suse.de, axboe@kernel.dk, vgoyal@redhat.com, martin.petersen@oracle.com
List-Id: linux-raid.ids

=3D/ well maybe with a sas disk it could be faster? maybe a pciexpress =
disk too?

Em 20 de mar=E7o de 2012 23:08, Shaohua Li <shli@kernel.org> escreveu:
> 2012/3/20 Shaohua Li <shli@kernel.org>:
>> 2012/3/20 Holger Kiehl <Holger.Kiehl@dwd.de>:
>>> Hello,
>>>
>>>
>>> On Tue, 20 Mar 2012, Shaohua Li wrote:
>>>
>>>> 2012/3/20 Holger Kiehl <Holger.Kiehl@dwd.de>:
>>>>>
>>>>> Hello,
>>>>>
>>>>>
>>>>> On Fri, 16 Mar 2012, Shaohua Li wrote:
>>>>>
>>>>>> The patches add TRIM support for raid linear/0/1/10. I'll add TR=
IM
>>>>>> support
>>>>>> for
>>>>>> raid 4/5/6 later. The implementation is pretty straightforward a=
nd
>>>>>> self-explained.
>>>>>>
>>>>>> v1->v2:
>>>>>> 1. fixed a checking issue
>>>>>> 2. dropped discard request plug and replace it with no discard m=
erege,
>>>>>> because
>>>>>> current SCSI layer can't handle discard request merge.
>>>>>>
>>>>> Have tested TRIM patches on three different systems with the foll=
owing
>>>>> hardware/ setup:
>>>>>
>>>>> =A0 1) root mounted on a raid1 over two SAS SSD's (200GB) and /ho=
me
>>>>> partition
>>>>> =A0 =A0 =A0on a raid0 over a fusionio ioDrive Duo. Is very new an=
d seen very
>>>>> =A0 =A0 =A0little usage.
>>>>>
>>>>> =A0 2) root and /home mounted on a raid0 over two Intel X25 Postv=
ille
>>>>> =A0 =A0 =A0(160GB) connected to a Intel P55 Express chipset. Has =
seen very
>>>>> =A0 =A0 =A0heavy usage for approx. 2 years.
>>>>>
>>>>> =A0 3) root and /home mounted on a raid0 over three OCZ-VERTEX2 (=
120GB)
>>>>> =A0 =A0 =A0connected via ICH7 south bridge. Has seen mild usage f=
or approx.
>>>>> =A0 =A0 =A01.5 years.
>>>>>
>>>>> Made the following observations when running my own benchmark whi=
ch
>>>>> copies around a lot of small files and deletes them. The benchmar=
k on
>>>>> all systems was always run only on the /home partition ie. on a r=
aid0.
>>>>>
>>>>> For system 1) there is hardly any measurable differnce whether di=
scard
>>>>> is enabled or not (~29000 files per second).
>>>>>
>>>>> On system 2) the performance drops from 6500->3700 files per seco=
nd,
>>>>> but under normal usage one does not notice any difference.
>>>>
>>>> do you have the blktrace data when the benchmark is running, espec=
ially
>>>> when doing file deletion. I'd like to check the latency of discard=
 in this
>>>> case.
>>>>
>>> It is uploaded on ftp://ftp.dwd.de/pub/afd/test/trim
>> Thanks, I'll check it.
> Thanks for the testing. The trace data is very helpful. In the intel
> SSD, trace data
> shows a discard request uses about 1 ~ 3 ms. The filesystem suffers f=
rom
> fragmentation too, so lots of small discard requests. When ext4 start=
s doing
> discard, it usually uses more than 1 minutes. That's too bad.
> If just looking one disk's trace data, there are some extra latencies=
 between
> two discard requests. The combined trace data of two disks show the l=
atency
> comes from waiting for another disk, so nothing abnormal. I thought w=
e could
> do an optimization for this case in the future.
> So in summary, discard from the SSDs is slow. When your filesystem is
> fragmented, the performance will be terrible.
>
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial

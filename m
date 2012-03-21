From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
Date: Wed, 21 Mar 2012 02:29:21 +0000
Message-ID: <CADNH=7EfmNRXq1bSyuUcRGy-8ksfNhJuGnopubTRomq8-oSmJw@mail.gmail.com>
References: <20120316073213.656519005@fusionio.com>
	<alpine.LRH.2.02.1203181824590.24824@diagnostix.dwd.de>
	<CANejiEWeaF44Rbgt5jhf_bnafF4yoTTZAYsqoD2+greJ07c-_A@mail.gmail.com>
	<alpine.LRH.2.02.1203200839120.29880@diagnostix.dwd.de>
	<CANejiEVWbP53QVKZQBS2xKtaqdX6jdW_mjZxJ9q5=cxKNk6_dg@mail.gmail.com>
	<CANejiEUDmDzGirBZRwKh5MTHvXX308JTHmmH_U0JfnPJkpvHJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANejiEUDmDzGirBZRwKh5MTHvXX308JTHmmH_U0JfnPJkpvHJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, neilb@suse.de, axboe@kernel.dk, vgoyal@redhat.com, martin.petersen@oracle.com
List-Id: linux-raid.ids

On 21 March 2012 02:08, Shaohua Li <shli@kernel.org> wrote:
> 2012/3/20 Shaohua Li <shli@kernel.org>:
>> 2012/3/20 Holger Kiehl <Holger.Kiehl@dwd.de>:
>>> Hello,
>>>
>>>
>>> On Tue, 20 Mar 2012, Shaohua Li wrote:
>>>
<snip>
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
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

Many people prefer to have the filesystems mounted without discard,
then they run a TRIM command/script at night (or whenever the disk
isn't used very much). This way the TRIM commands don't slow down the
'overall' performance.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

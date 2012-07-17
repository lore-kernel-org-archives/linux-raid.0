From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: doubt about raid 'quality'
Date: Tue, 17 Jul 2012 00:00:03 -0300
Message-ID: <CABYL=Tr=tMxmNhTz=U0bUae+f8rj+44jcnHTS0uguDqnXvJA5A@mail.gmail.com>
References: <CABYL=TobGA_eHqfLQXMnTJ8B8hPQ2B1HrBvTAdM3XAhn8x27uw@mail.gmail.com>
	<CADNH=7G7FXj7skqQ7_P54-GM6rDgAcUPBuKnFrQ6-qGbRNsf_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7G7FXj7skqQ7_P54-GM6rDgAcUPBuKnFrQ6-qGbRNsf_g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

humm and how i know if the check is ok?

2012/7/16 Mathias Bur=E9n <mathias.buren@gmail.com>:
> On 16 July 2012 16:56, Roberto Spadim <roberto@spadim.com.br> wrote:
>> hi guys, some days ago, i lost some data from my mysql database, it
>> was running nice, but start given bad record (one of my disks is bad=
)
>> i read some time ago about checks on md raids, could it be done
>> weekly? it=B4s a raid1 md device, i don=B4t know if it=B4s possible =
because
>> i read about raid5/6 devices only
>> it=B4s a newbie question, sorry
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Doesn't
>
> echo check >> /sys/block/md0/md/sync_action
>
> work?
>
> Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

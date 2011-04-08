From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: iostat with raid device...
Date: Fri, 8 Apr 2011 15:10:45 -0700
Message-ID: <BANLkTik0S7JfN+ccs+oKPHADkvZSH_aEzw@mail.gmail.com>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
	<BANLkTim6ANxfFoiMfHe1JOyTrtCQ-02gsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTim6ANxfFoiMfHe1JOyTrtCQ-02gsw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for pointing this out...I did observe this but forgot to
mention in the email...

Can someone give some insight into this.

Thanks.

On Fri, Apr 8, 2011 at 3:05 PM, Roberto Spadim <roberto@spadim.com.br> =
wrote:
> another question... why md have more tps? disk elevators? sector size=
?
>
> 2011/4/8 Linux Raid Study <linuxraid.study@gmail.com>:
>> Hello,
>>
>> I have a raid device /dev/md0 based on 4 devices sd[abcd].
>>
>> When I write 4GB to /dev/md0, I see following output from iostat...
>>
>> Ques:
>> Shouldn't I see write/sec to be same for all four drives? Why does
>> /dev/sdd always have higher value for =C2=A0BlksWrtn/sec?
>> My strip size is 1MB.
>>
>> thanks for any pointers...
>>
>> avg-cpu: =C2=A0%user =C2=A0 %nice %system %iowait =C2=A0%steal =C2=A0=
 %idle
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.02 =C2=A0 =C2=A00.00 =C2=A0 =C2=
=A00.34 =C2=A0 =C2=A00.03 =C2=A0 =C2=A00.00 =C2=A0 99.61
>>
>> Device: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tps =C2=A0 Blk_read=
/s =C2=A0 Blk_wrtn/s =C2=A0 Blk_read =C2=A0 Blk_wrtn
>> sda =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.08 =C2=A0 =C2=
=A0 =C2=A0 247.77 =C2=A0 =C2=A0 =C2=A0 338.73 =C2=A0 37478883 =C2=A0 51=
237136
>> sda1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.08 =C2=A0 =C2=
=A0 =C2=A0 247.77 =C2=A0 =C2=A0 =C2=A0 338.73 =C2=A0 37478195 =C2=A0 51=
237136
>> sdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.08 =C2=A0 =C2=
=A0 =C2=A0 247.73 =C2=A0 =C2=A0 =C2=A0 338.78 =C2=A0 37472990 =C2=A0 51=
245712
>> sdb1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.08 =C2=A0 =C2=
=A0 =C2=A0 247.73 =C2=A0 =C2=A0 =C2=A0 338.78 =C2=A0 37472302 =C2=A0 51=
245712
>> sdc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.10 =C2=A0 =C2=
=A0 =C2=A0 247.82 =C2=A0 =C2=A0 =C2=A0 338.66 =C2=A0 37486670 =C2=A0 51=
226640
>> sdc1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.10 =C2=A0 =C2=
=A0 =C2=A0 247.82 =C2=A0 =C2=A0 =C2=A0 338.66 =C2=A0 37485982 =C2=A0 51=
226640
>> sdd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.09 =C2=A0 =C2=
=A0 =C2=A0 118.46 =C2=A0 =C2=A0 =C2=A0 467.97 =C2=A0 17918510 =C2=A0 70=
786576
>> sdd1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.09 =C2=A0 =C2=
=A0 =C2=A0 118.45 =C2=A0 =C2=A0 =C2=A0 467.97 =C2=A0 17917822 =C2=A0 70=
786576
>> md0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A065.60 =C2=A0 =C2=
=A0 =C2=A0 443.79 =C2=A0 =C2=A0 =C2=A01002.42 =C2=A0 67129812 =C2=A0151=
629440
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

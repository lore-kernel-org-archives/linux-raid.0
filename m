From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: iostat with raid device...
Date: Fri, 8 Apr 2011 19:05:01 -0300
Message-ID: <BANLkTim6ANxfFoiMfHe1JOyTrtCQ-02gsw@mail.gmail.com>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

another question... why md have more tps? disk elevators? sector size?

2011/4/8 Linux Raid Study <linuxraid.study@gmail.com>:
> Hello,
>
> I have a raid device /dev/md0 based on 4 devices sd[abcd].
>
> When I write 4GB to /dev/md0, I see following output from iostat...
>
> Ques:
> Shouldn't I see write/sec to be same for all four drives? Why does
> /dev/sdd always have higher value for =A0BlksWrtn/sec?
> My strip size is 1MB.
>
> thanks for any pointers...
>
> avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
> =A0 =A0 =A0 =A0 =A0 0.02 =A0 =A00.00 =A0 =A00.34 =A0 =A00.03 =A0 =A00=
=2E00 =A0 99.61
>
> Device: =A0 =A0 =A0 =A0 =A0 =A0tps =A0 Blk_read/s =A0 Blk_wrtn/s =A0 =
Blk_read =A0 Blk_wrtn
> sda =A0 =A0 =A0 =A0 =A0 =A0 =A0 1.08 =A0 =A0 =A0 247.77 =A0 =A0 =A0 3=
38.73 =A0 37478883 =A0 51237136
> sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A01.08 =A0 =A0 =A0 247.77 =A0 =A0 =A0 3=
38.73 =A0 37478195 =A0 51237136
> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 1.08 =A0 =A0 =A0 247.73 =A0 =A0 =A0 3=
38.78 =A0 37472990 =A0 51245712
> sdb1 =A0 =A0 =A0 =A0 =A0 =A0 =A01.08 =A0 =A0 =A0 247.73 =A0 =A0 =A0 3=
38.78 =A0 37472302 =A0 51245712
> sdc =A0 =A0 =A0 =A0 =A0 =A0 =A0 1.10 =A0 =A0 =A0 247.82 =A0 =A0 =A0 3=
38.66 =A0 37486670 =A0 51226640
> sdc1 =A0 =A0 =A0 =A0 =A0 =A0 =A01.10 =A0 =A0 =A0 247.82 =A0 =A0 =A0 3=
38.66 =A0 37485982 =A0 51226640
> sdd =A0 =A0 =A0 =A0 =A0 =A0 =A0 1.09 =A0 =A0 =A0 118.46 =A0 =A0 =A0 4=
67.97 =A0 17918510 =A0 70786576
> sdd1 =A0 =A0 =A0 =A0 =A0 =A0 =A01.09 =A0 =A0 =A0 118.45 =A0 =A0 =A0 4=
67.97 =A0 17917822 =A0 70786576
> md0 =A0 =A0 =A0 =A0 =A0 =A0 =A065.60 =A0 =A0 =A0 443.79 =A0 =A0 =A010=
02.42 =A0 67129812 =A0151629440
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid10 - without stripe
Date: Tue, 22 Feb 2011 18:22:41 -0300
Message-ID: <AANLkTinoGxdS7qq1HPtRO084LQjvT+VJUZ8H1Ex_BuBq@mail.gmail.com>
References: <AANLkTimf64aT9smXdhvcGWLAo09Evn4sQ8KDbbB54W49@mail.gmail.com>
	<20110223074357.0e1a3dd4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110223074357.0e1a3dd4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i will try to get commands on bash history at production server, and po=
st again

the array was two disks on raid10
expected result: fail a disk, the array continue
i tryed with far and near layout but couldn=B4t get mirror only 'stripe=
'



2011/2/22 NeilBrown <neilb@suse.de>:
> On Tue, 22 Feb 2011 16:17:08 -0300 Roberto Spadim <roberto@spadim.com=
=2Ebr>
> wrote:
>
>> Hi guys, on old email, some one told me that was possible using raid=
10
>> with layouts, and without stripe
>> could i make a 2disks raid10 with layout?
>> i tried many commands but couldn=B4t work without stripe (disk grow
>> after each mdadm --create i made :/)
>> can anyone help? i want faster aligned reads (like raid0) but withou=
t
>> growing my disk size (i want only mirrors)
>>
>
> What actual commands did you try? =A0What exactly were the results?
>
> NeilBrown
>
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

From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: disk order problem in a raid 10 array
Date: Fri, 18 Mar 2011 21:07:59 -0300
Message-ID: <AANLkTikEv39Loq4SAsB2rMnchFhcvRxjgLsmXQcVQDE+@mail.gmail.com>
References: <201103181549.20835.xavier@alternatif.org>
	<20110319102039.52cc2282@notabene.brown>
	<201103190059.08093.xavier@alternatif.org>
	<201103190105.59075.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103190105.59075.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: Xavier Brochard <xavier@alternatif.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hum, can you check if you updated udev ?
i think it=B4s a udev with wrong configuration (maybe, maybe not)

2011/3/18 Xavier Brochard <xavier@alternatif.org>:
> Le samedi 19 mars 2011 00:59:07 Xavier Brochard, vous avez =E9crit :
>> > Could you please sent a complete output of:
>> >
>> > =A0 =A0cat /proc/mdstat
>> > =A0 =A0mdadm -D /dev/md0
>> > =A0 =A0mdadm -E /dev/sd?1
>> >
>> >
>> > all collected at the same time. =A0Then I will suggest if there is=
 any
>> > action you should take to repair anything.
>>
>> Here it is, thankyou for you help
>
> don't now if it is important, but I collected them from Sysrescue-cd,=
 with a
> 2.6.35-std163-amd64 kernel
>
> Xavier
> xavier@alternatif.org - 09 54 06 16 26
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

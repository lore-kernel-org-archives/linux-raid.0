From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID 1 using SSD and 2 HDD
Date: Tue, 19 Jul 2011 15:27:26 -0300
Message-ID: <CABYL=TppzPDszVp3cr0DnuVDAg3Hjq2dvZyP0CYEz2x3H2ZjZQ@mail.gmail.com>
References: <4E25C9BA.1060401@dodtsair.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E25C9BA.1060401@dodtsair.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Power <mpower@dodtsair.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

no this not work very fast...
use bcache  or other similar ssd+harddisk cache solution (facebook
have one solution i don=B4t remember the name)
mixing ssd and hdd are a big problem, since write speed is the slowest
(maybe ssd maybe hdd) and read speed isn=B4t very well since read in ss=
d
can be non sequencial and at hdd sequencial is prefered, the read
balance algorithm is tuned to use the near position device, and
sometimes ssd isn=B4t used, or less used or more used...
a bigger speed can be done using a cache solution (ssd+hdd or ssd+raid1=
(hdd))
that was my test results... maybe someone have others results


2011/7/19 Mike Power <mpower@dodtsair.com>:
> Is it possible to implement a RAID 1 array using two equal size HDD a=
nd one
> smaller and faster SSD. =A0The idea being that the resulting RAID wou=
ld have
> the same size of the HDD while picking up the speed benefits of the S=
SD.
> =A0You can do something similar today by just buying two hybrid drive=
s and
> putting them in an array. =A0By purchasing a dedicated SSD drive for =
that
> purpose you gain the ability of controlling the size of the SSD porti=
on. =A0I
> was hoping the RAID array could use the SSD more as a cache then a re=
dundant
> storage.
>
> Mike Power
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

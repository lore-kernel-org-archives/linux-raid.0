From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID HDDs spin up sequence
Date: Tue, 1 Feb 2011 20:46:15 -0200
Message-ID: <AANLkTi=8HGU=TtKFLjQXztEg1b9erCUP8NS2wDYcDdMd@mail.gmail.com>
References: <20110131201823.GA15704@lazy.lzy>
	<AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
	<20110131222348.GA15912@lazy.lzy>
	<AANLkTi=gL3ATPN1+HHE+mhK7ZsM+aPyyQfVsz9Pq1Ajf@mail.gmail.com>
	<20110131230703.GA16834@lazy.lzy>
	<4D4765B2.7090002@cfl.rr.com>
	<4D48062E.9040405@anonymous.org.uk>
	<4D487D22.7090405@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D487D22.7090405@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Phillip Susi <psusi@cfl.rr.com>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

some hardware solutions....
change PSU
change hard disk to solid state disks (OCZ is fast, energy saver, with
high MTBF, a very good disk is OCZ VERTEX 2, REVODRIVE (pci-express)
and OCZ AGILITY 2, check read random 4kb >=3D200 MB/s is better than an=
y
SAS disk... latency is <0.1ms)

maybe changing to solid state is a good solution (cost is the point her=
e)
another point is when startup remove (hot plug) some disks, and plug af=
ter

2011/2/1 Stan Hoeppner <stan@hardwarefreak.com>:
> John Robinson put forth on 2/1/2011 7:10 AM:
>
>> That'd be an excessive amount of time to wait. A quarter of a second=
 is more
>> than enough, a tenth of a second would probably be enough. It's just=
 the motor
>> inrush current you're trying to avoid having simultaneously.
>
> The blowers in a typical 2U server chassis will have slightly more st=
artup
> current draw than the drives, assuming 5 80mm blowers and 8 2.5" driv=
es. =A0Mobos
> don't do staggered startup of blowers. =A0Thus, staggering the drive =
spin up is
> pointless. =A0Add to that the fact that most server chassis ship with=
 PSUs large
> enough to carry the current draw of anything/everything you can stuff=
 into them.
>
>> So waiting another second for your array to wake up would mean you c=
ould use a
>> sensibly-sized PSU operating in its 80%+ efficiency range, rather th=
an a huge
>> PSU operating inefficiently.
>
> A typical 2.5" 10K RPM 600GB enterprise HDD, such as the Seagate Savv=
io, has a
> startup draw of 24.1 watts combined from the 12v and 5v rails. =A0A R=
AID/JBOD
> chassis of 24 such drives, which is sold by dozens of vendors today, =
will draw
> only 578.4 watts with all drives spinning up concurrently. =A0Most su=
ch chassis on
> the market today are sold with 800w to 1800w redundant PSUs, again, m=
aking
> staggered spin up moot.
>
> --
> Stan
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

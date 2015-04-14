From: Emanuel Domingos <emanuelsdrock@gmail.com>
Subject: Re: Recovery Raid6 Degraded
Date: Tue, 14 Apr 2015 10:02:00 -0300
Message-ID: <CACsoFmi9i-cGLgigq7v8iSYdpYq9vMx_r6UyOjdyvwPNymS-sA@mail.gmail.com>
References: <CACsoFmjWW7mqSA8OKZZEPhpFidf-exSMm771ZOp0TssSYydcrw@mail.gmail.com>
	<alpine.DEB.2.02.1504132234220.16871@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1504132234220.16871@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, Mikael, hi guys!


=46ollow the errors found after building the new version of mdadm:

#mdadm --stop /dev/md/ubuntu\:md-raid6_primary

#mdadm --assemble --force /dev/md/ubuntu\:md-raid6_primary /dev/sdaa
/dev/sdac /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdz

mdadm: device /dev/md/ubuntu:md-raid6_primary exists but is not an md a=
rray.


DMESG

[661924.167503] md: md123 stopped.
[661924.167513] md: unbind<sdi>
[661924.184248] md: export_rdev(sdi)
[661924.184259] md: unbind<sdj>
[661924.184324] md: export_rdev(sdj)
[661924.184335] md: unbind<sdg>
[661924.188227] md: export_rdev(sdg)
[661924.188248] md: unbind<sdh>
[661924.192285] md: export_rdev(sdh)
[661924.192296] md: unbind<sdf>
[661924.192364] md: export_rdev(sdf)
[661924.192375] md: unbind<sdz>
[661924.264120] md: export_rdev(sdz)
[661924.264133] md: unbind<sdaa>
[661924.264456] md: export_rdev(sdaa)
[661924.264467] md: unbind<sdac>
[661924.272138] md: export_rdev(sdac)

2015-04-13 17:38 GMT-03:00 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Mon, 13 Apr 2015, Emanuel Domingos wrote:
>
>> guys, following guidelines on wiki, before to try recreate my array
>> I'm sending this mail to listen the experts.
>
>
> Good choice!
>
>> I would like to aid as a problem in my raid arrays after a crash in
>> which I had to restart the server.
>
>
> What kernel version and mdadm version are you running?
>
> My first recommendation would be for you to compile latest mdadm from
> source:
>
> "git clone https://github.com/neilbrown/mdadm"
>
> Then compile it and use that to do the --assemble-force operation tha=
t
> failed before. This has helped others.
>
> If it still doesn't work, please provide dmesg output from when that
> operation occured.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se



--=20
Emanuel Domingos

Cursando Bacharelado em Ci=C3=AAncia da Computa=C3=A7=C3=A3o - IFCE Cam=
pus Maracana=C3=BA
T=C3=A9cnico em Conectividade - IFCE Campus Maracana=C3=BA
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

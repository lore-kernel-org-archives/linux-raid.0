From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Linux software RAID assistance
Date: Fri, 18 Feb 2011 14:38:23 -0200
Message-ID: <AANLkTi=4Cco95+shR10UcV9Md-tQe56Ki5fgLaVwD4Ls@mail.gmail.com>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5BD678.2050200@gmail.com>
	<4D5BE119.7000804@turmel.org>
	<4D5C0E17.3060306@gmail.com>
	<4D5C140F.9010301@turmel.org>
	<4D5C1508.3040308@gmail.com>
	<4D5C15D3.1070608@turmel.org>
	<4D5C167C.7000101@turmel.org>
	<4D5C1CF8.1020507@gmail.com>
	<4D5C1E0B.9060300@turmel.org>
	<4D5C2061.4060106@gmail.com>
	<4D5C2143.3000907@turmel.org>
	<4D5C2260.3020800@gmail.com>
	<4D5C273E.7020609@turmel.org>
	<AANLkTi=420ttuWWG0vCWy00YLmZvGiM9JTF2n-oi2ebu@mail.gmail.com>
	<4D5E7123.5020103@turmel.org>
	<AANLkTi=Yn4wWzRR2huY0asTHB8brcgF8PCkpvtrqmQBK@mail.gmail.com>
	<4D5E7556.803@turmel.org>
	<4D5E7E52.30509@gmail.com>
	<4D5E99E7.90909@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5E99E7.90909@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: simonmcnair@gmail.com, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

dd if=3D/dev/XXX of=3D/dev/null iflag=3Ddirect
on other terminal run
iostat -d 1 -k


2011/2/18 Phil Turmel <philip@turmel.org>:
> On 02/18/2011 09:12 AM, Simon McNair wrote:
>> Phil,
>> Tell me what you want me to do and I'm game for it. =A0When I bought=
 it the reviews were not all that promising (http://www.google.co.uk/pr=
oducts/catalog?hl=3D&q=3DAOC-SASLP-MV8&cid=3D15596376504116122379&os=3D=
reviews) but I figure getting up and running is more important than sat=
a speed at the moment.
>
> I perused the cards reviewed here:
>
> http://blog.zorinaq.com/?e=3D10
>
> I was aiming for the ~$100 mark, for personal use. =A0I'd have chosen=
 the one of LSI 1068E units, but the cheaper ones are reversed boards (=
parts on opposite side of normal). =A0The Marvell 6480 was apparently t=
he next best deal. =A0I may have to rethink that.
>
> In any case, some benchmarking options:
>
> 1) Spot check with "hdparm -t /dev/sd?". =A0Not considered very accur=
ate. =A0It's read-only, though, so can run in parallel with other devic=
e activity (w/ corresponding reduced accuracy).
>
> 2) Run a packaged set of benchmarks:
> =A0 =A0 =A0 =A0http://www.coker.com.au/bonnie++/
> =A0 =A0 =A0 =A0http://www.iozone.org/
> =A0 =A0 =A0 =A0http://dbench.samba.org/
>
> 3) Script a series of basic tests of various tasks:
> =A0 =A0 =A0 =A0https://raid.wiki.kernel.org/index.php/Home_grown_test=
ing_methods
>
> Most of these tests require a writable filesystem on the target devic=
e to work in.
>
> Phil
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

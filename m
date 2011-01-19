From: Jaap Crezee <jaap@jcz.nl>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 09:29:45 +0100
Message-ID: <4D36A0F9.6040306@jcz.nl>
References: <20110118210112.D13A236C@gemini.denx.de> <4D361F26.3060507@stud.tu-ilmenau.de> <AANLkTi=v6yA_0OOfi2ymA67X0x+KsvV9VC5OgG+0DvKq@mail.gmail.com> <20110119071138.7B2D02FC@gemini.denx.de> <4D369E6D.8020604@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D369E6D.8020604@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: stefan.huebner@stud.tu-ilmenau.de
Cc: Wolfgang Denk <wd@denx.de>, Roberto Spadim <roberto@spadim.com.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/19/11 09:18, Stefan /*St0fF*/ H=FCbner wrote:
> Am 19.01.2011 08:11, schrieb Wolfgang Denk:
> Lol - I wouldn't have answered in the first place if I didn't have an=
y
> expertise.  So suit yourself - as you don't bring up any real numbers
> (remember: you've got the weird setup, you asked, you don't have enou=
gh
> money for the enterprise solution - so ...) nobody who worked with 3w=
are
> controllers will believe you.

Here's one: I switched from 3ware hardware based raid to linux software=
 raid and I am getting better=20
throughputs. I had a 3ware PCI-X car (don't know which type by hearth).
Okay, to be honest I did not have a (enterprise solution?) battery-back=
up-unit. So probably no write caching...

Jaap
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

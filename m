From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Fri, 21 Jan 2011 20:34:57 +0100
Message-ID: <20110121193457.C7719D30268@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de> <4D361F26.3060507@stud.tu-ilmenau.de> <20110119192104.1FA92D30267@gemini.denx.de> <AANLkTimY8XWxnx1MZWXp2undt9J35U8vCyuCHaSF2KkJ@mail.gmail.com> <4D37677D.9010108@stud.tu-ilmenau.de> <AANLkTi=igTEuP4+NT+RFgc=k03z_qjhSWZKp_jcH1OdR@mail.gmail.com> <AANLkTiki_FfRrLtL3dMsrDLXeT8jNO0ndnTNpXk1OXMW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTiki_FfRrLtL3dMsrDLXeT8jNO0ndnTNpXk1OXMW@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: stefan.huebner@stud.tu-ilmenau.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Roberto,

In message <AANLkTiki_FfRrLtL3dMsrDLXeT8jNO0ndnTNpXk1OXMW@mail.gmail.co=
m> you wrote:
> a good idea....
> why not start a opensource raid controller?
> what we need? a cpu, memory, power supply with battery or capacitor,
> sas/sata (disk interfaces), pci-express or another (computer
> interface)
> it don=B4t need a operational system, since it will only run one prog=
ram
> with some threads (ok a small operational system to implement threads
> easly)
>
> we could use arm, fpga, intel core2duo, atlhon, xeon, or another syst=
em...

You could evenuse a processor dedicated for such a job, like a
PPC440SPe or PPC460SX or similar, which provide hardware-offload
capabilities for the RAID calculations.  These are even supported by
drivers in mainline Linux.

But again, thee would not helpo to maximize IOPS - goal for
optimization has always been maximum sequential troughput only
(and yes, I know exactly what I'm talking about; guess where the
aforementioned drivers are coming from).

Best regards,

Wolfgang Denk

--=20
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
I don't see any direct evidence ...  but, then, my crystal ball is in
dire need of an ectoplasmic upgrade. :-)              -- Howard Smith
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

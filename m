From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Automate on-going checks?
Date: Wed, 16 Feb 2011 17:27:25 -0200
Message-ID: <AANLkTinGH-CYfSPq0qMryEJdxn0De266tj13tk+dkLat@mail.gmail.com>
References: <AANLkTikpe3vShQXcMKFW5qK3ZuzaKqnotB29vciyFUEj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikpe3vShQXcMKFW5qK3ZuzaKqnotB29vciyFUEj@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

use raid1 with spare disks or write-mostly disks increase your disks re=
dundancy

2011/2/16 Mark Knecht <markknecht@gmail.com>:
> Hi all,
>
> I'm setting up a new laptop that my dad bought as a present for my
> mom. One interesting aspect of this laptop is that it has two 500GB
> hard drives in it so I was going to use RAID1. As the laptop will be
> at a location that I won't often visit I wanted to set up some sort o=
f
> on-going daily/weekly testing of the RAID that the machine could emai=
l
> the results to me.
>
> Is there a document somewhere that goes over what mdadm (or other
> tools) provide in this area? I assume I'll use smartctl as part of th=
e
> solution but what else can I do to reduce the chances of something
> getting overlooked?
>
> Thanks,
> Mark
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

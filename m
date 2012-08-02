From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 2 Aug 2012 14:04:35 -0300
Message-ID: <CABYL=TpDU0YD4orJqyZzeYPtUJ+vBEeM=CWhFxa4GWGj8SjGMQ@mail.gmail.com>
References: <50191ADE.10809@fastmail.fm>
	<5019D052.4000409@hardwarefreak.com>
	<20120802091917.32fb0ca5@natsu>
	<501A316C.3020305@hardwarefreak.com>
	<20120802140634.6f729d07@natsu>
	<1343926790.28421.140661109896017.1A222237@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1343926790.28421.140661109896017.1A222237@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: listy@fastmail.fm
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

well i think the integrity is know, but it=B4s not fully needed since
the security isn=B4t a problem we can buy secure sata/sas
controlers/disks
the main problem will be in some days when we are using SoC systems
and we only have USB to connect a harddrive... maybe when this become
more popular we will see a development of a module to have data
integrity (silient corruption detection and maybe repair)

2012/8/2  <listy@fastmail.fm>:
> Thanks for the replies, everyone.  I didn't expect the debate on
> controller price ranges, though.  :)
>
> My main concern was not really the price of the hardware ("OMG why
> doesn't my $15 card work?!?"), but that the entire setup, hardware +
> software, allows silent data corruption to occur. It's not hard to
> imagine that something similar might happen with an $800 controller
> card, for whatever reason.  And how would the user know, unless they
> noticed bad data, or happened to look at the mismatch_cnt?
>
> (And in my case, I think that, once the weekly raid-check runs and
> updates mismatch_cnt, it's already too late, as the check process has
> potentially rewritten bad data to the drives based on the bogus reads=
=2E
> Is that correct?   My array is RAID-6, btw.)
>
> Anyway, I'm going give up on SI-based controllers for now and try a
> StarTech PEXSAT34, as the Marvell 88SE9128 is supported natively by
> the kernel's AHCI driver.
>
> Thanks,
> matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

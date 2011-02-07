From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Periodic RebuildStarted event
Date: Mon, 7 Feb 2011 21:52:34 -0200
Message-ID: <AANLkTimBTE1uutF3ZsjVTFsBn-AOSTJ8Oa=Y1dprtHxc@mail.gmail.com>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com>
	<AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
	<20110207234411.GA93362@cons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110207234411.GA93362@cons.org>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Cracauer <cracauer@cons.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i don=B4t know if exists, but maybe a internal mdadm command to check
array (if have mirrors or ecc/checksum) with a limited speed (mb/s)
read operation could help with periodic check (instead resync)

2011/2/7 Martin Cracauer <cracauer@cons.org>:
> I just got through the RebuildStarted event which seems to be
> monthly. =A0This is being triggered by my Debian config, but before I
> nuke it I'd like to know a little more.
>
> If a real disk error happens during this rebuild on a raid5, would th=
e
> disk go into regular degraded mode or would it count as a double
> fault?
>
> I also noticed that recently all the checks for all the arrays happen
> simultaneously. =A0That's bad because most of them share the same
> physical disks. =A0Am I imagining this or was the system smart enough=
 to
> do them one after another until recently?
>
> Do you do period checks? I get lots of device mismatches reported but
> apparently that's normal if there's write activity. =A0The whole thin=
g
> sound contra-productive to me and might panic new users.
>
> Martin
> --
> %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
> Martin Cracauer <cracauer@cons.org> =A0 http://www.cons.org/cracauer/
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

From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Periodic RebuildStarted event
Date: Tue, 15 Mar 2011 00:28:24 -0300
Message-ID: <AANLkTimA1_Fyh=D0BoO4vrFgqNqzjCBR9vhK04z04PQM@mail.gmail.com>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com>
	<AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
	<20110207234411.GA93362@cons.org>
	<20110208112513.2b82111c@notabene.brown>
	<AANLkTi=xz=2RG2Ob_BsCffFDki_wYcUOohB5k4YQhZ-6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=xz=2RG2Ob_BsCffFDki_wYcUOohB5k4YQhZ-6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: NeilBrown <neilb@suse.de>, Martin Cracauer <cracauer@cons.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

does mdadm have check? could it have check with a startup position?
could the mdadm report last checked position?
this could help partial checks..

2011/3/15 CoolCold <coolthecold@gmail.com>:
> Hello!
>
> On Tue, Feb 8, 2011 at 3:25 AM, NeilBrown <neilb@suse.de> wrote:
> [snip]
>> Then start either the
>> 'next' array at the beginning, or the 'current' array at the current=
 point
>> (write to sync_min).
> I couldn't find documentation for sync_min/sync_max sysfs params at
> least for repo cloned from
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.g=
it
> coolcold@coolcold:~/gits/linux-2.6.37.y$ grep -qi sync_min
> Documentation/md.txt || echo failed find docs
> failed find docs
>
> As I could understand from sources - resync_min & resync_max are
> expressed in sectors (512bytes?) =A0and are set to 0 & total sectors =
on
> device accordingly. resync_max value should be divisible by array
> chunk size (in sectors) . After setting this values, one can trugger
> "check" / "repair" into sync_action.
>
> My basic idea is to use this method to clear pending sectors from
> SMART checks and looks like this gonna work, am i right?
>
>> Then wait for however long you want, abort the check (write 'idle' t=
o
>> 'sync_action') and find out where it got up to (read sync_min) and r=
ecord
>> that for next time.
>>
>> NeilBrown
>>
>
>
> --
> Best regards,
> [COOLCOLD-RIPN]
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

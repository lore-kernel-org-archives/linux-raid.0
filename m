From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Periodic RebuildStarted event
Date: Tue, 15 Mar 2011 01:16:09 -0300
Message-ID: <AANLkTim4D1haniStFuMD4EBxQw398fpPMtK1-YJWnarM@mail.gmail.com>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com>
	<AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
	<20110207234411.GA93362@cons.org>
	<20110208112513.2b82111c@notabene.brown>
	<AANLkTi=xz=2RG2Ob_BsCffFDki_wYcUOohB5k4YQhZ-6@mail.gmail.com>
	<AANLkTimA1_Fyh=D0BoO4vrFgqNqzjCBR9vhK04z04PQM@mail.gmail.com>
	<AANLkTinfGcqm0vuHMiHDWEDnnSRf=KbjTMm0Q1o-BF4E@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinfGcqm0vuHMiHDWEDnnSRf=KbjTMm0Q1o-BF4E@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, Martin Cracauer <cracauer@cons.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hum...
could we allow start with a initial position, and stop at any time?
maybe a pause too... (set speed to 0bytes/sec)
with pause we could pause get the actual position, stop, and start
from that position later

2011/3/15 CoolCold <coolthecold@gmail.com>:
> On Tue, Mar 15, 2011 at 6:28 AM, Roberto Spadim <roberto@spadim.com.b=
r> wrote:
>> does mdadm have check? could it have check with a startup position?
>> could the mdadm report last checked position?
>> this could help partial checks..
> Testing with loop devices shows it works.
> limits are set:
> root@nekotaz2:/storage/ovzs/keke# cat /sys/block/md5/md/sync_{min,max=
}
> 500000
> 700000
>
> calling check & viewing status:
> root@nekotaz2:/storage/ovzs/keke# echo check > /sys/block/md5/md/sync=
_action
> root@nekotaz2:/storage/ovzs/keke# cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md5 : active raid1 loop1[1] loop0[0]
> =A0 =A0 =A01048512 blocks [2/2] [UU]
> =A0 =A0 =A0[=3D=3D=3D=3D>................] =A0check =3D 24.2% (254608=
/1048512)
> finish=3D5.7min speed=3D2304K/sec
>
> Here 254608 is 500000/2 =3D 250000 + some progress for delay in betwe=
en
> of "echo check" & "cat /proc/mdstat"
> In result, it stops on 350000 which is exactly 700000/2
>
> root@nekotaz2:/storage/ovzs/keke# cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md5 : active raid1 loop1[1] loop0[0]
> =A0 =A0 =A01048512 blocks [2/2] [UU]
> =A0 =A0 =A0[=3D=3D=3D=3D=3D=3D>..............] =A0check =3D 33.3% (35=
0000/1048512)
> finish=3D76.4min speed=3D151K/sec
>
> Speed & finish time are still being calculated though.
>
> Also, see Nail's message.
>
>>
>> 2011/3/15 CoolCold <coolthecold@gmail.com>:
>>> Hello!
>>>
>>> On Tue, Feb 8, 2011 at 3:25 AM, NeilBrown <neilb@suse.de> wrote:
>>> [snip]
>>>> Then start either the
>>>> 'next' array at the beginning, or the 'current' array at the curre=
nt point
>>>> (write to sync_min).
>>> I couldn't find documentation for sync_min/sync_max sysfs params at
>>> least for repo cloned from
>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y=
=2Egit
>>> coolcold@coolcold:~/gits/linux-2.6.37.y$ grep -qi sync_min
>>> Documentation/md.txt || echo failed find docs
>>> failed find docs
>>>
>>> As I could understand from sources - resync_min & resync_max are
>>> expressed in sectors (512bytes?) =A0and are set to 0 & total sector=
s on
>>> device accordingly. resync_max value should be divisible by array
>>> chunk size (in sectors) . After setting this values, one can trugge=
r
>>> "check" / "repair" into sync_action.
>>>
>>> My basic idea is to use this method to clear pending sectors from
>>> SMART checks and looks like this gonna work, am i right?
>>>
>>>> Then wait for however long you want, abort the check (write 'idle'=
 to
>>>> 'sync_action') and find out where it got up to (read sync_min) and=
 record
>>>> that for next time.
>>>>
>>>> NeilBrown
>>>>
>>>
>>>
>>> --
>>> Best regards,
>>> [COOLCOLD-RIPN]
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>>
>
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
